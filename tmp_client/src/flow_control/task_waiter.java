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
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.local_tube;
import connect_tube.rmq_tube;
import connect_tube.task_data;
import data_center.client_data;
import data_center.exit_enum;
import data_center.public_data;
import data_center.switch_data;
import utility_funcs.deep_clone;
import utility_funcs.file_action;
import utility_funcs.system_call;
import utility_funcs.time_info;

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
	private String line_separator = System.getProperty("line.separator");
	private String file_seprator = System.getProperty("file.separator");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;
	// public function
	// protected function
	// private function

	public task_waiter(int waiter_index, switch_data switch_info, client_data client_info, pool_data pool_info,
			task_data task_info) {
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

	private void retrieve_queues_into_memory() {
		synchronized (this.getClass()) {
			task_info.update_received_admin_queues_treemap(
					import_data.retrieve_disk_dumped_received_admin_data(client_info));
			task_info.update_processed_admin_queues_treemap(
					import_data.retrieve_disk_dumped_processed_admin_data(client_info));
			task_info.update_received_task_queues_map(
					import_data.retrieve_disk_dumped_received_task_data(client_info));
			task_info.update_processed_task_queues_map(
					import_data.retrieve_disk_dumped_processed_task_data(client_info));
		}
	}

	private void update_processing_queue_list() {
		Set<String> captured_admin_queue_set = new HashSet<String>();
		captured_admin_queue_set.addAll(task_info.get_captured_admin_queues_treemap().keySet());
		Iterator<String> captured_it = captured_admin_queue_set.iterator();
		ArrayList<String> processing_admin_queue_list = new ArrayList<String>();
		while (captured_it.hasNext()) {
			String queue_name = captured_it.next();
			HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
			queue_data = deep_clone.clone(task_info.get_data_from_captured_admin_queues_treemap(queue_name));
			if (queue_data.isEmpty()) {
				continue; // some one delete this queue already
			}
			String status = queue_data.get("Status").get("admin_status");
			if (status.equalsIgnoreCase(queue_enum.PROCESSING.get_description())) {
				processing_admin_queue_list.add(queue_name);
			}
		}
		task_info.set_processing_admin_queue_list(processing_admin_queue_list);
	}

	private void update_running_queue_list() {
		ArrayList<String> running_admin_queue_list = new ArrayList<String>();
		ArrayList<String> processing_admin_queue_list = new ArrayList<String>();
		running_admin_queue_list.addAll(task_info.get_running_admin_queue_list());
		processing_admin_queue_list.addAll(task_info.get_processing_admin_queue_list());
		for (String queue_name : running_admin_queue_list) {
			if (!processing_admin_queue_list.contains(queue_name)) {
				// running queue finished or removed out side
				// task_info.update_finished_admin_queue_list(queue_name);
				task_info.decrease_running_admin_queue_list(queue_name);
			}
		}
	}

	private void reload_finished_queue_data() {
		synchronized (this.getClass()) {
			ArrayList<String> processing_queue_list = task_info.get_processing_admin_queue_list();
			ArrayList<String> finished_queue_list = task_info.get_finished_admin_queue_list();
			for (String queue_name : processing_queue_list) {
				if (!finished_queue_list.contains(queue_name)) {
					continue;
				}
				if (!task_info.remove_finished_admin_queue_list(queue_name)) {
					continue;// some one else remove queue form finished list
								// already
				}
				// action need to do after remove queue form finished list
				if (task_info.get_processed_task_queues_map().containsKey(queue_name)) {
					continue;// task_data already in memory, no import need.
				}
				task_info.update_queue_to_processed_task_queues_map(queue_name,
						import_data.import_disk_finished_task_data(queue_name, client_info));
				// don't import admin queue since it maybe changed remotely
			}
		}
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
		String queue_work_mode = client_info.get_client_data().get("preference").get("task_mode");
		if (queue_work_mode.equalsIgnoreCase("serial")) {
			queue_name = get_highest_queue_name(runable_queue_list);
		} else if (queue_work_mode.equalsIgnoreCase("parallel")) {
			select_queue_index = (waiter_index + 1) % queue_list_size;
			if (select_queue_index == 0) {
				select_queue_index = queue_list_size;
			}
			queue_name = runable_queue_list.get(select_queue_index - 1);
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
			if (request_data.isEmpty()) {
				// in case other thread deleted this queue already
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

	private HashMap<String, HashMap<String, String>> get_final_task_data(
			String queue_name,
			HashMap<String, HashMap<String, String>> admin_data,
			HashMap<String, String> client_preference_data) {
		Map<String, HashMap<String, HashMap<String, String>>> indexed_task_data = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		HashMap<String, HashMap<String, String>> standard_case_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, HashMap<String, String>> raw_task_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, HashMap<String, String>> task_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, HashMap<String, String>> return_data = new HashMap<String, HashMap<String, String>>();
		indexed_task_data.putAll(get_indexed_task_data(queue_name));
		if (indexed_task_data.isEmpty()) {
			return return_data;// empty data
		}
		// remote queue has case title while local queue case title == case id.
		// let's remove this title
		Iterator<String> indexed_it = indexed_task_data.keySet().iterator();
		String case_title = indexed_it.next();
		HashMap<String, HashMap<String, String>> raw_case_data = indexed_task_data.get(case_title);
		// again: merge case data admin queue and local queue (remote need,
		// local is done)
		standard_case_data.putAll(get_standard_case_data(raw_case_data));
		if (task_info.get_received_task_queues_map().containsKey(queue_name)) {
			// local data only need to merge admin ID run info
			raw_task_data.putAll(get_merged_local_task_info(admin_data,standard_case_data));						
		} else {
			// remote data, initial merge, rerun remote task will use local
			// model(no merge need) (consider cmd option)
			raw_task_data.putAll(get_merged_remote_task_info(admin_data, standard_case_data));
		}
		task_data.putAll(merge_default_and_preference_data(raw_task_data, client_preference_data));
		return_data.putAll(update_task_data_path_info(task_data, client_preference_data));
		return return_data;
	}

	private Map<String, HashMap<String, HashMap<String, String>>> get_indexed_task_data(String queue_name) {
		Map<String, HashMap<String, HashMap<String, String>>> indexed_case_data = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		// buffered task queues_tube_map
		if (task_info.get_received_task_queues_map().containsKey(queue_name)) {
			// task case from local
			// System.out.println(">>>>:" + Thread.currentThread().getName());
			indexed_case_data.putAll(task_info.get_one_indexed_case_data(queue_name));
		} else {
			try {
				indexed_case_data.putAll(rmq_tube.read_task_server(queue_name));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
				TASK_WAITER_LOGGER.info(waiter_name + ":Found empty/invalid Task Queue:" + queue_name);
			}
		}
		return indexed_case_data;
	}

	private void move_finished_admin_queue_from_tube(String queue_name) {
		// move received admin queue data to processed queue data
		HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
		queue_data.putAll(task_info.get_queue_data_from_received_admin_queues_treemap(queue_name));
		if (queue_data == null || queue_data.isEmpty()) {
			TASK_WAITER_LOGGER.info(waiter_name + ":Move queue already finished, " + queue_name);
			return;
		}
		HashMap<String, String> status_data = queue_data.get("Status");
		status_data.put("admin_status", queue_enum.FINISHED.get_description());
		task_info.update_queue_to_processed_admin_queues_treemap(queue_name, queue_data);
		// delete all buffered info
		task_info.remove_queue_from_received_admin_queues_treemap(queue_name);
		task_info.remove_queue_from_captured_admin_queues_treemap(queue_name);
	}

	private void move_finished_task_queue_from_tube(String queue_name) {
		// only need to remove buffered task queue in received task map if
		// have(task from rmq do not have)
		// since task case will add into processed task map, so we don't need to
		// copy again.
		task_info.remove_queue_from_received_task_queues_map(queue_name);
	}

	private HashMap<String, HashMap<String, String>> get_standard_case_data(
			HashMap<String, HashMap<String, String>> case_data) {
		HashMap<String, HashMap<String, String>> formated_data = new HashMap<String, HashMap<String, String>>();
		// ID format
		HashMap<String, String> id_hash = new HashMap<String, String>();
		String project = new String("");
		String run = new String("");
		String suite = new String("");
		String section = new String("");
		String id = new String("");
		id_hash.put("project", project);
		id_hash.put("run", run);
		id_hash.put("suite", suite);
		id_hash.put("section", section);
		id_hash.put("id", id);
		if (case_data.containsKey("ID")) {
			id_hash.putAll(case_data.get("ID"));
		}
		// remote task queue use TestID while local parser user ID for total
		if (case_data.containsKey("TestID")) {
			id_hash.putAll(case_data.get("TestID"));
		}
		formated_data.put("ID", id_hash);
		// CaseInfo format
		HashMap<String, String> caseinfo_hash = new HashMap<String, String>();
		// local xlsx file containing folded/path
		String xlsx_dest = new String("");
		String repository = new String("");
		String suite_path = new String("");
		String design_name = new String("");
		String script_address = new String("");
		caseinfo_hash.put("xlsx_dest", xlsx_dest);
		caseinfo_hash.put("repository", repository);
		caseinfo_hash.put("suite_path", suite_path);
		caseinfo_hash.put("design_name", design_name);
		caseinfo_hash.put("script_address", script_address);
		if (case_data.containsKey("CaseInfo")) {
			caseinfo_hash.putAll(case_data.get("CaseInfo"));
		}
		formated_data.put("CaseInfo", caseinfo_hash);
		// Environment no default data now
		HashMap<String, String> envinfo_hash = new HashMap<String, String>();
		if (case_data.containsKey("Environment")) {
			envinfo_hash.putAll(case_data.get("Environment"));
		}
		formated_data.put("Environment", envinfo_hash);
		// LaunchCommand format
		HashMap<String, String> command_hash = new HashMap<String, String>();
		String cmd = new String("");
		String dir = new String("");
		String override = new String("");
		command_hash.put("cmd", cmd);
		command_hash.put("dir", dir);
		command_hash.put("override", override);
		if (case_data.containsKey("LaunchCommand")) {
			command_hash.putAll(case_data.get("LaunchCommand"));
		}
		formated_data.put("LaunchCommand", command_hash);
		// Machine format
		HashMap<String, String> machine_hash = new HashMap<String, String>();
		String terminal = new String("");
		String group = new String("");
		machine_hash.put("terminal", terminal);
		machine_hash.put("group", group);
		if (case_data.containsKey("Machine")) {
			machine_hash.putAll(case_data.get("Machine"));
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
		if (case_data.containsKey("System")) {
			system_hash.putAll(case_data.get("System"));
		}
		formated_data.put("System", system_hash);
		// Software format
		HashMap<String, String> software_hash = new HashMap<String, String>();
		if (case_data.containsKey("Software")) {
			software_hash.putAll(case_data.get("Software"));
		}
		formated_data.put("Software", software_hash);
		// Status format
		HashMap<String, String> status_hash = new HashMap<String, String>();
		String admin_status = new String("");
		String cmd_status = new String("Processing");
		String cmd_reason = new String("");
		String location = new String("");
		String run_time = new String("");
		String update_time = new String("");
		status_hash.put("admin_status", admin_status);
		status_hash.put("cmd_status", cmd_status);
		status_hash.put("cmd_reason", cmd_reason);
		status_hash.put("location", location);
		status_hash.put("run_time", run_time);
		status_hash.put("update_time", update_time);
		if (case_data.containsKey("Status")) {
			status_hash.putAll(case_data.get("Status"));
		}
		formated_data.put("Status", status_hash);
		//paths format
		HashMap<String, String> paths_hash = new HashMap<String, String>();
		//String work_space = new String("");
		//String save_space = new String("");
		String depot_space = new String("");// repository + suite path
		String case_path = new String("");
		String task_path = new String("");
		String save_path = new String("");
		String script_path = new String("");
		String launch_path = new String("");
		//paths_hash.put("work_space", work_space);
		//paths_hash.put("save_space", save_space);
		paths_hash.put("depot_space", depot_space);
		paths_hash.put("case_path", case_path);
		paths_hash.put("task_path", task_path);
		paths_hash.put("save_path", save_path);
		paths_hash.put("script_path", script_path);
		paths_hash.put("launch_path", launch_path);
		formated_data.put("Paths", paths_hash);
		return formated_data;
	}

	private HashMap<String, HashMap<String, String>> merge_default_and_preference_data(
			HashMap<String, HashMap<String, String>> case_data,
			HashMap<String, String> preference_data) {
		HashMap<String, HashMap<String, String>> default_data = new HashMap<String, HashMap<String, String>>();
		// ID format NA
		HashMap<String, String> id_hash = new HashMap<String, String>();
		if (case_data.containsKey("ID")) {
			id_hash.putAll(case_data.get("ID"));
		}
		default_data.put("ID", id_hash);
		// CaseInfo format, 4 level override:
		// default < configure < command line < task 
		HashMap<String, String> caseinfo_hash = new HashMap<String, String>();
		String auth_key = public_data.ENCRY_DEF_STRING;
		String priority = public_data.TASK_DEF_PRIORITY;
		String timeout = public_data.TASK_DEF_TIMEOUT;
		String result_keep = public_data.TASK_DEF_RESULT_KEEP;
		String path_keep = public_data.DEF_COPY_PATH_KEEP;
		if (preference_data.containsKey("result_keep")){
			result_keep = preference_data.get("result_keep");
		}
		if (preference_data.containsKey("path_keep")){
			path_keep = preference_data.get("path_keep");
		}		
		caseinfo_hash.put("auth_key", auth_key);
		caseinfo_hash.put("priority", priority);
		caseinfo_hash.put("timeout", timeout);
		caseinfo_hash.put("result_keep", result_keep);
		caseinfo_hash.put("path_keep", path_keep);
		if (case_data.containsKey("CaseInfo")) {
			caseinfo_hash.putAll(case_data.get("CaseInfo"));
		}
		default_data.put("CaseInfo", caseinfo_hash);
		// Environment NA
		HashMap<String, String> envinfo_hash = new HashMap<String, String>();
		if (case_data.containsKey("Environment")) {
			envinfo_hash.putAll(case_data.get("Environment"));
		}
		default_data.put("Environment", envinfo_hash);
		// LaunchCommand NA
		HashMap<String, String> command_hash = new HashMap<String, String>();
		if (case_data.containsKey("LaunchCommand")) {
			command_hash.putAll(case_data.get("LaunchCommand"));
		}
		default_data.put("LaunchCommand", command_hash);
		// Machine format NA
		HashMap<String, String> machine_hash = new HashMap<String, String>();
		if (case_data.containsKey("Machine")) {
			machine_hash.putAll(case_data.get("Machine"));
		}
		default_data.put("Machine", machine_hash);
		// System format NA
		HashMap<String, String> system_hash = new HashMap<String, String>();
		if (case_data.containsKey("System")) {
			system_hash.putAll(case_data.get("System"));
		}
		default_data.put("System", system_hash);
		// Software NA
		HashMap<String, String> software_hash = new HashMap<String, String>();
		if (case_data.containsKey("Software")) {
			software_hash.putAll(case_data.get("Software"));
		}
		default_data.put("Software", software_hash);
		// Status NA
		HashMap<String, String> status_hash = new HashMap<String, String>();
		if (case_data.containsKey("Status")) {
			status_hash.putAll(case_data.get("Status"));
		}
		default_data.put("Status", status_hash);
		// Paths NA
		HashMap<String, String> paths_hash = new HashMap<String, String>();
		paths_hash.put("work_space", public_data.DEF_WORK_SPACE);
		paths_hash.put("save_space", public_data.DEF_SAVE_SPACE);
		if (preference_data.containsKey("work_space")){
			paths_hash.put("work_space", preference_data.get("work_space"));
		}
		if (preference_data.containsKey("save_space")){
			paths_hash.put("save_space", preference_data.get("save_space"));
		}		
		if (case_data.containsKey("Paths")) {
			paths_hash.putAll(case_data.get("Paths"));
		}
		default_data.put("Paths", paths_hash);		
		return default_data;
	}

	private HashMap<String, HashMap<String, String>> update_task_data_path_info(
			HashMap<String, HashMap<String, String>> case_data,
			HashMap<String, String> preference_data) {	
		HashMap<String, HashMap<String, String>> task_data = new HashMap<String, HashMap<String, String>>();
		String depot_space = new String("");// repository + suite path
		String design_source = new String("");
		String case_path = new String("");
		String task_path = new String("");
		String save_path = new String("");
		String script_source = new String("");
		String launch_path = new String("");
		String report_path = new String(""); //also named location in Status
		//initialize all data
		task_data.putAll(deep_clone.clone(case_data));
		HashMap<String, String> paths_hash = new HashMap<String, String>();
		paths_hash.putAll(task_data.get("Paths"));
		// common info prepare
		String xlsx_dest = task_data.get("CaseInfo").get("xlsx_dest").trim();
		String repository = task_data.get("CaseInfo").get("repository").trim();	
		String suite_path = task_data.get("CaseInfo").get("suite_path").trim();	
		String design_name = task_data.get("CaseInfo").get("design_name").trim();
		String launch_dir = task_data.get("LaunchCommand").get("dir").trim();
		String tmp_result = public_data.WORKSPACE_RESULT_DIR;
		String prj_name = "prj" + task_data.get("ID").get("project");
		String run_name = "run" + task_data.get("ID").get("run");
		String task_name = "T" + task_data.get("ID").get("id");
		String work_space = preference_data.get("work_space");
		String save_space = preference_data.get("save_space");
		String case_mode = preference_data.get("case_mode");
		String path_keep = preference_data.get("path_keep");
		File design_name_fobj = new File(design_name);
		String design_base_name = design_name_fobj.getName();
		//get depot_space
		repository = repository.replaceAll("\\$xlsx_dest", xlsx_dest);
		depot_space = repository + "/" + suite_path;
		paths_hash.put("depot_space", depot_space.replaceAll("\\\\", "/"));
		//get source_path
		design_source = repository + "/" + suite_path + "/" + design_name;
		paths_hash.put("design_source", design_source.replaceAll("\\\\", "/"));
		//get case_path
		if (case_mode.equalsIgnoreCase("keep_case")){
			case_path = design_source;
		} else {
			if(path_keep.equalsIgnoreCase("true")){
				String[] path_array = new String[] { work_space, tmp_result, prj_name, run_name, design_name };
				case_path = String.join(file_seprator, path_array);
			} else {
				String[] path_array = new String[] { work_space, tmp_result, prj_name, run_name, task_name,  design_base_name};
				case_path = String.join(file_seprator, path_array);
			}	
		}
		paths_hash.put("case_path", case_path.replaceAll("\\\\", "/"));
		//get task_path
		if (case_mode.equalsIgnoreCase("keep_case")){
			task_path = repository + "/" + suite_path;
		} else {
			if(path_keep.equalsIgnoreCase("true")){
				String[] path_array = new String[] { work_space, tmp_result, prj_name, run_name };
				task_path = String.join(file_seprator, path_array);
			} else {
				String[] path_array = new String[] { work_space, tmp_result, prj_name, run_name, task_name};
				task_path = String.join(file_seprator, path_array);
			}
		}
		paths_hash.put("task_path", task_path.replaceAll("\\\\", "/"));
		//get save_path
		if (case_mode.equalsIgnoreCase("keep_case")){
			save_path = repository + "/" + suite_path + "/" + design_name;
		} else {
			if(path_keep.equalsIgnoreCase("true")){
				String[] path_array = new String[] { save_space, tmp_result, prj_name, run_name, design_name };
				save_path = String.join(file_seprator, path_array);
			} else {
				String[] path_array = new String[] { save_space, tmp_result, prj_name, run_name, task_name};
				save_path = String.join(file_seprator, path_array);
			}
		}
		paths_hash.put("save_path", save_path.replaceAll("\\\\", "/"));	
		//get script_source
		script_source = task_data.get("CaseInfo").get("script_address").trim();
		script_source = script_source.replaceAll("\\$work_path", work_space);// = work_space
		script_source = script_source.replaceAll("\\$case_path", case_path);
		script_source = script_source.replaceAll("\\$tool_path", public_data.TOOLS_ROOT_PATH);		
		paths_hash.put("script_source", script_source.replaceAll("\\\\", "/"));
		//get launch_path
		if ( launch_dir != ""){
			launch_path = launch_dir.replaceAll("\\$case_path", case_path);
		} else {
			launch_path = task_path;
		}
		paths_hash.put("launch_path", launch_path.replaceAll("\\\\", "/"));
		//get report_path
		if (case_mode.equalsIgnoreCase("keep_case")){
			report_path = case_path;
		} else {
			if(path_keep.equalsIgnoreCase("true")){
				report_path = case_path;
			} else {
				report_path = task_path;
			}
		}
		paths_hash.put("report_path", report_path.replaceAll("\\\\", "/"));
		//push back
		task_data.put("Paths", paths_hash);
		return task_data;
	}
	
	private HashMap<String, HashMap<String, String>> get_merged_local_task_info(
			HashMap<String, HashMap<String, String>> admin_hash, 
			HashMap<String, HashMap<String, String>> case_hash) {
		HashMap<String, HashMap<String, String>> merged_data = new HashMap<String, HashMap<String, String>>();
		// case_hash is formated
		String admin_id_run = admin_hash.get("ID").get("run"); 
		HashMap<String, String> id_data = case_hash.get("ID");
		id_data.put("run", admin_id_run);
		merged_data.putAll(case_hash);
		return merged_data;
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
			time_out = "36000";
		}
		return Integer.parseInt(time_out);
	}
	
	private String get_last_error_msg(ArrayList<String> message_list){
		String return_string = new String("NA");
		// <status>Passed</status>
		Pattern p = Pattern.compile("^error", Pattern.CASE_INSENSITIVE);		
		for (String line : message_list) {
			Matcher m = p.matcher(line);
			if (m.find()) {
				return_string = line;
			}
		}		
		return return_string;
	}
	
	private void run_pre_launch_reporting(
			String queue_name, 
			String case_id,			
			HashMap<String, HashMap<String, String>> task_data,
			task_prepare prepare_obj,
			task_report report_obj,
			Boolean prepare_ok
			){
		//synchronized (this.getClass()) {}
		//prepare common inform
		String run_time = new String("NA");
		String update_time = new String(time_info.get_man_date_time());
		String cmd_status = new String(task_enum.OTHERS.get_description());
		if (prepare_ok){
			cmd_status = task_enum.PROCESSING.get_description();
		} else {
			cmd_status = task_enum.BLOCKED.get_description();
		}
		ArrayList<String> task_prepare_info_list = new ArrayList<String>();
		task_prepare_info_list.addAll(prepare_obj.task_prepare_info);
		String cmd_reason = new String("NA");
		cmd_reason = get_last_error_msg(task_prepare_info_list);
		String report_path = new String("NA");
		report_path = task_data.get("Paths").get("report_path");
		//task 1 update processed task data info 
		HashMap<String, String> status_data = task_data.get("Status");
		status_data.put("run_time", run_time);
		status_data.put("update_time", update_time);
		status_data.put("cmd_status", cmd_status);
		status_data.put("cmd_reason", cmd_reason);
		status_data.put("location", report_path);
		task_info.update_case_to_processed_task_queues_map(queue_name, case_id, task_data);
		//task 2 send case report to local disk
		ArrayList<String> title_list = new ArrayList<String>();
		title_list.add("");
		title_list.add("[Export]");
		report_obj.dump_disk_task_report_data(report_path, title_list);
		report_obj.dump_disk_task_report_data(report_path, task_prepare_info_list);
		//task 3 send case report to tube
		HashMap<String, HashMap<String, Object>> report_data = new HashMap<String, HashMap<String, Object>>();
		HashMap<String, Object> hash_data = new HashMap<String, Object>();
		String task_index = case_id + "#" + queue_name;
		hash_data.put("testId", task_data.get("ID").get("id"));
		hash_data.put("suiteId", task_data.get("ID").get("suite"));
		hash_data.put("runId", task_data.get("ID").get("run"));
		hash_data.put("projectId", task_data.get("ID").get("project"));
		hash_data.put("design", task_data.get("CaseInfo").get("design_name"));		
		hash_data.put("status", cmd_status);
		hash_data.put("reason", cmd_reason);
		hash_data.put("location", report_path);
		hash_data.put("run_time", run_time);
		hash_data.put("update_time", update_time);
		report_data.put(task_index, hash_data);
		report_obj.send_tube_task_data_report(report_data, false);
	}
	
	public void run() {
		try {
			monitor_run();
		} catch (Exception run_exception) {
			run_exception.printStackTrace();
			String dump_path = client_info.get_client_preference_data().get("work_space") + "/"
					+ public_data.WORKSPACE_LOG_DIR + "/core_dump/dump.log";
			file_action.append_file(dump_path, " " + line_separator);
			file_action.append_file(dump_path, "####################" + line_separator);
			file_action.append_file(dump_path, time_info.get_date_time() + line_separator);			
			file_action.append_file(dump_path, run_exception.toString() + line_separator);
			for (Object item : run_exception.getStackTrace()) {
				file_action.append_file(dump_path, "    at " + item.toString() + line_separator);
			}
			switch_info.set_client_stop_request(exit_enum.DUMP);
		}
	}
	
	private void monitor_run() {
		// ============== All static job start from here ==============
		// initial 1 : import_history_finished_admin_queue
		task_info.update_finished_admin_queue_list(import_data.import_disk_finished_admin_queue_list(client_info));
		// initial 2 : retrieve previously dumping working queues
		retrieve_queues_into_memory();
		// initial end
		task_report report_obj = new task_report(pool_info, client_info);
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
				Thread.sleep(base_interval * 1 * 1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			// ============== All dynamic job start from here ==============
			// task 0 : initial preparing, update processing queues and load
			// task data for re-processing queues
			update_processing_queue_list();
			update_running_queue_list();
			// reload finished task data if queue changed to processing from finished
			reload_finished_queue_data();
			// task 1 : check available work thread and task queue 
			if (pool_info.get_available_thread() < 1) {
				continue;
			}
			if (task_info.get_processing_admin_queue_list().size() < 1) {
				if (waiter_name.equalsIgnoreCase("tw_0") && !switch_info.get_local_console_mode()){
					TASK_WAITER_LOGGER.info(waiter_name + ":No Processing queue found.");
				} else {
					TASK_WAITER_LOGGER.debug(waiter_name + ":No Processing queue found.");
				}
				continue;
			}
			// task 2 : get working queue ======================>key variable 1:
			// queue_name OK now
			String queue_name = new String();
			queue_name = get_right_task_queue();
			if (queue_name.equals("") || queue_name == null) {
				//only TW_0 can report out when there is no work queue found.
				if (waiter_name.equalsIgnoreCase("tw_0") && !switch_info.get_local_console_mode()){
					TASK_WAITER_LOGGER.info(waiter_name + ":No matched queue found.");
				} else {
					TASK_WAITER_LOGGER.debug(waiter_name + ":No matched queue found.");
				}
				continue;
			} else {
				TASK_WAITER_LOGGER.debug(waiter_name + ":Focus on " + queue_name);
			}
			// task 3 : get admin data ======================>key variable 2:
			// admin_data OK now
			HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
			admin_data.putAll(task_info.get_data_from_captured_admin_queues_treemap(queue_name));
			if (admin_data.isEmpty()) {
				TASK_WAITER_LOGGER.warn(waiter_name + ":empty admin queue find," + queue_name);
				continue; // in case this queue deleted by other threads
			}
			// task 4 : resource booking (thread, software usage) ==========>
			// Resource booking finished, release if not launched
			Boolean software_booking = client_info.booking_used_soft_insts(admin_data.get("Software"));
			if (!software_booking) {
				continue;
			}
			Boolean thread_booking = pool_info.booking_used_thread(1);
			if (!thread_booking) {
				client_info.release_used_soft_insts(admin_data.get("Software"));
				continue;
			}
			// task 5 : get one task case data ===============>key variable 3:
			// task_data OK now
			HashMap<String, HashMap<String, String>> task_data = new HashMap<String, HashMap<String, String>>();
			task_data.putAll(get_final_task_data(queue_name, admin_data, client_info.get_client_preference_data()));
			if (task_data.isEmpty()) {
				if (switch_info.get_local_console_mode()){
					TASK_WAITER_LOGGER.debug(waiter_name + ":Try change queue to finished status:" + queue_name);
				} else {
					TASK_WAITER_LOGGER.info(waiter_name + ":Try change queue to finished status:" + queue_name);
				}
				task_info.decrease_processing_admin_queue_list(queue_name);
				task_info.decrease_running_admin_queue_list(queue_name);
				// move queue form received to processed admin queue treemap
				move_finished_admin_queue_from_tube(queue_name);
				move_finished_task_queue_from_tube(queue_name);
				//update finished list must be placed here to avoid multi threads risk
				task_info.update_finished_admin_queue_list(queue_name);
				// release booking info
				client_info.release_used_soft_insts(admin_data.get("Software"));
				pool_info.release_used_thread(1);
				continue;
			}
			// task 6 : register task case to processed task queues map
			// ======>key variable 4: case_id OK now
			String case_id = new String("");
			case_id = task_data.get("ID").get("id");
			if (case_id == "" || case_id == null){
				TASK_WAITER_LOGGER.info(waiter_name + ":No Task id find, ignore:" + task_data.toString());
				client_info.release_used_soft_insts(admin_data.get("Software"));
				pool_info.release_used_thread(1);
				continue;				
			}
			Boolean register_status = task_info.register_case_to_processed_task_queues_map(queue_name, case_id,
					task_data);
			if (register_status) {
				if (switch_info.get_local_console_mode()){
					TASK_WAITER_LOGGER.debug(waiter_name + ":Launched " + queue_name + "," + case_id);
				} else {
					TASK_WAITER_LOGGER.info(waiter_name + ":Launched " + queue_name + "," + case_id);
				}
				// start running this queue.
				task_info.increase_running_admin_queue_list(queue_name);
			} else {
				if (switch_info.get_local_console_mode()){
					TASK_WAITER_LOGGER.debug(waiter_name + ":Register " + queue_name + "," + case_id + "Failed, skip.");
				} else {
					TASK_WAITER_LOGGER.info(waiter_name + ":Register " + queue_name + "," + case_id + "Failed, skip.");
				}
				client_info.release_used_soft_insts(admin_data.get("Software"));
				pool_info.release_used_thread(1);
				continue;// register false, someone register this case already.
			}
			// task 7 : get test case ready
			task_prepare prepare_obj = new task_prepare();
			Boolean task_case_ok = prepare_obj.get_task_case_ready(task_data, client_info.get_client_preference_data());
			if (!task_case_ok){
				client_info.release_used_soft_insts(admin_data.get("Software"));
				pool_info.release_used_thread(1);
				continue;			
			} 
			run_pre_launch_reporting(queue_name, case_id, task_data, prepare_obj, report_obj, task_case_ok);
			// task 8 : launch info prepare
			String launch_path = task_data.get("Paths").get("launch_path").trim();
			String[] launch_cmd = prepare_obj.get_launch_command(task_data);
			Map<String, String> launch_env = prepare_obj.get_launch_environment(task_data, client_info.get_client_data());
			// task 9 : launch
			int case_time_out = get_time_out(task_data.get("CaseInfo").get("timeout"));
			system_call sys_call = new system_call(launch_cmd, launch_env, launch_path, case_time_out);
			pool_info.add_sys_call(sys_call, queue_name, case_id, launch_path, case_time_out);
			/*
			ArrayList<String> case_prepare_list = new ArrayList<String>();
			String case_work_path = new String();
			try {
				case_work_path = prepare_obj.get_working_dir(task_data,
						client_info.get_client_preference_data().get("work_space"));
				case_prepare_list = prepare_obj.get_case_ready(task_data, case_work_path);
			} catch (Exception e) {
				e.printStackTrace();
				TASK_WAITER_LOGGER.warn(waiter_name + ":Case prepare failed, skip this case.");
				client_info.release_used_soft_insts(admin_data.get("Software"));
				pool_info.release_used_thread(1);
				continue;
			}
			String local_case_report = case_work_path + "/" + public_data.WORKSPACE_CASE_REPORT_NAME;
			file_action.append_file(local_case_report,
					"Client Version:" + public_data.BASE_CURRENTVERSION + line_separator);
			file_action.append_file(local_case_report, "[Export]" + line_separator);
			file_action.append_file(local_case_report, String.join(line_separator, case_prepare_list) + line_separator);
			// task 8 : launch cmd
			String[] run_cmd = prepare_obj.get_run_command(
					task_data,
					case_work_path,
					client_info.get_client_preference_data().get("work_space"));
			// task 9 : launch env
			Map<String, String> run_env = prepare_obj.get_run_environment(task_data, client_info.get_client_data());
			// task 10: launch dir by-default use case work path
			String run_dir = prepare_obj.get_run_directory(task_data, case_work_path);
			// task 11 : launch (add case info to task data)
			int case_time_out = get_time_out(task_data.get("CaseInfo").get("timeout"));
			String result_keep = task_data.get("CaseInfo").get("result_keep");
			system_call sys_call = new system_call(run_cmd, run_env, run_dir, case_time_out);
			pool_info.add_sys_call(sys_call, queue_name, case_id, case_work_path, case_time_out, result_keep);
			*/
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
