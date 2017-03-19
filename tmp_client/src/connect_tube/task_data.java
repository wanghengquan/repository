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
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class task_data {
	// public property
	// {queue_name: {case_id_or_title: {}}}
	// protected property
	// private property
	//private TreeMap<String, HashMap<String, HashMap<String, String>>> remote_admin_queue_receive_treemap = new TreeMap<String, HashMap<String, HashMap<String, String>>>(new queue_comparator());
	//private TreeMap<String, HashMap<String, HashMap<String, String>>> local_admin_queue_receive_treemap = new TreeMap<String, HashMap<String, HashMap<String, String>>>(new queue_comparator());
	private TreeMap<String, HashMap<String, HashMap<String, String>>> received_admin_queues_treemap = new TreeMap<String, HashMap<String, HashMap<String, String>>>(new queue_comparator());
	private TreeMap<String, HashMap<String, HashMap<String, String>>> processed_admin_queues_treemap = new TreeMap<String, HashMap<String, HashMap<String, String>>>(new queue_comparator());
	private TreeMap<String, HashMap<String, HashMap<String, String>>> captured_admin_queues_treemap = new TreeMap<String, HashMap<String, HashMap<String, String>>>(new queue_comparator());
	private Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> received_task_queues_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
	private Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> processed_task_queues_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
	private static final Logger TASK_DATA_LOGGER = LogManager.getLogger(task_data.class.getName());
	private ReadWriteLock rw_lock = new ReentrantReadWriteLock();
	// public function
	// protected function
	// private function
	// =====updated by tube server====== queue name and reason
	private TreeMap<String, String> rejected_admin_reason_treemap = new TreeMap<String, String>(new queue_comparator());
	//private ArrayList<String> rejected_admin_queue_list = new ArrayList<String>();
	// =====updated by hall manager=====
	// captured: match with current client, including status in: stop pause
	//private ArrayList<String> captured_admin_queue_list = new ArrayList<String>();//also update by result waiter remove finished one
	// processing: all captured queue with status in processing(value form TMP platform)
	private ArrayList<String> processing_admin_queue_list = new ArrayList<String>();
	// ====updated by waiters====
	// running: working queue updated by task waiter
	private ArrayList<String> running_admin_queue_list = new ArrayList<String>();
	// finished: finished queue updated by task waiter
	private ArrayList<String> finished_admin_queue_list = new ArrayList<String>();
	// update by gui
	private ArrayList<String> watching_admin_queue_list = new ArrayList<String>();
	//=============================================member end=====================================
	
	public task_data() {

	}
	
	//=============================================function start=================================
	/*
	public TreeMap<String, HashMap<String, HashMap<String, String>>> get_remote_admin_queue_receive_treemap() {
		rw_lock.readLock().lock();
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			queue_data.putAll(this.remote_admin_queue_receive_treemap);
		} finally {
			rw_lock.readLock().unlock();
		}
		return queue_data;
	}	
	
	public Boolean update_remote_admin_queue_receive_treemap(TreeMap<String, HashMap<String, HashMap<String, String>>> update_queue) {
		Boolean update_status = new Boolean(true);
		rw_lock.writeLock().lock();
		try {
			this.remote_admin_queue_receive_treemap.putAll(update_queue);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}	
	
	public Boolean remove_queue_from_remote_admin_queue_receive_treemap(String queue_name) {
		Boolean remove_status = new Boolean(true);
		rw_lock.writeLock().lock();
		try {
			if (remote_admin_queue_receive_treemap.containsKey(queue_name)){
				remote_admin_queue_receive_treemap.remove(queue_name);
			} else {
				remove_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return remove_status;
	}
	
	public TreeMap<String, HashMap<String, HashMap<String, String>>> get_local_admin_queue_receive_treemap() {
		rw_lock.readLock().lock();
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			queue_data.putAll(this.local_admin_queue_receive_treemap);
		} finally {
			rw_lock.readLock().unlock();
		}
		return queue_data;
	}	
	
	public Boolean update_local_admin_queue_receive_treemap(TreeMap<String, HashMap<String, HashMap<String, String>>> update_queue) {
		Boolean update_status = new Boolean(true);
		rw_lock.writeLock().lock();
		try {
			this.local_admin_queue_receive_treemap.putAll(update_queue);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}	
	
	public Boolean remove_queue_from_local_admin_queue_receive_treemap(String queue_name) {
		Boolean remove_status = new Boolean(true);
		rw_lock.writeLock().lock();
		try {
			if (local_admin_queue_receive_treemap.containsKey(queue_name)){
				local_admin_queue_receive_treemap.remove(queue_name);
			} else {
				remove_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return remove_status;
	}	
	*/
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
	
	public HashMap<String, HashMap<String, String>> get_queue_data_from_received_admin_queues_treemap(String queue_name) {
		rw_lock.readLock().lock();
		HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
		try {
			if(received_admin_queues_treemap.containsKey(queue_name)){
			queue_data.putAll(received_admin_queues_treemap.get(queue_name));
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return queue_data;
	}	
	
	public Boolean update_received_admin_queues_treemap(TreeMap<String, HashMap<String, HashMap<String, String>>> update_queue) {
		Boolean update_status = new Boolean(true);
		rw_lock.writeLock().lock();
		try {
			this.received_admin_queues_treemap.putAll(update_queue);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}	
	
	public Boolean remove_queue_from_received_admin_queues_treemap(String queue_name) {
		Boolean remove_status = new Boolean(true);
		rw_lock.writeLock().lock();
		try {
			if (received_admin_queues_treemap.containsKey(queue_name)){
				received_admin_queues_treemap.remove(queue_name);
			} else {
				remove_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return remove_status;
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
	
	public Boolean update_queue_to_processed_admin_queues_treemap(String queue_name, HashMap<String, HashMap<String, String>> queue_data) {
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
			if (processed_admin_queues_treemap.containsKey(queue_name)){
				processed_admin_queues_treemap.remove(queue_name);
			} else {
				remove_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return remove_status;
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
			if (captured_admin_queues_treemap.containsKey(queue_name)){
				queue_data.putAll(this.captured_admin_queues_treemap.get(queue_name));
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return queue_data;
	}
	
	public Boolean update_captured_admin_queues_treemap(String queue_name, HashMap<String, HashMap<String, String>> queue_data) {
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
			if (captured_admin_queues_treemap.containsKey(queue_name)){
				captured_admin_queues_treemap.remove(queue_name);
			} else {
				remove_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return remove_status;
	}
	
	public Boolean set_captured_admin_queues_treemap(TreeMap<String, HashMap<String, HashMap<String, String>>> queues_data) {
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
	
	public Boolean update_received_task_queues_map(Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> update_queue) {
		Boolean update_status = new Boolean(true);
		rw_lock.writeLock().lock();
		try {
			this.received_task_queues_map.putAll(update_queue);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}
	
	public Boolean update_received_task_queues_map(String queue_name, TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data) {
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
		Boolean remove_status = new Boolean(true);
		rw_lock.writeLock().lock();
		try {
			if (received_task_queues_map.containsKey(queue_name)){
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
	
	public TreeMap<String, HashMap<String, HashMap<String, String>>> get_queue_from_processed_task_queues_map(String queue_name) {
		rw_lock.readLock().lock();
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			if (processed_task_queues_map.containsKey(queue_name)){
				queue_data.putAll(this.processed_task_queues_map.get(queue_name));
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return queue_data;
	}
	
	public Map<String, HashMap<String, HashMap<String, String>>> get_one_indexed_case_data(String queue_name) {
		rw_lock.readLock().lock();
		Map<String, HashMap<String, HashMap<String, String>>> id_case_data = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			TreeMap<String, HashMap<String, HashMap<String, String>>> received_task_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
			TreeMap<String, HashMap<String, HashMap<String, String>>> processed_task_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
			received_task_data.putAll(received_task_queues_map.get(queue_name));
			processed_task_data.putAll(processed_task_queues_map.get(queue_name));
			Set<String> received_task_data_set = received_task_data.keySet();
			Iterator<String> received_task_data_it = received_task_data_set.iterator();
			while(received_task_data_it.hasNext()){
				String case_id = received_task_data_it.next();
				if (processed_task_data.containsKey(case_id)){
					continue;
				} else {
					id_case_data.put(case_id,received_task_data.get(case_id));
					break;
				}
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return id_case_data;
	}	

	public void update_case_to_processed_task_queues_map(String queue_name, String case_id, HashMap<String, HashMap<String, String>> case_data) {
		rw_lock.writeLock().lock();
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			if (processed_task_queues_map.containsKey(queue_name)){
				queue_data.putAll(processed_task_queues_map.get(queue_name));
			}
			queue_data.put(case_id, case_data);
			processed_task_queues_map.put(queue_name, queue_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_queue_to_processed_task_queues_map(String queue_name, TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data) {
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
			if (processed_task_queues_map.containsKey(queue_name)){
				if(processed_task_queues_map.get(queue_name).containsKey(case_id)){
					processed_task_queues_map.get(queue_name).remove(case_id);
					remove_result = true;
				}
			} 
		} finally {
			rw_lock.writeLock().unlock();
		}
		return remove_result;
	}
	
	public HashMap<String, HashMap<String, String>> get_case_from_processed_task_queues_map(String queue_name, String case_id) {
		HashMap<String, HashMap<String, String>> case_data = new HashMap<String, HashMap<String, String>>();
		rw_lock.writeLock().lock();
		try {
			if (processed_task_queues_map.containsKey(queue_name)){
				if(processed_task_queues_map.get(queue_name).containsKey(case_id)){
					case_data.putAll(processed_task_queues_map.get(queue_name).get(case_id));
				}
			} 
		} finally {
			rw_lock.writeLock().unlock();
		}
		return case_data;
	}
	
	public TreeMap<String, String> get_rejected_admin_reason_treemap() {
		rw_lock.readLock().lock();
		TreeMap<String, String> temp = new TreeMap<String, String>(new queue_comparator());
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
			if (rejected_admin_reason_treemap.containsKey(queue_name)){
				this.rejected_admin_reason_treemap.remove(queue_name);
			} else {
				remove_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return remove_status;
	}
	/*
	public ArrayList<String> get_rejected_admin_queue_list() {
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try {
			temp.addAll(this.rejected_admin_queue_list);
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

	public void add_rejected_admin_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		try {
			this.rejected_admin_queue_list.add(queue_name);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public Boolean remove_rejected_admin_queue_list(String queue_name) {
		Boolean remove_status = new Boolean(true);
		rw_lock.writeLock().lock();
		try {
			if (rejected_admin_queue_list.contains(queue_name)){
				this.rejected_admin_queue_list.remove(queue_name);
			} else {
				remove_status = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return remove_status;
	}	
	*/
	/*
	public ArrayList<String> get_captured_admin_queue_list() {
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try {
			temp.addAll(this.captured_admin_queue_list);
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
	*/
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
	
	//not used
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
			temp.addAll(this.running_admin_queue_list);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void increase_running_admin_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		try {
			if(!running_admin_queue_list.contains(queue_name)){
				running_admin_queue_list.add(queue_name);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void decrease_running_admin_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		try {
			if(running_admin_queue_list.contains(queue_name)){
				running_admin_queue_list.remove(queue_name);
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
			temp.addAll(finished_admin_queue_list);
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
	
	public void update_finished_admin_queue_list(ArrayList<String> queue_list) {
		rw_lock.writeLock().lock();
		try {
			for(String queue_name: queue_list){
				if(!finished_admin_queue_list.contains(queue_name)){
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
			if(finished_admin_queue_list.contains(queue_name)){
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
			if(!watching_admin_queue_list.contains(queue_name)){
				watching_admin_queue_list.add(queue_name);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void decrease_watching_admin_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		try {
			if(watching_admin_queue_list.contains(queue_name)){
				watching_admin_queue_list.remove(queue_name);
			}
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

class queue_comparator implements Comparator<String>{
	@Override
	public int compare(String queue_name1, String queue_name2) {
		// priority:match/assign task:job_from@run_number
		int int_pri1 = 0, int_pri2 = 0;
		int int_id1 = 0, int_id2 = 0;
		try {
			int_pri1 = get_srting_int(queue_name1, "^(\\d+)@");
			int_pri2 = get_srting_int(queue_name2, "^(\\d+)@");
			int_id1 = get_srting_int(queue_name1, "run_(\\d+)_");
			int_id2 = get_srting_int(queue_name2, "run_(\\d+)_");
		} catch (Exception e) {
			return queue_name1.compareTo(queue_name2);
		}
		if (int_pri1 > int_pri2) {
			return 1;
		} else if (int_pri1 < int_pri2) {
			return -1;
		} else {
			if (int_id1 < int_id2) {
				return 1;
			} else if (int_id1 > int_id2) {
				return -1;
			} else {
				return queue_name1.compareTo(queue_name2);
			}
		}
	}
	
	private static int get_srting_int(String str, String patt) {
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
}

