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
import java.util.ArrayList;
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
import utility_funcs.system_cmd;

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
		// get call map report

	}
	
	private HashMap<String, HashMap<String, Object>> get_call_status_map(){
		HashMap<String, HashMap<String, Object>> return_call_map = new HashMap<String, HashMap<String, Object>>();
		// scan calls update private_call_map with call_status, cmd_status, cmd_output
		HashMap<String, HashMap<String, Object>> system_call_map = pool_info.get_sys_call();
		Set<String> system_call_map_set = system_call_map.keySet();
		Iterator<String> system_call_map_it = system_call_map_set.iterator();
		while (system_call_map_it.hasNext()) {
			String call_index = system_call_map_it.next();
			HashMap<String, Object> return_call_data = new HashMap<String, Object>();
			Iterator<String> system_call_map_data_it = system_call_map.get(call_index).keySet().iterator();
			while(system_call_map_data_it.hasNext()){
				String sys_call_map_level2_key = system_call_map_data_it.next();
				Object sys_call_map_level2_value = system_call_map.get(call_index).get(sys_call_map_level2_key);
				if(  sys_call_map_level2_key){
					return_call_data.put(sys_call_map_level2_key, sys_call_map_level2_value);
				} else if (sys_call_map_level2_key.equals("case_id")){
					return_call_data.put(sys_call_map_level2_key, sys_call_map_level2_value);
				}
					
			}
			
			
			
			Future<?> call_back = (Future<?>) private_call_map.get(call_index).get("call_back");
			Boolean call_done = call_back.isDone();
			String status = new String();
			long current_time = System.currentTimeMillis() / 1000;
			long start_time = (long) private_call_map.get(call_index).get("start_time");
			int time_out = (int) private_call_map.get(call_index).get("time_out");
			// run report action
			if (call_done) {
				run_case_done_action();
			} else if (current_time - start_time > time_out + 5) {
				run_case_timeout_action();
			} else {
				run_case_processing_action();
			}
		}		
	}
	
	private void run_case_done_action(){
		//step 0 return case result
		//step
	}
	
	private void run_case_timeout_action(){
		
	}
	
	private void run_case_processing_action(){
		
	}	

	public static Boolean final_cleanup(String clean_work_path){
		String cmd ="python " + public_data.TOOLS_KILL_PROCESS + " " + clean_work_path;
		ArrayList<String> excute_retruns = new ArrayList<String>();
		try {
			excute_retruns =  system_cmd.run(cmd);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
		Boolean finish_clean = false;
		for (String line: excute_retruns){
			if (line.equalsIgnoreCase("Scan_finished")){
				finish_clean = true;
				break;
			}
		}
		if (finish_clean){
			return true;
		} else {
			return false;
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