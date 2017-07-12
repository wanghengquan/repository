/*
 * File: cmd_parser.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package top_control;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
//import java.net.URL;
//import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Scanner;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.core.config.ConfigurationSource;
import org.apache.logging.log4j.core.config.Configurator;

import connect_tube.task_data;
import connect_tube.tube_server;
import data_center.client_data;
import data_center.data_server;
import data_center.public_data;
import data_center.switch_data;
import env_monitor.core_update;
import env_monitor.kill_winpop;
import env_monitor.self_check;
import flow_control.hall_manager;
import flow_control.pool_data;
import gui_interface.view_data;
import gui_interface.view_server;
import info_parser.cmd_parser;
import self_update.app_update;
import utility_funcs.file_action;


public class tmp_manager extends Thread  {
	// public property
	// protected property
	// private property
	//private static final Logger TMP_MANAGER_LOGGER = LogManager.getLogger(tmp_manager.class.getName());
	private static Logger TMP_MANAGER_LOGGER = null; 
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread current_thread;
	private client_state initial_state;
	private client_state maintain_state;
	private client_state work_state;
	private client_state tmp_state;
	private String line_separator = System.getProperty("line.separator");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;	
	private switch_data switch_info;
	private client_data client_info;
	private int hall_idle_count = 0;
	// public function
	// protected function
	// private function	
	
	public tmp_manager(switch_data switch_info, client_data client_info){
		this.initial_state = new initial_state(this);
		this.maintain_state = new maintain_state(this);
		this.work_state = new work_state(this);
		this.switch_info = switch_info;
		this.client_info = client_info;
	}
	
	private void implements_self_quiet_update(){
		//self update only work in console mode
		String unattended_mode = client_info.get_client_data().get("Machine").get("unattended");  
		if (unattended_mode.equalsIgnoreCase("1")){ 
			app_update update_obj = new app_update(switch_info, client_info);
			update_obj.smart_update();
		}
	}
	
	private void implements_core_script_update(){
		core_update my_core = new core_update();
		my_core.update(client_info.get_client_data().get("preference").get("work_path"));
	}
	
	private Boolean run_maintenance_mode(){
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
	
	private void client_stop_acknowledge(){
		if(switch_info.get_client_stop_request() < 1){
			return;
		}
		int count = 0;
		while(switch_info.get_house_keep_request() > 0){
			if (count > 20){
				break;
			}
			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			count++;
		}
		System.exit(0);
	}
	
	public void run() {
		try {
			shut_down_server();
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

	private void shut_down_server(){
		shut_down sh_server = new shut_down(switch_info);
		Runtime.getRuntime().addShutdownHook(sh_server);
	}
	
	private void monitor_run() {
		current_thread = Thread.currentThread();
		// ============== All static job start from here ==============
		// initial 1 : check app update
		app_update update_obj = new app_update(switch_info, client_info);
		update_obj.smart_update();
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
				TMP_MANAGER_LOGGER.debug("Client Thread running...");
			}
			// ============== All dynamic job start from here ==============
			// task 1 : run maintenance mode
			if(run_maintenance_mode()){
				TMP_MANAGER_LOGGER.warn("Client Going to maintenance mode...");
				implements_self_quiet_update();
				implements_core_script_update();
			}
			// task 2 :
			client_stop_acknowledge();
			// task 3 : 
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
	
	public static String get_bin_path(){
		String class_path = System.getProperty("java.class.path");
		String path_split = System.getProperty("path.separator");
		String bin_path = class_path.split(path_split)[0].replaceAll("\\\\", "/");
		if (bin_path.endsWith(".jar") || bin_path.endsWith("client") || bin_path.endsWith(".exe")  || bin_path.endsWith(".so")){
			bin_path = bin_path.substring(0, bin_path.lastIndexOf("/") + 1);  
		}
		File file = new File(bin_path);
		bin_path = file.getAbsolutePath().replaceAll("\\\\", "/");
		System.out.println(">>>Info: SW bin path:" + bin_path);
		return bin_path;
	}
	
	private static void initial_log_config(){
		ConfigurationSource source;
		String bin_path = get_bin_path();
		File bin_dobj = new File(bin_path);
		String conf_path = bin_dobj.getParentFile().toString().replaceAll("\\\\", "/") + "/conf/log4j2.xml";
		System.out.println(">>>Info: SW log config path:" + conf_path);
		File file = new File(conf_path);
		try {
			source = new ConfigurationSource(new FileInputStream(file), file);
			Configurator.initialize(null, source);
			TMP_MANAGER_LOGGER = LogManager.getLogger(tmp_manager.class.getName());
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private static Boolean run_self_check(switch_data switch_info){
		self_check my_check = new self_check(switch_info);
		return my_check.do_self_check();
	}
	
	private static void run_system_client_insts_check(
			switch_data switch_info,
			String run_mode){
		int start_insts = switch_info.get_system_client_insts();
		System.out.println(">>>Info: " + String.valueOf(start_insts) + " TMP Client(s) launched already.");
		if (start_insts > 0 && run_mode.equals("cmd")){
			Scanner user_input = new Scanner(System.in);
			int input_count = 0;
			while(true){
				System.out.println(">>>Info: Do you want to launch a new one? y/n");
				String user_choice = user_input.nextLine();
				if (user_choice.equals("y")){
					break;
				}
				if (user_choice.equals("n")){
					System.exit(1);
				}
				input_count++;
				if(input_count > 9){
					System.exit(1);
				}
			}
			user_input.close(); 
			switch_info.increase_system_client_insts();
		}
	}
	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		System.out.println(">>>Info: Current Version:" + public_data.BASE_CURRENTVERSION);
		System.out.println(">>>Info: Build Date:" + public_data.BASE_BUILDDATE);
		System.out.println(">>>Info: Contact Us:" + public_data.BASE_CONTACT_MAIL);
		System.out.println("");
		initial_log_config();
		TMP_MANAGER_LOGGER.debug("debug output test");
		TMP_MANAGER_LOGGER.info("Info output ntest");
		TMP_MANAGER_LOGGER.warn("Warn output test");
		TMP_MANAGER_LOGGER.error("Error output test");
		TMP_MANAGER_LOGGER.fatal("Fatal output test");	
		switch_data switch_info = new switch_data();
		task_data task_info = new task_data();
		client_data client_info = new client_data();
		view_data view_info = new view_data();
		pool_data pool_info = new pool_data(public_data.PERF_POOL_MAXIMUM_SIZE);
		cmd_parser cmd_run = new cmd_parser(args);
		HashMap<String, String> cmd_info = cmd_run.cmdline_parser();
		//run self check
		if(!run_self_check(switch_info)){
			System.out.println(">>>Self check failed.");
			System.exit(1);
		}
		//run launched client instances check
		run_system_client_insts_check(switch_info, cmd_info.get("cmd_gui"));
		//launch GUI
		if(cmd_info.get("cmd_gui").equals("gui")){
			view_server view_runner = new view_server(switch_info, client_info, task_info, view_info, pool_info);
			view_runner.start();
		} else {
			switch_info.set_back_ground_power_up();
		}
		//launch data server
		data_server data_runner = new data_server(cmd_info, switch_info, client_info, pool_info);		
		data_runner.start();
		while(true){
			if (switch_info.get_data_server_power_up()){
				System.out.println(">>>data server power up");
				break;
			}
		}
		//core script prepare
		core_update my_core = new core_update();
		my_core.update(client_info.get_client_data().get("preference").get("work_path"));
		System.out.println(">>>Core updated...");
		//kill pop window launch
		kill_winpop my_kill = new kill_winpop(public_data.TOOLS_KILL_WINPOP);
		my_kill.start();
		//launch tube server
		tube_server tube_runner = new tube_server(switch_info, client_info, pool_info, task_info);
		tube_runner.start();
		while(true){
			if (switch_info.get_tube_server_power_up()){
				System.out.println(">>>tube server power up");
				break;
			}
		}
		// wait for background power up
		while(true){
			if(switch_info.get_back_ground_power_up()){
				System.out.println(">>>back_ground power up");
				break;
			}
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		//launch hall manager
		hall_manager jason = new hall_manager(switch_info, client_info, pool_info, task_info, view_info);
		jason.start();
		//launch tmp manager
		tmp_manager top_run = new tmp_manager(switch_info, client_info);
		top_run.start();
		try {
			Thread.sleep(10*1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}