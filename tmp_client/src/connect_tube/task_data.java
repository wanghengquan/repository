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
import java.util.Set;
import java.util.TreeMap;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class task_data {
	// public property
	// {queue_name: {case_id_or_title: {}}}
	// protected property
	// private property
	private Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> processed_task_queues_data_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
	private static final Logger TASK_DATA_LOGGER = LogManager.getLogger(task_data.class.getName());
	private ReadWriteLock rw_lock = new ReentrantReadWriteLock();
	// public function
	// protected function
	// private function
	// =====updated by hall manager=====
	// rejected: do not match with current client
	private ArrayList<String> rejected_admin_queue_list = new ArrayList<String>();
	// captured: match with current client, including status in: stop pause
	private ArrayList<String> captured_admin_queue_list = new ArrayList<String>();
	// processing: all captured queue with status in processing(value form TMP platform)
	private ArrayList<String> processing_admin_queue_list = new ArrayList<String>();
	// ====updated by waiters====
	// running: working queue
	private ArrayList<String> running_admin_queue_list = new ArrayList<String>();
	// finished: finished queue by waiter
	private ArrayList<String> finished_admin_queue_list = new ArrayList<String>();

	public task_data() {

	}

	public TreeMap<String, HashMap<String, HashMap<String, String>>> get_processed_task_queue_data_map(String queue_name) {
		rw_lock.readLock().lock();
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			if (processed_task_queues_data_map.containsKey(queue_name)){
				queue_data = this.processed_task_queues_data_map.get(queue_name);
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return queue_data;
	}
	
	public Map<String, HashMap<String, HashMap<String, String>>> get_one_local_case_data(String queue_name) {
		rw_lock.readLock().lock();
		Map<String, HashMap<String, HashMap<String, String>>> case_data = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			TreeMap<String, HashMap<String, HashMap<String, String>>> local_task_data = local_tube.local_task_queue_tube_map.get(queue_name);
			TreeMap<String, HashMap<String, HashMap<String, String>>> processed_task_data = processed_task_queues_data_map.get(queue_name);
			Set<String> local_task_data_set = local_task_data.keySet();
			Iterator<String> local_task_data_it = local_task_data_set.iterator();
			while(local_task_data_it.hasNext()){
				String case_id = local_task_data_it.next();
				if (processed_task_data.containsKey(case_id)){
					continue;
				} else {
					case_data.put(case_id,local_task_data.get(case_id));
					break;
				}
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return case_data;
	}	

	public void update_case_to_processed_task_queues_data_map(String queue_name, String case_id, HashMap<String, HashMap<String, String>> case_data) {
		rw_lock.writeLock().lock();
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = processed_task_queues_data_map.get(queue_name);
		try {
			if (processed_task_queues_data_map.containsKey(queue_name)){
				queue_data = processed_task_queues_data_map.get(queue_name);
			} else {
				queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();	
			}
			queue_data.put(case_id, case_data);
			processed_task_queues_data_map.put(queue_name, queue_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public Boolean remove_case_from_processed_task_queues_data_map(String queue_name, String case_id) {
		Boolean remove_result = new Boolean(false);
		rw_lock.writeLock().lock();
		try {
			if (processed_task_queues_data_map.containsKey(queue_name)){
				if(processed_task_queues_data_map.get(queue_name).containsKey(case_id)){
					processed_task_queues_data_map.get(queue_name).remove(case_id);
					remove_result = true;
				}
			} 
		} finally {
			rw_lock.writeLock().unlock();
		}
		return remove_result;
	}
	
	public HashMap<String, HashMap<String, String>> get_case_from_processed_task_queues_data_map(String queue_name, String case_id) {
		HashMap<String, HashMap<String, String>> case_data = new HashMap<String, HashMap<String, String>>();
		rw_lock.writeLock().lock();
		try {
			if (processed_task_queues_data_map.containsKey(queue_name)){
				if(processed_task_queues_data_map.get(queue_name).containsKey(case_id)){
					case_data = processed_task_queues_data_map.get(queue_name).get(case_id);
				}
			} 
		} finally {
			rw_lock.writeLock().unlock();
		}
		return case_data;
	}
	
	public ArrayList<String> get_rejected_admin_queue_list() {
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try {
			temp = this.rejected_admin_queue_list;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_rejected_admin_queue_list(ArrayList<String> update_data) {
		rw_lock.writeLock().lock();
		try {
			this.rejected_admin_queue_list.clear();
			this.rejected_admin_queue_list.addAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public ArrayList<String> get_captured_admin_queue_list() {
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try {
			temp = this.captured_admin_queue_list;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_captured_admin_queue_list(ArrayList<String> update_data) {
		rw_lock.writeLock().lock();
		try {
			this.captured_admin_queue_list.clear();
			this.captured_admin_queue_list.addAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public ArrayList<String> get_processing_admin_queue_list() {
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try {
			temp = this.processing_admin_queue_list;
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
	
	public ArrayList<String> get_pending_admin_queue_list(){
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try {
			for(String admin_queue:processing_admin_queue_list){
				if(finished_admin_queue_list.contains(admin_queue)){
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
			temp = this.running_admin_queue_list;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void add_running_admin_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		try {
			if(!running_admin_queue_list.contains(queue_name)){
				running_admin_queue_list.add(queue_name);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
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
			temp = this.finished_admin_queue_list;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void update_finished_admin_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		try {
			if(!finished_admin_queue_list.contains(queue_name)){
				finished_admin_queue_list.add(queue_name);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
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

	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		TASK_DATA_LOGGER.warn("task data");
	}
}