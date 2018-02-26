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
import java.util.TreeMap;

import javax.swing.SwingUtilities;

import org.apache.commons.io.FileUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.task_data;
import data_center.client_data;
import data_center.exit_enum;
import data_center.public_data;
import data_center.switch_data;
import flow_control.import_data;
import flow_control.pool_data;
import flow_control.queue_enum;
import flow_control.task_enum;
import utility_funcs.deep_clone;
import utility_funcs.file_action;
import utility_funcs.time_info;

public class view_server extends Thread {
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
	private pool_data pool_info;
	@SuppressWarnings("unused")
	private HashMap<String, String> cmd_info;
	private String line_separator = System.getProperty("line.separator");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;
	private String file_seprator = System.getProperty("file.separator");
	// public function
	// protected function
	// private function

	public view_server(HashMap<String, String> cmd_info, switch_data switch_info, client_data client_info,
			task_data task_info, view_data view_info, pool_data pool_info) {
		this.cmd_info = cmd_info;
		this.switch_info = switch_info;
		this.task_info = task_info;
		this.view_info = view_info;
		this.client_info = client_info;
		this.pool_info = pool_info;
	}

	private List<String> get_retest_case_list(String retest_queue) {
		List<String> case_list = new ArrayList<String>();
		retest_enum retest_area = view_info.impl_retest_queue_area();
		if (retest_area.equals(retest_enum.UNKNOWN)) {
			return case_list;
		}		
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		queue_data.putAll(task_info.get_queue_data_from_processed_task_queues_map(retest_queue));
		if (retest_area.equals(retest_enum.ALL)) {
			case_list.addAll(queue_data.keySet());
		} else if (retest_area.equals(retest_enum.SELECTED)) {
			case_list.addAll(view_info.get_select_task_case());
		} else {
			Iterator<String> queue_data_it = queue_data.keySet().iterator();
			while (queue_data_it.hasNext()) {
				String case_id = queue_data_it.next();
				if (!queue_data.get(case_id).get("Status").containsKey("cmd_status")) {
					continue;
				}
				String cmd_status = queue_data.get(case_id).get("Status").get("cmd_status");
				if (cmd_status.equalsIgnoreCase(retest_area.get_description())) {
					case_list.add(case_id);
				}
			}
		}
		return case_list;
	}

	private Boolean implements_retest_task_request() {
		Boolean retest_status = new Boolean(true);
		// get retest queue name
		String queue_name = view_info.get_watching_queue();
		// get retest case list
		ArrayList<String> case_list = new ArrayList<String>();
		case_list.addAll(get_retest_case_list(queue_name));
		if (case_list.isEmpty()) {
			return retest_status;
		}
		// move case from processed to received and mark case with waiting
		task_info.copy_task_list_from_processed_to_received_task_queues_map(queue_name, case_list);
		task_info.mark_task_list_for_processed_task_queues_map(queue_name, case_list, task_enum.WAITING);
		// mark admin_status to processing
		task_info.copy_admin_from_processed_to_received_admin_queues_treemap(queue_name);
		task_info.active_waiting_received_admin_queues_treemap(queue_name);
		return retest_status;
	}

	private queue_enum get_admin_queue_status(String queue_name){
		ArrayList<String> processing_admin_queue_list = task_info.get_processing_admin_queue_list();
		ArrayList<String> running_admin_queue_list = task_info.get_running_admin_queue_list();
		ArrayList<String> finished_admin_queue_list = task_info.get_finished_admin_queue_list();
		queue_enum queue_status = queue_enum.UNKNOWN;
		if (finished_admin_queue_list.contains(queue_name)) {
			queue_status = queue_enum.FINISHED;
		} else if (running_admin_queue_list.contains(queue_name)) {
			queue_status = queue_enum.RUNNING;
		} else if (processing_admin_queue_list.contains(queue_name)) {
			queue_status = queue_enum.PROCESSING;
		} else {
			if (!task_info.get_captured_admin_queues_treemap().containsKey(queue_name)){
				queue_status = queue_enum.UNKNOWN;
			} else {
				String admin_status = task_info.get_captured_admin_queues_treemap().get(queue_name).get("Status")
						.get("admin_status");
				if (admin_status.equals(queue_enum.STOPPED.get_description())){
					queue_status = queue_enum.STOPPED;
				} else if (admin_status.equals(queue_enum.REMOTESTOPED.get_description())){
					queue_status = queue_enum.STOPPED;
				} else if (admin_status.equals(queue_enum.PAUSED.get_description())){
					queue_status = queue_enum.PAUSED;
				} else if (admin_status.equals(queue_enum.REMOTEPAUSED.get_description())){
					queue_status = queue_enum.PAUSED;
				} else if (admin_status.equals(queue_enum.PROCESSING.get_description())){
					queue_status = queue_enum.PROCESSING;
				} else if (admin_status.equals(queue_enum.REMOTEPROCESSIONG.get_description())) {
					queue_status = queue_enum.PROCESSING;
				} else if (admin_status.equals(queue_enum.REMOTEDONE.get_description())) {
					queue_status = queue_enum.FINISHED;
				} else {
					queue_status = queue_enum.UNKNOWN;
				}
			}
		}
		return queue_status;
	}
	
