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
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;

import org.apache.commons.io.FileUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.task_data;
import data_center.client_data;
import data_center.public_data;
import info_parser.xml_parser;

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
			task_data.putAll(task_info.get_queue_from_processed_task_queues_map(queue_name));
		} else {
			return dump_status;
		}
		String work_path = client_info.get_client_data().get("preference").get("work_path");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_path = work_path + "/" + log_folder + "/finished/task";
		dump_status = export_task_data(queue_name, task_data, dump_path);
		return dump_status;
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