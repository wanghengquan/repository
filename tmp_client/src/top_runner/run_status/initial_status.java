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

import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.core.config.Configurator;

import cmd_interface.console_server;
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
		//step 1. soft stop requested and still have task running
		if(client.switch_info.get_client_soft_stop_request() && (client.pool_info.get_pool_used_threads() > 0)){
			client.STATUS_LOGGER.warn("Client stop requested, but still have tasks to be run...");
			return;
		}
		//step 2. to stop actions		
		client.STATUS_LOGGER.debug(">>>####################");
		client.STATUS_LOGGER.info("Go to stop");
		client.set_current_status(client.STOP);		
	}

	public void to_work() {
		client.STATUS_LOGGER.debug(">>>####################");
		client.STATUS_LOGGER.info("Initializing...");
		// task 1: launch link console
		launch_link_console();
		// task 2: launch GUI if in GUI mode
		launch_main_gui();
		// task 3: get and wait client data ready 
		get_client_data_ready();
		// task 4: client self update
		get_client_self_update();
		// task 5 : core script update 
		get_core_script_update();		
		// task 6: get daemon process ready
		get_daemon_process_ready();
		// task 7: auto restart warning message print
		release_auto_restart_msg();		
		// task 8: launch link services
		launch_link_services();
		// task 9: client run mode recognize
		local_console_run_recognize();
		// task 10: get tube server ready
		get_tube_server_ready();		
		// task 11: get hall manager ready
		get_hall_manager_ready();
		//waiting for all waiter ready
		if (client.client_info.get_client_machine_data().get("debug").equals("1")){
			client.STATUS_LOGGER.debug("Client run in Debug Mode.");
		}
		client.STATUS_LOGGER.info("Working...");
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
		client.STATUS_LOGGER.debug(">>>####################");
		client.STATUS_LOGGER.info("Go to maintain");
		client.set_current_status(client.MAINTAIN);
	}
	
	public void do_state_things(){
		//client.STATUS_LOGGER.info("Run initial state things");
	}
	
	//=============================================================
	//methods for locals
	private void launch_link_services(){
		client.cmd_server.start();
		client.task_server.start();
		client.STATUS_LOGGER.info("Socket servers power up.");
	}
	
	private void launch_link_console(){
		if (client.cmd_info.get("interactive").equals("1")){
			mute_log4j_outputs();
			console_server my_console = new console_server(client.switch_info);
			my_console.start();
		}		
	}
	
	private void mute_log4j_outputs(){
		Configurator.setLevel(LogManager.getRootLogger().getName(), Level.ERROR);
		Configurator.setLevel("top_runner.top_launcher", Level.OFF);
		Configurator.setLevel("top_runner.run_status.client_status", Level.OFF);
		Configurator.setLevel("flow_control.hall_manager", Level.OFF);
		Configurator.setLevel("flow_control.result_waiter", Level.OFF);
		Configurator.setLevel("flow_control.task_waiter", Level.OFF);
		Configurator.setLevel("flow_control.hall_manager", Level.OFF);
		Configurator.setLevel("connect_tube.tube_server", Level.OFF);
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
				client.STATUS_LOGGER.info("Data server power up.");
				break;
			}
		}		
	}
	
	//core script update
	private void get_core_script_update(){
		core_update my_core = new core_update(client.client_info);
		my_core.update();
		client.STATUS_LOGGER.info("Core Script updated.");
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
		if (update_obj.update_skipped) {
			client.STATUS_LOGGER.info("TMP Client self-update skipped...");
		} else {
			client.STATUS_LOGGER.info("TMP Client self-update launched...");
			//no data for dump at the initial state
			//export_data.export_disk_processed_queue_report(client.task_info, client.client_info);
			//export_data.export_disk_finished_queue_data(client.task_info, client.client_info);
			//export_data.export_disk_memory_queue_data(client.task_info, client.client_info);
		}		
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
		client.STATUS_LOGGER.info("TMP client updated.");
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
				client.STATUS_LOGGER.info("Tube server power up.");
				break;
			}
		}		
	}
	
	//print auto restart message
	private void release_auto_restart_msg(){
		String unattend_mode = client.client_info.get_client_machine_data().get("unattended");
		String auto_restart = client.client_info.get_client_preference_data().get("auto_restart");
		if (unattend_mode.equals("1") && auto_restart.equals("1")){
			client.STATUS_LOGGER.warn("Auto Restart sensed, will restart Client Machine every Sunday,12:00");
		}
	}	
	
	//client_local_console_run_recognize
	private void local_console_run_recognize(){
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
		client.STATUS_LOGGER.info("Hall manager power up.");
	}
}

