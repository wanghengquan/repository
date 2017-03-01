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
import data_center.client_data;
import data_center.public_data;

public class task_waiter extends Thread {
	// public property
	// protected property
	// private property
	private static final Logger WAITER_LOGGER = LogManager.getLogger(task_waiter.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private int waiter_index;
	private String waiter_status;
	private Thread waiter_thread;
	private thread_pool pool_data;
	private tube_data task_data;
	private client_data terminal_data;
	private String line_seprator = System.getProperty("line.separator");
	private int interval = public_data.PERF_THREAD_RUN_INTERVAL;
	// public function
	// protected function
	// private function

	public task_waiter(thread_pool pool_data, tube_data task_data, client_data terminal_data, int waiter_index) {
		this.pool_data = pool_data;
		this.task_data = task_data;
		this.terminal_data = terminal_data;
		this.waiter_index = waiter_index;
	}

	protected String get_waiter_status() {
		return this.waiter_status;
	}

	protected Thread get_waiter_thread() {
		return waiter_thread;
	}

	private ArrayList<String> get_running_tasks() {

	}

	/*
	 * private get_task_case(){
	 * 
	 * }
	 * 
	 * private prepare_task_case(){
	 * 
	 * }
	 * 
	 * private launch_task_case(){
	 * 
	 * }
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
		waiter_thread = Thread.currentThread();
		while (!stop_request) {
			if (wait_request) {
				WAITER_LOGGER.warn("Waiter_" + String.valueOf(waiter_index) + " waiting...");
				try {
					synchronized (this) {
						this.wait();
					}
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} else {
				this.waiter_status = "work";
				WAITER_LOGGER.warn("Waiter_" + String.valueOf(waiter_index) + " running...");
			}
			try {
				Thread.sleep(interval * 1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public void soft_stop() {
		stop_request = true;
		this.waiter_status = "stop";
	}

	public void hard_stop() {
		stop_request = true;
		if (waiter_thread != null) {
			waiter_thread.interrupt();
		}
		this.waiter_status = "stop";
	}

	public void wait_request() {
		this.waiter_status = "wait";
		wait_request = true;
	}

	public void wake_request() {
		this.waiter_status = "work";
		wait_request = false;
		synchronized (this) {
			this.notify();
		}
	}

	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		// thread_pool pool_instance = new thread_pool(10);
		// tube_data tube_data_instance = new tube_data(null);

		task_waiter waiter = new task_waiter(null, null, 0);
		waiter.start();
		try {
			Thread.sleep(5 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		waiter.wait_request();
		System.out.println(waiter.get_waiter_status());
		try {
			Thread.sleep(5 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		waiter.wake_request();
		System.out.println(waiter.get_waiter_status());
		try {
			Thread.sleep(5 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(waiter.get_waiter_status());
	}
}