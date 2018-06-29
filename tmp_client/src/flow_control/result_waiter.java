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
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.io.FileUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.task_data;
import data_center.client_data;
import data_center.exit_enum;
import data_center.public_data;
import data_center.switch_data;
import gui_interface.view_data;
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
	private switch_data switch_info;
	private String line_separator = System.getProperty("line.separator");
	//private String file_separator = System.getProperty("file.separator");
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
	}

	// since only this thread will remove the finished call, so not slipped
	// condition will happen
	/*
	 * call status map: {case_id@queue_name:{"call_back":call_back,
	 * "queue_name":queue_name, "case_id":case_id, "launch_path":launch_path,
	 * "start_time":start_time, "time_out":time_out, "cmd_output":cmd_output,
	 * "call_status": call_status //new added: done, timeout, processing } }
	 */
	@SuppressWarnings("unchecked")
	private Boolean run_post_process(
			HashMap<String, HashMap<String, Object>> case_report_map,
			task_report report_obj) {
		Boolean run_status = new Boolean(true);
		HashMap<String, HashMap<String, Object>> call_data = new HashMap<String, HashMap<String, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());		
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_data.get(call_index);
			call_enum call_status = (call_enum) one_call_data.get("call_status");
			// remove call added after case_report_map generate
			if(!case_report_map.containsKey(call_index)){
				continue;
			}
			// only done call will be release.
			if (!call_status.equals(call_enum.DONE)) {
				continue;
			}
			ArrayList<String> cmd_output_list = new ArrayList<String>();
			String queue_name = (String) one_call_data.get("queue_name");
			String case_id = (String) one_call_data.get("case_id");
			HashMap<String, HashMap<String, String>> task_data = new HashMap<String, HashMap<String, String>>();
			task_data.putAll(task_info.get_case_from_processed_task_queues_map(queue_name, case_id));
			String case_path = task_data.get("Paths").get("case_path");
			String save_path = task_data.get("Paths").get("save_path");
			String save_space = task_data.get("Paths").get("save_space");
			String work_space = task_data.get("Paths").get("work_space");
			String report_path = task_data.get("Paths").get("report_path");
			String result_keep = task_data.get("CaseInfo").get("result_keep");
			task_enum cmd_status = (task_enum) case_report_map.get(call_index).get("status");
			cmd_output_list = (ArrayList<String>) one_call_data.get("call_output");
			// task 0 : case local report generate
			ArrayList<String> title_list = new ArrayList<String>();
			title_list.add("");
			title_list.add("[Run]");
			report_obj.dump_disk_task_report_data(report_path, title_list);
			report_obj.dump_disk_task_report_data(report_path, cmd_output_list);			
			// task 1 : final running process clean up
			run_status = post_process_cleanup(case_path);			
			// task 2 : zip case to save path
			if (save_space.equalsIgnoreCase(work_space)) {
				continue;
			}
			if (save_space.trim().equals("")) {
				// no save path, skip copy
				continue;
			}
			switch (result_keep.toLowerCase()) {
			case "zipped":
				run_status = copy_case_to_save_path(report_path, save_path, "archive");
				break;
			case "unzipped":
				run_status = copy_case_to_save_path(report_path, save_path, "source");
				break;
			default:// auto and any other inputs treated as auto
				if (cmd_status.equals(task_enum.PASSED)) {
					run_status = copy_case_to_save_path(report_path, save_path, "archive");
				} else {
					run_status = copy_case_to_save_path(report_path, save_path, "source");
				}
			}
		}
		return run_status;
	}

	private void update_thread_pool_running_queue() {
		ArrayList<String> running_queue_in_pool = new ArrayList<String>();
		HashMap<String, HashMap<String, Object>> call_data = new HashMap<String, HashMap<String, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_data.get(call_index);
			String queue_name = (String) one_call_data.get("queue_name");
			running_queue_in_pool.add(queue_name);
		}
		task_info.set_thread_pool_admin_queue_list(running_queue_in_pool);
	}

	private void report_finished_queue_data() {
		ArrayList<String> running_queue_in_pool = new ArrayList<String>();
		running_queue_in_pool.addAll(task_info.get_thread_pool_admin_queue_list());
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

	private Boolean dump_finished_queue_data() {
		Boolean dump_status = new Boolean(true);
		ArrayList<String> running_queue_in_pool = new ArrayList<String>();
		running_queue_in_pool.addAll(task_info.get_thread_pool_admin_queue_list());
		// dump finished task queue data to xml file, save memory
		ArrayList<String> finished_admin_queue_list = new ArrayList<String>();
		finished_admin_queue_list.addAll(task_info.get_finished_admin_queue_list());
		for (String dump_queue : finished_admin_queue_list) {
			if (switch_info.get_local_console_mode()){
				continue;// in local console mode no dumping
			}			
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
			RESULT_WAITER_LOGGER.warn("Dumping admin queue:" + dump_queue);
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

	private Boolean release_resource_usage(){
		//release software usage
		Boolean software_release = release_software_usage();
		//release thread usage
		Boolean thread_release = release_thread_usage();
		if (software_release && thread_release){
			return true;
		} else 
			return false;
	}
	
	private Boolean release_software_usage() {
		Boolean release_status = new Boolean(true);
		HashMap<String, HashMap<String, Object>> call_data = new HashMap<String, HashMap<String, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());		
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_data.get(call_index);
			call_enum call_status = (call_enum) one_call_data.get("call_status");
			// only done call will be release. timeout call will be get in
			// the next cycle(at that time status will be done)
			if (!call_status.equals(call_enum.DONE)) {
				continue;
			}
			String queue_name = (String) one_call_data.get("queue_name");
			String case_id = (String) one_call_data.get("case_id");
			HashMap<String, HashMap<String, String>> case_data = task_info
					.get_case_from_processed_task_queues_map(queue_name, case_id);
			release_status = client_info.release_used_soft_insts(case_data.get("Software"));
		}
		return release_status;
	}

	private Boolean release_thread_usage() {
		Boolean release_status = new Boolean(true);
		HashMap<String, HashMap<String, Object>> call_data = new HashMap<String, HashMap<String, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());		
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_data.get(call_index);
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
	
	private Boolean update_client_run_case_summary(
			HashMap<String, HashMap<String, Object>> case_report_map) {
		Boolean update_status = new Boolean(true);
		HashMap<String, HashMap<String, Object>> call_data = new HashMap<String, HashMap<String, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());		
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_data.get(call_index);
			call_enum call_status = (call_enum) one_call_data.get("call_status");
			//remove call added after case_report_map generate
			if(!case_report_map.containsKey(call_index)){
				continue;
			}			
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

	private Boolean update_processed_task_data(
			HashMap<String, HashMap<String, Object>> case_report_map
			) {
		Boolean update_status = new Boolean(true);
		HashMap<String, HashMap<String, Object>> call_data = new HashMap<String, HashMap<String, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());		
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			String queue_name = (String) call_data.get(call_index).get("queue_name");
			String case_id = (String) call_data.get(call_index).get("case_id");
			//remove call added after case_report_map generate
			if(!case_report_map.containsKey(call_index)){
				continue;
			}					
			HashMap<String, HashMap<String, String>> case_data = task_info
					.get_case_from_processed_task_queues_map(queue_name, case_id);
			HashMap<String, String> case_status = new HashMap<String, String>();
			case_status.putAll(case_data.get("Status"));
			case_status.put("cmd_status",
					((task_enum) case_report_map.get(call_index).get("status")).get_description());
			case_status.put("cmd_reason", (String) case_report_map.get(call_index).get("reason"));
			case_status.put("location", (String) case_report_map.get(call_index).get("location"));
			case_status.put("run_time", (String) case_report_map.get(call_index).get("run_time"));
			case_status.put("update_time", (String) case_report_map.get(call_index).get("update_time"));
			case_data.put("Status", case_status);
			task_info.update_case_to_processed_task_queues_map(queue_name, case_id, case_data);
		}
		return update_status;
	}

	@SuppressWarnings("unchecked")
	private HashMap<String, HashMap<String, String>> generate_case_runtime_log_data() {
		HashMap<String, HashMap<String, String>> runtime_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, HashMap<String, Object>> call_data = new HashMap<String, HashMap<String, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());		
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_data.get(call_index);
			String queue_name = (String) one_call_data.get("queue_name");
			String case_id = (String) one_call_data.get("case_id");
			call_enum call_status = (call_enum) one_call_data.get("call_status");
			// only done call have runtime results.
			if (!call_status.equals(call_enum.DONE)) {
				continue;
			}
			HashMap<String, String> hash_data = new HashMap<String, String>();
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
			runlog.append("Run with TMP client:" + public_data.BASE_CURRENTVERSION + line_separator);
			String host_name = client_info.get_client_machine_data().get("terminal");
			String run_path = (String) one_call_data.get("launch_path");
			runlog.append("Runtime Location(Launch Path) ==> " + host_name + ":" + run_path + line_separator);
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
			runlog.append("Unified Location(Win LSH Access) ==> " + win_link + line_separator);
			runlog.append("Unified Location(Lin LSH Access) ==> " + lin_link + line_separator);
			runlog.append("Note:" + line_separator);
			runlog.append("1. If the link above not work, please copy it to your file explorer manually."
					+ line_separator);
			runlog.append("2. For windows, we can also use \\\\machine\\Disk_Partition$\\run_path to access directly."
					+ line_separator);			
			runlog.append(line_separator);
			runlog.append(line_separator);
			ArrayList<String> runtime_output_list = (ArrayList<String>) one_call_data.get("call_output");
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

	@SuppressWarnings("unchecked")
	private HashMap<String, HashMap<String, Object>> generate_case_report_data() {
		HashMap<String, HashMap<String, Object>> case_data = new HashMap<String, HashMap<String, Object>>();
		HashMap<String, HashMap<String, Object>> call_data = new HashMap<String, HashMap<String, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_data.get(call_index);
			String queue_name = (String) one_call_data.get("queue_name");
			String case_id = (String) one_call_data.get("case_id");
			call_enum call_status = (call_enum) one_call_data.get("call_status");
			Boolean call_timeout = (Boolean) one_call_data.get("call_timeout");
			Boolean call_terminate = (Boolean) one_call_data.get("call_terminate");
			HashMap<String, Object> hash_data = new HashMap<String, Object>();
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
				if(call_timeout){
					cmd_status = task_enum.TIMEOUT;
				} else if(call_terminate) {
					cmd_status = task_enum.HALTED;
				} else {
					cmd_status = get_cmd_status((ArrayList<String>) one_call_data.get("call_output"));
				}
				cmd_reason = get_cmd_reason((ArrayList<String>) one_call_data.get("call_output"));
				detail_report.putAll(get_detail_report((ArrayList<String>) one_call_data.get("call_output")));				
			}  else {
				cmd_status = task_enum.PROCESSING;
			}
			hash_data.putAll(detail_report);
			hash_data.put("status", cmd_status);
			hash_data.put("reason", cmd_reason);
			hash_data.put("location", (String) one_call_data.get("launch_path"));
			long start_time = (long) one_call_data.get("start_time");
			long current_time = System.currentTimeMillis() / 1000;
			hash_data.put("run_time", time_info.get_runtime_string_hms(start_time, current_time));
			hash_data.put("update_time", time_info.get_man_date_time());
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
		// <status>Passed</status>
		Pattern p = Pattern.compile("status>(.+?)</");
		for (String line : cmd_output) {
			if (!line.contains("<status>")) {
				continue;
			}
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
		case "Blocked":
			task_status = task_enum.BLOCKED;
			break;
		case "Case_Issue":
			task_status = task_enum.CASEISSUE;
			break;
		case "SW_Issue":
			task_status = task_enum.SWISSUE;
			break;			
		default:
			task_status = task_enum.OTHERS;
		}
		return task_status;
	}

	private String get_cmd_reason(ArrayList<String> cmd_output) {
		String reason = new String("NA");
		if(cmd_output == null || cmd_output.isEmpty()){
			return reason;
		}
		// <status>Passed</status>
		Pattern p = Pattern.compile("reason>(.+?)</");		
		for (String line : cmd_output) {
			if (!line.contains("<reason>")) {
				continue;
			}
			Matcher m = p.matcher(line);
			if (m.find()) {
				reason = m.group(1);
			}
		}
		return reason;
	}

	private Boolean terminate_user_request_running_call() {
		Boolean cancel_status = new Boolean(true);
		if (!view_info.impl_stop_case_request()) {
			return cancel_status;
		}
		String queue_name = view_info.get_watching_queue();
		List<String> select_task_case = view_info.get_select_task_case();
		HashMap<String, HashMap<String, Object>> call_data = new HashMap<String, HashMap<String, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			String call_name = (String) call_data.get(call_index).get("queue_name");
			String call_id = (String) call_data.get(call_index).get("case_id");
			call_enum call_status = (call_enum) call_data.get(call_index).get("call_status");
			if (!call_name.equalsIgnoreCase(queue_name)) {
				continue;
			}
			if (!select_task_case.contains(call_id)) {
				continue;
			}
			if (!call_status.equals(call_enum.PROCESSIONG)) {
				continue;
			}
			cancel_status = pool_info.terminate_sys_call(call_index);
		}
		return cancel_status;
	}

	private Boolean terminate_stopped_queue_running_call() {
		Boolean cancel_status = new Boolean(true);
		ArrayList<String> stopped_admin_queue_list = new ArrayList<String>();
		stopped_admin_queue_list.addAll(task_info.get_stopped_admin_queue_list());
		HashMap<String, HashMap<String, Object>> call_data = new HashMap<String, HashMap<String, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			String call_name = (String) call_data.get(call_index).get("queue_name");
			call_enum call_status = (call_enum) call_data.get(call_index).get("call_status");
			if(!stopped_admin_queue_list.contains(call_name)){
				continue;
			}
			if (!call_status.equals(call_enum.PROCESSIONG)) {
				continue;
			}
			cancel_status = pool_info.terminate_sys_call(call_index);
		}
		return cancel_status;
	}	
	
	public static Boolean post_process_cleanup(String clean_work_path) {
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

	public Boolean copy_case_to_save_path(String case_path, String save_path, String copy_type) {
		Boolean copy_status = new Boolean(true);
		if (case_path.equalsIgnoreCase(save_path)){
			return copy_status;
		}
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
		File case_path_obj = new File(case_path);
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

	private void generate_console_report(
			String waiter_name,
			HashMap<String, HashMap<String, Object>> case_report_map){
		HashMap<String, HashMap<String, Object>> call_data = new HashMap<String, HashMap<String, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<String, Object> one_call_data = call_data.get(call_index);
			call_enum call_status = (call_enum) one_call_data.get("call_status");
			//remove call added after case_report_map generate
			if(!case_report_map.containsKey(call_index)){
				continue;
			}			
			// only done call will be release. timeout call will be get in
			// the next cycle(at that time status will be done)
			if (!call_status.equals(call_enum.DONE)) {
				continue;
			}			
			String queue_name = (String) one_call_data.get("queue_name");
			String case_id = (String) one_call_data.get("case_id");
			task_enum status = (task_enum) case_report_map.get(call_index).get("status");
			String location = (String) case_report_map.get(call_index).get("location");
			if (switch_info.get_local_console_mode()){
				RESULT_WAITER_LOGGER.info(waiter_name + ": " + case_id + "," + status.get_description() + "," + location);
			} else {
				RESULT_WAITER_LOGGER.info(waiter_name + ": " + queue_name + "," + case_id + "," + status.get_description());
			}
		}
	}
	
	public void run() {
		try {
			monitor_run();
		} catch (Exception run_exception) {
			run_exception.printStackTrace();
			String dump_path = client_info.get_client_data().get("preference").get("work_space") + "/"
					+ public_data.WORKSPACE_LOG_DIR + "/core_dump/dump.log";
			file_action.append_file(dump_path, " " + line_separator);
			file_action.append_file(dump_path, "####################" + line_separator);
			file_action.append_file(dump_path, "Date   :" + time_info.get_date_time() + line_separator);
			file_action.append_file(dump_path, "Version:" + public_data.BASE_CURRENTVERSION + line_separator);
			file_action.append_file(dump_path, run_exception.toString() + line_separator);
			for (Object item : run_exception.getStackTrace()) {
				file_action.append_file(dump_path, "    at " + item.toString() + line_separator);
			}
			switch_info.set_client_stop_request(exit_enum.DUMP);
		}
	}

	private void monitor_run() {
		// ============== All static job start from here ==============
		// this run cannot launch multiple threads
		result_thread = Thread.currentThread();
		String waiter_name = "RW_0";
		task_report report_obj = new task_report(pool_info, client_info);
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
				Thread.sleep(base_interval * 1 * 1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			// ============== All dynamic job start from here ==============
			// task 1 : report/dump finished queue:report and data
			update_thread_pool_running_queue();	
			report_finished_queue_data(); //generate csv report
			dump_finished_queue_data(); //to log dir xml file save memory
			// following actions based on a non-empty call back.
			if (pool_info.get_sys_call_link() == null || pool_info.get_sys_call_link().size() < 1) {
				if(!switch_info.get_local_console_mode()){
					RESULT_WAITER_LOGGER.info(waiter_name + ":Thread Pool Empty...");
				}
				continue;
			}
			pool_info.fresh_sys_call();	
			// task 2 : terminate running call
			terminate_user_request_running_call();
			terminate_stopped_queue_running_call();
			// task 3 : general and send task report
			HashMap<String, HashMap<String, Object>> case_report_data = generate_case_report_data();
			HashMap<String, HashMap<String, String>> case_runtime_log_data = generate_case_runtime_log_data();
			report_obj.send_tube_task_data_report(case_report_data, true);			
			report_obj.send_tube_task_runtime_report(case_runtime_log_data);
			// task 4 : update memory case run summary
			generate_console_report(waiter_name, case_report_data);
			update_client_run_case_summary(case_report_data);
			// task 5 : update processed task data info
			update_processed_task_data(case_report_data);
			// task 6 : post process
			Boolean post_status = run_post_process(case_report_data, report_obj);
			// task 7 : release occupied resource
			Boolean release_status = release_resource_usage();			
			if (release_status && post_status) {
				RESULT_WAITER_LOGGER.debug(waiter_name + ": Work fine.");
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