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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.Vector;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.task_data;
import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;

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
    	ArrayList<String> captured_list = task_info.get_captured_admin_queue_list();// source data
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
    
    private Boolean update_working_queue_table(){
    	Boolean show_update = new Boolean(false);
    	
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