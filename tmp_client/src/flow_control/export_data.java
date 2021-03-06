/*
 * File: cmd_parser.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package flow_control;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;

import org.apache.commons.io.FileUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.task_data;
import connect_tube.taskid_compare;
import data_center.client_data;
import data_center.public_data;
import info_parser.xml_parser;
import utility_funcs.file_action;

public class export_data {
	// public property
	// protected property
	// private property
	private static final Logger EXPORT_DATA_LOGGER = LogManager.getLogger(task_waiter.class.getName());
	private static String line_separator = System.getProperty("line.separator");
	// private String file_seprator = System.getProperty("file.separator");

	public export_data() {
	}
	
	//====================
	//high level functions
	public static Boolean export_disk_finished_queue_data(
			task_data task_info,
			client_data client_info){
    	//by default result waiter will dump finished data except:
    	//1) case number less than 20
    	//2) suite is watching
    	//so when client stopped we need to dump these finished suite
		Boolean dump_status = Boolean.valueOf(true);
    	ArrayList<String> finished_admin_queue_list = new ArrayList<String>();
    	ArrayList<String> emptied_admin_queue_list = new ArrayList<String>();
    	finished_admin_queue_list.addAll(task_info.get_finished_admin_queue_list());
    	emptied_admin_queue_list.addAll(task_info.get_emptied_admin_queue_list());
		for (String dump_queue : finished_admin_queue_list) {
			if (!emptied_admin_queue_list.contains(dump_queue)){
				continue;// no dump need since this queue is not finished by this launch
			}
			if (!task_info.get_processed_task_queues_map().containsKey(dump_queue)) {
				continue;// no queue data to dump (already dumped)
			}
			// dumping task queue
			Boolean admin_dump = export_disk_finished_admin_queue_data(dump_queue, client_info, task_info);
			Boolean task_dump = export_disk_finished_task_queue_data(dump_queue, client_info, task_info);
			if (admin_dump && task_dump) {
				task_info.remove_queue_from_processed_admin_queues_treemap(dump_queue);
				task_info.remove_queue_from_processed_task_queues_map(dump_queue);
			} else {
				dump_status = false;
			}
		}
		return dump_status;
    }	
	
	public static Boolean export_disk_processed_queue_report(
			task_data task_info,
			client_data client_info){
		//generate csv file
    	//by default result waiter will dump finished queue report except:
    	//1) task not finished
		Boolean dump_status = Boolean.valueOf(true);
    	ArrayList<String> reported_admin_queue_list = new ArrayList<String>();
    	reported_admin_queue_list.addAll(task_info.get_reported_admin_queue_list()); 
    	Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> processed_task_queues_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
    	processed_task_queues_map.putAll(task_info.get_processed_task_queues_map());
    	Iterator<String> queue_it = processed_task_queues_map.keySet().iterator();
    	while(queue_it.hasNext()){
    		String queue_name = queue_it.next();
    		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
    		queue_data.putAll(processed_task_queues_map.get(queue_name));
    		if (reported_admin_queue_list.contains(queue_name)){
    			continue;
    		}
    		Boolean report_status = Boolean.valueOf(true);
    		report_status = export_disk_finished_task_queue_report(queue_name, client_info, task_info);
    		if (report_status) {
    			task_info.update_reported_admin_queue_list(queue_name);
    		}
    	}
    	return dump_status;
    }	
	
	public static Boolean export_disk_memory_queue_data(
			task_data task_info,
			client_data client_info){
		Boolean dump_status = Boolean.valueOf(true);
		dump_disk_received_admin_data(client_info, task_info);
		dump_disk_processed_admin_data(client_info, task_info);
		dump_disk_received_task_data(client_info, task_info);
		dump_disk_processed_task_data(client_info, task_info);
		return dump_status;
    }	
	
	
	//====================
	//lower level functions
	public static Boolean debug_disk_client_in_task(
			String file_name,
			String message,
			client_data client_info){
		Boolean dump_status = Boolean.valueOf(true);
		if (!client_info.get_client_machine_data().get("debug").equals("1")){
			return dump_status;
		}
		String work_space = client_info.get_client_preference_data().get("work_space");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_file = work_space + "/" + log_folder + "/debug/in/task/" + file_name; 
		file_action.append_file(dump_file, message + line_separator);
		return dump_status;
	}
	
	public static Boolean debug_disk_client_in_admin(
			String file_name,
			String message,
			client_data client_info){
		Boolean dump_status = Boolean.valueOf(true);
		if (!client_info.get_client_machine_data().get("debug").equals("1")){
			return dump_status;
		}
		String work_space = client_info.get_client_preference_data().get("work_space");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_file = work_space + "/" + log_folder + "/debug/in/admin/" + file_name; 
		file_action.append_file(dump_file, message + line_separator);
		return dump_status;
	}
	
	public static Boolean debug_disk_client_in_stop(
			String file_name,
			String message,
			client_data client_info){
		Boolean dump_status = Boolean.valueOf(true);
		if (!client_info.get_client_machine_data().get("debug").equals("1")){
			return dump_status;
		}
		String work_space = client_info.get_client_preference_data().get("work_space");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_file = work_space + "/" + log_folder + "/debug/in/stop/" + file_name; 
		file_action.append_file(dump_file, message + line_separator);
		return dump_status;
	}	
	
	public static Boolean debug_disk_client_out_result(
			String message,
			client_data client_info){
		Boolean dump_status = Boolean.valueOf(true);
		if (!client_info.get_client_machine_data().get("debug").equals("1")){
			return dump_status;
		}
		String work_space = client_info.get_client_preference_data().get("work_space");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_file = work_space + "/" + log_folder + "/debug/out/result.xml"; 
		file_action.append_file(dump_file, message + line_separator);
		return dump_status;
	}
	
	public static Boolean debug_disk_client_out_runtime(
			String message,
			client_data client_info){
		Boolean dump_status = Boolean.valueOf(true);
		if (!client_info.get_client_machine_data().get("debug").equals("1")){
			return dump_status;
		}
		String work_space = client_info.get_client_preference_data().get("work_space");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_file = work_space + "/" + log_folder + "/debug/out/runtime.xml"; 
		file_action.append_file(dump_file, message + line_separator);
		return dump_status;
	}	
	
	public static Boolean debug_disk_client_out_status(
			String message,
			client_data client_info){
		Boolean dump_status = Boolean.valueOf(true);
		if (!client_info.get_client_machine_data().get("debug").equals("1")){
			return dump_status;
		}
		String work_space = client_info.get_client_preference_data().get("work_space");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_file = work_space + "/" + log_folder + "/debug/out/status.xml"; 
		file_action.append_file(dump_file, message + line_separator);
		return dump_status;
	}
	
	public static void dump_disk_received_admin_data(
			client_data client_info,
			task_data task_info){
		TreeMap<String, HashMap<String, HashMap<String, String>>> received_admin_queues_treemap = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		received_admin_queues_treemap.putAll(task_info.get_received_admin_queues_treemap());
		String work_space = client_info.get_client_preference_data().get("work_space");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_path = work_space + "/" + log_folder + "/retrieve/received_admin";
		Iterator<String> queue_it = received_admin_queues_treemap.keySet().iterator();
		while(queue_it.hasNext()){
			String queue_name = queue_it.next();
			HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
			if(received_admin_queues_treemap.containsKey(queue_name)){
				queue_data.putAll(received_admin_queues_treemap.get(queue_name));
			}
			if(queue_data.isEmpty()){
				continue;
			}
			export_admin_data(queue_name, queue_data, dump_path);
		}
	}
	
	public static void dump_disk_processed_admin_data(
			client_data client_info,
			task_data task_info){
		TreeMap<String, HashMap<String, HashMap<String, String>>> processed_admin_queues_treemap = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		processed_admin_queues_treemap.putAll(task_info.get_processed_admin_queues_treemap());
		String work_space = client_info.get_client_preference_data().get("work_space");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_path = work_space + "/" + log_folder + "/retrieve/processed_admin";
		Iterator<String> queue_it = processed_admin_queues_treemap.keySet().iterator();
		while(queue_it.hasNext()){
			String queue_name = queue_it.next();
			HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
			if(processed_admin_queues_treemap.containsKey(queue_name)){
				queue_data.putAll(processed_admin_queues_treemap.get(queue_name));
			}
			if(queue_data.isEmpty()){
				continue;
			}
			export_admin_data(queue_name, queue_data, dump_path);
		}
	}
	
	public static void dump_disk_received_task_data(
			client_data client_info,
			task_data task_info){
		Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> received_task_queues_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
		received_task_queues_map.putAll(task_info.get_received_task_queues_map());
		String work_space = client_info.get_client_preference_data().get("work_space");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_path = work_space + "/" + log_folder + "/retrieve/received_task";
		Iterator<String> queue_it = received_task_queues_map.keySet().iterator();
		while(queue_it.hasNext()){
			String queue_name = queue_it.next();
			TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
			if(received_task_queues_map.containsKey(queue_name)){
				queue_data.putAll(received_task_queues_map.get(queue_name));
			}
			if(queue_data.isEmpty()){
				continue;
			}
			export_task_data(queue_name, queue_data, dump_path);
		}
	}
	
	public static void dump_disk_processed_task_data(
			client_data client_info,
			task_data task_info){
		Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> processed_task_queues_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
		processed_task_queues_map.putAll(task_info.get_processed_task_queues_map());
		String work_space = client_info.get_client_preference_data().get("work_space");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_path = work_space + "/" + log_folder + "/retrieve/processed_task";
		Iterator<String> queue_it = processed_task_queues_map.keySet().iterator();
		while(queue_it.hasNext()){
			String queue_name = queue_it.next();
			TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
			if(processed_task_queues_map.containsKey(queue_name)){
				queue_data.putAll(processed_task_queues_map.get(queue_name));
			}
			if(queue_data.isEmpty()){
				continue;
			}
			export_task_data(queue_name, queue_data, dump_path);
		}
	}
	
	public static Boolean export_disk_finished_admin_queue_data(
			String queue_name,
			client_data client_info,
			task_data task_info){
		Boolean dump_status = Boolean.valueOf(true);
		HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
		if (task_info.get_processed_admin_queues_treemap().containsKey(queue_name)) {
			admin_data.putAll(task_info.get_queue_data_from_processed_admin_queues_treemap(queue_name));
		} else {
			return dump_status;
		}
		String work_space = client_info.get_client_preference_data().get("work_space");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_path = work_space + "/" + log_folder + "/finished/admin";
		dump_status = export_admin_data(queue_name, admin_data, dump_path);
		return dump_status;
	}	
	
	public static Boolean export_disk_finished_task_queue_data(
			String queue_name,
			client_data client_info,
			task_data task_info){
		Boolean dump_status = Boolean.valueOf(true);
		TreeMap<String, HashMap<String, HashMap<String, String>>> task_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		if (task_info.get_processed_task_queues_map().containsKey(queue_name)) {
			task_data.putAll(task_info.get_queue_data_from_processed_task_queues_map(queue_name));
		} else {
			return dump_status;
		}
		String work_space = client_info.get_client_preference_data().get("work_space");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_path = work_space + "/" + log_folder + "/finished/task";
		dump_status = export_task_data(queue_name, task_data, dump_path);
		return dump_status;
	}
	
	public static Boolean export_disk_finished_task_queue_report(
		String queue_name,
		client_data client_info,
		task_data task_info){
		Boolean export_status = Boolean.valueOf(false);	
		String work_space = new String(client_info.get_client_preference_data().get("work_space"));
		File work_dir_fobj = new File(work_space);
		if (!work_dir_fobj.exists()) {
			EXPORT_DATA_LOGGER.warn("Work space do not exists:" + work_space);
			return export_status;
		}
		//get report file path
		HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
		admin_data.putAll(task_info.get_queue_data_from_processed_admin_queues_treemap(queue_name));
		if (admin_data.isEmpty()){
			admin_data.putAll(task_info.get_queue_data_from_received_admin_queues_treemap(queue_name));
		}
		if (admin_data.isEmpty()){
			EXPORT_DATA_LOGGER.warn("No admin data found for queue:" + queue_name);
			return export_status;			
		}
		String tmp_result_dir = public_data.WORKSPACE_RESULT_DIR;
		String prj_dir_name = "prj" + admin_data.get("ID").get("project");
		String run_dir_name = "run" + admin_data.get("ID").get("run");
		String report_name = run_dir_name + ".csv";
		String[] path_array = new String[] { work_space, tmp_result_dir, prj_dir_name, run_dir_name, report_name};
		String report_file_path = String.join(System.getProperty("file.separator"), path_array);
		report_file_path = report_file_path.replaceAll("\\\\", "/");
		//get report file content
		ArrayList<String> report_list = new ArrayList<String>();
		report_list.add("ID, Location, Status, Reason, run_time");
		TreeMap<String, HashMap<String, HashMap<String, String>>> task_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>(new taskid_compare());
		task_data.putAll(task_info.get_queue_data_from_processed_task_queues_map(queue_name));
		Iterator<String> case_it = task_data.keySet().iterator();
		while(case_it.hasNext()){
			String case_name = case_it.next();
			HashMap<String, HashMap<String, String>> case_data = task_data.get(case_name);
			if (!case_data.containsKey("Status")){
				break;
			}
			ArrayList<String> line_list = new ArrayList<String>();
			String run_time = case_data.get("Status").getOrDefault("run_time", "NA");
			String cmd_status = case_data.get("Status").getOrDefault("cmd_status", "NA");
			String location = case_data.get("Status").getOrDefault("location", "NA");
			String cmd_reason = case_data.get("Status").getOrDefault("cmd_reason", "NA");
			line_list.add(case_name);
			line_list.add(location);
			line_list.add(cmd_status);
			line_list.add(cmd_reason);
			line_list.add(run_time);
			String report_line = new String(String.join(",", line_list));
			report_list.add(report_line);
		}
		String report_contents = String.join(System.getProperty("line.separator"), report_list);
		int write_sts = file_action.force_write_file(report_file_path, report_contents);
		if (write_sts == 0){
			return true;
		} else {
			return false;
		}
	}
	
	public static Boolean export_admin_data(
			String queue_name,
			HashMap<String, HashMap<String, String>> admin_data,
			String dump_path) {
		Boolean dump_status = Boolean.valueOf(false);
		if (admin_data == null || admin_data.isEmpty()){
			return dump_status;
		}
		File dump_dobj = new File(dump_path);
		if (dump_dobj.exists() && dump_dobj.isDirectory()) {
			EXPORT_DATA_LOGGER.debug("dump folder exists.");
		} else {
			// create new case path if not have
			try {
				FileUtils.forceMkdir(dump_dobj);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				EXPORT_DATA_LOGGER.warn("Make log folder failed.");
				e.printStackTrace();
				return dump_status;
			}
		}
		String file_name = queue_name + ".xml";
		String dump_file = dump_path + "/" + file_name;
		try {
			dump_status = xml_parser.dump_admin_data(admin_data, queue_name, dump_file.replaceAll("\\\\", "/"));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			EXPORT_DATA_LOGGER.warn("dump finished admin queue failed:" + queue_name);
			dump_status = false;
		}
		return dump_status;
	}
	
	public static Boolean export_task_data(
			String queue_name,
			TreeMap<String, HashMap<String, HashMap<String, String>>> task_data,
			String dump_path) {
		Boolean dump_status = Boolean.valueOf(false);
		if (task_data == null || task_data.isEmpty()){
			return dump_status;
		}		
		File dump_dobj = new File(dump_path);
		if (dump_dobj.exists() && dump_dobj.isDirectory()) {
			EXPORT_DATA_LOGGER.debug("dump folder exists.");
		} else {
			// create new case path if not have
			try {
				FileUtils.forceMkdir(dump_dobj);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				EXPORT_DATA_LOGGER.warn("Make log folder failed.");
				e.printStackTrace();
				dump_status = false;
			}
		}
		String file_name = queue_name + ".xml";
		String dump_file = dump_path + "/" + file_name;
		try {
			dump_status = xml_parser.dump_task_data(task_data, queue_name, dump_file.replaceAll("\\\\", "/"));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			EXPORT_DATA_LOGGER.warn("dump finished task queue failed:" + queue_name);
			dump_status = false;
		}
		return dump_status;
	}
}