	private Boolean run_action_legal_check(
			queue_enum queue_status,
			queue_enum run_action){
		Boolean legal_run = new Boolean(true);
		switch (queue_status){
		case PROCESSING:
			if (run_action.equals(queue_enum.STOPPED)){
				legal_run = true;
			} else if (run_action.equals(queue_enum.PAUSED)){
				legal_run = true;
			} else {
				legal_run = false;
			}
			break;
		case RUNNING:
			if (run_action.equals(queue_enum.STOPPED)){
				legal_run = true;
			} else if (run_action.equals(queue_enum.PAUSED)){
				legal_run = true;
			} else {
				legal_run = false;
			}
			break;
		case STOPPED:
			if (run_action.equals(queue_enum.PROCESSING)){
				legal_run = true;
			} else {
				legal_run = false;
			}
			break;
		case PAUSED:
			if (run_action.equals(queue_enum.PROCESSING)){
				legal_run = true;
			} else if (run_action.equals(queue_enum.STOPPED)) {
				legal_run = true;
			} else {
				legal_run = false;
			}
			break;	
		case FINISHED:
			if (run_action.equals(queue_enum.STOPPED)){
				legal_run = true;
			} else {
				legal_run = false;
			}
			break;				
		default:
			legal_run = false;
			break;
		}
		return legal_run;
	}
	
	private Boolean implements_run_action_request(){
		Boolean action_status = new Boolean(true);
		//get retest queue
		String queue_name = view_info.get_select_captured_queue_name();
		if (queue_name.equals("")){
			return action_status;
		}
		//get queue status
		queue_enum queue_status = get_admin_queue_status(queue_name);
		queue_enum run_action = view_info.impl_run_action_request();
		//legal check
		Boolean legal_run = run_action_legal_check(queue_status, run_action);
		if (!legal_run){
			VIEW_SERVER_LOGGER.debug(">>>illegal run, queque_name:" + queue_name + ", queue_status:" + queue_status.toString() + ", request_action:" + run_action.toString());
			return action_status;
		}
		if(task_info.get_finished_admin_queue_list().contains(queue_name)){
			if(!task_info.get_processed_admin_queues_treemap().containsKey(queue_name)){
				Boolean import_admin_status = import_disk_admin_data_to_processed_data(queue_name);
				Boolean import_task_status = import_disk_task_data_to_processed_data(queue_name);
				if (!import_admin_status || !import_task_status){
					VIEW_SERVER_LOGGER.warn("Import xml data failed, Skip run action:" + run_action.get_description());
					return action_status;
				}
			}
			task_info.copy_admin_from_processed_to_received_admin_queues_treemap(queue_name);
			task_info.remove_finished_admin_queue_list(queue_name);
		}
		switch (run_action){
		case STOPPED:
			task_info.copy_task_queue_from_processed_to_received_task_queues_map(queue_name);
			task_info.mark_task_queue_for_processed_task_queues_map(queue_name, task_enum.HALTED);
			break;
		case PROCESSING:
			task_info.update_task_queue_for_processed_task_queues_map(queue_name, task_enum.HALTED, task_enum.WAITING);
			break;
		case PAUSED:
			task_info.update_task_queue_for_processed_task_queues_map(queue_name, task_enum.WAITING, task_enum.HALTED);
			break;
		default:
			VIEW_SERVER_LOGGER.debug(">>>illegal run, queque_name:" + queue_name + ", queue_status:" + queue_status.toString() + ", request_action:" + run_action.toString());
			return action_status;				
		}		
		task_info.mark_queue_in_received_admin_queues_treemap(queue_name, run_action);
		return action_status;
	}

