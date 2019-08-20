/*
 * File: client_state.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package top_runner.run_status;

import java.util.HashMap;
import java.util.Timer;


import cmd_interface.console_server;
import connect_link.link_server;
import data_center.public_data;
import env_monitor.core_update;
import env_monitor.kill_winpop;
import self_update.app_update;
import env_monitor.dev_checker;
import env_monitor.env_checker;

class initial_status extends abstract_status {
	
	public initial_status(client_status client) {
		super(client);
	}

	public void to_stop() {
		System.out.println(">>>####################");
		client.STATUS_LOGGER.warn("Go to stop");
		client.set_current_status(client.STOP);		
	}

	public void to_work() {
		System.out.println(">>>####################");
		client.STATUS_LOGGER.warn("Initializing...");
		// task 0: launch GUI if in GUI mode
		launch_link_services();
		if (client.cmd_info.get("interactive").equals("1")){
			console_server my_console = new console_server(client.switch_info);
			my_console.start();
			return;
		}
		// task 1: launch GUI if in GUI mode
		launch_main_gui();
		// task 2: get and wait client data ready 
		get_client_data_ready();
		// task 3: get daemon process ready
		get_daemon_process_ready();
		// task 4: get tube server ready
		get_tube_server_ready();
		// task 5: auto restart warning message print
		release_auto_restart_msg();		
		// task 6 : core script update 
		get_core_script_update();
		// task 7: client self update
		get_client_self_update();
		// task 8: client run mode recognize
		client_local_console_run_recognize();		
		// task 9: get hall manager ready
		get_hall_manager_ready();
		//waiting for all waiter ready
		if (client.client_info.get_client_machine_data().get("debug").equals("1")){
			System.out.println(">>>Info: Client run in Debug Mode.");
		}
		System.out.println(">>>Info: Working...");
		try {
			Thread.sleep(1000 * 1 * public_data.PERF_THREAD_BASE_INTERVAL);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//client initial updated, dump data needed
		client.switch_info.set_client_updated();
		client.set_current_status(client.WORK);
	}

	public void to_maintain() {
		client.STATUS_LOGGER.warn("Go to maintain");
		client.set_current_status(client.MAINTAIN);
	}
	
	public void do_state_things(){
		//client.STATUS_LOGGER.info("Run initial state things");
	}
	
	//=============================================================
	//methods for locals
	private void launch_link_services(){
		link_server task_link = new link_server(client.switch_info, client.client_info, client.task_info, public_data.SOCKET_DEF_TASK_PORT);
		link_server cmd_link = new link_server(client.switch_info, client.client_info, client.task_info, public_data.SOCKET_DEF_CMD_PORT);
		task_link.start();
		cmd_link.start();
	}
	
	private void launch_main_gui(){
		if(client.cmd_info.get("cmd_gui").equals("gui")){
			client.view_runner.start();
		} //don't wait until GUI ready
	}
	
	//data prepare
	private void get_client_data_ready(){
		//launch data server
		client.data_runner.start();
		while(true){
			if (client.switch_info.get_data_server_power_up()){
				System.out.println(">>>Info: Data server power up.");
				break;
			}
		}		
	}
	
	//core script update
	private void get_core_script_update(){
		core_update my_core = new core_update(client.client_info);
		my_core.update();
		System.out.println(">>>Info: Core Script updated.");
	}	
	//self update
	private void get_client_self_update(){ 
		//wait until main GUI start and then start update self
		while(client.cmd_info.get("cmd_gui").equals("gui")){
			if (client.switch_info.get_main_gui_power_up()){
				break;
			}
			try {
				Thread.sleep(5000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}		
		app_update update_obj = new app_update(client.client_info, client.switch_info);
		update_obj.smart_update();
		while(client.switch_info.get_client_console_updating()){
			if(update_obj.update_skipped){
				client.switch_info.set_client_console_updating(false);
				break;
			}
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		System.out.println(">>>Info: TMP client updated.");
	}
	
	//get daemon process ready
	private void get_daemon_process_ready(){
		Timer misc_timer = new Timer("misc_timer");
		//task 1: kill process
		String os = System.getProperty("os.name").toLowerCase();
		if (os.contains("windows")) {
			misc_timer.scheduleAtFixedRate(new kill_winpop(this.client.switch_info), 1000*0, 1000*10);
		}
		//task 2: dev check
		misc_timer.scheduleAtFixedRate(new dev_checker(this.client.switch_info, this.client.client_info), 1000*2, 1000*10);
		//task 3: environ check
		misc_timer.scheduleAtFixedRate(new env_checker(this.client.switch_info, this.client.client_info), 1000*4, 1000*10);
	}
	
	//get tube server start and wait it ready
	private void get_tube_server_ready(){
		client.tube_runner.start();
		while(true){
			if (client.switch_info.get_tube_server_power_up()){
				System.out.println(">>>Info: Tube server power up.");
				break;
			}
		}		
	}
	
	//print auto restart message
	private void release_auto_restart_msg(){
		String unattend_mode = client.client_info.get_client_machine_data().get("unattended");
		String auto_restart = client.client_info.get_client_preference_data().get("auto_restart");
		if (unattend_mode.equals("1") && auto_restart.equals("1")){
			System.out.println(">>>Warn: Auto Restart sensed, will restart Client Machine every Sunday,12:00");
		}
	}	
	
	//client_local_console_run_recognize
	private void client_local_console_run_recognize(){
		HashMap<String, String> preference_data = new HashMap<String, String>();
		preference_data.putAll(client.client_info.get_client_preference_data());
		String link_mode = new String("");
		String cmd_gui = new String("");
		link_mode = preference_data.getOrDefault("link_mode", public_data.DEF_CLIENT_LINK_MODE);
		cmd_gui = preference_data.getOrDefault("cmd_gui", "");
		if(link_mode.equalsIgnoreCase("local") && cmd_gui.equalsIgnoreCase("cmd")){
			client.switch_info.set_local_console_mode(true);
		} else {
			client.switch_info.set_local_console_mode(false);
		}
	}
	
	//get_hall_manager_reay
	private void get_hall_manager_ready(){
		client.hall_runner.start();
		System.out.println(">>>Info: Hall manager power up.");
	}
}

