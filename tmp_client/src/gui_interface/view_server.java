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
import java.util.Iterator;
import java.util.List;
import java.util.TreeMap;

import javax.swing.SwingUtilities;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


import connect_tube.task_data;
import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;

public class view_server extends Thread{
	// public property
	// protected property
	// private property
	private static final Logger VIEW_SERVER_LOGGER = LogManager.getLogger(view_server.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread current_thread;
	private view_data view_info;
	private task_data task_info;
	private switch_data switch_info;
	private client_data client_info;
	// private String line_seprator = System.getProperty("line.separator");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL ;
	// public function
	// protected function
	// private function

	public view_server(switch_data switch_info, client_data client_info, task_data task_info, view_data view_info) {
		this.switch_info = switch_info;
		this.task_info = task_info;
		this.view_info = view_info;
		this.client_info = client_info;
	}

	private List<String> get_retest_case_list(String retest_queue){
		List<String> case_list = new ArrayList<String>();
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		queue_data.putAll(task_info.get_queue_from_processed_task_queues_map(retest_queue));
		String retest_area = view_info.impl_retest_queue_area();
		if (retest_area.equals("")){
			return case_list;
		}
		if (retest_area.equals("all")){
			case_list.addAll(queue_data.keySet());
		} else if (retest_area.equals("selected")){
			case_list.addAll(view_info.get_select_task_case());
		} else {
			Iterator<String> queue_data_it = queue_data.keySet().iterator();
			while(queue_data_it.hasNext()){
				String case_id = queue_data_it.next();
				if(!queue_data.get(case_id).get("Status").containsKey("cmd_status")){
					continue;
				}
				String cmd_status = queue_data.get(case_id).get("Status").get("cmd_status");
				if(cmd_status.equalsIgnoreCase(retest_area)){
					case_list.add(case_id);
				}
			}
		}
		return case_list;
	}
	
	private Boolean implements_retest_task_cases(){
		Boolean retest_status = new Boolean(true);
		//get retest queue name
		String queue_name = view_info.get_watching_queue();
		//get retest case list
		ArrayList<String> case_list = new ArrayList<String>();
		case_list.addAll(get_retest_case_list(queue_name));
		if(case_list.isEmpty()){
			return retest_status;
		}
		//mark case status changed in processed case
		task_info.mark_waiting_case_to_processed_task_queues_map(queue_name, case_list);
		//dump task queue into receive side
		task_info.copy_task_from_processed_to_received_task_queues_map(queue_name, case_list);
		//mark admin_status to processing
		task_info.copy_admin_from_processed_to_received_admin_queues_treemap(queue_name);
		return retest_status;
	}
	
	private Boolean implements_run_action_request(){
		Boolean action_status = new Boolean(true);
		//get retest queue
		String queue_name = view_info.get_select_captured_queue();
		String run_action = view_info.impl_run_action_request();
		if (run_action.equals("")){
			return action_status;
		}
		task_info.copy_admin_from_processed_to_received_admin_queues_treemap(queue_name);
		task_info.mark_queue_in_received_admin_queues_treemap(queue_name, run_action);
		return action_status;
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
		// ============== All static job start from here ==============
		// initial 1 : start GUI
		main_frame top_view = new main_frame(switch_info, client_info, view_info, task_info);
		if (SwingUtilities.isEventDispatchThread()) {
			top_view.gui_constructor();
			top_view.setVisible(true);
		} else {
			SwingUtilities.invokeLater(new Runnable(){
				@Override
				public void run() {
					// TODO Auto-generated method stub
					top_view.gui_constructor();
					top_view.setVisible(true);
				}
			});
		}
		// initial 2 : xxxx
		current_thread = Thread.currentThread();
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
				VIEW_SERVER_LOGGER.debug("Thread running...");
			}
			// ============== All dynamic job start from here ==============
			// task 1 : run "retest" cases
			Boolean retest_status = implements_retest_task_cases();
			// task 2 : run "run" action implements
			Boolean action_status = implements_run_action_request();
			try {
				Thread.sleep(base_interval * 1 * 1000);
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
		if (current_thread != null) {
			current_thread.interrupt();
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
		//
	}
}

