/*
 * File: view_server.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package gui_interface;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.Vector;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.dom4j.DocumentException;

import connect_tube.task_data;
import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;
import info_parser.xml_parser;

public class view_server extends Thread {
	// public property
	// protected property
	// private property
	private static final Logger VIEW_SERVER_LOGGER = LogManager.getLogger(view_server.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread client_thread;
	private view_data view_info;
	private task_data task_info;
	private switch_data switch_info;
	private client_data client_info;
	// private String line_seprator = System.getProperty("line.separator");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;
	// public function
	// protected function
	// private function

	public view_server(switch_data switch_info, client_data client_info,task_data task_info, view_data view_info) {
		this.switch_info = switch_info;	
		this.task_info = task_info;
		this.view_info = view_info;
		this.client_info = client_info;
	}

    private Boolean update_rejected_queue_table(){
    	Boolean show_update = new Boolean(false);
    	ArrayList<String> reject_list = task_info.get_rejected_admin_queue_list();// source data
    	TreeMap<String, String> watching_treemap = view_info.get_watching_reject_treemap(); //record data
    	//Vector<List<String>> reject_data = view_info.get_reject_data(); //show data
    	for(String queue_name : reject_list){
    		if(watching_treemap.containsKey(queue_name)){
    			continue;
    		}
    		String reject_reason = new String("machine");//need to replace later
    		// add watching recording
    		view_info.add_watching_reject_treemap(queue_name, reject_reason);
    		// add watching vector
    		Vector<String> show_line = new Vector<String>();
    		show_line.add(queue_name);
    		show_line.add(reject_reason);
    		view_info.add_reject_data(show_line);
    		show_update = true;
    	}
    	return show_update;
    }
	
    private Boolean update_captured_queue_table(){
    	Boolean show_update = new Boolean(false);
    	ArrayList<String> captured_list = new ArrayList<String>();
    	captured_list.addAll(task_info.get_captured_admin_queue_list());// source data
    	captured_list.addAll(task_info.get_finished_admin_queue_list());// source data
    	TreeMap<String, String> watching_treemap = view_info.get_watching_capture_treemap(); //record data
    	//Vector<List<String>> reject_data = view_info.get_reject_data(); //show data
    	for(String queue_name : captured_list){
    		if(watching_treemap.containsKey(queue_name)){
    			continue;
    		}
    		String status = new String("processing");//need to replace later
    		// add watching recording
    		view_info.add_watching_capture_treemap(queue_name, status);
    		// add watching vector
    		Vector<String> show_line = new Vector<String>();
    		show_line.add(queue_name);
    		show_line.add(status);
    		view_info.add_capture_data(show_line);
    		show_update = true;
    	}
    	return show_update;
    }	
    
    private void add_case_to_work_data_and_watching_data(
    		String queue_name,
    		TreeMap<String, HashMap<String, HashMap<String, String>>> watching_task_queue_data_map,
    		TreeMap<String, HashMap<String, HashMap<String, String>>> processed_task_queue_data_map){
    	Iterator<String> processed_task_queue_case = processed_task_queue_data_map.keySet().iterator();
    	while(processed_task_queue_case.hasNext()){
			String case_id = processed_task_queue_case.next();
			if (watching_task_queue_data_map.containsKey(case_id)){
				continue;
			} else {
				HashMap<String, HashMap<String, String>> design_data = processed_task_queue_data_map.get(case_id);
				Vector<String> add_line = new Vector<String>();
				if(processed_task_queue_data_map.get("ID").containsKey("id")){
					add_line.add(design_data.get("ID").get("id"));
				} else {
					add_line.add("NA");
				}
				if(processed_task_queue_data_map.get("ID").containsKey("suite")){
					add_line.add(design_data.get("ID").get("suite"));
				} else {
					add_line.add("NA");
				}
				if(processed_task_queue_data_map.get("CaseInfo").containsKey("design_name")){
					add_line.add(design_data.get("CaseInfo").get("design_name"));
				} else {
					add_line.add("NA");
				}
				if(processed_task_queue_data_map.get("Status").containsKey("cmd_status")){
					add_line.add(design_data.get("Status").get("cmd_status"));
				} else {
					add_line.add("NA");
				}
				if(processed_task_queue_data_map.get("Status").containsKey("reason")){
					add_line.add(design_data.get("Status").get("reason"));
				} else {
					add_line.add("NA");
				}	
				if(processed_task_queue_data_map.get("Status").containsKey("run_time")){
					add_line.add(design_data.get("Status").get("run_time"));
				} else {
					add_line.add("NA");
				}
				view_info.add_work_data(add_line);
				view_info.update_case_to_watching_task_queues_data_map(queue_name, case_id, design_data);
			}    			
		}
    }
    
    private Boolean import_queue_data_to_processed_data(String import_queue){
    	Boolean import_status = new Boolean(false);
    	String work_path = client_info.get_client_data().get("base").get("work_path");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		File log_path = new File(work_path + "/" + log_folder + "/" + import_queue + ".xml");
		if (!log_path.exists()){
			return import_status;
		}
		xml_parser file_parser = new xml_parser();
		TreeMap<String, HashMap<String, HashMap<String, String>>> import_queue_data = null;
		try {
			import_queue_data = file_parser.get_xml_file_task_queue_data(log_path.getAbsolutePath().replaceAll("\\\\", "/"));
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
			VIEW_SERVER_LOGGER.warn("Import xml data failed:" + log_path.getAbsolutePath());
			return import_status;
		}
		task_info.update_queue_data_to_processed_task_queues_data_map(import_queue, import_queue_data);
		import_status = true;
    	return import_status;
    }
    
    private Boolean update_working_queue_table(){
    	Boolean show_update = new Boolean(false);
    	String watching_request = view_info.get_watching_request();
    	Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> watching_task_queues_data_map = view_info.get_watching_task_queues_data_map();
    	if (!task_info.get_processed_task_queues_data_map().containsKey(watching_request)){
    		Boolean import_status = import_queue_data_to_processed_data(watching_request);
    		if (!import_status){
    			return show_update; //no update
    		}
    	}
    	TreeMap<String, HashMap<String, HashMap<String, String>>> processed_task_queue_data_map = task_info.get_queue_from_processed_task_queues_data_map(watching_request);
    	if (watching_task_queues_data_map.containsKey(watching_request)){
    		//check update add new data for both watching task queues and show table_data
    		add_case_to_work_data_and_watching_data(watching_request, watching_task_queues_data_map.get(watching_request), processed_task_queue_data_map);
    		show_update = true;
    	} else {
    		//new queue request
    		view_info.clear_watching_task_queues_data_map();
    		TreeMap<String, HashMap<String, HashMap<String, String>>> new_watching_data_map = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
    		add_case_to_work_data_and_watching_data(watching_request, new_watching_data_map, processed_task_queue_data_map);
    		show_update = true;
    	}
    	return show_update;
    }
    
	public void run() {
		try {
			monitor_run();
		} catch (Exception run_exception) {
			run_exception.printStackTrace();
			System.exit(1);
		}
	}

	private void monitor_run() {
		client_thread = Thread.currentThread();
		// ============== All static job start from here ==============
		// initial 1 : start GUI
		main_frame top_view = new main_frame(switch_info, view_info);
		// loop start
		while (!stop_request) {
			if (wait_request) {
				try {
					synchronized (this) {
						this.wait();
					}
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} else {
				VIEW_SERVER_LOGGER.debug("view_server Thread running...");
			}
			// ============== All dynamic job start from here ==============
			// task 1: update rejected queue table		
			if(update_rejected_queue_table()){
				view_info.get_reject_table().updateUI();
			}
			// task 2: update captured queue table
			if(update_captured_queue_table()){
				view_info.get_capture_table().updateUI();
			}
			// task 3: update work table
			if (update_working_queue_table()){
				view_info.get_work_table().updateUI();
			}
			//System.out.println(work_data.toString());
			try {
				Thread.sleep(1 * 1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public void soft_stop() {
		stop_request = true;
	}

	public void hard_stop() {
		stop_request = true;
		if (client_thread != null) {
			client_thread.interrupt();
		}
	}

	public void wait_request() {
		wait_request = true;
	}

	public void wake_request() {
		wait_request = false;
		synchronized (this) {
			this.notify();
		}
	}

	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		switch_data switch_info = new switch_data();
		view_data view_info = new view_data();
		task_data task_info = new task_data();
		client_data client_info = new client_data();
		view_server data_server = new view_server(switch_info, client_info, task_info, view_info);
		data_server.start();
		try {
			Thread.sleep(10 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// server_runner.soft_stop();
	}
}