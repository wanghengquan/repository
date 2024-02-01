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
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.Vector;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import flow_control.queue_enum;
import utility_funcs.data_check;
import utility_funcs.deep_clone;

public class view_data {
	private ReadWriteLock rw_lock = new ReentrantReadWriteLock();
	private Boolean view_debug = Boolean.valueOf(false);
	private String current_watching_queue = new String("");
	private String request_watching_queue = new String("");
	private watch_enum current_watching_area = watch_enum.ALL;
	private watch_enum request_watching_area = watch_enum.ALL;
	private List<String> request_delete_queue = new ArrayList<String>();
	private HashMap<String, retest_enum> request_retest_area = new HashMap<String, retest_enum>();
	private HashMap<String, ArrayList<String>> request_retest_list = new HashMap<String, ArrayList<String>>();
	private HashMap<String, ArrayList<String>> request_terminate_list = new HashMap<String, ArrayList<String>>();
	private HashMap<String, queue_enum> run_action_request = new HashMap<String, queue_enum>();
	private List<String> export_queue_list = new ArrayList<String>();
	private List<String> export_title_list = new ArrayList<String>();
	private sort_enum rejected_sorting_request = sort_enum.DEFAULT;
	private sort_enum captured_sorting_request = sort_enum.DEFAULT;	
	private Boolean space_cleanup_apply = Boolean.valueOf(false);
	private Boolean environ_issue_apply = Boolean.valueOf(false);
	private Boolean corescript_update_apply = Boolean.valueOf(false);
	private Vector<Vector<String>> rejected_queue_data = new Vector<Vector<String>>();
	private Vector<Vector<String>> captured_queue_data = new Vector<Vector<String>>();
	private Vector<Vector<String>> watching_queue_data = new Vector<Vector<String>>();
	//following data not used
	private String select_rejected_queue_name = new String("");
	private String select_captured_queue_name = new String("");	
	private Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> watching_task_queues_data_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
	TreeMap<String, String> watching_reject_treemap = new TreeMap<String, String>(new queue_compare());
	TreeMap<String, String> watching_capture_treemap = new TreeMap<String, String>(new queue_compare());
	
	public view_data() {

	}
	
