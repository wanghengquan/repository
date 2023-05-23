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
import java.text.DecimalFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.local_tube;
import connect_tube.queue_attr;
import connect_tube.rmq_tube;
import connect_tube.task_data;
import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;
import top_runner.run_manager.thread_enum;
import top_runner.run_status.exit_enum;
import utility_funcs.data_check;
import utility_funcs.deep_clone;
import utility_funcs.screen_record;
import utility_funcs.system_call;
import utility_funcs.time_info;

public class task_waiter extends Thread {
	// public property
	// protected property
	// private property
	private static final Logger TASK_WAITER_LOGGER = LogManager.getLogger(task_waiter.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = true;
	private int waiter_index;
	private String waiter_name;
	private String waiter_status;
	private Thread waiter_thread;
	private pool_data pool_info;
	private task_data task_info;
	private client_data client_info;
	private switch_data switch_info;
	private DecimalFormat decimalformat = new DecimalFormat("0.00");
	//private String line_separator = System.getProperty("line.separator");
	private String file_seprator = System.getProperty("file.separator");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;
	// public function
	// protected function
	// private function

	public task_waiter(
			int waiter_index, 
			switch_data switch_info, 
			client_data client_info, 
			pool_data pool_info,
			task_data task_info
			) {
		this.waiter_index = waiter_index;
		this.pool_info = pool_info;
		this.task_info = task_info;
		this.client_info = client_info;
		this.switch_info = switch_info;
		this.waiter_name = "TW_" + String.valueOf(waiter_index);
	}

	protected int get_waiter_index() {
		return this.waiter_index;
	}

	protected String get_waiter_status() {
		return this.waiter_status;
	}

	protected Thread get_waiter_thread() {
		return waiter_thread;
	}

	private void retrieve_queues_into_memory() {
		synchronized (this.getClass()) {
			task_info.update_received_admin_queues_treemap(
					import_data.retrieve_disk_dumped_received_admin_data(client_info));
			task_info.update_processed_admin_queues_treemap(
					import_data.retrieve_disk_dumped_processed_admin_data(client_info));
			task_info.update_received_task_queues_map(
					import_data.retrieve_disk_dumped_received_task_data(client_info));
			task_info.update_processed_task_queues_map(
					import_data.retrieve_disk_dumped_processed_task_data(client_info));
		}
	}

	private void reload_repressing_queue_data() {
		synchronized (this.getClass()) {
			//must do with following order to avoid multi thread issue
			ArrayList<String> finished_queue_list = task_info.get_finished_admin_queue_list();
			ArrayList<String> emptied_queue_list = task_info.get_emptied_admin_queue_list();
			ArrayList<String> processing_queue_list = task_info.get_processing_admin_queue_list();
			for (String queue_name : processing_queue_list) {
				if (!emptied_queue_list.contains(queue_name)) {
					continue;
				}
				if (!task_info.remove_emptied_admin_queue_list(queue_name)) {
					continue;// some one else remove queue form finished list
								// already
				}
				if (!finished_queue_list.contains(queue_name)) {
					continue;
				}				
				if (!task_info.remove_finished_admin_queue_list(queue_name)) {
					continue;// some one else remove queue form finished list
								// already
				}
				// action need to do after remove queue form finished list
				if (task_info.get_processed_task_queues_map().containsKey(queue_name)) {
					continue;// task_data already in memory, no import need.
				}
				task_info.update_queue_to_processed_task_queues_map(queue_name,
						import_data.import_disk_finished_task_data(queue_name, client_info));
				// don't import admin queue since it maybe changed remotely
			}
		}
	}

	@SuppressWarnings("unused")
	private Boolean get_cpu_high_usage(){
		Boolean status = Boolean.valueOf(false);
		String cpu_used = client_info.get_client_system_data().getOrDefault("cpu", "NA");
		int cpu_used_int = 0;
		try{
			cpu_used_int = Integer.parseInt(cpu_used);
		} catch (Exception e) {
			return false;
		}
		if (cpu_used_int >= public_data.RUN_LIMITATION_CPU * 4 / 5){
			status = true;
		}
		return status;
	}
	
	@SuppressWarnings("unused")
	private Boolean get_mem_high_usage(){
		Boolean status = Boolean.valueOf(false);
		String mem_used = client_info.get_client_system_data().getOrDefault("mem", "NA");
		int mem_used_int = 0;
		try{
			mem_used_int = Integer.parseInt(mem_used);
		} catch (Exception e) {
			return false;
		}
		if (mem_used_int >= public_data.RUN_LIMITATION_MEM * 4 / 5){
			status = true;
		}
		return status;
	}
	
	private Boolean start_new_task_check(){
		Boolean available = Boolean.valueOf(true);
		//client soft stop request ?
		if (switch_info.get_client_soft_stop_request()){
			if (waiter_name.equalsIgnoreCase("tw_0")){
				TASK_WAITER_LOGGER.warn(waiter_name + ":Waiting for Client soft stop...");
			}			
			return false;			
		}		
		//work space ready ?
		if (switch_info.get_work_space_update_request()){
			if (waiter_name.equalsIgnoreCase("tw_0")){
				TASK_WAITER_LOGGER.warn(waiter_name + ":Waiting for work space update...");
			}			
			return false;			
		}
		//DEV ready ?
		if (switch_info.get_core_script_update_request()){
			if (waiter_name.equalsIgnoreCase("tw_0")){
				TASK_WAITER_LOGGER.warn(waiter_name + ":Waiting for core script update...");
			}
			return false;
		}
		//thread available ?
		if (pool_info.get_available_thread_for_reserve() < 1){
			if (waiter_name.equalsIgnoreCase("tw_0") && !switch_info.get_local_console_mode()){
				TASK_WAITER_LOGGER.debug(waiter_name + ":No more threads available...");
			}			
			return false;
		}
		//executing queue available ?
		if (task_info.get_executing_admin_queue_list().size() < 1) {
			if (waiter_name.equalsIgnoreCase("tw_0") && !switch_info.get_local_console_mode()){
				TASK_WAITER_LOGGER.debug(waiter_name + ":No Runnable queue found.");
			}
			return false;
		}		
		return available;
	}
	
	private String get_right_task_queue() {
		String queue_name = new String();
		// pending_queue_list = processing_admin_queue - executing_queue_list
		ArrayList<String> executing_queue_list = task_info.get_executing_admin_queue_list();
		ArrayList<String> runable_queue_list = get_runable_queue_list(executing_queue_list);
		int queue_list_size = runable_queue_list.size();
		int select_queue_index = 0;
		if (queue_list_size == 0) {
			return queue_name;
		}
		String queue_work_mode = client_info.get_client_data().get("preference").get("task_mode");
		if (queue_work_mode.equalsIgnoreCase("serial")) {
			queue_name = get_highest_queue_name(runable_queue_list);
		} else if (queue_work_mode.equalsIgnoreCase("parallel")) {
			select_queue_index = (waiter_index + 1) % queue_list_size;
			if (select_queue_index == 0) {
				select_queue_index = queue_list_size;
			}
			queue_name = runable_queue_list.get(select_queue_index - 1);
		} else {
			// auto mode run higher priority queue list
			ArrayList<String> higher_priority_queue_list = get_higher_priority_queue_list(runable_queue_list);
			int sub_queue_list_size = higher_priority_queue_list.size();
			select_queue_index = (waiter_index + 1) % sub_queue_list_size;
			if (select_queue_index == 0) {
				select_queue_index = sub_queue_list_size;
			}
			queue_name = higher_priority_queue_list.get(select_queue_index - 1);
		}
		return queue_name;
	}

	// sorting the queue list based on current resource info
	// Machine and System have already sorted in capture level on Software need
	// to rechecks
	private ArrayList<String> get_runable_queue_list(
			ArrayList<String> full_list
			) {
		ArrayList<String> runable_queue_list = new ArrayList<String>();
		HashMap<String, Integer> available_software_insts = client_info.get_available_software_insts();
		for (String queue_name : full_list) {
			HashMap<String, HashMap<String, String>> request_data = new HashMap<String, HashMap<String, String>>();
			request_data.putAll(task_info.get_data_from_captured_admin_queues_treemap(queue_name));
			if (request_data.isEmpty()) {
				// in case other thread deleted this queue already
				continue;
			}
			if (!request_data.containsKey("Software")) {
				runable_queue_list.add(queue_name);
				continue;
			}
			// with software request queue
			Boolean match_request = Boolean.valueOf(true);
			HashMap<String, String> sw_request_data = request_data.get("Software");
			Iterator<String> sw_request_it = sw_request_data.keySet().iterator();
			while (sw_request_it.hasNext()) {
				String sw_request_name = sw_request_it.next();
				if (!available_software_insts.containsKey(sw_request_name)) {
					match_request = false;
					break;
				}
				int available_sw_number = available_software_insts.get(sw_request_name);
				if (available_sw_number < 1) {
					match_request = false;
					break;
				}
			}
			if (match_request) {
				runable_queue_list.add(queue_name);
			}
		}
		return runable_queue_list;
	}

	private ArrayList<String> get_higher_priority_queue_list(ArrayList<String> full_list) {
		ArrayList<String> higher_priority_queue_list = new ArrayList<String>();
		int highest_priority = get_highest_queue_priority(full_list);
		for (String queue_name : full_list) {
			int queue_priority = get_srting_int(queue_name, "^(\\d+)@");
			if (queue_priority == highest_priority) {
				higher_priority_queue_list.add(queue_name);
			}
		}
		return higher_priority_queue_list;
	}

	private int get_highest_queue_priority(ArrayList<String> full_list) {
		int record_priority = 999;
		for (String queue_name : full_list) {
			int queue_priority = get_srting_int(queue_name, "^(\\d+)@");
			if (queue_priority < record_priority) {
				record_priority = queue_priority;
			}
		}
		return record_priority;
	}

	private String get_highest_queue_name(ArrayList<String> full_list) {
		//highest priority with earlier received time will be taken(sorted full_list)
		int record_priority = 999;
		String record_queue = new String();
		for (String queue_name : full_list) {
			int queue_priority = get_srting_int(queue_name, "^(\\d+)@");
			if (queue_priority < record_priority) {
				record_priority = queue_priority;
				record_queue = queue_name;
			}
		}
		return record_queue;
	}

	private int get_srting_int(String str, String patt) {
		int i = 999;
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

	private Boolean system_cpu_meet_admin_request(
			HashMap<String, HashMap<String, String>> admin_data
			) {
		Boolean status = Boolean.valueOf(true);
		//request data
		int request = 99;
		if (admin_data.get("Software").containsKey("squish")) {
			request = public_data.PERF_SQUISH_MAXIMUM_CPU;
		}
		if (admin_data.get("System").containsKey("max_cpu")) {
			try {
				request = Integer.valueOf(admin_data.get("System").get("max_cpu")).intValue();
			} catch (NumberFormatException e) {
				e.printStackTrace();
			}
		}
		//current data
		int current = 0;
		if (client_info.get_client_system_data().containsKey("cpu")) {
			try {
				current = Integer.valueOf(client_info.get_client_system_data().get("cpu")).intValue();
			} catch (NumberFormatException e) {
				e.printStackTrace();
			}	
		}
		if (request < current) {
			status = false;
		}
		return status;
	}
	
	private Boolean system_mem_meet_admin_request(
			HashMap<String, HashMap<String, String>> admin_data
			) {
		Boolean status = Boolean.valueOf(true);
		//request data
		int request = 99;
		if (admin_data.get("Software").containsKey("squish")) {
			request = public_data.PERF_SQUISH_MAXIMUM_MEM;
		}
		if (admin_data.get("System").containsKey("max_mem")) {
			try {
				request = Integer.valueOf(admin_data.get("System").get("max_mem")).intValue();
			} catch (NumberFormatException e) {
				e.printStackTrace();
			}
		}
		//current data
		int current = 0;
		if (client_info.get_client_system_data().containsKey("mem")) {
			try {
				current = Integer.valueOf(client_info.get_client_system_data().get("mem")).intValue();
			} catch (NumberFormatException e) {
				e.printStackTrace();
			}	
		}
		if (request < current) {
			status = false;
		}
		return status;
	}
	
	private Boolean system_space_meet_admin_request(
			HashMap<String, HashMap<String, String>> admin_data
			) {
		Boolean status = Boolean.valueOf(true);
		//request data
		int request = 0;
		if (admin_data.get("System").containsKey("min_space")) {
			try {
				request = Integer.valueOf(admin_data.get("System").get("min_space")).intValue();
			} catch (NumberFormatException e) {
				e.printStackTrace();
			}
		}
		//current data
		int current = 10;
		if (client_info.get_client_system_data().containsKey("space")) {
			try {
				current = Integer.valueOf(client_info.get_client_system_data().get("space")).intValue();
			} catch (NumberFormatException e) {
				e.printStackTrace();
			}	
		}
		if (request > current) {
			status = false;
		}
		return status;
	}
	
	private Boolean system_memory_booking(
			float est_mem
			) {
		Boolean status = Boolean.valueOf(true);
		//current running thread memory calculate
		synchronized (this.getClass()) {
			float reg_request = client_info.get_registered_memory();
			float run_request = pool_info.get_sys_call_extra_memory();
			float estimate_total = est_mem + reg_request + run_request;
			float memory_free = 0.0f;
			memory_free = Float.valueOf(client_info.get_client_system_data().get("mem_free")).floatValue();
			float available_memory = memory_free * public_data.PERF_GOOD_MEM_USAGE_RATE;
			if (available_memory >= estimate_total) {
				status = true;
				client_info.increase_registered_memory(est_mem);
			} else {
				status = false;
			}
			TASK_WAITER_LOGGER.debug(waiter_name + ":memory_free:" + decimalformat.format(memory_free));
			TASK_WAITER_LOGGER.debug(waiter_name + ":available_memory:" + decimalformat.format(available_memory));
			TASK_WAITER_LOGGER.debug(waiter_name + ":estimate_total:" + decimalformat.format(estimate_total));
			TASK_WAITER_LOGGER.debug(waiter_name + ":status:" + status.toString());
			//TASK_WAITER_LOGGER.warn(waiter_name + ":status:" + status.toString());
		}
		return status;
	}
	
	private Boolean system_space_booking(
			float est_space
			) {
		Boolean status = Boolean.valueOf(true);
		//current running thread memory calculate
		synchronized (this.getClass()) {
			float reg_request = client_info.get_registered_space();
			float run_request = pool_info.get_sys_call_extra_space();
			float estimate_total = est_space + reg_request + run_request;
			float space_free = 0.0f;
			float space_reserve = 0.0f;
			space_free = Float.valueOf(client_info.get_client_system_data().get("space")).floatValue();
			space_reserve = Float.valueOf(client_info.get_client_preference_data().get("space_reserve")).floatValue();
			if(space_reserve > space_free) {
				return false;
			}
			float available_space = space_free - space_reserve;
			if (available_space >= estimate_total) {
				status = true;
				client_info.increase_registered_space(est_space);
			} else {
				status = false;
			}
			TASK_WAITER_LOGGER.debug(waiter_name + ":space_free:" + decimalformat.format(space_free));
			TASK_WAITER_LOGGER.debug(waiter_name + ":available_space:" + decimalformat.format(available_space));
			TASK_WAITER_LOGGER.debug(waiter_name + ":estimate_total:" + decimalformat.format(estimate_total));
			TASK_WAITER_LOGGER.debug(waiter_name + ":status:" + status.toString());
			//TASK_WAITER_LOGGER.warn(waiter_name + ":status:" + status.toString());
		}
		return status;
	}
	
	private Boolean system_resource_booking(
			String queue_name,
			float est_mem,
			float est_space,
			Boolean cmds_parallel,
			String greed_mode,
			HashMap<String, HashMap<String, String>> admin_data
			){
		Boolean book_status = Boolean.valueOf(true);		
		//system ready? CPU, MEM, Space
		if (!system_cpu_meet_admin_request(admin_data)) {
			TASK_WAITER_LOGGER.debug(waiter_name + ":System CPU not available, skipping:" + queue_name);
			return false;
		}
		if (!system_mem_meet_admin_request(admin_data)) {
			TASK_WAITER_LOGGER.debug(waiter_name + ":System MEM not available, skipping:" + queue_name);
			return false;
		}
		if (!system_space_meet_admin_request(admin_data)) {
			TASK_WAITER_LOGGER.debug(waiter_name + ":System Space not available, skipping:" + queue_name);
			return false;
		}
		//
		//
		//=======booking=======
		//1. software available check
		//greed = true,do not reserve any quota
		//greed = false, booking used software
		if(greed_mode.equals("true")) {
			//In greed mode only check current SW instance available or not!
			Boolean software_available = client_info.software_available_check(admin_data.get("Software"), cmds_parallel);
			if (!software_available) {
				TASK_WAITER_LOGGER.debug(waiter_name + ":No SW resource available, skipping:" + queue_name);
				return false;
			}
		} else {
			Boolean software_booking = client_info.booking_used_soft_insts(admin_data.get("Software"), cmds_parallel);
			if (!software_booking) {
				TASK_WAITER_LOGGER.debug(waiter_name + ":No SW resource available, skipping:" + queue_name);
				return false;
			}
		}
		//2. memory ready for launch another thread
		if (!system_memory_booking(est_mem)) {
			TASK_WAITER_LOGGER.debug(waiter_name + ":System MEM not available for task launch, skipping:" + queue_name);
			if(!greed_mode.equals("true")) {
				client_info.release_used_soft_insts(admin_data.get("Software"), cmds_parallel);
			}
			return false;
		}
		//3. space ready for launch another thread
		if (!system_space_booking(est_space)) {
			TASK_WAITER_LOGGER.debug(waiter_name + ":System Space not available for task launch, skipping:" + queue_name);
			if(!greed_mode.equals("true")) {
				client_info.release_used_soft_insts(admin_data.get("Software"), cmds_parallel);
			}
			client_info.decrease_registered_memory(est_mem);
			return false;
		} 
		//3. thread booking
		Boolean thread_booking = pool_info.booking_reserved_threads(1);
		if (!thread_booking) {
			TASK_WAITER_LOGGER.debug(waiter_name + ":No Thread available, skipping:" + queue_name);
			if(!greed_mode.equals("true")) {
				client_info.release_used_soft_insts(admin_data.get("Software"), cmds_parallel);
			}
			client_info.decrease_registered_space(est_space);
			client_info.decrease_registered_memory(est_mem);
			return false;
		}
		return book_status;
	}
	
	private HashMap<String, HashMap<String, String>> get_final_admin_data(
			String queue_name
			) {
		HashMap<String, HashMap<String, String>> final_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, HashMap<String, String>> standard_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, HashMap<String, String>> raw_admin_data = new HashMap<String, HashMap<String, String>>();
		raw_admin_data.putAll(task_info.get_data_from_captured_admin_queues_treemap(queue_name));
		if (raw_admin_data.isEmpty()) {
			return final_data;
		}
		standard_data.putAll(get_standard_admin_data(raw_admin_data));
		final_data.putAll(raw_admin_data_sanity_check(standard_data));
		return final_data;
	}
	
	private HashMap<String, HashMap<String, String>> get_final_task_data(
			String queue_name,
			HashMap<String, HashMap<String, String>> admin_data,
			HashMap<String, String> client_preference_data
			) {
		Map<String, HashMap<String, HashMap<String, String>>> indexed_task_data = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		HashMap<String, HashMap<String, String>> standard_case_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, HashMap<String, String>> raw_task_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, HashMap<String, String>> checked_task_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, HashMap<String, String>> task_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, HashMap<String, String>> task_data_path_updated = new HashMap<String, HashMap<String, String>>();
		HashMap<String, HashMap<String, String>> return_data = new HashMap<String, HashMap<String, String>>();
		indexed_task_data.putAll(get_indexed_task_data(queue_name));
		if (indexed_task_data.isEmpty()) {
			return return_data;// empty data
		}
		// remote queue has case title while local queue case title == case id.
		// let's remove this title
		Iterator<String> indexed_it = indexed_task_data.keySet().iterator();
		String case_title = indexed_it.next();
		HashMap<String, HashMap<String, String>> raw_case_data = indexed_task_data.get(case_title);
		// again: merge case data admin queue and local queue (remote need,
		// local is done)
		standard_case_data.putAll(get_standard_task_data(raw_case_data));
		if (task_info.get_received_task_queues_map().containsKey(queue_name)) {
			// local data only need to merge admin ID run info
			raw_task_data.putAll(get_merged_local_task_info(admin_data,standard_case_data));						
		} else {
			// remote data, initial merge, rerun remote task will use local
			// model(no merge need) (consider cmd option)
			raw_task_data.putAll(get_merged_remote_task_info(admin_data, standard_case_data));
		}
		checked_task_data.putAll(raw_task_data_sanity_check(raw_task_data));
		task_data.putAll(merge_default_and_preference_data(checked_task_data, client_preference_data));
		task_data_path_updated.putAll(update_task_data_path_info(task_data, client_preference_data));
		//get escaped string and replaced string back
		return_data.putAll(replace_case_data_internal_string(task_data_path_updated));
		return return_data;
	}

	private HashMap<String, HashMap<String, String>> replace_case_data_internal_string(
			HashMap<String, HashMap<String, String>> case_data
			){
		HashMap<String, HashMap<String, String>> flow_data1 = new HashMap<String, HashMap<String, String>> ();
		HashMap<String, HashMap<String, String>> flow_data2 = new HashMap<String, HashMap<String, String>> ();
		//1. replace \; from remote queue
		flow_data1.putAll(hash_map_value_replacement("\\\\;", ";", case_data));
		//2. replace internal semicolon string
		flow_data2.putAll(hash_map_value_replacement(public_data.INTERNAL_STRING_SEMICOLON, ";", flow_data1));
		return flow_data2;
	}	
	
	private HashMap<String, HashMap<String, String>> hash_map_value_replacement(
			String ori_str,
			String rep_str,
			HashMap<String, HashMap<String, String>> case_data
			){
		HashMap<String, HashMap<String, String>> return_data = new HashMap<String, HashMap<String, String>> ();
		Iterator<String> section_iterator = case_data.keySet().iterator();
		while (section_iterator.hasNext()) {
			String section = section_iterator.next();
			HashMap<String, String> new_data = new HashMap<String, String>();
			Iterator<String> option_it = case_data.get(section).keySet().iterator();
			while(option_it.hasNext()){
				String key = option_it.next();
				String value = case_data.get(section).get(key);
				new_data.put(key, value.replaceAll(ori_str, rep_str));
			}
			return_data.put(section, new_data);
		}
		return return_data;
	}	
	
	private Map<String, HashMap<String, HashMap<String, String>>> get_indexed_task_data(
			String queue_name
			) {
		Map<String, HashMap<String, HashMap<String, String>>> indexed_case_data = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		// buffered task queues_tube_map
		if (task_info.get_received_task_queues_map().containsKey(queue_name)) {
			// task case from local
			// System.out.println(">>>>:" + Thread.currentThread().getName());
			indexed_case_data.putAll(task_info.get_one_indexed_case_data(queue_name));
		} else {
			try {
				indexed_case_data.putAll(rmq_tube.read_task_server(queue_name, client_info));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
				TASK_WAITER_LOGGER.info(waiter_name + ":Found empty/invalid Task Queue:" + queue_name);
			}
		}
		return indexed_case_data;
	}

	private void move_emptied_admin_queue_from_tube(String queue_name) {
		// move received admin queue data to processed queue data
		HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
		queue_data.putAll(task_info.get_queue_data_from_received_admin_queues_treemap(queue_name));
		if (queue_data == null || queue_data.isEmpty()) {
			TASK_WAITER_LOGGER.info(waiter_name + ":Move queue already finished, " + queue_name);
			return;
		}
		HashMap<String, String> status_data = queue_data.get("Status");
		status_data.put("admin_status", queue_enum.FINISHED.get_description());
		task_info.update_queue_to_processed_admin_queues_treemap(queue_name, queue_data);
		// delete all buffered info
		task_info.remove_queue_from_received_admin_queues_treemap(queue_name);
		task_info.remove_queue_from_captured_admin_queues_treemap(queue_name);
	}

	private void move_emptied_task_queue_from_tube(String queue_name) {
		// only need to remove buffered task queue in received task map if
		// have(task from rmq do not have)
		// since task case will add into processed task map, so we don't need to
		// copy again.
		task_info.remove_queue_from_received_task_queues_map(queue_name);
	}

	private HashMap<String, HashMap<String, String>> get_standard_admin_data(
			HashMap<String, HashMap<String, String>> admin_data) {
		HashMap<String, HashMap<String, String>> formated_data = new HashMap<String, HashMap<String, String>>();
		// ID format
		HashMap<String, String> id_hash = new HashMap<String, String>();
		if (admin_data.containsKey("ID")) {
			id_hash.putAll(admin_data.get("ID"));
		}
		formated_data.put("ID", id_hash);
		// CaseInfo format
		HashMap<String, String> caseinfo_hash = new HashMap<String, String>();
		if (admin_data.containsKey("CaseInfo")) {
			caseinfo_hash.putAll(admin_data.get("CaseInfo"));
		}
		formated_data.put("CaseInfo", caseinfo_hash);
		// Environment no default data now
		HashMap<String, String> envinfo_hash = new HashMap<String, String>();
		if (admin_data.containsKey("Environment")) {
			envinfo_hash.putAll(admin_data.get("Environment"));
		}
		formated_data.put("Environment", envinfo_hash);
		// LaunchCommand format
		HashMap<String, String> command_hash = new HashMap<String, String>();
		if (admin_data.containsKey("LaunchCommand")) {
			command_hash.putAll(admin_data.get("LaunchCommand"));
		}
		formated_data.put("LaunchCommand", command_hash);
		// Machine format
		HashMap<String, String> machine_hash = new HashMap<String, String>();
		if (admin_data.containsKey("Machine")) {
			machine_hash.putAll(admin_data.get("Machine"));
		}
		formated_data.put("Machine", machine_hash);      
		// System format
		HashMap<String, String> system_hash = new HashMap<String, String>();
		if (admin_data.containsKey("System")) {
			system_hash.putAll(admin_data.get("System"));
		}
		formated_data.put("System", system_hash);
		// Software format
		HashMap<String, String> software_hash = new HashMap<String, String>();
		if (admin_data.containsKey("Software")) {
			software_hash.putAll(admin_data.get("Software"));
		}
		formated_data.put("Software", software_hash);
        // Preference format
        HashMap<String, String> preference = new HashMap<String, String>();
        if (admin_data.containsKey("Preference")) {
            preference.putAll(admin_data.get("Preference"));
        }
        formated_data.put("Preference", preference); 
		// Status format
		HashMap<String, String> status_hash = new HashMap<String, String>();
		if (admin_data.containsKey("Status")) {
			status_hash.putAll(admin_data.get("Status"));
		}
		formated_data.put("Status", status_hash);        
		return formated_data;
	}
	
	private HashMap<String, HashMap<String, String>> get_standard_task_data(
			HashMap<String, HashMap<String, String>> case_data
			) {
		HashMap<String, HashMap<String, String>> formated_data = new HashMap<String, HashMap<String, String>>();
		// ID format
		HashMap<String, String> id_hash = new HashMap<String, String>();
		String project = new String("");
		String run = new String("");
		String suite = new String("");
		String section = new String("");
		String id = new String("");
		id_hash.put("project", project);
		id_hash.put("run", run);
		id_hash.put("suite", suite);
		id_hash.put("section", section);
		id_hash.put("id", id);
		if (case_data.containsKey("ID")) {
			id_hash.putAll(case_data.get("ID"));
		}
		// remote task queue use TestID while local parser user ID for total
		if (case_data.containsKey("TestID")) {
			id_hash.putAll(case_data.get("TestID"));
		}
		formated_data.put("ID", id_hash);
		// CaseInfo format
		HashMap<String, String> caseinfo_hash = new HashMap<String, String>();
		// local xlsx file containing folded/path
		String xlsx_dest = new String("");
		String repository = new String("");
		String suite_path = new String("");
		String design_name = new String("");
		String script_url = new String("");
		caseinfo_hash.put("xlsx_dest", xlsx_dest);
		caseinfo_hash.put("repository", repository);
		caseinfo_hash.put("suite_path", suite_path);
		caseinfo_hash.put("design_name", design_name);
		caseinfo_hash.put("script_url", script_url);
		if (case_data.containsKey("CaseInfo")) {
			caseinfo_hash.putAll(case_data.get("CaseInfo"));
		}
		formated_data.put("CaseInfo", caseinfo_hash);
		// Environment no default data now
		HashMap<String, String> envinfo_hash = new HashMap<String, String>();
		if (case_data.containsKey("Environment")) {
			envinfo_hash.putAll(case_data.get("Environment"));
		}
		formated_data.put("Environment", envinfo_hash);
		// LaunchCommand format
		HashMap<String, String> command_hash = new HashMap<String, String>();
		String dir = new String("");
		String override = new String("");
		command_hash.put("parallel", public_data.TASK_DEF_CMD_PARALLEL);
		command_hash.put("dir", dir);
		command_hash.put("override", override);
		if (case_data.containsKey("LaunchCommand")) {
			command_hash.putAll(case_data.get("LaunchCommand"));
		}
		formated_data.put("LaunchCommand", command_hash);
		// Machine format
		HashMap<String, String> machine_hash = new HashMap<String, String>();
		String terminal = new String("");
		String group = new String("");
		machine_hash.put("terminal", terminal);
		machine_hash.put("group", group);
		if (case_data.containsKey("Machine")) {
			machine_hash.putAll(case_data.get("Machine"));
		}
		formated_data.put("Machine", machine_hash);
        // Task Preference format
        HashMap<String, String> preference = new HashMap<String, String>();
        if (case_data.containsKey("Preference")) {
            preference.putAll(case_data.get("Preference"));
        }
        formated_data.put("Preference", preference);        
		// System format
		HashMap<String, String> system_hash = new HashMap<String, String>();
		String os = new String("");
		String os_type = new String("");
		String os_arch = new String("");
		system_hash.put("os", os);
		system_hash.put("os_type", os_type);
		system_hash.put("os_arch", os_arch);
		if (case_data.containsKey("System")) {
			system_hash.putAll(case_data.get("System"));
		}
		formated_data.put("System", system_hash);
		// Software format
		HashMap<String, String> software_hash = new HashMap<String, String>();
		if (case_data.containsKey("Software")) {
			software_hash.putAll(case_data.get("Software"));
		}
		formated_data.put("Software", software_hash);
		// Status format
		HashMap<String, String> status_hash = new HashMap<String, String>();
		String admin_status = new String("");
		String cmd_status = new String("Processing");
		String cmd_reason = new String("");
		String location = new String("");
		String run_time = new String("");
		String update_time = new String("");
		status_hash.put("admin_status", admin_status);
		status_hash.put("cmd_status", cmd_status);
		status_hash.put("cmd_reason", cmd_reason);
		status_hash.put("location", location);
		status_hash.put("run_time", run_time);
		status_hash.put("update_time", update_time);
		if (case_data.containsKey("Status")) {
			status_hash.putAll(case_data.get("Status"));
		}
		formated_data.put("Status", status_hash);
		//paths format
		HashMap<String, String> paths_hash = new HashMap<String, String>();
		//String work_space = new String("");
		//String save_space = new String("");
		String depot_space = new String("");// repository + suite path
		String case_path = new String("");
		String task_path = new String("");
		String save_path = new String("");
		String script_path = new String("");
		String launch_path = new String("");
		//paths_hash.put("work_space", work_space);
		//paths_hash.put("save_space", save_space);
		paths_hash.put("depot_space", depot_space);
		paths_hash.put("case_path", case_path);
		paths_hash.put("task_path", task_path);
		paths_hash.put("save_path", save_path);
		paths_hash.put("script_path", script_path);
		paths_hash.put("launch_path", launch_path);
		formated_data.put("Paths", paths_hash);
		return formated_data;
	}

	private HashMap<String, HashMap<String, String>> raw_admin_data_sanity_check(
			HashMap<String, HashMap<String, String>> raw_admin_data
			){
		HashMap<String, HashMap<String, String>> checked_data = new HashMap<String, HashMap<String, String>>();
		checked_data.putAll(deep_clone.clone(raw_admin_data));
		//CaseInfo check
		HashMap<String, String> case_data = checked_data.get("CaseInfo");
		if (case_data.containsKey("priority")) {
			try {
				Integer.parseInt(case_data.get("priority"));
			} catch (NumberFormatException e){
				TASK_WAITER_LOGGER.warn("Admin:Invalid priority value found, ignore this admin setting");
				case_data.remove("priority");
			}
		}
		if (case_data.containsKey("est_mem")) {
			try {
				Integer.parseInt(case_data.get("est_mem"));
			} catch (NumberFormatException e){
				TASK_WAITER_LOGGER.warn("Admin:Invalid est_mem value found, ignore this admin setting");
				case_data.remove("est_mem");
			}
		}
		if (case_data.containsKey("est_space")) {
			try {
				Integer.parseInt(case_data.get("est_space"));
			} catch (NumberFormatException e){
				TASK_WAITER_LOGGER.warn("Admin:Invalid est_space value found, ignore this admin setting");
				case_data.remove("est_space");
			}
		}
		if (case_data.containsKey("timeout")) {
			try {
				Integer.parseInt(case_data.get("timeout"));
			} catch (NumberFormatException e){
				TASK_WAITER_LOGGER.warn("Admin:Invalid timeout value found, ignore this admin setting");
				case_data.remove("timeout");
			}
		}
		//Environment check
		HashMap<String, String> env_data = checked_data.get("Environment");
		if (env_data.containsKey("override")) {
			if (!data_check.str_choice_check(env_data.get("override"), new String [] {"local", "globle"} )){
				env_data.remove("override");
			}
		}
		//LaunchCommand check
		HashMap<String, String> lcmd_data = checked_data.get("LaunchCommand");
		if (lcmd_data.containsKey("parallel")) {
			if (!data_check.str_choice_check(lcmd_data.get("parallel"), new String [] {"true", "false"} )){
				lcmd_data.remove("parallel");
			}
		}
		if (lcmd_data.containsKey("override")) {
			if (!data_check.str_choice_check(lcmd_data.get("override"), new String [] {"local", "globle"} )){
				lcmd_data.remove("override");
			}
		}
		//Software check
		//System check
		HashMap<String, String> system_data = checked_data.get("System");
		if (system_data.containsKey("max_cpu")) {
			try {
				Integer.parseInt(system_data.get("max_cpu"));
			} catch (NumberFormatException e){
				TASK_WAITER_LOGGER.warn("Admin:Invalid max_cpu value found, ignore this admin setting");
				system_data.remove("max_cpu");
			}
		}
		if (system_data.containsKey("max_mem")) {
			try {
				Integer.parseInt(system_data.get("max_mem"));
			} catch (NumberFormatException e){
				TASK_WAITER_LOGGER.warn("Admin:Invalid max_mem value found, ignore this admin setting");
				system_data.remove("max_mem");
			}
		}
		if (system_data.containsKey("min_space")) {
			try {
				Integer.parseInt(system_data.get("min_space"));
			} catch (NumberFormatException e){
				TASK_WAITER_LOGGER.warn("Admin:Invalid min_space value found, ignore this admin setting");
				system_data.remove("min_space");
			}
		}
		//Machine check
		//Preference check
		HashMap<String, String> preference_data = checked_data.get("Preference");
		if (preference_data.containsKey("case_mode")) {
			if (!data_check.str_choice_check(preference_data.get("case_mode"), new String [] {"copy_case", "hold_case"} )){
				preference_data.remove("case_mode");
			}
		}		
		if (preference_data.containsKey("greed_mode")) {
			if (!data_check.str_choice_check(preference_data.get("greed_mode"), new String [] {"false", "true", "auto"} )){
				preference_data.remove("greed_mode");
			}
		}
		
		if (preference_data.containsKey("keep_path")) {
			if (!data_check.str_choice_check(preference_data.get("keep_path"), new String [] {"false", "true"} )){
				preference_data.remove("keep_path");
			}
		}
		if (preference_data.containsKey("lazy_copy")) {
			if (!data_check.str_choice_check(preference_data.get("lazy_copy"), new String [] {"false", "true"} )){
				preference_data.remove("lazy_copy");
			}
		}
		if (preference_data.containsKey("result_keep")) {
			if (!data_check.str_choice_check(preference_data.get("result_keep"), new String [] {"zipped", "unzipped", "auto"} )){
				preference_data.remove("result_keep");
			}
		}
		if (preference_data.containsKey("max_threads")) {
			try {
				Integer.parseInt(preference_data.get("max_threads"));
			} catch (NumberFormatException e){
				TASK_WAITER_LOGGER.warn("Admin:Invalid max_threads value found, ignore this admin setting");
				preference_data.remove("max_threads");
			}
		}		
		if (preference_data.containsKey("host_restart")) {
			if (!data_check.str_choice_check(preference_data.get("host_restart"), new String [] {"false", "true"} )){
				preference_data.remove("host_restart");
			}
		}
		if (preference_data.containsKey("video_record")) {
			if (!data_check.str_choice_check(preference_data.get("video_record"), new String [] {"false", "true"} )){
				preference_data.remove("video_record");
			}
		}		
		return checked_data;
	}
	
	private HashMap<String, HashMap<String, String>> raw_task_data_sanity_check(
			HashMap<String, HashMap<String, String>> raw_task_data){
		HashMap<String, HashMap<String, String>> checked_data = new HashMap<String, HashMap<String, String>>();
		checked_data.putAll(deep_clone.clone(raw_task_data));
		//CaseInfo check
		HashMap<String, String> case_info = checked_data.get("CaseInfo");
		if (case_info.containsKey("durl_type")) {
			try {
				url_enum.valueOf(case_info.get("durl_type").toUpperCase());
			} catch (Exception e) {
				TASK_WAITER_LOGGER.warn("Task:Invalid url type found, ignore this task setting");
				case_info.remove("durl_type");
			}
		}
		if (case_info.containsKey("dzip_type")) {
			try {
				zip_enum.valueOf(case_info.get("dzip_type").toUpperCase());
			} catch (Exception e) {
				TASK_WAITER_LOGGER.warn("Task:Invalid zip type found, ignore this task setting");
				case_info.remove("dzip_type");
			}
		}
		if (case_info.containsKey("surl_type")) {
			try {
				url_enum.valueOf(case_info.get("surl_type").toUpperCase());
			} catch (Exception e) {
				TASK_WAITER_LOGGER.warn("Task:Invalid url type found, ignore this task setting");
				case_info.remove("surl_type");
			}
		}
		if (case_info.containsKey("szip_type")) {
			try {
				zip_enum.valueOf(case_info.get("szip_type").toUpperCase());
			} catch (Exception e) {
				TASK_WAITER_LOGGER.warn("Task:Invalid zip type found, ignore this task setting");
				case_info.remove("szip_type");
			}
		}
		if (case_info.containsKey("timeout")) {
			try {
				Integer.parseInt(case_info.get("timeout"));
			} catch (NumberFormatException e){
				TASK_WAITER_LOGGER.warn("Task:Invalid timeout value found, ignore this task setting");
				case_info.remove("timeout");
			}
		}
		//Environment check
		HashMap<String, String> environ_data = checked_data.get("Environment");
		if (environ_data.containsKey("override")) {
			if (!data_check.str_choice_check(environ_data.get("override"), new String [] {"globle", "local"} )){
				environ_data.remove("override");
			}
		}		
		//LaunchCommand check
		HashMap<String, String> lcmd_data = checked_data.get("LaunchCommand");
		if (lcmd_data.containsKey("parallel")) {
			if (!data_check.str_choice_check(lcmd_data.get("parallel"), new String [] {"false", "true"} )){
				lcmd_data.remove("parallel");
			}
		}
		if (lcmd_data.containsKey("override")) {
			if (!data_check.str_choice_check(lcmd_data.get("override"), new String [] {"globle", "local"} )){
				lcmd_data.remove("override");
			}
		}
		//Software check
		//System check
		HashMap<String, String> system_data = checked_data.get("System");
		if (system_data.containsKey("os_type")) {
			if (!data_check.str_choice_check(system_data.get("os_type"), new String [] {"windows", "linux"} )){
				system_data.remove("os_type");
			}
		}
		//Machine check
		//Preference check
		HashMap<String, String> preference_data = checked_data.get("Preference");
		if (preference_data.containsKey("case_mode")) {
			if (!data_check.str_choice_check(preference_data.get("case_mode"), new String [] {"copy_case", "hold_case"} )){
				preference_data.remove("case_mode");
			}
		}
		if (preference_data.containsKey("greed_mode")) {
			if (!data_check.str_choice_check(preference_data.get("greed_mode"), new String [] {"false", "true", "auto"} )){
				preference_data.remove("greed_mode");
			}
		}
		if (preference_data.containsKey("keep_path")) {
			if (!data_check.str_choice_check(preference_data.get("keep_path"), new String [] {"false", "true"} )){
				preference_data.remove("keep_path");
			}
		}
		if (preference_data.containsKey("lazy_copy")) {
			if (!data_check.str_choice_check(preference_data.get("lazy_copy"), new String [] {"false", "true"} )){
				preference_data.remove("lazy_copy");
			}
		}
		if (preference_data.containsKey("result_keep")) {
			if (!data_check.str_choice_check(preference_data.get("result_keep"), new String [] {"auto", "zipped", "unzipped"} )){
				preference_data.remove("result_keep");
			}
		}
		if (preference_data.containsKey("host_restart")) {
			if (!data_check.str_choice_check(preference_data.get("host_restart"), new String [] {"false", "true"} )){
				preference_data.remove("host_restart");
			}
		}
		if (preference_data.containsKey("video_record")) {
			if (!data_check.str_choice_check(preference_data.get("video_record"), new String [] {"false", "true"} )){
				preference_data.remove("video_record");
			}
		}
		return checked_data;
	}
	
	private HashMap<String, HashMap<String, String>> merge_default_and_preference_data(
			HashMap<String, HashMap<String, String>> case_data,
			HashMap<String, String> preference_data
			) {
		// the priority will be :  default < preference < case_data
		HashMap<String, HashMap<String, String>> default_data = new HashMap<String, HashMap<String, String>>();
		// ID format NA
		HashMap<String, String> id_hash = new HashMap<String, String>();
		if (case_data.containsKey("ID")) {
			id_hash.putAll(case_data.get("ID"));
		}
		StringBuilder id_index = new StringBuilder();
		id_index.append(case_data.get("ID").get("id"));
		if (case_data.get("ID").containsKey("breakpoint")) {
			String breakpoint = new String();
			breakpoint = case_data.get("ID").get("breakpoint");
			if(breakpoint != null) {
				id_index.append("_");
				id_index.append(breakpoint.split("\\s*,\\s*")[0]);
			}
		}
		id_hash.put("id_index", id_index.toString());
		default_data.put("ID", id_hash);
		// CaseInfo format, 4 level override:
		// default < configure < command line < task 
		HashMap<String, String> caseinfo_hash = new HashMap<String, String>();	
		caseinfo_hash.put("auth_key", public_data.ENCRY_DEF_STRING);
		caseinfo_hash.put("priority", public_data.TASK_DEF_PRIORITY);
		caseinfo_hash.put("timeout", public_data.TASK_DEF_TIMEOUT);
		if (case_data.containsKey("CaseInfo")) {
			caseinfo_hash.putAll(case_data.get("CaseInfo"));
		}
		default_data.put("CaseInfo", caseinfo_hash);
		// Environment NA
		HashMap<String, String> envinfo_hash = new HashMap<String, String>();
		if (case_data.containsKey("Environment")) {
			envinfo_hash.putAll(case_data.get("Environment"));
		}
		default_data.put("Environment", envinfo_hash);
		// LaunchCommand NA
		HashMap<String, String> command_hash = new HashMap<String, String>();
		command_hash.put("parallel", public_data.TASK_DEF_CMD_PARALLEL);
		command_hash.put("decision", public_data.TASK_DEF_CMD_DECISION);
		if (case_data.containsKey("LaunchCommand")) {
			command_hash.putAll(case_data.get("LaunchCommand"));
		}
		default_data.put("LaunchCommand", command_hash);
		// Machine format NA
		HashMap<String, String> machine_hash = new HashMap<String, String>();
		if (case_data.containsKey("Machine")) {
			machine_hash.putAll(case_data.get("Machine"));
		}
		default_data.put("Machine", machine_hash);
		// System format NA
		HashMap<String, String> system_hash = new HashMap<String, String>();
		if (case_data.containsKey("System")) {
			system_hash.putAll(case_data.get("System"));
		}
		default_data.put("System", system_hash);
		// Software NA
		HashMap<String, String> software_hash = new HashMap<String, String>();
		if (case_data.containsKey("Software")) {
			software_hash.putAll(case_data.get("Software"));
		}
		default_data.put("Software", software_hash);
		// task Preference NA
        HashMap<String, String> preference_hash = new HashMap<>();
		String result_keep = public_data.TASK_DEF_RESULT_KEEP;
		String keep_path = public_data.DEF_COPY_KEEP_PATH;
		String case_mode = public_data.DEF_CLIENT_CASE_MODE;
		String lazy_copy = public_data.DEF_COPY_LAZY_COPY;
		preference_hash.put("result_keep", result_keep);
		preference_hash.put("keep_path", keep_path);
		preference_hash.put("case_mode", case_mode);
		preference_hash.put("lazy_copy", lazy_copy);
		preference_hash.putAll(preference_data);
        if(case_data.containsKey("ClientPreference")){  //for compatibility
        	preference_hash.putAll(case_data.get("ClientPreference"));
        }
        if(case_data.containsKey("Preference")){
        	preference_hash.putAll(case_data.get("Preference"));
        }        
        default_data.put("Preference", preference_hash);		
		// Status NA
		HashMap<String, String> status_hash = new HashMap<String, String>();
		if (case_data.containsKey("Status")) {
			status_hash.putAll(case_data.get("Status"));
		}
		default_data.put("Status", status_hash);
		return default_data;
	}

	private HashMap<String, HashMap<String, String>> update_task_data_path_info(
			HashMap<String, HashMap<String, String>> case_data,
			HashMap<String, String> preference_data) {	
		HashMap<String, HashMap<String, String>> task_data = new HashMap<String, HashMap<String, String>>();
		String depot_space = new String("");// repository + suite path
		String design_url = new String("");
		String case_path = new String("");
		String case_name = new String("");
		String task_path = new String("");
		String work_suite = new String("");
		String save_path = new String("");
		String save_suite = new String("");
		String script_url = new String("");
		String script_base = new String("");
		String script_path = new String("");
		String launch_path = new String("");
		String report_path = new String(""); //also named location in Status
		//initialize all data
		task_data.putAll(deep_clone.clone(case_data));
		HashMap<String, String> paths_hash = new HashMap<String, String>();
		//common info prepare
		String xlsx_dest = task_data.get("CaseInfo").get("xlsx_dest").trim().replaceAll("\\\\", "/");
		String repository = task_data.get("CaseInfo").get("repository").trim().replaceAll("\\\\", "/");	
		String suite_path = task_data.get("CaseInfo").get("suite_path").trim().replaceAll("\\\\", "/");	
		String design_name = task_data.get("CaseInfo").get("design_name").trim().replaceAll("\\\\", "/");
		String launch_dir = task_data.get("LaunchCommand").get("dir").trim().replaceAll("\\\\", "/");
		String tmp_result = public_data.WORKSPACE_RESULT_DIR;
		String prj_name = "prj" + task_data.get("ID").get("project");
		String run_name = "run" + task_data.get("ID").get("run");
		String task_name = "T" + task_data.get("ID").get("id_index");
		String work_space = public_data.DEF_WORK_SPACE;
        String save_space = public_data.DEF_SAVE_SPACE;
		String case_mode = task_data.get("Preference").get("case_mode").trim();
		String keep_path = task_data.get("Preference").get("keep_path").trim();     
        //get design base name
		File design_name_fobj = new File(design_name);
		String design_base_name = design_name_fobj.getName();
		paths_hash.put("base_name", design_base_name);
		//get case name
		case_name = get_source_unzip_name(design_base_name);
		paths_hash.put("case_name", case_name);
		//get depot_space
		repository = repository.replaceAll("\\$xlsx_dest", xlsx_dest);
		depot_space = repository + "/" + suite_path;
		paths_hash.put("depot_space", depot_space.replaceAll("\\\\", "/"));
		//get work space
        if (preference_data.containsKey("work_space")) {
        	work_space = preference_data.get("work_space");
        }
        paths_hash.put("work_space", work_space.replaceAll("\\\\", "/"));
		//get save space
        if (preference_data.containsKey("save_space")) {
        	save_space = preference_data.get("save_space");
        }
        if (task_data.get("Preference").containsKey("save_space")) {
        	save_space = task_data.get("Preference").get("save_space");
        }
        save_space = save_space.replaceAll("\\$xlsx_dest", xlsx_dest); 
        paths_hash.put("save_space", save_space.replaceAll("\\\\", "/"));
		//get source_path
		design_url = repository + "/" + suite_path + "/" + design_name;
		paths_hash.put("design_url", design_url.replaceAll("\\\\", "/"));
		//get case_path
		if (case_mode.equalsIgnoreCase("hold_case")){
			case_path = design_url.replaceAll("\\\\", "/");
		} else {
			if(keep_path.equalsIgnoreCase("true")){
				String[] path_array = new String[] { work_space, tmp_result, prj_name, run_name, get_source_unzip_name(design_name)};
				case_path = String.join(file_seprator, path_array).replaceAll("\\\\", "/");
			} else {
				String[] path_array = new String[] { work_space, tmp_result, prj_name, run_name, task_name, get_source_unzip_name(design_base_name)};
				case_path = String.join(file_seprator, path_array).replaceAll("\\\\", "/");
			}	
		}
		paths_hash.put("case_path", case_path);
		//get task_path
		if (case_mode.equalsIgnoreCase("hold_case")){
			task_path = repository + "/" + suite_path;
		} else {
			if(keep_path.equalsIgnoreCase("true")){
				String[] path_array = new String[] { work_space, tmp_result, prj_name, run_name };
				task_path = String.join(file_seprator, path_array).replaceAll("\\\\", "/");
			} else {
				String[] path_array = new String[] { work_space, tmp_result, prj_name, run_name, task_name};
				task_path = String.join(file_seprator, path_array).replaceAll("\\\\", "/");
			}
		}
		paths_hash.put("task_path", task_path);
		//get suite local work suite path
		if (case_mode.equalsIgnoreCase("hold_case")){
			work_suite = repository + "/" + suite_path;
		} else {
			String[] path_array = new String[] { work_space, tmp_result, prj_name, run_name };
			work_suite = String.join(file_seprator, path_array).replaceAll("\\\\", "/");
		}
		paths_hash.put("work_suite", work_suite);		
		//get suite save path save_suite
        String[] tmp_space = save_space.split("\\s*,\\s*");
        ArrayList<String> tmp_suite = new ArrayList<String>();    
		if (case_mode.equalsIgnoreCase("hold_case")){
			save_suite = repository + "/" + suite_path;
		} else {
		    for(String space:tmp_space) {
		        String s_path = new String("");
		        String[] path_array = new String[]{space.trim(), tmp_result, prj_name, run_name};
                s_path = String.join(file_seprator, path_array);
                if(s_path.startsWith("//")){
                    s_path = s_path.replace('/', '\\');
                }
                tmp_suite.add(s_path);
            }
		    save_suite = String.join(",", tmp_suite);
		}
		paths_hash.put("save_suite", save_suite);
		//get save_path
        ArrayList<String> tmp_path = new ArrayList<String>();    
		if (case_mode.equalsIgnoreCase("hold_case")){
			save_path = repository + "/" + suite_path + "/" + design_name;
		} else {
		    for(String space:tmp_space) {
		        String s_path = new String("");
                if (keep_path.equalsIgnoreCase("true")) {
                    String[] path_array = new String[]{space.trim(), tmp_result, prj_name, run_name, get_source_unzip_name(design_name)};
                    s_path = String.join(file_seprator, path_array);
                } else {
                    String[] path_array = new String[]{space.trim(), tmp_result, prj_name, run_name, task_name};
                    s_path = String.join(file_seprator, path_array);
                }
                if(s_path.startsWith("//")){
                    s_path = s_path.replace('/', '\\');
                }
                tmp_path.add(s_path);
            }
            save_path = String.join(",", tmp_path);
		}
		paths_hash.put("save_path", save_path);	
		//get script_source
		script_url = task_data.get("CaseInfo").get("script_url").trim().replaceAll("\\\\", "/");
		script_url = script_url.replaceAll("\\$work_path", work_space);// = work_space
		script_url = script_url.replaceAll("\\$case_path", case_path);
		script_url = script_url.replaceAll("\\$tool_path", public_data.TOOLS_ROOT_PATH);		
		paths_hash.put("script_url", script_url);
		//get script_name
		if (script_url == null || script_url.equals("")) {
			script_base = "";
		} else {
			script_base = script_url.substring(script_url.lastIndexOf("/") + 1);
		}
		paths_hash.put("script_base", script_base);
		paths_hash.put("script_name", get_source_unzip_name(script_base));
		//get script_path
		if (script_url == null || script_url.equals("")) {
			script_path = "";
		} else if(script_url.startsWith(work_space) || script_url.startsWith(case_path) || script_url.startsWith(public_data.TOOLS_ROOT_PATH)) {
			script_path = script_url;
		} else {
			script_path = task_path + "/" + get_source_unzip_name(script_base); 
		}
		paths_hash.put("script_path", script_path);
		//get launch_path
		if ( launch_dir != null && launch_dir.length() > 0 ){
			launch_path = launch_dir.replaceAll("\\$case_path", case_path);
			launch_path = launch_path.replaceAll("\\$work_path", work_space);
			launch_path = launch_path.replaceAll("\\$tool_path", public_data.TOOLS_ROOT_PATH);
		} else {
			launch_path = task_path;
		}
		paths_hash.put("launch_path", launch_path);
		//get report_path
		if (case_mode.equalsIgnoreCase("hold_case")){
			report_path = case_path;
		} else {
			if(keep_path.equalsIgnoreCase("true")){
				report_path = case_path;
			} else {
				report_path = task_path;
			}
		}
		paths_hash.put("report_path", report_path);
		//push back
		task_data.put("Paths", paths_hash);
		return task_data;
	}

	private String get_source_unzip_name(
			String ori_name) {
		String return_str = new String("");
		Boolean zip_file = Boolean.valueOf(false);
		for (zip_enum zip_type : zip_enum.values()) {
			if (zip_type.equals(zip_enum.NO) || zip_type.equals(zip_enum.UNKNOWN)) {
				continue;
			}
			if (ori_name.contains(zip_type.get_description())) {
				zip_file = true;
				break;
			}
		}
		if (zip_file) {
			return_str = ori_name.split("\\.")[0];
		} else {
			return_str = ori_name;
		}
		return return_str;
	}
	
	private HashMap<String, HashMap<String, String>> get_merged_local_task_info(
			HashMap<String, HashMap<String, String>> admin_hash, 
			HashMap<String, HashMap<String, String>> case_hash) {
		HashMap<String, HashMap<String, String>> merged_data = new HashMap<String, HashMap<String, String>>();
		// case_hash is formated
		String admin_id_run = admin_hash.get("ID").get("run"); 
		HashMap<String, String> id_data = case_hash.get("ID");
		id_data.put("run", admin_id_run);
		merged_data.putAll(case_hash);
		return merged_data;
	}
	
	private HashMap<String, HashMap<String, String>> get_merged_remote_task_info(
			HashMap<String, HashMap<String, String>> admin_hash, 
			HashMap<String, HashMap<String, String>> case_hash) {
		HashMap<String, HashMap<String, String>> merged_data = new HashMap<String, HashMap<String, String>>();
		// case_hash is formated
		Iterator<String> case_hash_it = case_hash.keySet().iterator();
		while (case_hash_it.hasNext()) {
			String key_name = case_hash_it.next();
			HashMap<String, String> case_info = new HashMap<String, String>();
			case_info.putAll(case_hash.get(key_name));
			HashMap<String, String> merge_info = new HashMap<String, String>();
			if (admin_hash.containsKey(key_name)) {
				HashMap<String, String> admin_info = new HashMap<String, String>();
				admin_info.putAll(admin_hash.get(key_name));
				merge_info.putAll(local_tube.comm_admin_task_merge(admin_info, case_info, key_name));
			} else {
				merge_info.putAll(case_info);
			}
			merged_data.put(key_name, merge_info);
		}
		return merged_data;
	}

	private int get_time_out(String time_out) {
		Pattern p_timeout = Pattern.compile("\\D");
		Matcher m = p_timeout.matcher(time_out);
		//if non-digital found in string, make a default value
		if (m.find())
			time_out = "3600";
		//parse the timeout
		Integer data = Integer.valueOf(3600);
		Integer data_max = Integer.valueOf(Integer.MAX_VALUE -10);//discount 10 to avoid future overflow.
		try {
			data = Integer.parseInt(time_out);
		} catch (NumberFormatException e){
			TASK_WAITER_LOGGER.warn("Wrong timeout value found, will use default:3600 seconds");
		}
		//translate 0 to maximum integer
		if (data.equals(0)) {
			data = data_max;
		}
		//limit the maximum data
		if (data > data_max){
			data = data_max; 
		}
		return data;
	}
	
	private Boolean get_task_record_request(
			HashMap<String, HashMap<String, String>> task_data
			) {
		Boolean request = Boolean.valueOf(public_data.TASK_DEF_VIDEO_RECORD);
		//by default squish case will be record
		if(task_data.get("Software").containsKey("squish") && task_data.get("Environment").containsKey(public_data.ENV_SQUISH_RECORD)) {
			request = true;
		}
		if(task_data.get("Preference").containsKey("video_record")) {
			if (task_data.get("Preference").get("video_record").equalsIgnoreCase("true")) {
				request = true;
			}
		}
		return request;
	}
	
	private String get_last_error_msg(ArrayList<String> message_list){
		String return_string = new String("NA");
		if (message_list == null || message_list.isEmpty()) {
			return return_string;
		}
		Pattern p = Pattern.compile("^error", Pattern.CASE_INSENSITIVE);		
		for (String line : message_list) {
			Matcher m = p.matcher(line);
			if (m.find()) {
				return_string = line;
			}
		}		
		return return_string;
	}
	
	private String calculate_admin_queue_greed_mode(
			String queue_name,
			HashMap<String, HashMap<String, String>> admin_data
			) {
		//input 1: client default
		String greed_value = new String(client_info.get_client_preference_data().getOrDefault("greed_mode", public_data.DEF_CLIENT_GREED_MODE));
		//input 2: remote task inputs
		if (admin_data.get("Preference").containsKey("greed_mode")) {
			greed_value = admin_data.get("Preference").get("greed_mode");
		}
		if (greed_value.equals("auto")) {
			if (admin_data.get("LaunchCommand").containsKey("cmd_1") || admin_data.get("LaunchCommand").containsKey("cmd_2")) {
				greed_value = "true";
			} else {
				greed_value = "false";
			}
		}
		task_info.update_admin_queue_attribute_value(queue_name, queue_attr.GREED_MODE, greed_value);
		return greed_value;
	}
	
	private String get_admin_queue_greed_mode(
			String queue_name,
			HashMap<String, HashMap<String, String>> admin_data
			) {
		String greed_mode = new String("");
		greed_mode = task_info.get_admin_queue_attribute_value(queue_name, queue_attr.GREED_MODE);
		if(greed_mode == null || greed_mode.equals("")) {
			greed_mode = calculate_admin_queue_greed_mode(queue_name, admin_data);
		} 
		return greed_mode;
	}
	
	private float get_task_estimated_memory(
			String queue_name,
			HashMap<String, HashMap<String, String>> admin_data
			) {
		float est_mem = 0.0f;
		//1. default memory requirement:available memory * 0.6
		float sys_mem_avi = 0.0f;
		sys_mem_avi = Float.valueOf(client_info.get_client_system_data().get("mem_free")).floatValue();
		float max_est_mem = sys_mem_avi * 0.60f;
		if (max_est_mem > public_data.TASK_DEF_ESTIMATE_MEM_MAX) {
			est_mem = public_data.TASK_DEF_ESTIMATE_MEM_MAX;
		} else if(max_est_mem < public_data.TASK_DEF_ESTIMATE_MEM_MIN) {
			est_mem = public_data.TASK_DEF_ESTIMATE_MEM_MIN;
		} else {
			est_mem = max_est_mem;
		}
		//2. history memory requirement
		if(task_info.get_client_run_case_summary_memory_map(queue_name).containsKey("avg")) {
			est_mem = task_info.get_client_run_case_summary_memory_map(queue_name).get("avg");
		}
		//3. user memory requirement
		if(admin_data.get("CaseInfo").containsKey("est_mem")) {
			float usr_est_mem = 0;
			try {
				usr_est_mem = Float.valueOf(admin_data.get("CaseInfo").get("est_mem"));
			} catch (NumberFormatException e) {
				TASK_WAITER_LOGGER.debug(admin_data.get("CaseInfo").get("est_mem") + ", wrong number format, ignored.");
			}
			if(usr_est_mem > 0) {
				if(usr_est_mem > 32) {
					est_mem = 32.0f;
					TASK_WAITER_LOGGER.debug(admin_data.get("CaseInfo").get("est_mem") + "> 32G, use 32G instead.");
				} else {
					est_mem = usr_est_mem;
				}
			}
		}
		return est_mem;
	}
	
	private float get_task_estimated_space(
			String queue_name,
			HashMap<String, HashMap<String, String>> admin_data
			) {
		//1. default space requirement
		float est_space = public_data.TASK_DEF_ESTIMATE_SPACE;
		//2. history space requirement
		if(task_info.get_client_run_case_summary_space_map(queue_name).containsKey("avg")) {
			est_space = task_info.get_client_run_case_summary_space_map(queue_name).get("avg");
		}
		//3. user space requirement
		if(admin_data.get("CaseInfo").containsKey("est_space")) {
			float usr_est_space = 0;
			try {
				usr_est_space = Float.valueOf(admin_data.get("CaseInfo").get("est_space"));
			} catch (NumberFormatException e) {
				TASK_WAITER_LOGGER.debug(admin_data.get("CaseInfo").get("est_space") + ", wrong number format, ignored.");
			}
			if(usr_est_space > 0) {
				if(usr_est_space > 32) {
					est_space = 32.0f;
					TASK_WAITER_LOGGER.debug(admin_data.get("CaseInfo").get("est_space") + "> 32G, use 32G instead.");
				} else {
					est_space = usr_est_space;
				}
			}
		}
		return est_space;
	}
	
	private void run_invalid_queue_name_jobs(
			) {
		//reporting
		if (waiter_name.equalsIgnoreCase("tw_0") && !switch_info.get_local_console_mode()){
			TASK_WAITER_LOGGER.info(waiter_name + ":No runnable queue found.");
		} else {
			TASK_WAITER_LOGGER.debug(waiter_name + ":No runnable queue found.");
		}
	}
	
	private void run_invalid_admin_data_jobs(
			String queue_name
			) {
		//reporting
		TASK_WAITER_LOGGER.warn(waiter_name + ":Empty admin queue find," + queue_name);
	}
	
	private void run_invalid_resource_booking_jobs(
			String queue_name
			) {
		//reporting
		if (waiter_name.equalsIgnoreCase("tw_0") && !switch_info.get_local_console_mode()){
			TASK_WAITER_LOGGER.info(waiter_name + ":System resource limitation, Skipping:" + queue_name);
		} else {
			TASK_WAITER_LOGGER.debug(waiter_name + ":System resource limitation, Skipping:" + queue_name);
		}
	}
	
	private void run_invalid_tasks_data_jobs(
			String queue_name,
			float est_mem,
			float est_space,
			Boolean cmds_parallel,
			String greed_mode,
			HashMap<String, HashMap<String, String>> admin_data
			) {
		//reporting
		if (switch_info.get_local_console_mode()){
			TASK_WAITER_LOGGER.debug(waiter_name + ":Try change queue to finished status:" + queue_name);
		} else {
			TASK_WAITER_LOGGER.info(waiter_name + ":Try change queue to finished status:" + queue_name);
		}
		// move queue form received to processed admin queue treemap
		move_emptied_admin_queue_from_tube(queue_name);
		move_emptied_task_queue_from_tube(queue_name);
		// update list must be placed here to avoid multi threads risk
		try {
			Thread.sleep(10);// make the thread safe
		} catch (InterruptedException e) {
			TASK_WAITER_LOGGER.info(waiter_name + ":Sleep error out");
		}
		task_info.decrease_executing_admin_queue_list(queue_name);	
		task_info.decrease_processing_admin_queue_list(queue_name);				
		task_info.increase_emptied_admin_queue_list(queue_name);
		// release booking info
		if(!greed_mode.equals("true")) {
			client_info.release_used_soft_insts(admin_data.get("Software"), cmds_parallel);
		}
		client_info.decrease_registered_space(est_space);
		client_info.decrease_registered_memory(est_mem);
		pool_info.release_reserved_threads(1);
	}
	
	private void run_invalid_case_id_jobs(
			String queue_name,
			float est_mem,
			float est_space,
			Boolean cmds_parallel,
			String greed_mode,
			HashMap<String, HashMap<String, String>> admin_data,
			HashMap<String, HashMap<String, String>> task_data
			) {
		//reporting
		TASK_WAITER_LOGGER.info(waiter_name + ":No Task id find, skip launching:" + task_data.toString());
		// release booking info
		if(!greed_mode.equals("true")) {
			client_info.release_used_soft_insts(admin_data.get("Software"), cmds_parallel);
		}
		client_info.decrease_registered_space(est_space);
		client_info.decrease_registered_memory(est_mem);
		pool_info.release_reserved_threads(1);
	}
	
	private void run_invalid_register_status_jobs(
			String queue_name,
			String case_id,
			float est_mem,
			float est_space,
			Boolean cmds_parallel,
			String greed_mode,
			HashMap<String, HashMap<String, String>> admin_data
			) {
		//reporting
		if (switch_info.get_local_console_mode()){
			TASK_WAITER_LOGGER.debug(waiter_name + ":Launch failed:" + queue_name + "," + case_id + ", skipped.");
		} else {
			TASK_WAITER_LOGGER.info(waiter_name + ":Launch failed:" + queue_name + "," + case_id + ", skipped.");
		}
		// release booking info
		if(!greed_mode.equals("true")) {
			client_info.release_used_soft_insts(admin_data.get("Software"), cmds_parallel);
		}
		client_info.decrease_registered_space(est_space);
		client_info.decrease_registered_memory(est_mem);
		pool_info.release_reserved_threads(1);
	}
	
	private void run_valid_register_status_jobs(
			String queue_name,
			String case_id
			) {
		//reporting
		if (switch_info.get_local_console_mode()){
			TASK_WAITER_LOGGER.debug(waiter_name + ":Launching " + queue_name + "," + case_id);
		} else {
			TASK_WAITER_LOGGER.info(waiter_name + ":Launching " + queue_name + "," + case_id);
		}
	}
	
	private void run_invalid_task_prepare_jobs(
			String queue_name,
			String case_id,
			float est_mem,
			float est_space,
			Boolean cmds_parallel,
			String greed_mode,
			HashMap<String, HashMap<String, String>> admin_data
			) {
		//reporting
		if(!greed_mode.equals("true")) {
			client_info.release_used_soft_insts(admin_data.get("Software"), cmds_parallel);
		}
		client_info.decrease_registered_space(est_space);
		client_info.decrease_registered_memory(est_mem);
		pool_info.release_reserved_threads(1);
		task_info.increase_client_run_case_summary_status_map(queue_name, task_enum.BLOCKED, 1);
		TASK_WAITER_LOGGER.info("Task launch failed:" + queue_name + "," + case_id);
	}
	
	private void run_pre_launch_reporting(
			String queue_name, 
			String case_id,			
			HashMap<String, HashMap<String, String>> task_data,
			task_prepare prepare_obj,
			task_report report_obj,
			Boolean prepare_ok
			){
		//synchronized (this.getClass()) {}
		//prepare common inform
		String run_time = new String("NA");
		String update_time = new String(time_info.get_man_date_time());
		task_enum cmd_status = task_enum.OTHERS;
		if (prepare_ok){
			cmd_status = task_enum.PROCESSING;
		} else {
			cmd_status = task_enum.FAILED;
		}
		ArrayList<String> task_prepare_info_list = new ArrayList<String>();
		task_prepare_info_list.addAll(prepare_obj.task_prepare_info);
		String cmd_reason = new String("NA");
		cmd_reason = get_last_error_msg(task_prepare_info_list);
		String report_path = new String("NA");
		report_path = task_data.get("Paths").get("report_path");
		//task 1 update processed task data info 
		HashMap<String, String> status_data = task_data.get("Status");
		status_data.put("run_time", run_time);
		status_data.put("update_time", update_time);
		status_data.put("cmd_status", cmd_status.get_description());
		status_data.put("cmd_reason", cmd_reason);
		status_data.put("location", report_path);
		task_info.update_case_to_processed_task_queues_map(queue_name, case_id, task_data);
		//task 2 send case report to local disk
		HashMap<String, String> system_data = new HashMap<String, String>();
		system_data.putAll(client_info.get_client_system_data());
		String host_name = client_info.get_client_machine_data().get("terminal");
		String account = client_info.get_client_machine_data().getOrDefault("account", "NA");
		ArrayList<String> title_list = new ArrayList<String>();
		title_list.add("");
		title_list.add("============================================================");
		title_list.add("Run Time:" + time_info.get_date_time());
		StringBuilder hostlog = new StringBuilder();
		hostlog.append("Host Info:");
		hostlog.append(host_name + "(" + account + "), ");
		hostlog.append("OS:" + system_data.getOrDefault("os", "NA") + ", ");
		hostlog.append("CPU:" + system_data.getOrDefault("cpu", "NA") + ", ");
		hostlog.append("MEM:" + system_data.getOrDefault("mem", "NA"));
		title_list.add(hostlog.toString());
		title_list.add("Task Queue:" + queue_name);
		title_list.add("Task Case:" + case_id);
		title_list.add("");
		title_list.add("[Setup]");
		report_obj.dump_disk_task_report_data(report_path, title_list);
		report_obj.dump_disk_task_report_data(report_path, task_prepare_info_list);
		//task 3 send case report to tube
		HashMap<String, HashMap<String, Object>> report_data = new HashMap<String, HashMap<String, Object>>();
		HashMap<String, Object> hash_data = new HashMap<String, Object>();
		String task_index = case_id + "#" + queue_name;
		if (task_data.get("ID").containsKey("breakpoint")) {
			hash_data.put("breakpoint", task_data.get("ID").get("breakpoint"));
		}
		hash_data.put("testId", task_data.get("ID").get("id"));
		hash_data.put("suiteId", task_data.get("ID").get("suite"));
		hash_data.put("runId", task_data.get("ID").get("run"));
		hash_data.put("projectId", task_data.get("ID").get("project"));
		hash_data.put("design", task_data.get("CaseInfo").get("design_name"));		
		hash_data.put("status", cmd_status);
		hash_data.put("reason", cmd_reason);
		hash_data.put("location", report_path);
		hash_data.put("run_time", run_time);
		hash_data.put("update_time", update_time);
		report_data.put(task_index, hash_data);
		report_obj.send_tube_task_data_report(report_data, false);
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
		// initial 1 : import_history_finished_admin_queue
		task_info.update_finished_admin_queue_list(import_data.import_disk_finished_admin_queue_list(client_info));
		// initial 2 : retrieve previously dumping working queues
		retrieve_queues_into_memory();
		// initial end
		task_report report_obj = new task_report(pool_info, client_info);
		waiter_thread = Thread.currentThread();
		while (!stop_request) {
			if (wait_request) {
				TASK_WAITER_LOGGER.debug(waiter_name + ":Waiting...");
				try {
					synchronized (this) {
						this.wait();
					}
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} else {
				this.waiter_status = "work";
				TASK_WAITER_LOGGER.debug(waiter_name + ":Running...");
				switch_info.update_threads_active_map(thread_enum.task_runner, time_info.get_date_time());
			}
			// take a rest
			try {
				Thread.sleep(base_interval * 1 * 1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			// ============== All dynamic job start from here ==============
			// task 0 : initial preparing,  load task data for re-processing queues
			reload_repressing_queue_data();// reload finished task data if queue changed to processing from finished
			// task 1 : check available work environments 
			if(!start_new_task_check()){
				continue;
			}
			// task 2 : get working queue => key variable 1: queue_name OK now
			String queue_name = new String("");
			queue_name = get_right_task_queue();
			if (queue_name == null || queue_name.equals("")) {
				run_invalid_queue_name_jobs();
				continue;
			}
			// task 3 : get admin data =>key variable 2: admin_data OK now
			HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
			admin_data.putAll(get_final_admin_data(queue_name));
			if (admin_data.isEmpty()) {
				run_invalid_admin_data_jobs(queue_name);
				continue; // in case this queue deleted by other threads
			}
			float est_mem = get_task_estimated_memory(queue_name, admin_data);
			float est_space = get_task_estimated_space(queue_name, admin_data);
			String greed_mode = get_admin_queue_greed_mode(queue_name, admin_data);
			Boolean cmds_parallel = Boolean.valueOf(admin_data.get("LaunchCommand").getOrDefault("parallel", public_data.TASK_DEF_CMD_PARALLEL).trim());
			// task 4 : resource booking (memory, thread, software)
			if (!system_resource_booking(queue_name, est_mem, est_space, cmds_parallel, greed_mode, admin_data)) {
				run_invalid_resource_booking_jobs(queue_name);
				continue;
			}
			// task 5 : get task data =>key variable 3: task_data OK now
			HashMap<String, HashMap<String, String>> task_data = new HashMap<String, HashMap<String, String>>();
			task_data.putAll(get_final_task_data(queue_name, admin_data, client_info.get_client_preference_data()));
			if (task_data.isEmpty()) {
				run_invalid_tasks_data_jobs(queue_name, est_mem, est_space, cmds_parallel, greed_mode, admin_data);
				continue;
			}
			// task 6 : get case_id, variable 4: case_id OK now, 12345, 12345_80_80
			String case_index = new String(task_data.get("ID").get("id_index"));
			if (case_index == null || case_index.equals("")){
				run_invalid_case_id_jobs(queue_name, est_mem, est_space, cmds_parallel, greed_mode, admin_data, task_data);
				continue;				
			}
			// task 7 : register task case to processed task queues map
			Boolean register_status = task_info.register_case_to_processed_task_queues_map(queue_name, case_index, task_data);
			if (register_status) {
				run_valid_register_status_jobs(queue_name, case_index);
			} else {
				run_invalid_register_status_jobs(queue_name, case_index, est_mem, est_space, cmds_parallel, greed_mode, admin_data);
				continue;// register false, someone register this case already.
			}
			// task 8 : get task info and case ready
			task_prepare prepare_obj = new task_prepare();
			String design_url = task_data.get("Paths").get("design_url").trim();
			String launch_path = task_data.get("Paths").get("launch_path").trim();
			String case_path = task_data.get("Paths").get("case_path").trim();
			String python_version = switch_info.get_system_python_version();
			String cmds_decision = task_data.get("LaunchCommand").getOrDefault("decision", public_data.TASK_DEF_CMD_DECISION).trim(); 
			Boolean corescript_link_status = switch_info.get_remote_corescript_linked();
			Boolean record_request = get_task_record_request(task_data);
			int case_timeout = get_time_out(task_data.get("CaseInfo").get("timeout"));
			Boolean task_ready = prepare_obj.get_task_case_ready(client_info.get_client_tools_data(), task_data);
			// task 9 : launch reporting
			run_pre_launch_reporting(queue_name, case_index, task_data, prepare_obj, report_obj, task_ready);
			if (!task_ready){
				run_invalid_task_prepare_jobs(queue_name, case_index, est_mem, est_space, cmds_parallel, greed_mode, admin_data);
				continue;
			} 
			// task 10 : launch
			screen_record record_object = null;
			if (record_request) {
				record_object = new screen_record(launch_path, "case_video", false);
				record_object.start();
			}
			TreeMap<String, HashMap<cmd_attr, List<String>>> launch_cmds = new TreeMap<String, HashMap<cmd_attr, List<String>>>();
			launch_cmds.putAll(prepare_obj.get_launch_commands(python_version, corescript_link_status, client_info.get_client_tools_data(), task_data, client_info.get_client_data()));
			system_call sys_call = new system_call(launch_cmds, cmds_parallel, cmds_decision, launch_path, case_timeout, greed_mode, client_info);
			pool_info.add_sys_call(sys_call, queue_name, case_index, launch_path, case_path, design_url, est_mem, est_space, case_timeout, record_request, record_object);
			client_info.decrease_registered_memory(est_mem);
			client_info.decrease_registered_space(est_space);
			TASK_WAITER_LOGGER.debug("Task launched:" + queue_name + "," + case_index);
		}
	}

	public void soft_stop() {
		stop_request = true;
		this.waiter_status = "stop";
	}

	public void hard_stop() {
		stop_request = true;
		if (waiter_thread != null) {
			waiter_thread.interrupt();
		}
		this.waiter_status = "stop";
	}

	public void wait_request() {
		this.waiter_status = "wait";
		wait_request = true;
	}

	public void wake_request() {
		this.waiter_status = "work";
		wait_request = false;
		synchronized (this) {
			this.notify();
		}
	}

	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		// pool_data pool_instance = new pool_data(10);
		// task_data task_data_instance = new task_data(null);

		task_waiter waiter = new task_waiter(0, null, null, null, null);
		waiter.start();
		try {
			Thread.sleep(20 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		waiter.wait_request();
		System.out.println(waiter.get_waiter_status());
		try {
			Thread.sleep(5 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		waiter.wake_request();
		System.out.println(waiter.get_waiter_status());
		try {
			Thread.sleep(5 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(waiter.get_waiter_status());
	}
}
