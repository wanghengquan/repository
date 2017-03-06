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
import java.util.concurrent.Callable;
//import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.switch_data;



public class pool_data{
	// public property
	// protected property
	// private property
	private static final Logger THREAD_POOL_LOGGER = LogManager.getLogger(pool_data.class.getName());
	//private String line_seprator = System.getProperty("line.separator");	
	// public function
	// protected function
	// private function	
	private ExecutorService run_pool;
	private HashMap<String, HashMap<String, Object>> call_map = new HashMap<String, HashMap<String, Object>>();
	private switch_data switch_info;
	private int used_thread = 0;
	
	public pool_data(int pool_size, switch_data switch_info){
		this.run_pool = Executors.newFixedThreadPool(pool_size);
		this.switch_info = switch_info;
	}
	
	public synchronized int get_used_thread(){
		return used_thread;
	}

	public synchronized void set_used_thread(int new_int){
		this.used_thread = new_int;
	}
	
	public synchronized int get_available_thread(){
		int maximum_thread = Integer.parseInt(switch_info.get_pool_max_procs());
		if(maximum_thread > used_thread){
			return maximum_thread - used_thread;
		} else {
			return 0;
		}
	}
	
	public synchronized Boolean booking_used_thread(int booking_number){
		Boolean booking_result = new Boolean(true);
		int future_thread = this.used_thread + booking_number;
		if (future_thread > Integer.parseInt(switch_info.get_pool_max_procs())){
			booking_result = false;
		} 
		this.used_thread = future_thread;
		return booking_result;
	}
	
	public synchronized Boolean release_used_thread(int release_number){
		Boolean release_result = new Boolean(true);
		int future_thread = this.used_thread - release_number;
		if (future_thread < 0){
			future_thread = 0;
			release_result = false;
			THREAD_POOL_LOGGER.warn("Thread in pool released with warnning");
		} 
		this.used_thread = future_thread;
		return release_result;
	}
	
	public synchronized void add_sys_call(
			Callable<?> sys_call, 
			String queue_name, 
			String case_id,
			String case_work_dir,
			int time_out){
		Future<?> future_call_back = run_pool.submit(sys_call);
		String sys_call_key = case_id + "@" + queue_name;
		HashMap<String, Object> sys_call_value= new HashMap<String, Object>();
		sys_call_value.put("call_back", future_call_back);
		sys_call_value.put("queue_name", queue_name);
		sys_call_value.put("case_id", case_id);
		long start_time = System.currentTimeMillis()/1000;
		sys_call_value.put("start_time", start_time);
		sys_call_value.put("time_out", time_out);
		call_map.put(sys_call_key, sys_call_value);
	}
	
	public synchronized HashMap<String, HashMap<String, Object>> get_sys_call(){
		return this.call_map;
	}
	
	public synchronized Boolean remove_sys_call(String sys_call_key){
		Boolean remove_result = new Boolean(true);
		if (call_map.containsKey(sys_call_key)){
			call_map.remove(sys_call_key);
		} else {
			remove_result = false;
		}
		return remove_result;
	}
	
	public void shutdown_pool(){
		run_pool.shutdown();
	}
	

	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		//
	}
}