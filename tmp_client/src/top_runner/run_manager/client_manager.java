/*
 * File: cmd_parser.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package top_runner.run_manager;

import java.util.HashMap;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.task_data;
import connect_tube.tube_server;
import data_center.client_data;
import data_center.data_server;
import data_center.exit_enum;
import data_center.public_data;
import data_center.switch_data;
import flow_control.hall_manager;
import flow_control.pool_data;
import gui_interface.view_data;
import gui_interface.view_server;
import top_runner.run_status.client_status;
import utility_funcs.file_action;
import utility_funcs.time_info;


public class client_manager extends Thread  {
	// public property
	// protected property
	// private property
	//private static final Logger CLIENT_MANAGER_LOGGER = LogManager.getLogger(tmp_manager.class.getName());
	private static Logger CLIENT_MANAGER_LOGGER = LogManager.getLogger(client_manager.class.getName());; 
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread current_thread;
	private String line_separator = System.getProperty("line.separator");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;	
	private switch_data switch_info;
	private client_data client_info;
	private task_data task_info;
	private view_data view_info;
	private pool_data pool_info;
	private HashMap<String, String> cmd_info;
	private int hall_idle_count = 0;
	// public function
	// protected function
	// private function	
	
	public client_manager(
			switch_data switch_info, 
			client_data client_info,
			task_data task_info,
			view_data view_info,
			pool_data pool_info,
			HashMap<String, String> cmd_info){
		this.switch_info = switch_info;
		this.client_info = client_info;
		this.task_info = task_info;
		this.view_info = view_info;
		this.pool_info = pool_info;
		this.cmd_info = cmd_info;
	}
	
	private Boolean start_maintenance_mode(){
		String current_hall_status = switch_info.get_client_hall_status();
		if(current_hall_status.equalsIgnoreCase("idle")){
			hall_idle_count += 1;
		} else {
			hall_idle_count = 0;
		}
		if (hall_idle_count > 60){
			//cycle is base_interval * 1 * 60 = 5 minutes
			hall_idle_count = 0;
			return true;
		}
		return false;
	}
	
	public void run() {
		try {
			shut_down_server();
			monitor_run();
		} catch (Exception run_exception) {
			run_exception.printStackTrace();
			String dump_path = client_info.get_client_data().get("preference").get("work_path") 
					+ "/" + public_data.WORKSPACE_LOG_DIR + "/core_dump/dump.log";
			file_action.append_file(dump_path, " " + line_separator);
			file_action.append_file(dump_path, "####################" + line_separator);
			file_action.append_file(dump_path, time_info.get_date_time() + line_separator);			
			file_action.append_file(dump_path, run_exception.toString() + line_separator);
			for(Object item: run_exception.getStackTrace()){
				file_action.append_file(dump_path, "    at " + item.toString() + line_separator);
			}			
			System.exit(exit_enum.DUMP.get_index());
		}
	}

	private void shut_down_server(){
		shut_down sh_server = new shut_down(switch_info);
		Runtime.getRuntime().addShutdownHook(sh_server);
	}
	
	private void monitor_run() {
		current_thread = Thread.currentThread();
		// ============== All static job start from here ==============
		// initial 1 : get all runner
		view_server view_runner = new view_server(cmd_info, switch_info,client_info, task_info, view_info, pool_info);
		tube_server tube_runner = new tube_server(switch_info, client_info, pool_info, task_info);
		data_server data_runner = new data_server(cmd_info, switch_info, client_info, pool_info);
		hall_manager hall_runner = new hall_manager(switch_info, client_info, pool_info, task_info, view_info);		
		// initial 2 : get client current status
		client_status client_sts = new client_status(
				switch_info, 
				client_info, 
				task_info, 
				view_info, 
				pool_info, 
				cmd_info,
				view_runner,
				tube_runner,
				data_runner,
				hall_runner);
		client_sts.set_current_status(client_sts.INITIAL);
		// initial 3 : go to work status
		client_sts.to_work_status();
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
				CLIENT_MANAGER_LOGGER.debug("Client Thread running...");
			}
			// ============== All dynamic job start from here ==============
			// task 1 : return to work status
			if (client_sts.get_current_status().equals("maintain_status")){
				client_sts.to_work_status();
			}
			// task 2 : maintenance mode calculate
			if(start_maintenance_mode()){
				client_sts.to_maintain_status();
			}
			// task 3 :
			if (switch_info.get_client_stop_request().size() > 0){
				client_sts.to_stop_status();
			} 
			// task 4 : 
			try {
				Thread.sleep(base_interval * 1 * 1000);
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
		try {
			Thread.sleep(10*1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}