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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.dom4j.DocumentException;

import data_center.client_data;
import data_center.public_data;
import info_parser.xml_parser;

public class import_data {
	// public property
	// protected property
	// private property
	private static final Logger IMPORT_DATA_LOGGER = LogManager.getLogger(task_waiter.class.getName());
	// private String line_separator = System.getProperty("line.separator");
	// private String file_seprator = System.getProperty("file.separator");

	public import_data() {
	}
	
	public static TreeMap<String, HashMap<String, HashMap<String, String>>> retrieve_disk_dumped_received_admin_data(
			client_data client_info){
		TreeMap<String, HashMap<String, HashMap<String, String>>> update_queues = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		String work_path = client_info.get_client_data().get("preference").get("work_path");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		File log_path = new File(work_path + "/" + log_folder + "/retrieve/received_admin");
		if (!log_path.exists() || !log_path.canRead()) {
			return update_queues;
		}
		File[] file_list = log_path.listFiles();
		for (File file : file_list) {
			if (file.isDirectory()) {
				continue;
			}
			if (!file.getName().contains(".xml")) {
				continue;
			}
			if (!file.getName().contains("@")) {
				continue;
			}
			String queue_name = file.getName().split("\\.")[0];
			HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
			queue_data.putAll(import_admin_data(file.getAbsolutePath().replaceAll("\\\\", "/")));
			if (queue_data.isEmpty()){
				IMPORT_DATA_LOGGER.warn("Retrieve data failed:" + file.getAbsolutePath().replaceAll("\\\\", "/"));
				continue;
			}
			file.delete();
			update_queues.put(queue_name, queue_data);
		}
		return update_queues;
	}
	
	public static TreeMap<String, HashMap<String, HashMap<String, String>>> retrieve_disk_dumped_processed_admin_data(
			client_data client_info){
		TreeMap<String, HashMap<String, HashMap<String, String>>> update_queues = new TreeMap<String, HashMap<String, HashMap<String, String>>>();		
		String work_path = client_info.get_client_data().get("preference").get("work_path");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		File log_path = new File(work_path + "/" + log_folder + "/retrieve/processed_admin");
		if (!log_path.exists() || !log_path.canRead()) {
			return update_queues;
		}
		File[] file_list = log_path.listFiles();
		for (File file : file_list) {
			if (file.isDirectory()) {
				continue;
			}
			if (!file.getName().contains(".xml")) {
				continue;
			}
			if (!file.getName().contains("@")) {
				continue;
			}
			String queue_name = file.getName().split("\\.")[0];
			HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
			queue_data.putAll(import_admin_data(file.getAbsolutePath().replaceAll("\\\\", "/")));
			if (queue_data.isEmpty()){
				IMPORT_DATA_LOGGER.warn("Retrieve data failed:" + file.getAbsolutePath().replaceAll("\\\\", "/"));
				continue;
			}
			file.delete();
			update_queues.put(queue_name, queue_data);
		}	
		return update_queues;
	}
	
	public static Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> retrieve_disk_dumped_received_task_data(
			client_data client_info){
		Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> update_queues = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> ();
		String work_path = client_info.get_client_data().get("preference").get("work_path");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		File log_path = new File(work_path + "/" + log_folder + "/retrieve/received_task");
		if (!log_path.exists() || !log_path.canRead()) {
			return update_queues;
		}
		File[] file_list = log_path.listFiles();
		for (File file : file_list) {
			if (file.isDirectory()) {
				continue;
			}
			if (!file.getName().contains(".xml")) {
				continue;
			}
			if (!file.getName().contains("@")) {
				continue;
			}
			String queue_name = file.getName().split("\\.")[0];
			TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
			queue_data.putAll(import_task_data(file.getAbsolutePath().replaceAll("\\\\", "/")));
			if (queue_data.isEmpty()){
				IMPORT_DATA_LOGGER.warn("Retrieve data failed:" + file.getAbsolutePath().replaceAll("\\\\", "/"));
				continue;
			}
			file.delete();
			update_queues.put(queue_name, queue_data);
		}	
		return update_queues;
	}
	