	// dup function in work panel
	private Boolean import_disk_admin_data_to_processed_data(String queue_name) {
		Boolean import_status = new Boolean(false);
		HashMap<String, HashMap<String, String>> import_admin_data = new HashMap<String, HashMap<String, String>>();
		import_admin_data.putAll(import_data.import_disk_finished_admin_data(queue_name, client_info));
		if (import_admin_data.isEmpty()) {
			import_status = false;
		} else {
			task_info.update_queue_to_processed_admin_queues_treemap(queue_name, import_admin_data);
			import_status = true;
		}
		return import_status;
	}

	// dup function in work panel
	private Boolean import_disk_task_data_to_processed_data(String queue_name) {
		Boolean import_status = new Boolean(false);
		TreeMap<String, HashMap<String, HashMap<String, String>>> import_task_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		import_task_data.putAll(import_data.import_disk_finished_task_data(queue_name, client_info));
		if (import_task_data.isEmpty()) {
			import_status = false;
		} else {
			task_info.update_queue_to_processed_task_queues_map(queue_name, import_task_data);
			import_status = true;
		}
		return import_status;
	}

	private void implements_user_del_request() {
		// get delete list
		List<String> delete_list = new ArrayList<String>();
		delete_list.addAll(view_info.impl_delete_request_queue());
		for (String queue_name : delete_list) {
			// public info for implementation
			String work_space = new String();
			if (client_info.get_client_data().containsKey("preference")) {
				work_space = client_info.get_client_preference_data().get("work_space");
			} else {
				work_space = public_data.DEF_WORK_SPACE;
			}
			HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
			admin_data.putAll(deep_clone.clone(task_info.get_queue_data_from_received_admin_queues_treemap(queue_name)));
			admin_data.putAll(deep_clone.clone(task_info.get_queue_data_from_processed_admin_queues_treemap(queue_name)));
			if (admin_data.isEmpty()){
				admin_data.putAll(import_data.import_disk_finished_admin_data(queue_name, client_info));				
			}
			if (admin_data.isEmpty()){
				continue;
			}
			// delete data in memory(Remote server may send a done queue which also need to be delete)
			task_info.remove_queue_from_received_admin_queues_treemap(queue_name);
			task_info.remove_queue_from_received_task_queues_map(queue_name);			
			task_info.remove_queue_from_processed_admin_queues_treemap(queue_name);
			task_info.remove_queue_from_processed_task_queues_map(queue_name);
			task_info.remove_queue_from_captured_admin_queues_treemap(queue_name);
			task_info.remove_finished_admin_queue_list(queue_name);
			// delete log in disk
			String log_folder = public_data.WORKSPACE_LOG_DIR;
			File admin_path = new File(work_space + "/" + log_folder + "/finished/admin/" + queue_name + ".xml");
			File task_path = new File(work_space + "/" + log_folder + "/finished/task/" + queue_name + ".xml");
			if (admin_path.exists() && admin_path.isFile()) {
				admin_path.delete();
			}
			if (task_path.exists() && task_path.isFile()) {
				task_path.delete();
			}
			// delete results in disk
			String tmp_result_dir = public_data.WORKSPACE_RESULT_DIR;
			String prj_dir_name = "prj" + admin_data.get("ID").get("project");
			String run_dir_name = "run" + admin_data.get("ID").get("run");
			String[] path_array = new String[] { work_space, tmp_result_dir, prj_dir_name, run_dir_name };
			String result_url = String.join(file_seprator, path_array);	
			File result_url_fobj = new File(result_url);
			Thread del_result = new Thread(){
				public void run() {
					if (result_url_fobj.exists()){
						if(FileUtils.deleteQuietly(result_url_fobj)){
							VIEW_SERVER_LOGGER.debug("Result path cleanup Pass:" + result_url);
						} else {
							VIEW_SERVER_LOGGER.info("Result path cleanup Fail:" + result_url);
						}
					}
				}
			};
			del_result.start();
		}
	}

