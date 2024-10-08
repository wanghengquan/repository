/*
 * File: tube_data.java
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
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.public_data;
import flow_control.book_enum;
import flow_control.queue_enum;
import flow_control.task_enum;
import utility_funcs.deep_clone;

public class task_data {
	// public property
	// {queue_name: {case_id_or_title: {}}}
	// protected property
	// private property
	// private TreeMap<String, HashMap<String, HashMap<String, String>>>
	// remote_admin_queue_receive_treemap = new TreeMap<String, HashMap<String,
	// HashMap<String, String>>>(new queue_compare());
	// private TreeMap<String, HashMap<String, HashMap<String, String>>>
	// local_admin_queue_receive_treemap = new TreeMap<String, HashMap<String,
	// HashMap<String, String>>>(new queue_compare());
	private static final Logger TASK_DATA_LOGGER = LogManager.getLogger(task_data.class.getName());
	private ReadWriteLock rw_lock = new ReentrantReadWriteLock();	
	private TreeMap<String, HashMap<String, HashMap<String, String>>> received_admin_queues_treemap = new TreeMap<String, HashMap<String, HashMap<String, String>>>(
			new queue_compare());
	private TreeMap<String, HashMap<String, HashMap<String, String>>> processed_admin_queues_treemap = new TreeMap<String, HashMap<String, HashMap<String, String>>>(
			new queue_compare());
	private TreeMap<String, HashMap<String, HashMap<String, String>>> captured_admin_queues_treemap = new TreeMap<String, HashMap<String, HashMap<String, String>>>(
			new queue_compare());
	private Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> received_task_queues_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
	private Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> processed_task_queues_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
	private HashMap<String, HashMap<String, String>> received_stop_queues_map = new HashMap<String, HashMap<String, String>>();
	private Map<String, HashMap<String, String>> local_file_imported_task_map = new HashMap<String, HashMap<String, String>>();
	private Map<String, HashMap<String, String>> local_file_finished_task_map = new HashMap<String, HashMap<String, String>>();
	private Map<String, HashMap<String, String>> local_path_imported_task_map = new HashMap<String, HashMap<String, String>>();
	private Map<String, HashMap<String, String>> local_path_finished_task_map = new HashMap<String, HashMap<String, String>>();	
	// public function
	// protected function
	// private function
	// =====updated by tube server====== queue name and reason
	private TreeMap<String, String> rejected_admin_reason_treemap = new TreeMap<String, String>(new queue_compare());
	private ArrayList<String> processing_admin_queue_list = new ArrayList<String>();
	private ArrayList<String> paused_admin_queue_list = new ArrayList<String>();
	private ArrayList<String> stopped_admin_queue_list = new ArrayList<String>();	
	// =====updated by hall manager=====
	private ArrayList<String> warned_task_queue_list = new ArrayList<String>();
	private ArrayList<String> executing_admin_queue_list = new ArrayList<String>();
	private ArrayList<String> pending_admin_queue_list = new ArrayList<String>();
	// ====updated by waiters====
	// Queues updated by task waiter
	private ArrayList<String> waiting_admin_queue_list = new ArrayList<String>();
	private ArrayList<String> emptied_admin_queue_list = new ArrayList<String>();
	private HashMap<String, ArrayList<book_enum>> tasks_booking_issue_list = new HashMap<String, ArrayList<book_enum>>();
	// update by gui
	private ArrayList<String> watching_admin_queue_list = new ArrayList<String>();
	private ArrayList<String> local_priority_queue_list = new ArrayList<String>();
	// update by console
	private ArrayList<String> local_priority_runid_list = new ArrayList<String>();
	// ====updated by result waiter====
	//private ArrayList<String> thread_pool_admin_queue_list = new ArrayList<String>();
	private ArrayList<String> running_admin_queue_list = new ArrayList<String>();
	private ArrayList<String> finished_admin_queue_list = new ArrayList<String>();	
	private ArrayList<String> reported_admin_queue_list = new ArrayList<String>();
	private HashMap<String, HashMap<task_enum, Integer>> client_run_case_summary_status_map = new HashMap<String, HashMap<task_enum, Integer>>();
	private HashMap<String, HashMap<String, Object>> client_run_case_summary_memory_map = new HashMap<String, HashMap<String, Object>>();
	private HashMap<String, HashMap<String, Float>> client_run_case_summary_space_map = new HashMap<String, HashMap<String, Float>>();
	private HashMap<String,Integer> finished_queue_dump_delay_counter = new HashMap<String,Integer>();
	//====data not used====
	private ArrayList<String> thread_pool_admin_queue_list  = new ArrayList<String>();
	private HashMap<String, HashMap<queue_attr, String>> admin_queue_attribute_map = new HashMap<String, HashMap<queue_attr, String>>();
	// =============================================member
	// end=====================================

	public task_data() {

	}

	public HashMap<String, String> get_database_info() {
		HashMap<String, String> result = new HashMap<String, String>();
		rw_lock.readLock().lock();
		try {
			result.put("received_admin_queues_treemap", received_admin_queues_treemap.toString());
			result.put("processed_admin_queues_treemap", processed_admin_queues_treemap.toString());
			result.put("captured_admin_queues_treemap", captured_admin_queues_treemap.toString());
			result.put("received_task_queues_map", received_task_queues_map.toString());
			result.put("processed_task_queues_map", processed_task_queues_map.toString());
			result.put("received_stop_queues_map", received_stop_queues_map.toString());
			result.put("local_file_imported_task_map", local_file_imported_task_map.toString());
			result.put("local_file_finished_task_map", local_file_finished_task_map.toString());
			result.put("local_path_imported_task_map", local_path_imported_task_map.toString());
			result.put("local_path_finished_task_map", local_path_finished_task_map.toString());
			result.put("rejected_admin_reason_treemap", rejected_admin_reason_treemap.toString());
			result.put("processing_admin_queue_list", processing_admin_queue_list.toString());
			result.put("paused_admin_queue_list", paused_admin_queue_list.toString());
			result.put("stopped_admin_queue_list", stopped_admin_queue_list.toString());
			result.put("warned_task_queue_list", warned_task_queue_list.toString());
			result.put("executing_admin_queue_list", executing_admin_queue_list.toString());
			result.put("pending_admin_queue_list", pending_admin_queue_list.toString());
			result.put("waiting_admin_queue_list", waiting_admin_queue_list.toString());
			result.put("local_priority_queue_list", local_priority_queue_list.toString());
			result.put("local_priority_runid_list", local_priority_runid_list.toString());
			result.put("emptied_admin_queue_list", emptied_admin_queue_list.toString());
			result.put("tasks_booking_issue_list", tasks_booking_issue_list.toString());
			result.put("watching_admin_queue_list", watching_admin_queue_list.toString());
			result.put("running_admin_queue_list", running_admin_queue_list.toString());
			result.put("finished_admin_queue_list", finished_admin_queue_list.toString());
			result.put("reported_admin_queue_list", reported_admin_queue_list.toString());
			result.put("client_run_case_summary_status_map", client_run_case_summary_status_map.toString());
			result.put("client_run_case_summary_memory_map", client_run_case_summary_memory_map.toString());
			result.put("client_run_case_summary_space_map", client_run_case_summary_space_map.toString());
			result.put("finished_queue_dump_delay_counter", finished_queue_dump_delay_counter.toString());
			result.put("admin_queue_attribute_map", admin_queue_attribute_map.toString());
		} finally {
			rw_lock.readLock().unlock();
		}
		return result;
	}
	
	public HashMap<String, String> console_database_update(
			HashMap<String, String> update_data
			) {
		rw_lock.writeLock().lock();
		HashMap<String, String> update_status = new HashMap<String, String>();
		try {
			Iterator<String> update_it = update_data.keySet().iterator();
			while (update_it.hasNext()) {
				String obj_name = update_it.next();
				String optin_value = update_data.get(obj_name);
				switch(obj_name) {
				case "local_priority_queue_list":
				    if (!local_priority_queue_list.contains(optin_value)) {
				    	local_priority_queue_list.add(optin_value);
				    }
				    update_status.put(obj_name, "PASS");
				    break;
				case "local_priority_runid_list":
				    if (!local_priority_runid_list.contains(optin_value)) {
				    	local_priority_runid_list.add(optin_value);
				    }
				    update_status.put(obj_name, "PASS");
				    break;				    
				default:
					update_status.put(obj_name, "FAIL, " + obj_name + " console update not supported yet.");
				}
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}
	// =============================================function
	// start=================================
	public HashMap<queue_attr, String> get_admin_queue_attribute_map(
			String queue_name
			) {
		rw_lock.readLock().lock();
		HashMap<queue_attr, String> attribute_data = new HashMap<queue_attr, String>();
		try {
			if (admin_queue_attribute_map.containsKey(queue_name)) {
				attribute_data = deep_clone.clone(admin_queue_attribute_map.get(queue_name));
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return attribute_data;
	}
	
	public String get_admin_queue_attribute_value(
			String queue_name,
			queue_attr attribute
			) {
		rw_lock.readLock().lock();
		String attribute_value = new String("");
		try {
			if (admin_queue_attribute_map.containsKey(queue_name)) {
				if (admin_queue_attribute_map.get(queue_name).containsKey(attribute)) {
					attribute_value = admin_queue_attribute_map.get(queue_name).get(attribute);
				}
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return attribute_value;
	}
	
	public Boolean update_admin_queue_attribute_map(
			String queue_name,
			HashMap<queue_attr, String> attribute_data
			) {
		Boolean update_status = Boolean.valueOf(true);
		rw_lock.writeLock().lock();
		try {
			this.admin_queue_attribute_map.put(queue_name, attribute_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}	

	public Boolean update_admin_queue_attribute_value(
			String queue_name,
			queue_attr attribute_name,
			String attribute_value
			) {
		Boolean update_status = Boolean.valueOf(true);
		HashMap<queue_attr, String> attribute_data = new HashMap<queue_attr, String>();
		attribute_data.put(attribute_name, attribute_value);
		rw_lock.writeLock().lock();
		try {
			if (admin_queue_attribute_map.containsKey(queue_name)) {
				this.admin_queue_attribute_map.get(queue_name).putAll(attribute_data);
			} else {
				this.admin_queue_attribute_map.put(queue_name, attribute_data);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}
	
	public TreeMap<String, HashMap<String, HashMap<String, String>>> get_received_admin_queues_treemap() {
		rw_lock.readLock().lock();
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			queue_data.putAll(this.received_admin_queues_treemap);
		} finally {
			rw_lock.readLock().unlock();
		}
		return queue_data;
	}

	public HashMap<String, HashMap<String, String>> get_queue_data_from_received_admin_queues_treemap(
			String queue_name) {
		rw_lock.readLock().lock();
		HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
		try {
			if (received_admin_queues_treemap.containsKey(queue_name)) {
				queue_data = deep_clone.clone(received_admin_queues_treemap.get(queue_name));
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return queue_data;
	}

	public Boolean add_queue_data_to_received_admin_queues_treemap(String queue_name,
			HashMap<String, HashMap<String, String>> queue_data) {
		rw_lock.writeLock().lock();
		Boolean add_status = Boolean.valueOf(false);
		try {
			if (!received_admin_queues_treemap.containsKey(queue_name)) {
				received_admin_queues_treemap.put(queue_name, queue_data);
				add_status = true;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return add_status;
	}

	public Boolean update_queue_to_received_admin_queues_treemap(String queue_name,
			HashMap<String, HashMap<String, String>> queue_data) {
		Boolean update_status = Boolean.valueOf(true);
		rw_lock.writeLock().lock();
		try {
			this.received_admin_queues_treemap.put(queue_name, queue_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}
	
	public Boolean update_received_admin_queues_treemap(
			TreeMap<String, HashMap<String, HashMap<String, String>>> update_queues) {
		Boolean update_status = Boolean.valueOf(true);
		rw_lock.writeLock().lock();
		try {
			this.received_admin_queues_treemap.putAll(update_queues);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}

	public Boolean mark_queue_in_received_admin_queues_treemap(String queue_name, queue_enum action_request) {
		rw_lock.writeLock().lock();
		Boolean action_status = Boolean.valueOf(true);
		try {
			if (received_admin_queues_treemap.containsKey(queue_name)) {
				HashMap<String, HashMap<String, String>> queue_data = received_admin_queues_treemap.get(queue_name);
				HashMap<String, String> status_data = queue_data.get("Status");
				status_data.put("admin_status", action_request.get_description());
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return action_status;
	}

	public Boolean remove_queue_from_received_admin_queues_treemap(String queue_name) {
		Boolean remove_status = Boolean.valueOf(true);
		rw_lock.writeLock().lock();
		try {
			if (received_admin_queues_treemap.containsKey(queue_name)) {
				received_admin_queues_treemap.remove(queue_name);
			} else {
				remove_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return remove_status;
	}

	public Boolean active_waiting_received_admin_queues_treemap(String queue_name) {
		Boolean active_status = Boolean.valueOf(true);
		rw_lock.writeLock().lock();
		try {
			if (received_admin_queues_treemap.containsKey(queue_name)) {
				HashMap<String, String> status_data = received_admin_queues_treemap.get(queue_name).get("Status");
				status_data.put("admin_status", queue_enum.PROCESSING.get_description());
			} else {
				active_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return active_status;
	}

	public TreeMap<String, HashMap<String, HashMap<String, String>>> get_processed_admin_queues_treemap() {
		rw_lock.readLock().lock();
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			queue_data.putAll(this.processed_admin_queues_treemap);
		} finally {
			rw_lock.readLock().unlock();
		}
		return queue_data;
	}

	public HashMap<String, HashMap<String, String>> get_queue_data_from_processed_admin_queues_treemap(
			String queue_name) {
		rw_lock.readLock().lock();
		HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
		try {
			if (processed_admin_queues_treemap.containsKey(queue_name)) {
				queue_data.putAll(processed_admin_queues_treemap.get(queue_name));
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return queue_data;
	}
	
	public Boolean update_processed_admin_queues_treemap(
			TreeMap<String, HashMap<String, HashMap<String, String>>> update_queues) {
		Boolean update_status = Boolean.valueOf(true);
		rw_lock.writeLock().lock();
		try {
			this.processed_admin_queues_treemap.putAll(update_queues);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}	
	
	public Boolean update_queue_to_processed_admin_queues_treemap(String queue_name,
			HashMap<String, HashMap<String, String>> queue_data) {
		Boolean update_status = Boolean.valueOf(true);
		rw_lock.writeLock().lock();
		try {
			this.processed_admin_queues_treemap.put(queue_name, queue_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}

	public Boolean remove_queue_from_processed_admin_queues_treemap(String queue_name) {
		Boolean remove_status = Boolean.valueOf(true);
		rw_lock.writeLock().lock();
		try {
			if (processed_admin_queues_treemap.containsKey(queue_name)) {
				processed_admin_queues_treemap.remove(queue_name);
			} else {
				remove_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return remove_status;
	}

	public Boolean copy_admin_from_processed_to_received_admin_queues_treemap(String queue_name) {
		Boolean copy_status = Boolean.valueOf(true);
		rw_lock.writeLock().lock();
		HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
		try {
			if (processed_admin_queues_treemap.containsKey(queue_name)) {
				admin_data.putAll(deep_clone.clone(processed_admin_queues_treemap.get(queue_name)));
				HashMap<String, String> status_data = admin_data.get("Status");
				status_data.put("admin_status", queue_enum.WAITING.get_description());
				received_admin_queues_treemap.put(queue_name, admin_data);
				// processed_admin_queues_treemap.remove(queue_name);
			} else {
				copy_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return copy_status;
	}

	public TreeMap<String, HashMap<String, HashMap<String, String>>> get_captured_admin_queues_treemap() {
		rw_lock.readLock().lock();
		TreeMap<String, HashMap<String, HashMap<String, String>>> queues_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			queues_data.putAll(this.captured_admin_queues_treemap);
		} finally {
			rw_lock.readLock().unlock();
		}
		return queues_data;
	}

	public HashMap<String, HashMap<String, String>> get_data_from_captured_admin_queues_treemap(String queue_name) {
		rw_lock.readLock().lock();
		HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
		try {
			if (captured_admin_queues_treemap.containsKey(queue_name)) {
				queue_data.putAll(this.captured_admin_queues_treemap.get(queue_name));
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return queue_data;
	}

	public Boolean update_captured_admin_queues_treemap(String queue_name,
			HashMap<String, HashMap<String, String>> queue_data) {
		Boolean update_status = Boolean.valueOf(true);
		rw_lock.writeLock().lock();
		try {
			this.captured_admin_queues_treemap.put(queue_name, queue_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}

	public Boolean remove_queue_from_captured_admin_queues_treemap(String queue_name) {
		Boolean remove_status = Boolean.valueOf(true);
		rw_lock.writeLock().lock();
		try {
			if (captured_admin_queues_treemap.containsKey(queue_name)) {
				captured_admin_queues_treemap.remove(queue_name);
			} else {
				remove_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return remove_status;
	}

	public Boolean set_captured_admin_queues_treemap(
			TreeMap<String, HashMap<String, HashMap<String, String>>> queues_data) {
		Boolean set_status = Boolean.valueOf(true);
		rw_lock.writeLock().lock();
		try {
			captured_admin_queues_treemap.clear();
			captured_admin_queues_treemap.putAll(queues_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return set_status;
	}

	public Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> get_received_task_queues_map() {
		rw_lock.readLock().lock();
		Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> queue_data = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
		try {
			queue_data.putAll(this.received_task_queues_map);
		} finally {
			rw_lock.readLock().unlock();
		}
		return queue_data;
	}
	
	public TreeMap<String, HashMap<String, HashMap<String, String>>> get_queue_data_from_received_task_queues_map(String queue_name) {
		rw_lock.readLock().lock();
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			if (received_task_queues_map.containsKey(queue_name)) {
				queue_data.putAll(this.received_task_queues_map.get(queue_name));
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return queue_data;
	}	

	public HashMap<String, HashMap<String, String>> get_case_from_received_task_queues_map(
			String queue_name,
			String case_id) {
		HashMap<String, HashMap<String, String>> case_data = new HashMap<String, HashMap<String, String>>();
		rw_lock.readLock().lock();
		try {
			if (received_task_queues_map.containsKey(queue_name)) {
				if (received_task_queues_map.get(queue_name).containsKey(case_id)) {
					case_data.putAll(received_task_queues_map.get(queue_name).get(case_id));
				}
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return case_data;
	}
	
	public Boolean update_received_task_queues_map(
			Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> update_queues) {
		Boolean update_status = Boolean.valueOf(true);
		rw_lock.writeLock().lock();
		try {
			this.received_task_queues_map.putAll(update_queues);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}

	public Boolean update_queue_to_received_task_queues_map(String queue_name,
			TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data) {
		Boolean update_status = Boolean.valueOf(true);
		rw_lock.writeLock().lock();
		try {
			this.received_task_queues_map.put(queue_name, queue_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}

	public Boolean remove_queue_from_received_task_queues_map(String queue_name) {
		rw_lock.writeLock().lock();
		Boolean remove_status = Boolean.valueOf(true);
		try {
			if (received_task_queues_map.containsKey(queue_name)) {
				received_task_queues_map.remove(queue_name);
			} else {
				remove_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return remove_status;
	}

	public Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> get_processed_task_queues_map() {
		rw_lock.readLock().lock();
		Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> queues_data = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
		try {
			queues_data.putAll(processed_task_queues_map);
		} finally {
			rw_lock.readLock().unlock();
		}
		return queues_data;
	}

	public TreeMap<String, HashMap<String, HashMap<String, String>>> get_queue_data_from_processed_task_queues_map(
			String queue_name) {
		rw_lock.readLock().lock();
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			if (processed_task_queues_map.containsKey(queue_name)) {
				queue_data.putAll(this.processed_task_queues_map.get(queue_name));
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return queue_data;
	}

	public Map<String, HashMap<String, HashMap<String, String>>> get_one_indexed_case_data(
			String queue_name
			) {
		rw_lock.writeLock().lock();
		Map<String, HashMap<String, HashMap<String, String>>> return_id_case_data = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			TreeMap<String, HashMap<String, HashMap<String, String>>> received_task_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
			// TreeMap<String, HashMap<String, HashMap<String, String>>>
			// processed_task_data = new TreeMap<String, HashMap<String,
			// HashMap<String, String>>>();
			if(received_task_queues_map.containsKey(queue_name)){
				received_task_data.putAll(received_task_queues_map.get(queue_name));
			}
			// if(processed_task_queues_map.containsKey(queue_name)){
			// processed_task_data.putAll(processed_task_queues_map.get(queue_name));
			// }
			TreeSet<String> received_task_data_set = new TreeSet<String>(new taskid_compare());
			received_task_data_set.addAll(received_task_data.keySet());
			Iterator<String> received_task_data_it = received_task_data_set.iterator();
			while (received_task_data_it.hasNext()) {
				String case_id = received_task_data_it.next();
				HashMap<String, HashMap<String, String>> case_data = received_task_data.get(case_id);
				HashMap<String, String> status_data = case_data.get("Status");
				if (status_data.containsKey("cmd_status")) {
					if (status_data.get("cmd_status").equalsIgnoreCase("waiting")) {
						status_data.put("cmd_status", "Processing");
						return_id_case_data.put(case_id, case_data);
						// update received queue						
						received_task_queues_map.put(queue_name, received_task_data);
						break;
					}
				} else {
					status_data.put("cmd_status", "Processing");
					return_id_case_data.put(case_id, case_data);
					//update received queue
					received_task_queues_map.put(queue_name, received_task_data);
					break;
				}
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return return_id_case_data;
	}

	public void update_case_to_processed_task_queues_map(String queue_name, String case_id,
			HashMap<String, HashMap<String, String>> case_data) {
		rw_lock.writeLock().lock();
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			if (processed_task_queues_map.containsKey(queue_name)) {
				queue_data.putAll(processed_task_queues_map.get(queue_name));
			}
			queue_data.put(case_id, case_data);
			processed_task_queues_map.put(queue_name, queue_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public Boolean register_case_to_processed_task_queues_map(
			String queue_name, 
			String case_id,
			HashMap<String, HashMap<String, String>> case_data
			) {
		rw_lock.writeLock().lock();
		Boolean register_status = Boolean.valueOf(false);
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		HashMap<String, HashMap<String, String>> ori_case_data = new HashMap<String, HashMap<String, String>>();
		try {
			if (!processed_task_queues_map.containsKey(queue_name)) {
				queue_data.put(case_id, case_data);
				register_status = true;
			} else if (!processed_task_queues_map.get(queue_name).containsKey(case_id)) {
				queue_data.putAll(processed_task_queues_map.get(queue_name));
				queue_data.put(case_id, case_data);
				register_status = true;
			} else {
				ori_case_data.putAll(processed_task_queues_map.get(queue_name).get(case_id));
				if (ori_case_data.get("Status").get("cmd_status").equalsIgnoreCase(task_enum.WAITING.toString())) {
					queue_data.putAll(processed_task_queues_map.get(queue_name));
					queue_data.put(case_id, case_data);
					register_status = true;
				} else {
					TASK_DATA_LOGGER.info("Some one finished this case already.");
				}
			}
			if (register_status) {
				processed_task_queues_map.put(queue_name, queue_data);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return register_status;
	}

	public Boolean copy_task_list_from_processed_to_received_task_queues_map(
			String queue_name,
			ArrayList<String> case_list) {
		rw_lock.writeLock().lock();
		Boolean copy_status = Boolean.valueOf(true);
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			if (received_task_queues_map.containsKey(queue_name)) {
				queue_data.putAll(deep_clone.clone(received_task_queues_map.get(queue_name)));
			}
			for (String case_id : case_list) {
				HashMap<String, HashMap<String, String>> task_data = new HashMap<String, HashMap<String, String>>();
				task_data.putAll(deep_clone.clone(processed_task_queues_map.get(queue_name).get(case_id)));
				HashMap<String, String> status_data = new HashMap<String, String>();
				if(task_data.containsKey("Status")){
					status_data.putAll(task_data.get("Status"));
				}
				status_data.put("cmd_status", task_enum.WAITING.get_description());
				task_data.put("Status", status_data);
				queue_data.put(case_id, task_data);
				// processed_task_queues_map.get(queue_name).remove(case_id);
			}
			received_task_queues_map.put(queue_name, queue_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return copy_status;
	}

	public Boolean mark_task_list_for_processed_task_queues_map(
			String queue_name, ArrayList<String> case_list,
			task_enum action_request) {
		rw_lock.writeLock().lock();
		Boolean mark_status = Boolean.valueOf(true);
		try {
			for (String case_id : case_list) {
				HashMap<String, HashMap<String, String>> task_data = processed_task_queues_map.get(queue_name).get(case_id);
				HashMap<String, String> status_data = task_data.get("Status");
				status_data.put("cmd_status", action_request.get_description());
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return mark_status;
	}

	public Boolean copy_task_queue_from_processed_to_received_task_queues_map(String queue_name) {
		rw_lock.writeLock().lock();
		Boolean copy_status = Boolean.valueOf(true);
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			if (received_task_queues_map.containsKey(queue_name)) {
				queue_data = deep_clone.clone(received_task_queues_map.get(queue_name));
			}
			if (processed_task_queues_map.containsKey(queue_name)) {
				TreeMap<String, HashMap<String, HashMap<String, String>>> processed_queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
				processed_queue_data = deep_clone.clone(processed_task_queues_map.get(queue_name));
				Iterator<String> processed_queue_data_it = processed_queue_data.keySet().iterator();
				while (processed_queue_data_it.hasNext()) {
					HashMap<String, HashMap<String, String>> task_data = new HashMap<String, HashMap<String, String>>();
					String case_id = processed_queue_data_it.next();
					task_data.putAll(processed_queue_data.get(case_id));
					HashMap<String, String> status_data = task_data.get("Status");
					status_data.put("cmd_status", task_enum.WAITING.get_description());
					queue_data.put(case_id, task_data);
					// processed_task_queues_map.get(queue_name).remove(case_id);
				}
			} else {
				copy_status = false;
			}
			received_task_queues_map.put(queue_name, queue_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return copy_status;
	}

	public Boolean mark_task_queue_for_processed_task_queues_map(String queue_name, task_enum action_request) {
		rw_lock.writeLock().lock();
		Boolean mark_status = Boolean.valueOf(true);
		try {
			if (processed_task_queues_map.containsKey(queue_name)) {
				TreeMap<String, HashMap<String, HashMap<String, String>>> processed_queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
				processed_queue_data.putAll(processed_task_queues_map.get(queue_name));
				Iterator<String> processed_queue_data_it = processed_queue_data.keySet().iterator();
				while (processed_queue_data_it.hasNext()) {
					HashMap<String, HashMap<String, String>> task_data = new HashMap<String, HashMap<String, String>>();
					String case_id = processed_queue_data_it.next();
					task_data = processed_queue_data.get(case_id);
					HashMap<String, String> status_data = task_data.get("Status");
					status_data.put("cmd_status", action_request.get_description());
				}
			} else {
				mark_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return mark_status;
	}

	public Boolean update_task_queue_for_processed_task_queues_map(
			String queue_name, 
			task_enum ori_status,
			task_enum new_status) {
		rw_lock.writeLock().lock();
		Boolean mark_status = Boolean.valueOf(true);
		try {
			if (processed_task_queues_map.containsKey(queue_name)) {
				TreeMap<String, HashMap<String, HashMap<String, String>>> processed_queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
				processed_queue_data.putAll(processed_task_queues_map.get(queue_name));
				Iterator<String> processed_queue_data_it = processed_queue_data.keySet().iterator();
				while (processed_queue_data_it.hasNext()) {
					HashMap<String, HashMap<String, String>> task_data = new HashMap<String, HashMap<String, String>>();
					String case_id = processed_queue_data_it.next();
					task_data = processed_queue_data.get(case_id);
					HashMap<String, String> status_data = task_data.get("Status");
					if (!status_data.containsKey("cmd_status")){
						continue;
					}
					if (status_data.get("cmd_status").equalsIgnoreCase(ori_status.get_description())){
						status_data.put("cmd_status", new_status.get_description());
					}
				}
			} else {
				mark_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return mark_status;
	}	
	
	public void update_processed_task_queues_map(
			Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> update_queues) {
		rw_lock.writeLock().lock();
		try {
			processed_task_queues_map.putAll(update_queues);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_queue_to_processed_task_queues_map(String queue_name,
			TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data) {
		rw_lock.writeLock().lock();
		try {
			processed_task_queues_map.put(queue_name, queue_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public Boolean remove_case_from_processed_task_queues_map(String queue_name, String case_id) {
		Boolean remove_result = Boolean.valueOf(false);
		rw_lock.writeLock().lock();
		try {
			if (processed_task_queues_map.containsKey(queue_name)) {
				if (processed_task_queues_map.get(queue_name).containsKey(case_id)) {
					processed_task_queues_map.get(queue_name).remove(case_id);
					remove_result = true;
				}
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return remove_result;
	}

	public Boolean remove_queue_from_processed_task_queues_map(String queue_name) {
		Boolean remove_result = Boolean.valueOf(false);
		rw_lock.writeLock().lock();
		try {
			if (processed_task_queues_map.containsKey(queue_name)) {
				processed_task_queues_map.remove(queue_name);
				remove_result = true;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return remove_result;
	}

	public HashMap<String, HashMap<String, String>> get_case_from_processed_task_queues_map(
			String queue_name,
			String case_id) {
		HashMap<String, HashMap<String, String>> case_data = new HashMap<String, HashMap<String, String>>();
		rw_lock.readLock().lock();
		try {
			if (processed_task_queues_map.containsKey(queue_name)) {
				if (processed_task_queues_map.get(queue_name).containsKey(case_id)) {
					case_data.putAll(processed_task_queues_map.get(queue_name).get(case_id));
				}
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return case_data;
	}

	public TreeMap<String, String> get_rejected_admin_reason_treemap() {
		rw_lock.readLock().lock();
		TreeMap<String, String> temp = new TreeMap<String, String>();
		try {
			temp.putAll(this.rejected_admin_reason_treemap);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_rejected_admin_reason_treemap(TreeMap<String, String> update_data) {
		rw_lock.writeLock().lock();
		try {
			this.rejected_admin_reason_treemap.clear();
			this.rejected_admin_reason_treemap.putAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public void add_rejected_admin_reason_treemap(String queue_name, String reason) {
		rw_lock.writeLock().lock();
		try {
			this.rejected_admin_reason_treemap.put(queue_name, reason);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public Boolean remove_rejected_admin_reason_treemap(String queue_name) {
		Boolean remove_status = Boolean.valueOf(true);
		rw_lock.writeLock().lock();
		try {
			if (rejected_admin_reason_treemap.containsKey(queue_name)) {
				this.rejected_admin_reason_treemap.remove(queue_name);
			} else {
				remove_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return remove_status;
	}

	public void set_waiting_admin_queue_list(ArrayList<String> update_data) {
		rw_lock.writeLock().lock();
		try {
			this.waiting_admin_queue_list.clear();
			this.waiting_admin_queue_list.addAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public ArrayList<String> get_waiting_admin_queue_list() {
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try {
			temp.addAll(this.waiting_admin_queue_list);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void set_pending_admin_queue_list(ArrayList<String> update_data) {
		rw_lock.writeLock().lock();
		try {
			this.pending_admin_queue_list.clear();
			this.pending_admin_queue_list.addAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public ArrayList<String> get_pending_admin_queue_list() {
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try {
			temp.addAll(this.pending_admin_queue_list);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public ArrayList<String> get_executing_admin_queue_list() {
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try {
			temp.addAll(this.executing_admin_queue_list);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_executing_admin_queue_list(ArrayList<String> update_data) {
		rw_lock.writeLock().lock();
		try {
			this.executing_admin_queue_list.clear();
			this.executing_admin_queue_list.addAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public Boolean decrease_executing_admin_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		Boolean decrease_status = Boolean.valueOf(true);
		try {
			if (executing_admin_queue_list.contains(queue_name)) {
				executing_admin_queue_list.remove(queue_name);
			} else {
				decrease_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return decrease_status;
	}

	public ArrayList<String> get_processing_admin_queue_list() {
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try {
			temp.addAll(this.processing_admin_queue_list);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void set_processing_admin_queue_list(ArrayList<String> update_data) {
		rw_lock.writeLock().lock();
		try {
			this.processing_admin_queue_list.clear();
			this.processing_admin_queue_list.addAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public Boolean decrease_processing_admin_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		Boolean decrease_status = Boolean.valueOf(true);
		try {
			if (processing_admin_queue_list.contains(queue_name)) {
				processing_admin_queue_list.remove(queue_name);
			} else {
				decrease_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return decrease_status;
	}
	
	public void set_paused_admin_queue_list(ArrayList<String> update_data) {
		rw_lock.writeLock().lock();
		try {
			this.paused_admin_queue_list.clear();
			this.paused_admin_queue_list.addAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public ArrayList<String> get_paused_admin_queue_list() {
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try {
			temp.addAll(this.paused_admin_queue_list);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}	
	
	public void set_stopped_admin_queue_list(ArrayList<String> update_data) {
		rw_lock.writeLock().lock();
		try {
			this.stopped_admin_queue_list.clear();
			this.stopped_admin_queue_list.addAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public ArrayList<String> get_stopped_admin_queue_list() {
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try {
			temp.addAll(this.stopped_admin_queue_list);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public ArrayList<String> get_running_admin_queue_list() {
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try {
			temp.addAll(this.running_admin_queue_list);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void increase_running_admin_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		try {
			if (!running_admin_queue_list.contains(queue_name)) {
				running_admin_queue_list.add(queue_name);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public Boolean decrease_running_admin_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		Boolean decrease_status = Boolean.valueOf(true);
		try {
			if (running_admin_queue_list.contains(queue_name)) {
				running_admin_queue_list.remove(queue_name);
			} else {
				decrease_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return decrease_status;
	}

	public void set_running_admin_queue_list(ArrayList<String> update_data) {
		rw_lock.writeLock().lock();
		try {
			this.running_admin_queue_list.clear();
			this.running_admin_queue_list.addAll(update_data);		
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public ArrayList<String> get_emptied_admin_queue_list() {
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try {
			temp.addAll(this.emptied_admin_queue_list);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void increase_emptied_admin_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		try {
			if (!emptied_admin_queue_list.contains(queue_name)) {
				emptied_admin_queue_list.add(queue_name);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public Boolean decrease_emptied_admin_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		Boolean decrease_status = Boolean.valueOf(true);
		try {
			if (emptied_admin_queue_list.contains(queue_name)) {
				emptied_admin_queue_list.remove(queue_name);
			} else {
				decrease_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return decrease_status;
	}

	public Boolean remove_emptied_admin_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		Boolean remove_status = Boolean.valueOf(true);
		try {
			if (emptied_admin_queue_list.contains(queue_name)) {
				emptied_admin_queue_list.remove(queue_name);
			} else {
				remove_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return remove_status;
	}	
	
	public void set_emptied_admin_queue_list(ArrayList<String> update_data) {
		rw_lock.writeLock().lock();
		try {
			this.emptied_admin_queue_list.clear();
			this.emptied_admin_queue_list.addAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_tasks_booking_issue_list(
			String queue_name,
			ArrayList<book_enum> update_data
			) {
		rw_lock.writeLock().lock();
		try {
			if (update_data.isEmpty()) {
				if (this.tasks_booking_issue_list.containsKey(queue_name)) {
					this.tasks_booking_issue_list.remove(queue_name);
				}
			} else {
				this.tasks_booking_issue_list.put(queue_name, update_data);
			}		
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public HashMap<String, ArrayList<book_enum>> get_tasks_booking_issue_list() {
		rw_lock.readLock().lock();
		HashMap<String, ArrayList<book_enum>> temp = new HashMap<String, ArrayList<book_enum>>();
		try {
			temp.putAll(this.tasks_booking_issue_list);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public ArrayList<String> get_finished_admin_queue_list() {
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try {
			temp.addAll(finished_admin_queue_list);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public Boolean increase_finished_admin_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		Boolean increase_status = Boolean.valueOf(true);
		try {
			if (finished_admin_queue_list.contains(queue_name)) {
				increase_status = false;
			} else {
				finished_admin_queue_list.add(queue_name);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return increase_status;
	}
	
	public Boolean update_finished_admin_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		Boolean update_status = Boolean.valueOf(true);
		try {
			if (finished_admin_queue_list.contains(queue_name)) {
				update_status = false;
			} else {
				finished_admin_queue_list.add(queue_name);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}

	public void update_finished_admin_queue_list(ArrayList<String> queue_list) {
		rw_lock.writeLock().lock();
		try {
			for (String queue_name : queue_list) {
				if (!finished_admin_queue_list.contains(queue_name)) {
					finished_admin_queue_list.add(queue_name);
				}
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public Boolean remove_finished_admin_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		Boolean remove_status = Boolean.valueOf(true);
		try {
			if (finished_admin_queue_list.contains(queue_name)) {
				finished_admin_queue_list.remove(queue_name);
			} else {
				remove_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return remove_status;
	}

	public void set_finished_admin_queue_list(ArrayList<String> update_data) {
		rw_lock.writeLock().lock();
		try {
			this.finished_admin_queue_list.clear();
			this.finished_admin_queue_list.addAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public ArrayList<String> get_reported_admin_queue_list() {
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try {
			temp.addAll(reported_admin_queue_list);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public Boolean update_reported_admin_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		Boolean update_status = Boolean.valueOf(true);
		try {
			if (reported_admin_queue_list.contains(queue_name)) {
				update_status = false;
			} else {
				reported_admin_queue_list.add(queue_name);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}
	
	public ArrayList<String> get_watching_admin_queue_list() {
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try {
			temp.addAll(watching_admin_queue_list);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void increase_watching_admin_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		try {
			if (!watching_admin_queue_list.contains(queue_name)) {
				watching_admin_queue_list.add(queue_name);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public void decrease_watching_admin_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		try {
			if (watching_admin_queue_list.contains(queue_name)) {
				watching_admin_queue_list.remove(queue_name);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public ArrayList<String> get_local_priority_queue_list() {
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try {
			temp.addAll(local_priority_queue_list);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void increase_local_priority_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		try {
			if (!local_priority_queue_list.contains(queue_name)) {
				local_priority_queue_list.add(queue_name);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public void decrease_local_priority_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		try {
			if (local_priority_queue_list.contains(queue_name)) {
				local_priority_queue_list.remove(queue_name);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public ArrayList<String> get_local_priority_runid_list() {
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try {
			temp.addAll(local_priority_runid_list);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void increase_local_priority_runid_list(String run_id) {
		rw_lock.writeLock().lock();
		try {
			if (!local_priority_runid_list.contains(run_id)) {
				local_priority_runid_list.add(run_id);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public void decrease_local_priority_runid_list(String run_id) {
		rw_lock.writeLock().lock();
		try {
			if (local_priority_runid_list.contains(run_id)) {
				local_priority_runid_list.remove(run_id);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public ArrayList<String> get_thread_pool_admin_queue_list() {
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try {
			temp.addAll(thread_pool_admin_queue_list);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_thread_pool_admin_queue_list(ArrayList<String> queue_list) {
		rw_lock.writeLock().lock();
		try {
			thread_pool_admin_queue_list.clear();
			thread_pool_admin_queue_list.addAll(queue_list);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public HashMap<String, HashMap<String, Object>> get_client_run_case_summary_memory_map() {
		rw_lock.readLock().lock();
		HashMap<String, HashMap<String, Object>> temp = new HashMap<String, HashMap<String, Object>>();
		try {
			temp.putAll(client_run_case_summary_memory_map);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public HashMap<String, Object> get_client_run_case_summary_memory_map(
			String queue_name
			) {
		rw_lock.readLock().lock();
		HashMap<String, Object> temp = new HashMap<String, Object>();
		try {
			if (client_run_case_summary_memory_map.containsKey(queue_name)) {
				temp.putAll(client_run_case_summary_memory_map.get(queue_name));
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void reset_client_run_case_summary_memory_map() {
		rw_lock.writeLock().lock();
		try {
			client_run_case_summary_memory_map.clear();
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_client_run_case_summary_memory_map(
			String queue_name, 
			HashMap<String, Object> memory_map
			) {
		rw_lock.writeLock().lock();
		HashMap<String, Object> memory_data = new HashMap<String, Object>();
		try {
			if (client_run_case_summary_memory_map.containsKey(queue_name)){
				memory_data.putAll(client_run_case_summary_memory_map.get(queue_name));
			}
			memory_data.putAll(memory_map);
			client_run_case_summary_memory_map.put(queue_name, memory_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_client_run_case_summary_memory_map(
			String queue_name, 
			Float new_data
			) {
		rw_lock.writeLock().lock();
		HashMap<String, Object> memory_data = new HashMap<String, Object>();
		try {
			if (client_run_case_summary_memory_map.containsKey(queue_name)){
				memory_data.putAll(client_run_case_summary_memory_map.get(queue_name));
			}
			Float min = (Float) memory_data.getOrDefault("min", 99.0f);
			Float max = (Float) memory_data.getOrDefault("max", 0.0f);
			Float num = (Float) memory_data.getOrDefault("num", 0.0f);
			@SuppressWarnings("unchecked")
			ArrayList<Float> lst = (ArrayList<Float>) memory_data.getOrDefault("lst", new ArrayList<Float>());
			if (new_data.compareTo(min) < 0) {
				min = new_data;
			}
			if (new_data.compareTo(max) > 0) {
				max = new_data;
			}
			lst.add(new_data);
			if(lst.size()>20) {
				lst.remove(0);
			}
			num = num + 1;
			memory_data.put("min", min);
			memory_data.put("max", max);
			memory_data.put("num", num);
			memory_data.put("avg", get_float_list_recent_data_average(lst, lst.size()));
			memory_data.put("av5", get_float_list_recent_data_average(lst, 5));
			memory_data.put("av1", get_float_list_recent_data_average(lst, 1));
			memory_data.put("lst", lst);
			client_run_case_summary_memory_map.put(queue_name, memory_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	private float get_float_list_recent_data_average(
			ArrayList<Float> float_list,
			int cal_num
			) {
		ArrayList<Float> sub_list = new ArrayList<Float>();
		if(float_list.size() < cal_num) {
			sub_list.addAll(float_list);
		} else {
			sub_list.addAll(float_list.subList(float_list.size() - cal_num, float_list.size()));
		}
		float total = 0.0f;
		float avg = 1.0f;
		for(Float data: sub_list) {
			total += data;
		}
		if (sub_list.size() > 0) {
			avg = total / sub_list.size(); 
		}
		return avg;
	}
	
	public HashMap<String, HashMap<String, Float>> get_client_run_case_summary_space_map() {
		rw_lock.readLock().lock();
		HashMap<String, HashMap<String, Float>> temp = new HashMap<String, HashMap<String, Float>>();
		try {
			temp.putAll(client_run_case_summary_space_map);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public HashMap<String, Float> get_client_run_case_summary_space_map(String queue_name) {
		rw_lock.readLock().lock();
		HashMap<String, Float> temp = new HashMap<String, Float>();
		try {
			if (client_run_case_summary_space_map.containsKey(queue_name)) {
				temp.putAll(client_run_case_summary_space_map.get(queue_name));
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void reset_client_run_case_summary_space_map() {
		rw_lock.writeLock().lock();
		try {
			client_run_case_summary_space_map.clear();
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_client_run_case_summary_space_map(
			String queue_name, 
			HashMap<String, Float> space_map) {
		rw_lock.writeLock().lock();
		HashMap<String, Float> space_data = new HashMap<String, Float>();
		try {
			if (client_run_case_summary_space_map.containsKey(queue_name)){
				space_data.putAll(client_run_case_summary_space_map.get(queue_name));
			}
			space_data.putAll(space_map);
			client_run_case_summary_space_map.put(queue_name, space_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_client_run_case_summary_space_map(
			String queue_name, 
			Float new_data) {
		rw_lock.writeLock().lock();
		HashMap<String, Float> space_data = new HashMap<String, Float>();
		try {
			if (client_run_case_summary_space_map.containsKey(queue_name)){
				space_data.putAll(client_run_case_summary_space_map.get(queue_name));
			}
			Float min = space_data.getOrDefault("min", 99.0f);
			Float max = space_data.getOrDefault("max", public_data.TASK_DEF_ESTIMATE_SPACE);
			Float avg = space_data.getOrDefault("avg", public_data.TASK_DEF_ESTIMATE_SPACE);
			Float num = space_data.getOrDefault("num", 0.0f);
			if (new_data.compareTo(min) < 0) {
				min = new_data;
			}
			if (new_data.compareTo(max) > 0) {
				max = new_data;
			}
			avg = (avg * num + new_data) / (num + 1);
			num = num + 1;
			space_data.put("min", min);
			space_data.put("max", max);
			space_data.put("avg", avg);
			space_data.put("num", num);
			client_run_case_summary_space_map.put(queue_name, space_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public HashMap<String, HashMap<task_enum, Integer>> get_client_run_case_summary_status_map() {
		rw_lock.readLock().lock();
		HashMap<String, HashMap<task_enum, Integer>> temp = new HashMap<String, HashMap<task_enum, Integer>>();
		try {
			temp.putAll(client_run_case_summary_status_map);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void reset_client_run_case_summary_status_map() {
		rw_lock.writeLock().lock();
		try {
			client_run_case_summary_status_map.clear();
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void increase_client_run_case_summary_status_map(String queue_name, task_enum result_type, Integer increase_num) {
		rw_lock.writeLock().lock();
		HashMap<task_enum, Integer> queue_data = new HashMap<task_enum, Integer>();
		try {
			if (client_run_case_summary_status_map.containsKey(queue_name)){
				queue_data.putAll(client_run_case_summary_status_map.get(queue_name));
			}
			Integer new_pass_num = queue_data.getOrDefault(result_type, 0) + increase_num;
			queue_data.put(result_type, new_pass_num);
			client_run_case_summary_status_map.put(queue_name, queue_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public HashMap<String, Integer> get_finished_queue_dump_delay_counter() {
		rw_lock.readLock().lock();
		HashMap<String, Integer> temp = new HashMap<String, Integer>();
		try {
			temp.putAll(finished_queue_dump_delay_counter);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}	
	
	public Integer get_finished_queue_dump_delay_data(String queue_name) {
		rw_lock.readLock().lock();
		Integer temp = Integer.valueOf(0);
		try {
			if (finished_queue_dump_delay_counter.containsKey(queue_name)){
				temp = finished_queue_dump_delay_counter.get(queue_name);
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void increase_finished_queue_dump_delay_counter(
			String queue_name,
			Integer number) {
		rw_lock.writeLock().lock();
		try {
			if (finished_queue_dump_delay_counter.containsKey(queue_name)){
				int new_data = finished_queue_dump_delay_counter.get(queue_name) + number;
				finished_queue_dump_delay_counter.put(queue_name, new_data);
			} else {
				finished_queue_dump_delay_counter.put(queue_name, number);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void release_finished_queue_dump_delay_counter(
			String queue_name) {
		rw_lock.writeLock().lock();
		try {
			if (finished_queue_dump_delay_counter.containsKey(queue_name)){
				finished_queue_dump_delay_counter.remove(queue_name);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	//Map<String, HashMap<String, String>> local_file_imported_task_map
	public HashMap<String, HashMap<String, String>> get_local_file_imported_task_map() {
		rw_lock.readLock().lock();
		HashMap<String, HashMap<String, String>> temp = new HashMap<String, HashMap<String, String>>();
		try {
			temp.putAll(local_file_imported_task_map);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void reset_local_file_imported_task_map() {
		rw_lock.writeLock().lock();
		try {
			local_file_imported_task_map.clear();
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_local_file_imported_task_map(String task, HashMap<String, String> task_data) {
		rw_lock.writeLock().lock();
		try {
			local_file_imported_task_map.put(task, task_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	//Map<String, HashMap<String, String>> local_file_finished_task_map
	public HashMap<String, HashMap<String, String>> get_local_file_finished_task_map() {
		rw_lock.readLock().lock();
		HashMap<String, HashMap<String, String>> temp = new HashMap<String, HashMap<String, String>>();
		try {
			temp.putAll(local_file_finished_task_map);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void reset_local_file_finished_task_map() {
		rw_lock.writeLock().lock();
		try {
			local_file_finished_task_map.clear();
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_local_file_finished_task_map(String task, HashMap<String, String> task_data) {
		rw_lock.writeLock().lock();
		try {
			local_file_finished_task_map.put(task, task_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	//Map<String, HashMap<String, String>> local_path_imported_task_map
	public HashMap<String, HashMap<String, String>> get_local_path_imported_task_map() {
		rw_lock.readLock().lock();
		HashMap<String, HashMap<String, String>> temp = new HashMap<String, HashMap<String, String>>();
		try {
			temp.putAll(local_path_imported_task_map);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void reset_local_path_imported_task_map() {
		rw_lock.writeLock().lock();
		try {
			local_path_imported_task_map.clear();
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_local_path_imported_task_map(String task, HashMap<String, String> task_data) {
		rw_lock.writeLock().lock();
		try {
			local_path_imported_task_map.put(task, task_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	//Map<String, HashMap<String, String>> local_file_finished_task_map
	public HashMap<String, HashMap<String, String>> get_local_path_finished_task_map() {
		rw_lock.readLock().lock();
		HashMap<String, HashMap<String, String>> temp = new HashMap<String, HashMap<String, String>>();
		try {
			temp.putAll(local_path_finished_task_map);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void reset_local_path_finished_task_map() {
		rw_lock.writeLock().lock();
		try {
			local_path_finished_task_map.clear();
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_local_path_finished_task_map(String task, HashMap<String, String> task_data) {
		rw_lock.writeLock().lock();
		try {
			local_path_finished_task_map.put(task, task_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public ArrayList<String> get_warned_task_queue_list() {
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try {
			temp.addAll(warned_task_queue_list);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public Boolean update_warned_task_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		Boolean update_status = Boolean.valueOf(true);
		try {
			if (warned_task_queue_list.contains(queue_name)) {
				update_status = false;
			} else {
				warned_task_queue_list.add(queue_name);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}

	public void update_warned_task_queue_list(ArrayList<String> queue_list) {
		rw_lock.writeLock().lock();
		try {
			for (String queue_name : queue_list) {
				if (!warned_task_queue_list.contains(queue_name)) {
					warned_task_queue_list.add(queue_name);
				}
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public HashMap<String, HashMap<String, String>> get_received_stop_queues_map() {
		rw_lock.readLock().lock();
		HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
		try {
			queue_data.putAll(this.received_stop_queues_map);
		} finally {
			rw_lock.readLock().unlock();
		}
		return queue_data;
	}
	
	public void set_received_stop_queues_map(HashMap<String, HashMap<String, String>> queue_data) {
		rw_lock.writeLock().lock();
		try {
			this.received_stop_queues_map.clear();
			this.received_stop_queues_map.putAll(queue_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return;
	}
	
	public void update_received_stop_queues_map(HashMap<String, HashMap<String, String>> queue_data) {
		rw_lock.writeLock().lock();
		try {
			this.received_stop_queues_map.putAll(queue_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return;
	}
	
	public void update_received_stop_queues_map(String test_id, HashMap<String, String> info_data) {
		rw_lock.writeLock().lock();
		try {
			this.received_stop_queues_map.put(test_id, info_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return;
	}
	
	public Boolean remove_task_from_received_stop_queues_map(String test_id) {
		Boolean remove_status = Boolean.valueOf(true);
		rw_lock.writeLock().lock();
		try {
			if (received_stop_queues_map.containsKey(test_id)) {
				received_stop_queues_map.remove(test_id);
			} else {
				remove_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return remove_status;
	}
	
	public HashMap<String, HashMap<String, String>> fetch_tasks_from_received_stop_queues_map() {
		HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
		rw_lock.writeLock().lock();
		try {
			if (!received_stop_queues_map.isEmpty()){
				queue_data.putAll(deep_clone.clone(received_stop_queues_map));
				received_stop_queues_map.clear();
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return queue_data;
	}
	
	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		TASK_DATA_LOGGER.warn("task data");
	}
}
