/*
 * File: cmd_parser.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package connect_tube;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.client_data;
import data_center.data_server;
import data_center.exit_enum;
import data_center.public_data;
import data_center.switch_data;
import flow_control.pool_data;
import info_parser.cmd_parser;
import info_parser.xml_parser;
import utility_funcs.deep_clone;
import utility_funcs.file_action;

public class tube_server extends Thread {
	// public property
	// public static ConcurrentHashMap<String, HashMap<String, HashMap<String,
	// String>>> captured_admin_queues = new ConcurrentHashMap<String,
	// HashMap<String, HashMap<String, String>>>();
	// protected property
	// private property
	private static final Logger TUBE_SERVER_LOGGER = LogManager.getLogger(tube_server.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread tube_thread;
	private switch_data switch_info;
	private client_data client_info;
	private pool_data pool_info;
	private task_data task_info;
	private rmq_tube rmq_runner;
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;
	private String line_separator = System.getProperty("line.separator");

	// public function
	public tube_server(switch_data switch_info, client_data client_info, pool_data pool_info, task_data task_info) {
		this.switch_info = switch_info;
		this.task_info = task_info;
		this.client_info = client_info;
		this.pool_info = pool_info;
		this.rmq_runner = new rmq_tube(task_info); // should be changed later
	}

	// protected function
	// private function

	private Boolean admin_queue_system_key_check(HashMap<String, HashMap<String, String>> queue_data,
			Map<String, HashMap<String, String>> client_hash) {
		Boolean system_match = new Boolean(true);
		if (!queue_data.containsKey("System")) {
			return system_match;
		}
		// check System match
		HashMap<String, String> system_require_data = queue_data.get("System");
		Set<String> system_require_set = system_require_data.keySet();
		Iterator<String> system_require_it = system_require_set.iterator();
		while (system_require_it.hasNext()) {
			String key_name = system_require_it.next();
			String value = system_require_data.get(key_name);
			if (!client_hash.get("System").containsKey(key_name)){
				system_match = false;
				break;
			}			
			if (key_name.equals("min_space")) {
				String client_available_space = client_hash.get("System").get("space");
				if (Integer.valueOf(value) > Integer.valueOf(client_available_space)) {
					system_match = false;
					break;
				}
			} else {
				if (!value.contains(client_hash.get("System").get(key_name))) {
					system_match = false;
					break;
				}
			}
		}
		return system_match;
	}

	private Boolean admin_queue_machine_key_check(HashMap<String, HashMap<String, String>> queue_data,
			Map<String, HashMap<String, String>> client_hash) {
		Boolean machine_match = new Boolean(true);
		if (!queue_data.containsKey("Machine")) {
			return machine_match;
		}
		// check machine match
		HashMap<String, String> machine_require_data = queue_data.get("Machine");
		Set<String> machine_require_set = machine_require_data.keySet();
		Iterator<String> machine_require_it = machine_require_set.iterator();
		while (machine_require_it.hasNext()) {
			String key_name = machine_require_it.next();
			String value = machine_require_data.get(key_name);
			if (!client_hash.get("Machine").containsKey(key_name)){
				machine_match = false;
				break;
			}
			if (!value.contains(client_hash.get("Machine").get(key_name))) {
				machine_match = false;
				break;
			}
		}
		String client_current_private = client_hash.get("Machine").get("private");
		if (client_current_private.equals("1")) {
			if (!machine_require_data.containsKey("terminal")) {
				machine_match = false;
			}
		}
		return machine_match;
	}

	private Boolean admin_queue_software_key_check(HashMap<String, HashMap<String, String>> queue_data,
			Map<String, HashMap<String, String>> client_hash) {
		Boolean software_match = new Boolean(true);
		if (!queue_data.containsKey("Software")) {
			return software_match;
		}
		// check software match
		HashMap<String, String> software_require_data = queue_data.get("Software");
		Set<String> software_require_set = software_require_data.keySet();
		Iterator<String> software_require_it = software_require_set.iterator();
		while (software_require_it.hasNext()) {
			String sw_name = software_require_it.next();
			String sw_build = software_require_data.get(sw_name);
			if (!client_hash.containsKey(sw_name)) {
				software_match = false;
				break;
			}
			if (!client_hash.get(sw_name).containsKey(sw_build)) {
				software_match = false;
				break;
			}
		}
		return software_match;
	}

	public ArrayList<String> admin_queue_mismatch_list_check(HashMap<String, HashMap<String, String>> queue_data,
			Map<String, HashMap<String, String>> client_hash) {
		ArrayList<String> mismatch_list = new ArrayList<String>();
		if (!admin_queue_system_key_check(queue_data, client_hash)) {
			mismatch_list.add("System");
		}
		if (!admin_queue_machine_key_check(queue_data, client_hash)) {
			mismatch_list.add("Machine");
		}
		if (!admin_queue_software_key_check(queue_data, client_hash)) {
			mismatch_list.add("Software");
		}
		return mismatch_list;
	}

	/*
	 * task 2: flash tube output: captured and rejected treemap
	 */
	private void flash_tube_output() {
		Map<String, HashMap<String, String>> client_data = new HashMap<String, HashMap<String, String>>();
		Map<String, HashMap<String, HashMap<String, String>>> total_admin_queue = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		TreeMap<String, HashMap<String, HashMap<String, String>>> captured_admin_queue = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		TreeMap<String, String> new_rejected_reason_queue = new TreeMap<String, String>();
		TreeMap<String, String> old_rejected_reason_queue = new TreeMap<String, String>();
		client_data.putAll(client_info.get_client_data());
		total_admin_queue.putAll(task_info.get_received_admin_queues_treemap());
		old_rejected_reason_queue.putAll(task_info.get_rejected_admin_reason_treemap());
		Set<String> queue_set = total_admin_queue.keySet();
		Iterator<String> queue_it = queue_set.iterator();
		while (queue_it.hasNext()) {
			String queue_name = queue_it.next();
			HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
			queue_data.putAll(total_admin_queue.get(queue_name));
			// check mismatch list
			ArrayList<String> mismatch_item = new ArrayList<String>();
			mismatch_item = admin_queue_mismatch_list_check(queue_data, client_data);
			if (mismatch_item.isEmpty()) {
				captured_admin_queue.put(queue_name, queue_data);
				if (!task_info.get_captured_admin_queues_treemap().containsKey(queue_name)) {
					TUBE_SERVER_LOGGER.info("Captured:" + queue_name);
				}
			} else {
				new_rejected_reason_queue.put(queue_name, String.join(",", mismatch_item));
				if (!old_rejected_reason_queue.containsKey(queue_name)) {
					TUBE_SERVER_LOGGER.info("Rejected:" + queue_name + ", Reason:" + mismatch_item.toString());
				}
			}
		}
		task_info.set_captured_admin_queues_treemap(captured_admin_queue);
		task_info.set_rejected_admin_reason_treemap(new_rejected_reason_queue);
	}

	private Boolean send_client_info(String mode) {
		Boolean send_status = new Boolean(true);
		HashMap<String, HashMap<String, String>> client_hash = new HashMap<String, HashMap<String, String>>();
		client_hash = deep_clone.clone(client_info.get_client_data());
		//bypass the client data sending in local model
		String link_mode = client_hash.get("preference").get("link_mode").toLowerCase();
		if (link_mode.equals("local")){
			TUBE_SERVER_LOGGER.debug("Client run in Local mode, bypass client info sending.");
			return send_status;
		}
		ArrayList<String> processing_admin_queue_list = new ArrayList<String>();
		processing_admin_queue_list.addAll(task_info.get_processing_admin_queue_list());
		HashMap<String, String> simple_data = new HashMap<String, String>();
		HashMap<String, String> complex_data = new HashMap<String, String>();
		String host_name = client_hash.get("Machine").get("terminal");
		String admin_request = "1";
		String cpu_used = client_hash.get("System").get("cpu");
		int cpu_used_int = 0;
		try{
			cpu_used_int = Integer.parseInt(cpu_used);
		} catch (Exception e) {
			cpu_used_int = 99;
		}
		String status = new String();
		if (cpu_used_int > 60) {
			status = "Busy";
		} else {
			status = "Free";
		}
		int used_thread = pool_info.get_pool_used_threads();
		int max_thread = pool_info.get_pool_current_size();
		String rpt_thread = String.valueOf(used_thread) + "/" + String.valueOf(max_thread);
		simple_data.put("host_name", host_name);
		simple_data.put("status", status);
		simple_data.put("used_thread", rpt_thread);
		simple_data.put("task_take", String.join(line_separator, processing_admin_queue_list));
		//client only sent request(1), server side will response and reset the value to 0
		if (switch_info.impl_send_admin_request()) {
			simple_data.put("admin_request", admin_request);
		}		
		// complex data send
		String host_ip = client_hash.get("Machine").get("ip");
		String os = client_hash.get("System").get("os");
		String group_name = client_hash.get("Machine").get("group");
		String memory_used = client_hash.get("System").get("mem");
		String disk_left = client_hash.get("System").get("space");
		String os_type = client_hash.get("System").get("os_type");
		String private_mode = client_hash.get("Machine").get("private");
		String unattended_mode = client_hash.get("Machine").get("unattended");
		String client_version = public_data.BASE_CURRENTVERSION;
		//String high_priority = "NA";
		//String max_threads = String.valueOf(max_thread);
		complex_data.putAll(simple_data);
		complex_data.put("host_ip", host_ip);
		complex_data.put("os", os);
		complex_data.put("group_name", group_name);
		complex_data.put("memory_used", memory_used);
		complex_data.put("disk_left", disk_left);
		complex_data.put("cpu_used", cpu_used);
		complex_data.put("os_type", os_type);
		complex_data.put("private_mode", private_mode);
		complex_data.put("unattended_mode", unattended_mode);
		complex_data.put("client_version", client_version);
		//complex_data.put("high_priority", high_priority);
		//complex_data.put("max_threads", max_threads);
		Iterator<String> client_hash_it = client_hash.keySet().iterator();
		while (client_hash_it.hasNext()) {
			String key_name = client_hash_it.next();
			if (key_name.equals("Machine") || key_name.equals("System") || key_name.equals("preference")) {
				continue;
			}
			Set<String> value_set = client_hash.get(key_name).keySet();
			if (value_set.contains("scan_dir")) {
				value_set.remove("scan_dir");
			}
			if (value_set.contains("max_insts")) {
				value_set.remove("max_insts");
			}
			String key_value = String.join(line_separator, value_set);
			if (key_value.equals("")) {
				key_value = "NA";
			}
			complex_data.put(key_name, key_value);
		}
		// generate xml message
		String send_msg = new String();
		xml_parser parser = new xml_parser();
		if (mode.equals("simple")) {
			send_msg = parser.create_client_document_string(simple_data);
		} else {
			send_msg = parser.create_client_document_string(complex_data);
		}
		send_status = rmq_runner.basic_send(public_data.RMQ_CLIENT_NAME, send_msg);
		return send_status;
	}

	private void run_import_local_admin() {
		ArrayList<String> suite_file_list = switch_info.get_suite_file_list();
		if (suite_file_list.isEmpty()) {
			return;
		}
		local_tube local_tube_parser = new local_tube(task_info);
		String terminal = new String(client_info.get_client_data().get("Machine").get("terminal"));
		int counter = 0;
		while(true){
			if (counter > 10){
				break;
			}
			String suite_file = switch_info.get_one_suite_file();
			if (suite_file.equals("")){
				break;
			}
			local_tube_parser.generate_local_admin_task_queues(suite_file, terminal);
			counter++;
		}
	}

	private void run_import_remote_admin(){
		String link_mode = client_info.get_client_data().get("preference").get("link_mode");
		if (link_mode.equalsIgnoreCase("local")){
			try {
				rmq_runner.stop_admin_tube();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				TUBE_SERVER_LOGGER.error("Stop Link to RabbitMQ server failed.");
			}
		} else {
			try {
				rmq_runner.start_admin_tube(client_info.get_client_data().get("Machine").get("terminal"));
			} catch (Exception e1) {
				TUBE_SERVER_LOGGER.error("Link to RabbitMQ server failed.");
			}
		}
	}
	
	private void run_received_admin_sorting(){
		String link_mode = client_info.get_client_data().get("preference").get("link_mode");
		if (link_mode.equalsIgnoreCase("both")){
			return;
		}
		TreeMap<String, HashMap<String, HashMap<String, String>>> sorting_admin_queues_treemap = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		sorting_admin_queues_treemap.putAll(deep_clone.clone(task_info.get_received_admin_queues_treemap()));
		Iterator<String> queue_iterator = sorting_admin_queues_treemap.keySet().iterator();
		if (link_mode.equalsIgnoreCase("local")){
			while(queue_iterator.hasNext()){
				String queue_name = queue_iterator.next();
				if (queue_name.contains("1@")){
					task_info.remove_queue_from_received_admin_queues_treemap(queue_name);
				}
			}
		} else if (link_mode.equalsIgnoreCase("remote")) {
			while(queue_iterator.hasNext()){
				String queue_name = queue_iterator.next();
				if (queue_name.contains("0@")){
					task_info.remove_queue_from_received_admin_queues_treemap(queue_name);
				}
			}			
		} else {
			return;
		}
	}
	
	public void run() {
		try {
			monitor_run();
		} catch (Exception run_exception) {
			run_exception.printStackTrace();
			String dump_path = client_info.get_client_data().get("preference").get("work_path") 
					+ "/" + public_data.WORKSPACE_LOG_DIR + "/core_dump/dump.log";
			file_action.append_file(dump_path, run_exception.toString() + line_separator);
			for(Object item: run_exception.getStackTrace()){
				file_action.append_file(dump_path, "    at " + item.toString() + line_separator);
			}			
			switch_info.set_client_stop_request(exit_enum.DUMP);
		}
	}

	private void monitor_run() {
		tube_thread = Thread.currentThread();
		// ============== All static job start from here ==============
		// initial 1 : send client detail info
		send_client_info("complex");
		// initial 2 : Announce tube server ready
		switch_info.set_tube_server_power_up();
		int send_count = 0;
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
				TUBE_SERVER_LOGGER.debug("Tube Server running...");
			}
			// ============== All dynamic job start from here ==============
			// task 1: update remote admin
			run_import_remote_admin();
			// task 2: update local admin (local file, import)
			run_import_local_admin();
			// task 3 flash tube input:
			run_received_admin_sorting();
			// task 4: flash tube output: captured and rejected treemap
			flash_tube_output();
			// task 5: send client info to Remote server
			if (send_count < 10) {
				send_count++;
				send_client_info("simple");
			} else {
				send_count = 0;
				send_client_info("complex");
			}
			try {
				Thread.sleep(base_interval * 1 * 1000);
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
		if (tube_thread != null) {
			tube_thread.interrupt();
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
		cmd_parser cmd_run = new cmd_parser(args);
		HashMap<String, String> cmd_info = cmd_run.cmdline_parser();
		switch_data switch_info = new switch_data();
		client_data client_info = new client_data();
		pool_data pool_info = new pool_data(10);
		task_data task_info = new task_data();
		data_server data_runner = new data_server(cmd_info, switch_info, client_info, pool_info);
		data_runner.start();
		while (true) {
			if (switch_info.get_data_server_power_up()) {
				break;
			}
		}
		tube_server tube_runner = new tube_server(switch_info, client_info, pool_info, task_info);
		tube_runner.start();
		while (true) {
			// System.out.println(task_info.get_rejected_admin_reason_treemap());
			try {
				Thread.sleep(2000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
}