	public static Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> retrieve_disk_dumped_processed_task_data(
			client_data client_info){
		Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> update_queues = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> ();		
		String work_path = client_info.get_client_data().get("preference").get("work_path");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		File log_path = new File(work_path + "/" + log_folder + "/retrieve/processed_task");
		if (!log_path.exists() || !log_path.canRead()) {
			return update_queues;
		}
		File[] file_list = log_path.listFiles();
		for (File file : file_list) {
			if (file.isDirectory()) {
				continue;
			}
			if (!file.getName().contains(".xml")) {
				continue;
			}
			if (!file.getName().contains("@")) {
				continue;
			}
			String queue_name = file.getName().split("\\.")[0];
			TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
			queue_data.putAll(import_task_data(file.getAbsolutePath().replaceAll("\\\\", "/")));
			if (queue_data.isEmpty()){
				IMPORT_DATA_LOGGER.warn("Retrieve data failed:" + file.getAbsolutePath().replaceAll("\\\\", "/"));
				continue;
			}
			file.delete();
			update_queues.put(queue_name, queue_data);
		}	
		return update_queues;
	}
	
	public static ArrayList<String> import_disk_finished_admin_queue_list(
			client_data client_info){
		String work_path = client_info.get_client_data().get("preference").get("work_path");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		ArrayList<String> finished_admin_queue_list = new ArrayList<String>();
		File log_path = new File(work_path + "/" + log_folder + "/finished/admin");
		if (!log_path.exists() || !log_path.canRead()) {
			return finished_admin_queue_list;
		}
		File[] file_list = log_path.listFiles();
		for (File file : file_list) {
			if (file.isDirectory()) {
				continue;
			}
			if (!file.getName().contains(".xml")) {
				continue;
			}
			if (!file.getName().contains("@")) {
				continue;
			}
			String file_name = file.getName();
			finished_admin_queue_list.add(file_name.replace(".xml", ""));
		}
		return finished_admin_queue_list;
	}	
	
	public static HashMap<String, HashMap<String, String>> import_disk_finished_admin_data(
			String queue_name,
			client_data client_info) {		
		String work_path = client_info.get_client_data().get("preference").get("work_path");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String xml_path = work_path + "/" + log_folder + "/finished/admin/" + queue_name + ".xml";
		HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
		queue_data.putAll(import_admin_data(xml_path));
		return queue_data;
	}	
	
	public static TreeMap<String, HashMap<String, HashMap<String, String>>> import_disk_finished_task_data(
			String queue_name,
			client_data client_info) {		
		String work_path = client_info.get_client_data().get("preference").get("work_path");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String xml_path = work_path + "/" + log_folder + "/finished/task/" + queue_name + ".xml";
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		queue_data.putAll(import_task_data(xml_path));
		return queue_data;
	}
	
	public static HashMap<String, HashMap<String, String>> import_admin_data(String xml_path) {
		HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
		File xml_frh = new File(xml_path);
		if (!xml_frh.exists() || !xml_frh.canRead()) {
			return queue_data;
		}
		xml_parser parser = new xml_parser();
		try {
			queue_data.putAll(parser.get_xml_file_admin_queue_data(xml_frh.getAbsolutePath().replaceAll("\\\\", "/")));
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			IMPORT_DATA_LOGGER.warn("Import history task data failed:" + xml_path);
			return queue_data;
		}
		return queue_data;
	}
	
	public static TreeMap<String, HashMap<String, HashMap<String, String>>> import_task_data(String xml_path) {
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		File xml_frh = new File(xml_path);
		if (!xml_frh.exists() || !xml_frh.canRead()) {
			return queue_data;
		}
		xml_parser parser = new xml_parser();
		try {
			queue_data.putAll(parser.get_xml_file_task_queue_data(xml_frh.getAbsolutePath().replaceAll("\\\\", "/")));
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			IMPORT_DATA_LOGGER.warn("Import history task data failed:" + xml_path);
			return queue_data;
		}
		return queue_data;
	}	
}