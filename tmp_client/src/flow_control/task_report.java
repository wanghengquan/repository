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
import java.util.Iterator;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.rmq_tube;
import data_center.client_data;
import data_center.public_data;
import info_parser.xml_parser;
import utility_funcs.deep_clone;
import utility_funcs.file_action;

public class task_report {
	// public property
	// protected property
	// private property
	private pool_data pool_info;
	private client_data client_info;
	@SuppressWarnings("unused")
	private static final Logger CASE_REPORT_LOGGER = LogManager.getLogger(task_report.class.getName());
	//private ArrayList<String> case_report_info = new ArrayList<String>();
	private String line_separator = System.getProperty("line.separator");
	//private String file_seprator = System.getProperty("file.separator");
    
	public task_report(
			pool_data pool_info,
			client_data client_info) {
		this.pool_info = pool_info;
		this.client_info = client_info;
	}

	protected Boolean dump_disk_task_report_data(
			String report_path,
			ArrayList<String> report_list
			){
		if (report_list == null || report_list.isEmpty()){
			return false;
		}
		String report_file = report_path + "/" + public_data.CASE_REPORT_NAME;
		File report_fobj = new File(report_file);
		if (!report_fobj.exists()){
			file_action.append_file(report_file, "Client Version:" + public_data.BASE_CURRENTVERSION + line_separator);
		}
		file_action.append_file(report_file, String.join(line_separator, report_list) + line_separator);
		return true;
	}	
	
	protected Boolean send_tube_task_data_report(
			HashMap<String, HashMap<String, Object>> case_report_data,
			Boolean smart_send
			) {
		Boolean report_status = new Boolean(true);
		xml_parser parser = new xml_parser();
		String ip = client_info.get_client_machine_data().get("ip");
		String terminal = client_info.get_client_machine_data().get("terminal");
		// get remote date
		HashMap<String, HashMap<String, Object>> remote_data = new HashMap<String, HashMap<String, Object>>();
		// get local data
		HashMap<String, HashMap<String, Object>> local_data = new HashMap<String, HashMap<String, Object>>();
		Iterator<String> report_data_it = case_report_data.keySet().iterator();
		while (report_data_it.hasNext()) {
			String call_index = report_data_it.next();
			if (call_index.contains("0@")) { // 0@ local queue
				local_data.put(call_index, case_report_data.get(call_index));
			} else {
				remote_data.put(call_index, case_report_data.get(call_index));
			}
		}
		HashMap<String, HashMap<String, Object>> remote_send_data = new HashMap<String, HashMap<String, Object>>();
		if (smart_send){
			remote_send_data.putAll(generate_optimized_remote_send_data(remote_data));
		} else {
			remote_send_data.putAll(remote_data);
		}
		if (remote_send_data.size() > 0) {
			// remote send
			rmq_tube rmq_runner = new rmq_tube();
			String rmq_result_str = parser.create_result_document_string(remote_send_data, ip, terminal);
			report_status = rmq_runner.basic_send(public_data.RMQ_RESULT_NAME, rmq_result_str);
			export_data.debug_disk_client_out_result(rmq_result_str, client_info);
		}
		if (local_data.size() > 0) {
			// local send
			;
		}
		return report_status;
	}
	
	protected Boolean send_tube_task_runtime_report(
			HashMap<String, HashMap<String, String>> runtime_log_data
			) {
		Boolean report_status = new Boolean(true);
		xml_parser parser = new xml_parser();
		// get remote date
		HashMap<String, HashMap<String, String>> remote_data = new HashMap<String, HashMap<String, String>>();
		// get local data
		HashMap<String, HashMap<String, String>> local_data = new HashMap<String, HashMap<String, String>>();
		Iterator<String> report_data_it = runtime_log_data.keySet().iterator();
		while (report_data_it.hasNext()) {
			String call_index = report_data_it.next();
			if (call_index.contains("0@")) { // 0@ local queue
				local_data.put(call_index, runtime_log_data.get(call_index));
			} else {
				remote_data.put(call_index, runtime_log_data.get(call_index));
			}
		}
		if (remote_data.size() > 0) {
			// remote send
			rmq_tube rmq_runner = new rmq_tube();
			String rmq_runtime_str = parser.create_runtime_document_string(remote_data);
			report_status = rmq_runner.exchange_send(public_data.RMQ_RUNTIME_NAME, rmq_runtime_str);
			export_data.debug_disk_client_out_runtime(rmq_runtime_str, client_info);
		}
		if (local_data.size() > 0) {
			// local send
			;
		}
		return report_status;
	}	
	
	private HashMap<String, HashMap<String, Object>> generate_optimized_remote_send_data(
			HashMap<String, HashMap<String, Object>> ori_send_data) {
		synchronized (this.getClass()) {
			HashMap<String, HashMap<String, Object>> remote_send_data = new HashMap<String, HashMap<String, Object>>();
			HashMap<String, HashMap<String, Object>> history_send_data = new HashMap<String, HashMap<String, Object>>();
			history_send_data.putAll(deep_clone.clone(pool_info.get_history_send_data()));
			Iterator<String> case_index_it = ori_send_data.keySet().iterator();
			while (case_index_it.hasNext()) {
				String case_index = case_index_it.next();
				HashMap<String, Object> case_data = new HashMap<String, Object>();
				case_data.putAll(ori_send_data.get(case_index));
				HashMap<String, Object> history_case_data = new HashMap<String, Object>();
				if (!history_send_data.containsKey(case_index)) {
					remote_send_data.put(case_index, case_data);
					history_case_data.put("status", case_data.get("status"));
					history_case_data.put("counter", 0);
					pool_info.update_history_send_data(case_index, history_case_data);
					continue;
				}
				history_case_data.putAll(history_send_data.get(case_index));
				task_enum current_status = (task_enum) case_data.get("status");
				task_enum history_status = (task_enum) history_case_data.get("status");
				if (current_status.compareTo(history_status) > 0) {// status update
					remote_send_data.put(case_index, case_data);
					history_case_data.put("status", case_data.get("status"));
					history_case_data.put("counter", 0);
					pool_info.update_history_send_data(case_index, history_case_data);
					continue;
				}
				int interval = public_data.PERF_DUP_REPORT_INTERVAL / public_data.PERF_THREAD_BASE_INTERVAL;
				if ((Integer) history_case_data.get("counter") > interval) {
					remote_send_data.put(case_index, case_data);
					history_case_data.put("counter", 0);
				} else {
					history_case_data.put("counter", (Integer) history_case_data.get("counter") + 1);
				}
				pool_info.update_history_send_data(case_index, history_case_data);
			}
			// clean up history data
			Iterator<String> history_index_it = history_send_data.keySet().iterator();
			while (history_index_it.hasNext()){
				String history_index = history_index_it.next();
				if (!ori_send_data.keySet().contains(history_index)){
					pool_info.remove_history_send_data(history_index);
				}
			}
			return remote_send_data;
		}
	}

}