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
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.dom4j.DocumentException;

import connect_tube.local_tube;
import connect_tube.rmq_tube;
import connect_tube.task_data;
import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;
import info_parser.xml_parser;
import utility_funcs.file_action;
import utility_funcs.system_call;

public class task_waiter extends Thread {
	// public property
	// protected property
	// private property
	private static final Logger TASK_WAITER_LOGGER = LogManager.getLogger(task_waiter.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private int waiter_index;
	private String waiter_name;
	private String waiter_status;
	private Thread waiter_thread;
	private pool_data pool_info;
	private task_data task_info;
	private client_data client_info;
	private switch_data switch_info;
	private String line_seprator = System.getProperty("line.separator");
	//private String file_seprator = System.getProperty("file.separator");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;
	// public function
	// protected function
	// private function

	public task_waiter(int waiter_index, switch_data switch_info, client_data client_info, pool_data pool_info, task_data task_info) {
		this.waiter_index = waiter_index;
		this.pool_info = pool_info;
		this.task_info = task_info;
		this.client_info = client_info;
		this.switch_info = switch_info;
		this.waiter_name = "TW_" + String.valueOf(waiter_index);
	}

	protected int get_waiter_index() {
		return this.waiter_index;
	}

	protected String get_waiter_status() {
		return this.waiter_status;
	}

	protected Thread get_waiter_thread() {
		return waiter_thread;
	}

	private Boolean import_history_task_list_into_memory(){
		Boolean import_status = new Boolean(false);
		String work_path = client_info.get_client_data().get("base").get("work_path");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		ArrayList<String> history_admin_queue_list = new ArrayList<String>();
		File log_path = new File(work_path + "/" + log_folder);
		if (!log_path.exists() || !log_path.canRead()){
			return import_status;
		}
		File[] file_list = log_path.listFiles();
		for(File file: file_list){
			if(file.isDirectory()){
				continue;
			}
			if (!file.getName().contains(".xml")){
				continue;
			}
			if (!file.getName().contains("@")){
				continue;
			}
			String file_name = file.getName();
			history_admin_queue_list.add(file_name.replace(".xml", ""));
		}
		if (history_admin_queue_list.size()>0){
			task_info.update_finished_admin_queue_list(history_admin_queue_list);
			import_status = true;
		}
		return import_status;
	}
	
	private String get_right_task_queue() {
		String queue_name = new String();
		// pending_queue_list = total processing_admin_queue -
		// finished_admin_queue
		ArrayList<String> processing_queue_list = task_info.get_processing_admin_queue_list();
		ArrayList<String> runable_queue_list = get_runable_queue_list(processing_queue_list);
		int queue_list_size = runable_queue_list.size();
		int select_queue_index = 0;
		if (queue_list_size == 0) {
			return queue_name;
		}
		String queue_work_mode = switch_info.get_queue_work_mode();
		if (queue_work_mode.equalsIgnoreCase("serial")) {
			queue_name = get_highest_queue_name(runable_queue_list);
		} else if (queue_work_mode.equalsIgnoreCase("parallel")) {
			select_queue_index = (waiter_index + 1) % queue_list_size;
			if (select_queue_index == 0) {
				select_queue_index = queue_list_size;
			}
			queue_name = runable_queue_list.get(select_queue_index);
		} else {
			// auto mode run higher priority queue list
			ArrayList<String> higher_priority_queue_list = get_higher_priority_queue_list(runable_queue_list);
			int sub_queue_list_size = higher_priority_queue_list.size();
			select_queue_index = (waiter_index + 1) % sub_queue_list_size;
			if (select_queue_index == 0) {
				select_queue_index = sub_queue_list_size;
			}
			queue_name = higher_priority_queue_list.get(select_queue_index - 1);
		}
		return queue_name;
	}

	// sorting the queue list based on current resource info
	// Machine and System have already sorted in capture level on Software need
	// to rechecks
	private ArrayList<String> get_runable_queue_list(ArrayList<String> full_list) {
		ArrayList<String> runable_queue_list = new ArrayList<String>();
		HashMap<String, Integer> available_software_insts = client_info.get_available_software_insts();
		for (String queue_name : full_list) {
			HashMap<String, HashMap<String, String>> request_data = new HashMap<String, HashMap<String, String>>();
			request_data.putAll(task_info.get_data_from_captured_admin_queues_treemap(queue_name));
			if (request_data.isEmpty()){
				//in case other thread deleted this queue already
				continue;
			}
			if (!request_data.containsKey("Software")) {
				runable_queue_list.add(queue_name);
				continue;
			}
			// with software request queue
			Boolean match_request = new Boolean(true);
			HashMap<String, String> sw_request_data = request_data.get("Software");
			Set<String> sw_request_set = sw_request_data.keySet();
			Iterator<String> sw_request_it = sw_request_set.iterator();
			while (sw_request_it.hasNext()) {
				String sw_request_name = sw_request_it.next();
				if (!available_software_insts.containsKey(sw_request_name)) {
					match_request = false;
					break;
				}
				int available_sw_number = available_software_insts.get(sw_request_name);
				if (available_sw_number < 1) {
					match_request = false;
					break;
				}
			}
			if (match_request) {
				runable_queue_list.add(queue_name);
			}
		}
		return runable_queue_list;
	}

	private ArrayList<String> get_higher_priority_queue_list(ArrayList<String> full_list) {
		ArrayList<String> higher_priority_queue_list = new ArrayList<String>();
		int highest_priority = get_highest_queue_priority(full_list);
		for (String queue_name : full_list) {
			int queue_priority = get_srting_int(queue_name, "^(\\d+)@");
			if (queue_priority == highest_priority) {
				higher_priority_queue_list.add(queue_name);
			}
		}
		return higher_priority_queue_list;
	}

	private int get_highest_queue_priority(ArrayList<String> full_list) {
		int record_priority = 999;
		for (String queue_name : full_list) {
			int queue_priority = get_srting_int(queue_name, "^(\\d+)@");
			if (queue_priority < record_priority) {
				record_priority = queue_priority;
			}
		}
		return record_priority;
	}

	private String get_highest_queue_name(ArrayList<String> full_list) {
		int record_priority = 999;
		String record_queue = new String();
		for (String queue_name : full_list) {
			int queue_priority = get_srting_int(queue_name, "^(\\d+)@");
			if (queue_priority < record_priority) {
				record_priority = queue_priority;
				record_queue = queue_name;
			}
		}
		return record_queue;
	}

	private int get_srting_int(String str, String patt) {
		int i = 0;
		try {
			Pattern p = Pattern.compile(patt);
			Matcher m = p.matcher(str);
			if (m.find()) {
				i = Integer.valueOf(m.group(1));
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}
		return i;
	}

	private Map<String, HashMap<String, HashMap<String, String>>> get_task_case_data(String queue_name) {
		Map<String, HashMap<String, HashMap<String, String>>> case_data = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		Boolean local_queue = new Boolean(false);
		if (queue_name.contains("0@")) {
			local_queue = true;
		}
		if (local_queue) {
			case_data.putAll(task_info.get_one_local_case_data(queue_name));
		} else {
			try {
				case_data.putAll(rmq_tube.read_task_server(queue_name));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
				TASK_WAITER_LOGGER.warn(waiter_name + ":Found empty/invalid Task Queue:" + queue_name);
			}
		}
		return case_data;
	}

	private Boolean import_history_task_data_into_memory(String queue_name){
		Boolean import_status = new Boolean(false);
		if(!task_info.get_finished_admin_queue_list().contains(queue_name)){
			return import_status;
		}
		String work_path = client_info.get_client_data().get("base").get("work_path");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		File log_path = new File(work_path + "/" + log_folder + "/" + queue_name + ".xml");
		if (!log_path.exists() || !log_path.canRead()){
			return import_status;
		}
		xml_parser parser = new xml_parser();
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			queue_data.putAll(parser.get_xml_file_task_queue_data(log_path.getAbsolutePath().replaceAll("\\\\", "/")));
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			TASK_WAITER_LOGGER.warn(waiter_name + ":Import history task data failed:" + queue_name);
			return import_status;
		}
		task_info.update_queue_data_to_processed_task_queues_data_map(queue_name, queue_data);
		return import_status;
	}
	
	private Boolean remove_finished_admin_queue_from_tube(String queue_name){
		Boolean remove_src_status = new Boolean(true);
		Boolean remove_buf_status = new Boolean(true);
		// both resouce end local and reomte admin queue     and     captured admin queue
		if (task_info.get_remote_admin_queue_receive_treemap().containsKey(queue_name)){
			remove_src_status = task_info.remove_queue_from_remote_admin_queue_receive_treemap(queue_name);
		} else if (task_info.get_local_admin_queue_receive_treemap().containsKey(queue_name)){
			remove_src_status = task_info.remove_queue_from_local_admin_queue_receive_treemap(queue_name);
		} else {
			TASK_WAITER_LOGGER.warn(waiter_name + ":Remove task queue failed:" + queue_name);
			remove_src_status = false;
		}
		remove_buf_status = task_info.remove_queue_from_captured_admin_queues_treemap(queue_name);
		if (remove_buf_status && remove_src_status){
			return true;
		} else {
			return false;
		}
		
	}
	
	private HashMap<String, HashMap<String, String>> get_formated_case_hash(
			HashMap<String, HashMap<String, String>> case_hash) {
		HashMap<String, HashMap<String, String>> formated_data = new HashMap<String, HashMap<String, String>>();
		// ID format
		HashMap<String, String> id_hash = new HashMap<String, String>();
		String project = "";
		String run = "";
		String suite = "";
		String section = "";
		String id = "";
		id_hash.put("project", project);
		id_hash.put("run", run);
		id_hash.put("suite", suite);
		id_hash.put("section", section);
		id_hash.put("id", id);
		if (case_hash.containsKey("ID")) {
			id_hash.putAll(case_hash.get("ID"));
		}
		if (case_hash.containsKey("TestID")) {
			id_hash.putAll(case_hash.get("TestID"));
		}
		formated_data.put("ID", id_hash);
		// CaseInfo format
		HashMap<String, String> caseinfo_hash = new HashMap<String, String>();
		String repository = new String("");
		String suite_path = new String("");
		String design_name = new String("");
		String script_address = new String("");
		String auth_key = public_data.ENCRY_DEF_STRING;
		String priority = public_data.TASK_DEF_PRIORITY;
		String timeout = public_data.TASK_DEF_TIMEOUT;
		caseinfo_hash.put("repository", repository);
		caseinfo_hash.put("suite_path", suite_path);
		caseinfo_hash.put("design_name", design_name);
		caseinfo_hash.put("script_address", script_address);
		caseinfo_hash.put("auth_key", auth_key);
		caseinfo_hash.put("priority", priority);
		caseinfo_hash.put("timeout", timeout);
		if (case_hash.containsKey("CaseInfo")) {
			caseinfo_hash.putAll(case_hash.get("CaseInfo"));
		}
		formated_data.put("CaseInfo", caseinfo_hash);
		// Environment no default data now
		HashMap<String, String> envinfo_hash = new HashMap<String, String>();
		if (case_hash.containsKey("Environment")) {
			envinfo_hash.putAll(case_hash.get("Environment"));
		}
		formated_data.put("Environment", envinfo_hash);
		// LaunchCommand format
		HashMap<String, String> command_hash = new HashMap<String, String>();
		String cmd = new String("");
		String override = new String("");
		command_hash.put("cmd", cmd);
		command_hash.put("override", override);
		if (case_hash.containsKey("LaunchCommand")) {
			command_hash.putAll(case_hash.get("LaunchCommand"));
		}
		formated_data.put("LaunchCommand", command_hash);
		// Machine format
		HashMap<String, String> machine_hash = new HashMap<String, String>();
		String terminal = new String("");
		String group = new String("");
		machine_hash.put("terminal", terminal);
		machine_hash.put("group", group);
		if (case_hash.containsKey("Machine")) {
			machine_hash.putAll(case_hash.get("Machine"));
		}
		formated_data.put("Machine", machine_hash);
		// System format
		HashMap<String, String> system_hash = new HashMap<String, String>();
		String os = new String("");
		String os_type = new String("");
		String os_arch = new String("");
		String min_space = new String("");
		system_hash.put("os", os);
		system_hash.put("os_type", os_type);
		system_hash.put("os_arch", os_arch);
		system_hash.put("min_space", min_space);
		if (case_hash.containsKey("System")) {
			system_hash.putAll(case_hash.get("System"));
		}
		formated_data.put("System", system_hash);
		// Software
		HashMap<String, String> software_hash = new HashMap<String, String>();
		if (case_hash.containsKey("Software")) {
			software_hash.putAll(case_hash.get("Software"));
		}
		formated_data.put("Software", software_hash);
		// Status
		HashMap<String, String> status_hash = new HashMap<String, String>();
		if (case_hash.containsKey("Status")) {
			status_hash.putAll(case_hash.get("Status"));
		}
		formated_data.put("Status", status_hash);
		return formated_data;
	}

	private HashMap<String, HashMap<String, String>> get_merged_remote_task_info(
			HashMap<String, HashMap<String, String>> admin_hash, 
			HashMap<String, HashMap<String, String>> case_hash) {
		HashMap<String, HashMap<String, String>> merged_data = new HashMap<String, HashMap<String, String>>();
		// case_hash is formated
		Set<String> case_hash_set = case_hash.keySet();
		Iterator<String> case_hash_it = case_hash_set.iterator();
		while (case_hash_it.hasNext()) {
			String key_name = case_hash_it.next();
			HashMap<String, String> case_info = new HashMap<String, String>();
			case_info.putAll(case_hash.get(key_name));
			HashMap<String, String> merge_info = new HashMap<String, String>();
			if (admin_hash.containsKey(key_name)) {
				HashMap<String, String> admin_info = new HashMap<String, String>();
				admin_info.putAll(admin_hash.get(key_name));
				merge_info.putAll(local_tube.comm_admin_task_merge(admin_info, case_info));
			} else {
				merge_info.putAll(case_info);
			}
			merged_data.put(key_name, merge_info);
		}
		return merged_data;
	}

	private int get_time_out(String time_out) {
		Pattern p_timeout = Pattern.compile("\\D");
		Matcher m = p_timeout.matcher(time_out);
		if (m.find())
			time_out = "3600";
		if (time_out.equals("0")) {
			time_out = "18000";
		}
		return Integer.parseInt(time_out);
	}

	public void run() {
		try {
			monitor_run();
		} catch (Exception run_exception) {
			run_exception.printStackTrace();
			System.exit(1);
		}
	}

	private void monitor_run() {
		// ============== All static job start from here ==============
		// initial 1 : start task waiters
		import_history_task_list_into_memory();
		// initial end
		waiter_thread = Thread.currentThread();
		while (!stop_request) {
			if (wait_request) {
				TASK_WAITER_LOGGER.debug(waiter_name + ":Waiting...");
				try {
					synchronized (this) {
						this.wait();
					}
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} else {
				this.waiter_status = "work";
				TASK_WAITER_LOGGER.debug(waiter_name + ":Running...");
			}
			// take a rest
			try {
				Thread.sleep(base_interval * 1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			// ============== All dynamic job start from here ==============
			// task 1 : check available task queue and thread
			if (task_info.get_captured_admin_queues_treemap().size() == 0) {
				TASK_WAITER_LOGGER.warn(waiter_name + ":No matched queue found in captured queue list.");
				continue;
			}
			if (pool_info.get_available_thread() == 0) {
				continue;
			}
			// task 2 : get working queue
			String queue_name = get_right_task_queue();
			if (queue_name.equals("") || queue_name == null) {
				TASK_WAITER_LOGGER.warn("No matched queue found.");
				continue;
			} else {
				TASK_WAITER_LOGGER.warn(waiter_name + ":Focus on " + queue_name);
			}
			// task 3 : resource booking (thread, software usage)
			// Please release if case not launched !!!
			Boolean thread_booking = pool_info.booking_used_thread(1);
			if (!thread_booking) {
				continue;
			}
			// now we have booking thread, if software booking failed we need to
			// release thread booking also.
			HashMap<String, String> software_cost = new HashMap<String, String>();
			software_cost.putAll(task_info.get_data_from_captured_admin_queues_treemap(queue_name).get("Software"));
			Boolean software_booking = client_info.booking_use_soft_insts(software_cost);
			if (!software_booking) {
				pool_info.release_used_thread(1);
				continue;
			}
			// task 4 : get one task case data
			Map<String, HashMap<String, HashMap<String, String>>> case_data = new HashMap<String, HashMap<String, HashMap<String, String>>>();
			case_data.putAll(get_task_case_data(queue_name));
			TASK_WAITER_LOGGER.debug(waiter_name + ":Get case" + case_data.toString());
			if (case_data.isEmpty() || case_data == null) {
				TASK_WAITER_LOGGER.warn(waiter_name + ":Change queue to finished status:" + queue_name);
				task_info.update_finished_admin_queue_list(queue_name);
				task_info.decrease_running_admin_queue_list(queue_name);
				remove_finished_admin_queue_from_tube(queue_name);
				// release booking info
				client_info.release_use_soft_insts(software_cost);
				pool_info.release_used_thread(1);
				continue;
			} else {
				//import history data into memory if have
				task_info.increase_running_admin_queue_list(queue_name);
				import_history_task_data_into_memory(queue_name);
			}
			Set<String> case_set = case_data.keySet();
			Iterator<String> case_it = case_set.iterator();
			// remote queue have a real case title while local queue case title
			// == case id
			String case_title = case_it.next();
			HashMap<String, HashMap<String, String>> case_hash = case_data.get(case_title);
			HashMap<String, HashMap<String, String>> formated_case_hash = get_formated_case_hash(case_hash);
			// task 5 : merge case data admin queue and local queue (remote
			// need, local is ready)
			HashMap<String, HashMap<String, String>> task_data = new HashMap<String, HashMap<String, String>>();
			HashMap<String, HashMap<String, String>> admin_hash = new HashMap<String, HashMap<String, String>>();
			if (queue_name.contains("1@")) { // 1@: remote task, 0@: local task
				System.out.println(task_info.get_data_from_captured_admin_queues_treemap(queue_name));
				admin_hash.putAll(task_info.get_data_from_captured_admin_queues_treemap(queue_name));				
				task_data.putAll(get_merged_remote_task_info(admin_hash, formated_case_hash));
			} else {
				task_data.putAll(formated_case_hash);
			}
			// task 6 : get test case ready
			case_prepare prepare_obj = new case_prepare();
			ArrayList<String> case_prepare_list = new ArrayList<String>();
			String case_work_path = new String();
			try {
				case_work_path = prepare_obj.get_working_dir(task_data,
						client_info.get_client_data().get("base").get("work_path"));
				case_prepare_list = prepare_obj.get_case_ready(task_data,
						case_work_path);
			} catch (Exception e) {
				e.printStackTrace();
				TASK_WAITER_LOGGER.warn(waiter_name + ":Case prepare failed, skip this case.");
				client_info.release_use_soft_insts(software_cost);
				pool_info.release_used_thread(1);
				continue;
			}
			String local_case_report = case_work_path + "/" +public_data.WORKSPACE_CASE_REPORT_NAME;
			file_action.append_file(local_case_report, "[Export]" + line_seprator);
			file_action.append_file(local_case_report, String.join(line_seprator, case_prepare_list));
			file_action.append_file(local_case_report, line_seprator);
			// task 7 : launch cmd
			String[] run_cmd = prepare_obj.get_run_command(task_data,
					client_info.get_client_data().get("base").get("work_path"));
			// task 8 : launch env
			Map<String, String> run_env = prepare_obj.get_run_environment(task_data, client_info.get_client_data());
			// task 9 : launch (add case info to task data)
			int case_time_out = get_time_out(task_data.get("CaseInfo").get("timeout"));
			String case_id = task_data.get("ID").get("id");
			system_call sys_call = new system_call(run_cmd, run_env, case_work_path, case_time_out);
			pool_info.add_sys_call(sys_call, queue_name, case_id, case_work_path, case_time_out);
			// task 10 : register launched case in task_data and local
			TASK_WAITER_LOGGER.warn(waiter_name + ":Launched " + queue_name + "," + case_id);
			task_info.update_case_to_processed_task_queues_data_map(queue_name, case_id, task_data);
		}
	}

	public void soft_stop() {
		stop_request = true;
		this.waiter_status = "stop";
	}

	public void hard_stop() {
		stop_request = true;
		if (waiter_thread != null) {
			waiter_thread.interrupt();
		}
		this.waiter_status = "stop";
	}

	public void wait_request() {
		this.waiter_status = "wait";
		wait_request = true;
	}

	public void wake_request() {
		this.waiter_status = "work";
		wait_request = false;
		synchronized (this) {
			this.notify();
		}
	}

	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		// pool_data pool_instance = new pool_data(10);
		// task_data task_data_instance = new task_data(null);

		task_waiter waiter = new task_waiter(0, null, null, null, null);
		waiter.start();
		try {
			Thread.sleep(20 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		waiter.wait_request();
		System.out.println(waiter.get_waiter_status());
		try {
			Thread.sleep(5 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		waiter.wake_request();
		System.out.println(waiter.get_waiter_status());
		try {
			Thread.sleep(5 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(waiter.get_waiter_status());
	}
}