	private void start_main_gui() {
		while (true) {
			if (switch_info.get_data_server_power_up()) {
				break;
			}
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		main_frame top_view = new main_frame(switch_info, client_info, view_info, task_info, pool_info);
		if (SwingUtilities.isEventDispatchThread()) {
			top_view.gui_constructor();
			top_view.setVisible(true);
			top_view.show_welcome_letter();
		} else {
			SwingUtilities.invokeLater(new Runnable() {
				@Override
				public void run() {
					// TODO Auto-generated method stub
					top_view.gui_constructor();
					top_view.setVisible(true);
					top_view.show_welcome_letter();
				}
			});
		}
	}

	private void start_progress_show() {
		start_progress start_prepare = new start_progress(switch_info);
		start_prepare.setVisible(true);
		new Thread(start_prepare).start();
		while (true) {
			if (switch_info.get_start_progress_power_up()) {
				break;
			}
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		start_prepare.setVisible(false);
		start_prepare.dispose();
	}

	private void run_system_client_insts_check() {
		switch_info.increase_system_client_insts();
		/*
		int start_insts = switch_info.get_system_client_insts();
		String message = new String("Info: " + String.valueOf(start_insts)
				+ " TMP Client(s) launched with your account already. Do you want to launch a new one?");
		String title = new String("TMP Client launch number confirmation.");
		String unattended_mode = cmd_info.getOrDefault("unattended", "");
		// both yes and no need to add 1 insts.
		if ((start_insts > 0) && (!unattended_mode.equals("1"))) {
			// 0:yes , 1:no
			// yes: add one more insts
			// no: add one since exit will decrease by default
			switch_info.increase_system_client_insts();
			int user_select = JOptionPane.showConfirmDialog(null, message, title, JOptionPane.YES_NO_OPTION);
			if (user_select == 1) {
				System.exit(exit_enum.USER.get_index());// this action will
														// decrease insts num
			}
		} else {
			switch_info.increase_system_client_insts();
		}
		*/
	}

	/*
	private void implements_disk_cleanup_request(){
		Boolean space_cleanup_apply = view_info.get_space_cleanup_apply();
		if (!space_cleanup_apply){
			//no apply
			return;
		}
		if (disk_cleanup_dialog_show){
			//already shown
			return;
		}
		disk_cleanup_dialog_show = true;
		String message = new String();
		String title = new String("Work Space cleanup required.");
		if (SwingUtilities.isEventDispatchThread()) {
			int user_input = 1;
			user_input = JOptionPane.showConfirmDialog(null, message, title, JOptionPane.OK_OPTION);
			if (user_input == 0){
				disk_cleanup_dialog_show = false;
				view_info.set_space_cleanup_apply(false);
			}
		} else {
			SwingUtilities.invokeLater(new Runnable() {
				@Override
				public void run() {
					// TODO Auto-generated method stub
					int user_input = 1;
					user_input = JOptionPane.showConfirmDialog(null, message, title, JOptionPane.OK_OPTION);
					if (user_input == 0){
						disk_cleanup_dialog_show = false;
						view_info.set_space_cleanup_apply(false);
					}					
				}
			});
		}		
	}
	*/
	
	public void run() {
		try {
			monitor_run();
		} catch (Exception run_exception) {
			run_exception.printStackTrace();
			String dump_path = client_info.get_client_data().get("preference").get("work_space") + "/"
					+ public_data.WORKSPACE_LOG_DIR + "/core_dump/dump.log";
			file_action.append_file(dump_path, " " + line_separator);
			file_action.append_file(dump_path, "####################" + line_separator);
			file_action.append_file(dump_path, time_info.get_date_time() + line_separator);
			file_action.append_file(dump_path, run_exception.toString() + line_separator);
			for (Object item : run_exception.getStackTrace()) {
				file_action.append_file(dump_path, "    at " + item.toString() + line_separator);
			}
			switch_info.set_client_stop_request(exit_enum.DUMP);
		}
	}

	private void monitor_run() {
		// ============== All static job start from here ==============
		// initial 0 : TMP client software instances check
		run_system_client_insts_check();
		// initial 1 : start progress
		start_progress_show();
		// initial 2 : start GUI
		start_main_gui();
		// initial 3 : Announce main GUI ready
		switch_info.set_main_gui_power_up();
		// ======================================
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
			implements_retest_task_request();
			// task 2 : run "run" action implements
			implements_run_action_request();
			// task 3 : delete finished queue data
			implements_user_del_request();
			try {
				Thread.sleep(base_interval * 1 * 100);
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
