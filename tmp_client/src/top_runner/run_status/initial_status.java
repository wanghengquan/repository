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
		System.out.println(">>>Info:Go to work status");
		System.out.println("");
		// task 1: launch gui if in GUI mode
		launch_main_gui();
		// task 2: get and wait client data ready 
		get_client_data_ready();
		// task 3: core script update
		get_client_self_update();
		// task 4: core script update
		get_core_script_update();
		// task 5: get daemon process ready
		get_daemon_process_ready();
		// task 6: get tube server ready
		get_tube_server_ready();
		// task 7: wait for all background ready
		wait_background_ready();
		// task 8: get hall manager ready
		get_hall_manager_reay();
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
		} else {
			client.switch_info.set_back_ground_power_up();
		}		
	}
	
	//data prepare
	private void get_client_data_ready(){
		//launch data server
		client.data_runner.start();
		while(true){
			if (client.switch_info.get_data_server_power_up()){
				System.out.println(">>>data server power up");
				break;
			}
		}		
	}
	
	//core script update
	private void get_client_self_update(){ 
		app_update update_obj = new app_update(client.switch_info, client.client_info);
		update_obj.smart_update();
		System.out.println(">>>Client updated...");
	}
	
	//core script update
	private void get_core_script_update(){
		core_update my_core = new core_update();
		my_core.update(client.client_info.get_client_data().get("preference").get("work_path"));
		System.out.println(">>>Core updated...");
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
				System.out.println(">>>tube server power up");
				break;
			}
		}		
	}
	
	//wait_backgroud_ready
	private void wait_background_ready(){
		while(true){
			if(client.switch_info.get_back_ground_power_up()){
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
	}
	
	//get_hall_manager_reay
	private void get_hall_manager_reay(){
		client.hall_runner.start();
	}
	
}

