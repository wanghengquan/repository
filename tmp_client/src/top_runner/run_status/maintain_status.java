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
import flow_control.export_data;
import flow_control.import_data;
import self_update.app_update;
import utility_funcs.deep_clone;
import utility_funcs.mail_action;
import utility_funcs.time_info;

public class maintain_status extends abstract_status {
	
	public maintain_status(client_status client) {
		super(client);
	}

	public void to_stop() {
		//step 1. soft stop requested and still have task running
		if(client.switch_info.get_client_soft_stop_request()) {
			if (client.pool_info.get_pool_used_threads() > 0){
				client.STATUS_LOGGER.warn("Client stop requested, but still have tasks to be run...");
				return;
			}
			int post_call_size = client.post_info.get_postrun_call_size();
			if (post_call_size > 0){
				client.STATUS_LOGGER.warn("Client stop requested, but still have tasks to be sync..." + post_call_size);
				return;
			}
		}
		//step 2. to stop actions		
		client.hall_runner.soft_stop();
		client.tube_runner.soft_stop();
		client.data_runner.soft_stop();		
		client.STATUS_LOGGER.debug(">>>####################");
		client.STATUS_LOGGER.info("Go to stop");	
		client.set_current_status(client.STOP);
	}

	public void to_work() {
		client.STATUS_LOGGER.debug(">>>####################");
		client.STATUS_LOGGER.info("Go to work");
		//client.data_runner.wake_request();
		//client.tube_runner.wake_request();
		client.hall_runner.wake_request();
		client.set_current_status(client.WORK);
	}

	public void to_maintain() {
		client.STATUS_LOGGER.debug(">>>####################");
		client.STATUS_LOGGER.info("Go to maintain");
		client.set_current_status(client.MAINTAIN);
	}
	
