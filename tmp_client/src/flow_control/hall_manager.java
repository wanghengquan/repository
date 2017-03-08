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

import connect_tube.local_tube;
import connect_tube.rmq_tube;
import connect_tube.run_tube;
import connect_tube.task_data;
import data_center.client_data;
import data_center.switch_data;
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
	// private String line_seprator = System.getProperty("line.separator");
	private int interval = public_data.PERF_THREAD_RUN_INTERVAL;
	// public function
	// protected function
	// private function

	private hall_manager(task_data task_info, client_data client_info, switch_data switch_info) {
		this.task_info = task_info;
		this.client_info = client_info;
		this.switch_info = switch_info;
	}

	private HashMap<String, task_waiter> get_waiter_ready(pool_data pool_info) {
		HashMap<String, task_waiter> waiters = new HashMap<String, task_waiter>();
		int max_sw_thread = public_data.PERF_POOL_MAXIMUM_THREAD;
		for (int i = 0; i < max_sw_thread; i++) {
			task_waiter waiter = new task_waiter(i, pool_info, task_info, client_info, switch_info);
			String waiter_index = "waiter_" + String.valueOf(i);
			waiters.put(waiter_index, waiter);
			waiter.start();
			waiter.wait_request();
			System.out.println(waiter.get_waiter_status());
		}
		return waiters;
	}

	private void start_right_task_waiter(HashMap<String, task_waiter> waiters) {
		String start_number = public_data.DEF_MAX_PROCS;
		Integer right_number = Integer.valueOf(start_number);
		Set<String> waiter_set = waiters.keySet();
		Iterator<String> waiter_it = waiter_set.iterator();
		while (waiter_it.hasNext()) {
			String waiter_index = waiter_it.next();
			int waiter_id = Integer.valueOf(waiter_index.replace("waiter_", ""));
			task_waiter waiter = waiters.get(waiter_index);
			String waiter_status = waiter.get_waiter_status();
			System.out.println(waiter_index + ":" + waiter_status);
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
		result_waiter waiter = new result_waiter(pool_info, task_info, client_info, switch_info);
		waiter.start();
		return waiter;
	}

	private void update_reject_queue_list() {
		Set<String> remote_admin_queue_set = rmq_tube.remote_admin_queue_receive_treemap.keySet();
		Iterator<String> remote_it = remote_admin_queue_set.iterator();
		Set<String> local_admin_queue_set = local_tube.local_admin_queue_receive_treemap.keySet();
		Iterator<String> local_it = local_admin_queue_set.iterator();
		Set<String> captured_admin_queue_set = run_tube.captured_admin_queues.keySet();
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
		Set<String> captured_admin_queue_set = run_tube.captured_admin_queues.keySet();
		Iterator<String> captured_it = captured_admin_queue_set.iterator();
		ArrayList<String> captured_admin_queue_list = new ArrayList<String>();
		while (captured_it.hasNext()) {
			String queue_name = captured_it.next();
			captured_admin_queue_list.add(queue_name);
		}
		task_info.set_captured_admin_queue_list(captured_admin_queue_list);
	}

	private void update_processing_queue_list() {
		Set<String> captured_admin_queue_set = run_tube.captured_admin_queues.keySet();
		Iterator<String> captured_it = captured_admin_queue_set.iterator();
		ArrayList<String> processing_admin_queue_list = new ArrayList<String>();
		while (captured_it.hasNext()) {
			String queue_name = captured_it.next();
			String queue_status = run_tube.captured_admin_queues.get(queue_name).get("Status").get("admin_status");
			if (queue_status.equals("processing")) {
				processing_admin_queue_list.add(queue_name);
			}
		}
		task_info.set_processing_admin_queue_list(processing_admin_queue_list);
	}

	private void make_console_report(pool_data pool_info) {
		// report processing queue list
		HALL_MANAGER_LOGGER.warn(">>>Processing queue:" + task_info.get_processing_admin_queue_list().toString());
		// report running queue list
		HALL_MANAGER_LOGGER.warn(">>>running queue:" + task_info.get_running_admin_queue_list().toString());
		// report finished queue list
		HALL_MANAGER_LOGGER.warn(">>>finished queue:" + task_info.get_finished_admin_queue_list().toString());
		// report thread using
		Integer max_thread = Integer.parseInt(switch_info.get_pool_max_procs());
		int used_thread = pool_info.get_used_thread();
		HALL_MANAGER_LOGGER.warn(">>>Used Thread:" + String.valueOf(used_thread) + "/" + max_thread.toString());
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
		pool_data pool_info = new pool_data(public_data.PERF_POOL_MAXIMUM_THREAD, switch_info);
		// initial 1 : start task waiters
		HashMap<String, task_waiter> waiters_task = get_waiter_ready(pool_info);
		// initial 2 : start result waiter
		result_waiter waiter_result = start_right_result_waiter(pool_info);
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
				HALL_MANAGER_LOGGER.warn("hall manager Thread running...");
			}
			// ============== All dynamic job start from here ==============
			// task 1 : update running task waiters
			start_right_task_waiter(waiters_task);
			// task 2 : update reject queue list
			update_reject_queue_list();
			// task 3 : update captured queue list
			update_captured_queue_list();
			// task 4 : update processing queue list
			update_processing_queue_list();
			// task 5 : automatic run
			// task 6 : make general report
			make_console_report(pool_info);
			// task 7 : stop waiters
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
		switch_data switch_info = new switch_data();
		task_data task_data = new task_data();
		client_data client_info = new client_data();
		hall_manager jason = new hall_manager(task_data, client_info, switch_info);
		jason.start();
	}
}