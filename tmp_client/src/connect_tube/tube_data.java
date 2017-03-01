/*
 * File: tube_data.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package connect_tube;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class tube_data {
	// public property
	// {queue_name: {case_id_or_title: {}}}	
	// protected property
	// private property
	private Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> task_queues_data = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
	private static final Logger TUBE_LOGGER = LogManager.getLogger(tube_data.class.getName());
	private ReadWriteLock rw_lock = new ReentrantReadWriteLock();
	// public function
	// protected function
	// private function
	private ArrayList<String> running_admin_queue = new ArrayList<String>();
	private ArrayList<String> finished_admin_queue = new ArrayList<String>();

	public tube_data() {
		
	}
	
	public ArrayList<String> get_running_admin_queue(){
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try{
			temp = this.running_admin_queue;
		} finally{
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void set_running_admin_queue(ArrayList<String> update_data){
		rw_lock.writeLock().lock();
		try{
			this.running_admin_queue.clear();
			this.running_admin_queue.addAll(update_data);
		} finally{
			rw_lock.writeLock().unlock();
		}
	}
	
	public ArrayList<String> get_finished_admin_queue(){
		rw_lock.readLock().lock();
		ArrayList<String> temp = new ArrayList<String>();
		try{
			temp = this.finished_admin_queue;
		} finally{
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void set_finished_admin_queue(ArrayList<String> update_data){
		rw_lock.writeLock().lock();
		try{
			this.finished_admin_queue.clear();
			this.finished_admin_queue.addAll(update_data);
		} finally{
			rw_lock.writeLock().unlock();
		}
	}
	
	/*
	 * main entry for test
	 */
	public static void main(String[] args) {

	}
}