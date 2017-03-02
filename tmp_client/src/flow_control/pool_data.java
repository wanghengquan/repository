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
import java.util.concurrent.ConcurrentHashMap;
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
	private String line_seprator = System.getProperty("line.separator");	
	// public function
	// protected function
	// private function	
	private ExecutorService run_pool;
	private ConcurrentHashMap<String, HashMap<String, String>> call_map = new ConcurrentHashMap<String, HashMap<String, String>>();
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
	
	public synchronized void add_sys_call(Callable sys_call){
		Future future_call_back = run_pool.submit(sys_call);
		
		this.used_thread++;
	}
	
	public synchronized void get_sys_call_results(){
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