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

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;
import java.util.concurrent.Future;

import org.apache.commons.io.FileUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.task_data;
import data_center.client_data;
import data_center.public_data;
import utility_funcs.file_action;

public class result_waiter extends Thread {
	// public property
	// protected property
	// private property
	private static final Logger RESULT_WAITER_LOGGER = LogManager.getLogger(result_waiter.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread result_thread;
	private pool_data pool_info;
	private client_data client_info;
	private task_data task_info;
	private String line_seprator = System.getProperty("line.separator");
	private int interval = public_data.PERF_THREAD_RUN_INTERVAL;
	// public function
	// protected function
	// private function

	public result_waiter(pool_data pool_info, task_data task_info, client_data client_info) {
		this.pool_info = pool_info;
		this.task_info = task_info;
		this.client_info = client_info;
	}

	// since only this thread will remove the finished call, so not slipped
	// condition will happen
	private HashMap<String, HashMap<String, Object>> sys_call_monitor() {
		// get call map
		HashMap<String, HashMap<String, Object>> call_map = new HashMap<String, HashMap<String, Object>>();
		call_map = pool_info.get_sys_call();
		Set<String> call_map_set = call_map.keySet();
		Iterator<String> call_map_it = call_map_set.iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			Future<?> call_back = (Future<?>) call_map.get(call_index).get("call_back");
			Boolean call_done = call_back.isDone();
			long current_time = System.currentTimeMillis() / 1000;
			long start_time = (long) call_map.get(call_index).get("start_time");
			int time_out = (int) call_map.get(call_index).get("time_out");
			// when call done
			if (call_done) {
				run_case_done_action();
			} else if (current_time - start_time > time_out + 5) {
				run_case_timeout_action();
			} else {
				run_case_processing_action();
			}
		}
	}

	public void copy_case_to_save_path(String case_dir, String copy_type) {
		String save_path = client_info.client_hash.get("base").get("save_path");
		File save_path_fobj = new File(save_path);
		if (!save_path_fobj.exists()) {
			RESULT_WAITER_LOGGER.warn("Client save path not exists, Skip post run process");
			return;
		}
		File case_path_obj = new File(case_dir);
		String case_folder_name = case_path_obj.getName();
		String case_parent_path = case_path_obj.getParent();
		File save_parent_dir = new File(save_path, case_parent_path);
		File save_dest_path = new File(save_parent_dir.toString(), case_folder_name);
		File save_dest_file = new File(save_parent_dir.toString(), case_folder_name + ".zip");
		if (!save_parent_dir.exists()) {
			save_parent_dir.mkdirs();
			save_parent_dir.setWritable(true, false);
		}
		if (copy_type.equals("source")) {
			try {
				FileUtils.copyDirectory(case_path_obj, save_dest_path);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
				RESULT_WAITER_LOGGER.warn("Copy source case failed, Skip this case");
			}
		} else if (copy_type.equals("archive")) {
			file_action.zipFolder(case_path_obj.getAbsolutePath().toString().replaceAll("\\\\", "/"),
					save_dest_file.toString());
		} else {
			RESULT_WAITER_LOGGER.warn("Wrong copy type given, skip");
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
		result_thread = Thread.currentThread();
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
				RESULT_WAITER_LOGGER.debug("Client Thread running...");
			}
			// >>>step 0 get run status
			sys_call_monitor();
			// >>>step 1
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
		if (result_thread != null) {
			result_thread.interrupt();
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
		//
	}
}