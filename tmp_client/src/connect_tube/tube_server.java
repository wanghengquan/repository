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
import data_center.public_data;
import data_center.switch_data;
import flow_control.pool_data;
import info_parser.xml_parser;
import utility_funcs.deep_clone;

public class tube_server extends Thread {
	// public property
	// public static ConcurrentHashMap<String, HashMap<String, HashMap<String, String>>> captured_admin_queues = new ConcurrentHashMap<String, HashMap<String, HashMap<String, String>>>();
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
	private String line_seprator = System.getProperty("line.separator");

	// public function
	public tube_server(switch_data switch_info, client_data client_info, pool_data pool_info, task_data task_info) {
		this.switch_info = switch_info;
		this.task_info = task_info;
		this.client_info = client_info;
		this.pool_info = pool_info;
		this.rmq_runner = new rmq_tube(task_info);   //should be changed later
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
		if(!admin_queue_system_key_check(queue_data, client_hash)){
			mismatch_list.add("System");
		}
		if(!admin_queue_machine_key_check(queue_data, client_hash)){
			mismatch_list.add("Machine");
		}
		if(!admin_queue_software_key_check(queue_data, client_hash)){
			mismatch_list.add("Software");
		}		
		return mismatch_list;
	}
	
	/*
	 * task 2: flash tube output: captured and rejected treemap
	 */
	private void flash_tube_output(){
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
			} else {
				new_rejected_reason_queue.put(queue_name, String.join(",", mismatch_item));
				if(!old_rejected_reason_queue.containsKey(queue_name)){
					TUBE_SERVER_LOGGER.warn("Rejected:" + queue_name + ", Reason:" + mismatch_item.toString());
				}
			}
		}
		task_info.set_captured_admin_queues_treemap(captured_admin_queue);
		task_info.set_rejected_admin_reason_treemap(new_rejected_reason_queue);
	}
	
	/*
	private void update_captured_admin_queues() {
		Map<String, HashMap<String, String>> client_data = new HashMap<String, HashMap<String, String>>();
		Map<String, HashMap<String, HashMap<String, String>>> total_admin_queue = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		client_data.putAll(client_info.get_client_data());
		total_admin_queue.putAll(task_info.get_received_admin_queues_treemap());	
		Set<String> queue_set = total_admin_queue.keySet();
		Iterator<String> queue_it = queue_set.iterator();
		while (queue_it.hasNext()) {
			String queue_name = queue_it.next();
			ArrayList<String> mismatch_item = new ArrayList<String>();
			HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
			queue_data.putAll(total_admin_queue.get(queue_name));
			// check mismatch list
			mismatch_item = admin_queue_mismatch_list_check(queue_data, client_data);
			if (mismatch_item.isEmpty()) {
				task_info.update_captured_admin_queues_treemap(queue_name, queue_data);
				task_info.remove_rejected_admin_queue_list(queue_name);
				task_info.remove_rejected_admin_queue_treemap(queue_name);
			} else {
				if (!task_info.get_rejected_admin_queue_list().contains(queue_name)){
					//console show
					TUBE_SERVER_LOGGER.warn("Rejected:" + queue_name + ", Reason:" + mismatch_item.toString());
					//reject list update
					task_info.add_rejected_admin_queue_list(queue_name);
					//reason record
					task_info.add_rejected_admin_queue_treemap(queue_name, String.join(",", mismatch_item));
				}
			}
		}
	}
	 */

	private Boolean send_client_info(String mode) {
		Boolean send_status = new Boolean(true);
		HashMap<String, HashMap<String, String>> client_hash = new HashMap<String, HashMap<String, String>>();
		client_hash = deep_clone.clone(client_info.get_client_data());
		//client_hash.putAll(client_info.get_client_data());
		HashMap<String, String> simple_data = new HashMap<String, String>();
		HashMap<String, String> complex_data = new HashMap<String, String>();
		String host_name = client_hash.get("Machine").get("terminal");
		String admin_request = "0";
		if (switch_info.impl_send_admin_request()) {
			admin_request = "1";
		}
		// admin_request = "1";
		String cpu_used = client_hash.get("System").get("cpu");
		int cpu_used_int = Integer.parseInt(cpu_used);
		String status = new String();
		if (cpu_used_int > 60) {
			status = "Busy";
		} else {
			status = "Free";
		}
		int used_thread = pool_info.get_pool_used_threads();
		int max_thread = pool_info.get_pool_max_threads();
		String processNum = String.valueOf(used_thread) + "/" + String.valueOf(max_thread);
		simple_data.put("host_name", host_name);
		simple_data.put("admin_request", admin_request);
		simple_data.put("status", status);
		simple_data.put("processNum", processNum);
		// complex data send
		String host_ip = client_hash.get("Machine").get("ip");
		String os = client_hash.get("System").get("os");
		String group_name = client_hash.get("Machine").get("group");
		String memory_left = client_hash.get("System").get("mem");
		String disk_left = client_hash.get("System").get("space");
		String os_type = client_hash.get("System").get("os_type");
		String high_priority = "NA";
		String max_threads = String.valueOf(max_thread);
		complex_data.putAll(simple_data);
		complex_data.put("host_ip", host_ip);
		complex_data.put("os", os);
		complex_data.put("group_name", group_name);
		complex_data.put("memory_left", memory_left);
		complex_data.put("disk_left", disk_left);
		complex_data.put("cpu_used", cpu_used);
		complex_data.put("os_type", os_type);
		complex_data.put("high_priority", high_priority);
		complex_data.put("max_threads", max_threads);
		Set<String> client_hash_set = client_hash.keySet();
		Iterator<String> client_hash_it = client_hash_set.iterator();		
		while (client_hash_it.hasNext()) {
			String key_name = client_hash_it.next();
			if (key_name.equals("Machine") || key_name.equals("System") || key_name.equals("base")) {
				continue;
			}
			Set<String> value_set = client_hash.get(key_name).keySet();
			if (value_set.contains("scan_dir")) {
				value_set.remove("scan_dir");
			}
			if (value_set.contains("max_insts")) {
				value_set.remove("max_insts");
			}
			String key_value = String.join(line_seprator, value_set);
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
		//send_msg = send_msg.replaceAll("\"", "\\\"");
		send_status = rmq_runner.basic_send(public_data.RMQ_CLIENT_NAME, send_msg);
		return send_status;
	}

	private void run_import_suite_file(){
		String suite_files = switch_info.impl_suite_file();
		if (suite_files.equals("")){
			return;
		}
		local_tube local_tube_parser = new local_tube(task_info);
		String[] file_list = suite_files.split(";");
		for (String file : file_list) {
			local_tube_parser.generate_local_admin_task_queues(file,
					client_info.get_client_data().get("Machine").get("terminal"));
		}	
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
		tube_thread = Thread.currentThread();
		// ============== All static job start from here ==============
		// initial 1 : start rmq tube (admin queque)   //should be remove later
		try {
			//rmq_runner.read_admin_server(public_data.RMQ_ADMIN_NAME, "D27639");
			rmq_runner.read_admin_server(public_data.RMQ_ADMIN_NAME, client_info.get_client_data().get("Machine").get("terminal"));
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			//e1.printStackTrace();
			TUBE_SERVER_LOGGER.error("Link to RabbitMQ server failed.");
			TUBE_SERVER_LOGGER.error("Client will run in local model.");
			//System.exit(1);
		}
		// initial 2 : send client detail info
		send_client_info("simple");
		send_client_info("simple");
		send_client_info("complex");
		// initial 3 : Announce tube server ready
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
			// task 1: update received tube(local file,  remote will update by rmq_tube)
			run_import_suite_file();
			// task 2: flash tube output: captured and rejected treemap
			flash_tube_output();
			// task 3: send client info to Remote server
			if (send_count < 6) {
				send_count++;
				send_client_info("simple");
			} else {
				send_count = 0;
				send_client_info("complex");
			}
			try {
				Thread.sleep(base_interval * 2 * 1000);
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
		switch_data switch_info = new switch_data();
		client_data client_info = new client_data();
		pool_data pool_info = new pool_data(10);
		task_data task_info = new task_data();
		data_server data_runner = new data_server(switch_info, client_info, pool_info);
		data_runner.start();
		while (true) {
			if (switch_info.get_data_server_power_up()) {
				break;
			}
		}
		tube_server tube_runner = new tube_server(switch_info, client_info, pool_info, task_info);
		tube_runner.start();
		while (true) {
			System.out.println(task_info.get_rejected_admin_reason_treemap());
			try {
				Thread.sleep(2000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
}