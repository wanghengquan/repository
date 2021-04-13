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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.task_data;
import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;
import gui_interface.view_data;
import top_runner.run_status.exit_enum;
import utility_funcs.deep_clone;
import utility_funcs.postrun_call;
import utility_funcs.time_info;

public class result_waiter extends Thread {
	// public property
	// protected property
	// private property
	private static final Logger RESULT_WAITER_LOGGER = LogManager.getLogger(result_waiter.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = true;
	private Thread result_thread;
	private pool_data pool_info;
	private client_data client_info;
	private task_data task_info;
	private view_data view_info;
	private switch_data switch_info;
	private post_data post_info;
	private task_report report_obj;
	private String line_separator = System.getProperty("line.separator");
	//private String file_separator = System.getProperty("file.separator");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;
	// public function
	// protected function
	// private function

	public result_waiter(
			switch_data switch_info,
			client_data client_info,
			pool_data pool_info,
			task_data task_info,
			view_data view_info,
			post_data post_info
			) {
		this.pool_info = pool_info;
		this.task_info = task_info;
		this.client_info = client_info;
		this.switch_info = switch_info;
		this.view_info = view_info;
		this.post_info = post_info;
		this.report_obj = new task_report(pool_info, client_info);
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
	private Boolean run_local_disk_report(
			HashMap<String, HashMap<String, Object>> case_report_map) {
		Boolean run_status = Boolean.valueOf(true);
		HashMap<String, HashMap<pool_attr, Object>> call_data = new HashMap<String, HashMap<pool_attr, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());		
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<pool_attr, Object> one_call_data = call_data.get(call_index);
			call_state call_status = (call_state) one_call_data.get(pool_attr.call_status);
			// remove call added after case_report_map generate
			if(!case_report_map.containsKey(call_index)){
				continue;
			}
			// only done call will be release.
			if (!call_status.equals(call_state.DONE)) {
				continue;
			}
			ArrayList<String> cmd_output_list = new ArrayList<String>();
			String queue_name = (String) one_call_data.get(pool_attr.call_queue);
			String case_id = (String) one_call_data.get(pool_attr.call_case);
			HashMap<String, HashMap<String, String>> task_data = new HashMap<String, HashMap<String, String>>();
			task_data.putAll(task_info.get_case_from_processed_task_queues_map(queue_name, case_id));
			String report_path = task_data.get("Paths").get("report_path");
			cmd_output_list = (ArrayList<String>) one_call_data.get(pool_attr.call_output);
			// task 0 : case local report generate
			ArrayList<String> title_list = new ArrayList<String>();
			title_list.add("");
			title_list.add("[Run]");
			report_obj.dump_disk_task_report_data(report_path, title_list);
			report_obj.dump_disk_task_report_data(report_path, cmd_output_list);			
		}
		return run_status;
	}

