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
	// private String line_separator = System.getProperty("line.separator");
	// private String file_seprator = System.getProperty("file.separator");

	public export_data() {
	}
	
	public static void dump_disk_received_admin_data(
			client_data client_info,
			task_data task_info){
		TreeMap<String, HashMap<String, HashMap<String, String>>> received_admin_queues_treemap = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		received_admin_queues_treemap.putAll(task_info.get_received_admin_queues_treemap());
		String work_path = client_info.get_client_data().get("preference").get("work_path");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_path = work_path + "/" + log_folder + "/retrieve/received_admin";
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
		String work_path = client_info.get_client_data().get("preference").get("work_path");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_path = work_path + "/" + log_folder + "/retrieve/processed_admin";
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
		String work_path = client_info.get_client_data().get("preference").get("work_path");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_path = work_path + "/" + log_folder + "/retrieve/received_task";
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
		String work_path = client_info.get_client_data().get("preference").get("work_path");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_path = work_path + "/" + log_folder + "/retrieve/processed_task";
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
		Boolean dump_status = new Boolean(true);
		HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
		if (task_info.get_processed_admin_queues_treemap().containsKey(queue_name)) {
			admin_data.putAll(task_info.get_queue_data_from_processed_admin_queues_treemap(queue_name));
		} else {
			return dump_status;
		}
		String work_path = client_info.get_client_data().get("preference").get("work_path");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_path = work_path + "/" + log_folder + "/finished/admin";
		dump_status = export_admin_data(queue_name, admin_data, dump_path);
		return dump_status;
	}	
	
	public static Boolean export_disk_finished_task_queue_data(
			String queue_name,
			client_data client_info,
			task_data task_info){
		Boolean dump_status = new Boolean(true);
		TreeMap<String, HashMap<String, HashMap<String, String>>> task_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		if (task_info.get_processed_task_queues_map().containsKey(queue_name)) {
			task_data.putAll(task_info.get_queue_data_from_processed_task_queues_map(queue_name));
		} else {
			return dump_status;
		}
		String work_path = client_info.get_client_data().get("preference").get("work_path");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_path = work_path + "/" + log_folder + "/finished/task";
		dump_status = export_task_data(queue_name, task_data, dump_path);
		return dump_status;
	}
	
	public static Boolean export_disk_finished_task_queue_report(
		String queue_name,
		client_data client_info,
		task_data task_info){
		Boolean export_status = new Boolean(false);	
		String work_dir = new String(client_info.get_client_data().get("preference").get("work_path"));
		File work_dir_fobj = new File(work_dir);
		if (!work_dir_fobj.exists()) {
			EXPORT_DATA_LOGGER.warn("Work space do not exists:" + work_dir);
			return export_status;
		}
		//get report file path
		HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
		admin_data.putAll(task_info.get_queue_data_from_processed_admin_queues_treemap(queue_name));
		if (admin_data.isEmpty()){
			admin_data.putAll(task_info.get_queue_data_from_received_admin_queues_treemap(queue_name));
		}
		String tmp_result_dir = public_data.WORKSPACE_RESULT_DIR;
		String prj_dir_name = "prj" + admin_data.get("ID").get("project");
		String run_dir_name = "run" + admin_data.get("ID").get("run");
		String report_name = run_dir_name + ".csv";
		String[] path_array = new String[] { work_dir, tmp_result_dir, prj_dir_name, run_dir_name, report_name};
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
		Boolean dump_status = new Boolean(false);
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
		xml_parser parser = new xml_parser();
		try {
			dump_status = parser.dump_admin_data(admin_data, queue_name, dump_file.replaceAll("\\\\", "/"));
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
		Boolean dump_status = new Boolean(false);
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
		xml_parser parser = new xml_parser();
		try {
			dump_status = parser.dump_task_data(task_data, queue_name, dump_file.replaceAll("\\\\", "/"));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			EXPORT_DATA_LOGGER.warn("dump finished task queue failed:" + queue_name);
			dump_status = false;
		}
		return dump_status;
	}
}