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
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.Vector;

import javax.swing.SwingUtilities;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.dom4j.DocumentException;

import connect_tube.task_data;
import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;
import info_parser.xml_parser;
import utility_funcs.time_info;

//public class view_server extends Thread {
public class view_server implements Runnable {
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

	public view_server(switch_data switch_info, client_data client_info, task_data task_info, view_data view_info) {
		this.switch_info = switch_info;
		this.task_info = task_info;
		this.view_info = view_info;
		this.client_info = client_info;
	}

	private Boolean update_rejected_queue_table() {
		Boolean show_update = new Boolean(false);
		TreeMap<String, String> reject_treemap = task_info.get_rejected_admin_queue_treemap();// source
																								// data
		// TreeMap<String, String> watching_treemap =
		// view_info.get_watching_reject_treemap(); //record data
		Iterator<String> reject_treemap_it = reject_treemap.keySet().iterator();
		view_info.clear_reject_data();
		while (reject_treemap_it.hasNext()) {
			String queue_name = reject_treemap_it.next();
			String reject_reason = reject_treemap.get(queue_name);
			// add watching vector
			Vector<String> show_line = new Vector<String>();
			show_line.add(queue_name);
			show_line.add(reject_reason);
			view_info.add_reject_data(show_line);
			show_update = true;
		}
		return show_update;
	}