	public void do_state_things(){
		//client.STATUS_LOGGER.info("Run maintain state things");
		String work_space = client.client_info.get_client_preference_data().get("work_space");
		ArrayList<maintain_enum> maintain_list = new ArrayList<maintain_enum>();
		maintain_list.addAll(client.switch_info.get_client_maintain_list());
		client.STATUS_LOGGER.info("Maintain Entry is: " + maintain_list.toString());
		for (maintain_enum maintain_entry: maintain_list){
			switch (maintain_entry) {
			case idle:
				client.STATUS_LOGGER.warn(">>>Idle: Begin to run system idle things...");
				implements_self_quiet_update();
				implements_core_script_update();
				implements_auto_restart_action();
				break;
			case update:
				client.STATUS_LOGGER.warn(">>>Update: Begin to update DEV...");
				Boolean update_status = implements_core_script_update();
				if (update_status){
					client.switch_info.set_core_script_update_request(false);
				} 
				break;
			case environ:
				client.STATUS_LOGGER.warn(">>>Environ: Begin to propagate env issue...");
				implements_env_issue_propagate();
				break;				
			case cpu:
				client.STATUS_LOGGER.warn(">>>CPU:" + machine_sync.get_cpu_usage());
				implements_client_cpu_action();
				break;
			case mem:
				client.STATUS_LOGGER.warn(">>>MEM:" + machine_sync.get_mem_usage());
				implements_client_mem_action();
				break;
			case space:
				client.STATUS_LOGGER.warn(">>>Space:" + machine_sync.get_avail_space(work_space));
				implements_client_space_action();
				break;
			case workspace:
				client.STATUS_LOGGER.warn(">>>Workspace: Begin to update work space...");
				implements_work_space_update();
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
		if (update_obj.update_skipped) {
			client.STATUS_LOGGER.info("TMP Client self-update skipped...");
		} else {
			client.STATUS_LOGGER.info("TMP Client self-update launched...");
			export_data.export_disk_processed_queue_report(client.task_info, client.client_info);
			export_data.export_disk_finished_queue_data(client.task_info, client.client_info);
			export_data.export_disk_memory_queue_data(client.task_info, client.client_info);
		}
		while(client.switch_info.get_client_console_updating()){
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	private Boolean implements_core_script_update(){
		//confirm no test case running
		int counter = 0;
		while(true){
			counter++;
			if(counter > 10){
				client.STATUS_LOGGER.warn(">>>Info: Core script update failed...");
				return false;
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
		core_update my_core = new core_update(client.client_info);
		Boolean update_status = my_core.update();
		if (update_status){
			client.STATUS_LOGGER.info("Core script updated...PASS");
			return update_status;
		}
		client.STATUS_LOGGER.info("Core script updated...FAILED");
		HashMap<String, String> machine_data = new HashMap<String, String>();
		machine_data.putAll(client.client_info.get_client_machine_data());
		HashMap<String, String> preference_data = new HashMap<String, String>();
		preference_data.putAll(client.client_info.get_client_preference_data());		
		String run_mode = machine_data.getOrDefault("unattended", public_data.DEF_UNATTENDED_MODE);
		if(run_mode.equals("0")){ 
			//attended mode local showing
			if(preference_data.get("cmd_gui").equals("gui")){
				client.view_info.set_corescript_update_apply(true);
			} else {
				client.STATUS_LOGGER.warn("Manually Core Script update needed...");
				try {
					Thread.sleep(1000 * public_data.PERF_THREAD_BASE_INTERVAL);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}				
			}			
		} else {
			//send mail
			if (!get_core_script_issue_announced()){
				client.switch_info.set_core_script_warning_announced_date(time_info.get_date_year());
				send_core_script_update_issue_info();
			}
		}
		return update_status;
	}	
	
	private Boolean get_core_script_issue_announced(){
		Boolean status = Boolean.valueOf(false);
		String current_date = new String(time_info.get_date_year());
		String history_date = new String(client.switch_info.get_core_script_warning_announced_date());
		if (current_date.equalsIgnoreCase(history_date)){
			status = true;
		}
		return status;
	}	
	
	private void send_core_script_update_issue_info(){
		String subject = new String("TMP Client: Core Script update issue, manually check needed.");
		String to_str = client.client_info.get_client_preference_data().get("opr_mails");
		String line_separator = System.getProperty("line.separator");
		StringBuilder message = new StringBuilder("");
		message.append("Hi all:" + line_separator);
		message.append("    TMP client get Core Script update issue, manually check needed." + line_separator);
		message.append("    TMP client will suspended before this issue removed:" + line_separator);
		message.append("    Possible reason are: Core script locked" + line_separator);
		message.append("    " + line_separator);
		message.append("    Time:" + time_info.get_date_time() + line_separator);
		message.append("    Terminal:" + client.client_info.get_client_machine_data().get("terminal"));
		message.append("    " + line_separator);
		message.append("Thanks" + line_separator);
		message.append("TMP Clients" + line_separator);
		mail_action.simple_event_mail(subject, to_str, message.toString());
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
		if(match.find()){
			client.STATUS_LOGGER.warn("Host Machine restarting...");
			client.switch_info.set_client_stop_request(exit_enum.HRN);
		}
	}
	
	private void implements_client_mem_action(){
		HashMap<String, String> system_data = new HashMap<String, String>();
		int counter = 0;
		while(true){
			counter++;
			if(counter > 5){
				client.STATUS_LOGGER.info("MEM maintain timeout...");
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
		HashMap<String, String> preference_data = new HashMap<String, String>();
		preference_data.putAll(client.client_info.get_client_preference_data());		
		String run_mode = machine_data.getOrDefault("unattended", public_data.DEF_UNATTENDED_MODE);
		if(run_mode.equals("0")){ 
			//attended mode local showing
			if(preference_data.get("cmd_gui").equals("gui")){
				client.view_info.set_environ_issue_apply(true);
			} else {
				client.STATUS_LOGGER.info("Manually Environment check needed...");
				try {
					Thread.sleep(1000 * public_data.PERF_THREAD_BASE_INTERVAL);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		} else {
			//send mail
			if (get_environ_announced()){
				return;
			} else {
				client.switch_info.set_environ_warning_announced_date(time_info.get_date_year());
				send_environ_issue_mail();
			}
		}
	}
	
	private void send_environ_issue_mail(){
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
	
	private Boolean get_environ_announced(){
		Boolean status = Boolean.valueOf(false);
		String current_date = new String(time_info.get_date_year());
		String history_date = new String(client.switch_info.get_environ_warning_announced_date());
		if (current_date.equalsIgnoreCase(history_date)){
			status = true;
		}
		return status;
	}
	
	private void implements_client_cpu_action(){
		HashMap<String, String> system_data = new HashMap<String, String>();
		int counter = 0;
		while(true){
			counter++;
			if(counter > 5){
				client.STATUS_LOGGER.info("CPU maintain timeout...");
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
		Boolean space_cleaned = Boolean.valueOf(false);
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
				client.STATUS_LOGGER.info("Manually Work Space cleanup needed...");
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
	
	private Boolean implements_work_space_update(){
		Boolean work_space_updated = Boolean.valueOf(false);
		//confirm no test case running
		int counter = 0;
		while(true){
			counter++;
			if(counter > 10){
				client.STATUS_LOGGER.warn("work space update failed...");
				return work_space_updated;
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
		//update work space
		HashMap<String, String> preference_data = new HashMap<String, String>();
		preference_data.putAll(deep_clone.clone(client.client_info.get_client_preference_data()));
        String new_work_space = new String(preference_data.get("work_space_temp"));
        //1. export new core script
		core_update my_core = new core_update(client.client_info);
		try {
			work_space_updated = my_core.update_core_script(new_work_space);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if (!work_space_updated){
			client.STATUS_LOGGER.warn("Work Space update failed, Keep original one.");
			return work_space_updated;
		}
		//2. update client preference data
		preference_data.put("work_space", new_work_space);
		client.client_info.set_client_preference_data(preference_data);
		client.switch_info.set_work_space_update_request(false);
		client.switch_info.set_client_updated();
		client.STATUS_LOGGER.warn("Work Space updated to:" + new_work_space);
		return work_space_updated;
	}
	
	private void run_space_clean_up(){
		int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;	
		int maximum_remove_round = 10;
		int remove_round = 0;
		while(true){
			del_finished_results();
			try {
				Thread.sleep(base_interval * 1 *1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//client will keep in maintain state before this function finished
			//comment out following lines
			//state_enum client_state = client.switch_info.get_client_run_state();
			//if (!client_state.equals(state_enum.maintain)){
			//	break;
			//}
			if (remove_round > maximum_remove_round){
				break;
			}
			remove_round++;
		}
		if (get_overload_removed()){
			return;
		}
		if (get_overload_announced()){
			return;
		}
		send_space_overload_info();
	}
	
	private void send_space_overload_info(){
		client.switch_info.set_space_warning_announced_date(time_info.get_date_year());
		String subject = new String("TMP Client: Space overload, Extra cleanup needed.");
		String to_str = client.client_info.get_client_preference_data().get("opr_mails");
		String line_separator = System.getProperty("line.separator");
		StringBuilder message = new StringBuilder("");
		message.append("Hi all:" + line_separator);
		message.append("    TMP client get space overload issue, Extra cleanup needed." + line_separator);
		message.append("    TMP client will try to remove finished jobs automatically." + line_separator);
		message.append("    But it is better to make a disk cleanup manually!" + line_separator);
		message.append("    " + line_separator);
		message.append("    Time:" + time_info.get_date_time() + line_separator);
		message.append("    Terminal:" + client.client_info.get_client_machine_data().get("terminal"));
		message.append("    " + line_separator);
		message.append("Thanks" + line_separator);
		message.append("TMP Clients" + line_separator);
		mail_action.simple_event_mail(subject, to_str, message.toString());
	}
	
	private Boolean get_overload_announced(){
		Boolean status = Boolean.valueOf(false);
		String current_date = new String(time_info.get_date_year());
		String history_date = new String(client.switch_info.get_space_warning_announced_date());
		if (current_date.equalsIgnoreCase(history_date)){
			status = true;
		}
		return status;
	}
	
	private Boolean get_overload_removed(){
		Boolean status = Boolean.valueOf(false);
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
		if (space_available_int > space_reserve_int){
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
			client.STATUS_LOGGER.info("Manually Disk cleanup needed...");
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
			// got task queue still running
			if (client.task_info.get_running_admin_queue_list().contains(queue_name)){
				continue;
			}
			client.STATUS_LOGGER.warn("Begin to remove data for Task:" + queue_name);
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
				client.STATUS_LOGGER.warn("No data can be removed for Task:" + queue_name);
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
				client.STATUS_LOGGER.warn("Admin file removed:" + admin_path);
			}
			if (task_path.exists() && task_path.isFile()) {
				task_path.delete();
				client.STATUS_LOGGER.warn("Task file removed:" + task_path);
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
					client.STATUS_LOGGER.warn("Result path cleanup Pass:" + result_url);
				} else {
					client.STATUS_LOGGER.warn("Result path cleanup Fail:" + result_url);
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
