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

import data_center.public_data;
import env_monitor.core_update;
import env_monitor.kill_winpop;
import self_update.app_update;

class initial_status extends abstract_status {
	
	public initial_status(client_status client) {
		super(client);
	}

	public void to_stop() {
		System.out.println(">>>####################");
		System.out.println(">>>Info:Go to stop");
		System.out.println("");		
		client.set_current_status(client.STOP);
	}

	public void to_work() {
		System.out.println(">>>####################");
		System.out.println(">>>Info: initializing...");
		System.out.println("");
		// task 1: launch GUI if in GUI mode
		launch_main_gui();
		// task 2: get and wait client data ready 
		get_client_data_ready();
		// task 3 : core script update 
		get_core_script_update();		
		// task 4: get daemon process ready
		get_daemon_process_ready();
		// task 5: get tube server ready
		get_tube_server_ready();
		// task 6: client self update
		get_client_self_update();
		// task 7: get hall manager ready
		get_hall_manager_reay();
		System.out.println(">>>Info: working...");
		client.set_current_status(client.WORK);
	}

	public void to_maintain() {
		System.out.println("Go to maintain");
		client.set_current_status(client.MAINTAIN);
	}
	
	//=============================================================
	//methods for locals
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
				System.out.println(">>>data server power up.");
				break;
			}
		}		
	}
	
	//core script update
	private void get_core_script_update(){
		core_update my_core = new core_update();
		my_core.update(client.client_info.get_client_data().get("preference").get("work_path"));
		System.out.println(">>>Core updated.");
	}	
	//self update
	private void get_client_self_update(){ 
		//wait until main GUI start and then start update self
		while(client.cmd_info.get("cmd_gui").equals("gui")){
			if (client.switch_info.get_main_gui_power_up()){
				break;
			}
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}		
		app_update update_obj = new app_update(client.client_info, client.switch_info);
		update_obj.smart_update();
		while(client.switch_info.get_client_console_updating()){
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		System.out.println(">>>Client updated.");
	}
	
	//get daemon process ready
	private void get_daemon_process_ready(){
		kill_winpop my_kill = new kill_winpop(public_data.TOOLS_KILL_WINPOP);
		my_kill.start();
	}
	
	//get tube server start and wait it ready
	private void get_tube_server_ready(){
		client.tube_runner.start();
		while(true){
			if (client.switch_info.get_tube_server_power_up()){
				System.out.println(">>>tube server power up.");
				break;
			}
		}		
	}
	
	//get_hall_manager_reay
	private void get_hall_manager_reay(){
		client.hall_runner.start();
	}
	
}