	@SuppressWarnings("unused")
	private Boolean update_rejected_queue_table123() {
		Boolean show_update = new Boolean(false);
		TreeMap<String, String> reject_treemap = task_info.get_rejected_admin_queue_treemap();// source
																								// data
		TreeMap<String, String> watching_treemap = view_info.get_watching_reject_treemap(); // record
																							// data
		Iterator<String> reject_treemap_it = reject_treemap.keySet().iterator();
		while (reject_treemap_it.hasNext()) {
			String queue_name = reject_treemap_it.next();
			if (watching_treemap.containsKey(queue_name)) {
				continue;
			}
			String reject_reason = reject_treemap.get(queue_name);// need to
																	// replace
																	// later
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

	private Boolean update_captured_queue_table() {
		Boolean show_update = new Boolean(false);
		ArrayList<String> captured_list = new ArrayList<String>();
		ArrayList<String> captured_admin_queue_list = task_info.get_captured_admin_queue_list();
		ArrayList<String> finished_admin_queue_list = task_info.get_finished_admin_queue_list();
		ArrayList<String> processing_admin_queue_list = task_info.get_processing_admin_queue_list();
		ArrayList<String> running_admin_queue_list = task_info.get_running_admin_queue_list();
		captured_list.addAll(finished_admin_queue_list);// source data
		for (String queue_name : captured_admin_queue_list) {
			if (captured_list.contains(queue_name)) {
				continue;
			}
			captured_list.add(queue_name);
		}
		// TreeMap<String, String> watching_treemap =
		// view_info.get_watching_capture_treemap(); //record data
		// Vector<List<String>> reject_data = view_info.get_reject_data();
		// //show data
		view_info.clear_capture_data();
		for (String queue_name : captured_list) {
			String status = new String("");
			if (finished_admin_queue_list.contains(queue_name)) {
				status = "Finished";
			} else if (running_admin_queue_list.contains(queue_name)) {
				status = "Running";
			} else if (processing_admin_queue_list.contains(queue_name)) {
				status = "Processing";
			} else {
				status = "Halted";
			}
			// add watching vector
			Vector<String> show_line = new Vector<String>();
			show_line.add(queue_name);
			show_line.add(status);
			view_info.add_capture_data(show_line);
			show_update = true;
		}
		return show_update;
	}

	@SuppressWarnings("unused")
	private Boolean update_captured_queue_table123() {
		Boolean show_update = new Boolean(false);
		ArrayList<String> captured_list = new ArrayList<String>();
		ArrayList<String> captured_admin_queue_list = task_info.get_captured_admin_queue_list();
		ArrayList<String> finished_admin_queue_list = task_info.get_finished_admin_queue_list();
		ArrayList<String> processing_admin_queue_list = task_info.get_processing_admin_queue_list();
		ArrayList<String> running_admin_queue_list = task_info.get_running_admin_queue_list();
		captured_list.addAll(captured_admin_queue_list);// source data
		captured_list.addAll(finished_admin_queue_list);// source data
		TreeMap<String, String> watching_treemap = view_info.get_watching_capture_treemap(); // record
																								// data
		// Vector<List<String>> reject_data = view_info.get_reject_data();
		// //show data
		for (String queue_name : captured_list) {
			if (watching_treemap.containsKey(queue_name)) {
				continue;
			}
			String status = new String("");
			if (finished_admin_queue_list.contains(queue_name)) {
				status = "Finished";
			} else if (running_admin_queue_list.contains(queue_name)) {
				status = "Running";
			} else if (processing_admin_queue_list.contains(queue_name)) {
				status = "Processing";
			} else {
				status = "Halted";
			}
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

	/*
	 * private Boolean update_watching_data(String queue_name, Map<String,
	 * TreeMap<String, HashMap<String, HashMap<String, String>>>>
	 * processed_task_queues_data_map) { Boolean update_status = new
	 * Boolean(false); if
	 * (!processed_task_queues_data_map.containsKey(queue_name)) { return
	 * update_status; } if
	 * (processed_task_queues_data_map.get(queue_name).size() < 1) { return
	 * update_status; } TreeMap<String, HashMap<String, HashMap<String,
	 * String>>> processed_task_queue_data_map = processed_task_queues_data_map
	 * .get(queue_name); TreeMap<String, HashMap<String, HashMap<String,
	 * String>>> watching_task_queue_data_map = watching_task_queues_data_map
	 * .get(queue_name); Iterator<String> processed_task_queue_case_it =
	 * processed_task_queue_data_map.keySet().iterator(); while
	 * (processed_task_queue_case_it.hasNext()) { String case_id =
	 * processed_task_queue_case_it.next(); HashMap<String, HashMap<String,
	 * String>> design_data = processed_task_queue_data_map.get(case_id); if
	 * (watching_task_queue_data_map.containsKey(case_id)) { // update line
	 * HashMap<String, HashMap<String, String>> show_data =
	 * watching_task_queue_data_map.get(case_id); String watch_time =
	 * show_data.get("Status").get("run_time"); String new_time =
	 * design_data.get("Status").get("run_time"); if
	 * (new_time.equals(watch_time)) { continue; // no update } else {
	 * Vector<String> update_line = get_one_report_line(design_data);
	 * view_info.update_work_data(update_line);
	 * view_info.update_case_to_watching_task_queues_data_map(queue_name,
	 * case_id, design_data); update_status = true; } } else { // and new line
	 * Vector<String> add_line = get_one_report_line(design_data);
	 * view_info.add_work_data(add_line);
	 * view_info.update_case_to_watching_task_queues_data_map(queue_name,
	 * case_id, design_data); update_status = true; } } return update_status; }
	 * 
	 * 
	 * private Boolean update_watching_data(String queue_name, Map<String,
	 * TreeMap<String, HashMap<String, HashMap<String, String>>>>
	 * watching_task_queues_data_map, Map<String, TreeMap<String,
	 * HashMap<String, HashMap<String, String>>>>
	 * processed_task_queues_data_map) { Boolean update_status = new
	 * Boolean(false); if
	 * (!processed_task_queues_data_map.containsKey(queue_name)) { return
	 * update_status; } if
	 * (processed_task_queues_data_map.get(queue_name).size() < 1) { return
	 * update_status; } TreeMap<String, HashMap<String, HashMap<String,
	 * String>>> processed_task_queue_data_map = processed_task_queues_data_map
	 * .get(queue_name); TreeMap<String, HashMap<String, HashMap<String,
	 * String>>> watching_task_queue_data_map = watching_task_queues_data_map
	 * .get(queue_name); Iterator<String> processed_task_queue_case_it =
	 * processed_task_queue_data_map.keySet().iterator(); while
	 * (processed_task_queue_case_it.hasNext()) { String case_id =
	 * processed_task_queue_case_it.next(); HashMap<String, HashMap<String,
	 * String>> design_data = processed_task_queue_data_map.get(case_id); if
	 * (watching_task_queue_data_map.containsKey(case_id)) { // update line
	 * HashMap<String, HashMap<String, String>> show_data =
	 * watching_task_queue_data_map.get(case_id); String watch_time =
	 * show_data.get("Status").get("run_time"); String new_time =
	 * design_data.get("Status").get("run_time"); if
	 * (new_time.equals(watch_time)) { continue; // no update } else {
	 * Vector<String> update_line = get_one_report_line(design_data);
	 * view_info.update_work_data(update_line);
	 * view_info.update_case_to_watching_task_queues_data_map(queue_name,
	 * case_id, design_data); update_status = true; } } else { // and new line
	 * Vector<String> add_line = get_one_report_line(design_data);
	 * view_info.add_work_data(add_line);
	 * view_info.update_case_to_watching_task_queues_data_map(queue_name,
	 * case_id, design_data); update_status = true; } } return update_status; }
	 */
	private Boolean import_queue_data_to_processed_data(String import_queue) {
		Boolean import_status = new Boolean(false);
		String work_path = new String();
		if (client_info.get_client_data().containsKey("base")) {
			// work with console
			work_path = client_info.get_client_data().get("base").get("work_path");
		} else {
			// gui run only use public default data
			work_path = public_data.DEF_WORK_PATH;
		}
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		File log_path = new File(work_path + "/" + log_folder + "/" + import_queue + ".xml");
		if (!log_path.exists()) {
			return import_status;
		}
		xml_parser file_parser = new xml_parser();
		TreeMap<String, HashMap<String, HashMap<String, String>>> import_queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			import_queue_data = file_parser
					.get_xml_file_task_queue_data(log_path.getAbsolutePath().replaceAll("\\\\", "/"));
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			VIEW_SERVER_LOGGER.warn("Import xml data failed:" + log_path.getAbsolutePath());
			return import_status;
		}
		task_info.update_queue_data_to_processed_task_queues_data_map(import_queue, import_queue_data);
		import_status = true;
		return import_status;
	}

	/*
	 * @SuppressWarnings("unused") private Boolean
	 * update_working_queue_table123() { Boolean show_update = new
	 * Boolean(false); String watching_request =
	 * view_info.get_watching_request(); if (watching_request.equals("")) {
	 * return show_update; // no watching queue selected } Map<String,
	 * TreeMap<String, HashMap<String, HashMap<String, String>>>>
	 * watching_task_queues_data_map = view_info
	 * .get_watching_task_queues_data_map(); Map<String, TreeMap<String,
	 * HashMap<String, HashMap<String, String>>>> processed_task_queues_data_map
	 * = task_info .get_processed_task_queues_data_map(); if
	 * (watching_task_queues_data_map.containsKey(watching_request)) { // check
	 * update add new data for both watching task queues and show // table_data
	 * show_update = update_watching_data(watching_request,
	 * watching_task_queues_data_map, processed_task_queues_data_map); } else {
	 * // new queue request // clean first add data to watching queue data map
	 * view_info.clear_work_data();
	 * view_info.clear_watching_task_queues_data_map(); // try import non exists
	 * queue data if
	 * (!processed_task_queues_data_map.containsKey(watching_request)) {
	 * import_queue_data_to_processed_data(watching_request); } TreeMap<String,
	 * HashMap<String, HashMap<String, String>>> new_queue_data = new
	 * TreeMap<String, HashMap<String, HashMap<String, String>>>();
	 * view_info.update_queue_data_to_watching_task_queues_data_map(
	 * watching_request, new_queue_data); // new data watching data will be
	 * update in next cycle. show_update = true; } return show_update; }
	 */

	private Vector<String> get_one_report_line(HashMap<String, HashMap<String, String>> design_data) {
		Vector<String> add_line = new Vector<String>();
		if (design_data.get("ID").containsKey("id")) {
			add_line.add(design_data.get("ID").get("id"));
		} else {
			add_line.add("NA");
		}
		if (design_data.get("ID").containsKey("suite")) {
			add_line.add(design_data.get("ID").get("suite"));
		} else {
			add_line.add("NA");
		}
		if (design_data.get("CaseInfo").containsKey("design_name")) {
			add_line.add(design_data.get("CaseInfo").get("design_name"));
		} else {
			add_line.add("NA");
		}
		if (design_data.get("Status").containsKey("cmd_status")) {
			add_line.add(design_data.get("Status").get("cmd_status"));
		} else {
			add_line.add("NA");
		}
		if (design_data.get("Status").containsKey("reason")) {
			add_line.add(design_data.get("Status").get("reason"));
		} else {
			add_line.add("NA");
		}
		if (design_data.get("Status").containsKey("run_time")) {
			add_line.add(design_data.get("Status").get("run_time"));
		} else {
			add_line.add("NA");
		}
		return add_line;
	}

	private Boolean update_working_queue_table() {
		Boolean show_update = new Boolean(false);
		String watching_request = view_info.get_watching_request();
		if (watching_request.equals("")) {
			return show_update; // no watching queue selected
		}
		show_update = true;
		view_info.clear_work_data();
		Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> processed_task_queues_data_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
		processed_task_queues_data_map.putAll(task_info.get_processed_task_queues_data_map());
		// try import non exists queue data
		if (!processed_task_queues_data_map.containsKey(watching_request)) {
			import_queue_data_to_processed_data(watching_request);
		}
		if (!processed_task_queues_data_map.containsKey(watching_request)) {
			Vector<String> add_line = new Vector<String>();
			add_line.add("No data found.");
			add_line.add("..");
			add_line.add("..");
			add_line.add("..");
			add_line.add("..");
			add_line.add("..");
			view_info.add_work_data(add_line);
			return show_update;
		}
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		queue_data.putAll(processed_task_queues_data_map.get(watching_request));
		if (queue_data.size() < 1) {
			Vector<String> add_line = new Vector<String>();
			add_line.add("No data found.");
			add_line.add("..");
			add_line.add("..");
			add_line.add("..");
			add_line.add("..");
			add_line.add("..");
			view_info.add_work_data(add_line);
			return show_update;
		}
		Set<String> case_set = queue_data.keySet();
		Iterator<String> case_it = case_set.iterator();
		while (case_it.hasNext()) {
			String case_id = case_it.next();
			HashMap<String, HashMap<String, String>> design_data = queue_data.get(case_id);
			Vector<String> add_line = get_one_report_line(design_data);
			view_info.add_work_data(add_line);
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
				VIEW_SERVER_LOGGER.warn("view_server Thread running...");
			}
			// ============== DEBUG ========================================
			// task debug: manually inser data for GUI test
			Boolean debug = new Boolean(true);
			if (debug) {
				for (int i = 0; i < 1; i++) {
					Vector<String> show_line = new Vector<String>();
					show_line.add("001@run123_" + String.valueOf(i));
					show_line.add("machine");
					view_info.add_reject_data(show_line);
				}
				view_info.get_reject_table().updateUI();

				for (int i = 0; i < 1; i++) {
					Vector<String> show_line = new Vector<String>();
					show_line.add("001@run123_" + String.valueOf(i));
					show_line.add("processing");
					view_info.add_capture_data(show_line);
				}
				view_info.get_capture_table().updateUI();

				for (int i = 0; i < 2; i++) {
					Vector<String> show_line = new Vector<String>();
					show_line.add(String.valueOf(i));
					show_line.add("suite");
					show_line.add("design");
					show_line.add("status");
					show_line.add("reason");
					show_line.add(time_info.get_date_time());
					view_info.add_work_data(show_line);
				}
				view_info.get_work_table().updateUI();
				try {
					Thread.sleep(2000);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}

			// ============== All dynamic job start from here ==============
			// task 1: update rejected queue table
			if (update_rejected_queue_table()) {
				view_info.get_reject_table().validate();
				view_info.get_reject_table().updateUI();
			}
			// task 2: update captured queue table
			if (update_captured_queue_table()) {
				view_info.get_reject_table().validate();
				view_info.get_capture_table().updateUI();
			}
			// task 3: update work table
			if (update_working_queue_table()) {
				view_info.get_reject_table().validate();
				view_info.get_work_table().updateUI();
			}
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
		main_frame top_view = new main_frame(switch_info, view_info);
		while (true) {
			if (SwingUtilities.isEventDispatchThread()) {
				new Thread(data_server).start();
			} else {
				SwingUtilities.invokeLater(data_server);
			}
		}
		// data_server.start();
		// server_runner.soft_stop();
	}
}