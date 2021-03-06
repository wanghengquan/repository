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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.tube_server;
import connect_tube.task_data;
import data_center.client_data;
import data_center.data_server;
import data_center.switch_data;
import gui_interface.view_data;
import gui_interface.view_server;
import info_parser.cmd_parser;
import top_runner.run_status.exit_enum;
import utility_funcs.data_check;
import utility_funcs.des_encode;
import utility_funcs.mail_action;
import utility_funcs.time_info;
import data_center.public_data;

public class hall_manager extends Thread {
	// public property
	// protected property
	// private property
	private static final Logger HALL_MANAGER_LOGGER = LogManager.getLogger(hall_manager.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread current_thread;
	private switch_data switch_info;
	private task_data task_info;
	private client_data client_info;
	private pool_data pool_info;
	private view_data view_info;
	private post_data post_info;
	private String line_separator = System.getProperty("line.separator");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;
	private int local_cmd_exit_counter = 0;
	private int thread_auto_adjust_counter = 0;
	private ArrayList<Integer> client_history_cpu_list = new ArrayList<Integer>();
	private ArrayList<Integer> client_history_mem_list = new ArrayList<Integer>();
	// sub threads need to be launched
	HashMap<String, task_waiter> task_waiters;
	result_waiter waiter_result;
	// public function
	// protected function
	// private function

	public hall_manager(
			switch_data switch_info, 
			client_data client_info, 
			pool_data pool_info, 
			task_data task_info,
			view_data view_info,
			post_data post_info) {
		this.task_info = task_info;
		this.client_info = client_info;
		this.switch_info = switch_info;
		this.pool_info = pool_info;
		this.view_info = view_info;
		this.post_info = post_info;
	}

	private HashMap<String, task_waiter> get_task_waiter_ready() {
		HashMap<String, task_waiter> waiters = new HashMap<String, task_waiter>();
		int waiter_num = public_data.PERF_MAX_TASK_WAITER;
		for (int i = 0; i < waiter_num; i++) {
			task_waiter waiter = new task_waiter(i, switch_info, client_info, pool_info, task_info);
			String waiter_index = "waiter_" + String.valueOf(i);
			waiters.put(waiter_index, waiter);
			waiter.start();
			waiter.wake_request();
		}
		return waiters;
	}

	private void start_right_task_waiter(HashMap<String, task_waiter> waiters, int current_number) {
		int right_number = current_number;
		Set<String> waiter_set = waiters.keySet();
		Iterator<String> waiter_it = waiter_set.iterator();
		while (waiter_it.hasNext()) {
			String waiter_index = waiter_it.next();
			int waiter_id = Integer.valueOf(waiter_index.replace("waiter_", ""));
			task_waiter waiter = waiters.get(waiter_index);
			String waiter_status = waiter.get_waiter_status();
			HALL_MANAGER_LOGGER.debug(waiter_index + ":" + waiter_status);
			if (waiter_id < right_number) {
				if (waiter_status.equals("wait")) {
					waiter.wake_request();
				}
			} else {
				if (waiter_status.equals("work")) {
					waiter.wait_request();
				}
			}
		}
	}

	private result_waiter get_result_waiter_ready() {
		result_waiter waiter = new result_waiter(switch_info, client_info, pool_info, task_info, view_info, post_info);
		waiter.start();
		waiter.wake_request();
		return waiter;
	}

	private String get_client_runtime(){
		String start_time = new String("0");
		try{
			start_time = client_info.get_client_machine_data().get("start_time");
		} catch (Exception e){
			HALL_MANAGER_LOGGER.info("Get client start time failed.");
			return "NA";
		}
		String current_time = String.valueOf(System.currentTimeMillis() / 1000);
		return time_info.get_runtime_string_dhms(start_time, current_time);	
	}
	
	private void implement_task_blocker_actions(){
		HashMap<String, HashMap<task_enum, Integer>> summary_map = new HashMap<String, HashMap<task_enum, Integer>>();
		summary_map.putAll(task_info.get_client_run_case_summary_data_map());
		Iterator<String> queue_it = summary_map.keySet().iterator();
		while(queue_it.hasNext()){
			String queue_name = queue_it.next();
			Integer block_num = Integer.valueOf(0);
			HashMap<task_enum, Integer> queue_data = new HashMap<task_enum, Integer>();
			queue_data.putAll(summary_map.get(queue_name));
			block_num = queue_data.getOrDefault(task_enum.BLOCKED, 0);
			if (block_num < public_data.SEND_MAIL_TASK_BLOCK){
				continue;
			}
			if (task_info.get_warned_task_queue_list().contains(queue_name)){
				continue;
			}
			task_info.update_warned_task_queue_list(queue_name);
			//try to pause current running task
			ArrayList<String> processing_admin_queue_list = task_info.get_processing_admin_queue_list();
			//ArrayList<String> running_admin_queue_list = task_info.get_running_admin_queue_list();
			//if (running_admin_queue_list.contains(queue_name) || processing_admin_queue_list.contains(queue_name)) {
			if (processing_admin_queue_list.contains(queue_name)) {
				task_info.update_task_queue_for_processed_task_queues_map(queue_name, task_enum.WAITING, task_enum.HALTED);
				task_info.mark_queue_in_received_admin_queues_treemap(queue_name, queue_enum.PAUSED);
			}			
			//send warning mail
			send_warnning_mail(queue_name);
		}
	}
	
	private void send_warnning_mail(String queue_name){
		String events = new String("Too many run blocks encountered.");
		StringBuilder message = new StringBuilder("");
		message.append("Hi TMP Operators:" + line_separator);
		message.append("This Mail is send to you automatically due to ");
		message.append("TMP Client encountered too many blocks in one task queue.");
		message.append(line_separator);
		message.append("Machine:" + client_info.get_client_machine_data().get("terminal"));
		message.append(line_separator);
		message.append("Task Queue:" + queue_name + line_separator);
		message.append("Possible Reasons: System resource issue, Case issue..." + line_separator);
		message.append(line_separator);
		message.append(line_separator);
		message.append("TMP client will try to pause it locally." + line_separator);
		message.append("Please have time to check this issue." + line_separator);
		message.append(line_separator);
		message.append("Thanks" + line_separator);
		message.append("TMP Client" + line_separator);
		String to_str = new String(public_data.BASE_OPERATOR_MAIL);
		to_str = client_info.get_client_preference_data().get("opr_mails");
		mail_action.simple_event_mail(events, to_str, message.toString());
	}
	
	private HashMap<task_enum, String> get_client_run_case_summary(){
		HashMap<task_enum, String> run_summary = new HashMap<task_enum, String>();
		Integer pass_num = Integer.valueOf(0);
		Integer fail_num = Integer.valueOf(0);
		Integer tbd_num = Integer.valueOf(0);
		Integer timeout_num = Integer.valueOf(0);
		Integer others_num = Integer.valueOf(0);
		HashMap<String, HashMap<task_enum, Integer>> summary_map = new HashMap<String, HashMap<task_enum, Integer>>();
		summary_map.putAll(task_info.get_client_run_case_summary_data_map());
		Iterator<String> queue_it = summary_map.keySet().iterator();
		while(queue_it.hasNext()){
			String queue_name = queue_it.next();
			HashMap<task_enum, Integer> queue_data = new HashMap<task_enum, Integer>();
			queue_data.putAll(summary_map.get(queue_name));
			pass_num = pass_num + queue_data.getOrDefault(task_enum.PASSED, 0);
			fail_num = fail_num + queue_data.getOrDefault(task_enum.FAILED, 0);
			tbd_num = tbd_num + queue_data.getOrDefault(task_enum.TBD, 0);
			timeout_num = timeout_num + queue_data.getOrDefault(task_enum.TIMEOUT, 0);
			others_num = others_num + queue_data.getOrDefault(task_enum.OTHERS, 0);
		}
		run_summary.put(task_enum.PASSED, pass_num.toString());
		run_summary.put(task_enum.FAILED, fail_num.toString());
		run_summary.put(task_enum.TBD, tbd_num.toString());
		run_summary.put(task_enum.TIMEOUT, timeout_num.toString());
		run_summary.put(task_enum.OTHERS, others_num.toString() );
		return run_summary;
	}	
	
	private void implement_general_console_report() {
		// skip for local console mode
		if(switch_info.get_local_console_mode()){
			return;
		}
		// report processing queue list
		int show_queue_number = 6;
		HALL_MANAGER_LOGGER.info("");
		HALL_MANAGER_LOGGER.info(">>>==========Console Report==========");
		HALL_MANAGER_LOGGER.info(">>>Run  time:" + get_client_runtime());		
		HALL_MANAGER_LOGGER.info(">>>Run  mode:" + client_info.get_client_preference_data().get("cmd_gui"));
		HALL_MANAGER_LOGGER.info(">>>link mode:" + client_info.get_client_preference_data().get("link_mode"));
		// report Captured queue list
		ArrayList<String> captured_queue_list = new ArrayList<String>();
		captured_queue_list.addAll(task_info.get_captured_admin_queues_treemap().keySet());
		if (captured_queue_list.size() > show_queue_number){
			HALL_MANAGER_LOGGER.info(">>>Captured queue:" + captured_queue_list.subList(0, 3).toString() + "...");
		} else {
			HALL_MANAGER_LOGGER.info(">>>Captured queue:" + captured_queue_list.toString());
		}
		// report processing queue list
		ArrayList<String> processing_queue_list = new ArrayList<String>();
		processing_queue_list.addAll(task_info.get_processing_admin_queue_list());
		if (processing_queue_list.size() > show_queue_number){
			HALL_MANAGER_LOGGER.info(">>>Processing queue:" + processing_queue_list.subList(0, 3).toString() + "...");
		} else {
			HALL_MANAGER_LOGGER.info(">>>Processing queue:" + processing_queue_list.toString());
		}
		// report executing queue list
		ArrayList<String> executing_queue_list = new ArrayList<String>();
		executing_queue_list.addAll(task_info.get_executing_admin_queue_list());
		if (executing_queue_list.size() > show_queue_number){
			HALL_MANAGER_LOGGER.info(">>>Executing queue:" + executing_queue_list.subList(0, 3).toString() + "...");
		} else {
			HALL_MANAGER_LOGGER.info(">>>Executing queue:" + executing_queue_list.toString());
		}		
		// report running queue list
		ArrayList<String> running_queue_list = new ArrayList<String>();
		running_queue_list.addAll(task_info.get_running_admin_queue_list());
		if (running_queue_list.size() > show_queue_number){
			HALL_MANAGER_LOGGER.info(">>>Running queue:" + running_queue_list.subList(0, 3).toString() + "...");
		} else {
			HALL_MANAGER_LOGGER.info(">>>Running queue:" + running_queue_list.toString());
		}
		// report finished queue list
		ArrayList<String> finished_queue_list = new ArrayList<String>();
		finished_queue_list.addAll(task_info.get_finished_admin_queue_list());
		if (finished_queue_list.size() > show_queue_number){
			HALL_MANAGER_LOGGER.info(">>>Finished queue:" + finished_queue_list.subList(0, 3).toString() + "...");
		} else {
			HALL_MANAGER_LOGGER.info(">>>Finished queue:" + finished_queue_list.toString());
		}
		// report thread using
		String max_thread = String.valueOf(pool_info.get_pool_current_size());
		String used_thread = String.valueOf(pool_info.get_pool_used_threads());
		HALL_MANAGER_LOGGER.info(">>>Used Thread:" + used_thread + "/" + max_thread);
		HALL_MANAGER_LOGGER.info(">>>Run Summary:" + get_client_run_case_summary());
		HALL_MANAGER_LOGGER.info(">>>==================================");
		HALL_MANAGER_LOGGER.info("");
		HALL_MANAGER_LOGGER.debug(client_info.get_used_soft_insts());
		HALL_MANAGER_LOGGER.debug(client_info.get_max_soft_insts());
		HALL_MANAGER_LOGGER.debug(client_info.get_available_software_insts());
		HALL_MANAGER_LOGGER.debug(client_info.get_client_data().toString());
	}
	
	private void implement_local_cmd_mode_exit(){
		if (!switch_info.get_local_console_mode()){
			return;
		}
		if (task_info.get_local_file_finished_task_map().size() < task_info.get_local_file_imported_task_map().size()){
			return;
		}
		if (task_info.get_local_path_finished_task_map().size() < task_info.get_local_path_imported_task_map().size()){
			return;
		}
		if (!task_info.get_processing_admin_queue_list().isEmpty()){
			return;
		}
		if (pool_info.get_pool_used_threads() > 0){
			return;
		}
		//make exit report
		local_cmd_exit_counter++;
		if (local_cmd_exit_counter < 3){ //3 * 2 * base_interval
			return;
		}
		local_cmd_exit_counter = 0;
		generate_exit_report();
		HashMap<task_enum, String> run_summary = get_client_run_case_summary();
		if(Integer.valueOf(run_summary.get(task_enum.FAILED)) > 0 ){
			switch_info.set_client_stop_request(exit_enum.TASK2);
		} else if(Integer.valueOf(run_summary.get(task_enum.TBD)) > 0 ){
			switch_info.set_client_stop_request(exit_enum.TASK1);
		} else {
			switch_info.set_client_stop_request(exit_enum.NORMAL);
		}
	}
	
	private void implement_thread_auto_adjustment(){
		HashMap<String, String> preference_data = new HashMap<String, String>();
		preference_data.putAll(client_info.get_client_preference_data());
		if (preference_data.get("thread_mode").equals("manual")){
			return;
		}
		//only when executing queue list not empty, this feature work
		ArrayList<String> executing_queue_list = new ArrayList<String>();
		executing_queue_list.addAll(task_info.get_executing_admin_queue_list());
		if(executing_queue_list.isEmpty()){
			return;
		}
		//check thread limitation
		HashMap<String, HashMap<String, String>> requrement_map = new HashMap<String, HashMap<String, String>>();
		requrement_map.putAll(task_info.get_processing_queue_system_requrement_map());
		//max threads setting.
		int task_threads = 0; //no limitation
		for (String queue_name : executing_queue_list) {
			HashMap<String, String> request_data = new HashMap<String, String>();
			request_data.putAll(requrement_map.get(queue_name));
			int request_value = get_srting_int(request_data.get("max_threads"), "^(\\d+)$");
			if (request_value > task_threads) {
				task_threads = request_value;
			}
		}
		if (task_threads > 0) {
			HALL_MANAGER_LOGGER.warn("Task threads limitation found 'Thread auto adjustment feature' disabled.");
			return;
		}
		//system info record if not successfully record, skip this point
		if (!current_system_info_record()){
			return;
		}
		thread_auto_adjust_counter += 1;
		if(thread_auto_adjust_counter <= public_data.PERF_AUTO_ADJUST_CYCLE){
			return;// adjust cycle = 6 * 10 seconds
		}
		//only when used thread >= pool_curent_size, this feature work
		int max_thread = pool_info.get_pool_current_size();
		int used_thread = pool_info.get_pool_used_threads();
		int cpu_avgs = get_integer_list_average(client_history_cpu_list);
		int mem_avgs = get_integer_list_average(client_history_mem_list);
		if(cpu_avgs == 0 || mem_avgs ==0){
			//empty data find, skip adjustment
			cleanup_auto_adjust_record();
			return;
		}
		if(cpu_avgs > public_data.PERF_AUTO_MAXIMUM_CPU && mem_avgs > public_data.PERF_AUTO_MAXIMUM_MEM){
			if (used_thread <= max_thread){
				decrease_max_thread();
			}
		} 
		if (cpu_avgs < public_data.PERF_AUTO_MAXIMUM_CPU && mem_avgs < public_data.PERF_AUTO_MAXIMUM_MEM){
			if (used_thread >= max_thread){
				increase_max_thread();
			}			
		}
		cleanup_auto_adjust_record();	
	}
	
	private void decrease_max_thread(){
		int current_max_thread = pool_info.get_pool_current_size();
		int new_max_thread = current_max_thread - 1;
		if (new_max_thread > 0){
			pool_info.set_pool_current_size(new_max_thread);
		}
	}
	
	private void increase_max_thread(){
		int current_max_thread = pool_info.get_pool_current_size();
		int new_max_thread = current_max_thread + 1;
		if (new_max_thread <= pool_info.get_pool_maximum_size()){
			pool_info.set_pool_current_size(new_max_thread);
		}
	}
	
	private void reset_default_max_thread(){
		int max_thread = pool_info.get_pool_current_size();
		int used_thread = pool_info.get_pool_used_threads();
		String default_max_threads = client_info.get_client_preference_data().get("max_threads");
		int def_thread = Integer.parseInt(default_max_threads);
		if (used_thread > 0){
			return;
		}
		if (max_thread == def_thread){
			return;//already reseted
		}
		pool_info.set_pool_current_size(def_thread);
	}
	
	private int get_integer_list_average(ArrayList<Integer> integer_list){
		int list_num = integer_list.size();
		if (list_num == 0){
			return 0;
		}
		int list_sum = 0;
		for(Integer data: integer_list){
			list_sum += data;
		}
		int list_avg = list_sum / list_num;
		return list_avg;
	}
	
	private void cleanup_auto_adjust_record(){
		thread_auto_adjust_counter = 0;
		client_history_cpu_list.clear();
		client_history_mem_list.clear();
	}
	
	private Boolean current_system_info_record(){
		Boolean record_status = Boolean.valueOf(true);
		HashMap<String, String> system_data = new HashMap<String, String>();
		system_data.putAll(client_info.get_client_system_data());
		String cpu_usage = system_data.get("cpu");
		String mem_usage = system_data.get("mem");
		Integer cpu_integer = Integer.valueOf(0);
		Integer mem_integer = Integer.valueOf(0);
		try{
			cpu_integer = Integer.valueOf(cpu_usage);
			mem_integer = Integer.valueOf(mem_usage);
		} catch (Exception e) {
			HALL_MANAGER_LOGGER.warn("Cannot parser CPU/MEM value.");
			record_status = false;
			return record_status;
		}
		client_history_cpu_list.add(cpu_integer);
		client_history_mem_list.add(mem_integer);
		return record_status;
	}
	
	private String get_report_file_path(
			String queue_name){
		//get report file path
		String report_file_path = new String("");
		String work_space = new String(client_info.get_client_preference_data().get("work_space"));
		File work_space_fobj = new File(work_space);
		if (!work_space_fobj.exists()) {
			HALL_MANAGER_LOGGER.warn("Work space do not exists:" + work_space);
			return report_file_path;
		}		
		HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
		admin_data.putAll(task_info.get_queue_data_from_processed_admin_queues_treemap(queue_name));
		if (admin_data.isEmpty()){
			admin_data.putAll(task_info.get_queue_data_from_received_admin_queues_treemap(queue_name));
		}
		if (admin_data.isEmpty()){
			HALL_MANAGER_LOGGER.warn("No admin data found for queue:" + queue_name);
			return report_file_path;			
		}
		String tmp_result_dir = public_data.WORKSPACE_RESULT_DIR;
		String prj_dir_name = "prj" + admin_data.get("ID").get("project");
		String run_dir_name = "run" + admin_data.get("ID").get("run");
		String report_name = run_dir_name + ".csv";
		String[] path_array = new String[] { work_space, tmp_result_dir, prj_dir_name, run_dir_name, report_name};
		report_file_path = String.join(System.getProperty("file.separator"), path_array);
		report_file_path = report_file_path.replaceAll("\\\\", "/");
		return report_file_path;
	}
	
	private String get_run_suite_data_string(
			String queue_name){
		String result_string = new String("");
		HashMap<String, HashMap<task_enum, Integer>> summary_map = new HashMap<String, HashMap<task_enum, Integer>>();
		summary_map.putAll(task_info.get_client_run_case_summary_data_map());
		HashMap<task_enum, Integer> run_queue_data = new HashMap<task_enum, Integer>();
		if (summary_map.containsKey(queue_name)){
			run_queue_data.putAll(summary_map.get(queue_name));
		} else {
			HALL_MANAGER_LOGGER.warn("No run data found for :" + queue_name);
			return result_string;
		}
		result_string = run_queue_data.toString();
		return result_string;
	}
	
	private String get_run_suite_final_result(
			String queue_name){
		String run_result = new String("");
		HashMap<String, HashMap<task_enum, Integer>> summary_map = new HashMap<String, HashMap<task_enum, Integer>>();
		summary_map.putAll(task_info.get_client_run_case_summary_data_map());
		HashMap<task_enum, Integer> run_queue_data = new HashMap<task_enum, Integer>();
		if (summary_map.containsKey(queue_name)){
			run_queue_data.putAll(summary_map.get(queue_name));
		} else {
			HALL_MANAGER_LOGGER.warn("No run data found for :" + queue_name);
			return run_result;
		}
		Integer pass_num = run_queue_data.getOrDefault(task_enum.PASSED, 0);
		Integer fail_num = run_queue_data.getOrDefault(task_enum.FAILED, 0);
		Integer tbd_num = run_queue_data.getOrDefault(task_enum.TBD, 0);
		Integer timeout_num = run_queue_data.getOrDefault(task_enum.TIMEOUT, 0);
		Integer others_num = run_queue_data.getOrDefault(task_enum.OTHERS, 0);
		Integer total_num = pass_num + fail_num + tbd_num + timeout_num + others_num;
		if (total_num < 1){
			run_result = "Unknown";
		}else if (fail_num > 0){
			run_result = "Failed";
		}else if (pass_num < 1){
			run_result = "Failed";
		} else {
			run_result = "Passed";
		}
		return run_result;
	}
	
	private String get_task_queue_run_id(
			String queue_name){
		String run_id = new String("Unknown Issue");
		HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
		admin_data.putAll(task_info.get_queue_data_from_processed_admin_queues_treemap(queue_name));
		if (admin_data.isEmpty()){
			admin_data.putAll(task_info.get_queue_data_from_received_admin_queues_treemap(queue_name));
		}
		if (admin_data.isEmpty()){
			HALL_MANAGER_LOGGER.warn("No queue data found for Run ID generate:" + queue_name);
			run_id = "No queue data found for Run ID generate.";
			return run_id;			
		}
		String run_suite_name = admin_data.get("ID").get("suite");
		String run_suite_result = get_run_suite_final_result(queue_name);
		String encode_string = run_suite_name + "_" + get_run_suite_data_string(queue_name) + "_" + time_info.get_date_time();
		String encryption_code = "unknown";
		try {
			encryption_code = des_encode.encrypt(encode_string, public_data.ENCRY_KEY);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		run_id = run_suite_name + "_" + run_suite_result + "_<" + encryption_code + ">";
		return run_id;
	}
	
	private void generate_exit_report() {
		// report processing queue list
		HALL_MANAGER_LOGGER.info(">>>==========Exit Report==========");
		HALL_MANAGER_LOGGER.info(">>>Run  time:" + get_client_runtime());		
		HALL_MANAGER_LOGGER.info(">>>Run  mode:" + client_info.get_client_preference_data().get("cmd_gui"));
		HALL_MANAGER_LOGGER.info(">>>link mode:" + client_info.get_client_preference_data().get("link_mode"));
		HALL_MANAGER_LOGGER.info(">>>Finished queue(s): " + task_info.get_client_run_case_summary_data_map().size());
		for (String queue_name: task_info.get_client_run_case_summary_data_map().keySet()){
			HALL_MANAGER_LOGGER.info(">>>Run    Task:" + queue_name);
			HALL_MANAGER_LOGGER.info(">>>Task Report:" + get_report_file_path(queue_name));
			HALL_MANAGER_LOGGER.info(">>>Submit Code:" + get_task_queue_run_id(queue_name));
			HALL_MANAGER_LOGGER.info(">>>");
		}
		HashMap<task_enum, String> run_summary = get_client_run_case_summary();
		HALL_MANAGER_LOGGER.info(">>>Run Summary:" + run_summary);
		if(Integer.valueOf(run_summary.get(task_enum.FAILED)) > 0 ){
			HALL_MANAGER_LOGGER.info(">>>Client will exit with code 2.");
		} else if(Integer.valueOf(run_summary.get(task_enum.TBD)) > 0 ){
			HALL_MANAGER_LOGGER.info(">>>Client will exit with code 1.");
		} else {
			HALL_MANAGER_LOGGER.info(">>>Client will exit with code 0.");
		}
		HALL_MANAGER_LOGGER.info(">>>===============================");
	}
	
	private void update_processing_queue_system_requrement_map() {
		HashMap<String, HashMap<String, String>> updated_request_map = new HashMap<String, HashMap<String, String>>();
		for(String queue_name: task_info.get_processing_admin_queue_list()) {
			HashMap<String, String> request_map = new HashMap<String, String>();
			HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
			admin_data.putAll(task_info.get_data_from_captured_admin_queues_treemap(queue_name));
			//max threads request
			String max_threads = new String(public_data.TASK_DEF_MAX_THREADS);
			if (!admin_data.containsKey("Preference")) {
				max_threads = public_data.TASK_DEF_MAX_THREADS;
			} else if (!admin_data.get("Preference").containsKey("max_threads")) {
				max_threads = public_data.TASK_DEF_MAX_THREADS;
			} else {
				max_threads = admin_data.get("Preference").get("max_threads");
				Pattern p = Pattern.compile("^\\d$");
				Matcher m = p.matcher(max_threads);
				if (!m.find()) {
					max_threads = public_data.TASK_DEF_MAX_THREADS;
				}
			}
			request_map.put("max_threads", max_threads);
			//host restart request
			String host_restart = new String(public_data.TASK_DEF_HOST_RESTART);
			if (!admin_data.containsKey("Preference")) {
				host_restart = public_data.TASK_DEF_HOST_RESTART;
			} else if (!admin_data.get("Preference").containsKey("host_restart")) {
				host_restart = public_data.TASK_DEF_HOST_RESTART;
			} else {
				String request_value = new String(admin_data.get("Preference").get("host_restart").trim());
				if (!data_check.str_choice_check(request_value, new String [] {"false", "true"} )){
					HALL_MANAGER_LOGGER.warn(queue_name + ":has wrong Preference->host_restart, default value " + public_data.TASK_DEF_HOST_RESTART + " used.");
				} else {
					host_restart = request_value;
				}				
			}
			request_map.put("host_restart", host_restart);
			updated_request_map.put(queue_name, request_map);
		}
		task_info.reset_processing_queue_system_requrement_map();
		task_info.update_processing_queue_system_requrement_map(updated_request_map);
	}
	
	private ArrayList<String> generate_executing_admin_queue_list(){
		ArrayList<String> executing_list = new ArrayList<String>();
		HashMap<String, HashMap<String, String>> requrement_map = new HashMap<String, HashMap<String, String>>();
		requrement_map.putAll(task_info.get_processing_queue_system_requrement_map());
		//get highest thread request queue
		int record_data = 0;
		for (String queue_name : requrement_map.keySet()) {
			HashMap<String, String> queue_data = new HashMap<String, String>();
			queue_data.putAll(requrement_map.get(queue_name));
			int queue_value = get_srting_int(queue_data.get("max_threads"), "^(\\d+)$");
			if (queue_value > record_data) {
				record_data = queue_value;
			}
		}
		//get executing queue list
		for (String queue_name : requrement_map.keySet()) {
			HashMap<String, String> queue_data = new HashMap<String, String>();
			queue_data.putAll(requrement_map.get(queue_name));
			if (queue_data.get("max_threads").equalsIgnoreCase(String.valueOf(record_data))) {
				executing_list.add(queue_name);
			}
		}
		return executing_list;
	}
	
	private int get_srting_int(String str, String patt) {
		int i = 0;
		try {
			Pattern p = Pattern.compile(patt);
			Matcher m = p.matcher(str);
			if (m.find()) {
				i = Integer.valueOf(m.group(1));
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}
		return i;
	}
	
	private void update_run_environment(
			ArrayList<String> executing_list
			) {
		//Idle status go to default status
		if (executing_list.isEmpty()) {
			reset_default_max_thread();
			return;
		}
		HashMap<String, HashMap<String, String>> requrement_map = new HashMap<String, HashMap<String, String>>();
		requrement_map.putAll(task_info.get_processing_queue_system_requrement_map());
		//max threads setting.
		int max_threads = 0;
		for (String queue_name : executing_list) {
			HashMap<String, String> request_data = new HashMap<String, String>();
			request_data.putAll(requrement_map.get(queue_name));
			int request_value = get_srting_int(request_data.get("max_threads"), "^(\\d+)$");
			if (request_value > max_threads) {
				max_threads = request_value;
			}
		}
		if (max_threads > 0 && max_threads <= pool_info.get_pool_maximum_size()) {
			pool_info.set_pool_current_size(max_threads);
		}
		//host restart if need.
		Boolean host_restart = Boolean.valueOf(false);		
		for (String queue_name : executing_list) {
			HashMap<String, String> request_data = new HashMap<String, String>();
			request_data.putAll(requrement_map.get(queue_name));
			String request_value = request_data.get("host_restart");
			if (request_value.equals("false")) {
				continue;
			}
			//admin queue with host restart needed
			HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
			queue_data.putAll(task_info.get_data_from_captured_admin_queues_treemap(queue_name));
			String admin_time = new String("");
			if (!queue_data.containsKey("ID")) {
				continue;
			} 
			if (!queue_data.get("ID").containsKey("epoch_time")) {
				continue;
			}
			admin_time = queue_data.get("ID").get("epoch_time");
			if(is_restart_needed(admin_time)) {
				host_restart = true;
				break;
			}
		}
		if (host_restart) {
	    	String os = System.getProperty("os.name").toLowerCase();
			if (os.contains("windows")) {
				HALL_MANAGER_LOGGER.warn("Host restart...");
				switch_info.set_client_stop_request(exit_enum.HRL);
				switch_info.set_client_soft_stop_request(true);				
			} else {
				HALL_MANAGER_LOGGER.warn("Host restart not support on Linux side.");
			}
		}
		//other environment build.
	}
	
	private Boolean is_restart_needed(
			String admin_time_string
			) {
		long admin_time = 0;
		long current_time = System.currentTimeMillis() / 1000;
		Pattern p = Pattern.compile("^(\\d+)$");
		Matcher m = p.matcher(admin_time_string);
		if (m.find()) {
			admin_time = Long.valueOf(m.group(1));
		} else {
			HALL_MANAGER_LOGGER.warn("Wrong admin epoch_time:" + admin_time_string);
		}
		//Check admin time, if old admin queue, no restart needed
		if (current_time - admin_time > public_data.TASK_DEF_RESTART_IDENTIFY_THRESHOLD) {
			return false;
		}
		//Check host runtime, if less than 3600 no restart needed
		String start_time = client_info.get_client_machine_data().get("start_time");
		long begin_time = Long.valueOf(start_time);
		if (current_time - begin_time > public_data.TASK_DEF_RESTART_SYSTEM_THRESHOLD) {
			return true;
		} else {
			return false;
		}
	}
	
	private void job_environment_build() {
		//task 1: update processing queue system requirement hash map
		update_processing_queue_system_requrement_map();
		//task 2: generate executing queue list
		ArrayList<String> executing_queue_list = new ArrayList<String>();
		executing_queue_list.addAll(generate_executing_admin_queue_list());
		//task 3: run environment update(thread pool, task waiter)
		update_run_environment(executing_queue_list);
		//task 4: release executing queue list(for task waiters use)
		task_info.set_executing_admin_queue_list(executing_queue_list);
	}
	
	private void job_implementation_monitor() {
		// task 1 : Maximum threads adjustment
		implement_thread_auto_adjustment();
		// task 2 : Send mail for task queue with too many blockers
		implement_task_blocker_actions();
	}
	
	private void job_report_generation() {
		// task 1 : make general report for non local console mode
		implement_general_console_report();
		// task 2 : exit apply for local command line mode
		implement_local_cmd_mode_exit();
	}
	
	private void stop_sub_threads() {
		waiter_result.soft_stop();
		Iterator<String> waiters_it = task_waiters.keySet().iterator();
		while (waiters_it.hasNext()) {
			String waiter_name = waiters_it.next();
			task_waiter waiter = task_waiters.get(waiter_name);
			waiter.soft_stop();
		}
	}

	private void wait_sub_threads(){
		waiter_result.wait_request();
		Iterator<String> waiters_it = task_waiters.keySet().iterator();
		while (waiters_it.hasNext()) {
			String waiter_name = waiters_it.next();
			task_waiter waiter = task_waiters.get(waiter_name);
			waiter.wait_request();
		}		
	}
	
	private void wake_sub_threads(){
		waiter_result.wake_request();
		start_right_task_waiter(task_waiters, pool_info.get_pool_current_size());
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
		current_thread = Thread.currentThread();
		// ============== All static job start from here ==============
		// initial 1 : start task waiters
		task_waiters = get_task_waiter_ready();
		// initial 2 : start result waiter
		waiter_result = get_result_waiter_ready();
		// initial 3 : Announce hall server ready
		switch_info.set_hall_server_power_up();
		HALL_MANAGER_LOGGER.info("Work Space:" + client_info.get_client_preference_data().get("work_space"));
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
				HALL_MANAGER_LOGGER.debug("hall manager Thread running...");
			}
			// ============== All dynamic job start from here ==============
			//task 1: build system environment according admin queues
			job_environment_build();
			//task 2: monitor
			job_implementation_monitor();
			//task 3: run environment update(thread pool, task waiter)
			job_report_generation();
			try {
				Thread.sleep(base_interval * 2 * 1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public void soft_stop() {
		stop_sub_threads();
		stop_request = true;
	}

	public void hard_stop() {
		stop_sub_threads();
		stop_request = true;
		if (current_thread != null) {
			current_thread.interrupt();
		}
	}

	public void wait_request() {
		wait_sub_threads();
		wait_request = true;
	}

	public void wake_request() {
		wake_sub_threads();
		wait_request = false;
		synchronized (this) {
			this.notify();
		}
	}

	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		cmd_parser cmd_run = new cmd_parser(args);
		HashMap<String, String> cmd_info = cmd_run.cmdline_parser();
		switch_data switch_info = new switch_data();
		task_data task_info = new task_data();
		client_data client_info = new client_data();
		view_data view_info = new view_data();
		post_data post_info = new post_data();
		pool_data pool_info = new pool_data(public_data.PERF_POOL_MAXIMUM_SIZE);
		view_server view_runner = new view_server(cmd_info, switch_info, client_info, task_info, view_info, pool_info, post_info);
		view_runner.start();
		data_server data_runner = new data_server(cmd_info, switch_info, client_info, pool_info);
		data_runner.start();
		while (true) {
			if (switch_info.get_data_server_power_up()) {
				System.out.println(">>>data server power up");
				break;
			}
		}
		tube_server tube_runner = new tube_server(cmd_info, switch_info, client_info, pool_info, task_info);
		tube_runner.start();
		while (true) {
			if (switch_info.get_tube_server_power_up()) {
				System.out.println(">>>tube server power up");
				break;
			}
		}
		hall_manager jason = new hall_manager(switch_info, client_info, pool_info, task_info, view_info, post_info);
		jason.start();
		try {
			Thread.sleep(10 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// jason.soft_stop();
		HALL_MANAGER_LOGGER.warn(">>>Used Thread:" + "jason stopped");
		// tube_runner.soft_stop();
		HALL_MANAGER_LOGGER.warn(">>>Used Thread:" + "tube_runner stopped");
		// data_runner.soft_stop();
		HALL_MANAGER_LOGGER.warn(">>>Used Thread:" + "data_runner stopped");
	}
}