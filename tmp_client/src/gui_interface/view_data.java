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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import flow_control.queue_enum;

public class view_data {
	private ReadWriteLock rw_lock = new ReentrantReadWriteLock();
	private Boolean view_debug = new Boolean(false);
	private String watching_queue = new String();
	private watch_enum watching_queue_area = watch_enum.UNKNOWN;
	private retest_enum retest_queue_area = retest_enum.UNKNOWN;
	private int stop_case_request = 0;
	private List<String> delete_request_queue = new ArrayList<String>();
	private String select_rejected_queue_name = new String();
	private String select_captured_queue_name = new String();
	private queue_enum select_captured_queue_status = queue_enum.UNKNOWN;
	private List<String> select_task_case = new ArrayList<String>();
	private List<String> export_queue_list = new ArrayList<String>();
	private List<String> export_title_list = new ArrayList<String>();
	private queue_enum run_action_request = queue_enum.UNKNOWN;//play, pause, stop
	private sort_enum rejected_sorting_request = sort_enum.DEFAULT;
	private sort_enum captured_sorting_request = sort_enum.DEFAULT;
	private Boolean space_cleanup_apply = new Boolean(false);
	private Boolean environ_issue_apply = new Boolean(false);
	//following data not used currently
	private Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> watching_task_queues_data_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
	TreeMap<String, String> watching_reject_treemap = new TreeMap<String, String>(new queue_compare());
	TreeMap<String, String> watching_capture_treemap = new TreeMap<String, String>(new queue_compare());
	
	public view_data() {

	}
	
