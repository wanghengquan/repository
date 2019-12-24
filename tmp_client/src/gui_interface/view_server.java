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
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.Vector;

import javax.swing.JOptionPane;
import javax.swing.SwingUtilities;

import org.apache.commons.io.FileUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.task_data;
import connect_tube.taskid_compare;
import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;
import flow_control.import_data;
import flow_control.pool_data;
import flow_control.queue_enum;
import flow_control.task_enum;
import top_runner.run_status.exit_enum;
import utility_funcs.deep_clone;

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
	//private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;
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

	private HashMap<String, ArrayList<String>> get_retest_list_from_retest_area(
			HashMap<String, retest_enum> queue_area) {
		HashMap<String, ArrayList<String>> return_list = new HashMap<String, ArrayList<String>>();
		Iterator<String> queue_it = queue_area.keySet().iterator();
		while(queue_it.hasNext()){
			String queue_name = queue_it.next();
			retest_enum retest_area = queue_area.get(queue_name);
			ArrayList<String> case_list = new ArrayList<String>();
			TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
			queue_data.putAll(task_info.get_queue_data_from_processed_task_queues_map(queue_name));
			if (retest_area.equals(retest_enum.UNKNOWN)) {
				continue;
			}
			if (retest_area.equals(retest_enum.ALL)) {
				case_list.addAll(queue_data.keySet());
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
			return_list.put(queue_name, case_list);
		}
		return return_list;
	}	
	
	private Boolean implements_retest_task_request() {
		Boolean retest_status = new Boolean(true);
		HashMap<String, ArrayList<String>> retest_hash = new HashMap<String, ArrayList<String>>();
		retest_hash.putAll(view_info.impl_request_retest_list());
		retest_hash.putAll(get_retest_list_from_retest_area(view_info.impl_request_retest_area()));
		Iterator<String> queue_it = retest_hash.keySet().iterator();
		while(queue_it.hasNext()){
			String queue_name = queue_it.next();
			ArrayList<String> case_list = retest_hash.get(queue_name);
			if (case_list == null || case_list.isEmpty()) {
				continue;
			}
			// move case from processed to received and mark case with waiting
			task_info.copy_task_list_from_processed_to_received_task_queues_map(queue_name, case_list);
			task_info.mark_task_list_for_processed_task_queues_map(queue_name, case_list, task_enum.WAITING);
			// mark admin_status to processing
			task_info.copy_admin_from_processed_to_received_admin_queues_treemap(queue_name);
			task_info.active_waiting_received_admin_queues_treemap(queue_name);			
		}
		return retest_status;
	}

	private queue_enum get_admin_queue_status(String queue_name){
		ArrayList<String> running_admin_queue_list = task_info.get_running_admin_queue_list();
		ArrayList<String> finished_admin_queue_list = task_info.get_finished_admin_queue_list();
		ArrayList<String> emptied_admin_queue_list = task_info.get_emptied_admin_queue_list();
		queue_enum status = queue_enum.UNKNOWN;
		if (task_info.get_captured_admin_queues_treemap().containsKey(queue_name)){
			String admin_status = task_info.get_captured_admin_queues_treemap().get(queue_name).get("Status")
					.get("admin_status");
			if (admin_status.equals(queue_enum.STOPPED.get_description())){
				status = queue_enum.STOPPED;
			} else if (admin_status.equals(queue_enum.REMOTESTOPED.get_description())){
				status = queue_enum.STOPPED;
			} else if (admin_status.equals(queue_enum.PAUSED.get_description())){
				status = queue_enum.PAUSED;
			} else if (admin_status.equals(queue_enum.REMOTEPAUSED.get_description())){
				status = queue_enum.PAUSED;
			} else if (admin_status.equals(queue_enum.PROCESSING.get_description())){
				status = queue_enum.PROCESSING;
			} else if (admin_status.equals(queue_enum.REMOTEPROCESSIONG.get_description())) {
				status = queue_enum.PROCESSING;
			} else if (admin_status.equals(queue_enum.REMOTEDONE.get_description())) {
				status = queue_enum.FINISHED;
			} else {
				status = queue_enum.UNKNOWN;
			}				
		} else if (emptied_admin_queue_list.contains(queue_name)) {
			status = queue_enum.FINISHED;
		} else if (finished_admin_queue_list.contains(queue_name)){
			status = queue_enum.FINISHED;
		} else {
			status = queue_enum.UNKNOWN;
		}
		if (status.equals(queue_enum.PROCESSING) || status.equals(queue_enum.FINISHED)){
			if (running_admin_queue_list.contains(queue_name)){
				status = queue_enum.RUNNING;
			}
		}
		return status;
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
		//get run data
		HashMap<String, queue_enum> request_data = new HashMap<String, queue_enum>();
		request_data.putAll(view_info.impl_run_action_request());
		if (request_data.isEmpty()){
			return action_status;
		}
		Iterator<String> queue_it = request_data.keySet().iterator();
		while(queue_it.hasNext()){
			String queue_name = queue_it.next();
			queue_enum run_action = request_data.get(queue_name);
			if (queue_name.equals("")){
				continue;
			}
			queue_enum queue_status = get_admin_queue_status(queue_name);
			if (run_action.equals(queue_enum.UNKNOWN)){
				return action_status; //nothing to do
			}
			//legal check
			Boolean legal_run = run_action_legal_check(queue_status, run_action);
			if (!legal_run){
				VIEW_SERVER_LOGGER.warn(">>>illegal run, queque_name:" + queue_name + ", queue_status:" + queue_status.toString() + ", request_action:" + run_action.toString());
				continue;
			}
			if(task_info.get_finished_admin_queue_list().contains(queue_name)){
				if(!task_info.get_processed_admin_queues_treemap().containsKey(queue_name)){
					Boolean import_admin_status = import_disk_admin_data_to_processed_data(queue_name);
					Boolean import_task_status = import_disk_task_data_to_processed_data(queue_name);
					if (!import_admin_status || !import_task_status){
						VIEW_SERVER_LOGGER.warn("Import xml data failed, Skip run action:" + run_action.get_description());
						continue;
					}
				}
				task_info.copy_admin_from_processed_to_received_admin_queues_treemap(queue_name);
				task_info.remove_finished_admin_queue_list(queue_name);
			}
			if(task_info.get_emptied_admin_queue_list().contains(queue_name)){
				task_info.copy_admin_from_processed_to_received_admin_queues_treemap(queue_name);
				task_info.remove_emptied_admin_queue_list(queue_name);
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
				continue;				
			}		
			task_info.mark_queue_in_received_admin_queues_treemap(queue_name, run_action);			
		}
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
		delete_list.addAll(view_info.impl_request_delete_queue());
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
				VIEW_SERVER_LOGGER.warn("Empty admin queue found, remove it anyway.");
				task_info.remove_queue_from_processed_admin_queues_treemap(queue_name);
				task_info.remove_queue_from_processed_task_queues_map(queue_name);
				task_info.remove_finished_admin_queue_list(queue_name);
				task_info.remove_emptied_admin_queue_list(queue_name);
				continue;
			}
			// delete data in memory(Remote server may send a done queue which also need to be delete)
			task_info.remove_queue_from_received_admin_queues_treemap(queue_name);
			task_info.remove_queue_from_received_task_queues_map(queue_name);			
			task_info.remove_queue_from_processed_admin_queues_treemap(queue_name);
			task_info.remove_queue_from_processed_task_queues_map(queue_name);
			task_info.remove_queue_from_captured_admin_queues_treemap(queue_name);
			task_info.remove_finished_admin_queue_list(queue_name);
			task_info.remove_emptied_admin_queue_list(queue_name);
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

	private main_frame start_main_gui() {
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
		return top_view;
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

	private void implements_message_prompt(main_frame top_view){
		HashMap<String, String> machine_data = new HashMap<String, String>();
		HashMap<String, String> preference_data = new HashMap<String, String>();
		machine_data.putAll(client_info.get_client_machine_data());
		preference_data.putAll(client_info.get_client_preference_data());
		String run_mode = machine_data.getOrDefault("unattended", public_data.DEF_UNATTENDED_MODE);
		if (run_mode.equals("1")){
			//in unattended mode, no one take care this client
			return;
		}
		if (preference_data.get("cmd_gui").equals("cmd")){
			//in console mode no gui interface
			return;
		}
		//message 1. space alert
		apply_space_reservation_alert(top_view);
		//message 2. env issue alert
		apply_environ_issue_alert(top_view);
		//message 3. core script update alert
		apply_corescript_update_alert(top_view);
	}
	
	
	private void apply_corescript_update_alert(main_frame top_view){
		if (!view_info.get_corescript_update_apply()){
			return;
		}
		StringBuilder message = new StringBuilder("");
		message.append("TMP client have Core Script update issue.");
		message.append(line_separator);
		message.append("Possible issues: Core Script(DEV) was locked.");
		message.append(line_separator);
		message.append("");
		message.append(line_separator);
		message.append("Manually Core Script update needed.");
		String title = new String("Warning:Client Core Script update issue.");
		JOptionPane.showMessageDialog(top_view, message.toString(), title, JOptionPane.OK_OPTION);
		view_info.set_corescript_update_apply(false);		
	}
	
	private void apply_environ_issue_alert(main_frame top_view){
		if (!view_info.get_environ_issue_apply()){
			return;
		}
		StringBuilder message = new StringBuilder("");
		message.append("TMP client have wrong environment.");
		message.append(line_separator);
		message.append("Possible issues: Python/svn issue, no system resource.");
		message.append(line_separator);
		message.append("");
		message.append(line_separator);
		message.append("Manually environment check needed.");
		String title = new String("Warning:Client environ issue.");
		JOptionPane.showMessageDialog(top_view, message.toString(), title, JOptionPane.OK_OPTION);
		view_info.set_environ_issue_apply(false);		
	}
	
	private void apply_space_reservation_alert(main_frame top_view){
		if (!view_info.get_space_cleanup_apply()){
			return;
		}
		String work_space = new String(client_info.get_client_preference_data().get("work_space"));
		String available_space = new String(client_info.get_client_system_data().get("space"));
		String space_reserve = new String(client_info.get_client_preference_data().get("space_reserve"));
		StringBuilder message = new StringBuilder("");
		message.append("Work space :" + work_space + " has a lower disk space.");
		message.append(line_separator);
		message.append("Available Space: "+ available_space + "G, Reserved space: " + space_reserve + "G.");
		message.append(line_separator);
		message.append("");
		message.append(line_separator);
		message.append("Manually 'Work Space' clean up needed.");
		String title = new String("Warning:Low space alert.");
		JOptionPane.showMessageDialog(top_view, message.toString(), title, JOptionPane.OK_OPTION);
		view_info.set_space_cleanup_apply(false);
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
	
	private Boolean implements_rejected_queue_data_update(){
		Boolean show_update = new Boolean(false);
		Set<String> rejected_set = new TreeSet<String>(new queue_compare(view_info.get_rejected_sorting_request()));
		TreeMap<String, String> rejected_treemap = new TreeMap<String, String>();
		rejected_treemap.putAll(deep_clone.clone(task_info.get_rejected_admin_reason_treemap()));
		rejected_set.addAll(rejected_treemap.keySet());
		Iterator<String> rejected_it = rejected_set.iterator();
		Vector<Vector<String>> new_data = new Vector<Vector<String>>();
		while (rejected_it.hasNext()) {
			String queue_name = rejected_it.next();
			String reject_reason = rejected_treemap.get(queue_name);
			// add watching vector
			Vector<String> show_line = new Vector<String>();
			show_line.add(queue_name);
			show_line.add(reject_reason);
			new_data.add(show_line);
			show_update = true;
		}
		view_info.set_rejected_queue_data(new_data);
		return show_update;		
	}

	private Boolean implements_captured_queue_data_update() {
		Boolean show_update = new Boolean(false);
		Set<String> captured_set = new TreeSet<String>(new queue_compare(view_info.get_captured_sorting_request()));
		TreeMap<String, HashMap<String, HashMap<String, String>>> captured_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		captured_data.putAll(deep_clone.clone(task_info.get_captured_admin_queues_treemap()));
		captured_set.addAll(captured_data.keySet());
		//Set<String> captured_set = task_info.get_captured_admin_queues_treemap().keySet();
		//ArrayList<String> processing_admin_queue_list = task_info.get_processing_admin_queue_list();
		ArrayList<String> running_admin_queue_list = task_info.get_running_admin_queue_list();
		ArrayList<String> finished_admin_queue_list = task_info.get_finished_admin_queue_list();
		ArrayList<String> emptied_admin_queue_list = task_info.get_emptied_admin_queue_list();
		captured_set.addAll(emptied_admin_queue_list);// source data
		captured_set.addAll(finished_admin_queue_list);
		// //show data
		Iterator<String> captured_it = captured_set.iterator();
		Vector<Vector<String>> vector_data = new Vector<Vector<String>>();
		TreeMap<String, queue_enum> treemap_data = new TreeMap<String, queue_enum>(new queue_compare(view_info.get_captured_sorting_request()));
		while (captured_it.hasNext()) {
			String queue_name = captured_it.next();
			queue_enum status = queue_enum.UNKNOWN;
			if (captured_data.containsKey(queue_name)){
				String admin_status = captured_data.get(queue_name).get("Status")
						.get("admin_status");
				if (admin_status.equals(queue_enum.STOPPED.get_description())){
					status = queue_enum.STOPPED;
				} else if (admin_status.equals(queue_enum.REMOTESTOPED.get_description())){
					status = queue_enum.STOPPED;
				} else if (admin_status.equals(queue_enum.PAUSED.get_description())){
					status = queue_enum.PAUSED;
				} else if (admin_status.equals(queue_enum.REMOTEPAUSED.get_description())){
					status = queue_enum.PAUSED;
				} else if (admin_status.equals(queue_enum.PROCESSING.get_description())){
					status = queue_enum.PROCESSING;
				} else if (admin_status.equals(queue_enum.REMOTEPROCESSIONG.get_description())) {
					status = queue_enum.PROCESSING;
				} else if (admin_status.equals(queue_enum.REMOTEDONE.get_description())) {
					status = queue_enum.FINISHED;
				} else {
					status = queue_enum.UNKNOWN;
				}				
			} else if (emptied_admin_queue_list.contains(queue_name)) {
				status = queue_enum.FINISHED;
			} else if (finished_admin_queue_list.contains(queue_name)){
				status = queue_enum.FINISHED;
			} else {
				status = queue_enum.UNKNOWN;
			}
			if (status.equals(queue_enum.PROCESSING) || status.equals(queue_enum.FINISHED)){
				if (running_admin_queue_list.contains(queue_name)){
					status = queue_enum.RUNNING;
				}
			}
			// watching vector data
			Vector<String> show_line = new Vector<String>();
			show_line.add(queue_name);
			show_line.add(status.get_description());
			vector_data.add(show_line);
			// watching map data for future sorting
			treemap_data.put(queue_name, status);
			show_update = true;
		}
		if (view_info.get_captured_sorting_request().equals(sort_enum.STATUS)){
			view_info.set_captured_queue_data(get_status_sorted_data(treemap_data));
		} else {
			view_info.set_captured_queue_data(vector_data);
		}
		return show_update;
	}
	
	private Vector<Vector<String>> get_status_sorted_data(
			TreeMap<String, queue_enum> ori_data){
		Vector<Vector<String>> status_sorted_data = new Vector<Vector<String>>();
        for (int index = 0; index < queue_enum.values().length; index++ ){
        	Iterator<String> queue_it = ori_data.keySet().iterator();
        	while(queue_it.hasNext()){
        		String queue_name = queue_it.next();
        		queue_enum queue_status = ori_data.get(queue_name);
        		if (queue_status.get_index() == index){
        			Vector<String> show_line = new Vector<String>();
        			show_line.add(queue_name);
        			show_line.add(queue_status.get_description());
        			status_sorted_data.add(show_line);
        		}
        	}
        }
		return status_sorted_data;
	}
	
	private Boolean implements_working_queue_data_update() {
		Boolean show_update = new Boolean(true);
		String request_queue = view_info.get_request_watching_queue();
		watch_enum request_area = view_info.get_request_watching_area();		
		if (request_queue.equals("")) {
			return show_update; // no watching queue selected
		}
		Vector<Vector<String>> new_data = new Vector<Vector<String>>();
		// try import non exists queue data
		if (!task_info.get_processed_task_queues_map().containsKey(request_queue)) {
			//both admin and task should be successfully import otherwise skip import
			import_disk_admin_data_to_processed_data(request_queue);
			Boolean task_import_status = import_disk_task_data_to_processed_data(request_queue);
			if (!task_import_status){
				VIEW_SERVER_LOGGER.warn("Import queue data failed:" + request_queue + ", " + request_area.get_description());
				view_info.set_watching_queue_data(get_blank_data());
				view_info.set_request_watching_queue("");
				return show_update; // no data show
			}
		}
		if (!task_info.get_processed_task_queues_map().containsKey(request_queue)) {
			VIEW_SERVER_LOGGER.warn("Import queue data failed:" + request_queue + ", " + request_area.get_description());
			view_info.set_watching_queue_data(get_blank_data());
			view_info.set_request_watching_queue("");
			return show_update;
		}
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>(new taskid_compare());
		queue_data.putAll(deep_clone.clone(task_info.get_queue_data_from_processed_task_queues_map(request_queue)));
		if (queue_data.size() < 1) {
			VIEW_SERVER_LOGGER.warn("Empty Queue found:" + request_queue + ", " + request_area.get_description());
			view_info.set_watching_queue_data(get_blank_data());
			view_info.set_request_watching_queue("");
			return show_update;
		}
		Iterator<String> case_it = queue_data.keySet().iterator();
		while (case_it.hasNext()) {
			String case_id = case_it.next();
			HashMap<String, HashMap<String, String>> design_data = queue_data.get(case_id);
			Vector<String> add_line = get_one_report_line(design_data, request_area);
			if(add_line.isEmpty()){
				continue;
			}
			new_data.add(add_line);
		}
		view_info.set_watching_queue_data(new_data);
		view_info.set_current_watching_queue(request_queue);
		view_info.set_current_watching_area(request_area);
		return show_update;
	}
	
	private Vector<String> get_one_report_line(
			HashMap<String, HashMap<String, String>> design_data, 
			watch_enum watching_area) {
		Vector<String> add_line = new Vector<String>();
		if(!watching_area.equals(watch_enum.ALL)){
			if(!design_data.get("Status").containsKey("cmd_status")){
				return add_line;//empty line which will be ignore
			}
		}
		if(watching_area.equals(watch_enum.PASSED)){
			if (!design_data.get("Status").get("cmd_status").equals(task_enum.PASSED.get_description())){
				return add_line;//non-passed line which will be ignore
			}
		}
		if(watching_area.equals(watch_enum.FAILED)){
			if (!design_data.get("Status").get("cmd_status").equals(task_enum.FAILED.get_description())){
				return add_line;//non-failed line which will be ignore
			}
		}
		if(watching_area.equals(watch_enum.TBD)){
			if (!design_data.get("Status").get("cmd_status").equals(task_enum.TBD.get_description())){
				return add_line;//non-tbd line which will be ignore
			}
		}		
		if(watching_area.equals(watch_enum.TIMEOUT)){
			if (!design_data.get("Status").get("cmd_status").equals(task_enum.TIMEOUT.get_description())){
				return add_line;//non-timeout line which will be ignore
			}
		}
		if(watching_area.equals(watch_enum.PROCESSING)){
			if (!design_data.get("Status").get("cmd_status").equals(task_enum.PROCESSING.get_description())){
				return add_line;//non-processing line which will be ignore
			}
		}
		if(watching_area.equals(watch_enum.WAITING)){
			if (!design_data.get("Status").get("cmd_status").equals(task_enum.WAITING.get_description())){
				return add_line;//non-waiting line which will be ignore
			}
		}	
		if(watching_area.equals(watch_enum.HALTED)){
			if (!design_data.get("Status").get("cmd_status").equals(task_enum.HALTED.get_description())){
				return add_line;//non-tbd line which will be ignore
			}
		}		
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
			add_line.add("Waiting");
		}
		if (design_data.get("Status").containsKey("cmd_reason")) {
			add_line.add(design_data.get("Status").get("cmd_reason"));
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

	private Vector<Vector<String>> get_blank_data(){
		Vector<Vector<String>> blank_data = new Vector<Vector<String>>();
		Vector<String> add_line = new Vector<String>();
		add_line.add("No data found.");
		add_line.add("..");
		add_line.add("..");
		add_line.add("..");
		add_line.add("..");
		add_line.add("..");
		blank_data.add(add_line);
		return blank_data;
	}
	
	public void run() {
		try {
			monitor_run();
		} catch (Exception run_exception) {
			run_exception.printStackTrace();
			switch_info.set_client_stop_exception(run_exception);
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
		main_frame top_view = start_main_gui();
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
			// task 4 : prompt message windows
			implements_message_prompt(top_view);
			// task 5 : update rejected_queue_data
			implements_rejected_queue_data_update();
			// task 6 : update captured_queue_data
			implements_captured_queue_data_update();
			// task 7 : update working_queue_data
			implements_working_queue_data_update();			
			try {
				Thread.sleep(public_data.PERF_GUI_BASE_INTERVAL * 1 * 1000);
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
