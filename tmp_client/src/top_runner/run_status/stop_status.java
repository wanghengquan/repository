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
import java.util.HashMap;

import com.panayotis.jupidator.data.TextUtils;

import data_center.public_data;
import flow_control.export_data;
import oshi.util.Util;
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
		//step 1: stop remain servers
		stop_user_interface();
		stop_link_services();
		stop_daemon_process();
		//step 2: data keep
		export_data.export_disk_processed_queue_report(client.task_info, client.client_info);
		export_data.export_disk_finished_queue_data(client.task_info, client.client_info);
		export_data.export_disk_memory_queue_data(client.task_info, client.client_info);
		//wait a moment
		Util.sleep(1000);
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
    	String client_restart_cmd = new String("");
    	String os = System.getProperty("os.name").toLowerCase();
		if (os.contains("windows")) {
			sw_path = sw_home + "/bin/client.exe";
		} else {
			sw_path = sw_home + "/bin/client.jar";
		}
		if(preference_data.get("cmd_gui").equals("gui")){
			run_mode = " -g";
		} else {
			run_mode = " -c";
		}
		if (os.contains("windows")) {
			client_restart_cmd = new String(sw_path + run_mode);
		} else {
			client_restart_cmd = new String(get_java_exec() + " -jar " +sw_path + run_mode);
		}
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
    	client.STATUS_LOGGER.warn("Client run command:" + cmd);
    	system_cmd.run_immediately(cmd);
    	try {
    		Thread.sleep(3 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
    private String get_java_exec() {
        String EXEC = TextUtils.getSystemName().contains("windows") ? "javaw.exe" : "java";
        String JAVAHOME = System.getProperty("java.home");
        String file;
        file = JAVAHOME + File.separator + "bin" + File.separator + EXEC;
        if (new File(file).isFile())
            return file;
        file = JAVAHOME + File.separator + "jre" + File.separator + "bin" + File.separator + EXEC;
        if (new File(file).isFile())
            return file;
        String default_return = new String("java");
        return default_return;
    }
	
    private void stop_daemon_process() {
    	client.misc_timer.cancel();
    }
    
    private void stop_user_interface() {
		if (client.cmd_info.get("interactive").equals("1")){
			client.console_runner.soft_stop();
		}
		if (client.cmd_info.get("cmd_gui").equals("gui")){
			client.view_runner.soft_stop();
		} 
    }
    
	private void stop_link_services(){
		client.cmd_server.soft_stop();
		client.task_server.soft_stop();
	}

}