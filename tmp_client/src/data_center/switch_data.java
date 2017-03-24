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
	private int send_admin_request = 5;  //for client start up use why???
	private int dump_config_request = 0;
	// Thread start sequence
	private Boolean client_self_check = new Boolean(false);
	private Boolean core_script_update = new Boolean(false);
	private Boolean data_server_power_up = new Boolean(false);
	private Boolean tube_server_power_up = new Boolean(false);
	private Boolean hall_server_power_up = new Boolean(false);
	private Boolean back_ground_power_up = new Boolean(false);
	// suite file updating
	private String suite_file = new String();
	// client work mode
	private String task_work_mode = public_data.DEF_TASK_WORK_MODE;
	private String thread_work_mode = public_data.DEF_MAX_THREAD_MODE;
	private Integer current_max_thread = Integer.parseInt(public_data.DEF_MAX_THREADS);
	// public function
	public switch_data() {

	}

	public void set_client_updated() {
		rw_lock.writeLock().lock();
		try {
			this.send_admin_request = send_admin_request + 2;
			this.dump_config_request = dump_config_request + 1;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public Boolean impl_send_admin_request(){
		rw_lock.writeLock().lock();
		Boolean action_need = new Boolean(false);
		try {
			if (send_admin_request > 0){
				action_need = true;
				this.send_admin_request = send_admin_request - 1;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return action_need;
	}

	public Boolean impl_dump_config_request(){
		rw_lock.writeLock().lock();
		Boolean action_need = new Boolean(false);
		try {
			if (dump_config_request > 0){
				action_need = true;
				dump_config_request = dump_config_request - 1;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return action_need;
	}
	
	public void set_client_self_check() {
		rw_lock.writeLock().lock();
		try {
			this.client_self_check = true;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public Boolean get_client_self_check() {
		Boolean status = new Boolean(false);
		rw_lock.readLock().lock();
		try {
			status = this.client_self_check;
		} finally {
			rw_lock.readLock().unlock();
		}
		return status;
	}
	
	public void set_core_script_update() {
		rw_lock.writeLock().lock();
		try {
			this.core_script_update = true;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public Boolean get_core_script_update() {
		Boolean status = new Boolean(false);
		rw_lock.readLock().lock();
		try {
			status = this.core_script_update;
		} finally {
			rw_lock.readLock().unlock();
		}
		return status;
	}
	
	public void set_data_server_power_up() {
		rw_lock.writeLock().lock();
		try {
			this.data_server_power_up = true;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public Boolean get_data_server_power_up() {
		Boolean status = new Boolean(false);
		rw_lock.readLock().lock();
		try {
			status = this.data_server_power_up;
		} finally {
			rw_lock.readLock().unlock();
		}
		return status;
	}	
	
	public void set_tube_server_power_up() {
		rw_lock.writeLock().lock();
		try {
			this.tube_server_power_up = true;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public Boolean get_tube_server_power_up() {
		Boolean status = new Boolean(false);
		rw_lock.readLock().lock();
		try {
			status = this.tube_server_power_up;
		} finally {
			rw_lock.readLock().unlock();
		}
		return status;
	}
	
	public void set_hall_server_power_up() {
		rw_lock.writeLock().lock();
		try {
			this.hall_server_power_up = true;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public Boolean get_hall_server_power_up() {
		Boolean status = new Boolean(false);
		rw_lock.readLock().lock();
		try {
			status = this.hall_server_power_up;
		} finally {
			rw_lock.readLock().unlock();
		}
		return status;
	}
	
	public void set_back_ground_power_up() {
		rw_lock.writeLock().lock();
		try {
			this.back_ground_power_up = true;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public Boolean get_back_ground_power_up() {
		Boolean status = new Boolean(false);
		rw_lock.readLock().lock();
		try {
			status = this.back_ground_power_up;
		} finally {
			rw_lock.readLock().unlock();
		}
		return status;
	}
	
	public void set_suite_file(String new_data) {
		rw_lock.writeLock().lock();
		try {
			this.suite_file = new_data;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public String get_suite_file() {
		rw_lock.readLock().lock();
		String value = new String();
		try {
			value = this.suite_file;
		} finally {
			rw_lock.readLock().unlock();
		}
		return value;
	}	
	
	public String impl_suite_file() {
		rw_lock.writeLock().lock();
		String value = new String();
		try {
			value = this.suite_file;
			suite_file = "";
		} finally {
			rw_lock.writeLock().unlock();
		}
		return value;
	}

	public void set_thread_work_mode(String new_data) {
		rw_lock.writeLock().lock();
		try {
			this.thread_work_mode = new_data;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public String get_thread_work_mode() {
		rw_lock.readLock().lock();
		String value = new String();
		try {
			value = this.thread_work_mode;
		} finally {
			rw_lock.readLock().unlock();
		}
		return value;
	}

	public void set_task_work_mode(String new_data) {
		rw_lock.writeLock().lock();
		try {
			this.task_work_mode = new_data;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public String get_task_work_mode() {
		rw_lock.readLock().lock();
		String value = new String();
		try {
			value = this.task_work_mode;
		} finally {
			rw_lock.readLock().unlock();
		}
		return value;
	}
	
	public void set_current_max_thread(Integer new_data) {
		rw_lock.writeLock().lock();
		try {
			this.current_max_thread = new_data;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public Integer get_current_max_thread() {
		rw_lock.readLock().lock();
		int value = new Integer(0);
		try {
			value = this.current_max_thread;
		} finally {
			rw_lock.readLock().unlock();
		}
		return value;
	}
	// protected function
	// private function
	
}