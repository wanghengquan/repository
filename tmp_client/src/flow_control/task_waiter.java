/*
 * File: cmd_parser.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package flow_control;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.tube_data;
import data_center.public_data;


public class task_waiter extends Thread  {
	// public property
	// protected property
	// private property
	private static final Logger WAITER_LOGGER = LogManager.getLogger(task_waiter.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Integer waiter_index;
	private String waiter_status;
	private Thread client_thread;
	private thread_pool pool_instance;
	private tube_data tube_data_instance;
	private String line_seprator = System.getProperty("line.separator");
	private int interval = public_data.PERF_THREAD_RUN_INTERVAL;	
	// public function
	// protected function
	// private function	
	
	public task_waiter(thread_pool pool_instance, tube_data tube_data_instance, Integer waiter_index){
		this.pool_instance = pool_instance;	
		this.tube_data_instance = tube_data_instance;
		this.waiter_index = waiter_index;
	}
	
	protected String get_waiter_status(){
		return this.waiter_status;
	}
	
	/*
	private get_running_tasks(){
		
	}
	
	private get_task_case(){
		
	}
	
	private prepare_task_case(){
		
	}
	
	private launch_task_case(){
		
	}
	*/
	public void run() {
		try {
			monitor_run();
		} catch (Exception run_exception) {
			run_exception.printStackTrace();
			System.exit(1);
		}
	}

	private void monitor_run() {
		client_thread = Thread.currentThread();
		waiter_status = "work";
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
				WAITER_LOGGER.warn("Waiter_" + String.valueOf(waiter_index) +" waiting...");
			} else {
				WAITER_LOGGER.warn("Waiter_" + String.valueOf(waiter_index) +" running...");
			}
			
			// System.out.println("Thread running...");
			try {
				Thread.sleep(1 * 1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public void soft_stop() {
		stop_request = true;
		waiter_status = "stop";
	}

	public void hard_stop() {
		stop_request = true;
		if (client_thread != null) {
			client_thread.interrupt();
		}
		waiter_status = "stop";
	}

	public void wait_request() {
		waiter_status = "wait";
		wait_request = true;
	}

	public void wake_request() {
		wait_request = false;
		synchronized (this) {
			this.notify();
		}
		waiter_status = "work";
	}
	
	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		//thread_pool pool_instance = new thread_pool(10);
		//tube_data tube_data_instance = new tube_data(null);
		
		task_waiter waiter = new task_waiter(null, null, 0);
		waiter.start();
		try {
			Thread.sleep(10 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
		waiter.wait_request();
		try {
			Thread.sleep(10 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	}
}