	public Boolean get_view_debug() {
		rw_lock.readLock().lock();
		Boolean temp = new Boolean(false);
		try {
			temp = view_debug;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void set_view_debug(Boolean debug_value) {
		rw_lock.writeLock().lock();
		try {
			this.view_debug = debug_value;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public String get_watching_queue() {
		rw_lock.readLock().lock();
		String temp = new String();
		try {
			temp = watching_queue;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void set_watching_queue(String update_queue) {
		rw_lock.writeLock().lock();
		try {
			this.watching_queue = update_queue;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public watch_enum get_watching_queue_area() {
		rw_lock.readLock().lock();
		watch_enum temp = watch_enum.UNKNOWN;
		try {
			temp = watching_queue_area;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_watching_queue_area(watch_enum queue_area) {
		rw_lock.writeLock().lock();
		try {
			this.watching_queue_area = queue_area;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public retest_enum get_retest_queue_area() {
		rw_lock.readLock().lock();
		retest_enum temp = retest_enum.UNKNOWN;
		try {
			temp = retest_queue_area;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_retest_queue_area(retest_enum queue_area) {
		rw_lock.writeLock().lock();
		try {
			this.retest_queue_area = queue_area;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public retest_enum impl_retest_queue_area() {
		rw_lock.writeLock().lock();
		retest_enum impl_area = retest_enum.UNKNOWN;
		try {
			impl_area = retest_queue_area;
			this.retest_queue_area = retest_enum.UNKNOWN;
		} finally {
			rw_lock.writeLock().unlock();
		}
		return impl_area;
	}	
	
	public void set_stop_case_request() {
		rw_lock.writeLock().lock();
		try {
			this.stop_case_request = stop_case_request + 1;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public Boolean impl_stop_case_request() {
		rw_lock.writeLock().lock();
		Boolean stop_request = new Boolean(false);
		try {
			if (stop_case_request > 0){
				stop_request = true;
				stop_case_request = stop_case_request - 1;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return stop_request;
	}
	
	public int get_stop_case_request() {
		rw_lock.readLock().lock();
		int stop_request = 0;
		try {
			stop_request = stop_case_request;
		} finally {
			rw_lock.readLock().unlock();
		}
		return stop_request;
	}

	public void add_delete_request_queue(String queue_name) {
		rw_lock.writeLock().lock();
		try {
			this.delete_request_queue.add(queue_name);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public List<String> impl_delete_request_queue() {
		List<String> delete_list = new ArrayList<String>();
		rw_lock.writeLock().lock();
		try {
			delete_list.addAll(delete_request_queue);
			this.delete_request_queue.clear();
		} finally {
			rw_lock.writeLock().unlock();
		}
		return delete_list;
	}
	
	public String get_select_rejected_queue_name() {
		rw_lock.readLock().lock();
		String temp = new String();
		try {
			temp = select_rejected_queue_name;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_select_rejected_queue_name(String queue_name) {
		rw_lock.writeLock().lock();
		try {
			this.select_rejected_queue_name = queue_name;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public String get_select_captured_queue_name() {
		rw_lock.readLock().lock();
		String temp = new String();
		try {
			temp = select_captured_queue_name;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_select_captured_queue_name(String queue_name) {
		rw_lock.writeLock().lock();
		try {
			this.select_captured_queue_name = queue_name;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public queue_enum get_select_captured_queue_status() {
		rw_lock.readLock().lock();
		queue_enum temp = queue_enum.UNKNOWN;
		try {
			temp = select_captured_queue_status;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}	
	
	public void set_select_captured_queue_status(queue_enum queue_status) {
		rw_lock.writeLock().lock();
		try {
			this.select_captured_queue_status = queue_status;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public List<String> get_select_task_case() {
		rw_lock.readLock().lock();
		List<String> temp = new ArrayList<String>();
		try {
			temp.addAll(this.select_task_case);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_select_task_case(List<String> case_list) {
		rw_lock.writeLock().lock();
		try {
			this.select_task_case.clear();
			this.select_task_case.addAll(case_list);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public List<String> get_export_title_list() {
		rw_lock.readLock().lock();
		List<String> temp = new ArrayList<String>();
		try {
			temp.addAll(this.export_title_list);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void set_export_title_list(List<String> title_list) {
		rw_lock.writeLock().lock();
		try {
			this.export_title_list.clear();
			this.export_title_list.addAll(title_list);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void add_export_title_list(String title) {
		rw_lock.writeLock().lock();
		try {
			if(!export_title_list.contains(title)){
				this.export_title_list.add(title);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void remove_export_title_list(String title) {
		rw_lock.writeLock().lock();
		try {
			if(export_title_list.contains(title)){
				this.export_title_list.remove(title);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public List<String> get_export_queue_list() {
		rw_lock.readLock().lock();
		List<String> temp = new ArrayList<String>();
		try {
			temp.addAll(this.export_queue_list);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_export_queue_list(List<String> queue_list) {
		rw_lock.writeLock().lock();
		try {
			this.export_queue_list.clear();
			this.export_queue_list.addAll(queue_list);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void add_export_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		try {
			if (!export_queue_list.contains(queue_name)){
				this.export_queue_list.add(queue_name);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void remove_export_queue_list(String queue_name) {
		rw_lock.writeLock().lock();
		try {
			if (export_queue_list.contains(queue_name)){
				this.export_queue_list.remove(queue_name);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void set_run_action_request(queue_enum request_action) {
		rw_lock.writeLock().lock();
		try {
			this.run_action_request = request_action;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public queue_enum impl_run_action_request() {
		rw_lock.writeLock().lock();
		queue_enum impl_action = queue_enum.UNKNOWN;
		try {
			impl_action = run_action_request;
			this.run_action_request = queue_enum.UNKNOWN;
		} finally {
			rw_lock.writeLock().unlock();
		}
		return impl_action;
	}
	
	public void set_rejected_sorting_request(sort_enum sort_request) {
		rw_lock.writeLock().lock();
		try {
			this.rejected_sorting_request = sort_request;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public sort_enum get_rejected_sorting_request() {
		rw_lock.readLock().lock();
		sort_enum temp = sort_enum.DEFAULT;
		try {
			temp = rejected_sorting_request;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void set_captured_sorting_request(sort_enum sort_request) {
		rw_lock.writeLock().lock();
		try {
			this.captured_sorting_request = sort_request;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	

	public sort_enum get_captured_sorting_request() {
		rw_lock.readLock().lock();
		sort_enum temp = sort_enum.DEFAULT;
		try {
			temp = captured_sorting_request;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> get_watching_task_queues_data_map() {
		rw_lock.readLock().lock();
		Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> queues_data = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
		try {
			queues_data.putAll(watching_task_queues_data_map);
		} finally {
			rw_lock.readLock().unlock();
		}
		return queues_data;
	}	
	
	public TreeMap<String, HashMap<String, HashMap<String, String>>> get_queue_from_watching_task_queues_data_map(String queue_name) {
		rw_lock.readLock().lock();
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			if (watching_task_queues_data_map.containsKey(queue_name)){
				queue_data.putAll(this.watching_task_queues_data_map.get(queue_name));
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return queue_data;
	}

	public void update_case_to_watching_task_queues_data_map(String queue_name, String case_id, HashMap<String, HashMap<String, String>> case_data) {
		rw_lock.writeLock().lock();
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			if (watching_task_queues_data_map.containsKey(queue_name)){
				queue_data.putAll(watching_task_queues_data_map.get(queue_name));
			}
			queue_data.put(case_id, case_data);
			watching_task_queues_data_map.put(queue_name, queue_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_queue_data_to_watching_task_queues_data_map(String queue_name, TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data) {
		rw_lock.writeLock().lock();
		try {
			watching_task_queues_data_map.put(queue_name, queue_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void clear_watching_task_queues_data_map() {
		rw_lock.writeLock().lock();
		try {
			watching_task_queues_data_map.clear();
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public Boolean remove_case_from_watching_task_queues_data_map(String queue_name, String case_id) {
		Boolean remove_result = new Boolean(false);
		rw_lock.writeLock().lock();
		try {
			if (watching_task_queues_data_map.containsKey(queue_name)){
				if(watching_task_queues_data_map.get(queue_name).containsKey(case_id)){
					watching_task_queues_data_map.get(queue_name).remove(case_id);
					remove_result = true;
				}
			} 
		} finally {
			rw_lock.writeLock().unlock();
		}
		return remove_result;
	}
	
	public HashMap<String, HashMap<String, String>> get_case_from_watching_task_queues_data_map(String queue_name, String case_id) {
		HashMap<String, HashMap<String, String>> case_data = new HashMap<String, HashMap<String, String>>();
		rw_lock.writeLock().lock();
		try {
			if (watching_task_queues_data_map.containsKey(queue_name)){
				if(watching_task_queues_data_map.get(queue_name).containsKey(case_id)){
					case_data.putAll(watching_task_queues_data_map.get(queue_name).get(case_id));
				}
			} 
		} finally {
			rw_lock.writeLock().unlock();
		}
		return case_data;
	}	
	
	public TreeMap<String, String> get_watching_reject_treemap(){
		rw_lock.readLock().lock();
		TreeMap<String, String> temp = new TreeMap<String, String>();
		try {
			temp.putAll(watching_reject_treemap);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void add_watching_reject_treemap(String queue_name, String reason){
		rw_lock.writeLock().lock();
		try {
			watching_reject_treemap.put(queue_name, reason);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public TreeMap<String, String> get_watching_capture_treemap(){
		rw_lock.readLock().lock();
		TreeMap<String, String> temp = new TreeMap<String, String>();
		try {
			temp.putAll(watching_capture_treemap);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void add_watching_capture_treemap(String queue_name, String status){
		rw_lock.writeLock().lock();
		try {
			watching_capture_treemap.put(queue_name, status);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	//space_cleanup_dialog
	public Boolean get_space_cleanup_apply() {
		rw_lock.readLock().lock();
		Boolean temp = new Boolean(false);
		try {
			temp = space_cleanup_apply;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_space_cleanup_apply(Boolean new_data) {
		rw_lock.writeLock().lock();
		try {
			space_cleanup_apply = new_data;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	//space_cleanup_dialog
	public Boolean get_environ_issue_apply() {
		rw_lock.readLock().lock();
		Boolean temp = new Boolean(false);
		try {
			temp = environ_issue_apply;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_environ_issue_apply(Boolean new_data) {
		rw_lock.writeLock().lock();
		try {
			environ_issue_apply = new_data;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
}