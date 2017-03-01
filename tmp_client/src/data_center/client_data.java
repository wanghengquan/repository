/*
 * File: tube_data.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package data_center;

import java.util.HashMap;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


public class client_data {
	// public property
	// {queue_name: {case_id_or_title: {}}}	
	// protected property
	// private property
	private static final Logger CLIENT_DATA_LOGGER = LogManager.getLogger(client_data.class.getName());
	private ReadWriteLock rw_lock = new ReentrantReadWriteLock();
	public HashMap<String, HashMap<String, String>> client_hash = new HashMap<String, HashMap<String, String>>();
	public HashMap<String, Integer> max_soft_insts = new HashMap<String, Integer>();
	public HashMap<String, Integer> use_soft_insts = new HashMap<String, Integer>();
	// public function
	// protected function
	// private function
	
	public client_data() {
		
	}

	public HashMap<String, HashMap<String, String>> get_client_data(){
		rw_lock.readLock().lock();
		HashMap<String, HashMap<String, String>> temp = new HashMap<String, HashMap<String, String>>();
		try{
			temp = client_hash;
		} finally{
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void set_client_data(HashMap<String, HashMap<String, String>> update_data){
		rw_lock.writeLock().lock();
		try{
			client_hash.clear();
			client_hash.putAll(update_data);
		} finally{
			rw_lock.writeLock().unlock();
		}
	}
	
	public HashMap<String, Integer> get_max_soft_insts(){
		rw_lock.readLock().lock();
		HashMap<String, Integer> temp = new HashMap<String, Integer>();
		try{
			temp = max_soft_insts;
		} finally{
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void set_max_soft_insts(HashMap<String, Integer> update_data){
		rw_lock.writeLock().lock();
		try{
			max_soft_insts.clear();
			max_soft_insts.putAll(update_data);
		} finally{
			rw_lock.writeLock().unlock();
		}
	}	
	
	public HashMap<String, Integer> get_use_soft_insts(){
		rw_lock.readLock().lock();
		HashMap<String, Integer> temp = new HashMap<String, Integer>();
		try{
			temp = use_soft_insts;
		} finally{
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void set_use_soft_insts(HashMap<String, Integer> update_data){
		rw_lock.writeLock().lock();
		try{
			use_soft_insts.clear();
			use_soft_insts.putAll(update_data);
		} finally{
			rw_lock.writeLock().unlock();
		}
	}	
	
	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		CLIENT_DATA_LOGGER.warn("Share data");
	}
}