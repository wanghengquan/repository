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

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.public_data;
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
	private int pool_used_threads = 0;
	private int pool_current_size = Integer.parseInt(public_data.DEF_POOL_CURRENT_SIZE);
	private HashMap<String, HashMap<String, Object>> history_send_data = new HashMap<String, HashMap<String, Object>> ();

	public pool_data(int pool_size) {
		this.run_pool = Executors.newFixedThreadPool(pool_size);
	}

	public synchronized int get_pool_used_threads() {
		int temp = 0;
		temp = pool_used_threads;
		return temp;
	}

	public synchronized void set_pool_used_threads(int new_int) {
		this.pool_used_threads = new_int;
	}

	public synchronized int get_pool_current_size() {
		return this.pool_current_size;
	}

	public synchronized void set_pool_current_size(int new_int) {
		this.pool_current_size = new_int;
	}

	public synchronized int get_available_thread() {
		if (pool_current_size > pool_used_threads) {
			return pool_current_size - pool_used_threads;
		} else {
			return 0;
		}
	}

	public synchronized Boolean booking_used_thread(int booking_number) {
		Boolean booking_result = new Boolean(true);
		int future_threads = this.pool_used_threads + booking_number;
		if (future_threads > pool_current_size) {
			booking_result = false;
		} else {
			this.pool_used_threads = future_threads;
		}
		return booking_result;
	}

	public synchronized Boolean release_used_thread(int release_number) {
		Boolean release_result = new Boolean(true);
		int future_threads = this.pool_used_threads - release_number;
		if (future_threads < 0) {
			future_threads = 0;
			release_result = false;
			THREAD_POOL_LOGGER.warn("Thread in pool released with warnning");
		}
		this.pool_used_threads = future_threads;
		return release_result;
	}

	public synchronized void add_sys_call(
			Callable<?> sys_call, 
			String queue_name, 
			String case_id, 
			String launch_path,
			String case_path,
			int time_out) {
		Future<?> future_call_back = run_pool.submit(sys_call);
		String sys_call_key = case_id + "#" + queue_name;
		HashMap<pool_attr, Object> sys_call_data = new HashMap<pool_attr, Object>();
		sys_call_data.put(pool_attr.call_back, future_call_back);
		sys_call_data.put(pool_attr.call_queue, queue_name);
		sys_call_data.put(pool_attr.call_case, case_id);
		sys_call_data.put(pool_attr.call_laudir, launch_path);
		sys_call_data.put(pool_attr.call_casedir, case_path);
		long start_time = System.currentTimeMillis() / 1000;
		sys_call_data.put(pool_attr.call_gentime, start_time);
		sys_call_data.put(pool_attr.call_reqtime, time_out);
		sys_call_data.put(pool_attr.call_canceled, false);
		sys_call_data.put(pool_attr.call_timeout, false);
		sys_call_data.put(pool_attr.call_terminate, false);
		sys_call_data.put(pool_attr.call_status, call_state.INITIATE);
		ArrayList<String> call_output = new ArrayList<String>();
		sys_call_data.put(pool_attr.call_output, call_output);
		call_map.put(sys_call_key, sys_call_data);
	}

	@SuppressWarnings("unchecked")
	public synchronized void fresh_sys_call() {
		Iterator<String> call_map_it = call_map.keySet().iterator();
		while (call_map_it.hasNext()) {
			String call_index = call_map_it.next();
			HashMap<pool_attr, Object> hash_data = call_map.get(call_index);
			// put call_status
			Future<?> call_back = (Future<?>) hash_data.get(pool_attr.call_back);
			long current_time = System.currentTimeMillis() / 1000;
			long start_time = (long) hash_data.get(pool_attr.call_gentime);
			int time_out = (int) hash_data.get(pool_attr.call_reqtime);
			// timeout task cancel
			if (current_time - start_time > time_out + 5) {
				hash_data.put(pool_attr.call_timeout, true);
				hash_data.put(pool_attr.call_canceled, call_back.cancel(true));
			}			
			// run report action
			Boolean call_done = call_back.isDone();
			if (call_done) {
				hash_data.put(pool_attr.call_status, call_state.DONE);
				ArrayList<String> call_output = (ArrayList<String>) hash_data.get(pool_attr.call_output);
				try {
					call_output.addAll((Collection<? extends String>) call_back.get(10, TimeUnit.SECONDS));
				} catch (Exception e) {
					// e.printStackTrace();
					THREAD_POOL_LOGGER.warn("Get task call exception.");
					call_output.add(">>>Error:Get task call exception.");
					call_output.add("<status>Blocked</status>");
				}
				if((boolean) hash_data.get(pool_attr.call_canceled)){
					call_output.add(">>>Timeout extra run:");
					call_output.addAll(get_cancel_extra_run_output((String) hash_data.get(pool_attr.call_casedir)));
				}
				if (is_child_process_timeout(call_output)){
					call_output.add(">>>Timeout extra run:");
					call_output.addAll(get_cancel_extra_run_output((String) hash_data.get(pool_attr.call_casedir)));
				}
			} else {
				hash_data.put(pool_attr.call_status, call_state.PROCESSIONG);
			}
		}
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
		Boolean cancel_status = new Boolean(true);
		HashMap<pool_attr, Object> hash_data = call_map.get(call_index);
		Future<?> call_back = (Future<?>) hash_data.get(pool_attr.call_back);
		hash_data.put(pool_attr.call_terminate, true);
		cancel_status = call_back.cancel(true);
		hash_data.put(pool_attr.call_canceled, cancel_status);		
		return cancel_status;
	}	
	
	private ArrayList<String> get_cancel_extra_run_output(
			String case_path){
		ArrayList<String> output_data = new ArrayList<String>();
		String run_cmd = new String("python " + public_data.CASE_TIMEOUT_RUN);
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

	public synchronized HashMap<String, HashMap<pool_attr, Object>> get_sys_call_link() {
		return this.call_map;
	}	
	
	public synchronized Boolean update_sys_call(
			String sys_call_key,
			HashMap<pool_attr, Object> update_data
			) {
		Boolean update_status = new Boolean(true);
		HashMap<pool_attr, Object> call_data = new HashMap<pool_attr, Object>();
		if (call_map.containsKey(sys_call_key)) {
			call_data.putAll(call_map.get(sys_call_key));
		} 
		call_data.putAll(update_data);
		call_map.put(sys_call_key, call_data);
		return update_status;
	}
	
	public synchronized Boolean remove_sys_call(String sys_call_key) {
		Boolean remove_result = new Boolean(true);
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
		Boolean update_status = new Boolean(true);
		history_send_data.put(case_index, update_data);
		return update_status;
	}
	
	public synchronized Boolean remove_history_send_data(String case_index){
		Boolean remove_status = new Boolean(false);
		if (history_send_data.containsKey(case_index)){
			history_send_data.remove(case_index);
			remove_status = true;
		}
		return remove_status;
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