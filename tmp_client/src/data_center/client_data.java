/*
 * File: tube_data.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package data_center;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class client_data {
	// public property
	// {queue_name: {case_id_or_title: {}}}
	// protected property
	// private property
	private static final Logger CLIENT_DATA_LOGGER = LogManager.getLogger(client_data.class.getName());
	private ReadWriteLock rw_lock = new ReentrantReadWriteLock();
	private HashMap<String, HashMap<String, String>> client_hash = new HashMap<String, HashMap<String, String>>();
	private HashMap<String, Integer> max_soft_insts = new HashMap<String, Integer>();
	private HashMap<String, Integer> use_soft_insts = new HashMap<String, Integer>();
	/*
	 * private String task_assign_mode = public_data.DEF_TASK_ASSIGN_MODE;
	 * private String thread_work_mode = public_data.DEF_MAX_THREAD_MODE;
	 * private int pool_current_size =
	 * Integer.parseInt(public_data.DEF_POOL_CURRENT_SIZE);//dup with pool_data,
	 * for data dump private String client_link_mode =
	 * public_data.DEF_CLIENT_LINK_MODE; private String client_work_path =
	 * public_data.DEF_WORK_PATH; private String client_save_path =
	 * public_data.DEF_SAVE_PATH;
	 */
	// public function
	// protected function
	// private function

	public client_data() {

	}

	public HashMap<String, HashMap<String, String>> get_client_data() {
		rw_lock.readLock().lock();
		HashMap<String, HashMap<String, String>> temp = new HashMap<String, HashMap<String, String>>();
		try {
			temp.putAll(client_hash);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_client_data(HashMap<String, HashMap<String, String>> update_data) {
		rw_lock.writeLock().lock();
		try {
			client_hash.clear();
			client_hash.putAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public HashMap<String, Integer> get_max_soft_insts() {
		rw_lock.readLock().lock();
		HashMap<String, Integer> temp = new HashMap<String, Integer>();
		try {
			temp.putAll(max_soft_insts);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_max_soft_insts(HashMap<String, Integer> update_data) {
		rw_lock.writeLock().lock();
		try {
			max_soft_insts.clear();
			max_soft_insts.putAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public HashMap<String, Integer> get_use_soft_insts() {
		rw_lock.readLock().lock();
		HashMap<String, Integer> temp = new HashMap<String, Integer>();
		try {
			temp.putAll(use_soft_insts);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	// release 1 usage for every software
	public Boolean release_use_soft_insts(HashMap<String, String> release_data) {
		rw_lock.writeLock().lock();
		Boolean release_result = new Boolean(true);
		try {
			HashMap<String, Integer> future_soft_insts = new HashMap<String, Integer>();
			future_soft_insts.putAll(use_soft_insts);
			Set<String> release_data_set = release_data.keySet();
			Iterator<String> release_data_it = release_data_set.iterator();
			while (release_data_it.hasNext()) {
				String sw_name = release_data_it.next();
				Integer sw_insts = future_soft_insts.get(sw_name);
				sw_insts = sw_insts - 1;
				if (sw_insts < 0) {
					sw_insts = 0;
					release_result = false;
					CLIENT_DATA_LOGGER.warn("Release warnning found for " + sw_name);
				}
				future_soft_insts.put(sw_name, sw_insts);
			}
			use_soft_insts.putAll(future_soft_insts);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return release_result;
	}

	public Boolean release_use_soft_insts_multi(HashMap<String, Integer> release_data) {
		rw_lock.writeLock().lock();
		Boolean release_result = new Boolean(true);
		try {
			HashMap<String, Integer> future_soft_insts = new HashMap<String, Integer>();
			future_soft_insts.putAll(use_soft_insts);
			Set<String> future_keys_set = future_soft_insts.keySet();
			Iterator<String> future_keys_it = future_keys_set.iterator();
			while (future_keys_it.hasNext()) {
				String sw_name = future_keys_it.next();
				Integer sw_insts = future_soft_insts.get(sw_name);
				sw_insts = sw_insts - release_data.get(sw_name);
				if (sw_insts < 0) {
					sw_insts = 0;
					release_result = false;
					CLIENT_DATA_LOGGER.warn("Release warnning found for " + sw_name);
				}
				future_soft_insts.put(sw_name, sw_insts);
			}
			use_soft_insts.putAll(future_soft_insts);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return release_result;
	}

	// software name , build
	// booking 1 usage for every used software
	public Boolean booking_use_soft_insts(HashMap<String, String> booking_data) {
		rw_lock.writeLock().lock();
		Boolean booking_result = new Boolean(true);
		try {
			HashMap<String, Integer> future_soft_insts = new HashMap<String, Integer>();
			future_soft_insts.putAll(use_soft_insts);
			Set<String> booking_data_set = booking_data.keySet();
			Iterator<String> booking_data_it = booking_data_set.iterator();
			while (booking_data_it.hasNext()) {
				String sw_name = booking_data_it.next();
				Integer sw_insts = new Integer(0);
				if (future_soft_insts.containsKey(sw_name)) {
					sw_insts = future_soft_insts.get(sw_name);
				}
				Integer sw_max_insts = max_soft_insts.get(sw_name);
				sw_insts = sw_insts + 1; // booking 1 usage for every software
				if (sw_insts > sw_max_insts) {
					booking_result = false;
					break;
				} else {
					future_soft_insts.put(sw_name, sw_insts);
				}
			}
			if (booking_result) {
				use_soft_insts.putAll(future_soft_insts);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return booking_result;
	}

	public Boolean booking_use_soft_insts_multi(HashMap<String, Integer> booking_data) {
		rw_lock.writeLock().lock();
		Boolean booking_result = new Boolean(true);
		try {
			HashMap<String, Integer> future_soft_insts = new HashMap<String, Integer>();
			future_soft_insts.putAll(use_soft_insts);
			Set<String> future_keys_set = future_soft_insts.keySet();
			Iterator<String> future_keys_it = future_keys_set.iterator();
			while (future_keys_it.hasNext()) {
				String sw_name = future_keys_it.next();
				Integer sw_insts = future_soft_insts.get(sw_name);
				Integer sw_max_insts = max_soft_insts.get(sw_name);
				sw_insts = sw_insts + booking_data.get(sw_name);
				if (sw_insts > sw_max_insts) {
					booking_result = false;
					break;
				} else {
					future_soft_insts.put(sw_name, sw_insts);
				}
			}
			if (booking_result) {
				use_soft_insts.putAll(future_soft_insts);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return booking_result;
	}

	public HashMap<String, Integer> get_available_software_insts() {
		rw_lock.writeLock().lock();
		HashMap<String, Integer> available_software_insts = new HashMap<String, Integer>();
		try {
			Set<String> soft_keys_set = max_soft_insts.keySet();
			Iterator<String> soft_keys_it = soft_keys_set.iterator();
			while (soft_keys_it.hasNext()) {
				String sw_name = soft_keys_it.next();
				Integer sw_max_insts = max_soft_insts.get(sw_name);
				Integer sw_use_insts = new Integer(0);
				Integer sw_free_insts = new Integer(0);
				if (use_soft_insts.containsKey(sw_name)) {
					sw_use_insts = use_soft_insts.get(sw_name);
				}
				sw_free_insts = sw_max_insts - sw_use_insts;
				available_software_insts.put(sw_name, sw_free_insts);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return available_software_insts;
	}

	public void set_use_soft_insts(HashMap<String, Integer> update_data) {
		rw_lock.writeLock().lock();
		try {
			use_soft_insts.clear();
			use_soft_insts.putAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	/*
	 * public void set_thread_work_mode(String new_data) {
	 * rw_lock.writeLock().lock(); try { this.thread_work_mode = new_data; }
	 * finally { rw_lock.writeLock().unlock(); } }
	 * 
	 * public String get_thread_work_mode() { rw_lock.readLock().lock(); String
	 * value = new String(); try { value = this.thread_work_mode; } finally {
	 * rw_lock.readLock().unlock(); } return value; }
	 * 
	 * public void set_pool_current_size(int new_data) {
	 * rw_lock.writeLock().lock(); try { this.pool_current_size = new_data; }
	 * finally { rw_lock.writeLock().unlock(); } }
	 * 
	 * public int get_pool_current_size() { rw_lock.readLock().lock(); int value
	 * = 0; try { value = this.pool_current_size; } finally {
	 * rw_lock.readLock().unlock(); } return value; }
	 * 
	 * public void set_task_assign_mode(String new_data) {
	 * rw_lock.writeLock().lock(); try { this.task_assign_mode = new_data; }
	 * finally { rw_lock.writeLock().unlock(); } }
	 * 
	 * public String get_task_assign_mode() { rw_lock.readLock().lock(); String
	 * value = new String(); try { value = this.task_assign_mode; } finally {
	 * rw_lock.readLock().unlock(); } return value; }
	 * 
	 * public void set_client_link_mode(String new_data) {
	 * rw_lock.writeLock().lock(); try { this.client_link_mode = new_data; }
	 * finally { rw_lock.writeLock().unlock(); } }
	 * 
	 * public String get_client_link_mode() { rw_lock.readLock().lock(); String
	 * value = new String(); try { value = this.client_link_mode; } finally {
	 * rw_lock.readLock().unlock(); } return value; }
	 * 
	 * public void set_client_work_path(String new_data) {
	 * rw_lock.writeLock().lock(); try { this.client_work_path = new_data; }
	 * finally { rw_lock.writeLock().unlock(); } }
	 * 
	 * public String get_client_work_path() { rw_lock.readLock().lock(); String
	 * value = new String(); try { value = this.client_work_path; } finally {
	 * rw_lock.readLock().unlock(); } return value; }
	 * 
	 * public void set_client_save_path(String new_data) {
	 * rw_lock.writeLock().lock(); try { this.client_save_path = new_data; }
	 * finally { rw_lock.writeLock().unlock(); } }
	 * 
	 * public String get_client_save_path() { rw_lock.readLock().lock(); String
	 * value = new String(); try { value = this.client_save_path; } finally {
	 * rw_lock.readLock().unlock(); } return value; }
	 */

	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		CLIENT_DATA_LOGGER.warn("Share data");
	}
}