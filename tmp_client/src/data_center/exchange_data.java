/*
 * File: public_data.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package data_center;

import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class exchange_data {
	// public property
	// protected property
	// private property
	private static final Logger EXCHANGE_LOGGER = LogManager.getLogger(exchange_data.class.getName());
	private ReadWriteLock rw_lock = new ReentrantReadWriteLock();
	// configuration static variables
	// config_sync  --> other
	private int config_update_announce = 0;
	// other --> config_sync
	private int config_save_request = 0;

	// public function
	public exchange_data(){
		
	}
	
	public void set_config_update_announce(int new_data){
		rw_lock.writeLock().lock();
		try{
			this.config_update_announce = new_data;
		} finally{
			rw_lock.writeLock().unlock();
		}
	}
	
	public int get_config_update_announce(){
		rw_lock.readLock().lock();
		int value = 0;
		try{
			value = this.config_update_announce;
		} finally{
			rw_lock.readLock().unlock();
		}
		return value;
	}
	
	public void set_config_save_request(int new_data){
		rw_lock.writeLock().lock();
		try{
			this.config_save_request = new_data;
		} finally{
			rw_lock.writeLock().unlock();
		}
	}
	
	public int get_config_save_request(){
		rw_lock.readLock().lock();
		int value = 0;
		try{
			value = this.config_save_request;
		} finally{
			rw_lock.readLock().unlock();
		}
		return value;
	}	
	// protected function
	// private function	
	
}