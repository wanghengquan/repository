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
import java.util.Timer;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import cmd_interface.console_server;
import connect_link.link_server;
import connect_tube.task_data;
import connect_tube.tube_server;
import data_center.client_data;
import data_center.data_server;
import data_center.public_data;
import data_center.switch_data;
import env_monitor.machine_sync;
import flow_control.post_data;
import flow_control.hall_manager;
import flow_control.pool_data;
import gui_interface.view_data;
import gui_interface.view_server;
import top_runner.run_status.client_status;
import top_runner.run_status.exit_enum;
import top_runner.run_status.maintain_enum;
import top_runner.run_status.state_enum;
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
	//private String line_separator = System.getProperty("line.separator");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;	
	private switch_data switch_info;
	private client_data client_info;
	private task_data task_info;
	private view_data view_info;
	private pool_data pool_info;
	private HashMap<String, String> cmd_info;
	private post_data post_info;
	private int idle_counter = 0;	
	// public function
	// protected function
	// private function	
	
	public client_manager(
			HashMap<String, String> cmd_info,
			switch_data switch_info, 
			client_data client_info,
			task_data task_info,
			view_data view_info,
			pool_data pool_info,
			post_data post_info){
		this.switch_info = switch_info;
		this.client_info = client_info;
		this.task_info = task_info;
		this.view_info = view_info;
		this.pool_info = pool_info;
		this.cmd_info = cmd_info;
		this.post_info = post_info;
	}
	
	private Boolean get_system_idle(){
		Boolean status = Boolean.valueOf(false);
		if(pool_info.get_pool_used_threads() == 0){
			idle_counter ++;
		} else {
			idle_counter = 0;
		}
		if (idle_counter > 60){
			//cycle is base_interval * 1 * 60 = 5 minutes
			idle_counter = 0;
			status = true;
		}
		return status;
	}
	
	private Boolean get_update_available(){
		Boolean status = Boolean.valueOf(false);
        if(switch_info.get_core_script_update_request() && pool_info.get_pool_used_threads() == 0){
		    status = true;
        }
		return status;
	}
	
	private Boolean get_environ_issue(){
		Boolean status = Boolean.valueOf(false);
		if(switch_info.get_client_environ_issue()){
			status = true;
		}
		return status;
	}
	
	private Boolean get_cpu_overload(){
		Boolean status = Boolean.valueOf(false);
		String cpu_used = client_info.get_client_system_data().getOrDefault("cpu", "NA");
		int cpu_used_int = 0;
		try{
			cpu_used_int = Integer.parseInt(cpu_used);
		} catch (Exception e) {
			return false;
		}
		if (cpu_used_int > public_data.RUN_LIMITATION_CPU){
			status = true;
		}
		return status;
	}
	
	private Boolean get_mem_overload(){
		Boolean status = Boolean.valueOf(false);
		String mem_used = client_info.get_client_system_data().getOrDefault("mem", "NA");
		int mem_used_int = 0;
		try{
			mem_used_int = Integer.parseInt(mem_used);
		} catch (Exception e) {
			return false;
		}
		if (mem_used_int > public_data.RUN_LIMITATION_MEM){
			status = true;
		}
		return status;
	}
	
	private Boolean get_space_overload(){
		Boolean status = Boolean.valueOf(false);
		String work_space = client_info.get_client_preference_data().get("work_space");
		String space_available = machine_sync.get_avail_space(work_space);
		String space_reserve = client_info.get_client_preference_data().get("space_reserve");
		int space_available_int = 0;
		int space_reserve_int = 0;
		try{
			space_available_int = Integer.parseInt(space_available);
			space_reserve_int = Integer.parseInt(space_reserve);
		} catch (Exception e) {
			return false;
		}	
		if (space_available_int < space_reserve_int){
			status = true;
		}
		return status;
	}
	
	private Boolean get_work_space_updated(){
		Boolean status = Boolean.valueOf(false);
		if (switch_info.get_work_space_update_request() && pool_info.get_pool_used_threads() == 0){
			status = true;
		}
		return status;
	}
	
	private void impl_current_info_update(){
		switch_info.clear_client_maintain_list();
		if (get_system_idle()){
			switch_info.update_client_maintain_list(maintain_enum.idle);
		}
		if (get_update_available()){
			switch_info.update_client_maintain_list(maintain_enum.update);
		}
		if (get_environ_issue()){
			switch_info.update_client_maintain_list(maintain_enum.environ);
		}		
		if (get_cpu_overload()){
			switch_info.update_client_maintain_list(maintain_enum.cpu);
		}
		if (get_mem_overload()){
			switch_info.update_client_maintain_list(maintain_enum.mem);
		}
		if (get_space_overload()){
			switch_info.update_client_maintain_list(maintain_enum.space);
		}
		if (get_work_space_updated()){
			switch_info.update_client_maintain_list(maintain_enum.workspace);
		}
	}
	
	private Boolean start_work_mode(client_status client_sts){
		if(client_sts.get_current_status().equals(state_enum.work)){
			return false; //already in work status
		}		
		if(!switch_info.get_client_maintain_list().isEmpty()){
			return false;
		}
		if(!switch_info.get_client_stop_list().isEmpty()){
			return false;
		}		
		return true;
	}
	
	private Boolean start_maintenance_mode(client_status client_sts){
		if(client_sts.get_current_status().equals(state_enum.maintain)){
			return false; //already in maintain_status
		}
		if(switch_info.get_client_maintain_list().isEmpty()){
			return false;
		}
		if(!switch_info.get_client_stop_list().isEmpty()){
			return false;
		}		
		return true;
	}
	
	private Boolean start_stop_mode(client_status client_sts){
		if(client_sts.get_current_status().equals(state_enum.stop)){
			return false; //already in stop_status
		}
		if(switch_info.get_client_stop_list().isEmpty()){
			return false;
		}
		return true;
	}	
	
	private String get_dump_string(Exception dump_exception){
		StringBuilder message = new StringBuilder("");
		String line_separator = System.getProperty("line.separator");
		if (dump_exception == null){
			return message.toString();
		}
		message.append("####################" + line_separator);
		message.append("Date   :" + time_info.get_date_time() + line_separator);
		message.append("Version:" + public_data.BASE_CURRENTVERSION + line_separator);
		message.append(dump_exception.toString() + line_separator);
		for(Object item: dump_exception.getStackTrace()){
			message.append("    at " + item.toString() + line_separator);
		}
		return message.toString();
	}
	
	public void run() {
		try {
			shut_down_server();
			monitor_run();
		} catch (Exception run_exception) {
			run_exception.printStackTrace();
			String dump_path = client_info.get_client_preference_data().get("work_space") 
					+ "/" + public_data.WORKSPACE_LOG_DIR + "/core_dump/dump.log";
			String dump_message = get_dump_string(run_exception);
			file_action.append_file(dump_path, dump_message);
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
		view_server view_runner = new view_server(cmd_info, switch_info,client_info, task_info, view_info, pool_info, post_info);
		tube_server tube_runner = new tube_server(cmd_info, switch_info, client_info, pool_info, task_info);
		data_server data_runner = new data_server(cmd_info, switch_info, client_info);
		hall_manager hall_runner = new hall_manager(switch_info, client_info, pool_info, task_info, view_info, post_info);
		link_server link_runner = new link_server(switch_info, client_info, view_info, task_info, pool_info, post_info);
		console_server console_runner = new console_server(switch_info);
		Timer misc_timer = new Timer("misc_timer");
		switch_info.update_threads_object_map(thread_enum.view_runner, view_runner);
		switch_info.update_threads_object_map(thread_enum.tube_runner, tube_runner);
		switch_info.update_threads_object_map(thread_enum.data_runner, data_runner);
		switch_info.update_threads_object_map(thread_enum.hall_runner, hall_runner);
		switch_info.update_threads_object_map(thread_enum.link_runner, link_runner);
		switch_info.update_threads_object_map(thread_enum.console_runner, console_runner);
		// initial 2 : get client current status
		client_status client_sts = new client_status(
				cmd_info,
				switch_info, 
				client_info, 
				task_info, 
				view_info, 
				pool_info, 
				post_info,
				view_runner,
				tube_runner,
				data_runner,
				hall_runner,
				link_runner,
				console_runner,
				misc_timer);
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
				switch_info.update_threads_active_map(thread_enum.top_runner, time_info.get_date_time());
			}
			// ============== All dynamic job start from here ==============
			// task 0 : current misc info update
			impl_current_info_update();
			// task 1 : start work status
			if (start_work_mode(client_sts)){
				client_sts.to_work_status();
			}
			// task 2 : maintenance mode calculate
			if(start_maintenance_mode(client_sts)){
				client_sts.to_maintain_status();
			}
			// task 3 :
			if (start_stop_mode(client_sts)){
				client_sts.to_stop_status();
			} 
			// task 4 :
			client_sts.do_state_things();
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