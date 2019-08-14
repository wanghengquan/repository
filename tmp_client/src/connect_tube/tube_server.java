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
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
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
import data_center.status_enum;
import data_center.switch_data;
import flow_control.export_data;
import flow_control.pool_data;
import flow_control.queue_enum;
import info_parser.cmd_parser;
import info_parser.xml_parser;
import utility_funcs.deep_clone;

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
	private int send_count = 0;

	// public function
	public tube_server(switch_data switch_info, client_data client_info, pool_data pool_info, task_data task_info) {
		this.switch_info = switch_info;
		this.task_info = task_info;
		this.client_info = client_info;
		this.pool_info = pool_info;
		this.rmq_runner = new rmq_tube(task_info, client_info); // should be changed later
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
			String request_key = system_require_it.next();
			String request_value = system_require_data.get(request_key);
			if (!client_hash.get("System").containsKey(request_key)){
				system_match = false;
				break;
			}			
			if (request_key.equals("min_space")) {
				String client_available_space = client_hash.get("System").get("space");
				if (Integer.valueOf(request_value) > Integer.valueOf(client_available_space)) {
					system_match = false;
					break;
				}
			} else {
				// Get request value list
				ArrayList<String> request_value_list = new ArrayList<String>();		
				if (request_value.contains(",")){
					request_value_list.addAll(Arrays.asList(request_value.split("\\s*,\\s*")));
				} else if (request_value.contains(";")){
					request_value_list.addAll(Arrays.asList(request_value.split("\\s*;\\s*")));
				} else{
					request_value_list.add(request_value);
				}
				//get available value list
				String client_value = new String(client_hash.get("System").get(request_key));
				ArrayList<String> client_value_list = new ArrayList<String>();		
				if (client_value.contains(",")){
					client_value_list.addAll(Arrays.asList(client_value.split("\\s*,\\s*")));
				} else if (client_value.contains(";")){
					client_value_list.addAll(Arrays.asList(client_value.split("\\s*;\\s*")));
				} else{
					client_value_list.add(client_value);
				}				
				//compare data
				Boolean item_match = new Boolean(false);
				for (String individual: client_value_list){
					if (request_value_list.contains(individual)){
						item_match = true;
						break;
					}
				}
				if (!item_match){
					system_match = false;
					break;
				}
			}
		}
		return system_match;
	}

	private Boolean admin_queue_machine_key_check(
			String queue_name,
			HashMap<String, HashMap<String, String>> queue_data,
			Map<String, HashMap<String, String>> client_hash) {
		Boolean machine_match = new Boolean(true);
		String client_current_private = client_hash.get("Machine").get("private");
		//Scenario 1 local task (not remote)
		if (queue_name.contains("0@")){
			//this is a local task queue no private need to check
			return machine_match;
		}		
		//Scenario 2 without machine requirement data
		if (!queue_data.containsKey("Machine")) {
			if (client_current_private.equals("1")) {
				machine_match = false;
			} else {
				machine_match = true;
			}
			return machine_match;
		}
		//Scenario 3 with machine requirement data without 'terminal'
		HashMap<String, String> machine_require_data = queue_data.get("Machine");
		if (client_current_private.equals("1") && !machine_require_data.containsKey("terminal")) {
			machine_match = false;
			return machine_match;
		}
		//Scenario 4 with machine requirement data
		Iterator<String> machine_require_it = machine_require_data.keySet().iterator();
		while (machine_require_it.hasNext()) {
			String request_key = machine_require_it.next();
			String request_value = machine_require_data.get(request_key);
			ArrayList<String> request_value_list = new ArrayList<String>();		
			if (request_value.contains(",")){
				request_value_list.addAll(Arrays.asList(request_value.split("\\s*,\\s*")));
			} else if (request_value.contains(";")){
				request_value_list.addAll(Arrays.asList(request_value.split("\\s*;\\s*")));
			} else{
				request_value_list.add(request_value);
			}			
			if (!client_hash.get("Machine").containsKey(request_key)){
				machine_match = false;
				break;
			}
			String client_value = new String(client_hash.get("Machine").get(request_key));
			ArrayList<String> client_value_list = new ArrayList<String>();		
			if (client_value.contains(",")){
				client_value_list.addAll(Arrays.asList(client_value.split("\\s*,\\s*")));
			} else if (client_value.contains(";")){
				client_value_list.addAll(Arrays.asList(client_value.split("\\s*;\\s*")));
			} else{
				client_value_list.add(client_value);
			}
			Boolean item_match = new Boolean(false);

            for (String terminal_model: request_value_list){
                if(terminal_model.contains("!")){
                    item_match = true;
                    break;
                }
            }

			for (String individual: client_value_list){
				if (request_value_list.contains(individual)){
					item_match = true;
					break;
				}
                if (request_value_list.contains("!" + individual)){
                    item_match = false;
                    break;
                }
			}
			if (!item_match){
				machine_match = false;
				break;
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

	public ArrayList<String> admin_queue_mismatch_list_check(
			String queue_name,
			HashMap<String, HashMap<String, String>> queue_data,
			Map<String, HashMap<String, String>> client_hash) {
		ArrayList<String> mismatch_list = new ArrayList<String>();
		String ignore_request = new String("");
		if (client_hash.containsKey("preference")){
			ignore_request = client_hash.get("preference").getOrDefault("ignore_request", public_data.DEF_CLIENT_IGNORE_REQUEST);
		}
		if (ignore_request.contains("all")){
			return mismatch_list;
		}
		if (!ignore_request.contains("system")){
			if (!admin_queue_system_key_check(queue_data, client_hash)) {
				mismatch_list.add("System");
			}			
		}
		if (!ignore_request.contains("machine")){
			if (!admin_queue_machine_key_check(queue_name, queue_data, client_hash)) {
				mismatch_list.add("Machine");
			}		
		}
		if (!ignore_request.contains("software")){
			if (!admin_queue_software_key_check(queue_data, client_hash)) {
				mismatch_list.add("Software");
			}
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
		client_data.putAll(deep_clone.clone(client_info.get_client_data()));
		total_admin_queue.putAll(task_info.get_received_admin_queues_treemap());
		old_rejected_reason_queue.putAll(task_info.get_rejected_admin_reason_treemap());
		Iterator<String> queue_it = total_admin_queue.keySet().iterator();
		while (queue_it.hasNext()) {
			String queue_name = queue_it.next();
			HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
			queue_data.putAll(total_admin_queue.get(queue_name));
			// check mismatch list
			ArrayList<String> mismatch_item = new ArrayList<String>();
			mismatch_item = admin_queue_mismatch_list_check(queue_name, queue_data, client_data);
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

	private void send_client_current_info(){
		//send client detail data every 1 minutes
		if (send_count < 12) {
			send_count++;
			send_client_info("simple");
		} else {
			send_count = 0;
			send_client_info("complex");
		}		
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
		String system_status = client_hash.get("System").getOrDefault("status", status_enum.UNKNOWN.get_description());
		int used_thread = pool_info.get_pool_used_threads();
		int max_thread = pool_info.get_pool_current_size();
		String rpt_thread = String.valueOf(used_thread) + "/" + String.valueOf(max_thread);
		simple_data.put("host_name", host_name);
		simple_data.put("status", system_status);
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
		String cpu_used = client_hash.get("System").get("cpu");
		String memory_used = client_hash.get("System").get("mem");
		String disk_left = client_hash.get("System").get("space");
		String os_type = client_hash.get("System").get("os_type");
		String private_mode = client_hash.get("Machine").get("private");
		String unattended_mode = client_hash.get("Machine").get("unattended");
		String client_version = public_data.BASE_CURRENTVERSION;
		String core_version = new String("NA");
		if (client_hash.containsKey("CoreScript")){
			core_version = client_hash.get("CoreScript").getOrDefault("version", "NA");
		}
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
		complex_data.put("core_version", core_version);
		//complex_data.put("high_priority", high_priority);
		//complex_data.put("max_threads", max_threads);
		Iterator<String> client_hash_it = client_hash.keySet().iterator();
		while (client_hash_it.hasNext()) {
			String key_name = client_hash_it.next();
			if (key_name.equals("Machine") || key_name.equals("System") || key_name.equals("preference") || key_name.equals("CoreScript")) {
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
		export_data.debug_disk_client_out_status(send_msg, client_info);
		return send_status;
	}

	private void run_import_local_path_admin() {
		Map<String, HashMap<String, String>> imported_map = new HashMap<String, HashMap<String, String>>();
		imported_map.putAll(deep_clone.clone(task_info.get_local_path_imported_task_map()));
		Map<String, HashMap<String, String>> finished_map = new HashMap<String, HashMap<String, String>>();
		finished_map.putAll(deep_clone.clone(task_info.get_local_path_finished_task_map()));		
		if (imported_map.isEmpty()) {
			return;
		}
		local_tube local_path_tube_parser = new local_tube(task_info);
		Iterator<String> imported_it = imported_map.keySet().iterator();
		int counter = 0;
		while(imported_it.hasNext()){
			if (counter > 5){
				break;
			}
			String imported_id = imported_it.next();
			if (finished_map.containsKey(imported_id)){
				continue;
			} else {
				task_info.update_local_path_finished_task_map(imported_id, imported_map.get(imported_id));
			}
			HashMap<String, String> imported_data = imported_map.get(imported_id);
			local_path_tube_parser.generate_suite_path_local_admin_task_queues(imported_data);
			counter++;
		}
	}	
	
	private void run_import_local_file_admin() {
		Map<String, HashMap<String, String>> imported_map = new HashMap<String, HashMap<String, String>>();
		imported_map.putAll(deep_clone.clone(task_info.get_local_file_imported_task_map()));
		Map<String, HashMap<String, String>> finished_map = new HashMap<String, HashMap<String, String>>();
		finished_map.putAll(deep_clone.clone(task_info.get_local_file_finished_task_map()));		
		if (imported_map.isEmpty()) {
			return;
		}
		local_tube local_file_tube_parser = new local_tube(task_info);
		String terminal = new String(client_info.get_client_machine_data().get("terminal"));
		Iterator<String> imported_it = imported_map.keySet().iterator();
		int counter = 0;
		while(imported_it.hasNext()){
			if (counter > 5){
				break;
			}
			String imported_id = imported_it.next();
			if (finished_map.containsKey(imported_id)){
				continue;
			} else {
				task_info.update_local_file_finished_task_map(imported_id, imported_map.get(imported_id));
			}
			String imported_file = imported_map.get(imported_id).get("path");
			String imported_env = imported_map.get(imported_id).get("env");
			local_file_tube_parser.generate_suite_file_local_admin_task_queues(imported_file, imported_env, terminal);
			counter++;
		}
	}
	
	private void run_received_admin_sorting(){
		String link_mode = client_info.get_client_preference_data().get("link_mode");
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
	
	private void update_captured_queue_detail_lists() {
		Set<String> captured_admin_queue_set = new HashSet<String>();
		captured_admin_queue_set.addAll(task_info.get_captured_admin_queues_treemap().keySet());
		Iterator<String> captured_it = captured_admin_queue_set.iterator();
		ArrayList<String> processing_admin_queue_list = new ArrayList<String>();
		ArrayList<String> paused_admin_queue_list = new ArrayList<String>();
		ArrayList<String> stopped_admin_queue_list = new ArrayList<String>();
		while (captured_it.hasNext()) {
			String queue_name = captured_it.next();
			HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
			queue_data = deep_clone.clone(task_info.get_data_from_captured_admin_queues_treemap(queue_name));
			if (queue_data == null || queue_data.isEmpty()) {
				continue; // some one delete this queue already
			}
			String status = queue_data.get("Status").get("admin_status");
			if (status.equals(queue_enum.PROCESSING.get_description())) {
				processing_admin_queue_list.add(queue_name);
			} else if (status.equals(queue_enum.REMOTEPROCESSIONG.get_description())){
				processing_admin_queue_list.add(queue_name);
			} else if (status.equals(queue_enum.PAUSED.get_description())){
				paused_admin_queue_list.add(queue_name);
			} else if (status.equals(queue_enum.REMOTEPAUSED.get_description())){
				paused_admin_queue_list.add(queue_name);
			} else if (status.equals(queue_enum.STOPPED.get_description())){
				stopped_admin_queue_list.add(queue_name);
			} else if (status.equals(queue_enum.REMOTESTOPED.get_description())){
				stopped_admin_queue_list.add(queue_name);
			} else {
				continue;
			}
		}
		task_info.set_processing_admin_queue_list(processing_admin_queue_list);
		task_info.set_paused_admin_queue_list(paused_admin_queue_list);
		task_info.set_stopped_admin_queue_list(stopped_admin_queue_list);
	}	
	
	private void run_remote_tubes_control(){
		String link_mode = client_info.get_client_preference_data().get("link_mode");
		if (link_mode.equalsIgnoreCase("local")){
			try {
				rmq_runner.stop_admin_tube();
				rmq_runner.stop_stop_tube();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				TUBE_SERVER_LOGGER.error("Stop Link to RabbitMQ server failed.");
			}
		} else {
			try {
				rmq_runner.start_admin_tube(client_info.get_client_machine_data().get("terminal"));
				rmq_runner.start_stop_tube();
			} catch (Exception e1) {
				TUBE_SERVER_LOGGER.error("Link to RabbitMQ server failed.");
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
		tube_thread = Thread.currentThread();
		// ============== All static job start from here ==============
		// initial 1 : send client detail info
		send_client_info("complex");
		// initial 2 : Announce tube server ready
		switch_info.set_tube_server_power_up();
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
			// task 1: open/close remote tubes
			run_remote_tubes_control();
			// task 2: update local suite file admin (local file, import)
			run_import_local_file_admin();
			// task 3: update local suite path admin (local file, import)
			run_import_local_path_admin();
			// task 4: flash tube input:
			run_received_admin_sorting();
			// task 5: flash tube output: captured and rejected treemap
			flash_tube_output();
			// task 6: detail output list
			update_captured_queue_detail_lists();
			// task 7: send client info to Remote server
			send_client_current_info();
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
		data_server data_runner = new data_server(cmd_info, switch_info, task_info, client_info, pool_info);
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