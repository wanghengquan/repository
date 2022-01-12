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
import top_runner.run_manager.thread_enum;
import top_runner.run_status.exit_enum;
import utility_funcs.data_check;
import utility_funcs.deep_clone;
import utility_funcs.des_encode;
import utility_funcs.file_action;
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
	private boolean auto_adjust = false;
	private boolean auto_adjust_thread_match = false;
	private Integer auto_adjust_prvious_finish = 0;
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
	HashMap<String, task_waiter> task_runners;
	result_waiter result_runner;
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
		summary_map.putAll(task_info.get_client_run_case_summary_status_map());
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
		Integer swissue_num = Integer.valueOf(0);
		Integer caseissue_num = Integer.valueOf(0);
		Integer tbd_num = Integer.valueOf(0);
		Integer timeout_num = Integer.valueOf(0);
		Integer others_num = Integer.valueOf(0);
		HashMap<String, HashMap<task_enum, Integer>> summary_map = new HashMap<String, HashMap<task_enum, Integer>>();
		summary_map.putAll(task_info.get_client_run_case_summary_status_map());
		Iterator<String> queue_it = summary_map.keySet().iterator();
		while(queue_it.hasNext()){
			String queue_name = queue_it.next();
			HashMap<task_enum, Integer> queue_data = new HashMap<task_enum, Integer>();
			queue_data.putAll(summary_map.get(queue_name));
			pass_num = pass_num + queue_data.getOrDefault(task_enum.PASSED, 0);
			fail_num = fail_num + queue_data.getOrDefault(task_enum.FAILED, 0);
			swissue_num = swissue_num + queue_data.getOrDefault(task_enum.SWISSUE, 0);
			caseissue_num = caseissue_num + queue_data.getOrDefault(task_enum.CASEISSUE, 0);
			tbd_num = tbd_num + queue_data.getOrDefault(task_enum.TBD, 0);
			timeout_num = timeout_num + queue_data.getOrDefault(task_enum.TIMEOUT, 0);
			others_num = others_num + queue_data.getOrDefault(task_enum.OTHERS, 0);
		}
		run_summary.put(task_enum.PASSED, pass_num.toString());
		run_summary.put(task_enum.FAILED, fail_num.toString());
		run_summary.put(task_enum.SWISSUE, swissue_num.toString());
		run_summary.put(task_enum.CASEISSUE, caseissue_num.toString());
		run_summary.put(task_enum.TBD, tbd_num.toString());
		run_summary.put(task_enum.TIMEOUT, timeout_num.toString());
		run_summary.put(task_enum.OTHERS, others_num.toString());
		return run_summary;
	}	
	
	private HashMap<task_enum, Integer> get_client_run_case_summary_int(){
		HashMap<task_enum, Integer> run_summary = new HashMap<task_enum, Integer>();
		Integer pass_num = Integer.valueOf(0);
		Integer fail_num = Integer.valueOf(0);
		Integer swissue_num = Integer.valueOf(0);
		Integer caseissue_num = Integer.valueOf(0);		
		Integer tbd_num = Integer.valueOf(0);
		Integer timeout_num = Integer.valueOf(0);
		Integer others_num = Integer.valueOf(0);
		HashMap<String, HashMap<task_enum, Integer>> summary_map = new HashMap<String, HashMap<task_enum, Integer>>();
		summary_map.putAll(task_info.get_client_run_case_summary_status_map());
		Iterator<String> queue_it = summary_map.keySet().iterator();
		while(queue_it.hasNext()){
			String queue_name = queue_it.next();
			HashMap<task_enum, Integer> queue_data = new HashMap<task_enum, Integer>();
			queue_data.putAll(summary_map.get(queue_name));
			pass_num = pass_num + queue_data.getOrDefault(task_enum.PASSED, 0);
			fail_num = fail_num + queue_data.getOrDefault(task_enum.FAILED, 0);
			swissue_num = swissue_num + queue_data.getOrDefault(task_enum.SWISSUE, 0);
			caseissue_num = caseissue_num + queue_data.getOrDefault(task_enum.CASEISSUE, 0);			
			tbd_num = tbd_num + queue_data.getOrDefault(task_enum.TBD, 0);
			timeout_num = timeout_num + queue_data.getOrDefault(task_enum.TIMEOUT, 0);
			others_num = others_num + queue_data.getOrDefault(task_enum.OTHERS, 0);
		}
		run_summary.put(task_enum.PASSED, pass_num);
		run_summary.put(task_enum.FAILED, fail_num);
		run_summary.put(task_enum.SWISSUE, swissue_num);
		run_summary.put(task_enum.CASEISSUE, caseissue_num);		
		run_summary.put(task_enum.TBD, tbd_num);
		run_summary.put(task_enum.TIMEOUT, timeout_num);
		run_summary.put(task_enum.OTHERS, others_num);
		return run_summary;
	}
	
	private Integer get_client_current_run_case_number() {
		Integer total = Integer.valueOf(0);
		HashMap<task_enum, Integer> run_data = new HashMap<task_enum, Integer>();
		run_data.putAll(get_client_run_case_summary_int());
		Iterator<task_enum> state_it = run_data.keySet().iterator();
		while(state_it.hasNext()){
			task_enum current_state = state_it.next();
			Integer current_num = run_data.getOrDefault(current_state, 0);
			total = total + current_num;
		}
		return total;
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
		//HALL_MANAGER_LOGGER.info(">>>Run  mode:" + client_info.get_client_preference_data().get("interface_mode"));
		//HALL_MANAGER_LOGGER.info(">>>link mode:" + client_info.get_client_preference_data().get("link_mode"));
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
		if (local_cmd_exit_counter < 4){ //3 * 2 * base_interval
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
	
	private Boolean implement_local_debug_data_dump(){
		Boolean dump_status = Boolean.valueOf(true);
		if (!client_info.get_client_preference_data().get("debug_mode").equals("1")){
			return dump_status;
		}
		String work_space = client_info.get_client_preference_data().get("work_space");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_file = work_space + "/" + log_folder + "/debug/local/client_data.txt";
		//generate title
		StringBuilder title_sb = new StringBuilder();
		title_sb.append("Time" + ",");
		title_sb.append("Threads" + ",");		
		title_sb.append("CPU" + ",");
		title_sb.append("MEM" + ",");
		title_sb.append("Space" + ",");
		title_sb.append("CoreScript");
		String title = title_sb.toString();
		//generate message line
		String thread_mode = new String();
		thread_mode = auto_adjust ? "A" : "M";
		int use_thread = pool_info.get_pool_used_threads();
		int max_thread = pool_info.get_pool_current_size();
		HashMap<String, String> system_data = new HashMap<String, String>();
		system_data.putAll(deep_clone.clone(client_info.get_client_system_data()));
		HashMap<String, String> corescript_data = new HashMap<String, String>();
		corescript_data.putAll(deep_clone.clone(client_info.get_client_corescript_data()));
		StringBuilder msg_sb = new StringBuilder();
		msg_sb.append(time_info.get_date_time() + ",");
		msg_sb.append(String.valueOf(use_thread) + "/" + String.valueOf(max_thread) + "(" + thread_mode + "),");
		msg_sb.append(system_data.getOrDefault("cpu", "NA") + ",");
		msg_sb.append(system_data.getOrDefault("mem", "NA") + ",");
		msg_sb.append(system_data.getOrDefault("space", "NA") + ",");
		msg_sb.append(corescript_data.getOrDefault("version", "NA") + line_separator);
		String message = msg_sb.toString();
		//dump
		file_action.append_file_with_title(dump_file, title, message);
		return dump_status;
	}
	
	private void thread_auto_adjustment_start_check() {
		if (auto_adjust) {
			return;//already in auto adjustment status
		}
		String def_thread_str = client_info.get_client_preference_data().get("max_threads");
		int def_thread = Integer.parseInt(def_thread_str);		
		//condition1: used thread = max_threads setting
		if (!auto_adjust_thread_match) {
			int used_thread = pool_info.get_pool_used_threads();
			if (used_thread < def_thread) {
				return;//default max threads didn't fully occupied
			} else {
				auto_adjust_thread_match = true;
				auto_adjust_prvious_finish = get_client_current_run_case_number();
				return;
			}
		}
		//condition2: finish half of launched case
		int new_finished_number = get_client_current_run_case_number() - auto_adjust_prvious_finish;
		int half_def_thread_num = def_thread / 2;
		if (new_finished_number >= half_def_thread_num) {
			auto_adjust = true;
		}
	}
	
	private void thread_auto_adjustment_end_check() {
		if (!auto_adjust) {
			return;//already in non-auto adjustment status
		}
		int used_thread = pool_info.get_pool_used_threads();
		if (used_thread <= 0) {
			auto_adjust = false;
			auto_adjust_thread_match = false;
			auto_adjust_prvious_finish = 0;
		}
	}
	
	private void thread_auto_adjustment_status_check() {
		//step 1. manual mode, no auto adjustment
		if (client_info.get_client_preference_data().get("thread_mode").equals("manual")){
			return;//manual mode no auto adjustment
		}
		//step 2. thread limitation sensed, no auto adjustment
		ArrayList<String> executing_queue_list = new ArrayList<String>();
		executing_queue_list.addAll(task_info.get_executing_admin_queue_list());
		HashMap<String, HashMap<String, HashMap<String, String>>> admin_queues_map = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		admin_queues_map.putAll(deep_clone.clone(task_info.get_captured_admin_queues_treemap()));		
		Integer limit_threads = Integer.valueOf(0); //no limitation
		for (String queue_name : executing_queue_list) {
			if (!admin_queues_map.containsKey(queue_name)) {
				continue;
			}
			limit_threads = Integer.valueOf(get_admin_queue_max_threads(admin_queues_map.get(queue_name)));
			//typically all queues(in executing_queue_list) have a same thread limitation
			break;
		}
		if (limit_threads > 0) {
			HALL_MANAGER_LOGGER.info("Threads limitation found, 'Thread auto adjustment feature' disabled.");
			return;
		}
		//step 3. do start end check
		thread_auto_adjustment_start_check();
		thread_auto_adjustment_end_check();
	}
	
	private void implement_thread_auto_adjustment(){
		//system info record, if not successfully recorded, skip this point
		if (!current_system_info_record()){
			return;
		}
		thread_auto_adjust_counter += 1;
		if(thread_auto_adjust_counter <= public_data.PERF_AUTO_ADJUST_CYCLE){
			return;// adjust cycle = 12 * 10 seconds
		}
		//only when used thread >= pool_curent_size, this feature work
		String def_thread_str = client_info.get_client_preference_data().get("max_threads");
		int def_thread = Integer.parseInt(def_thread_str);	
		int max_thread = pool_info.get_pool_current_size();
		int use_thread = pool_info.get_pool_used_threads();
		int cpu_avgs = get_integer_list_average(client_history_cpu_list);
		int mem_avgs = get_integer_list_average(client_history_mem_list);
		if(cpu_avgs == 0 || mem_avgs ==0){
			//empty data find, skip adjustment
			cleanup_auto_adjust_record();
			return;
		}
		if(cpu_avgs >= public_data.PERF_AUTO_MAXIMUM_CPU || mem_avgs >= public_data.PERF_AUTO_MAXIMUM_MEM){
			run_system_overload_thread_update(use_thread, max_thread);
		} 
		if (cpu_avgs < public_data.PERF_AUTO_MAXIMUM_CPU && mem_avgs < public_data.PERF_AUTO_MAXIMUM_MEM){
			run_system_normal_thread_update(use_thread, max_thread, def_thread);
		}
		cleanup_auto_adjust_record();	
	}
	
	private void run_system_overload_thread_update(
			int use_thread,
			int max_thread
			){
		if (use_thread <= max_thread){
			decrease_max_thread();
		}
	}
	
	private void run_system_normal_thread_update(
			int use_thread,
			int max_thread,
			int def_thread
			){
		int half_def_thread = def_thread / 2;
		if (use_thread >= max_thread){
			increase_max_thread();
			return;
		}
		if (max_thread < half_def_thread) {
			increase_max_thread();
			return;
		} 
		if (max_thread > def_thread && use_thread <= half_def_thread) {
			decrease_max_thread();
			return;
		}
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
		summary_map.putAll(task_info.get_client_run_case_summary_status_map());
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
		summary_map.putAll(task_info.get_client_run_case_summary_status_map());
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
		HALL_MANAGER_LOGGER.info(">>>Run  mode:" + client_info.get_client_preference_data().get("interface_mode"));
		HALL_MANAGER_LOGGER.info(">>>link mode:" + client_info.get_client_preference_data().get("link_mode"));
		HALL_MANAGER_LOGGER.info(">>>Finished queue(s): " + task_info.get_client_run_case_summary_status_map().size());
		for (String queue_name: task_info.get_client_run_case_summary_status_map().keySet()){
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
	
	private ArrayList<String> generate_executing_admin_queue_list(){
		//processing_list > software_ready_list > thread_priority_list > executing_list 
		ArrayList<String> executing_list = new ArrayList<String>();
		ArrayList<String> software_ready_list = new ArrayList<String>();
		HashMap<String, HashMap<String, HashMap<String, String>>> admin_queues_map = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		admin_queues_map.putAll(deep_clone.clone(task_info.get_captured_admin_queues_treemap()));
		//step 1 : generate software ready list (remove software isn't ready items)
		HashMap<String, HashMap<String, String>> client_data = new HashMap<String, HashMap<String, String>>();
		client_data.putAll(deep_clone.clone(client_info.get_client_data()));
		for(String queue_name: task_info.get_processing_admin_queue_list()) {
			HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
			if (!admin_queues_map.containsKey(queue_name)) {
				//multi-threads issue: some thread may removed this queue
				continue;
			}
			queue_data.putAll(admin_queues_map.get(queue_name));
			if (!queue_data.containsKey("Software")) {
				software_ready_list.add(queue_name);
				continue;
			}
			Boolean sw_available = Boolean.valueOf(true);
			for(String software: queue_data.get("Software").keySet()) {
				if (client_data.containsKey(software)) {
					Integer insts_value = Integer.valueOf(client_data.get(software).getOrDefault("max_insts", public_data.DEF_SW_MAX_INSTANCES));
					if (insts_value < 1) {
						sw_available = false;
						break;
					}
				} else {
					sw_available = false;
					break;
				}
			}
			if (sw_available) {
				software_ready_list.add(queue_name);
			} else {
				HALL_MANAGER_LOGGER.debug(queue_name + ":Software not ready for run.");
			}
		}
		//step 2 : get highest thread list
		Integer record_thread = Integer.valueOf(0);
		for (String queue_name : software_ready_list) {
			HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
			admin_data.putAll(admin_queues_map.get(queue_name));
			Integer current_thread = Integer.valueOf(get_admin_queue_max_threads(admin_data));
			if (current_thread > record_thread) {
				record_thread = current_thread;
			}
		}
		for (String queue_name : software_ready_list) {
			HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
			admin_data.putAll(admin_queues_map.get(queue_name));
			Integer current_thread = Integer.valueOf(get_admin_queue_max_threads(admin_data));
			if (current_thread.equals(record_thread)) {
				executing_list.add(queue_name);
			}
		}
		return executing_list;
	}
	
	private String get_admin_queue_max_threads(
			HashMap<String, HashMap<String, String>> admin_data
			) {
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
		return max_threads;
	}
	
	private String get_admin_queue_host_restart(
			HashMap<String, HashMap<String, String>> admin_data
			) {
		String host_restart = new String(public_data.TASK_DEF_HOST_RESTART);
		if (!admin_data.containsKey("Preference")) {
			host_restart = public_data.TASK_DEF_HOST_RESTART;
		} else if (!admin_data.get("Preference").containsKey("host_restart")) {
			host_restart = public_data.TASK_DEF_HOST_RESTART;
		} else {
			String request_value = new String(admin_data.get("Preference").get("host_restart").trim());
			if (!data_check.str_choice_check(request_value, new String [] {"false", "true"} )){
				HALL_MANAGER_LOGGER.warn("Wrong Preference->host_restart, default value " + public_data.TASK_DEF_HOST_RESTART + " used.");
			} else {
				host_restart = request_value;
			}				
		}
		return host_restart;
	}
	
	@SuppressWarnings("unused")
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
		//Idle status go to default threads setting
		if (executing_list.isEmpty()) {
			reset_default_max_thread();
			return;
		}
		HashMap<String, HashMap<String, HashMap<String, String>>> admin_queues_map = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		admin_queues_map.putAll(deep_clone.clone(task_info.get_captured_admin_queues_treemap()));
		//step 1: max threads setting.
		Integer limit_threads = Integer.valueOf(0);
		for (String queue_name: executing_list) {
			if (!admin_queues_map.containsKey(queue_name)) {
				continue;
			}
			limit_threads = Integer.valueOf(get_admin_queue_max_threads(admin_queues_map.get(queue_name)));
			break;
		}
		if (pool_info.get_pool_current_size() != limit_threads) {
			if (limit_threads > 0 && limit_threads <= pool_info.get_pool_maximum_size()) {
				pool_info.set_pool_current_size(limit_threads);
			} else {
				reset_default_max_thread();
			}
		} else {
			HALL_MANAGER_LOGGER.debug("Required Thread Num already finished.");
		}
		//step 2: host restart if need.
		Boolean host_restart = Boolean.valueOf(false);		
		for (String queue_name : executing_list) {
			if (!admin_queues_map.containsKey(queue_name)) {
				continue;
			}
			HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
			admin_data.putAll(admin_queues_map.get(queue_name));
			String request_value = new String(get_admin_queue_host_restart(admin_data));			
			if (request_value.equals("false")) {
				continue;
			}
			//admin queue with host restart needed
			String admin_time = new String("");
			if (!admin_data.containsKey("ID")) {
				continue;
			} 
			if (!admin_data.get("ID").containsKey("epoch_time")) {
				continue;
			}
			admin_time = admin_data.get("ID").get("epoch_time");
			if(is_restart_needed(admin_time)) {
				host_restart = true;
				break;
			}
		}
		if (host_restart) {
	    	String os = System.getProperty("os.name").toLowerCase();
			if (os.contains("windows")) {
				HALL_MANAGER_LOGGER.warn("Host restart, task requirements...");
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
		//task 1: generate executing queue list
		ArrayList<String> executing_queue_list = new ArrayList<String>();
		executing_queue_list.addAll(generate_executing_admin_queue_list());
		//task 2: run environment update(thread pool, task waiter)
		update_run_environment(executing_queue_list);
		//task 3: release executing queue list(for task waiters use)
		task_info.set_executing_admin_queue_list(executing_queue_list);
	}
	
	private void job_implementation_monitor() {
		thread_auto_adjustment_status_check();
		// task 1 : Maximum threads adjustment
		if(auto_adjust) {
			implement_thread_auto_adjustment();
		}
		// task 2 : Send mail for task queue with too many blockers
		implement_task_blocker_actions();
	}
	
	private void job_report_generation() {
		// task 1 : make general report for non local console mode
		implement_general_console_report();
		// task 2 : exit apply for local command line mode
		implement_local_cmd_mode_exit();
		// task 3 : local client and system info dump
		implement_local_debug_data_dump();
	}
	
	private void stop_sub_threads() {
		result_runner.soft_stop();
		Iterator<String> waiters_it = task_runners.keySet().iterator();
		while (waiters_it.hasNext()) {
			String waiter_name = waiters_it.next();
			task_waiter waiter = task_runners.get(waiter_name);
			waiter.soft_stop();
		}
	}

	private void wait_sub_threads(){
		result_runner.wait_request();
		Iterator<String> waiters_it = task_runners.keySet().iterator();
		while (waiters_it.hasNext()) {
			String waiter_name = waiters_it.next();
			task_waiter waiter = task_runners.get(waiter_name);
			waiter.wait_request();
		}		
	}
	
	private void wake_sub_threads(){
		result_runner.wake_request();
		start_right_task_waiter(task_runners, pool_info.get_pool_current_size());
	}
	
	private void initial_thread_pool_setting(){
		int pool_size = Integer.valueOf(client_info.get_client_preference_data().get("pool_size"));
		int max_threads = Integer.valueOf(client_info.get_client_preference_data().get("max_threads"));
		pool_info.initialize_thread_pool(pool_size);
		if (max_threads > pool_size){
			HALL_MANAGER_LOGGER.warn("max_threads > pool_size, will use pool_size:" + pool_size +" as maximum threads num");
			pool_info.set_pool_current_size(pool_size);
		} else {
			pool_info.set_pool_current_size(max_threads);
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
		current_thread = Thread.currentThread();
		// ============== All static job start from here ==============
		// initial 0 : update default current size into Pool Data
		initial_thread_pool_setting();
		// initial 1 : start task waiters
		task_runners = get_task_waiter_ready();
		// initial 2 : start result waiter
		result_runner = get_result_waiter_ready();
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
				switch_info.update_threads_active_map(thread_enum.hall_runner, time_info.get_date_time());
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
		data_server data_runner = new data_server(cmd_info, switch_info, client_info);
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