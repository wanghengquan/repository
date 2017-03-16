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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.tube_server;
import connect_tube.task_data;
import data_center.client_data;
import data_center.data_server;
import data_center.switch_data;
import gui_interface.view_data;
import gui_interface.view_server;
import data_center.public_data;

public class hall_manager extends Thread {
	// public property
	// protected property
	// private property
	private static final Logger HALL_MANAGER_LOGGER = LogManager.getLogger(hall_manager.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread client_thread;
	private switch_data switch_info;
	private task_data task_info;
	private client_data client_info;
	private pool_data pool_info;
	private view_data view_info;
	// private String line_seprator = System.getProperty("line.separator");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;
	// sub threads need to be launched
	HashMap<String, task_waiter> waiters_task;
	result_waiter waiter_result;
	// public function
	// protected function
	// private function

	private hall_manager(switch_data switch_info, client_data client_info, pool_data pool_info, task_data task_info, view_data view_info) {
		this.task_info = task_info;
		this.client_info = client_info;
		this.switch_info = switch_info;
		this.pool_info = pool_info;
		this.view_info = view_info;
	}

	private HashMap<String, task_waiter> get_waiter_ready(pool_data pool_info) {
		HashMap<String, task_waiter> waiters = new HashMap<String, task_waiter>();
		int max_sw_thread = public_data.PERF_POOL_MAXIMUM_THREAD;
		for (int i = 0; i < max_sw_thread; i++) {
			task_waiter waiter = new task_waiter(i,switch_info, client_info, pool_info, task_info);
			String waiter_index = "waiter_" + String.valueOf(i);
			waiters.put(waiter_index, waiter);
			waiter.start();
			waiter.wait_request();
		}
		return waiters;
	}

	private void start_right_task_waiter(HashMap<String, task_waiter> waiters, int current_number) {
		int right_number = current_number;
		Set<String> waiter_set = waiters.keySet();
		Iterator<String> waiter_it = waiter_set.iterator();
		while (waiter_it.hasNext()) {
			String waiter_index = waiter_it.next();
			int waiter_id = Integer.valueOf(waiter_index.replace("waiter_", ""));
			task_waiter waiter = waiters.get(waiter_index);
			String waiter_status = waiter.get_waiter_status();
			HALL_MANAGER_LOGGER.debug(waiter_index + ":" + waiter_status);
			if (waiter_id < right_number) {
				if (waiter_status.equals("wait")) {
					waiter.wake_request();
				}
			} else {
				if (waiter_status.equals("work")) {
					waiter.wait_request();
				}
			}
		}
	}

	private result_waiter start_right_result_waiter(pool_data pool_info) {
		result_waiter waiter = new result_waiter(switch_info, client_info, pool_info, task_info, view_info);
		waiter.start();
		return waiter;
	}

	@SuppressWarnings("unused")
	private void update_reject_queue_list() {
		Set<String> remote_admin_queue_set = task_info.get_remote_admin_queue_receive_treemap().keySet();
		Iterator<String> remote_it = remote_admin_queue_set.iterator();
		Set<String> local_admin_queue_set = task_info.get_local_admin_queue_receive_treemap().keySet();
		Iterator<String> local_it = local_admin_queue_set.iterator();
		Set<String> captured_admin_queue_set = tube_server.captured_admin_queues.keySet();
		ArrayList<String> rejected_admin_queue_list = new ArrayList<String>();
		while (remote_it.hasNext()) {
			String queue_name = remote_it.next();
			if (!captured_admin_queue_set.contains(queue_name)) {
				rejected_admin_queue_list.add(queue_name);
			}
		}
		while (local_it.hasNext()) {
			String queue_name = local_it.next();
			if (!captured_admin_queue_set.contains(queue_name)) {
				rejected_admin_queue_list.add(queue_name);
			}
		}
		task_info.set_rejected_admin_queue_list(rejected_admin_queue_list);
	}

	private void update_captured_queue_list() {
		Set<String> captured_admin_queue_set = tube_server.captured_admin_queues.keySet();
		Iterator<String> captured_it = captured_admin_queue_set.iterator();
		ArrayList<String> captured_admin_queue_list = new ArrayList<String>();
		while (captured_it.hasNext()) {
			String queue_name = captured_it.next();
			captured_admin_queue_list.add(queue_name);
		}
		task_info.set_captured_admin_queue_list(captured_admin_queue_list);
	}

	private void update_processing_queue_list() {
		Set<String> captured_admin_queue_set = tube_server.captured_admin_queues.keySet();
		Iterator<String> captured_it = captured_admin_queue_set.iterator();
		ArrayList<String> processing_admin_queue_list = new ArrayList<String>();
		while (captured_it.hasNext()) {
			String queue_name = captured_it.next();
			String queue_status = tube_server.captured_admin_queues.get(queue_name).get("Status").get("admin_status");
			if (queue_status.equals("processing")) {
				processing_admin_queue_list.add(queue_name);
			}
		}
		task_info.set_processing_admin_queue_list(processing_admin_queue_list);
	}

	private void generate_console_report(pool_data pool_info) {
		// report processing queue list
		HALL_MANAGER_LOGGER.warn(">>>==========Console Report==========");
		HALL_MANAGER_LOGGER.warn(">>>Captured queue:" + task_info.get_captured_admin_queue_list().toString());
		// report processing queue list
		HALL_MANAGER_LOGGER.warn(">>>Processing queue:" + task_info.get_processing_admin_queue_list().toString());
		// report running queue list
		HALL_MANAGER_LOGGER.warn(">>>Running queue:" + task_info.get_running_admin_queue_list().toString());
		// report finished queue list
		HALL_MANAGER_LOGGER.warn(">>>Finished queue:" + task_info.get_finished_admin_queue_list().toString());
		// report thread using
		int max_thread = pool_info.get_pool_max_threads();
		int used_thread = pool_info.get_pool_used_threads();
		HALL_MANAGER_LOGGER.warn(">>>Used Thread:" + String.valueOf(used_thread) + "/" + String.valueOf(max_thread));
		HALL_MANAGER_LOGGER.warn(">>>==================================");
		HALL_MANAGER_LOGGER.warn("");
		HALL_MANAGER_LOGGER.warn("");		
		HALL_MANAGER_LOGGER.warn(">>>>>>>>>>>>>:" + task_info.get_processed_task_queues_data_map().toString());
	}
	
	private void stop_sub_threads(){
		waiter_result.soft_stop();
		Iterator<String> waiters_it = waiters_task.keySet().iterator();
		while(waiters_it.hasNext()){
			String waiter_name = waiters_it.next();
			task_waiter waiter = waiters_task.get(waiter_name);
			waiter.soft_stop();
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
		// ============== All static job start from here ==============
		// initial 1 : start task waiters
		waiters_task = get_waiter_ready(pool_info);
		// initial 2 : start result waiter
		waiter_result = start_right_result_waiter(pool_info);
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
				HALL_MANAGER_LOGGER.debug("hall manager Thread running...");
			}
			// ============== All dynamic job start from here ==============
			// task 1 : update running task waiters
			start_right_task_waiter(waiters_task, pool_info.get_pool_max_threads());
			// task 2 : update captured queue list
			update_captured_queue_list();
			// task 3 : update processing queue list
			update_processing_queue_list();
			// task 4 : automatic run
			// task 5 : make general report
			generate_console_report(pool_info);
			// task 6 : stop waiters
			try {
				Thread.sleep(base_interval * 2 * 1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public void soft_stop() {
		stop_sub_threads();
		stop_request = true;
	}

	public void hard_stop() {
		stop_sub_threads();
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
		switch_data switch_info = new switch_data();
		task_data task_info = new task_data();
		client_data client_info = new client_data();
		view_data view_info = new view_data();
		pool_data pool_info = new pool_data(public_data.PERF_POOL_MAXIMUM_THREAD);
		data_server data_runner = new data_server(switch_info, client_info, pool_info);
		data_runner.start();
		while(true){
			if (switch_info.get_data_server_power_up()){
				System.out.println(">>>data server power up");
				break;
			}
		}
		tube_server tube_runner = new tube_server(switch_info, client_info, pool_info, task_info);
		tube_runner.start();
		while(true){
			if (switch_info.get_tube_server_power_up()){
				System.out.println(">>>tube server power up");
				break;
			}
		}		
		hall_manager jason = new hall_manager(switch_info, client_info, pool_info, task_info, view_info);
		jason.start();
		view_server view_runner = new view_server(switch_info, client_info, task_info, view_info);
		view_runner.start();
		try {
			Thread.sleep(10*1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//jason.soft_stop();
		HALL_MANAGER_LOGGER.warn(">>>Used Thread:" + "jason stopped");
		//tube_runner.soft_stop();
		HALL_MANAGER_LOGGER.warn(">>>Used Thread:" + "tube_runner stopped");
		//data_runner.soft_stop();
		HALL_MANAGER_LOGGER.warn(">>>Used Thread:" + "data_runner stopped");
	}
}