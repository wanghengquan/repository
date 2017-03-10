/*
 * File: cmd_parser.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package flow_control;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;
import java.util.TreeMap;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.io.FileUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.rmq_tube;
import connect_tube.task_data;
import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;
import info_parser.xml_parser;
import utility_funcs.file_action;
import utility_funcs.system_cmd;

public class result_waiter extends Thread {
	// public property
	// protected property
	// private property
	private static final Logger RESULT_WAITER_LOGGER = LogManager.getLogger(result_waiter.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread result_thread;
	private pool_data pool_info;
	private client_data client_info;
	private task_data task_info;
	private switch_data switch_info;
	private String line_seprator = System.getProperty("line.separator");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;
	// public function
	// protected function
	// private function

	public result_waiter(switch_data switch_info, client_data client_info, pool_data pool_info, task_data task_info) {
		this.pool_info = pool_info;
		this.task_info = task_info;
		this.client_info = client_info;
		this.switch_info = switch_info;
	}

	// since only this thread will remove the finished call, so not slipped
	// condition will happen
	/*
	 * call status map: {case_id@queue_name:{"call_back":call_back,
	 * "queue_name":queue_name, "case_id":case_id, "case_dir":case_dir,
	 * "start_time":start_time, "time_out":time_out, "cmd_output":cmd_output,
	 * "call_status": call_status //new added: done, timeout, processing } }
	 */
	private Boolean run_post_process(HashMap<String, HashMap<String, Object>> call_status_map,
			HashMap<String, HashMap<String, String>> case_report_map) {
		Boolean run_status = new Boolean(true);
		ArrayList<String> running_queue_in_pool = new ArrayList<String>();
		Iterator<String> call_map_it = call_status_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_status_map.get(call_index);
			String call_status = (String) one_call_data.get("call_status");
			// only done call will be release. timeout call will be get in
			// the next cycle(at that time status will be done)
			if (!call_status.equals("done")) {
				continue;
			}
			String queue_name = (String) call_status_map.get(call_index).get("queue_name");
			String work_dir = (String) call_status_map.get(call_index).get("case_dir");
			String cmd_status = case_report_map.get(call_index).get("status");
			running_queue_in_pool.add(queue_name);
			// task 1 : final running process clean up
			run_status = final_cleanup(work_dir);
			// task 2 : zip case to save path
			if (cmd_status.equalsIgnoreCase("failed")) {
				run_status = copy_case_to_save_path(work_dir, "source");
			} else {
				run_status = copy_case_to_save_path(work_dir, "archive");
			}
		}
		// task 3 : dump finished task queue data to xml file, save memory
		ArrayList<String> finished_queue_list = task_info.get_finished_admin_queue_list();
		String[] dumped_queue_list = get_dumped_admin_queue_list();
		for (String finished_queue : finished_queue_list) {
			if (running_queue_in_pool.contains(finished_queue)) {
				continue;// queue not finished
			}
			if (dumped_queue_list.toString().contains(finished_queue)) {
				continue;// queue dumped already
			}
			String work_path = client_info.get_client_data().get("base").get("work_path");
			String log_folder = public_data.WORKSPACE_LOG_DIR;
			String file_name = finished_queue + ".xml";
			String dump_path = work_path + log_folder + file_name;
			TreeMap<String, HashMap<String, HashMap<String, String>>> task_queue_data = task_info
					.get_queue_from_processed_task_queues_data_map(finished_queue);
			xml_parser parser = new xml_parser();
			try {
				run_status = parser.dump_finished_queue_data(task_queue_data, finished_queue, dump_path);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
				RESULT_WAITER_LOGGER.warn("dump finished queue failed:" + finished_queue);
				run_status = false;
			}
		}
		return run_status;
	}

	private String[] get_dumped_admin_queue_list() {
		String work_path = client_info.get_client_data().get("base").get("work_path");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		File log_path = new File(work_path + log_folder);
		String[] queue_file_list = log_path.list();
		return queue_file_list;
	}

	private Boolean release_resource_usage(HashMap<String, HashMap<String, Object>> call_status_map) {
		Boolean release_status = new Boolean(true);
		Iterator<String> call_map_it = call_status_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_status_map.get(call_index);
			String call_status = (String) one_call_data.get("call_status");
			// only done call will be release. timeout call will be get in
			// the next cycle(at that time status will be done)
			if (!call_status.equals("done")) {
				continue;
			}
			String queue_name = (String) call_status_map.get(call_index).get("queue_name");
			String case_id = (String) call_status_map.get(call_index).get("case_id");
			HashMap<String, HashMap<String, String>> case_data = task_info
					.get_case_from_processed_task_queues_data_map(queue_name, case_id);
			HashMap<String, String> software_cost = case_data.get("Software");
			release_status = client_info.release_use_soft_insts(software_cost);
		}
		return release_status;
	}

	private Boolean release_pool_thread(HashMap<String, HashMap<String, Object>> call_status_map) {
		Boolean release_status = new Boolean(true);
		Iterator<String> call_map_it = call_status_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_status_map.get(call_index);
			String call_status = (String) one_call_data.get("call_status");
			// only done call have runtime results. timeout call will be get in
			// the next cycle(at that time status will be done)
			if (!call_status.equals("done")) {
				continue;
			}
			// update call map in ThreadPool
			release_status = pool_info.remove_sys_call(call_index);
			// update used thread in ThreadPool
			release_status = pool_info.release_used_thread(1);
		}
		return release_status;
	}

	private Boolean update_processed_task_data(HashMap<String, HashMap<String, Object>> call_status_map,
			HashMap<String, HashMap<String, String>> case_report_map) {
		Boolean release_status = new Boolean(true);
		Iterator<String> call_map_it = call_status_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_status_map.get(call_index);
			String call_status = (String) one_call_data.get("call_status");
			// only done call will be release. timeout call will be get in
			// the next cycle(at that time status will be done)
			if (call_status.equals("processing")) {
				continue;
			}
			String queue_name = (String) call_status_map.get(call_index).get("queue_name");
			String case_id = (String) call_status_map.get(call_index).get("case_id");
			HashMap<String, HashMap<String, String>> case_data = task_info
					.get_case_from_processed_task_queues_data_map(queue_name, case_id);
			HashMap<String, String> case_status = case_data.get("Status");
			case_status.put("cmd_status", case_report_map.get(call_index).get("status"));
			case_status.put("cmd_reason", case_report_map.get(call_index).get("reason"));
			case_status.put("location", case_report_map.get(call_index).get("location"));
			case_data.put("Status", case_status);
			task_info.update_case_to_processed_task_queues_data_map(queue_name, case_id, case_data);
		}
		return release_status;
	}

	private Boolean send_runtime_report(HashMap<String, HashMap<String, String>> runtime_log_data) {
		Boolean report_status = new Boolean(true);
		xml_parser parser = new xml_parser();
		// get remote date
		HashMap<String, HashMap<String, String>> remote_data = new HashMap<String, HashMap<String, String>>();
		// get local data
		HashMap<String, HashMap<String, String>> local_data = new HashMap<String, HashMap<String, String>>();
		Iterator<String> report_data_it = runtime_log_data.keySet().iterator();
		while (report_data_it.hasNext()) {
			String call_index = report_data_it.next();
			if (call_index.contains("0@")) { // 0@ local queue
				local_data.put(call_index, runtime_log_data.get(call_index));
			} else {
				remote_data.put(call_index, runtime_log_data.get(call_index));
			}
		}

		if (remote_data.size() > 0) {
			// remote send
			String rmq_runtime_str = parser.create_runtime_document_string(remote_data);
			report_status = rmq_tube.exchange_send(public_data.RMQ_RUNTIME_NAME, rmq_runtime_str);
		} 
		if (local_data.size() > 0){
			// local send
			;
		}
		return report_status;
	}

	@SuppressWarnings("unchecked")
	private HashMap<String, HashMap<String, String>> generate_case_runtime_log_data(
			HashMap<String, HashMap<String, Object>> call_status_map) {
		HashMap<String, HashMap<String, String>> runtime_data = new HashMap<String, HashMap<String, String>>();
		Iterator<String> call_map_it = call_status_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_status_map.get(call_index);
			String call_status = (String) one_call_data.get("call_status");
			// only done call have runtime results. timeout call will be get in
			// the next cycle(at that time status will be done)
			if (!call_status.equals("done")) {
				continue;
			}
			HashMap<String, String> hash_data = new HashMap<String, String>();
			// call_index format case_id@queue_name
			String queue_name = call_index.split("#")[1];
			String case_id = call_index.split("#")[0];
			HashMap<String, HashMap<String, String>> task_data = task_info
					.get_case_from_processed_task_queues_data_map(queue_name, case_id);
			hash_data.put("testId", task_data.get("ID").get("id"));
			hash_data.put("suiteId", task_data.get("ID").get("suite"));
			hash_data.put("runId", task_data.get("ID").get("run"));
			hash_data.put("projectId", task_data.get("ID").get("project"));
			StringBuilder runlog = new StringBuilder();
			runlog.append("####################" + line_seprator);
			String host_name = client_info.get_client_data().get("Machine").get("terminal");
			String work_path = (String) one_call_data.get("case_dir");
			runlog.append("Result Location ==> " + host_name + ":" + work_path + line_seprator);
			ArrayList<String> runtime_output_list = (ArrayList<String>) one_call_data.get("cmd_output");
			runlog.append(runtime_output_list.toString());
			String runlog_str = runlog.toString();
			hash_data.put("runLog", remove_xml_modifier(runlog_str));
			runtime_data.put(call_index, hash_data);
		}
		return runtime_data;
	}

	private String remove_xml_modifier(String xml_string) {
		xml_string = xml_string.replaceAll("\"", "&quot;");
		xml_string = xml_string.replaceAll("&", "&amp;");
		xml_string = xml_string.replaceAll("<", "&lt;");
		xml_string = xml_string.replaceAll(">", "&gt;");
		return xml_string;
	}

	private Boolean send_case_report(HashMap<String, HashMap<String, String>> case_report_data) {
		Boolean report_status = new Boolean(true);
		xml_parser parser = new xml_parser();
		String ip = client_info.get_client_data().get("Machine").get("ip");
		String terminal = client_info.get_client_data().get("Machine").get("terminal");
		// get remote date
		HashMap<String, HashMap<String, String>> remote_data = new HashMap<String, HashMap<String, String>>();
		// get local data
		HashMap<String, HashMap<String, String>> local_data = new HashMap<String, HashMap<String, String>>();
		Iterator<String> report_data_it = case_report_data.keySet().iterator();
		while (report_data_it.hasNext()) {
			String call_index = report_data_it.next();
			if (call_index.contains("0@")) { // 0@ local queue
				local_data.put(call_index, case_report_data.get(call_index));
			} else {
				remote_data.put(call_index, case_report_data.get(call_index));
			}
		}

		if (remote_data.size() > 0) {
			// remote send
			String rmq_result_str = parser.create_result_document_string(remote_data, ip, terminal);
			report_status = rmq_tube.basic_send(public_data.RMQ_RESULT_NAME, rmq_result_str);
		} 
		if (local_data.size() > 0) {
			// local send
			;
		}
		return report_status;
	}

	@SuppressWarnings("unchecked")
	private HashMap<String, HashMap<String, String>> generate_case_report_data(
			HashMap<String, HashMap<String, Object>> call_status_map) {
		HashMap<String, HashMap<String, String>> case_data = new HashMap<String, HashMap<String, String>>();
		Iterator<String> call_map_it = call_status_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_status_map.get(call_index);
			String call_status = (String) one_call_data.get("call_status");
			HashMap<String, String> hash_data = new HashMap<String, String>();
			String queue_name = call_index.split("#")[1];
			String case_id = call_index.split("#")[0];
			HashMap<String, HashMap<String, String>> task_data = task_info
					.get_case_from_processed_task_queues_data_map(queue_name, case_id);
			hash_data.put("testId", task_data.get("ID").get("id"));
			hash_data.put("suiteId", task_data.get("ID").get("suite"));
			hash_data.put("runId", task_data.get("ID").get("run"));
			hash_data.put("projectId", task_data.get("ID").get("project"));
			hash_data.put("design", task_data.get("CaseInfo").get("design_name"));
			String cmd_status = new String("");
			String cmd_reason = new String("");
			if (call_status.equals("done")) {
				cmd_status = get_cmd_status((ArrayList<String>) one_call_data.get("cmd_output"));
				cmd_reason = get_cmd_reason((ArrayList<String>) one_call_data.get("cmd_output"));
			} else if (call_status.equals("timeout")) {
				cmd_status = "Timeout"; // match output
				cmd_reason = "Timeout";
			} else {
				cmd_status = "Processing"; // match output
			}
			hash_data.put("status", cmd_status);
			hash_data.put("reason", cmd_reason);
			String host_name = client_info.get_client_data().get("Machine").get("terminal");
			String work_path = (String) one_call_data.get("case_dir");
			hash_data.put("location", host_name + ":" + work_path);
			case_data.put(call_index, hash_data);
		}
		return case_data;
	}

	private String get_cmd_status(ArrayList<String> cmd_output) {
		String status = new String();
		for (String line : cmd_output) {
			if (!line.contains("<status>")) {
				continue;
			}
			// <status>Passed</status>
			Pattern p = Pattern.compile("status>(.+?)</");
			Matcher m = p.matcher(line);
			if (m.find()) {
				status = m.group(1);
			}
		}
		return status;
	}

	private String get_cmd_reason(ArrayList<String> cmd_output) {
		String reason = new String();
		for (String line : cmd_output) {
			if (!line.contains("<reason>")) {
				continue;
			}
			// <status>Passed</status>
			Pattern p = Pattern.compile("reason>(\\.+?)</");
			Matcher m = p.matcher(line);
			if (m.find()) {
				reason = m.group(1);
			}
		}
		return reason;
	}

	private Boolean cancel_timeout_call(HashMap<String, HashMap<String, Object>> call_status_map) {
		Boolean cancel_status = new Boolean(true);
		Iterator<String> call_map_it = call_status_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			String call_status = (String) call_status_map.get(call_index).get("call_status");
			if (!call_status.equals("timeout")) {
				continue;
			}
			Future<?> call_back = (Future<?>) call_status_map.get(call_index).get("call_back");
			cancel_status = call_back.cancel(true);
		}
		return cancel_status;
	}

	/*
	 * call status map: {case_id@queue_name:{"call_back":call_back,
	 * "queue_name":queue_name, "case_id":case_id, "case_dir":case_dir,
	 * "start_time":start_time, "time_out":time_out, "cmd_output":cmd_output,
	 * "call_status": call_status //new added: done, timeout, processing } }
	 */
	private HashMap<String, HashMap<String, Object>> get_call_status_map() {
		HashMap<String, HashMap<String, Object>> return_call_map = new HashMap<String, HashMap<String, Object>>();
		// scan calls update return_call_map with call_status, cmd_status,
		// cmd_output
		HashMap<String, HashMap<String, Object>> system_call_map = pool_info.get_sys_call();
		Set<String> system_call_map_set = system_call_map.keySet();
		Iterator<String> system_call_map_it = system_call_map_set.iterator();
		while (system_call_map_it.hasNext()) {
			String call_index = system_call_map_it.next();
			HashMap<String, Object> hash_data = new HashMap<String, Object>();
			HashMap<String, Object> call_ori_data = system_call_map.get(call_index);
			hash_data.putAll(call_ori_data);
			// put call_status
			Future<?> call_back = (Future<?>) system_call_map.get(call_index).get("call_back");
			Boolean call_done = call_back.isDone();
			long current_time = System.currentTimeMillis() / 1000;
			long start_time = (long) system_call_map.get(call_index).get("start_time");
			int time_out = (int) system_call_map.get(call_index).get("time_out");
			// run report action
			if (call_done) {
				hash_data.put("call_status", "done");
				try {
					hash_data.put("cmd_output", call_back.get(time_out, TimeUnit.SECONDS));
				} catch (InterruptedException | ExecutionException | TimeoutException e) {
					// e.printStackTrace();
					RESULT_WAITER_LOGGER.warn("Get call result exception.");
					hash_data.put("cmd_output", "");
				}
			} else if (current_time - start_time > time_out + 5) {
				hash_data.put("call_status", "timeout");
			} else {
				hash_data.put("call_status", "processing");
			}
			return_call_map.put(call_index, hash_data);
		}
		return return_call_map;
	}

	public static Boolean final_cleanup(String clean_work_path) {
		String cmd = "python " + public_data.TOOLS_KILL_PROCESS + " " + clean_work_path;
		ArrayList<String> excute_retruns = new ArrayList<String>();
		try {
			excute_retruns = system_cmd.run(cmd);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
		Boolean finish_clean = false;
		for (String line : excute_retruns) {
			if (line.equalsIgnoreCase("Scan_finished")) {
				finish_clean = true;
				break;
			}
		}
		if (finish_clean) {
			return true;
		} else {
			return false;
		}
	}

	public Boolean copy_case_to_save_path(String case_dir, String copy_type) {
		Boolean copy_status = new Boolean(true);
		String save_path = client_info.client_hash.get("base").get("save_path");
		File save_path_fobj = new File(save_path);
		if (!save_path_fobj.exists()) {
			RESULT_WAITER_LOGGER.warn("Client save path not exists, Skip post run process");
			copy_status = false;
			return copy_status;
		}
		File case_path_obj = new File(case_dir);
		String case_folder_name = case_path_obj.getName();
		String case_parent_path = case_path_obj.getParent();
		File save_parent_dir = new File(save_path, case_parent_path);
		File save_dest_path = new File(save_parent_dir.toString(), case_folder_name);
		File save_dest_file = new File(save_parent_dir.toString(), case_folder_name + ".zip");
		if (!save_parent_dir.exists()) {
			save_parent_dir.mkdirs();
			save_parent_dir.setWritable(true, false);
		}
		if (copy_type.equals("source")) {
			try {
				FileUtils.copyDirectory(case_path_obj, save_dest_path);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
				RESULT_WAITER_LOGGER.warn("Copy source case failed, Skip this case");
				copy_status = false;
			}
		} else if (copy_type.equals("archive")) {
			file_action.zipFolder(case_path_obj.getAbsolutePath().toString().replaceAll("\\\\", "/"),
					save_dest_file.toString());
			copy_status = false;
		} else {
			RESULT_WAITER_LOGGER.warn("Wrong copy type given, skip");
			copy_status = false;
		}
		return copy_status;
	}

	public void run() {
		try {
			monitor_run();
		} catch (Exception run_exception) {
			run_exception.printStackTrace();
			System.exit(1);
		}
	}

	private void monitor_run() {
		// ============== All static job start from here ==============
		result_thread = Thread.currentThread();
		while (!stop_request) {
			if (wait_request) {
				try {
					synchronized (this) {
						this.wait();
					}
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} else {
				RESULT_WAITER_LOGGER.debug("Client Thread running...");
			}
			try {
				Thread.sleep(base_interval * 1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}			
			// ============== All dynamic job start from here ==============
			HashMap<String, HashMap<String, Object>> call_status = new HashMap<String, HashMap<String, Object>>();
			// task 1 : get call map status
			call_status = get_call_status_map();
			if (call_status.size() < 1) {
				continue;
			}
			// task 2 : cancel timeout call
			Boolean cancel_status = cancel_timeout_call(call_status);
			// task 3 : generate case general data
			HashMap<String, HashMap<String, String>> case_report_data = generate_case_report_data(call_status);
			// task 4 : send case report data
			Boolean send_case_status = send_case_report(case_report_data);
			// task 5 : generate case runtime log data
			HashMap<String, HashMap<String, String>> case_runtime_log_data = generate_case_runtime_log_data(
					call_status);
			// task 6 : send case runtime log data
			Boolean send_runtime_status = send_runtime_report(case_runtime_log_data);
			// task 7 : update processed task data info
			Boolean update_task_data_status = update_processed_task_data(call_status, case_report_data);
			// task 8 : release occupied pool thread
			Boolean release_pool_thread_status = release_pool_thread(call_status);
			// task 9 : release occupied resource usage
			Boolean release_resource_status = release_resource_usage(call_status);
			// task 10 : post process
			Boolean post_status = run_post_process(call_status, case_report_data);
			if (cancel_status && send_case_status && send_runtime_status && update_task_data_status
					&& release_pool_thread_status && release_resource_status && post_status) {
				RESULT_WAITER_LOGGER.debug("Result waiter work fine.");
			} else {
				RESULT_WAITER_LOGGER.warn("Result waiter get some warning process. please check.");
			}
			try {
				Thread.sleep(base_interval * 1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public void soft_stop() {
		stop_request = true;
	}

	public void hard_stop() {
		stop_request = true;
		if (result_thread != null) {
			result_thread.interrupt();
		}
	}

	public void wait_request() {
		wait_request = true;
	}

	public void wake_request() {
		wait_request = false;
		synchronized (this) {
			this.notify();
		}
	}

	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		//
	}
}