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

public class work_status extends abstract_status {

	public work_status(client_status client) {
		super(client);
	}

	public void to_stop() {
		client.hall_runner.soft_stop();
		client.tube_runner.soft_stop();
		client.data_runner.soft_stop();
		System.out.println(">>>####################");
		client.STATUS_LOGGER.warn("Go to stop");	
		client.set_current_status(client.STOP);
	}

	public void to_work() {
		System.out.println(">>>####################");
		client.STATUS_LOGGER.warn("Go to work");		
		client.set_current_status(client.WORK);
	}

	public void to_maintain() {
		// task 1: stop runner
		client.hall_runner.wait_request();
		client.tube_runner.wait_request();
		client.data_runner.wait_request();
		try {
			Thread.sleep(public_data.PERF_THREAD_BASE_INTERVAL * 1000 * 2);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
		System.out.println(">>>####################");
		client.STATUS_LOGGER.warn("Go to maintain");		
		client.set_current_status(client.MAINTAIN);
	}
	
	public void do_state_things(){
		client.STATUS_LOGGER.info("Run state things");
	}	
	
	//=============================================================
	//methods for locals
	
}