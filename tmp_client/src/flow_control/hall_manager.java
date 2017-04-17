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

import connect_tube.tube_server;
import connect_tube.task_data;
import data_center.client_data;
import data_center.data_server;
import data_center.switch_data;
import gui_interface.view_data;
import gui_interface.view_server;
import info_parser.cmd_parser;
import utility_funcs.file_action;
import data_center.public_data;

public class hall_manager extends Thread {
	// public property
	// protected property
	// private property
	private static final Logger HALL_MANAGER_LOGGER = LogManager.getLogger(hall_manager.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread current_thread;
	private switch_data switch_info;
	private task_data task_info;
	private client_data client_info;
	private pool_data pool_info;
	private view_data view_info;
	private String line_separator = System.getProperty("line.separator");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;
	// sub threads need to be launched
	HashMap<String, task_waiter> waiters_task;
	result_waiter waiter_result;
	// public function
	// protected function
	// private function

	public hall_manager(switch_data switch_info, client_data client_info, pool_data pool_info, task_data task_info,
			view_data view_info) {
		this.task_info = task_info;
		this.client_info = client_info;
		this.switch_info = switch_info;
		this.pool_info = pool_info;
		this.view_info = view_info;
	}

	private HashMap<String, task_waiter> get_waiter_ready(pool_data pool_info) {
		HashMap<String, task_waiter> waiters = new HashMap<String, task_waiter>();
		int max_pool_size = public_data.PERF_POOL_MAXIMUM_SIZE;
		for (int i = 0; i < max_pool_size; i++) {
			task_waiter waiter = new task_waiter(i, switch_info, client_info, pool_info, task_info);
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

	private void generate_console_report(pool_data pool_info) {
		// report processing queue list
		HALL_MANAGER_LOGGER.info(">>>==========Console Report==========");
		HALL_MANAGER_LOGGER
				.info(">>>Captured queue:" + task_info.get_captured_admin_queues_treemap().keySet().toString());
		// report processing queue list
		HALL_MANAGER_LOGGER.info(">>>Processing queue:" + task_info.get_processing_admin_queue_list().toString());
		// report running queue list
		HALL_MANAGER_LOGGER.info(">>>Running queue:" + task_info.get_running_admin_queue_list().toString());
		// report finished queue list
		HALL_MANAGER_LOGGER.info(">>>Finished queue:" + task_info.get_finished_admin_queue_list().toString());
		// report thread using
		String max_thread = String.valueOf(pool_info.get_pool_current_size());
		String used_thread = String.valueOf(pool_info.get_pool_used_threads());
		HALL_MANAGER_LOGGER.info(">>>Used Thread:" + used_thread + "/" + max_thread);
		HALL_MANAGER_LOGGER.info(">>>==================================");
		HALL_MANAGER_LOGGER.info("");
		HALL_MANAGER_LOGGER.debug(client_info.get_use_soft_insts());
		HALL_MANAGER_LOGGER.debug(client_info.get_max_soft_insts());
		HALL_MANAGER_LOGGER.debug(client_info.get_available_software_insts());
		HALL_MANAGER_LOGGER.debug(client_info.get_client_data().toString());
	}

	private void stop_sub_threads() {
		waiter_result.soft_stop();
		Iterator<String> waiters_it = waiters_task.keySet().iterator();
		while (waiters_it.hasNext()) {
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
			String dump_path = client_info.get_client_data().get("preference").get("work_path") 
					+ "/" + public_data.WORKSPACE_LOG_DIR + "/core_dump/dump.log";
			file_action.append_file(dump_path, run_exception.toString() + line_separator);
			for(Object item: run_exception.getStackTrace()){
				file_action.append_file(dump_path, "    at " + item.toString() + line_separator);
			}				
			System.exit(1);
		}
	}

	private void monitor_run() {
		current_thread = Thread.currentThread();
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
			start_right_task_waiter(waiters_task, pool_info.get_pool_current_size());
			// task 2 : automatic run

			// task 3 : make general report
			generate_console_report(pool_info);
			// task 4 : stop waiters
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
		if (current_thread != null) {
			current_thread.interrupt();
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
		cmd_parser cmd_run = new cmd_parser(args);
		HashMap<String, String> cmd_info = cmd_run.cmdline_parser();
		switch_data switch_info = new switch_data();
		task_data task_info = new task_data();
		client_data client_info = new client_data();
		view_data view_info = new view_data();
		pool_data pool_info = new pool_data(public_data.PERF_POOL_MAXIMUM_SIZE);
		view_server view_runner = new view_server(switch_info, client_info, task_info, view_info, pool_info);
		view_runner.start();
		data_server data_runner = new data_server(cmd_info, switch_info, client_info, pool_info);
		data_runner.start();
		while (true) {
			if (switch_info.get_data_server_power_up()) {
				System.out.println(">>>data server power up");
				break;
			}
		}
		tube_server tube_runner = new tube_server(switch_info, client_info, pool_info, task_info);
		tube_runner.start();
		while (true) {
			if (switch_info.get_tube_server_power_up()) {
				System.out.println(">>>tube server power up");
				break;
			}
		}
		hall_manager jason = new hall_manager(switch_info, client_info, pool_info, task_info, view_info);
		jason.start();
		try {
			Thread.sleep(10 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// jason.soft_stop();
		HALL_MANAGER_LOGGER.warn(">>>Used Thread:" + "jason stopped");
		// tube_runner.soft_stop();
		HALL_MANAGER_LOGGER.warn(">>>Used Thread:" + "tube_runner stopped");
		// data_runner.soft_stop();
		HALL_MANAGER_LOGGER.warn(">>>Used Thread:" + "data_runner stopped");
	}
}