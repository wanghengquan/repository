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
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.concurrent.Callable;
//import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.io.FileUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.public_data;
import utility_funcs.screen_record;
import utility_funcs.system_cmd;

public class pool_data {
	// public property
	// protected property
	// private property
	private static final Logger THREAD_POOL_LOGGER = LogManager.getLogger(pool_data.class.getName());
	// private String line_separator = System.getProperty("line.separator");
	// public function
	// protected function
	// private function
	private ExecutorService run_pool;
	private HashMap<String, HashMap<pool_attr, Object>> call_map = new HashMap<String, HashMap<pool_attr, Object>>();
	private HashMap<String, Thread> space_check_thread_map = new HashMap<String, Thread>();
	private int pool_reserved_threads = 0;
	private int pool_current_size = public_data.PERF_POOL_CURRENT_SIZE;
	private int pool_maximum_size = public_data.PERF_POOL_MAXIMUM_SIZE;
	private HashMap<String, HashMap<String, Object>> history_send_data = new HashMap<String, HashMap<String, Object>> ();

	public pool_data(int pool_size) {
		this.run_pool = Executors.newFixedThreadPool(pool_size);
	}

	public pool_data() {
		//initialize the thread pool later (when config info ready)
	}

	public synchronized HashMap<String, String> get_database_info() {
		HashMap<String, String> result = new HashMap<String, String>();
		result.put("call_map", call_map.toString());
		result.put("pool_reserved_threads", String.valueOf(pool_reserved_threads));
		result.put("pool_current_size", String.valueOf(pool_current_size));
		result.put("pool_maximum_size", String.valueOf(pool_maximum_size));
		result.put("history_send_data", history_send_data.toString());
		return result;
	}
	
	public synchronized void initialize_thread_pool(int pool_size){
		this.run_pool = Executors.newFixedThreadPool(pool_size);
		this.pool_maximum_size = pool_size;
	}
	
	public synchronized void set_pool_maximum_size(int pool_size) {
		this.pool_maximum_size = pool_size;
	}
	
	public synchronized int get_pool_maximum_size() {
		int temp = 0;
		temp = pool_maximum_size;
		return temp;
	}

	public synchronized void set_pool_current_size(int new_int) {
		this.pool_current_size = new_int;
	}
	
	public synchronized int get_pool_current_size() {
		return this.pool_current_size;
	}
	
	public synchronized void set_pool_reserved_threads(int new_int) {
		this.pool_reserved_threads = new_int;
	}

	public synchronized int get_pool_reserved_threads() {
		int temp = 0;
		temp = pool_reserved_threads;
		return temp;
	}

	public synchronized int get_pool_used_threads() {
		int temp = 0;
		temp = call_map.size();
		return temp;
	}
	
	public synchronized int get_available_thread_for_reserve() {
		if (pool_current_size > pool_reserved_threads) {
			return pool_current_size - pool_reserved_threads;
		} else {
			return 0;
		}
	}

	public synchronized Boolean booking_reserved_threads(int booking_number) {
		Boolean booking_result = Boolean.valueOf(true);
		int future_threads = this.pool_reserved_threads + booking_number;
		if (future_threads > pool_current_size) {
			booking_result = false;
		} else {
			this.pool_reserved_threads = future_threads;
		}
		return booking_result;
	}

	public synchronized Boolean release_reserved_threads(int release_number) {
		Boolean release_result = Boolean.valueOf(true);
		int future_threads = this.pool_reserved_threads - release_number;
		if (future_threads < 0) {
			future_threads = 0;
			release_result = false;
			THREAD_POOL_LOGGER.warn("Thread in pool released with warnning");
		}
		this.pool_reserved_threads = future_threads;
		return release_result;
	}

