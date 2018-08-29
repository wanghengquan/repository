/*
 * File: client_state.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package top_runner.run_status;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.io.FileUtils;

import data_center.public_data;
import env_monitor.core_update;
import env_monitor.machine_sync;
import flow_control.import_data;
import self_update.app_update;
import utility_funcs.deep_clone;
import utility_funcs.mail_action;
import utility_funcs.system_cmd;
import utility_funcs.time_info;

public class maintain_status extends abstract_status {
	
	public maintain_status(client_status client) {
		super(client);
	}

	public void to_stop() {
		client.hall_runner.soft_stop();
		client.tube_runner.soft_stop();
		client.data_runner.soft_stop();		
		System.out.println(">>>####################");
		client.STATUS_LOGGER.warn("Go to stop");	
		client.set_current_status(client.STOP);
	}

	public void to_work() {
		System.out.println(">>>####################");
		client.STATUS_LOGGER.warn("Go to work");
		client.data_runner.wake_request();
		client.tube_runner.wake_request();
		client.hall_runner.wake_request();
		client.set_current_status(client.WORK);
	}

	public void to_maintain() {
		System.out.println(">>>####################");
		client.STATUS_LOGGER.warn("Go to maintain");
		client.set_current_status(client.MAINTAIN);
	}
	
	public void do_state_things(){
		client.STATUS_LOGGER.info("Run state things");
		String work_space = client.client_info.get_client_preference_data().get("work_space");
		ArrayList<maintain_enum> maintain_list = new ArrayList<maintain_enum>();
		maintain_list.addAll(client.switch_info.get_client_maintain_list());
		System.out.println(">>>Info:Maintain Entry is: " + maintain_list.toString());
		for (maintain_enum maintain_entry: maintain_list){
			switch (maintain_entry) {
			case idle:
				implements_self_quiet_update();
				implements_core_script_update();
				implements_auto_restart_action();
				break;
			case update:
				System.out.println(">>>Update: Begin to update DEV...");
				implements_core_script_update();
				client.switch_info.set_dev_update_done();
				client.switch_info.clear_dev_need_update();
				break;
			case environ:
				System.out.println(">>>Update: Begin to propagate env issue...");
				implements_env_issue_propagate();
				break;				
			case cpu:
				System.out.println(">>>CPU:" + machine_sync.get_cpu_usage());
				implements_client_cpu_action();
				break;
			case mem:
				System.out.println(">>>MEM:" + machine_sync.get_mem_usage());
				implements_client_mem_action();
				break;
			case space:
				System.out.println(">>>Space:" + machine_sync.get_disk_left(work_space));
				implements_client_space_action();
				break;
			default:
				break;
			}
		}
	}
	
	//=============================================================
	//methods for locals
	private void implements_self_quiet_update(){
		//self update only work in unattended mode
		String unattended_mode = client.client_info.get_client_machine_data().get("unattended");  
		if (!unattended_mode.equalsIgnoreCase("1")){ 
			return;
		}
		app_update update_obj = new app_update(client.client_info, client.switch_info);
		update_obj.smart_update();
		while(client.switch_info.get_client_console_updating()){
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		System.out.println(">>>Info: TMP Client updated...");		
	}
	
	private void implements_core_script_update(){
		//confirm no test case running
		int counter = 0;
		while(true){
			counter++;
			if(counter > 10){
				System.out.println(">>>Info: Core script update failed...");
				return;
			}
			if (client.pool_info.get_pool_used_threads() > 0){
				try {
					Thread.sleep(1000 *60);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				continue;
			} else {
				break;
			}
		}
		core_update my_core = new core_update();
		my_core.update(client.client_info.get_client_preference_data().get("work_space"));
		System.out.println(">>>Info: Core script updated...");
	}	
	
	private void implements_auto_restart_action(){
		String unattend_mode = client.client_info.get_client_machine_data().get("unattended");
		String auto_restart = client.client_info.get_client_preference_data().get("auto_restart");
		String os_type = client.client_info.get_client_system_data().get("os_type");
		if(!unattend_mode.equals("1") || !auto_restart.equals("1")){
			return;
		}
		if(!os_type.equals("windows")){
			return;
		}
		String week_day = new String("");
		week_day = time_info.get_week_day_num();
		if (!week_day.equals(public_data.DEF_AUTO_RESTART_DAY)){
			return;
		}
		String current_time = new String("");
		current_time = time_info.get_time_hhmm();
		Pattern patt = Pattern.compile("120\\d", Pattern.CASE_INSENSITIVE);
		Matcher match = patt.matcher(current_time);
		String run_cmd = new String("shutdown -r");
		if(match.find()){
			System.out.println(">>>Warn: System restarting...");
			client.STATUS_LOGGER.warn("System restarting...");
			try {
				system_cmd.run(run_cmd);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
				System.out.println(">>>Warn: System restart Failed...");
				client.STATUS_LOGGER.warn("System restart Failed...");
			}
		}
	}
	
	private void implements_client_mem_action(){
		HashMap<String, String> system_data = new HashMap<String, String>();
		int counter = 0;
		while(true){
			counter++;
			if(counter > 5){
				System.out.println(">>>Info: MEM maintain timeout...");
				break;
			}	
			system_data.putAll(client.client_info.get_client_system_data());
			//run mem usage check
			if (!system_data.containsKey("mem")){
				break;
			}
			String mem_status = system_data.get("mem");
			int mem_used_int = 0;
			try{
				mem_used_int = Integer.parseInt(mem_status);
			} catch (Exception e) {
				e.printStackTrace();
			}
			//5 just make a gap for trigger again
			if (mem_used_int > public_data.RUN_LIMITATION_MEM - 5){
				try {
					Thread.sleep(1000 * public_data.PERF_THREAD_BASE_INTERVAL);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				continue;
			} else {
				break;
			}
		}
	}	
	
	private void implements_env_issue_propagate(){
		HashMap<String, String> machine_data = new HashMap<String, String>();
		machine_data.putAll(client.client_info.get_client_machine_data());
		String run_mode = machine_data.getOrDefault("unattended", public_data.DEF_UNATTENDED_MODE);
		if(run_mode.equals("0")){ 
			//attended mode local showing
			client.view_info.set_environ_issue_apply(true);
		} else {
			//send mail
			send_env_issue_info();
		}
	}
	
	private void send_env_issue_info(){
		String subject = new String("TMP Client: Environ issue, manually check needed.");
		String to_str = client.client_info.get_client_preference_data().get("opr_mails");
		String line_separator = System.getProperty("line.separator");
		StringBuilder message = new StringBuilder("");
		message.append("Hi all:" + line_separator);
		message.append("    TMP client get environ issue, manually check needed." + line_separator);
		message.append("    TMP client will suspended before this issue removed:" + line_separator);
		message.append("    Possible reason are: Python/svn issue, No system resource" + line_separator);
		message.append("    " + line_separator);
		message.append("    Time:" + time_info.get_date_time() + line_separator);
		message.append("    Terminal:" + client.client_info.get_client_machine_data().get("terminal"));
		message.append("    " + line_separator);
		message.append("Thanks" + line_separator);
		message.append("TMP Clients" + line_separator);
		mail_action.simple_event_mail(subject, to_str, message.toString());
	}
	
	private void implements_client_cpu_action(){
		HashMap<String, String> system_data = new HashMap<String, String>();
		int counter = 0;
		while(true){
			counter++;
			if(counter > 5){
				System.out.println(">>>Info: CPU maintain timeout...");
				break;
			}	
			system_data.putAll(client.client_info.get_client_system_data());
			//run cpu usage check
			if (!system_data.containsKey("cpu")){
				break;
			}
			String cpu_status = system_data.get("cpu");
			int cpu_used_int = 0;
			try{
				cpu_used_int = Integer.parseInt(cpu_status);
			} catch (Exception e) {
				e.printStackTrace();
			}
			//5 just make a gap for trigger again
			if (cpu_used_int > public_data.RUN_LIMITATION_CPU - 5){
				try {
					Thread.sleep(1000 * public_data.PERF_THREAD_BASE_INTERVAL);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				continue;
			} else {
				break;
			}
		}
	}
	
	private Boolean implements_client_space_action(){
		Boolean space_cleaned = new Boolean(false);
		HashMap<String, String> machine_data = new HashMap<String, String>();
		HashMap<String, String> preference_data = new HashMap<String, String>();
		machine_data.putAll(client.client_info.get_client_machine_data());
		preference_data.putAll(client.client_info.get_client_preference_data());
		String run_mode = machine_data.getOrDefault("unattended", public_data.DEF_UNATTENDED_MODE);
		if(run_mode.equals("0")){ 
			//attended mode, message dialog apply
			if(preference_data.get("cmd_gui").equals("gui")){
				client.view_info.set_space_cleanup_apply(true);
			} else {
				System.out.println(">>>Info: Manually Work Space cleanup needed...");
				try {
					Thread.sleep(1000 * public_data.PERF_THREAD_BASE_INTERVAL);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}				
			}
			space_cleaned = false;
		} else {
			//unattended mode, remove old run results
			run_space_clean_up();
			space_cleaned = true;
		}
		return space_cleaned;
	}
	
	private void run_space_clean_up(){
		int maximum_remove_round = 5;
		int remove_round = 0;
		while(true){
			state_enum client_state = client.switch_info.get_client_run_state();
			if (!client_state.equals(state_enum.maintain)){
				break;
			}
			if (remove_round > maximum_remove_round){
				break;
			}
			del_finished_results();
			remove_round++;
		}
		if (get_space_overload()){
			send_space_overload_info();
		}
	}
	
	private void send_space_overload_info(){
		String subject = new String("TMP Client: Space overload, manually cleanup needed.");
		String to_str = client.client_info.get_client_preference_data().get("opr_mails");
		String line_separator = System.getProperty("line.separator");
		StringBuilder message = new StringBuilder("");
		message.append("Hi all:" + line_separator);
		message.append("    TMP client get space overload, manually cleanup needed." + line_separator);
		message.append("    TMP client will suspended before this issue removed:" + line_separator);
		message.append("    " + line_separator);
		message.append("    Time:" + time_info.get_date_time() + line_separator);
		message.append("    Terminal:" + client.client_info.get_client_machine_data().get("terminal"));
		message.append("    " + line_separator);
		message.append("Thanks" + line_separator);
		message.append("TMP Clients" + line_separator);
		mail_action.simple_event_mail(subject, to_str, message.toString());
	}
	
	private Boolean get_space_overload(){
		Boolean status = new Boolean(false);
		String work_space = client.client_info.get_client_preference_data().get("work_space");
		String space_available = machine_sync.get_avail_space(work_space);
		String space_reserve = client.client_info.get_client_preference_data().get("space_reserve");
		int space_available_int = 0;
		int space_reserve_int = 0;
		try{
			space_available_int = Integer.parseInt(space_available);
			space_reserve_int = Integer.parseInt(space_reserve);
		} catch (Exception e) {
			return false;
		}	
		if (space_available_int < space_reserve_int){
			status = true;
		}
		return status;
	}	
	
	private void del_finished_results() {
		// get delete list
		List<String> finished_list = new ArrayList<String>();
		finished_list.addAll(client.task_info.get_finished_admin_queue_list());
		String earliest_date = get_earliest_task_date(finished_list);
		if (earliest_date.equals(time_info.get_date_year())){
			System.out.println(">>>Info: Manually Disk cleanup needed...");
			try {
				Thread.sleep(1000 * public_data.PERF_THREAD_BASE_INTERVAL);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}	
			return;
		}
		for (String queue_name : finished_list) {
			// public info for implementation
			if (!queue_name.contains(earliest_date)){
				continue;
			}
			String work_path = new String();
			if (client.client_info.get_client_data().containsKey("preference")) {
				work_path = client.client_info.get_client_preference_data().get("work_space");
			} else {
				work_path = public_data.DEF_WORK_SPACE;
			}
			HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
			admin_data.putAll(deep_clone.clone(client.task_info.get_queue_data_from_received_admin_queues_treemap(queue_name)));
			admin_data.putAll(deep_clone.clone(client.task_info.get_queue_data_from_processed_admin_queues_treemap(queue_name)));
			if (admin_data.isEmpty()){
				admin_data.putAll(import_data.import_disk_finished_admin_data(queue_name, client.client_info));				
			}
			if (admin_data.isEmpty()){
				continue;
			}
			// delete data in memory(Remote server may send a done queue which also need to be delete)
			client.task_info.remove_queue_from_received_admin_queues_treemap(queue_name);
			client.task_info.remove_queue_from_received_task_queues_map(queue_name);			
			client.task_info.remove_queue_from_processed_admin_queues_treemap(queue_name);
			client.task_info.remove_queue_from_processed_task_queues_map(queue_name);
			client.task_info.remove_queue_from_captured_admin_queues_treemap(queue_name);
			client.task_info.remove_finished_admin_queue_list(queue_name);
			// delete log in disk
			String log_folder = public_data.WORKSPACE_LOG_DIR;
			File admin_path = new File(work_path + "/" + log_folder + "/finished/admin/" + queue_name + ".xml");
			File task_path = new File(work_path + "/" + log_folder + "/finished/task/" + queue_name + ".xml");
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
			String[] path_array = new String[] { work_path, tmp_result_dir, prj_dir_name, run_dir_name };
			String file_seprator = System.getProperty("file.separator");
			String result_url = String.join(file_seprator, path_array);	
			File result_url_fobj = new File(result_url);
			if (result_url_fobj.exists()){
				if(FileUtils.deleteQuietly(result_url_fobj)){
					System.out.println(">>>Info: Result path cleanup Pass:" + result_url);
				} else {
					System.out.println(">>>Info: Result path cleanup Fail:" + result_url);
				}
			}
		}
	}
	
	private String get_earliest_task_date(List<String> queue_list){
		String earlist_date = time_info.get_date_year();
		for (String queue_name: queue_list){
			String queue_date = get_date_srting(queue_name, "_(\\d+)_\\d+$");
			if (queue_date.compareTo(earlist_date) < 0){
				earlist_date = queue_date;
			}
		}
		return earlist_date;
	}
	
	private String get_date_srting(String str, String patt) {
		String date_str = new String("");
		Pattern p = Pattern.compile(patt);
		Matcher m = p.matcher(str);
		if (m.find()) {
			date_str = m.group(1);
		}
		return date_str;
	}
	
}
