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
import java.util.List;
import java.util.concurrent.CancellationException;
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
import data_center.exit_enum;
import data_center.public_data;
import data_center.switch_data;
import gui_interface.view_data;
import info_parser.xml_parser;
import utility_funcs.deep_clone;
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
	private switch_data switch_info;
	private String line_separator = System.getProperty("line.separator");
	private String file_separator = System.getProperty("file.separator");
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
			HashMap<String, HashMap<String, Object>> case_report_map) {
		Boolean run_status = new Boolean(true);
		Iterator<String> call_map_it = call_status_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_status_map.get(call_index);
			ArrayList<String> cmd_output_list = new ArrayList<String>();
			call_enum call_status = (call_enum) one_call_data.get("call_status");
			// only done call will be release. timeout call will be get in
			// the next cycle(at that time status will be done)
			if (!call_status.equals(call_enum.DONE)) {
				continue;
			}
			String case_work_path = (String) one_call_data.get("case_dir");
			cmd_output_list = (ArrayList<String>) one_call_data.get("cmd_output");
			task_enum cmd_status = (task_enum) case_report_map.get(call_index).get("status");
			String prj_dir_name = "prj" + case_report_map.get(call_index).get("projectId");
			String run_dir_name = "run" + case_report_map.get(call_index).get("runId");
			String tmp_result_dir = public_data.WORKSPACE_RESULT_DIR;
			String save_path = client_info.get_client_data().get("preference").get("save_path").replaceAll("\\\\", "/");
			String[] path_array = new String[] { save_path, tmp_result_dir, prj_dir_name, run_dir_name };
			String case_save_path = String.join(file_separator, path_array);
			case_save_path = case_save_path.replaceAll("\\\\", "/");
			// public data for every case end
			// task 0 : case local report generate
			String local_case_report = case_work_path + "/" + public_data.WORKSPACE_CASE_REPORT_NAME;
			file_action.append_file(local_case_report, line_separator + "[Run]" + line_separator);
			file_action.append_file(local_case_report, String.join(line_separator, cmd_output_list));
			// task 1 : final running process clean up
			run_status = final_cleanup(case_work_path);
			// task 2 : zip case to save path
			String result_keep = (String) one_call_data.get("result_keep");
			if (case_work_path.contains(save_path)) {
				// case save path same with work path no need to copy
				continue;
			}
			if (save_path.trim().equals("")) {
				// no save path, skip copy
				continue;
			}
			switch (result_keep.toLowerCase()) {
			case "zipped":
				run_status = copy_case_to_save_path(case_work_path, case_save_path, "archive");
				break;
			case "unzipped":
				run_status = copy_case_to_save_path(case_work_path, case_save_path, "source");
				break;
			default:// auto and any other inputs treated as auto
				if (cmd_status.equals(task_enum.FAILED)) {
					run_status = copy_case_to_save_path(case_work_path, case_save_path, "source");
				} else {
					run_status = copy_case_to_save_path(case_work_path, case_save_path, "archive");
				}
			}
		}
		return run_status;
	}

	private void update_thread_pool_running_queue(HashMap<String, HashMap<String, Object>> call_status_map) {
		ArrayList<String> running_queue_in_pool = new ArrayList<String>();
		Iterator<String> call_map_it = call_status_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_status_map.get(call_index);
			String queue_name = (String) one_call_data.get("queue_name");
			running_queue_in_pool.add(queue_name);
		}
		task_info.set_thread_pool_admin_queue_list(running_queue_in_pool);
	}

	private void report_finished_queue_data(HashMap<String, HashMap<String, Object>> call_status_map) {
		ArrayList<String> running_queue_in_pool = new ArrayList<String>();
		Iterator<String> call_map_it = call_status_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_status_map.get(call_index);
			String queue_name = (String) one_call_data.get("queue_name");
			running_queue_in_pool.add(queue_name);
		}
		// task 3 : dump finished task queue data to csv file, save memory
		ArrayList<String> finished_admin_queue_list = new ArrayList<String>();
		finished_admin_queue_list.addAll(task_info.get_finished_admin_queue_list());
		ArrayList<String> reported_admin_queue_list = new ArrayList<String>();
		reported_admin_queue_list.addAll(task_info.get_reported_admin_queue_list());
		for (String queue_name : finished_admin_queue_list) {
			Boolean report_status = new Boolean(true);
			if (running_queue_in_pool.contains(queue_name)) {
				continue;// queue not finished
			}
			if (reported_admin_queue_list.contains(queue_name)) {
				continue;// finished queue already reported.
			}
			if (!task_info.get_processed_task_queues_map().containsKey(queue_name)) {
				continue;// no queue data to dump (already dumped)
			}
			// report task queue
			report_status = export_data.export_disk_finished_task_queue_report(queue_name, client_info, task_info);
			if (report_status) {
				task_info.update_reported_admin_queue_list(queue_name);
			}
		}
	}

	private Boolean dump_finished_queue_data(HashMap<String, HashMap<String, Object>> call_status_map) {
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
		ArrayList<String> finished_admin_queue_list = new ArrayList<String>();
		finished_admin_queue_list.addAll(task_info.get_finished_admin_queue_list());
		for (String dump_queue : finished_admin_queue_list) {
			if (running_queue_in_pool.contains(dump_queue)) {
				continue;// queue not finished
			}
			if (view_info.get_watching_queue().equalsIgnoreCase(dump_queue)) {
				continue;// queue in GUI watching
			}
			if (view_info.get_export_queue_list().contains(dump_queue)) {
				continue;// queue in GUI dump status
			}
			if (!task_info.get_processed_task_queues_map().containsKey(dump_queue)) {
				continue;// no queue data to dump (already dumped)
			}
			if (task_info.get_processed_task_queues_map().get(dump_queue).size() < 20) {
				continue;// no need to dump to increase the performance > don't
							// forget dump when shutdown client
			}
			// dumping task queue
			Boolean admin_dump = export_data.export_disk_finished_admin_queue_data(dump_queue, client_info, task_info);
			Boolean task_dump = export_data.export_disk_finished_task_queue_data(dump_queue, client_info, task_info);
			if (admin_dump && task_dump) {
				task_info.remove_queue_from_processed_admin_queues_treemap(dump_queue);
				task_info.remove_queue_from_processed_task_queues_map(dump_queue);
				dump_status = true;
			} else {
				dump_status = false;
			}
		}
		return dump_status;
	}

	private Boolean release_resource_usage(HashMap<String, HashMap<String, Object>> call_status_map) {
		Boolean release_status = new Boolean(true);
		Iterator<String> call_map_it = call_status_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_status_map.get(call_index);
			call_enum call_status = (call_enum) one_call_data.get("call_status");
			// only done call will be release. timeout call will be get in
			// the next cycle(at that time status will be done)
			if (!call_status.equals(call_enum.DONE)) {
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

	private Boolean update_client_run_case_summary(HashMap<String, HashMap<String, Object>> call_status_map,
			HashMap<String, HashMap<String, Object>> case_report_map) {
		Boolean update_status = new Boolean(true);
		Iterator<String> call_map_it = call_status_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_status_map.get(call_index);
			call_enum call_status = (call_enum) one_call_data.get("call_status");
			// only done call will be release. timeout call will be get in
			// the next cycle(at that time status will be done)
			if (!call_status.equals(call_enum.DONE)) {
				continue;
			}
			String queue_name = (String) one_call_data.get("queue_name");
			task_enum case_result = (task_enum) case_report_map.get(call_index).get("status");
			switch (case_result) {
			case PASSED:
				task_info.increase_client_run_case_summary_data_map(queue_name, task_enum.PASSED, 1);
				break;
			case FAILED:
				task_info.increase_client_run_case_summary_data_map(queue_name, task_enum.FAILED, 1);
				break;
			case TIMEOUT:
				task_info.increase_client_run_case_summary_data_map(queue_name, task_enum.TIMEOUT, 1);
				break;
			case TBD:
				task_info.increase_client_run_case_summary_data_map(queue_name, task_enum.TBD, 1);
				break;
			default:
				task_info.increase_client_run_case_summary_data_map(queue_name, task_enum.OTHERS, 1);
			}
		}
		return update_status;
	}

	private Boolean release_pool_thread(HashMap<String, HashMap<String, Object>> call_status_map) {
		Boolean release_status = new Boolean(true);
		Iterator<String> call_map_it = call_status_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_status_map.get(call_index);
			call_enum call_status = (call_enum) one_call_data.get("call_status");
			// only done call have runtime results. timeout call will be get in
			// the next cycle(at that time status will be done)
			if (!call_status.equals(call_enum.DONE)) {
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
			HashMap<String, HashMap<String, Object>> case_report_map) {
		Boolean update_status = new Boolean(true);
		Iterator<String> call_map_it = call_status_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			String queue_name = (String) call_status_map.get(call_index).get("queue_name");
			String case_id = (String) call_status_map.get(call_index).get("case_id");
			HashMap<String, HashMap<String, String>> case_data = task_info
					.get_case_from_processed_task_queues_map(queue_name, case_id);
			HashMap<String, String> case_status = case_data.get("Status");
			case_status.put("cmd_status",
					((task_enum) case_report_map.get(call_index).get("status")).get_description());
			case_status.put("cmd_reason", (String) case_report_map.get(call_index).get("reason"));
			case_status.put("location", (String) case_report_map.get(call_index).get("location"));
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
			call_enum call_status = (call_enum) one_call_data.get("call_status");
			// only done call have runtime results. timeout call will be get in
			// the next cycle(at that time status will be done)
			if (!call_status.equals(call_enum.DONE)) {
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
			runlog.append(line_separator);
			runlog.append(line_separator);
			runlog.append("####################" + line_separator);
			String host_name = client_info.get_client_data().get("Machine").get("terminal");
			String run_path = (String) one_call_data.get("case_dir");
			runlog.append("Runtime Location ==> " + host_name + ":" + run_path + line_separator);
			String detail_path = new String();
			detail_path = "/prj" + task_data.get("ID").get("project") + "/run" + task_data.get("ID").get("run") + "/T"
					+ task_data.get("ID").get("id");
			String win_link = new String();
			String lin_link = new String();
			// Access for Windows: <a href=\\lsh-smb01\home/rel/ng1_0.1205\icd
			// target='_explorer.exe'>\\lsh-smb01\home\rel\ng1_0.1205\icd</a>
			win_link = String.format(
					"<a href=\\\\lsh-smb01\\sw/qa/qadata/results%s target='_explorer.exe'>\\\\lsh-smb01\\sw/qa/qadata/results%s</a>",
					detail_path, detail_path);
			lin_link = String.format(
					"<a href=file://localhost/lsh/sw/qa/qadata/results%s  target='_blank'>/lsh/sw/qa/qadata/results%s</a>",
					detail_path, detail_path);
			runlog.append("Unified Location(Win Default Access) ==> " + win_link + line_separator);
			runlog.append("Unified Location(Lin Default Access) ==> " + lin_link + line_separator);
			runlog.append("Note: If the link above not work, please copy it to your file explorer manually."
					+ line_separator);
			runlog.append(line_separator);
			runlog.append(line_separator);
			ArrayList<String> runtime_output_list = (ArrayList<String>) one_call_data.get("cmd_output");
			runlog.append(String.join(line_separator, runtime_output_list));
			runlog.append(line_separator);
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

	private Boolean send_case_report(HashMap<String, HashMap<String, Object>> case_report_data) {
		Boolean report_status = new Boolean(true);
		xml_parser parser = new xml_parser();
		String ip = client_info.get_client_data().get("Machine").get("ip");
		String terminal = client_info.get_client_data().get("Machine").get("terminal");
		// get remote date
		HashMap<String, HashMap<String, Object>> remote_data = new HashMap<String, HashMap<String, Object>>();
		// get local data
		HashMap<String, HashMap<String, Object>> local_data = new HashMap<String, HashMap<String, Object>>();
		Iterator<String> report_data_it = case_report_data.keySet().iterator();
		while (report_data_it.hasNext()) {
			String call_index = report_data_it.next();
			if (call_index.contains("0@")) { // 0@ local queue
				local_data.put(call_index, case_report_data.get(call_index));
			} else {
				remote_data.put(call_index, case_report_data.get(call_index));
			}
		}
		HashMap<String, HashMap<String, Object>> remote_send_data = new HashMap<String, HashMap<String, Object>>();
		remote_send_data.putAll(generate_optimized_remote_send_data(remote_data));
		if (remote_send_data.size() > 0) {
			// remote send
			String rmq_result_str = parser.create_result_document_string(remote_send_data, ip, terminal);
			report_status = rmq_runner.basic_send(public_data.RMQ_RESULT_NAME, rmq_result_str);
		}
		if (local_data.size() > 0) {
			// local send
			;
		}
		return report_status;
	}

	private HashMap<String, HashMap<String, Object>> generate_optimized_remote_send_data(
			HashMap<String, HashMap<String, Object>> ori_send_data) {
		synchronized (this.getClass()) {
			HashMap<String, HashMap<String, Object>> remote_send_data = new HashMap<String, HashMap<String, Object>>();
			HashMap<String, HashMap<String, Object>> history_send_data = new HashMap<String, HashMap<String, Object>>();
			history_send_data.putAll(deep_clone.clone(pool_info.get_history_send_data()));
			Iterator<String> case_index_it = ori_send_data.keySet().iterator();
			while (case_index_it.hasNext()) {
				String case_index = case_index_it.next();
				HashMap<String, Object> case_data = new HashMap<String, Object>();
				case_data.putAll(ori_send_data.get(case_index));
				HashMap<String, Object> history_case_data = new HashMap<String, Object>();
				if (!history_send_data.containsKey(case_index)) {
					remote_send_data.put(case_index, case_data);
					history_case_data.put("status", case_data.get("status"));
					history_case_data.put("counter", 0);
					pool_info.update_history_send_data(case_index, history_case_data);
					continue;
				}
				history_case_data.putAll(history_send_data.get(case_index));
				task_enum current_status = (task_enum) case_data.get("status");
				task_enum history_status = (task_enum) history_case_data.get("status");
				if (current_status.compareTo(history_status) > 0) {// status update
					remote_send_data.put(case_index, case_data);
					history_case_data.put("status", case_data.get("status"));
					history_case_data.put("counter", 0);
					pool_info.update_history_send_data(case_index, history_case_data);
					continue;
				}
				if ((Integer) history_case_data.get("counter") > 5) {
					remote_send_data.put(case_index, case_data);
					history_case_data.put("counter", 0);
				} else {
					history_case_data.put("counter", (Integer) history_case_data.get("counter") + 1);
				}
				pool_info.update_history_send_data(case_index, history_case_data);
			}
			// clean up history data
			Iterator<String> history_index_it = history_send_data.keySet().iterator();
			while (history_index_it.hasNext()){
				String history_index = history_index_it.next();
				if (!ori_send_data.keySet().contains(history_index)){
					pool_info.remove_history_send_data(history_index);
				}
			}
			return remote_send_data;
		}
	}

	@SuppressWarnings("unchecked")
	private HashMap<String, HashMap<String, Object>> generate_case_report_data(
			HashMap<String, HashMap<String, Object>> call_status_map) {
		HashMap<String, HashMap<String, Object>> case_data = new HashMap<String, HashMap<String, Object>>();
		Iterator<String> call_map_it = call_status_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_status_map.get(call_index);
			call_enum call_status = (call_enum) one_call_data.get("call_status");
			HashMap<String, Object> hash_data = new HashMap<String, Object>();
			String queue_name = call_index.split("#")[1];
			String case_id = call_index.split("#")[0];
			HashMap<String, HashMap<String, String>> task_data = task_info
					.get_case_from_processed_task_queues_map(queue_name, case_id);
			hash_data.put("testId", task_data.get("ID").get("id"));
			hash_data.put("suiteId", task_data.get("ID").get("suite"));
			hash_data.put("runId", task_data.get("ID").get("run"));
			hash_data.put("projectId", task_data.get("ID").get("project"));
			hash_data.put("design", task_data.get("CaseInfo").get("design_name"));
			task_enum cmd_status = task_enum.OTHERS;
			String cmd_reason = new String("NA");
			HashMap<String, String> detail_report = new HashMap<String, String>();
			if (call_status.equals(call_enum.DONE)) {
				cmd_status = get_cmd_status((ArrayList<String>) one_call_data.get("cmd_output"));
				cmd_reason = get_cmd_reason((ArrayList<String>) one_call_data.get("cmd_output"));
				detail_report.putAll(get_detail_report((ArrayList<String>) one_call_data.get("cmd_output")));
			} else if (call_status.equals(call_enum.TIMEOUT)) {
				cmd_status = task_enum.TIMEOUT;
				cmd_reason = "Timeout";
			} else {
				cmd_status = task_enum.PROCESSING;
			}
			hash_data.putAll(detail_report);
			hash_data.put("status", cmd_status);
			hash_data.put("reason", cmd_reason);
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

	private task_enum get_cmd_status(ArrayList<String> cmd_output) {
		task_enum task_status = task_enum.OTHERS;
		String status = new String("NA");
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
		switch (status) {
		case "Passed":
			task_status = task_enum.PASSED;
			break;
		case "Failed":
			task_status = task_enum.FAILED;
			break;
		case "TBD":
			task_status = task_enum.TBD;
			break;
		case "Timeout":
			task_status = task_enum.TIMEOUT;
			break;			
		default:
			task_status = task_enum.OTHERS;
		}
		return task_status;
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
			call_enum status = (call_enum) call_status_map.get(call_index).get("call_status");
			if (!status.equals(call_enum.TIMEOUT)) {
				continue;
			}
			Future<?> call_back = (Future<?>) call_status_map.get(call_index).get("call_back");
			cancel_status = call_back.cancel(true);
		}
		return cancel_status;
	}

	private Boolean cancel_gui_request_call(HashMap<String, HashMap<String, Object>> call_status_map) {
		Boolean cancel_status = new Boolean(true);
		if (!view_info.impl_stop_case_request()) {
			return cancel_status;
		}
		String queue_name = view_info.get_watching_queue();
		List<String> select_task_case = view_info.get_select_task_case();
		Iterator<String> call_map_it = call_status_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			String call_name = (String) call_status_map.get(call_index).get("queue_name");
			String call_id = (String) call_status_map.get(call_index).get("case_id");
			call_enum call_status = (call_enum) call_status_map.get(call_index).get("call_status");
			if (!call_name.equalsIgnoreCase(queue_name)) {
				continue;
			}
			if (!select_task_case.contains(call_id)) {
				continue;
			}
			if (!call_status.equals(call_enum.PROCESSIONG)) {
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
	 * "start_time":start_time, "time_out":time_out, "result_keep", result_keep,
	 * "cmd_output":cmd_output, //new added "call_status": call_status //new
	 * added: done, timeout, processing } }
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
				hash_data.put("call_status", call_enum.DONE);
				try {
					hash_data.put("cmd_output", call_back.get(10, TimeUnit.SECONDS));
				} catch (InterruptedException | ExecutionException | TimeoutException | CancellationException e) {
					// e.printStackTrace();
					RESULT_WAITER_LOGGER.warn("Get call result exception.");
					ArrayList<String> default_output = new ArrayList<String>();
					default_output.add("NA");
					hash_data.put("cmd_output", default_output);
				}
			} else if (current_time - start_time > time_out + 5) {
				hash_data.put("call_status", call_enum.TIMEOUT);
			} else {
				hash_data.put("call_status", call_enum.PROCESSIONG);
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
		} catch (Exception e) {
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
		// case_path_obj.getParent().replaceAll("\\\\", "/");
		File save_dest_folder = new File(save_path, case_folder_name);
		File save_dest_file = new File(save_path, case_folder_name + ".zip");
		if (save_dest_folder.exists()) {
			FileUtils.deleteQuietly(save_dest_folder);
		}
		if (save_dest_file.exists()) {
			FileUtils.deleteQuietly(save_dest_file);
		}
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
			String dump_path = client_info.get_client_data().get("preference").get("work_path") + "/"
					+ public_data.WORKSPACE_LOG_DIR + "/core_dump/dump.log";
			file_action.append_file(dump_path, " " + line_separator);
			file_action.append_file(dump_path, "####################" + line_separator);
			file_action.append_file(dump_path, time_info.get_date_time() + line_separator);
			file_action.append_file(dump_path, run_exception.toString() + line_separator);
			for (Object item : run_exception.getStackTrace()) {
				file_action.append_file(dump_path, "    at " + item.toString() + line_separator);
			}
			switch_info.set_client_stop_request(exit_enum.DUMP);
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
				Thread.sleep(base_interval * 4 * 1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			// ============== All dynamic job start from here ==============
			// use call_status and case_report_data for all tasks
			HashMap<String, HashMap<String, Object>> call_status = new HashMap<String, HashMap<String, Object>>();
			// task 1 : get call map status
			call_status = get_call_status_map();
			// task 2 : update running queue in thread pool
			update_thread_pool_running_queue(call_status);
			// task 3 : dump finished queue:report and data
			report_finished_queue_data(call_status);
			dump_finished_queue_data(call_status);
			// following actions based on a non-empty call back.
			if (call_status.size() < 1) {
				RESULT_WAITER_LOGGER.info(waiter_name + ":Thread Pool Empty...");
				continue;
			}
			// task 4 : cancel running call:1. time out, 2. user terminate
			Boolean cancel_status = cancel_timeout_call(call_status);
			cancel_gui_request_call(call_status);
			// task 5 : general case report
			HashMap<String, HashMap<String, Object>> case_report_data = generate_case_report_data(call_status);
			Boolean send_case_status = send_case_report(case_report_data);
			// task 6 : detail case runtime log report
			HashMap<String, HashMap<String, String>> case_runtime_log_data = generate_case_runtime_log_data(
					call_status);
			Boolean send_runtime_status = send_runtime_report(case_runtime_log_data);
			// task 7 : update memory case run summary
			update_client_run_case_summary(call_status, case_report_data);
			// task 8 : update processed task data info
			Boolean update_task_data_status = update_processed_task_data(call_status, case_report_data);
			// task 9 : release occupied pool thread
			Boolean release_pool_thread_status = release_pool_thread(call_status);
			// task 10 : release occupied resource usage
			Boolean release_resource_status = release_resource_usage(call_status);
			// task 11 : post process
			Boolean post_status = run_post_process(call_status, case_report_data);
			if (cancel_status && send_case_status && send_runtime_status && update_task_data_status
					&& release_pool_thread_status && release_resource_status && post_status) {
				RESULT_WAITER_LOGGER.debug(waiter_name + ": work fine.");
			} else {
				RESULT_WAITER_LOGGER.info(waiter_name + ": Get some warning process. please check.");
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