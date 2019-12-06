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

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;

import data_center.public_data;
import flow_control.export_data;
import utility_funcs.file_action;
import utility_funcs.mail_action;
import utility_funcs.system_cmd;
import utility_funcs.time_info;

class stop_status extends abstract_status {
	
	public stop_status(client_status client) {
		super(client);
	}

	public void to_stop() {
		client.STATUS_LOGGER.debug(">>>####################");
		client.STATUS_LOGGER.info("Go to stop");
		client.set_current_status(client.STOP);
	}

	public void to_work() {
		client.STATUS_LOGGER.debug(">>>####################");
		client.STATUS_LOGGER.info("Go to work");		
		client.set_current_status(client.WORK);
	}

	public void to_maintain() {
		client.STATUS_LOGGER.debug(">>>####################");
		client.STATUS_LOGGER.info("Go to maintain");
		client.set_current_status(client.MAINTAIN);
	}
	
	public void do_state_things(){
		//client.STATUS_LOGGER.info("Run stop state things");
		stop_link_servers();
		report_processed_data();
		dump_finished_data();
		dump_memory_data();		
		try {
			Thread.sleep(public_data.PERF_THREAD_BASE_INTERVAL * 100);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		send_exception_report();
		restart_shutdown_run();
		stop_with_exit_state();		
	}
	
	//=============================================================
	//methods for locals
	private void send_exception_report(){
		if (!client.switch_info.get_client_stop_request().containsKey(exit_enum.DUMP)){
			return;
		}
		Exception dump_exception = new Exception();
		dump_exception = client.switch_info.get_client_stop_exception();
		if (dump_exception == null){
			return;
		}
		String work_space = client.client_info.get_client_preference_data().get("work_space");
		String dump_path = work_space + "/" + public_data.WORKSPACE_LOG_DIR + "/core_dump/dump.log";
		String to_str = client.client_info.get_client_preference_data().get("dev_mails");
		String cc_str = client.client_info.get_client_preference_data().get("opr_mails");
		String machine = client.client_info.get_client_machine_data().get("terminal");
		String message = new String("");
		message = get_dump_string(dump_exception);
		// 1. send to local disk file
		file_action.append_file(dump_path, message);
		// 2. send mail to TMP OPR and DEV
		mail_action.simple_dump_mail(to_str, cc_str, message, machine);
	}

	private String get_dump_string(Exception dump_exception){
		StringBuilder message = new StringBuilder("");
		String line_separator = System.getProperty("line.separator");
		if (dump_exception == null){
			return message.toString();
		}
		message.append("####################" + line_separator);
		message.append("Date   :" + time_info.get_date_time() + line_separator);
		message.append("Version:" + public_data.BASE_CURRENTVERSION + line_separator);
		message.append(dump_exception.toString() + line_separator);
		for(Object item: dump_exception.getStackTrace()){
			message.append("    at " + item.toString() + line_separator);
		}
		return message.toString();
	}	
	
	private void stop_with_exit_state(){
    	exit_enum exit_state = exit_enum.NORMAL;
    	for (exit_enum current_state: client.switch_info.get_client_stop_request().keySet()){
    		//higher exit have higher priority
    		if(current_state.get_index() > exit_state.get_index()){
    			exit_state = current_state;
    		}
    	}
    	client.STATUS_LOGGER.info("Client Exit Code:" + exit_state.get_index());
    	client.STATUS_LOGGER.info("Client Exit Reason:" + exit_state.get_description());
    	System.exit(exit_state.get_index());
    }
	
	private void restart_shutdown_run(){
		//step 1. get highest exit reason
    	exit_enum exit_state = exit_enum.NORMAL;
    	for (exit_enum current_state: client.switch_info.get_client_stop_request().keySet()){
    		//higher exit have higher priority
    		if(current_state.get_index() > exit_state.get_index()){
    			exit_state = current_state;
    		}
    	}
    	//step 2. get client restart command
		HashMap<String, String> preference_data = new HashMap<String, String>();
		preference_data.putAll(client.client_info.get_client_preference_data());    	
    	String sw_home = public_data.SW_HOME_PATH;
    	String sw_path = new String("");
    	String run_mode = new String("");
    	String os = System.getProperty("os.name").toLowerCase();
		if (os.contains("windows")) {
			sw_path = sw_home + "/bin/client.exe";
		} else {
			sw_path = sw_home + "/bin/client";
		}
		if(preference_data.get("cmd_gui").equals("gui")){
			run_mode = " -g";
		} else {
			run_mode = " -c";
		}
    	String client_restart_cmd = new String(sw_path + run_mode);
    	//step 2. get host machine restart command
    	String host_restart_cmd = new String("shutdown -r");
    	//step 3. get host machine shutdown command
    	String host_shutdown_cmd = new String("shutdown -s");
    	//step 4. get final commands
    	String cmd = new String("");
    	switch (exit_state){
    	case CRN:
    		cmd = client_restart_cmd;
    		break;
    	case CRL:
    		cmd = client_restart_cmd;
    		break;
    	case HRN:
    		if (os.contains("windows")) {
    			cmd = host_restart_cmd;
    		} else {
    			client.STATUS_LOGGER.warn("Host restart not available for Linux client");
    		}
    		break; 
    	case HRL:
    		if (os.contains("windows")) {
    			cmd = host_restart_cmd;
    		} else {
    			client.STATUS_LOGGER.warn("Host restart not available for Linux client");
    		}
    		break; 
    	case HSN:
    		if (os.contains("windows")) {
    			cmd = host_shutdown_cmd;
    		} else {
    			client.STATUS_LOGGER.warn("Host shutdown not available for Linux client");
    		}
    		break;  
    	case HSL:
    		if (os.contains("windows")) {
    			cmd = host_shutdown_cmd;
    		} else {
    			client.STATUS_LOGGER.warn("Host shutdown not available for Linux client");
    		}
    		break;
    	default:
    		break;
    	}
    	//step 5. run final command
    	if (cmd == null || cmd.equals("")){
    		return;
    	}
    	system_cmd.run_immediately(cmd);
    	try {
    		Thread.sleep(1 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private void stop_link_servers(){
		client.cmd_server.soft_stop();
		client.task_server.soft_stop();
	}
	
	private void report_processed_data(){
    	//by default result waiter will dump finished data except:
    	//1) task not finished
    	ArrayList<String> reported_admin_queue_list = new ArrayList<String>();
    	reported_admin_queue_list.addAll(client.task_info.get_reported_admin_queue_list()); 
    	Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> processed_task_queues_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
    	processed_task_queues_map.putAll(client.task_info.get_processed_task_queues_map());
    	Iterator<String> queue_it = processed_task_queues_map.keySet().iterator();
    	while(queue_it.hasNext()){
    		String queue_name = queue_it.next();
    		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
    		queue_data.putAll(processed_task_queues_map.get(queue_name));
    		if (reported_admin_queue_list.contains(queue_name)){
    			continue;
    		}
    		export_data.export_disk_finished_task_queue_report(queue_name, client.client_info, client.task_info);
    	}
    }
    
	private void dump_finished_data(){
    	//by default result waiter will dump finished data except:
    	//1) case number less than 20
    	//2) suite is watching
    	//so when client stopped we need dump these finished suite
    	ArrayList<String> finished_admin_queue_list = new ArrayList<String>();
    	ArrayList<String> emptied_admin_queue_list = new ArrayList<String>();
    	finished_admin_queue_list.addAll(client.task_info.get_finished_admin_queue_list());
    	emptied_admin_queue_list.addAll(client.task_info.get_emptied_admin_queue_list());
		for (String dump_queue : finished_admin_queue_list) {
			if (!emptied_admin_queue_list.contains(dump_queue)){
				continue;// no dump need since this queue is not finished by this launch
			}
			if (!client.task_info.get_processed_task_queues_map().containsKey(dump_queue)) {
				continue;// no queue data to dump (already dumped)
			}
			// dumping task queue
			Boolean admin_dump = export_data.export_disk_finished_admin_queue_data(dump_queue, client.client_info, client.task_info);
			Boolean task_dump = export_data.export_disk_finished_task_queue_data(dump_queue, client.client_info, client.task_info);
			if (admin_dump && task_dump) {
				client.task_info.remove_queue_from_processed_admin_queues_treemap(dump_queue);
				client.task_info.remove_queue_from_processed_task_queues_map(dump_queue);
			}
		}
    }
    
	private void dump_memory_data(){
		export_data.dump_disk_received_admin_data(client.client_info, client.task_info);
		export_data.dump_disk_processed_admin_data(client.client_info, client.task_info);
		export_data.dump_disk_received_task_data(client.client_info, client.task_info);
		export_data.dump_disk_processed_task_data(client.client_info, client.task_info);	
    }	
	
}