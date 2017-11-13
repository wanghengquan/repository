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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;
import java.util.prefs.Preferences;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import env_monitor.machine_sync;

public class switch_data {
	// public property
	// protected property
	// private property
	@SuppressWarnings("unused")
	private static final Logger SWITCH_DATA_LOGGER = LogManager.getLogger(switch_data.class.getName());
	private static final Preferences sys_pref = Preferences.userRoot().node("tmp_client");
	private ReadWriteLock rw_lock = new ReentrantReadWriteLock();
	// System start client record
	private int system_client_insts = sys_pref.getInt("", 0);
	// client update
	private int send_admin_request = 1; // for client start up
	private int dump_config_request = 0;
	private int check_core_request = 0;
	// client house keep request
	private int house_keep_request = 0;
	private HashMap<exit_enum, Integer> client_stop_request = new HashMap<exit_enum, Integer>();
	// Thread start sequence
	private Boolean start_progress_power_up = new Boolean(false);
	private Boolean main_gui_power_up = new Boolean(false);
	private Boolean data_server_power_up = new Boolean(false);
	private Boolean tube_server_power_up = new Boolean(false);
	private Boolean hall_server_power_up = new Boolean(false);
	// suite file updating
	private ArrayList<String> suite_file_list = new ArrayList<String>();
	// client hall status(idle or busy) : thread pool not empty == busy
	private String client_hall_status = new String("busy");
	// Client concole updating
	private Boolean client_console_updating = new Boolean(false);
	// Client maintaince mode (house keeping) assertion
	private Boolean client_house_keeping = new Boolean(false);
	// system level message
	//private String client_info_message = new String("");
	//private String client_warn_message = new String("");
	//private String client_error_message = new String("");
	
	
	// public function
	public switch_data() {

	}

	public int get_system_client_insts() {
		rw_lock.writeLock().lock();
		String terminal = new String(machine_sync.get_host_name());
		try {
			system_client_insts = sys_pref.getInt(terminal, 0);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return system_client_insts;
	}

	public void increase_system_client_insts() {
		//always use the data form preference in disk
		rw_lock.writeLock().lock();
		String terminal = new String(machine_sync.get_host_name());
		try {
			system_client_insts = get_system_client_insts() + 1;
			sys_pref.putInt(terminal, system_client_insts);
			sys_pref.flush();
		} catch (Exception e){
			e.printStackTrace();
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public void decrease_system_client_insts() {
		//always use the data form preference in disk
		rw_lock.writeLock().lock();
		String terminal = new String(machine_sync.get_host_name());
		try {
			system_client_insts = get_system_client_insts();
			if (system_client_insts > 0) {
				system_client_insts = system_client_insts - 1;
			}
			sys_pref.putInt(terminal, system_client_insts);
			sys_pref.flush();
		} catch (Exception e){
			e.printStackTrace();			
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

	/*
	 * public void decrease_house_keep_request() { rw_lock.writeLock().lock();
	 * try { if (house_keep_request > 0) { house_keep_request =
	 * house_keep_request - 1; } } finally { rw_lock.writeLock().unlock(); } }
	 * 
	 * public int get_house_keep_request() { int result = 0;
	 * rw_lock.readLock().lock(); try { result = this.house_keep_request; }
	 * finally { rw_lock.readLock().unlock(); } return result; }
	 */

	public void set_client_stop_request(exit_enum exit_state) {
		rw_lock.writeLock().lock();
		try {
			Integer ori_data = client_stop_request.getOrDefault(exit_state, 0);
			client_stop_request.put(exit_state, ori_data + 1);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public HashMap<exit_enum, Integer> get_client_stop_request() {
		HashMap<exit_enum, Integer> result = new HashMap<exit_enum, Integer>();
		rw_lock.readLock().lock();
		try {
			result.putAll(client_stop_request);
		} finally {
			rw_lock.readLock().unlock();
		}
		return result;
	}

	public void set_main_gui_power_up() {
		rw_lock.writeLock().lock();
		try {
			this.main_gui_power_up = true;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public Boolean get_main_gui_power_up() {
		Boolean status = new Boolean(false);
		rw_lock.readLock().lock();
		try {
			status = this.main_gui_power_up;
		} finally {
			rw_lock.readLock().unlock();
		}
		return status;
	}

	public void set_start_progress_power_up() {
		rw_lock.writeLock().lock();
		try {
			this.start_progress_power_up = true;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public Boolean get_start_progress_power_up() {
		Boolean status = new Boolean(false);
		rw_lock.readLock().lock();
		try {
			status = this.start_progress_power_up;
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
	//app_update_running
	public void set_client_console_updating(Boolean new_status) {
		rw_lock.writeLock().lock();
		try {
			this.client_console_updating = new_status;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public Boolean get_client_console_updating() {
		Boolean status = new Boolean(false);
		rw_lock.readLock().lock();
		try {
			status = this.client_console_updating;
		} finally {
			rw_lock.readLock().unlock();
		}
		return status;
	}	
	
	//client_house_keeping
	public void set_client_house_keeping(Boolean new_status) {
		rw_lock.writeLock().lock();
		try {
			this.client_house_keeping = new_status;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public Boolean get_client_house_keeping() {
		Boolean status = new Boolean(false);
		rw_lock.readLock().lock();
		try {
			status = this.client_house_keeping;
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

	public void add_suite_file_list(ArrayList<String> file_list) {
		rw_lock.writeLock().lock();
		try {
			this.suite_file_list.addAll(file_list);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public void add_suite_file_list(String suite_file) {
		rw_lock.writeLock().lock();
		try {
			this.suite_file_list.add(suite_file);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public ArrayList<String> get_suite_file_list() {
		rw_lock.readLock().lock();
		ArrayList<String> value = new ArrayList<String>();
		try {
			value = this.suite_file_list;
		} finally {
			rw_lock.readLock().unlock();
		}
		return value;
	}

	public String get_one_suite_file() {
		rw_lock.writeLock().lock();
		String value = new String(); 
		try {
			if (!suite_file_list.isEmpty()){
				value = suite_file_list.get(0);
				suite_file_list.remove(0);
			}
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