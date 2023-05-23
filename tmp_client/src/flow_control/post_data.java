/*
 * File: tube_data.java
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
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.public_data;
import utility_funcs.postrun_call;


public class post_data {
	// public property
	// {queue_name: {case_id_or_title: {}}}
	// protected property
	// private property
	private static final Logger CLEANUP_DATA_LOGGER = LogManager.getLogger(post_data.class.getName());
	private ReadWriteLock rw_lock = new ReentrantReadWriteLock();
	private ExecutorService postrun_pool = Executors.newSingleThreadExecutor(); 
	private HashMap<String, HashMap<post_attr, Object>> call_map = new HashMap<String, HashMap<post_attr, Object>>();
	// public function
	// protected function
	// private function

	public post_data() {
		
	}
	
	public HashMap<String, String> get_database_info() {
		HashMap<String, String> result = new HashMap<String, String>();
		rw_lock.readLock().lock();
		try {
			result.put("call_map", call_map.toString());
		} finally {
			rw_lock.readLock().unlock();
		}
		return result;
	}
	
	public HashMap<String, String> console_database_update(
			HashMap<String, String> update_data
			) {
		rw_lock.writeLock().lock();
		HashMap<String, String> update_status = new HashMap<String, String>();
		try {
			Iterator<String> update_it = update_data.keySet().iterator();
			while (update_it.hasNext()) {
				String ob_name = update_it.next();
				update_status.put(ob_name, "FAIL, " + ob_name + " console update not supported yet.");
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}
	
	public HashMap<String, HashMap<post_attr, Object>> get_postrun_call_link() {
		rw_lock.readLock().lock();
		HashMap<String, HashMap<post_attr, Object>> call_data = new HashMap<String, HashMap<post_attr, Object>>();
		try {
			call_data = this.call_map;
		} finally {
			rw_lock.readLock().unlock();
		}
		return call_data;
	}	
	
	public HashMap<String, HashMap<post_attr, Object>> get_postrun_call_copy() {
		rw_lock.readLock().lock();
		HashMap<String, HashMap<post_attr, Object>> call_data = new HashMap<String, HashMap<post_attr, Object>>();
		try {
			Iterator<String> call_map_it = call_map.keySet().iterator();
			while (call_map_it.hasNext()) {
				String call_index = call_map_it.next();
				HashMap<post_attr, Object> one_call_data = call_map.get(call_index);
				HashMap<post_attr, Object> return_data = new HashMap<post_attr, Object>();
				Iterator<post_attr> one_call_it = one_call_data.keySet().iterator();
				while (one_call_it.hasNext()){
					post_attr call_key = one_call_it.next();
					if (call_key.equals(post_attr.call_back)){
						continue;
					}
					return_data.put(call_key, one_call_data.get(call_key));
				}
				call_data.put(call_index, return_data);
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return call_data;
	}
	
	public Boolean add_postrun_call(
			postrun_call call_obj,
			String queue_name, 
			String case_id, 			
			int time_out) {
		rw_lock.writeLock().lock();
		Boolean update_status = Boolean.valueOf(true);
		try {
			if (call_map.size() > public_data.DEF_CLEANUP_QUEUE_SIZE){
				CLEANUP_DATA_LOGGER.warn("Cleanup queue: No more cleanup task available, current task size is:" + public_data.DEF_CLEANUP_QUEUE_SIZE);
				update_status = false;
			} else {
				Future<?> call_back = postrun_pool.submit(call_obj);
				String call_key = case_id + "#" + queue_name;
				HashMap<post_attr, Object> call_data = new HashMap<post_attr, Object>();
				call_data.put(post_attr.call_back, call_back);
				call_data.put(post_attr.call_id, call_key);
				call_data.put(post_attr.call_case, case_id);
				call_data.put(post_attr.call_queue, queue_name);
				call_data.put(post_attr.call_obj, call_obj);
				call_data.put(post_attr.call_reqtime, time_out);
				call_data.put(post_attr.call_gentime, System.currentTimeMillis() / 1000);
				call_data.put(post_attr.call_lautime, 0);
				call_data.put(post_attr.call_canceled, false);
				call_data.put(post_attr.call_timeout, false);
				call_data.put(post_attr.call_terminate, false);
				call_data.put(post_attr.call_status, call_state.INITIATE);
				call_data.put(post_attr.call_rptdir, call_obj.get_report_path());
				call_data.put(post_attr.call_message, new ArrayList<String>());
				call_map.put(call_key, call_data);
				CLEANUP_DATA_LOGGER.info("Cleanup call added for: " + call_key);				
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}	
	
	public void fresh_postrun_call() {
		rw_lock.writeLock().lock();
		try {
			Iterator<String> call_map_it = call_map.keySet().iterator();
			while (call_map_it.hasNext()) {
				String call_index = call_map_it.next();
				HashMap<post_attr, Object> hash_data = call_map.get(call_index);
				// put call_status
				Future<?> call_back = (Future<?>) hash_data.get(post_attr.call_back);
				long current_time = System.currentTimeMillis() / 1000;
				postrun_call call_obj = (postrun_call) hash_data.get(post_attr.call_obj);
				long obj_launch_time = call_obj.get_start_time();
				int time_out = (int) hash_data.get(post_attr.call_reqtime);
				// task not started
				if (obj_launch_time == 0){
					continue;
				} else {
					hash_data.put(post_attr.call_lautime, obj_launch_time);
				}
				if (current_time - obj_launch_time > time_out) {
					CLEANUP_DATA_LOGGER.warn("Cleanup call timeout: " + call_index);
					hash_data.put(post_attr.call_timeout, true);
					hash_data.put(post_attr.call_canceled, call_back.cancel(true));
				}
				// run report action
				Boolean call_done = call_back.isDone();
				if (call_done) {
					hash_data.put(post_attr.call_status, call_state.DONE);
					hash_data.put(post_attr.call_message, call_obj.run_msg);
				} else {
					hash_data.put(post_attr.call_status, call_state.PROCESSIONG);
				}
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public Boolean remove_postrun_call(
			String call_key) {
		rw_lock.writeLock().lock();
		Boolean remove_result = Boolean.valueOf(true);
		try {
			if (call_map.containsKey(call_key)) {
				call_map.remove(call_key);
			} else {
				remove_result = false;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return remove_result;
	}
	
	public int get_postrun_call_size() {
		rw_lock.writeLock().lock();
		int temp = 0;
		try {
			temp = call_map.size();
		} finally {
			rw_lock.writeLock().unlock();
		}
		return temp;
	}
}