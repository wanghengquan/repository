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
import gui_interface.view_data;
import info_parser.xml_parser;
import utility_funcs.file_action;
import utility_funcs.system_cmd;
import utility_funcs.time_info;

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
	private view_data view_info;
	private rmq_tube rmq_runner;
	@SuppressWarnings("unused")
	private switch_data switch_info;
	private String line_seprator = System.getProperty("line.separator");
	private String file_seprator = System.getProperty("file.separator");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;
	// public function
	// protected function
	// private function

	public result_waiter(switch_data switch_info, client_data client_info, pool_data pool_info, task_data task_info,
			view_data view_info) {
		this.pool_info = pool_info;
		this.task_info = task_info;
		this.client_info = client_info;
		this.switch_info = switch_info;
		this.view_info = view_info;
		this.rmq_runner = new rmq_tube(task_info); // should be remove later
	}

	// since only this thread will remove the finished call, so not slipped
	// condition will happen
	/*
	 * call status map: {case_id@queue_name:{"call_back":call_back,
	 * "queue_name":queue_name, "case_id":case_id, "case_dir":case_dir,
	 * "start_time":start_time, "time_out":time_out, "cmd_output":cmd_output,
	 * "call_status": call_status //new added: done, timeout, processing } }
	 */
	@SuppressWarnings("unchecked")
	private Boolean run_post_process(HashMap<String, HashMap<String, Object>> call_status_map,
			HashMap<String, HashMap<String, String>> case_report_map) {
		Boolean run_status = new Boolean(true);
		Iterator<String> call_map_it = call_status_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_status_map.get(call_index);
			ArrayList<String> cmd_output_list = new ArrayList<String>();
			String call_status = (String) one_call_data.get("call_status");
			// only done call will be release. timeout call will be get in
			// the next cycle(at that time status will be done)
			if (!call_status.equals("done")) {
				continue;
			}
			String case_work_path = (String) one_call_data.get("case_dir");
			cmd_output_list = (ArrayList<String>) one_call_data.get("cmd_output");
			String cmd_status = case_report_map.get(call_index).get("status");
			String prj_dir_name = "prj" + case_report_map.get(call_index).get("projectId");
			String run_dir_name = "run" + case_report_map.get(call_index).get("runId");
			String tmp_result_dir = public_data.WORKSPACE_RESULT_DIR;
			String save_path = client_info.get_client_data().get("preference").get("save_path");
			String[] path_array = new String[] { save_path, tmp_result_dir, prj_dir_name, run_dir_name };
			String case_save_path = String.join(file_seprator, path_array);
			case_save_path = case_save_path.replaceAll("\\\\", "/");
			// public data for every case end
			// task 0 : case local report generate
			String local_case_report = case_work_path + "/" + public_data.WORKSPACE_CASE_REPORT_NAME;
			file_action.append_file(local_case_report, line_seprator + "[Run]" + line_seprator);
			file_action.append_file(local_case_report, String.join(line_seprator, cmd_output_list));
			// task 1 : final running process clean up
			run_status = final_cleanup(case_work_path);
			// task 2 : zip case to save path
			if (cmd_status.equalsIgnoreCase("failed")) {
				run_status = copy_case_to_save_path(case_work_path, case_save_path, "source");
			} else {
				run_status = copy_case_to_save_path(case_work_path, case_save_path, "archive");
			}
		}
		return run_status;
	}

	private Boolean dump_finished_data(HashMap<String, HashMap<String, Object>> call_status_map) {
		Boolean dump_status = new Boolean(true);
		ArrayList<String> running_queue_in_pool = new ArrayList<String>();
		Iterator<String> call_map_it = call_status_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_status_map.get(call_index);
			String queue_name = (String) one_call_data.get("queue_name");
			running_queue_in_pool.add(queue_name);
		}
		// task 3 : dump finished task queue data to xml file, save memory
		ArrayList<String> finished_admin_queue_list = task_info.get_finished_admin_queue_list();
		for (String dump_queue : finished_admin_queue_list) {
			if (running_queue_in_pool.contains(dump_queue)) {
				continue;// queue not finished
			}
			if (view_info.get_watching_queue().equalsIgnoreCase(dump_queue)) {
				continue;// queue in GUI watching
			}
			if (!task_info.get_processed_task_queues_map().containsKey(dump_queue)) {
				continue;// no queue data to dump (already dumped)
			}
			if (task_info.get_processed_task_queues_map().get(dump_queue).size() < 10) {
				continue;// no need to dump to increase the performance > don't
							// forget dump when shutdown client
			}
			// dumping task queue
			dump_admin_data(dump_queue);
			dump_task_data(dump_queue);
		}
		return dump_status;
	}

	private Boolean dump_admin_data(String queue_name) {
		Boolean dump_status = new Boolean(true);
		HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
		if (task_info.get_received_admin_queues_treemap().containsKey(queue_name)) {
			admin_data.putAll(task_info.get_queue_data_from_received_admin_queues_treemap(queue_name));
		} else {
			return dump_status;
		}
		String work_path = client_info.get_client_data().get("preference").get("work_path");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_path = work_path + "/" + log_folder + "/finished/admin";
		File dump_dobj = new File(dump_path);
		if (dump_dobj.exists() && dump_dobj.isDirectory()) {
			RESULT_WAITER_LOGGER.debug("dump folder exists.");
		} else {
			// create new case path if not have
			try {
				FileUtils.forceMkdir(dump_dobj);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				RESULT_WAITER_LOGGER.warn("Make log folder failed.");
				e.printStackTrace();
				dump_status = false;
			}
		}
		String file_name = queue_name + ".xml";
		String dump_file = dump_path + "/" + file_name;
		xml_parser parser = new xml_parser();
		try {
			dump_status = parser.dump_finished_admin_data(admin_data, queue_name, dump_file.replaceAll("\\\\", "/"));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			RESULT_WAITER_LOGGER.warn("dump finished queue failed:" + queue_name);
			dump_status = false;
		}
		return dump_status;
	}

	private Boolean dump_task_data(String queue_name) {
		Boolean dump_status = new Boolean(true);
		TreeMap<String, HashMap<String, HashMap<String, String>>> task_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		if (task_info.get_processed_task_queues_map().containsKey(queue_name)) {
			task_data.putAll(task_info.get_queue_from_processed_task_queues_map(queue_name));
		} else {
			return dump_status;
		}
		String work_path = client_info.get_client_data().get("preference").get("work_path");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_path = work_path + "/" + log_folder + "/finished/task";
		File dump_dobj = new File(dump_path);
		if (dump_dobj.exists() && dump_dobj.isDirectory()) {
			RESULT_WAITER_LOGGER.debug("dump folder exists.");
		} else {
			// create new case path if not have
			try {
				FileUtils.forceMkdir(dump_dobj);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				RESULT_WAITER_LOGGER.warn("Make log folder failed.");
				e.printStackTrace();
				dump_status = false;
			}
		}
		String file_name = queue_name + ".xml";
		String dump_file = dump_path + "/" + file_name;
		xml_parser parser = new xml_parser();
		try {
			dump_status = parser.dump_finished_task_data(task_data, queue_name, dump_file.replaceAll("\\\\", "/"));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			RESULT_WAITER_LOGGER.warn("dump finished queue failed:" + queue_name);
			dump_status = false;
		}
		return dump_status;
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
					.get_case_from_processed_task_queues_map(queue_name, case_id);
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
		Boolean update_status = new Boolean(true);
		Iterator<String> call_map_it = call_status_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			String queue_name = (String) call_status_map.get(call_index).get("queue_name");
			String case_id = (String) call_status_map.get(call_index).get("case_id");
			HashMap<String, HashMap<String, String>> case_data = task_info
					.get_case_from_processed_task_queues_map(queue_name, case_id);
			HashMap<String, String> case_status = case_data.get("Status");
			case_status.put("cmd_status", case_report_map.get(call_index).get("status"));
			case_status.put("cmd_reason", case_report_map.get(call_index).get("reason"));
			case_status.put("location", case_report_map.get(call_index).get("location"));
			case_status.put("run_time", time_info.get_man_date_time());
			case_data.put("Status", case_status);
			task_info.update_case_to_processed_task_queues_map(queue_name, case_id, case_data);
		}
		return update_status;
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
			report_status = rmq_runner.exchange_send(public_data.RMQ_RUNTIME_NAME, rmq_runtime_str);
		}
		if (local_data.size() > 0) {
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
					.get_case_from_processed_task_queues_map(queue_name, case_id);
			hash_data.put("testId", task_data.get("ID").get("id"));
			hash_data.put("suiteId", task_data.get("ID").get("suite"));
			hash_data.put("runId", task_data.get("ID").get("run"));
			hash_data.put("projectId", task_data.get("ID").get("project"));
			StringBuilder runlog = new StringBuilder();
			runlog.append(":" + line_seprator);
			runlog.append("####################" + line_seprator);
			String host_name = client_info.get_client_data().get("Machine").get("terminal");
			String work_path = (String) one_call_data.get("case_dir");
			runlog.append("Result Location ==> " + host_name + ":" + work_path + line_seprator);
			runlog.append(line_seprator);
			runlog.append(line_seprator);
			ArrayList<String> runtime_output_list = (ArrayList<String>) one_call_data.get("cmd_output");
			runlog.append(String.join(line_seprator, runtime_output_list));
			runlog.append(line_seprator);
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
			report_status = rmq_runner.basic_send(public_data.RMQ_RESULT_NAME, rmq_result_str);
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
					.get_case_from_processed_task_queues_map(queue_name, case_id);
			hash_data.put("testId", task_data.get("ID").get("id"));
			hash_data.put("suiteId", task_data.get("ID").get("suite"));
			hash_data.put("runId", task_data.get("ID").get("run"));
			hash_data.put("projectId", task_data.get("ID").get("project"));
			hash_data.put("design", task_data.get("CaseInfo").get("design_name"));
			String cmd_status = new String("NA");
			String cmd_reason = new String("NA");
			HashMap<String, String> detail_report = new HashMap<String, String>();
			if (call_status.equals("done")) {
				cmd_status = get_cmd_status((ArrayList<String>) one_call_data.get("cmd_output"));
				cmd_reason = get_cmd_reason((ArrayList<String>) one_call_data.get("cmd_output"));
				detail_report.putAll(get_detail_report((ArrayList<String>) one_call_data.get("cmd_output")));
			} else if (call_status.equals("timeout")) {
				cmd_status = "Timeout";
				cmd_reason = "Timeout";
			} else {
				cmd_status = "Processing";
			}
			hash_data.putAll(detail_report);
			hash_data.put("status", cmd_status);
			hash_data.put("reason", cmd_reason);
			// String host_name =
			// client_info.get_client_data().get("Machine").get("terminal");
			String work_path = (String) one_call_data.get("case_dir");
			hash_data.put("location", work_path);
			case_data.put(call_index, hash_data);
		}
		return case_data;
	}

	private HashMap<String, String> get_detail_report(ArrayList<String> cmd_output) {
		HashMap<String, String> report_data = new HashMap<String, String>();
		for (String line : cmd_output) {
			// <status>Passed</status>
			Pattern p = Pattern.compile("<(.+?)>(.+?)</");
			Matcher m = p.matcher(line);
			if (m.find()) {
				report_data.put(m.group(1), m.group(2));
			}
		}
		return report_data;
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
		String reason = new String("NA");
		for (String line : cmd_output) {
			if (!line.contains("<reason>")) {
				continue;
			}
			// <status>Passed</status>
			Pattern p = Pattern.compile("reason>(.+?)</");
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
		Iterator<String> system_call_map_it = system_call_map.keySet().iterator();
		while (system_call_map_it.hasNext()) {
			String call_index = system_call_map_it.next();
			HashMap<String, Object> hash_data = new HashMap<String, Object>();
			hash_data.putAll(system_call_map.get(call_index));
			// put call_status
			Future<?> call_back = (Future<?>) hash_data.get("call_back");
			Boolean call_done = call_back.isDone();
			long current_time = System.currentTimeMillis() / 1000;
			long start_time = (long) hash_data.get("start_time");
			int time_out = (int) hash_data.get("time_out");
			// run report action
			if (call_done) {
				hash_data.put("call_status", "done");
				try {
					hash_data.put("cmd_output", call_back.get(10, TimeUnit.SECONDS));
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

	public Boolean copy_case_to_save_path(String case_dir, String save_path, String copy_type) {
		Boolean copy_status = new Boolean(true);
		File save_path_fobj = new File(save_path);
		if (!save_path_fobj.exists()) {
			try {
				FileUtils.forceMkdir(save_path_fobj);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
				RESULT_WAITER_LOGGER.warn("Case remote save path create failed, Skip post run process");
				copy_status = false;
				return copy_status;
			}
		}
		if (!save_path_fobj.canWrite()) {
			RESULT_WAITER_LOGGER.warn("Case remote save path not writeable, Skip post run process");
			copy_status = false;
			return copy_status;
		}
		File case_path_obj = new File(case_dir);
		String case_folder_name = case_path_obj.getName();
		// String case_parent_path =
		// case_path_obj.getParent().replaceAll("\\\\", "/");
		File save_dest_folder = new File(save_path, case_folder_name);
		File save_dest_file = new File(save_path, case_folder_name + ".zip");
		if (!save_path_fobj.exists()) {
			save_path_fobj.mkdirs();
			save_path_fobj.setWritable(true, false);
		}
		if (copy_type.equals("source")) {
			try {
				FileUtils.copyDirectory(case_path_obj, save_dest_folder);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
				RESULT_WAITER_LOGGER.warn("Copy source case failed, Skip this case");
				copy_status = false;
			}
		} else if (copy_type.equals("archive")) {
			file_action.zipFolder(case_path_obj.getAbsolutePath().toString().replaceAll("\\\\", "/"),
					save_dest_file.toString());
			copy_status = true;
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
		String waiter_name = "RW_0";
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
				RESULT_WAITER_LOGGER.debug(waiter_name + ":Thread running...");
			}
			// take a rest
			try {
				Thread.sleep(base_interval * 2 * 1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			// ============== All dynamic job start from here ==============
			// use call_status and case_report_data for all tasks
			HashMap<String, HashMap<String, Object>> call_status = new HashMap<String, HashMap<String, Object>>();
			// task 1 : get call map status
			call_status = get_call_status_map();
			if (call_status.size() < 1) {
				RESULT_WAITER_LOGGER.warn(waiter_name + ":Thread Pool Empty...");
				continue;
			}
			// task 2 : cancel timeout call
			Boolean cancel_status = cancel_timeout_call(call_status);
			System.out.println(">>>>>>>>>>>>>>>>testing result waiter line670");
			System.out.println(call_status.toString());
			// task 3 : general case report
			HashMap<String, HashMap<String, String>> case_report_data = generate_case_report_data(call_status);
			Boolean send_case_status = send_case_report(case_report_data);
			// task 4 : detail case runtime log report
			HashMap<String, HashMap<String, String>> case_runtime_log_data = generate_case_runtime_log_data(
					call_status);
			Boolean send_runtime_status = send_runtime_report(case_runtime_log_data);
			// task 5 : update processed task data info
			Boolean update_task_data_status = update_processed_task_data(call_status, case_report_data);
			// task 6 : release occupied pool thread
			Boolean release_pool_thread_status = release_pool_thread(call_status);
			// task 7 : release occupied resource usage
			Boolean release_resource_status = release_resource_usage(call_status);
			// task 8 : post process
			Boolean post_status = run_post_process(call_status, case_report_data);
			// task 9 : dump finished queue
			Boolean dump_status = dump_finished_data(call_status);
			if (cancel_status && send_case_status && send_runtime_status && update_task_data_status
					&& release_pool_thread_status && release_resource_status && post_status && dump_status) {
				RESULT_WAITER_LOGGER.debug(waiter_name + ": work fine.");
			} else {
				RESULT_WAITER_LOGGER.warn(waiter_name + ": Get some warning process. please check.");
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