	public synchronized void add_sys_call(
			Callable<?> sys_call, 
			String queue_name, 
			String case_id, 
			String launch_path,
			String case_path,
			String case_url,
			float est_mem,
			float est_space,
			int time_out,
			Boolean call_recorded,
			screen_record video_object
			) {
		Future<?> future_call_back = run_pool.submit(sys_call);
		String sys_call_key = case_id + "#" + queue_name;
		HashMap<pool_attr, Object> sys_call_data = new HashMap<pool_attr, Object>();
		sys_call_data.put(pool_attr.call_back, future_call_back);
		sys_call_data.put(pool_attr.call_queue, queue_name);
		sys_call_data.put(pool_attr.call_case, case_id);
		sys_call_data.put(pool_attr.call_laudir, launch_path);
		sys_call_data.put(pool_attr.call_casedir, case_path);
		sys_call_data.put(pool_attr.call_caseurl, case_url);
		long start_time = System.currentTimeMillis() / 1000;
		sys_call_data.put(pool_attr.call_gentime, start_time);
		sys_call_data.put(pool_attr.call_reqtime, time_out);
		sys_call_data.put(pool_attr.call_canceled, false);
		sys_call_data.put(pool_attr.call_estmem, est_mem);
		sys_call_data.put(pool_attr.call_curmem, 0.0f);
		sys_call_data.put(pool_attr.call_maxmem, 0.0f);
		sys_call_data.put(pool_attr.call_estspace, est_space);
		sys_call_data.put(pool_attr.call_space, 0.0f);
		sys_call_data.put(pool_attr.call_timeout, false);
		sys_call_data.put(pool_attr.call_terminate, false);
		sys_call_data.put(pool_attr.call_status, call_state.INITIATE);
		ArrayList<String> call_output = new ArrayList<String>();
		sys_call_data.put(pool_attr.call_output, call_output);
		sys_call_data.put(pool_attr.call_recorded, call_recorded);
		sys_call_data.put(pool_attr.call_videoobj, video_object);
		call_map.put(sys_call_key, sys_call_data);
	}

