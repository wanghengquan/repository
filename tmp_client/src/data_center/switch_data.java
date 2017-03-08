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
	private int send_admin_request = 1;  //for client start up use
	private int dump_config_request = 0;
	// client max process number
	private String pool_max_procs = public_data.DEF_MAX_PROCS;
	
	
	
	
	// run tube variables
	private int available_admin_queue_updating = 0;

	// suite file updating
	private String suite_file_string = new String();



	//
	private String queue_work_mode = public_data.DEF_QUEUE_WORK_MODE;
	private String client_work_mode = public_data.DEF_CLIENT_WORK_MODE;

	// public function
	public switch_data() {

	}

	public void set_client_updated() {
		rw_lock.writeLock().lock();
		try {
			this.send_admin_request = send_admin_request + 1;
			this.dump_config_request = dump_config_request + 1;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public Boolean get_send_admin_request(){
		rw_lock.writeLock().lock();
		Boolean action_need = new Boolean(false);
		try {
			if (send_admin_request > 0){
				action_need = true;
			}
			this.send_admin_request = send_admin_request - 1;
		} finally {
			rw_lock.writeLock().unlock();
		}
		return action_need;
	}

	public Boolean get_dump_config_request(){
		rw_lock.writeLock().lock();
		Boolean action_need = new Boolean(false);
		try {
			if (dump_config_request > 0){
				action_need = true;
			}
			this.dump_config_request = dump_config_request - 1;
		} finally {
			rw_lock.writeLock().unlock();
		}
		return action_need;
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
	
	
	
	//check following
	
	
	
	
	
	
	
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