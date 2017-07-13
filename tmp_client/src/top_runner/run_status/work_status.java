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
import flow_control.export_data;
import self_update.app_update;

public class work_status extends abstract_status {

	public work_status(client_status client) {
		super(client);
	}

	public void to_stop() {
		System.out.println(">>>####################");
		System.out.println(">>>Info:Go to stop");
		System.out.println("");	
		export_data.dump_disk_received_admin_data(client.client_info, client.task_info);
		export_data.dump_disk_processed_admin_data(client.client_info, client.task_info);
		export_data.dump_disk_received_task_data(client.client_info, client.task_info);
		export_data.dump_disk_processed_task_data(client.client_info, client.task_info);
		client.hall_runner.soft_stop();
		client.tube_runner.soft_stop();
		client.data_runner.soft_stop();
		client.switch_info.decrease_system_client_insts();
		client.set_current_status(client.STOP);
		System.exit(0);
	}

	public void to_work() {
		System.out.println(">>>####################");
		System.out.println(">>>Info:already in work status");
		System.out.println("");			
		client.set_current_status(client.WORK);
	}

	public void to_maintain() {
		System.out.println(">>>####################");
		System.out.println(">>>Info:Go to maintain");
		System.out.println("");
		// task 1: stop runner
		client.hall_runner.soft_stop();
		client.tube_runner.soft_stop();
		client.data_runner.soft_stop();
		// task 2: implements_self_quiet_update
		implements_self_quiet_update();
		// task 3: implements_core_script_update
		implements_core_script_update();
		client.set_current_status(client.MAINTAIN);
	}
	
	
	//=============================================================
	//methods for locals
	
	private void implements_self_quiet_update(){
		//self update only work in console mode
		String unattended_mode = client.client_info.get_client_data().get("Machine").get("unattended");  
		if (unattended_mode.equalsIgnoreCase("1")){ 
			app_update update_obj = new app_update(client.switch_info, client.client_info);
			update_obj.smart_update();
		}
	}
	
	private void implements_core_script_update(){
		core_update my_core = new core_update();
		my_core.update(client.client_info.get_client_data().get("preference").get("work_path"));
	}
	
}