	public HashMap<String, String> get_database_info() {
		HashMap<String, String> result = new HashMap<String, String>();
		rw_lock.readLock().lock();
		try {
			result.put("view_debug", view_debug.toString());
			result.put("current_watching_queue", current_watching_queue);
			result.put("request_watching_queue", request_watching_queue);
			result.put("current_watching_area", current_watching_area.get_description());
			result.put("request_watching_area", request_watching_area.get_description());
			result.put("request_delete_queue", request_delete_queue.toString());
			result.put("request_retest_area", request_retest_area.toString());
			result.put("request_retest_list", request_retest_list.toString());
			result.put("request_terminate_list", request_terminate_list.toString());
			result.put("run_action_request", run_action_request.toString());
			result.put("export_queue_list", export_queue_list.toString());
			result.put("export_title_list", export_title_list.toString());
			result.put("rejected_sorting_request", rejected_sorting_request.get_description());
			result.put("captured_sorting_request", captured_sorting_request.get_description());
			result.put("space_cleanup_apply", space_cleanup_apply.toString());
			result.put("environ_issue_apply", environ_issue_apply.toString());
			result.put("corescript_update_apply", corescript_update_apply.toString());
			result.put("rejected_queue_data", rejected_queue_data.toString());
			result.put("captured_queue_data", captured_queue_data.toString());
			result.put("watching_queue_data", watching_queue_data.toString());
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
				String optin_value = update_data.get(ob_name);
				switch(ob_name) {
				case "view_debug":
					if (data_check.str_choice_check(optin_value, new String [] {"true", "false"} )){
						this.view_debug = Boolean.valueOf(optin_value);
						update_status.put(ob_name, "PASS");
					} else {
						update_status.put(ob_name, "FAIL, wrong input string, available value: true, false");
					}
					break;
				case "space_cleanup_apply":
					if (data_check.str_choice_check(optin_value, new String [] {"true", "false"} )){
						this.space_cleanup_apply = Boolean.valueOf(optin_value);
						update_status.put(ob_name, "PASS");
					} else {
						update_status.put(ob_name, "FAIL, wrong input string, available value: true, false");
					}
					break;					
				case "environ_issue_apply":
					if (data_check.str_choice_check(optin_value, new String [] {"true", "false"} )){
						this.environ_issue_apply = Boolean.valueOf(optin_value);
						update_status.put(ob_name, "PASS");
					} else {
						update_status.put(ob_name, "FAIL, wrong input string, available value: true, false");
					}
					break;
				case "corescript_update_apply":
					if (data_check.str_choice_check(optin_value, new String [] {"true", "false"} )){
						this.corescript_update_apply = Boolean.valueOf(optin_value);
						update_status.put(ob_name, "PASS");
					} else {
						update_status.put(ob_name, "FAIL, wrong input string, available value: true, false");
					}
					break;					
				default:
					update_status.put(ob_name, "FAIL, " + ob_name + " console update not supported yet.");
				}
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}	
	
	public Boolean get_view_debug() {
		rw_lock.readLock().lock();
		Boolean temp = Boolean.valueOf(false);
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
	
	public String get_current_watching_queue() {
		rw_lock.readLock().lock();
		String temp = new String();
		try {
			temp = current_watching_queue;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void set_current_watching_queue(String update_queue) {
		rw_lock.writeLock().lock();
		try {
			this.current_watching_queue = update_queue;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public String get_request_watching_queue() {
		rw_lock.readLock().lock();
		String temp = new String();
		try {
			temp = request_watching_queue;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void set_request_watching_queue(String update_queue) {
		rw_lock.writeLock().lock();
		try {
			this.request_watching_queue = update_queue;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public watch_enum get_current_watching_area() {
		rw_lock.readLock().lock();
		watch_enum temp = watch_enum.UNKNOWN;
		try {
			temp = current_watching_area;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_current_watching_area(watch_enum queue_area) {
		rw_lock.writeLock().lock();
		try {
			this.current_watching_area = queue_area;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public watch_enum get_request_watching_area() {
		rw_lock.readLock().lock();
		watch_enum temp = watch_enum.UNKNOWN;
		try {
			temp = request_watching_area;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_request_watching_area(watch_enum queue_area) {
		rw_lock.writeLock().lock();
		try {
			this.request_watching_area = queue_area;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public void add_request_delete_queue(String queue_name) {
		rw_lock.writeLock().lock();
		try {
			this.request_delete_queue.add(queue_name);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public List<String> impl_request_delete_queue() {
		List<String> delete_list = new ArrayList<String>();
		rw_lock.writeLock().lock();
		try {
			delete_list.addAll(request_delete_queue);
			this.request_delete_queue.clear();
		} finally {
			rw_lock.writeLock().unlock();
		}
		return delete_list;
	}
	
	public HashMap<String, retest_enum> impl_request_retest_area() {
		HashMap<String, retest_enum> request_list = new HashMap<String, retest_enum>();
		rw_lock.writeLock().lock();
		try {
			request_list.putAll(deep_clone.clone(request_retest_area));
			this.request_retest_area.clear();
		} finally {
			rw_lock.writeLock().unlock();
		}
		return request_list;
	}
	
	public void set_request_retest_area(HashMap<String, retest_enum> queue_area) {
		rw_lock.writeLock().lock();
		try {
			this.request_retest_area.clear();
			this.request_retest_area.putAll(queue_area);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public Boolean update_request_retest_area(
			String queue_name,
			retest_enum area) {
		rw_lock.writeLock().lock();
		Boolean update_result = Boolean.valueOf(true);
		try {
			request_retest_area.put(queue_name, area);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_result;
	}	
	
	public HashMap<String, ArrayList<String>> impl_request_retest_list() {
		HashMap<String, ArrayList<String>> request_list = new HashMap<String, ArrayList<String>>();
		rw_lock.writeLock().lock();
		try {
			request_list.putAll(deep_clone.clone(request_retest_list));
			this.request_retest_list.clear();
		} finally {
			rw_lock.writeLock().unlock();
		}
		return request_list;
	}
	
	public void set_request_retest_list(HashMap<String, ArrayList<String>> queue_case_list) {
		rw_lock.writeLock().lock();
		try {
			this.request_retest_list.clear();
			this.request_retest_list.putAll(queue_case_list);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public Boolean update_request_retest_list(
			String queue_name,
			ArrayList<String> case_list) {
		rw_lock.writeLock().lock();
		Boolean update_result = Boolean.valueOf(true);
		try {
			request_retest_list.put(queue_name, case_list);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_result;
	}	
	
	public HashMap<String, ArrayList<String>> impl_request_terminate_list() {
		HashMap<String, ArrayList<String>> request_list = new HashMap<String, ArrayList<String>>();
		rw_lock.writeLock().lock();
		try {
			request_list.putAll(deep_clone.clone(request_terminate_list));
			this.request_terminate_list.clear();
		} finally {
			rw_lock.writeLock().unlock();
		}
		return request_list;
	}
	
	public void set_request_terminate_list(HashMap<String, ArrayList<String>> queue_case_list) {
		rw_lock.writeLock().lock();
		try {
			this.request_terminate_list.clear();
			this.request_terminate_list.putAll(queue_case_list);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public Boolean update_request_terminate_list(
			String queue_name,
			ArrayList<String> case_list) {
		rw_lock.writeLock().lock();
		Boolean update_result = Boolean.valueOf(true);
		try {
			request_terminate_list.put(queue_name, case_list);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_result;
	}
	
	public HashMap<String, queue_enum> impl_run_action_request() {
		HashMap<String, queue_enum> request_list = new HashMap<String, queue_enum>();
		rw_lock.writeLock().lock();
		try {
			request_list.putAll(deep_clone.clone(run_action_request));
			this.run_action_request.clear();
		} finally {
			rw_lock.writeLock().unlock();
		}
		return request_list;
	}
	
	public void set_run_action_request(HashMap<String, queue_enum> queue_action) {
		rw_lock.writeLock().lock();
		try {
			this.run_action_request.clear();
			this.run_action_request.putAll(queue_action);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public Boolean update_run_action_request(
			String queue_name,
			queue_enum action) {
		rw_lock.writeLock().lock();
		Boolean update_result = Boolean.valueOf(true);
		try {
			run_action_request.put(queue_name, action);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_result;
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
	
	/*
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

	public void set_select_task_case1(List<String> case_list) {
		rw_lock.writeLock().lock();
		try {
			this.select_task_case.clear();
			this.select_task_case.addAll(case_list);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	*/
	
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
		Boolean remove_result = Boolean.valueOf(false);
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
		Boolean temp = Boolean.valueOf(false);
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
	
	//environ_issue_dialog
	public Boolean get_environ_issue_apply() {
		rw_lock.readLock().lock();
		Boolean temp = Boolean.valueOf(false);
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
	
	//core script update issue
	public Boolean get_corescript_update_apply() {
		rw_lock.readLock().lock();
		Boolean temp = Boolean.valueOf(false);
		try {
			temp = corescript_update_apply;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_corescript_update_apply(Boolean new_data) {
		rw_lock.writeLock().lock();
		try {
			corescript_update_apply = new_data;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public Vector<Vector<String>> get_rejected_queue_data() {
		rw_lock.readLock().lock();
		Vector<Vector<String>> temp = new Vector<Vector<String>>();
		try {
			temp.addAll(rejected_queue_data);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void set_rejected_queue_data(Vector<Vector<String>> new_data) {
		rw_lock.writeLock().lock();
		try {
			rejected_queue_data.clear();
			rejected_queue_data.addAll(new_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public Vector<Vector<String>> get_captured_queue_data() {
		rw_lock.readLock().lock();
		Vector<Vector<String>> temp = new Vector<Vector<String>>();
		try {
			temp.addAll(this.captured_queue_data);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void set_captured_queue_data(Vector<Vector<String>> new_data) {
		rw_lock.writeLock().lock();
		try {
			captured_queue_data.clear();
			captured_queue_data.addAll(new_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public Vector<Vector<String>> get_watching_queue_data() {
		rw_lock.readLock().lock();
		Vector<Vector<String>> temp = new Vector<Vector<String>>();
		try {
			temp.addAll(this.watching_queue_data);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void set_watching_queue_data(Vector<Vector<String>> new_data) {
		rw_lock.writeLock().lock();
		try {
			watching_queue_data.clear();
			watching_queue_data.addAll(new_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void set_watching_queue_data_default() {
		rw_lock.writeLock().lock();
		try {
			watching_queue_data.clear();
			Vector<Vector<String>> new_data = new Vector<Vector<String>>();
			Vector<String> add_line = new Vector<String>();
			add_line.add("No data found.");
			add_line.add("..");
			add_line.add("..");
			add_line.add("..");
			add_line.add("..");
			add_line.add("..");
			add_line.add("..");
			new_data.add(add_line);
			watching_queue_data.addAll(new_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

}