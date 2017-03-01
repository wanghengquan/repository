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
import java.util.Map;
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
	private Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> task_queues_data_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
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
	// processing: all captured queue with status in processing
	private ArrayList<String> processing_admin_queue_list = new ArrayList<String>();
	// ====updated by waiters====
	// running: working queue
	private ArrayList<String> running_admin_queue_list = new ArrayList<String>();
	// finished: finished queue by waiter
	private ArrayList<String> finished_admin_queue_list = new ArrayList<String>();

	public task_data() {

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