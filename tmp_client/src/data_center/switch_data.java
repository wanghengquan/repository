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
import java.util.prefs.Preferences;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class switch_data {
	// public property
	// protected property
	// private property
	@SuppressWarnings("unused")
	private static final Logger SWITCH_DATA_LOGGER = LogManager.getLogger(switch_data.class.getName());
	private static final Preferences sys_pref = Preferences.userRoot().node("tmp_client_num");
	private ReadWriteLock rw_lock = new ReentrantReadWriteLock();
	// System start client record
	private int system_client_insts = sys_pref.getInt("", 0);
	// client update
	private int send_admin_request = 1; // for client start up 
	private int dump_config_request = 0;
	private int check_core_request = 0;
	// client house keep request
	private int house_keep_request = 0;
	private int client_stop_request = 0;
	// Thread start sequence
	private Boolean client_self_check = new Boolean(false);
	private Boolean core_script_update = new Boolean(false);
	private Boolean data_server_power_up = new Boolean(false);
	private Boolean tube_server_power_up = new Boolean(false);
	private Boolean hall_server_power_up = new Boolean(false);
	private Boolean back_ground_power_up = new Boolean(false);
	// suite file updating
	private String suite_file = new String();
	// client hall status(idle or busy) : thread pool not empty == busy
    private String client_hall_status = new String("busy");
    private Boolean client_maintenance_mode = new Boolean(false);
	// public function
	public switch_data() {

	}

	public int get_system_client_insts(){
		rw_lock.writeLock().lock();
		try {
			system_client_insts = sys_pref.getInt("run_num", 0);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return system_client_insts;
	}
	
	public void increase_system_client_insts(){
		rw_lock.writeLock().lock();
		try {
			system_client_insts = system_client_insts + 1;
			sys_pref.putInt("run_num", system_client_insts);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void decrease_system_client_insts(){
		rw_lock.writeLock().lock();
		try {
			if(system_client_insts > 0){
				system_client_insts = system_client_insts - 1;
			}
			sys_pref.putInt("run_num", system_client_insts);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public void set_client_updated() {
		rw_lock.writeLock().lock();
		try {
			this.send_admin_request = send_admin_request + 1;
			this.dump_config_request = dump_config_request + 1;
			this.check_core_request = check_core_request + 1;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public Boolean impl_send_admin_request() {
		rw_lock.writeLock().lock();
		Boolean action_need = new Boolean(false);
		try {
			if (send_admin_request > 0) {
				action_need = true;
				this.send_admin_request = send_admin_request - 1;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return action_need;
	}

	public Boolean impl_dump_config_request() {
		rw_lock.writeLock().lock();
		Boolean action_need = new Boolean(false);
		try {
			if (dump_config_request > 0) {
				action_need = true;
				dump_config_request = dump_config_request - 1;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return action_need;
	}

	public Boolean impl_check_core_request() {
		rw_lock.writeLock().lock();
		Boolean action_need = new Boolean(false);
		try {
			if (check_core_request > 0) {
				action_need = true;
				check_core_request = check_core_request - 1;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return action_need;
	}
	
	public void set_house_keep_request() {
		rw_lock.writeLock().lock();
		try {
			this.house_keep_request = house_keep_request + 1;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void decrease_house_keep_request() {
		rw_lock.writeLock().lock();
		try {
			if (house_keep_request > 0) {
				house_keep_request = house_keep_request - 1;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public int get_house_keep_request() {
		int result = 0;
		rw_lock.readLock().lock();		
		try {
			result = this.house_keep_request;
		} finally {
			rw_lock.readLock().unlock();
		}
		return result;
	}
	
	public void set_client_stop_request() {
		rw_lock.writeLock().lock();
		try {
			this.client_stop_request = client_stop_request + 1;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public int get_client_stop_request() {
		int result = 0;
		rw_lock.readLock().lock();		
		try {
			result = this.client_stop_request;
		} finally {
			rw_lock.readLock().unlock();
		}
		return result;
	}
	
	public void set_client_self_check(Boolean check_status) {
		rw_lock.writeLock().lock();
		try {
			this.client_self_check = check_status;
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

	public void set_core_script_update(Boolean update_status) {
		rw_lock.writeLock().lock();
		try {
			this.core_script_update = update_status;
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
	
	public void set_client_hall_status(String current_status) {
		rw_lock.writeLock().lock();
		try {
			this.client_hall_status = current_status;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public String get_client_hall_status() {
		String status = new String("");
		rw_lock.readLock().lock();
		try {
			status = this.client_hall_status;
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

	/*
	 * public void set_current_max_thread(Integer new_data) {
	 * rw_lock.writeLock().lock(); try { this.current_max_thread = new_data; }
	 * finally { rw_lock.writeLock().unlock(); } }
	 * 
	 * public Integer get_current_max_thread() { rw_lock.readLock().lock(); int
	 * value = new Integer(0); try { value = this.current_max_thread; } finally
	 * { rw_lock.readLock().unlock(); } return value; }
	 */
	// protected function
	// private function

}