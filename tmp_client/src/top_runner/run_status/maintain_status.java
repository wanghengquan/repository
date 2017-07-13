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

import flow_control.export_data;

public class maintain_status extends abstract_status {
	
	public maintain_status(client_status client) {
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
		client.switch_info.decrease_system_client_insts();
		client.set_current_status(client.STOP);
		System.exit(0);
	}

	public void to_work() {
		System.out.println(">>>####################");
		System.out.println(">>>Info:Go to work");
		System.out.println("");	
		client.data_runner.start();
		client.tube_runner.start();
		client.hall_runner.start();
		client.set_current_status(client.WORK);
	}

	public void to_maintain() {
		System.out.println(">>>####################");
		System.out.println(">>>Info:already in maintain");
		System.out.println("");
		client.set_current_status(client.MAINTAIN);
	}
	
	//=============================================================
	//methods for locals
	
}
