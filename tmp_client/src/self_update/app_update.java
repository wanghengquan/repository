/*
 * File: app_update.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/05/3
 * Modifier:
 * Date:
 * Description:
 */
package self_update;


import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.panayotis.jupidator.UpdatedApplication;
import com.panayotis.jupidator.Updater;
import com.panayotis.jupidator.UpdaterException;

import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;

import utility_funcs.file_action;


public class app_update extends Thread implements UpdatedApplication  {
	// public property
	// protected property
	// private property
	//private static final Logger TMP_MANAGER_LOGGER = LogManager.getLogger(tmp_manager.class.getName());
	private static final Logger APP_UPDATE_LOGGER = LogManager.getLogger(app_update.class.getName()); 
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread current_thread;
	private String line_separator = System.getProperty("line.separator");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;	
	private switch_data switch_info;
	private client_data client_info;	
	// public function
	// protected function
	// private function	
	
	public app_update(switch_data switch_info, client_data client_info){
		this.switch_info = switch_info;
		this.client_info = client_info;
		create_update();
	}
	
	public void create_update(){
		String run_mode = client_info.get_client_data().get("preference").get("cmd_gui");
		Boolean force_console_update = new Boolean(false);
		if (run_mode.equalsIgnoreCase("cmd")){
			force_console_update = true;
		}
        try {
        	Updater app_update =  new Updater(
                    public_data.UPDATE_URL,
                    public_data.SW_HOME_PATH,
                    public_data.BASE_CURRENTVERSION_INT,
                    public_data.BASE_CURRENTVERSION,
                    this,
                    force_console_update);
        	app_update.actionDisplay();
        } catch (UpdaterException ex) {
            ex.printStackTrace();
            APP_UPDATE_LOGGER.warn("TMP client self update failed.");
        }
	}
	
	@Override
	public void receiveMessage(String message) {
		// TODO Auto-generated method stub
		System.err.println(message);
	}

	@Override
	public boolean requestRestart() {
		// TODO Auto-generated method stub
		return true;
	}
	
	public void run() {
		try {
			monitor_run();
		} catch (Exception run_exception) {
			run_exception.printStackTrace();
			String dump_path = client_info.get_client_data().get("preference").get("work_path") 
					+ "/" + public_data.WORKSPACE_LOG_DIR + "/core_dump/dump.log";
			file_action.append_file(dump_path, run_exception.toString() + line_separator);
			for(Object item: run_exception.getStackTrace()){
				file_action.append_file(dump_path, "    at " + item.toString() + line_separator);
			}			
			System.exit(1);
		}
	}

	private void monitor_run() {
		current_thread = Thread.currentThread();
		// ============== All static job start from here ==============
		// initial 1 : 
		// initial 2 : 
		// start loop:
		while (!stop_request) {
			if (wait_request) {
				try {
					synchronized (this) {
						this.wait();
					}
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} else {
				APP_UPDATE_LOGGER.debug("Client Thread running...");
			}
			// ============== All dynamic job start from here ==============
			// task 1 : update core script
			// task 2 : 
			// task 3 : 
			// task 4 : 
			try {
				Thread.sleep(base_interval * 2 * 1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public void soft_stop() {
		stop_request = true;
	}

	public void hard_stop() {
		stop_request = true;
		if (current_thread != null) {
			current_thread.interrupt();
		}
	}

	public void wait_request() {
		wait_request = true;
	}

	public void wake_request() {
		wait_request = false;
		synchronized (this) {
			this.notify();
		}
	}
	
	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		
	}
}