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



public class thread_pool{
	// public property
	// protected property
	// private property
	private static final Logger POOL_LOGGER = LogManager.getLogger(thread_pool.class.getName());
	private String line_seprator = System.getProperty("line.separator");	
	// public function
	// protected function
	// private function	
	private ExecutorService run_pool;
	private ConcurrentHashMap<String, HashMap<String, String>> call_map;
	private int used_thread = 0;
	
	public thread_pool(int pool_size){
		run_pool = Executors.newFixedThreadPool(pool_size);
		call_map = new ConcurrentHashMap<String, HashMap<String, String>>();
	}
	
	public synchronized int get_used_size(){
		return used_thread;
	}

	public synchronized void set_used_size(int new_int){
		this.used_thread = new_int;
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