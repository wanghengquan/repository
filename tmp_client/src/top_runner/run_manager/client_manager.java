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
import env_monitor.machine_sync;
import flow_control.hall_manager;
import flow_control.pool_data;
import gui_interface.view_data;
import gui_interface.view_server;
import top_runner.run_status.client_status;
import top_runner.run_status.maintain_enum;
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
	private int idle_counter = 0;
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
	
	private Boolean start_work_mode(client_status client_sts){
		if(client_sts.get_current_status().equals("work_status")){
			return false; //already in work status
		}
		if(switch_info.get_client_maintain_keeping()){
			return false;
		} else {
			return true;
		}
	}
	
	private maintain_enum start_maintenance_mode(client_status client_sts){
		if(client_sts.get_current_status().equals("maintain_status")){
			return maintain_enum.unknown; //already in maintain_status
		}		
		//maintenance start by any of following:
		//scenario 1: idle for a long time
		//String current_hall_status = switch_info.get_client_hall_status();
		if(pool_info.get_pool_used_threads() == 0){
			idle_counter ++;
		} else {
			idle_counter = 0;
		}
		if (idle_counter > 60){
			//cycle is base_interval * 1 * 60 = 5 minutes
			idle_counter = 0;
			return maintain_enum.idle;
		}

        // dev need update
        if(switch_info.dev_need_update()){
		    while(pool_info.get_pool_used_threads() != 0);
		    return maintain_enum.update;
        }

		//scenario 2: system suspend, cpu, mem, space exceed the maximum usage
		String work_space = client_info.get_client_preference_data().get("work_space");
		String cpu_used = machine_sync.get_cpu_usage();
		String mem_used = machine_sync.get_mem_usage();
		String space_available = machine_sync.get_avail_space(work_space);
		String space_reserve = client_info.get_client_preference_data().get("space_reserve");
		int cpu_used_int = 0;
		try{
			cpu_used_int = Integer.parseInt(cpu_used);
		} catch (Exception e) {
			return maintain_enum.unknown;
		}
		int mem_used_int = 0;
		try{
			mem_used_int = Integer.parseInt(mem_used);
		} catch (Exception e) {
			return maintain_enum.unknown;
		}
		int space_available_int = 0;
		int space_reserve_int = 0;
		try{
			space_available_int = Integer.parseInt(space_available);
			space_reserve_int = Integer.parseInt(space_reserve);
		} catch (Exception e) {
			return maintain_enum.unknown;
		}
		if (cpu_used_int > public_data.RUN_LIMITATION_CPU){
			return maintain_enum.cpu;
		}
		if (mem_used_int > public_data.RUN_LIMITATION_MEM){
			return maintain_enum.mem;
		}		
		if (space_available_int < space_reserve_int){
			return maintain_enum.space;
		}
		return maintain_enum.unknown;

	}
	
	public void run() {
		try {
			shut_down_server();
			monitor_run();
		} catch (Exception run_exception) {
			run_exception.printStackTrace();
			String dump_path = client_info.get_client_preference_data().get("work_path") 
					+ "/" + public_data.WORKSPACE_LOG_DIR + "/core_dump/dump.log";
			file_action.append_file(dump_path, " " + line_separator);
			file_action.append_file(dump_path, "####################" + line_separator);
			file_action.append_file(dump_path, "Date   :" + time_info.get_date_time() + line_separator);
			file_action.append_file(dump_path, "Version:" + public_data.BASE_CURRENTVERSION + line_separator);			
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
		data_server data_runner = new data_server(cmd_info, switch_info, task_info, client_info, pool_info);
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
			if (start_work_mode(client_sts)){
				client_sts.to_work_status();
				client_sts.do_state_things();
			}
			// task 2 : maintenance mode calculate
			maintain_enum maintain_entry = start_maintenance_mode(client_sts);
			if(!maintain_entry.equals(maintain_enum.unknown)){
				switch_info.set_client_maintain_reason(maintain_entry);
				client_sts.to_maintain_status();
				client_sts.do_state_things();
			}
			// task 3 :
			if (switch_info.get_client_stop_request().size() > 0){
				client_sts.to_stop_status();
				client_sts.do_state_things();
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