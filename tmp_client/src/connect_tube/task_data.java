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

import flow_control.result_enum;
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
	private TreeMap<String, HashMap<String, HashMap<String, String>>> received_admin_queues_treemap = new TreeMap<String, HashMap<String, HashMap<String, String>>>(
			new queue_compare());
	private TreeMap<String, HashMap<String, HashMap<String, String>>> processed_admin_queues_treemap = new TreeMap<String, HashMap<String, HashMap<String, String>>>(
			new queue_compare());
	private TreeMap<String, HashMap<String, HashMap<String, String>>> captured_admin_queues_treemap = new TreeMap<String, HashMap<String, HashMap<String, String>>>(
			new queue_compare());
	private Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> received_task_queues_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
	private Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> processed_task_queues_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
	private static final Logger TASK_DATA_LOGGER = LogManager.getLogger(task_data.class.getName());
	private ReadWriteLock rw_lock = new ReentrantReadWriteLock();
	// public function
	// protected function
	// private function
	// =====updated by tube server====== queue name and reason
	private TreeMap<String, String> rejected_admin_reason_treemap = new TreeMap<String, String>(new queue_compare());
	// private ArrayList<String> rejected_admin_queue_list = new
	// ArrayList<String>();
	// =====updated by hall manager=====
	// captured: match with current client, including status in: stop pause
	// private ArrayList<String> captured_admin_queue_list = new
	// ArrayList<String>();//also update by result waiter remove finished one
	// processing: all captured queue with status in processing(value form TMP
	// platform)
	private ArrayList<String> processing_admin_queue_list = new ArrayList<String>();
	// ====updated by waiters====
	// running: working queue updated by task waiter
	private ArrayList<String> running_admin_queue_list = new ArrayList<String>();
	// finished: finished queue updated by task waiter
	private ArrayList<String> finished_admin_queue_list = new ArrayList<String>();
	// update by gui
	private ArrayList<String> watching_admin_queue_list = new ArrayList<String>();
	// ====updated by result waiter====
	private ArrayList<String> thread_pool_admin_queue_list = new ArrayList<String>();
	private ArrayList<String> reported_admin_queue_list = new ArrayList<String>();
	private HashMap<String, HashMap<result_enum, Integer>> client_run_case_summary_data_map = new HashMap<String, HashMap<result_enum, Integer>>();
	// =============================================member
	// end=====================================

	public task_data() {

	}

	// =============================================function
	// start=================================
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
		Boolean add_status = new Boolean(false);
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
		Boolean update_status = new Boolean(true);
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
		Boolean update_status = new Boolean(true);
		rw_lock.writeLock().lock();
		try {
			this.received_admin_queues_treemap.putAll(update_queues);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}

	public Boolean mark_queue_in_received_admin_queues_treemap(String queue_name, String action_request) {
		rw_lock.writeLock().lock();
		Boolean action_status = new Boolean(true);
		try {
			if (received_admin_queues_treemap.containsKey(queue_name)) {
				HashMap<String, HashMap<String, String>> queue_data = received_admin_queues_treemap.get(queue_name);
				HashMap<String, String> status_data = queue_data.get("Status");
				status_data.put("admin_status", action_request);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return action_status;
	}

	public Boolean remove_queue_from_received_admin_queues_treemap(String queue_name) {
		Boolean remove_status = new Boolean(true);
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
		Boolean active_status = new Boolean(true);
		rw_lock.writeLock().lock();
		try {
			if (received_admin_queues_treemap.containsKey(queue_name)) {
				HashMap<String, String> status_data = received_admin_queues_treemap.get(queue_name).get("Status");
				status_data.put("admin_status", "processing");
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
		Boolean update_status = new Boolean(true);
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
		Boolean update_status = new Boolean(true);
		rw_lock.writeLock().lock();
		try {
			this.processed_admin_queues_treemap.put(queue_name, queue_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}

	public Boolean remove_queue_from_processed_admin_queues_treemap(String queue_name) {
		Boolean remove_status = new Boolean(true);
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
		Boolean copy_status = new Boolean(true);
		rw_lock.writeLock().lock();
		HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
		try {
			if (processed_admin_queues_treemap.containsKey(queue_name)) {
				admin_data.putAll(deep_clone.clone(processed_admin_queues_treemap.get(queue_name)));
				HashMap<String, String> status_data = admin_data.get("Status");
				status_data.put("admin_status", "waiting");
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
		Boolean update_status = new Boolean(true);
		rw_lock.writeLock().lock();
		try {
			this.captured_admin_queues_treemap.put(queue_name, queue_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}

	public Boolean remove_queue_from_captured_admin_queues_treemap(String queue_name) {
		Boolean remove_status = new Boolean(true);
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
		Boolean set_status = new Boolean(true);
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
		Boolean update_status = new Boolean(true);
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
		Boolean update_status = new Boolean(true);
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
		Boolean remove_status = new Boolean(true);
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

	public Map<String, HashMap<String, HashMap<String, String>>> get_one_indexed_case_data(String queue_name) {
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
					received_task_queues_map.put(queue_name, received_task_data);// update
																					// received
																					// queue
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
			HashMap<String, HashMap<String, String>> case_data) {
		rw_lock.writeLock().lock();
		Boolean register_status = new Boolean(false);
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
				if (ori_case_data.get("Status").get("cmd_status").equalsIgnoreCase("waiting")) {
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

	public Boolean copy_task_list_from_processed_to_received_task_queues_map(String queue_name,
			ArrayList<String> case_list) {
		rw_lock.writeLock().lock();
		Boolean copy_status = new Boolean(true);
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			if (received_task_queues_map.containsKey(queue_name)) {
				queue_data = deep_clone.clone(received_task_queues_map.get(queue_name));
			}
			for (String case_id : case_list) {
				HashMap<String, HashMap<String, String>> task_data = new HashMap<String, HashMap<String, String>>();
				task_data = deep_clone.clone(processed_task_queues_map.get(queue_name).get(case_id));
				HashMap<String, String> status_data = task_data.get("Status");
				status_data.put("cmd_status", "waiting");
				queue_data.put(case_id, task_data);
				// processed_task_queues_map.get(queue_name).remove(case_id);
			}
			received_task_queues_map.put(queue_name, queue_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return copy_status;
	}

	public Boolean mark_task_list_for_processed_task_queues_map(String queue_name, ArrayList<String> case_list,
			String action_request) {
		rw_lock.writeLock().lock();
		Boolean mark_status = new Boolean(true);
		try {
			for (String case_id : case_list) {
				HashMap<String, HashMap<String, String>> task_data = new HashMap<String, HashMap<String, String>>();
				task_data = processed_task_queues_map.get(queue_name).get(case_id);
				HashMap<String, String> status_data = task_data.get("Status");
				status_data.put("cmd_status", action_request);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return mark_status;
	}

	public Boolean copy_task_queue_from_processed_to_received_task_queues_map(String queue_name) {
		rw_lock.writeLock().lock();
		Boolean copy_status = new Boolean(true);
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
					status_data.put("cmd_status", "waiting");
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

	public Boolean mark_task_queue_for_processed_task_queues_map(String queue_name, String action_request) {
		rw_lock.writeLock().lock();
		Boolean mark_status = new Boolean(true);
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
					status_data.put("cmd_status", action_request);
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
		Boolean remove_result = new Boolean(false);
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
		Boolean remove_result = new Boolean(false);
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
		TreeMap<String, String> temp = new TreeMap<String, String>(new queue_compare());
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
		Boolean remove_status = new Boolean(true);
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

	// not used
	public ArrayList<String> get_pending_admin_queue_list() {
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try {
			for (String admin_queue : processing_admin_queue_list) {
				if (finished_admin_queue_list.contains(admin_queue)) {
					continue;
				}
				temp.add(admin_queue);
			}
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
		Boolean decrease_status = new Boolean(true);
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

	public Boolean update_finished_admin_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		Boolean update_status = new Boolean(true);
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
		Boolean remove_status = new Boolean(true);
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
		Boolean update_status = new Boolean(true);
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
	
	public HashMap<String, HashMap<result_enum, Integer>> get_client_run_case_summary_data_map() {
		rw_lock.readLock().lock();
		HashMap<String, HashMap<result_enum, Integer>> temp = new HashMap<String, HashMap<result_enum, Integer>>();
		try {
			temp.putAll(client_run_case_summary_data_map);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void reset_client_run_case_summary_data_map() {
		rw_lock.writeLock().lock();
		try {
			client_run_case_summary_data_map.clear();
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void increase_client_run_case_summary_data_map(String queue_name, result_enum result_type, Integer pass_num) {
		rw_lock.writeLock().lock();
		HashMap<result_enum, Integer> queue_data = new HashMap<result_enum, Integer>();
		try {
			if (client_run_case_summary_data_map.containsKey(queue_name)){
				queue_data.putAll(client_run_case_summary_data_map.get(queue_name));
			}
			Integer new_pass_num = queue_data.getOrDefault(result_type, 0) + pass_num;
			queue_data.put(result_type, new_pass_num);
			client_run_case_summary_data_map.put(queue_name, queue_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		TASK_DATA_LOGGER.warn("task data");
	}
}
