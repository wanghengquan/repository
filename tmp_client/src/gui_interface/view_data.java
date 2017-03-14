/*
 * File: tube_data.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package gui_interface;

import java.util.List;
import java.util.Vector;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

public class view_data {
	private ReadWriteLock rw_lock = new ReentrantReadWriteLock();
	private Vector<List<String>> work_data = new Vector<List<String>>();
	private Vector<List<String>> reject_data = new Vector<List<String>>();
	private Vector<List<String>> capture_data = new Vector<List<String>>();

	public view_data() {

	}
	
	public Vector<List<String>> get_work_data() {
		rw_lock.readLock().lock();
		Vector<List<String>> temp = new Vector<List<String>>();
		try {
			temp.addAll(work_data);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_work_data(Vector<List<String>> update_data) {
		rw_lock.writeLock().lock();
		try {
			work_data.clear();
			work_data.addAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void add_work_data(List<String> add_list) {
		rw_lock.writeLock().lock();
		try {
			work_data.add(add_list);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public Vector<List<String>> get_reject_data() {
		rw_lock.readLock().lock();
		Vector<List<String>> temp = new Vector<List<String>>();
		try {
			temp.addAll(reject_data);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_reject_data(Vector<List<String>> update_data) {
		rw_lock.writeLock().lock();
		try {
			reject_data.clear();
			reject_data.addAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void add_reject_data(List<String> add_list) {
		rw_lock.writeLock().lock();
		try {
			reject_data.add(add_list);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public Vector<List<String>> get_capture_data() {
		rw_lock.readLock().lock();
		Vector<List<String>> temp = new Vector<List<String>>();
		try {
			temp.addAll(capture_data);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_capture_data(Vector<List<String>> update_data) {
		rw_lock.writeLock().lock();
		try {
			capture_data.clear();
			capture_data.addAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void add_capture_data(List<String> add_list) {
		rw_lock.writeLock().lock();
		try {
			capture_data.add(add_list);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
}