	private Boolean run_post_process(
			HashMap<String, HashMap<String, Object>> case_report_map) {
		Boolean run_status = Boolean.valueOf(true);
		HashMap<String, HashMap<pool_attr, Object>> call_data = new HashMap<String, HashMap<pool_attr, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());		
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<pool_attr, Object> one_call_data = call_data.get(call_index);
			call_state call_status = (call_state) one_call_data.get(pool_attr.call_status);
			// remove call added after case_report_map generate
			if(!case_report_map.containsKey(call_index)){
				continue;
			}
			// only done call will be release.
			if (!call_status.equals(call_state.DONE)) {
				continue;
			}
			String queue_name = (String) one_call_data.get(pool_attr.call_queue);
			String case_id = (String) one_call_data.get(pool_attr.call_case);
			HashMap<String, HashMap<String, String>> task_data = new HashMap<String, HashMap<String, String>>();
			task_data.putAll(task_info.get_case_from_processed_task_queues_map(queue_name, case_id));
			String case_path = task_data.get("Paths").get("case_path");
			String save_path = task_data.get("Paths").get("save_path");
			String work_suite = task_data.get("Paths").get("work_suite");
			String save_suite = task_data.get("Paths").get("save_suite");
			String save_space = task_data.get("Paths").get("save_space");
			String work_space = task_data.get("Paths").get("work_space");
			String report_path = task_data.get("Paths").get("report_path");
			String result_keep = task_data.get("Preference").get("result_keep");
			task_enum cmd_status = (task_enum) case_report_map.get(call_index).get("status");
			ArrayList<String> post_report_list = new ArrayList<String>();
			post_report_list.add("");
			post_report_list.add("[PostRun]");				
			// task 1: add new post processes
			postrun_call call_obj = new postrun_call(
					case_path,
					report_path,
					work_space,
					work_suite,
					save_space,
					save_suite,
					save_path,
					cmd_status,
					"keep",
					result_keep,
					client_info.get_client_tools_data());
			Boolean create_status = post_info.add_postrun_call(call_obj, queue_name, case_id, public_data.DEF_CLEANUP_TASK_TIMEOUT);
			if (!create_status){
				post_report_list.add("Post run task skipped, no post run system/disk cleanup will be run.");
				post_report_list.add("This issue is caused by maximum cleanup tasks arrived.");
			} else {
				post_report_list.add("Post run task added successfully.");
			}
			report_obj.dump_disk_task_report_data(report_path, post_report_list);
		}
		return run_status;
	}	
	
	private void update_running_queue_list() {
		ArrayList<String> running_queue_in_pool = new ArrayList<String>();
		HashMap<String, HashMap<pool_attr, Object>> call_data = new HashMap<String, HashMap<pool_attr, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<pool_attr, Object> one_call_data = call_data.get(call_index);
			String queue_name = (String) one_call_data.get(pool_attr.call_queue);
			if (!running_queue_in_pool.contains(queue_name)) {
				running_queue_in_pool.add(queue_name);
			}
		}
		task_info.set_running_admin_queue_list(running_queue_in_pool);
	}
	
	private void update_finished_queue_list() {
		ArrayList<String> running_queue = new ArrayList<String>();
		running_queue.addAll(task_info.get_running_admin_queue_list());
		ArrayList<String> emptied_queue = new ArrayList<String>();
		emptied_queue.addAll(task_info.get_emptied_admin_queue_list());
		ArrayList<String> finished_queue = new ArrayList<String>();
		finished_queue.addAll(task_info.get_finished_admin_queue_list());
		for (String queue_name : emptied_queue){
			if (running_queue.contains(queue_name)){
				continue;
			}
			if (finished_queue.contains(queue_name)){
				continue;
			}
			task_info.increase_finished_admin_queue_list(queue_name);
		}
	}	

	private void dump_finished_queue_report() {
		ArrayList<String> finished_admin_queue_list = new ArrayList<String>();
		finished_admin_queue_list.addAll(task_info.get_finished_admin_queue_list());
		ArrayList<String> reported_admin_queue_list = new ArrayList<String>();
		reported_admin_queue_list.addAll(task_info.get_reported_admin_queue_list());
		for (String queue_name : finished_admin_queue_list) {
			Boolean report_status = Boolean.valueOf(true);
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
	
	private Boolean queue_dump_dealy_check(String queue_name){
		Boolean status = Boolean.valueOf(true);
		task_info.increase_finished_queue_dump_delay_counter(queue_name, 1);
		int current_delay_cycle = task_info.get_finished_queue_dump_delay_data(queue_name);
		if (current_delay_cycle < public_data.PERF_QUEUE_DUMP_DELAY){
			status = false;
		} else {
			task_info.release_finished_queue_dump_delay_counter(queue_name);
			status = true;
		}
		return status;
	}
	
	private Boolean dump_finished_queue_data() {
		Boolean dump_status = Boolean.valueOf(true);
		// dump finished task queue data to xml file, save memory
		ArrayList<String> finished_admin_queue_list = new ArrayList<String>();
		finished_admin_queue_list.addAll(task_info.get_finished_admin_queue_list());
		for (String dump_queue : finished_admin_queue_list) {
			if (!task_info.get_emptied_admin_queue_list().contains(dump_queue)){
				continue;//Queue not finished in this run will not dump
			}
			if (switch_info.get_local_console_mode()){
				continue;// in local console mode no dumping
			}
			if (view_info.get_request_watching_queue().equalsIgnoreCase(dump_queue)) {
				continue;// queue in GUI watching
			}			
			if (view_info.get_current_watching_queue().equalsIgnoreCase(dump_queue)) {
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
			if (!queue_dump_dealy_check(dump_queue)){
				continue;// dump delay not ready (to avoid client dump)
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

	private Boolean fresh_thread_pool_data(){
		Boolean run_status = Boolean.valueOf(true);
		//fresh pool call map data
		pool_info.fresh_sys_call(client_info.get_client_tools_data());
		post_info.fresh_postrun_call();
		//clean post run map data (sys call map will be clean later)
		clean_postrun_map_data();
		//clean history send data
		clean_history_send_data();
		return run_status;
	}
	
	private Boolean clean_history_send_data(){
		Boolean run_status = Boolean.valueOf(true);
		HashMap<String, HashMap<pool_attr, Object>> call_data = new HashMap<String, HashMap<pool_attr, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());
		HashMap<String, HashMap<String, Object>> history_send_data = new HashMap<String, HashMap<String, Object>>();
		history_send_data.putAll(deep_clone.clone(pool_info.get_history_send_data()));
		Iterator<String> history_index_it = history_send_data.keySet().iterator();
		while (history_index_it.hasNext()){
			String history_index = history_index_it.next();
			if (!call_data.containsKey(history_index)){
				pool_info.remove_history_send_data(history_index);
			}
		}
		return run_status;
	}
	
	private Boolean clean_postrun_map_data(){
		Boolean run_status = Boolean.valueOf(true);
		HashMap<String, HashMap<post_attr, Object>> call_data = new HashMap<String, HashMap<post_attr, Object>>();
		call_data.putAll(post_info.get_postrun_call_copy());
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<post_attr, Object> one_call_data = call_data.get(call_index);
			call_state call_status = (call_state) one_call_data.get(post_attr.call_status);
			// only done call will be release. timeout call will be get in
			// the next cycle(at that time status will be done)
			if (!call_status.equals(call_state.DONE)) {
				continue;
			}
			String report_path = (String) one_call_data.get(post_attr.call_rptdir);
			@SuppressWarnings("unchecked")
			ArrayList<String> run_msg = (ArrayList<String>) one_call_data.get(post_attr.call_message);
			// task 1: run message/report generate
			report_obj.dump_disk_task_report_data(report_path, run_msg);
			// task 2: remove post run call from call map
			post_info.remove_postrun_call(call_index);
		}
		return run_status;
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
		Boolean release_status = Boolean.valueOf(true);
		HashMap<String, HashMap<pool_attr, Object>> call_data = new HashMap<String, HashMap<pool_attr, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());		
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<pool_attr, Object> one_call_data = call_data.get(call_index);
			call_state call_status = (call_state) one_call_data.get(pool_attr.call_status);
			// only done call will be release. timeout call will be get in
			// the next cycle(at that time status will be done)
			if (!call_status.equals(call_state.DONE)) {
				continue;
			}
			String queue_name = (String) one_call_data.get(pool_attr.call_queue);
			String case_id = (String) one_call_data.get(pool_attr.call_case);
			HashMap<String, HashMap<String, String>> case_data = task_info
					.get_case_from_processed_task_queues_map(queue_name, case_id);
			release_status = client_info.release_used_soft_insts(case_data.get("Software"));
		}
		return release_status;
	}

	private Boolean release_thread_usage() {
		Boolean release_status = Boolean.valueOf(true);
		HashMap<String, HashMap<pool_attr, Object>> call_data = new HashMap<String, HashMap<pool_attr, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());		
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<pool_attr, Object> one_call_data = call_data.get(call_index);
			call_state call_status = (call_state) one_call_data.get(pool_attr.call_status);
			// only done call have runtime results. timeout call will be get in
			// the next cycle(at that time status will be done)
			if (!call_status.equals(call_state.DONE)) {
				continue;
			}
			// update call map in ThreadPool
			release_status = pool_info.remove_sys_call(call_index);
			// update reserved thread in ThreadPool
			release_status = pool_info.release_reserved_threads(1);
		}
		return release_status;
	}
	
	private Boolean update_client_run_case_summary(
			HashMap<String, HashMap<String, Object>> case_report_map) {
		Boolean update_status = Boolean.valueOf(true);
		HashMap<String, HashMap<pool_attr, Object>> call_data = new HashMap<String, HashMap<pool_attr, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());		
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<pool_attr, Object> one_call_data = call_data.get(call_index);
			call_state call_status = (call_state) one_call_data.get(pool_attr.call_status);
			//remove call added after case_report_map generate
			if(!case_report_map.containsKey(call_index)){
				continue;
			}			
			// only done call will be release. timeout call will be get in
			// the next cycle(at that time status will be done)
			if (!call_status.equals(call_state.DONE)) {
				continue;
			}
			String queue_name = (String) one_call_data.get(pool_attr.call_queue);
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
			case BLOCKED:
				task_info.increase_client_run_case_summary_data_map(queue_name, task_enum.BLOCKED, 1);
				break;	
			case SWISSUE:
				task_info.increase_client_run_case_summary_data_map(queue_name, task_enum.SWISSUE, 1);
				break;	
			case CASEISSUE:
				task_info.increase_client_run_case_summary_data_map(queue_name, task_enum.CASEISSUE, 1);
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
		Boolean update_status = Boolean.valueOf(true);
		HashMap<String, HashMap<pool_attr, Object>> call_data = new HashMap<String, HashMap<pool_attr, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());		
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			String queue_name = (String) call_data.get(call_index).get(pool_attr.call_queue);
			String case_id = (String) call_data.get(call_index).get(pool_attr.call_case);
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
			case_status.put("milestone", (String) case_report_map.get(call_index).get("milestone"));
			case_status.put("key_check", (String) case_report_map.get(call_index).get("key_check"));
			case_status.put("location", (String) case_report_map.get(call_index).get("location"));
			case_status.put("run_time", (String) case_report_map.get(call_index).get("run_time"));
			case_status.put("update_time", (String) case_report_map.get(call_index).get("update_time"));
            case_status.put("defects", (String) case_report_map.get(call_index).get("defects"));
            case_status.put("defects_history", (String) case_report_map.get(call_index).get("defects_history"));
			case_data.put("Status", case_status);
			task_info.update_case_to_processed_task_queues_map(queue_name, case_id, case_data);
		}
		return update_status;
	}

	@SuppressWarnings("unchecked")
	private HashMap<String, HashMap<String, String>> generate_case_runtime_log_data(
			HashMap<String, HashMap<String, Object>> case_report_map) {
		HashMap<String, HashMap<String, String>> runtime_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, HashMap<pool_attr, Object>> call_data = new HashMap<String, HashMap<pool_attr, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());		
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<pool_attr, Object> one_call_data = call_data.get(call_index);
			String queue_name = (String) one_call_data.get(pool_attr.call_queue);
			String case_id = (String) one_call_data.get(pool_attr.call_case);
			call_state call_status = (call_state) one_call_data.get(pool_attr.call_status);
			// only done call have runtime results.
			if (!call_status.equals(call_state.DONE)) {
				continue;
			}
			HashMap<String, String> hash_data = new HashMap<String, String>();
			HashMap<String, HashMap<String, String>> task_data = task_info
					.get_case_from_processed_task_queues_map(queue_name, case_id);
			hash_data.put("testId", task_data.get("ID").get("id"));
			hash_data.put("suiteId", task_data.get("ID").get("suite"));
			hash_data.put("runId", task_data.get("ID").get("run"));
			hash_data.put("projectId", task_data.get("ID").get("project"));
			task_enum status = (task_enum) case_report_map.get(call_index).get("status");
			StringBuilder runlog = new StringBuilder();
			//step 0: generate runlog title
			runlog.append(line_separator);
			runlog.append(line_separator);
			runlog.append("####################" + line_separator);
			runlog.append("Run with TMP client:" + public_data.BASE_CURRENTVERSION + line_separator);
			String case_url = (String) one_call_data.get(pool_attr.call_caseurl);
			runlog.append("Source Location(Case URL) ==> " + case_url.replaceAll("\\\\", "/") + line_separator);
			//step 1: generate runtime location
			String host_name = client_info.get_client_machine_data().get("terminal");
			String run_path = (String) one_call_data.get(pool_attr.call_laudir);
			runlog.append("Runtime Location(Launch Path) ==> " + host_name + ":" + run_path + line_separator);
			//step 2: generate save location
			runlog.append(save_location_generate(task_data.get("Paths").get("save_path"), status));
			//step 3: notes
			runlog.append("Note:" + line_separator);
			runlog.append("1. If the link above not work, please copy it to your file explorer manually."
					+ line_separator);
			runlog.append("2. For windows, we can also use \\\\machine\\Disk_Partition$\\run_path to access directly."
					+ line_separator);			
			runlog.append(line_separator);
			runlog.append(line_separator);
			//step 4: generate runtime outputs
			ArrayList<String> runtime_output_list = (ArrayList<String>) one_call_data.get(pool_attr.call_output);
			runlog.append(String.join(line_separator, runtime_output_filter(runtime_output_list)));
			runlog.append(line_separator);
			//step 5: return data
			String runlog_str = runlog.toString();
			hash_data.put("runLog", remove_xml_modifier(runlog_str));
			runtime_data.put(call_index, hash_data);
		}
		return runtime_data;
	}

	private String save_location_generate(
			String save_paths,
			task_enum status){
		StringBuilder loc_rpt = new StringBuilder();
        String win_href = "<a href=file:///%s target='_explorer.exe'>%s";
        String lin_href = "<a href=file:///%s  target='_blank'>%s";		
        String[] ori_paths = save_paths.split(",");
        //get effective and unique paths
        ArrayList<String> uniq_paths = new ArrayList<String>();
        for(String path: ori_paths) {
        	String ori_path = new String(path);
        	String match_str1 = new String("");
        	String match_str2 = new String("");
        	if (path.startsWith("/lsh/")) {
        		match_str1 = ori_path.replace("\\", "/");
        		match_str2 = ori_path.replace("/lsh/", "//lsh-smb02/").replace("\\", "/");
        	} else if (path.startsWith("\\\\lsh-smb02\\")){
        		match_str1 = ori_path.replace("\\", "/");
        		match_str2 = ori_path.replace("\\\\lsh-smb02\\", "/lsh/").replace("\\", "/");
        	} else if (path.startsWith("/disks/")){
        		match_str1 = ori_path.replace("\\", "/");
        		match_str2 = ori_path.replace("/disks/", "//ldc-smb01/").replace("\\", "/");
        	} else if (path.startsWith("\\\\ldc-smb01\\")){
        		match_str1 = ori_path.replace("\\", "/");
        		match_str2 = ori_path.replace("\\\\ldc-smb01\\", "/disks/").replace("\\", "/");
        	} else {
        		match_str1 = ori_path.replace("\\", "/");
        		match_str2 = ori_path.replace("\\", "/");
        	}
        	Boolean path_exist = Boolean.valueOf(false);
        	for (String path_str: uniq_paths) {
        		path_str = path_str.replace("\\", "/");
        		if (path_str.equalsIgnoreCase(match_str1) || path_str.equalsIgnoreCase(match_str2)) {
        			path_exist = true;
        			break;
        		}
        	}
        	if (!path_exist) {
        		uniq_paths.add(ori_path);
        	}
        }
        //generate report lines
        int i = 1;
        for(String path: uniq_paths) {
            path = path.trim();
            String site = new String("");
            if (path.startsWith("/lsh/") || path.startsWith("\\\\lsh-smb02\\")) {
            	site = "(LSH)";
            } else if (path.startsWith("/disks/") || path.startsWith("\\\\ldc-smb01\\")) {
            	site = "(LSV)";
            } else {
            	site = "";
            }
            if(path.startsWith("/lsh/")){
            	loc_rpt.append("Save location " + i + " for (Lin) access " + site + " ==> ");
            	loc_rpt.append(String.format(lin_href, path, path));
            	loc_rpt.append("</a>" + line_separator);
            	path = path.replace("/lsh/", "//lsh-smb02/");
            	loc_rpt.append("Save location " + i + " for (Win) access " + site + " ==> ");
            	loc_rpt.append(String.format(win_href, path, path.replace("/", "\\")));
            	loc_rpt.append("</a>" + line_separator);
            } else if (path.startsWith("\\\\lsh-smb02\\")) {
            	loc_rpt.append("Save location " + i + " for (Win) access " + site + " ==> ");
            	loc_rpt.append(String.format(win_href, path.replace("\\", "/"), path));
            	loc_rpt.append("</a>" + line_separator);
            	path = path.replace("\\\\lsh-smb02\\", "/lsh/").replace("\\", "/");
            	loc_rpt.append("Save location " + i + " for (Lin) access " + site + " ==> ");
            	loc_rpt.append(String.format(lin_href, path, path));
            	loc_rpt.append("</a>" + line_separator);
            } else if (path.startsWith("/disks/")){
            	//for LSV path, passed case will not be copy, so don't show link
            	if (status.equals(task_enum.PASSED)) {
            		continue;
            	}
            	loc_rpt.append("Save location " + i + " for (Lin) access " + site + " ==> ");
            	loc_rpt.append(String.format(lin_href, path, path));
            	loc_rpt.append("</a>" + line_separator);
            	path = path.replace("/disks/", "//ldc-smb01/");
            	loc_rpt.append("Save location " + i + " for (Win) access " + site + " ==> ");
            	loc_rpt.append(String.format(win_href, path, path.replace("/", "\\")));
            	loc_rpt.append("</a>" + line_separator);
            } else if (path.startsWith("\\\\ldc-smb01\\")) {
            	//for LSV path, passed case will not be copy, so don't show link
            	if (status.equals(task_enum.PASSED)) {
            		continue;
            	}         	
            	loc_rpt.append("Save location " + i + " for (Win) access " + site + " ==> ");
            	loc_rpt.append(String.format(win_href, path.replace("\\", "/"), path));
            	loc_rpt.append("</a>" + line_separator);
            	path = path.replace("\\\\ldc-smb01\\", "/disks/").replace("\\", "/");
            	loc_rpt.append("Save location " + i + " for (Lin) access " + site + " ==> ");
            	loc_rpt.append(String.format(lin_href, path, path));
            	loc_rpt.append("</a>" + line_separator);
            } else if (path.startsWith("/")) {
            	loc_rpt.append("Save location " + i + " for (Lin) access ==> ");
            	loc_rpt.append(String.format(lin_href, path, path));
            	loc_rpt.append("</a>" + line_separator);
            } else {
            	loc_rpt.append("Save location " + i + " for (Win) access ==> ");
            	loc_rpt.append(String.format(win_href, path.replace("\\", "/"), path));
                loc_rpt.append("</a>" + line_separator);
            }
            i++;
        }
        //return string
        return loc_rpt.toString();
	}
	
	private ArrayList<String> runtime_output_filter(ArrayList<String> output_list){
		ArrayList<String> return_list = new ArrayList<String>();
		if (output_list == null || output_list.isEmpty()) {
			return return_list;
		}
		Pattern start_pattern = Pattern.compile("===TMP Detail===");
		Pattern stop_pattern = Pattern.compile("===TMP end===");
		Boolean filter_enable = Boolean.valueOf(false);
		for (String line:output_list){
			Matcher start_match = start_pattern.matcher(line);
			Matcher stop_match = stop_pattern.matcher(line);
			if (start_match.find()){
				filter_enable = true;
				continue;
			}
			if (stop_match.find()){
				filter_enable = false;
				continue;
			}
			if (filter_enable){
				continue;
			}
			return_list.add(line);
		}
		return return_list;
	}
	
	private String remove_xml_modifier(String xml_string) {
        xml_string = xml_string.replaceAll("&", "&amp;");
		xml_string = xml_string.replaceAll("\"", "&quot;");
		xml_string = xml_string.replaceAll("<", "&lt;");
		xml_string = xml_string.replaceAll(">", "&gt;");
		return xml_string;
	}
	@SuppressWarnings("unchecked")
	private HashMap<String, HashMap<String, Object>> generate_case_report_data() {
		HashMap<String, HashMap<String, Object>> case_data = new HashMap<String, HashMap<String, Object>>();
		HashMap<String, HashMap<pool_attr, Object>> call_data = new HashMap<String, HashMap<pool_attr, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<pool_attr, Object> one_call_data = call_data.get(call_index);
			String queue_name = (String) one_call_data.get(pool_attr.call_queue);
			String case_id = (String) one_call_data.get(pool_attr.call_case);
			call_state call_status = (call_state) one_call_data.get(pool_attr.call_status);
			Boolean call_timeout = (Boolean) one_call_data.get(pool_attr.call_timeout);
			Boolean call_terminate = (Boolean) one_call_data.get(pool_attr.call_terminate);
			HashMap<String, Object> hash_data = new HashMap<String, Object>();
			HashMap<String, HashMap<String, String>> task_data = new HashMap<String, HashMap<String, String>>();
			task_data.putAll(deep_clone.clone(task_info.get_case_from_processed_task_queues_map(queue_name, case_id)));
			hash_data.put("testId", task_data.get("ID").get("id"));
			hash_data.put("suiteId", task_data.get("ID").get("suite"));
			hash_data.put("runId", task_data.get("ID").get("run"));
			hash_data.put("projectId", task_data.get("ID").get("project"));
			hash_data.put("design", task_data.get("CaseInfo").get("design_name"));
			task_enum cmd_status = task_enum.OTHERS;
			String cmd_reason = new String("NA");
			String milestone = new String("NA");
			String key_check = new String("NA");
			String defects = new String("");
			String defects_history = new String("NA");
			String scan_result = "";
			HashMap<String, String> detail_report = new HashMap<String, String>();
			if (call_status.equals(call_state.DONE)) {
				if(call_timeout){
					cmd_status = task_enum.TIMEOUT;
				} else if(call_terminate) {
					cmd_status = task_enum.HALTED;
				} else {
					cmd_status = get_cmd_status((ArrayList<String>) one_call_data.get(pool_attr.call_output));
				}
				cmd_reason = get_cmd_reason((ArrayList<String>) one_call_data.get(pool_attr.call_output));
				milestone = get_milestone_info((ArrayList<String>) one_call_data.get(pool_attr.call_output));
				key_check = get_key_check_info((ArrayList<String>) one_call_data.get(pool_attr.call_output));
				defects = get_defects_info((ArrayList<String>) one_call_data.get(pool_attr.call_output));
				defects_history = get_defects_history_info((ArrayList<String>) one_call_data.get(pool_attr.call_output));
                scan_result = get_scan_result((ArrayList<String>) one_call_data.get(pool_attr.call_output));
				detail_report.putAll(get_detail_report((ArrayList<String>) one_call_data.get(pool_attr.call_output)));				
			}  else {
				cmd_status = task_enum.PROCESSING;
			}
			hash_data.putAll(detail_report);
            hash_data.put("scan_result", scan_result);
			hash_data.put("defects", defects);
			hash_data.put("defects_history", defects_history);
			hash_data.put("milestone", milestone);
			hash_data.put("key_check", key_check);
			hash_data.put("status", cmd_status);
			hash_data.put("reason", cmd_reason);
			hash_data.put("location", (String) one_call_data.get(pool_attr.call_laudir));
			long start_time = (long) one_call_data.get(pool_attr.call_gentime);
			long current_time = System.currentTimeMillis() / 1000;
			hash_data.put("run_time", time_info.get_runtime_string_hms(start_time, current_time));
			hash_data.put("update_time", time_info.get_man_date_time());
			case_data.put(call_index, hash_data);
		}
		return case_data;
	}


    private String get_scan_result(ArrayList<String> cmd_output) {
        String scan_result = new String("");
        if (cmd_output == null || cmd_output.isEmpty()) {
            return scan_result;
        }
        Pattern p = Pattern.compile("^(\\{.+?\\})$");
        for (String line : cmd_output) {
            Matcher m = p.matcher(line);
            if (m.find()) {
                scan_result = m.group(1);
            }
        }
        return scan_result;
    }


	private HashMap<String, String> get_detail_report(ArrayList<String> cmd_output) {
		HashMap<String, String> report_data = new HashMap<String, String>();
		if (cmd_output == null || cmd_output.isEmpty()) {
			return report_data;
		}
		// <status>Passed</status>
		Pattern p = Pattern.compile("<(.+?)>(.+?)</");
		for (String line : cmd_output) {
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
		if(cmd_output == null || cmd_output.isEmpty()) {
			return task_status;
		}
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
		case "Case_Issue":
			task_status = task_enum.CASEISSUE;
			break;
		case "SW_Issue":
			task_status = task_enum.SWISSUE;
			break;		
		//web page no blocked status yet
		//case "Blocked":
		//	task_status = task_enum.FAILED; 
		//	break;
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
		// get failed check points :  <section result>
		Pattern section_patt = Pattern.compile("<\\s*?section\\s*?result\\s*?>\\s*?(.+?)\\s*?:\\s*?failed", Pattern.CASE_INSENSITIVE);
		ArrayList<String> failed_array = new ArrayList<String>();
		for (String line : cmd_output) {
			Matcher section_match = section_patt.matcher(line);
			if (section_match.find()){
				failed_array.add(section_match.group(1));
			}
		}
		if (failed_array.size() > 0){
			reason = "FC(s):" + String.join(",", failed_array);
		}
		// get failed error messages
		Pattern reason_patt = Pattern.compile("reason>(.+?)</");		
		for (String line : cmd_output) {
			if (!line.contains("<reason>")) {
				continue;
			}
			Matcher reason_match = reason_patt.matcher(line);
			if (reason_match.find()) {
				reason = reason_match.group(1);
			}
		}
		return reason;
	}

	private String get_milestone_info(ArrayList<String> cmd_output) {
		String milestone = new String("NA");
		if(cmd_output == null || cmd_output.isEmpty()){
			return milestone;
		}
		// <status>Passed</status>
		Pattern p = Pattern.compile("milestone\\s*>\\s*(.+?)$");
		for (String line : cmd_output) {
			Matcher m = p.matcher(line);
			if (m.find()) {
				milestone = m.group(1);
			}
		}
		return milestone;
	}	
	
	private String get_key_check_info(ArrayList<String> cmd_output) {
		String key_check = new String("NA");
		if(cmd_output == null || cmd_output.isEmpty()){
			return key_check;
		}
		// <status>Passed</status>
		Pattern p = Pattern.compile("key_check\\s*>\\s*(.+?)$");
		for (String line : cmd_output) {
			Matcher m = p.matcher(line);
			if (m.find()) {
				key_check = m.group(1);
			}
		}
		return key_check;
	}

    private String get_defects_info(ArrayList<String> cmd_output) {
        String defects = new String("");
        if(cmd_output == null || cmd_output.isEmpty()){
            return defects;
        }
        // <status>Passed</status>
        Pattern p = Pattern.compile("defects\\s*>\\s*(.+?)$");
        for (String line : cmd_output) {
            Matcher m = p.matcher(line);
            if (m.find()) {
                defects = m.group(1);
            }
        }
        return defects;
    }

    private String get_defects_history_info(ArrayList<String> cmd_output) {
        String defects_history = new String("NA");
        if (cmd_output == null || cmd_output.isEmpty()) {
            return defects_history;
        }
        // <status>Passed</status>
        Pattern p = Pattern.compile("defects_history\\s*>\\s*(.+?)$");
        for (String line : cmd_output) {
            Matcher m = p.matcher(line);
            if (m.find()) {
                defects_history = m.group(1);
            }
        }
        return defects_history;
    }

    private void terminate_user_request_running_call(){
    	// task1: this function works for both local and remote task queue stop request
		terminate_stopped_queue_running_task();
		// task2: terminate local user requested task case (from GUI)
		terminate_local_user_request_running_task();
		// task2: terminate remote user requested task case (from webpage)
		terminate_remote_user_request_running_task();    	
    }
    
	private Boolean terminate_local_user_request_running_task() {
		Boolean cancel_status = Boolean.valueOf(true);
		HashMap<String, ArrayList<String>> request_terminate_list = new HashMap<String, ArrayList<String>>();
		request_terminate_list.putAll(view_info.impl_request_terminate_list());
		if (request_terminate_list.isEmpty()){
			return cancel_status;
		}
		HashMap<String, HashMap<pool_attr, Object>> call_data = new HashMap<String, HashMap<pool_attr, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());
		Iterator<String> queue_it = request_terminate_list.keySet().iterator();
		while(queue_it.hasNext()){
			String queue_name = queue_it.next();
			ArrayList<String> case_list = new ArrayList<String>();
			case_list.addAll(request_terminate_list.get(queue_name));
			if (case_list.isEmpty()){
				continue;
			}
			Iterator<String> call_map_it = call_data.keySet().iterator();
			while (call_map_it.hasNext()) {
				String call_index = call_map_it.next();
				String call_name = (String) call_data.get(call_index).get(pool_attr.call_queue);
				String call_id = (String) call_data.get(call_index).get(pool_attr.call_case);
				call_state call_status = (call_state) call_data.get(call_index).get(pool_attr.call_status);
				if (!call_name.equalsIgnoreCase(queue_name)) {
					continue;
				}
				if (!case_list.contains(call_id)) {
					continue;
				}
				if (!call_status.equals(call_state.PROCESSIONG)) {
					continue;
				}
				cancel_status = pool_info.terminate_sys_call(call_index);
			}
		}
		return cancel_status;
	}

	private Boolean terminate_remote_user_request_running_task() {
		Boolean cancel_status = Boolean.valueOf(true);
		HashMap<String, HashMap<String, String>> request_data = new HashMap<String, HashMap<String, String>>();
		request_data.putAll(task_info.fetch_tasks_from_received_stop_queues_map());
		if (request_data == null || request_data.isEmpty()){
			return cancel_status;
		}
		HashMap<String, HashMap<pool_attr, Object>> call_data = new HashMap<String, HashMap<pool_attr, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			String call_id = (String) call_data.get(call_index).get(pool_attr.call_case);
			call_state call_status = (call_state) call_data.get(call_index).get(pool_attr.call_status);
			if (!request_data.containsKey(call_id)) {
				continue;
			}
			if (!call_status.equals(call_state.PROCESSIONG)) {
				continue;
			}
			cancel_status = pool_info.terminate_sys_call(call_index);
		}
		return cancel_status;
	}
	
	private Boolean terminate_stopped_queue_running_task() {
		Boolean cancel_status = Boolean.valueOf(true);
		ArrayList<String> stopped_admin_queue_list = new ArrayList<String>();
		stopped_admin_queue_list.addAll(task_info.get_stopped_admin_queue_list());
		HashMap<String, HashMap<pool_attr, Object>> call_data = new HashMap<String, HashMap<pool_attr, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			String call_name = (String) call_data.get(call_index).get(pool_attr.call_queue);
			call_state call_status = (call_state) call_data.get(call_index).get(pool_attr.call_status);
			if(!stopped_admin_queue_list.contains(call_name)){
				continue;
			}
			if (!call_status.equals(call_state.PROCESSIONG)) {
				continue;
			}
			cancel_status = pool_info.terminate_sys_call(call_index);
		}
		return cancel_status;
	}	

	private void generate_console_report(
			String waiter_name,
			HashMap<String, HashMap<String, Object>> case_report_map){
		HashMap<String, HashMap<pool_attr, Object>> call_data = new HashMap<String, HashMap<pool_attr, Object>>();
		call_data.putAll(pool_info.get_sys_call_copy());
		Iterator<String> call_map_it = call_data.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<pool_attr, Object> one_call_data = call_data.get(call_index);
			call_state call_status = (call_state) one_call_data.get(pool_attr.call_status);
			//remove call added after case_report_map generate
			if(!case_report_map.containsKey(call_index)){
				continue;
			}			
			// only done call will be release. timeout call will be get in
			// the next cycle(at that time status will be done)
			if (!call_status.equals(call_state.DONE)) {
				continue;
			}			
			String queue_name = (String) one_call_data.get(pool_attr.call_queue);
			String case_id = (String) one_call_data.get(pool_attr.call_case);
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
			switch_info.set_client_stop_exception(run_exception);
			switch_info.set_client_stop_request(exit_enum.DUMP);
		}
	}

	private void monitor_run() {
		// ============== All static job start from here ==============
		// this run cannot launch multiple threads
		result_thread = Thread.currentThread();
		String waiter_name = new String("RW");
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
			update_running_queue_list();	
			update_finished_queue_list();
			dump_finished_queue_report(); //generate csv report
			dump_finished_queue_data(); //to log dir xml file save memory
			// fresh data must start from here
			fresh_thread_pool_data(); //for all thread pools
			// following actions based on a non-empty call back.
			if (pool_info.get_sys_call_link() == null || pool_info.get_sys_call_link().size() < 1) {
				if(!switch_info.get_local_console_mode()){
					RESULT_WAITER_LOGGER.info(waiter_name + ":Thread Pool Empty...");
				}
				continue;
			}
			// task 2 : terminate running call
			terminate_user_request_running_call();
			// task 3 : general and send task report
			HashMap<String, HashMap<String, Object>> case_report_data = generate_case_report_data();
			HashMap<String, HashMap<String, String>> case_runtime_log_data = generate_case_runtime_log_data(case_report_data);
			report_obj.send_tube_task_data_report(case_report_data, true);			
			report_obj.send_tube_task_runtime_report(case_runtime_log_data);
			// task 4 : update memory case run summary
			generate_console_report(waiter_name, case_report_data);
			update_client_run_case_summary(case_report_data);
			// task 5 : update processed task data info
			update_processed_task_data(case_report_data);
			// task 6 : local report
			run_local_disk_report(case_report_data);
			// task 7 : run post process
			run_post_process(case_report_data);
			// task 8 : release occupied resource
			release_resource_usage();
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