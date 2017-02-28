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

import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.tube_data;
import data_center.exchange_data;
import data_center.public_data;


public class hall_manager extends Thread  {
	// public property
	// protected property
	// private property
	private static final Logger HALL_LOGGER = LogManager.getLogger(hall_manager.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread client_thread;
	private exchange_data share_data;
	private tube_data task_data;
	private String line_seprator = System.getProperty("line.separator");
	private int interval = public_data.PERF_THREAD_RUN_INTERVAL;	
	// public function
	// protected function
	// private function	
	
	private hall_manager(exchange_data share_data, tube_data task_data) {
		this.share_data = share_data;
		this.task_data = task_data;
	}
	
	private HashMap<String, task_waiter> get_waiter_ready(thread_pool pool_data){
		HashMap<String, task_waiter> waiters = new HashMap<String, task_waiter>();
		int max_sw_thread = public_data.PERF_SW_MAXIMUM_THREAD;
		for(int i = 0; i < max_sw_thread; i++){
			task_waiter waiter = new task_waiter(pool_data, task_data, i);
			String waiter_index = "waiter_" + String.valueOf(i);
			waiters.put(waiter_index, waiter);
			waiter.start();
			waiter.wait_request();
			System.out.println(waiter.get_waiter_status());
		}
		return waiters;
	}
	
	private void start_right_waiter(HashMap<String, task_waiter> waiters){
		String start_number = public_data.DEF_MAX_PROCS;
		Integer right_number = Integer.valueOf(start_number);
		Set<String> waiter_set = waiters.keySet();
		Iterator<String> waiter_it = waiter_set.iterator();
		while(waiter_it.hasNext()){
			String waiter_index = waiter_it.next();
			int waiter_id = Integer.valueOf(waiter_index.replace("waiter_", ""));
			task_waiter waiter = waiters.get(waiter_index);
			String waiter_status = waiter.get_waiter_status();
			System.out.println(waiter_index + ":" +waiter_status);
			if (waiter_id < right_number){
				if (waiter_status.equals("wait")){
					waiter.wake_request();
				}
			} else {
				if (waiter_status.equals("work")){
					waiter.wait_request();
				}
			}
		}
	}
	
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
		thread_pool pool_instance = new thread_pool(public_data.PERF_SW_MAXIMUM_THREAD);
		HashMap<String, task_waiter> waiters = get_waiter_ready(pool_instance);
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
			} else {
				HALL_LOGGER.warn("hall manager Thread running...");
			}
			start_right_waiter(waiters);
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
	}

	public void hard_stop() {
		stop_request = true;
		if (client_thread != null) {
			client_thread.interrupt();
		}
	}

	public void wait_request() {
		wait_request = true;
	}

	public void wake_request() {
		wait_request = false;
		synchronized (this) {
			this.notify();
		}
	}
	
	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		exchange_data share_data = new exchange_data();
		tube_data tube_data_instance = new tube_data(share_data);
		hall_manager jason = new hall_manager(share_data, tube_data_instance);
		jason.start();
	}
}