	@SuppressWarnings("unchecked")
	public synchronized void fresh_sys_call(
			ArrayList<String> mem_info,
			HashMap<String,String> tools_data
			) {
		if (call_map.isEmpty()) {
			return;
		}
		Iterator<String> call_map_it = call_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<pool_attr, Object> hash_data = call_map.get(call_index);
			// put call_status
			Future<?> call_back = (Future<?>) hash_data.get(pool_attr.call_back);
			String call_case_id = (String) hash_data.get(pool_attr.call_case);
			long current_time = System.currentTimeMillis() / 1000;
			long start_time = (long) hash_data.get(pool_attr.call_gentime);
			int time_out = (int) hash_data.get(pool_attr.call_reqtime);
			Boolean record_request = (Boolean) hash_data.get(pool_attr.call_recorded);
			screen_record record_object = (screen_record) hash_data.get(pool_attr.call_videoobj);
			// timeout task cancel
			if (current_time - start_time > time_out + 5) {
				hash_data.put(pool_attr.call_timeout, true);
				hash_data.put(pool_attr.call_canceled, call_back.cancel(true));
			}
			// run report action
			if (call_back.isDone()) {
				hash_data.put(pool_attr.call_status, call_state.DONE);
				ArrayList<String> call_output = (ArrayList<String>) hash_data.get(pool_attr.call_output);
				try {
					call_output.addAll((Collection<? extends String>) call_back.get(10, TimeUnit.SECONDS));
				} catch (Exception e) {
					// e.printStackTrace();
					THREAD_POOL_LOGGER.warn("Get task call exception.");
					call_output.add(">>>Error:Get task call exception.");
					call_output.add("<status>Failed</status>");
				}
				if((boolean) hash_data.get(pool_attr.call_canceled)){
					call_output.add(">>>Canceled extra run:");
					call_output.addAll(get_cancel_extra_run_output((String) hash_data.get(pool_attr.call_casedir), tools_data));
				}
				if (is_child_process_timeout(call_output)){
					call_output.add(">>>Timeout extra run:");
					call_output.addAll(get_cancel_extra_run_output((String) hash_data.get(pool_attr.call_casedir), tools_data));
				}
				if (record_request) {
					record_object.stop();
				}
			} else {
				hash_data.put(pool_attr.call_status, call_state.PROCESSIONG);
				float cur_mem = get_current_task_memory_usage(call_case_id, mem_info);
				hash_data.put(pool_attr.call_curmem, cur_mem);
				float max_mem = (float) hash_data.get(pool_attr.call_maxmem);
				if (cur_mem > max_mem) {
					hash_data.put(pool_attr.call_maxmem, cur_mem);
				}
				update_call_sapce_usage(call_index, (String) hash_data.get(pool_attr.call_casedir));
			}
		}
	}
	
	private void update_call_sapce_usage(
			String call_index,
			String case_path
			) {
		if (get_space_check_thread(call_index)!= null && get_space_check_thread(call_index).isAlive()) {//previous threads still working
			THREAD_POOL_LOGGER.warn("Previous space checking thread working, skip this launch.");
			return;
		}
		Thread size_checker = new Thread() {
			HashMap<pool_attr, Object> space_data = new HashMap<pool_attr, Object>();
			public void run() {
				float cur_space = 0.0f;
				try {
					cur_space = get_current_task_space_usage(case_path);
					space_data.put(pool_attr.call_space, cur_space);
					update_sys_call(call_index, space_data);
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					//System.out.println("Thread done, size_checker:" + String.valueOf(cur_space));
				}
			}
		};
		size_checker.start();
		update_space_check_thread(call_index, size_checker);
	}
	
	private float get_current_task_space_usage(
			String case_path
			) {
        float used_space = 0.0f;
		File file = new File(case_path);
		used_space = FileUtils.sizeOfDirectory(file);
		return used_space / 1024 / 1024 / 1024;
	}
	
	private float get_current_task_memory_usage(
			String case_id,
			ArrayList<String> mem_info
			){
		float current_mem = 0.0f;
		String scan_value = new String("0.0");
		//System.out.println(mem_info);
		for (String line: mem_info) {
			line = line.replace(")", "");//for python2.7 compatibility
			if(line.contains("T" + case_id) && line.contains(" ")) {
				scan_value = line.split("\\s+")[1];
				current_mem = Float.valueOf(scan_value).floatValue();
			}
		}
		return current_mem;
	}
	
	private Boolean is_child_process_timeout(ArrayList<String> cmd_output) {
		if (cmd_output == null | cmd_output.isEmpty()){
			return false;
		}
		// <status>Timeout</status>
		Pattern p = Pattern.compile("status>(.+?)</", Pattern.CASE_INSENSITIVE);
		for (String line : cmd_output) {
			if (!line.contains("<status>")) {
				continue;
			}
			Matcher m = p.matcher(line);
			if (m.find() && m.group(1).trim().equalsIgnoreCase("timeout")) {
				return true;
			}
		}
		return false;
	}
	
	public synchronized Boolean terminate_sys_call(String call_index) {
		Boolean cancel_status = Boolean.valueOf(true);
		HashMap<pool_attr, Object> hash_data = call_map.get(call_index);
		Future<?> call_back = (Future<?>) hash_data.get(pool_attr.call_back);
		hash_data.put(pool_attr.call_terminate, true);
		cancel_status = call_back.cancel(true);
		hash_data.put(pool_attr.call_canceled, cancel_status);		
		return cancel_status;
	}
	
	private ArrayList<String> get_cancel_extra_run_output(
			String case_path,
			HashMap<String,String> tools_data){
		ArrayList<String> output_data = new ArrayList<String>();
		String python_cmd = new String(tools_data.getOrDefault("python", public_data.DEF_PYTHON_PATH));
		String run_cmd = new String(python_cmd + " " + public_data.CASE_TIMEOUT_RUN);
		try {
			output_data.addAll(system_cmd.run(run_cmd, case_path));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			output_data.add("Run cancel extra run Failed.");
		}
		return output_data;
	}
	
	public synchronized HashMap<String, HashMap<pool_attr, Object>> get_sys_call_copy() {
		HashMap<String, HashMap<pool_attr, Object>> call_data = new HashMap<String, HashMap<pool_attr, Object>>();
		Iterator<String> call_map_it = call_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<pool_attr, Object> one_call_data = call_map.get(call_index);
			HashMap<pool_attr, Object> return_data = new HashMap<pool_attr, Object>();
			Iterator<pool_attr> one_call_it = one_call_data.keySet().iterator();
			while (one_call_it.hasNext()){
				pool_attr call_key = one_call_it.next();
				if (call_key.equals(pool_attr.call_back)){
					continue;
				}
				return_data.put(call_key, one_call_data.get(call_key));
			}
			call_data.put(call_index, return_data);
		}
		return call_data;
	}
	
	public synchronized float get_sys_call_extra_memory() {
		float total_estimate_extra_usage = 0.0f;		
		Iterator<String> call_map_it = call_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<pool_attr, Object> one_call_data = call_map.get(call_index);
			call_state call_status = (call_state) one_call_data.get(pool_attr.call_status);
			if (!call_status.equals(call_state.DONE)) {
				continue;
			}
			float est_mem = (float) one_call_data.get(pool_attr.call_estmem);
			float cur_mem = (float) one_call_data.get(pool_attr.call_curmem);
			if (est_mem > cur_mem) {
				total_estimate_extra_usage = total_estimate_extra_usage +  est_mem - cur_mem;
			}
		}
		return total_estimate_extra_usage;
	}
	
	public synchronized float get_sys_call_extra_space() {
		float total_estimate_extra_usage = 0.0f;		
		Iterator<String> call_map_it = call_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<pool_attr, Object> one_call_data = call_map.get(call_index);
			call_state call_status = (call_state) one_call_data.get(pool_attr.call_status);
			if (!call_status.equals(call_state.DONE)) {
				continue;
			}
			float est_space = (float) one_call_data.get(pool_attr.call_estspace);
			float cur_space = (float) one_call_data.get(pool_attr.call_space);
			if (est_space > cur_space) {
				total_estimate_extra_usage = total_estimate_extra_usage +  est_space - cur_space;
			}
		}
		return total_estimate_extra_usage;
	}	
	
	
	public synchronized HashMap<String, HashMap<pool_attr, Object>> get_sys_call_link() {
		return this.call_map;
	}	
	
	public synchronized Boolean update_sys_call(
			String sys_call_key,
			HashMap<pool_attr, Object> update_data
			) {
		Boolean update_status = Boolean.valueOf(true);
		HashMap<pool_attr, Object> call_data = new HashMap<pool_attr, Object>();
		if (call_map.containsKey(sys_call_key)) {
			call_data.putAll(call_map.get(sys_call_key));
		} 
		call_data.putAll(update_data);
		call_map.put(sys_call_key, call_data);
		return update_status;
	}
	
	public synchronized Boolean remove_sys_call(String sys_call_key) {
		Boolean remove_result = Boolean.valueOf(true);
		if (call_map.containsKey(sys_call_key)) {
			call_map.remove(sys_call_key);
		} else {
			remove_result = false;
		}
		return remove_result;
	}

	public synchronized HashMap<String, HashMap<String, Object>> get_history_send_data(){
		HashMap<String, HashMap<String, Object>> history_data = new HashMap<String, HashMap<String, Object>>();
		history_data.putAll(history_send_data);
		return history_data;
	}
	
	public synchronized Boolean update_history_send_data(
			String case_index, 
			HashMap<String, Object> update_data){
		Boolean update_status = Boolean.valueOf(true);
		history_send_data.put(case_index, update_data);
		return update_status;
	}
	
	public synchronized Boolean remove_history_send_data(String case_index){
		Boolean remove_status = Boolean.valueOf(false);
		if (history_send_data.containsKey(case_index)){
			history_send_data.remove(case_index);
			remove_status = true;
		}
		return remove_status;
	}
	
	
	public synchronized Thread get_space_check_thread(
			String case_index
			){
		Thread check_thread = null;
		if (space_check_thread_map.containsKey(case_index)){
			check_thread = space_check_thread_map.get(case_index);
		}
		return check_thread;
	}
	
	public synchronized void update_space_check_thread(
			String case_index,
			Thread thread_obj
			){
		space_check_thread_map.put(case_index, thread_obj);
	}
	
	public void shutdown_pool() {
		run_pool.shutdown();
	}

	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		//
	}
}