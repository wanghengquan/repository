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

import env_monitor.core_update;
import self_update.app_update;

public class work_status extends abstract_status {

	public work_status(client_status client) {
		super(client);
	}

	public void to_stop() {
		client.report_processed_data();
		client.dump_finished_data();
		client.dump_memory_data();
		client.hall_runner.soft_stop();
		client.tube_runner.soft_stop();
		client.data_runner.soft_stop();
		System.out.println(">>>####################");
		System.out.println(">>>Info:Go to stop");
		System.out.println("");		
		client.set_current_status(client.STOP);
		client.final_stop_with_exit_state();
	}

	public void to_work() {
		System.out.println(">>>####################");
		System.out.println(">>>Info:already in work status");
		System.out.println("");			
		client.set_current_status(client.WORK);
	}

	public void to_maintain() {
		// task 1: stop runner
		client.hall_runner.wait_request();
		client.tube_runner.wait_request();
		client.data_runner.wait_request();
		// task 2: implements_self_quiet_update
		implements_self_quiet_update();
		// task 3: implements_core_script_update
		implements_core_script_update();
		System.out.println(">>>####################");
		System.out.println(">>>Info:Go to maintain");
		System.out.println("");		
		client.set_current_status(client.MAINTAIN);
	}
	
	
	//=============================================================
	//methods for locals
	
	private void implements_self_quiet_update(){
		//self update only work in unattended mode
		String unattended_mode = client.client_info.get_client_data().get("Machine").get("unattended");  
		if (!unattended_mode.equalsIgnoreCase("1")){ 
			return;
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
		System.out.println(">>>Client updated...");		
	}
	
	private void implements_core_script_update(){
		core_update my_core = new core_update();
		my_core.update(client.client_info.get_client_data().get("preference").get("work_path"));
	}
	
}