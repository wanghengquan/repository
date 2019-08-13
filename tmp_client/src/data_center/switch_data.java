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
import top_runner.run_status.maintain_enum;
import top_runner.run_status.state_enum;

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
	private Exception client_stop_exception = new Exception();
	// Thread start sequence
	private Boolean start_progress_power_up = new Boolean(false);
	private Boolean main_gui_power_up = new Boolean(false);
	private Boolean data_server_power_up = new Boolean(false);
	private Boolean tube_server_power_up = new Boolean(false);
	private Boolean hall_server_power_up = new Boolean(false);
	private Boolean local_console_mode = new Boolean(false);
	// suite file updating
	// private ArrayList<String> suite_file_list = new ArrayList<String>();
	// client hall status(idle or busy) : thread pool not empty == busy
	// private String client_hall_status = new String("busy");
	// Client console updating
	private Boolean client_console_updating = new Boolean(false);
	// Client maintains mode (house keeping) assertion
	// private Boolean client_maintain_keeping = new Boolean(false);
	private ArrayList<maintain_enum> client_maintain_list = new ArrayList<maintain_enum>();
	// Client management update 
	private state_enum client_run_state = state_enum.initial;
	// Client environ update
	private Boolean client_environ_issue = new Boolean(true);
	// system level message
	//private String client_info_message = new String("");
	//private String client_warn_message = new String("");
	//private String client_error_message = new String("");
	private Boolean core_script_update_request = new Boolean(false);
	private Boolean work_space_update_request = new Boolean(false);
	private String space_warning_announced_date = new String("");
	private String environ_warning_announced_date = new String("");
	private String corescript_warning_announced_date = new String("");
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

	public void set_client_stop_exception(Exception dump_exception) {
		rw_lock.writeLock().lock();
		try {
			this.client_stop_exception = dump_exception;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public Exception get_client_stop_exception() {
		Exception result = new Exception();
		rw_lock.readLock().lock();
		try {
			result = this.client_stop_exception;
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
	
	public void set_local_console_mode() {
		rw_lock.writeLock().lock();
		try {
			this.local_console_mode = true;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public void set_local_console_mode(Boolean run_mode) {
		rw_lock.writeLock().lock();
		try {
			this.local_console_mode = run_mode;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public Boolean get_local_console_mode() {
		Boolean status = new Boolean(false);
		rw_lock.readLock().lock();
		try {
			status = this.local_console_mode;
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
	
	//client client_environ_issue
	public void set_client_environ_issue(Boolean new_status) {
		rw_lock.writeLock().lock();
		try {
			this.client_environ_issue = new_status;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public Boolean get_client_environ_issue() {
		Boolean status = new Boolean(false);
		rw_lock.readLock().lock();
		try {
			status = this.client_environ_issue;
		} finally {
			rw_lock.readLock().unlock();
		}
		return status;
	}
	
	/*
	public void set_client_maintain_keeping(Boolean new_status) {
		rw_lock.writeLock().lock();
		try {
			this.client_maintain_keeping = new_status;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public Boolean get_client_maintain_keeping() {
		Boolean status = new Boolean(false);
		rw_lock.readLock().lock();
		try {
			status = this.client_maintain_keeping;
		} finally {
			rw_lock.readLock().unlock();
		}
		return status;
	}	
	*/
	//client_maintain_reason
	public void clear_client_maintain_list() {
		rw_lock.writeLock().lock();
		try {
			this.client_maintain_list.clear();;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public Boolean update_client_maintain_list(maintain_enum maintain_entry) {
		Boolean update_status = new Boolean(true);
		rw_lock.writeLock().lock();
		try {
			if (client_maintain_list.contains(maintain_entry)){
				update_status = false;
			} else {
				client_maintain_list.add(maintain_entry);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}

	public ArrayList<maintain_enum> get_client_maintain_list() {
		rw_lock.readLock().lock();
		ArrayList<maintain_enum> temp = new ArrayList<maintain_enum>();
		try {
			temp.addAll(client_maintain_list);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}	
	
	public void set_client_run_state(state_enum run_state) {
		rw_lock.writeLock().lock();
		try {
			this.client_run_state = run_state;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public state_enum get_client_run_state() {
		state_enum run_state = state_enum.initial;
		rw_lock.readLock().lock();
		try {
			run_state = this.client_run_state;
		} finally {
			rw_lock.readLock().unlock();
		}
		return run_state;
	}
	
	public void set_core_script_update_request(Boolean new_request) {
		rw_lock.writeLock().lock();
		try {
			this.core_script_update_request = new_request;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public Boolean get_core_script_update_request() {
		Boolean status = new Boolean(false);
		rw_lock.readLock().lock();
		try {
			status = this.core_script_update_request;
		} finally {
			rw_lock.readLock().unlock();
		}
		return status;
	}	
	
	public void set_work_space_update_request(Boolean new_request) {
		rw_lock.writeLock().lock();
		try {
			this.work_space_update_request = new_request;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public Boolean get_work_space_update_request() {
		Boolean status = new Boolean(false);
		rw_lock.readLock().lock();
		try {
			status = this.work_space_update_request;
		} finally {
			rw_lock.readLock().unlock();
		}
		return status;
	}	
	
	public void set_space_warning_announced_date(String new_date) {
		rw_lock.writeLock().lock();
		try {
			this.space_warning_announced_date = new_date;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public String get_space_warning_announced_date() {
		String date = new String("");
		rw_lock.readLock().lock();
		try {
			date = this.space_warning_announced_date;
		} finally {
			rw_lock.readLock().unlock();
		}
		return date;
	}
	
	public void set_environ_warning_announced_date(String new_date) {
		rw_lock.writeLock().lock();
		try {
			this.environ_warning_announced_date = new_date;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public String get_environ_warning_announced_date() {
		String date = new String("");
		rw_lock.readLock().lock();
		try {
			date = this.environ_warning_announced_date;
		} finally {
			rw_lock.readLock().unlock();
		}
		return date;
	}
	
	public void set_core_script_warning_announced_date(String new_date) {
		rw_lock.writeLock().lock();
		try {
			this.corescript_warning_announced_date = new_date;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public String get_core_script_warning_announced_date() {
		String date = new String("");
		rw_lock.readLock().lock();
		try {
			date = this.corescript_warning_announced_date;
		} finally {
			rw_lock.readLock().unlock();
		}
		return date;
	}	
	/*
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
	 */
	/*
	public void add_suite_file_list1(ArrayList<String> file_list) {
		rw_lock.writeLock().lock();
		try {
			this.suite_file_list.addAll(file_list);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public void add_suite_file_list1(String suite_file) {
		rw_lock.writeLock().lock();
		try {
			this.suite_file_list.add(suite_file);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	
	public ArrayList<String> get_suite_file_list1() {
		rw_lock.readLock().lock();
		ArrayList<String> value = new ArrayList<String>();
		try {
			value = this.suite_file_list;
		} finally {
			rw_lock.readLock().unlock();
		}
		return value;
	}

	public String get_one_suite_file1() {
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
	*/

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