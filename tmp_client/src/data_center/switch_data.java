/*
 * File: public_data.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package data_center;

import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class switch_data {
	// public property
	// protected property
	// private property
	@SuppressWarnings("unused")
	private static final Logger SWITCH_DATA_LOGGER = LogManager.getLogger(switch_data.class.getName());
	private ReadWriteLock rw_lock = new ReentrantReadWriteLock();
	// client update
	private int client_update = 0;

	// run tube variables
	private int available_admin_queue_updating = 0;

	// suite file updating
	private String suite_file_string = new String();

	// client task queue work mode serial, parallel

	private String pool_max_procs = public_data.DEF_MAX_PROCS;

	//
	private String queue_work_mode = public_data.DEF_QUEUE_WORK_MODE;
	private String client_work_mode = public_data.DEF_CLIENT_WORK_MODE;

	// public function
	public switch_data() {

	}

	public void set_client_updated() {
		rw_lock.writeLock().lock();
		try {
			this.client_update = 2;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	//every client update need two action
	//1) save data to config file. 2) make a admin request
	public Boolean get_client_updated(){
		rw_lock.writeLock().lock();
		Boolean action_need = new Boolean(false);
		try {
			if (client_update > 0){
				action_need = true;
			}
			this.client_update = client_update - 1;
		} finally {
			rw_lock.writeLock().unlock();
		}
		return action_need;
	}

	public void set_available_admin_queue_updating(int new_data) {
		rw_lock.writeLock().lock();
		try {
			this.available_admin_queue_updating = new_data;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public int get_available_admin_queue_updating() {
		rw_lock.readLock().lock();
		int value = 0;
		try {
			value = this.available_admin_queue_updating;
		} finally {
			rw_lock.readLock().unlock();
		}
		return value;
	}

	public void set_suite_file_string(String new_data) {
		rw_lock.writeLock().lock();
		try {
			this.suite_file_string = new_data;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public String get_suite_file_string() {
		rw_lock.readLock().lock();
		String value = new String();
		try {
			value = this.suite_file_string;
		} finally {
			rw_lock.readLock().unlock();
		}
		return value;
	}

	public void set_client_work_mode(String new_data) {
		rw_lock.writeLock().lock();
		try {
			this.client_work_mode = new_data;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public String get_client_work_mode() {
		rw_lock.readLock().lock();
		String value = new String();
		try {
			value = this.client_work_mode;
		} finally {
			rw_lock.readLock().unlock();
		}
		return value;
	}

	public void set_pool_max_procs(String new_data) {
		rw_lock.writeLock().lock();
		try {
			this.pool_max_procs = new_data;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public String get_pool_max_procs() {
		rw_lock.readLock().lock();
		String value = new String();
		try {
			value = this.pool_max_procs;
		} finally {
			rw_lock.readLock().unlock();
		}
		return value;
	}

	public void set_queue_work_mode(String new_data) {
		rw_lock.writeLock().lock();
		try {
			this.queue_work_mode = new_data;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public String get_queue_work_mode() {
		rw_lock.readLock().lock();
		String value = new String();
		try {
			value = this.queue_work_mode;
		} finally {
			rw_lock.readLock().unlock();
		}
		return value;
	}
	// protected function
	// private function

}