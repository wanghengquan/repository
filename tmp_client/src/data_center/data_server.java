/*
 * File: data_server.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package data_center;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import env_monitor.config_sync;
import env_monitor.machine_sync;
import info_parser.cmd_parser;
import info_parser.ini_parser;
import top_runner.run_manager.thread_enum;
import top_runner.run_status.exit_enum;
import top_runner.run_status.state_enum;
import utility_funcs.data_check;
import utility_funcs.deep_clone;
import utility_funcs.file_action;
import utility_funcs.system_cmd;
import utility_funcs.time_info;

/*
 * This class used to get the basic information of the client.
 * return machine_hash:
 * 		diamond	:	build	=	xxxx
 * 					scan_dir=	xxxx
 * 					max_insts = int
 * 		radiant	:	build	=	xxxx
 * 					scan_dir=	xxxx
 * 					scan_cmd=   xxxx
 * 					max_insts = int 
 * 		...
 * 		System	:	os		=	type_arch
 * 					os_type	=	windows/linux
 * 					os_arch	=	32b/64b
 * 					space	=	xx	G
 * 					cpu		=	xx	%
 * 					mem		=	xx	%
 * 					status  =   Free/Busy/Suspend
 * 
 *      CoreScript: version =   xx
 *                  time    =   xx
 *                  status  =   latest/updating/NA
 *                  connection = 0/1
 *                  remote_version = xx
 *                  remote_time =xx
 *                  
 * 		Machine	:	terminal=	xxx
 * 					ip		=	xxx
 * 					group	=	xxx
 *                  account =   xxx
 * 					private	=	0/1
 * 					unattended = 0/1
 * 					stable_version = 0/1
 * 					start_time = xxxxx
 * 
 * 		tools   :   python = xxxx
 * 					perl   = xxxx
 *					ruby   = xxxx
 *					git    = xxxx
 *					svn    = xxxx
 * 
 * 	 preference :	thread_mode = xx
 * 					task_mode = xx
 * 					link_mode = both (from command line)
 * 					max_threads = xx
 *                  show_welcome = xx
 *                  auto_restart = xx
 * 					work_space = xx
 * 					save_space = xx
 *                  dev_mails = xx
 *                  opr_mails = xx
 *                  data from command line
 */
public class data_server extends Thread {
	// public property
	// protected property
	// private property
	private static final Logger DATA_SERVER_LOGGER = LogManager.getLogger(data_server.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread current_thread;
	private HashMap<String, String> cmd_info;
	private client_data client_info;
	private switch_data switch_info;
	private String line_separator = System.getProperty("line.separator");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;
	// sub threads need to be launched
	config_sync config_runner;
	machine_sync machine_runner;
	// public function
	// protected function
	// private function

	public data_server(
			HashMap<String, String> cmd_info, 
			switch_data switch_info,  
			client_data client_info) {
		this.cmd_info = cmd_info;
		this.client_info = client_info;
		this.switch_info = switch_info;
		this.config_runner = new config_sync(switch_info, client_info);
		this.machine_runner = new machine_sync(switch_info);
	}
	
	private String get_environ_tool_path(String tool) {
		String which_cmd = new String("");
		String host_run = System.getProperty("os.name").toLowerCase();
		if (host_run.startsWith("windows")) {
			which_cmd = public_data.TOOLS_WHICH + " ";
		} else {
			which_cmd = "which ";
		}
		String cmd = new String(which_cmd + " " + tool);
		ArrayList<String> excute_retruns = new ArrayList<String>();
		String path_str = new String("unknown");
		try {
			excute_retruns.addAll(system_cmd.run(cmd));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			DATA_SERVER_LOGGER.warn("Run command failed:" + cmd);			
		}
		Pattern path_patt = Pattern.compile(tool, Pattern.CASE_INSENSITIVE);
		for (String line : excute_retruns){
		    if(line == null || line == "")
		        continue;
		    if(line.contains("which")){
		    	continue;
		    }
			Matcher path_match = path_patt.matcher(line);
			if (path_match.find()) {
				path_str = line;
				break;
			}
		}
		if (path_str.equals("unknown")){
			DATA_SERVER_LOGGER.warn("No tool find according ENV PATH setting:" + cmd);
		}
		return path_str;
	}
	
	private void initial_merge_client_data(HashMap<String, String> cmd_hash) {
		HashMap<String, HashMap<String, String>> client_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, HashMap<String, String>> machine_hash = new HashMap<String, HashMap<String, String>>();
		HashMap<String, HashMap<String, String>> config_hash = new HashMap<String, HashMap<String, String>>();
		machine_hash.putAll(machine_sync.machine_hash);
		config_hash.putAll(config_sync.config_hash);
		// 1. merge Software data
		Iterator<String> config_it = config_hash.keySet().iterator();
		while (config_it.hasNext()) {
			String option = config_it.next();
			HashMap<String, String> option_data = config_hash.get(option);
			if (option.contains("tmp_")) {
				continue;
			}
			client_data.put(option, option_data);
		}
		// 2. merge System data
		client_data.put("System", machine_hash.get("System"));
		// 3. merge Machine data:
		// command data > configuration data > scan data > default data
		HashMap<String, String> machine_data = new HashMap<String, String>();
		machine_data.put("private", public_data.DEF_MACHINE_PRIVATE);
		machine_data.put("group", public_data.DEF_GROUP_NAME);
		machine_data.put("account", System.getProperty("user.name"));
		machine_data.put("unattended", public_data.DEF_UNATTENDED_MODE);
		machine_data.put("debug", public_data.DEF_CLIENT_DEBUG_MODE);
		machine_data.putAll(machine_hash.get("Machine")); // Scan data
		if (config_hash.containsKey("tmp_machine")) {
			machine_data.putAll(config_hash.get("tmp_machine")); // configuration
		}
		if(cmd_hash.containsKey("unattended")){				// add command line data
			machine_data.put("unattended", cmd_hash.get("unattended"));
		}
		if(cmd_hash.containsKey("debug")){
			machine_data.put("debug", cmd_hash.get("debug"));
		}
		client_data.put("Machine", machine_data);
		// 4. merge tools data
		// cmd >  conf > env > default
		HashMap<String, String> tools_data = new HashMap<String, String>();
		// Default
		tools_data.put("python", public_data.DEF_PYTHON_PATH);
		tools_data.put("perl", public_data.DEF_PERL_PATH);
		tools_data.put("ruby", public_data.DEF_RUBY_PATH);
		tools_data.put("svn", public_data.DEF_SVN_PATH);
		tools_data.put("git", public_data.DEF_GIT_PATH);
		// environ
		String env_python = new String(get_environ_tool_path("python"));
		if (data_check.str_file_check(env_python)) {
			tools_data.put("python", env_python);
		}
		String env_perl = new String(get_environ_tool_path("perl"));
		if (data_check.str_file_check(env_perl)) {
			tools_data.put("perl", env_perl);
		}
		String env_ruby = new String(get_environ_tool_path("ruby"));
		if (data_check.str_file_check(env_ruby)) {
			tools_data.put("ruby", env_ruby);
		}
		String env_svn = new String(get_environ_tool_path("svn"));
		if (data_check.str_file_check(env_svn)) {
			tools_data.put("svn", env_svn);
		}
		String env_git = new String(get_environ_tool_path("git"));
		if (data_check.str_file_check(env_git)) {
			tools_data.put("git", env_git);
		}
		// config file
		if(config_hash.containsKey("tmp_tools")) {
			tools_data.putAll(config_hash.get("tmp_tools"));
		}
		// command line
		if(cmd_hash.containsKey("python")){
			tools_data.put("python", cmd_hash.get("python"));
		}
		if(cmd_hash.containsKey("perl")){
			tools_data.put("perl", cmd_hash.get("perl"));
		}
		if(cmd_hash.containsKey("ruby")){
			tools_data.put("ruby", cmd_hash.get("ruby"));
		}
		if(cmd_hash.containsKey("svn")){
			tools_data.put("svn", cmd_hash.get("svn"));
		}
		if(cmd_hash.containsKey("git")){
			tools_data.put("git", cmd_hash.get("git"));
		}		
		client_data.put("tools", tools_data);
		// 5. merge preference data (for software use):
		// command data > configuration data > default data in public_data
		HashMap<String, String> preference_data = new HashMap<String, String>();
		preference_data.put("thread_mode", public_data.DEF_MAX_THREAD_MODE);
		preference_data.put("task_mode", public_data.DEF_TASK_ASSIGN_MODE);
		preference_data.put("link_mode", public_data.DEF_CLIENT_LINK_MODE);
		preference_data.put("case_mode", public_data.DEF_CLIENT_CASE_MODE);
		preference_data.put("interface_mode", public_data.DEF_INTERFACE_MODE);
		preference_data.put("stable_version", public_data.DEF_STABLE_VERSION);
		preference_data.put("ignore_request", public_data.DEF_CLIENT_IGNORE_REQUEST);
		preference_data.put("result_keep", public_data.TASK_DEF_RESULT_KEEP);
		preference_data.put("keep_path", public_data.DEF_COPY_KEEP_PATH);
		preference_data.put("lazy_copy", public_data.DEF_COPY_LAZY_COPY);
		preference_data.put("pool_size", String.valueOf(public_data.PERF_POOL_MAXIMUM_SIZE));
		preference_data.put("max_threads", String.valueOf(public_data.PERF_POOL_CURRENT_SIZE));
		preference_data.put("show_welcome", public_data.DEF_SHOW_WELCOME);
		preference_data.put("auto_restart", public_data.DEF_AUTO_RESTART);
		preference_data.put("dev_mails", public_data.BASE_DEVELOPER_MAIL);
		preference_data.put("opr_mails", public_data.BASE_OPERATOR_MAIL);
		preference_data.put("space_reserve", public_data.RUN_LIMITATION_SPACE);
		preference_data.put("work_space", public_data.DEF_WORK_SPACE);
		preference_data.put("save_space", public_data.DEF_SAVE_SPACE);
		//the following two are for history name support
		if(config_hash.get("tmp_preference").containsKey("work_path")){
			preference_data.put("work_space", config_hash.get("tmp_preference").get("work_path").replaceAll("\\\\", "/"));
		}
		if(config_hash.get("tmp_preference").containsKey("save_path")){
			preference_data.put("save_space", config_hash.get("tmp_preference").get("save_path").replaceAll("\\\\", "/"));
		}		
		preference_data.putAll(config_hash.get("tmp_preference"));
		preference_data.putAll(cmd_hash);
		client_data.put("preference", preference_data);
		client_info.set_client_data(client_data);
		DATA_SERVER_LOGGER.debug(client_data.toString());
	}

	/*
	 * private void initial_thread_pool_setting(){ int pool_size =
	 * Integer.valueOf(client_info.get_client_preference_data().get("pool_size"));
	 * int max_threads =
	 * Integer.valueOf(client_info.get_client_preference_data().get("max_threads"));
	 * pool_info.initialize_thread_pool(pool_size); if (max_threads > pool_size){
	 * DATA_SERVER_LOGGER.warn("max_threads > pool_size, will use pool_size:" +
	 * pool_size +" as maximum threads num");
	 * pool_info.set_pool_current_size(pool_size); } else {
	 * pool_info.set_pool_current_size(max_threads); } }
	 */
	
	private void dynamic_merge_system_data(){
		HashMap<String, String> system_data = new HashMap<String, String>();
		system_data.putAll(machine_sync.machine_hash.get("System"));
		String current_work_space = new String(client_info.get_client_preference_data().get("work_space"));
		if(current_work_space != null && !current_work_space.trim().equals("")){
			system_data.put("space", machine_sync.get_avail_space(current_work_space));
		}		
		client_info.update_system_data(system_data);
	}
	
	// this function may get slipped condition
	private Boolean dynamic_merge_build_data() {
		//merge new data form: scan_dir, scan_cmd and machine data 
		Boolean data_updated = Boolean.valueOf(false);
		HashMap<String, HashMap<String, String>> client_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, HashMap<String, String>> update_data = new HashMap<String, HashMap<String, String>>();
		client_data.putAll(deep_clone.clone(client_info.get_client_data()));
		Iterator<String> section = client_data.keySet().iterator();
		while(section.hasNext()){
			String section_name = section.next();
			HashMap<String, String> section_data = new HashMap<String, String>();
			section_data.putAll(client_data.get(section_name));
			if (section_name.equals("System") || section_name.equals("CoreScript") || section_name.equals("Machine") || section_name.equals("tools") || section_name.equals("preference")){
				continue;
			}
			HashMap<String, String> build_data = new HashMap<String, String>();
			if(section_data.containsKey("scan_dir")){
				build_data.putAll(get_multi_scan_dir_build(section_data.get("scan_dir")));
			}
			if(section_data.containsKey("scan_cmd")){
				build_data.putAll(get_scan_cmd_build(section_data.get("scan_cmd")));
			} else {
				String def_scan_script = new String("python $tool_path/scan_"+ section_name + ".py");
				build_data.putAll(get_scan_cmd_build(def_scan_script));
			}
			update_data.put(section_name, build_data);
		}
		if(get_scan_build_diff(client_data, update_data)){
			client_info.update_scan_build_data(update_data);
			data_updated = true;
		}
		return data_updated;
	}

	private void update_max_sw_insts_limitation() {
		HashMap<String, Integer> max_soft_insts = new HashMap<String, Integer>();
		HashMap<String, HashMap<String, String>> client_hash = new HashMap<String, HashMap<String, String>>();
		client_hash.putAll(deep_clone.clone(client_info.get_client_data()));
		Iterator<String> key_it = client_hash.keySet().iterator();
		while (key_it.hasNext()) {
			String key = key_it.next();
			if (key.equalsIgnoreCase("preference")) {
				continue;
			}
			if (key.equalsIgnoreCase("machine")) {
				continue;
			}
			if (key.equalsIgnoreCase("corescript")) {
				continue;
			}
			if (key.equalsIgnoreCase("system")) {
				continue;
			}
			if (key.equalsIgnoreCase("tools")) {
				continue;
			}
			if (!client_hash.get(key).containsKey("max_insts")) {
				continue;
			}
			Integer insts_value = Integer.valueOf(public_data.DEF_SW_MAX_INSTANCES);
			try{
				insts_value = Integer.valueOf(client_hash.get(key).get("max_insts"));
			} catch (NumberFormatException e) {
				DATA_SERVER_LOGGER.warn("Wrong number format detected:" + client_hash.get(key).get("max_insts"));
				DATA_SERVER_LOGGER.warn("Will use the default value:" + public_data.DEF_SW_MAX_INSTANCES);
			}
			max_soft_insts.put(key, insts_value);
		}
		client_info.set_max_soft_insts(max_soft_insts);
	}

	private HashMap<String, String> get_multi_scan_dir_build(
			String scan_paths
			){
		HashMap<String, String> build_paths = new HashMap<String, String>();
		ArrayList<String> path_list = new ArrayList<String>();		
		if (scan_paths.contains(",")){
			path_list.addAll(Arrays.asList(scan_paths.split("\\s*,\\s*")));
		} else if (scan_paths.contains(";")){
			path_list.addAll(Arrays.asList(scan_paths.split("\\s*;\\s*")));
		} else{
			path_list.add(scan_paths);
		}
		for (String scan_path: path_list) {
			build_paths.putAll(get_scan_dir_build(scan_path));
		}
		return build_paths;
	}
	
	private HashMap<String, String> get_scan_dir_build(String scan_path) {
		HashMap<String, String> build_paths = new HashMap<String, String>();
		if(scan_path == null || scan_path.trim().equals("")){
			DATA_SERVER_LOGGER.warn("Illegal Scan path find, skip");
			return build_paths;
		}
		File scan_handler = new File(scan_path);
		if(!scan_handler.exists()){
			DATA_SERVER_LOGGER.warn("Scan path not exist:" + scan_path);
			return build_paths;
		}
		if(!scan_handler.isDirectory()){
			DATA_SERVER_LOGGER.warn("Scan path not a Directory:" + scan_path);
			return build_paths;
		}	
		File[] all_handlers = scan_handler.listFiles();
		if (all_handlers == null){
			DATA_SERVER_LOGGER.warn("Scan path have null sub paths:" + scan_path);
			return build_paths;
		}		
		for (File sub_handler : all_handlers) {
			String build_name = sub_handler.getName();
			if (!sub_handler.isDirectory()) {
				continue;
			}
			File success_file = new File(sub_handler.getAbsolutePath() + "/success.ini");
			if (!success_file.exists() || !success_file.canRead()) {
				DATA_SERVER_LOGGER.info("Success.ini file not exists/readable:" + scan_path);
				continue;
			}
			ini_parser build_parser = new ini_parser(success_file.getAbsolutePath().replaceAll("\\\\", "/"));
			HashMap<String, HashMap<String, String>> build_data = new HashMap<String, HashMap<String, String>>();
			try {
				build_data.putAll(build_parser.read_ini_data());
			} catch (Exception e) {
				DATA_SERVER_LOGGER.warn("Wrong format for:" + success_file.getAbsolutePath() + ", skipped.");
				continue;				
			}
			if (!build_data.containsKey("root")) {
				continue;
			}
			if (!build_data.get("root").containsKey("path")) {
				continue;
			}
			String path = build_data.get("root").get("path");
			DATA_SERVER_LOGGER.debug("Catch SW path:" + path);
			File path_handler = new File(path);
			if (path_handler.exists()){
				build_paths.put("sd_" + build_name, path);
			}
		}
		return build_paths;
	}

	private HashMap<String, String> get_scan_cmd_build(String scan_cmd) {
		HashMap<String, String> extra_dirs = new HashMap<String, String>();
		if(scan_cmd == null || scan_cmd.trim().equals("")){
			DATA_SERVER_LOGGER.warn("Illegal Scan cmd find, skip");
			return extra_dirs;
		}		
		ArrayList<String> cmd_output = new ArrayList<String>();
		scan_cmd = scan_cmd.replaceAll("\\$work_path", client_info.get_client_preference_data().get("work_space"));
		scan_cmd = scan_cmd.replaceAll("\\$tool_path", public_data.TOOLS_ROOT_PATH);
		try {
			cmd_output.addAll(system_cmd.run(scan_cmd));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			DATA_SERVER_LOGGER.warn("Run scan command failed");
			return extra_dirs;
		}
		int build_counter = 1;
		for (String line : cmd_output){
			if (line == null || !line.startsWith("build:")){
				continue;
			}
			String build = line.split(":", 2)[1];
			String build_name = build.split("=")[0].trim();
			String build_path = build.split("=")[1].trim();
			File path_dobj = new File(build_path);
			if (!path_dobj.exists()){
				continue;
			}
			if (build_counter > public_data.DEF_SCAN_CMD_TAKE_LINE) {
				break;//only top 10 build will be take
			}
			extra_dirs.put("sc_" + build_name, build_path);
			build_counter++;
		}
		return extra_dirs;
	}
	
	private Boolean get_scan_build_diff(
			HashMap<String, HashMap<String, String>> ori_data, 
			HashMap<String, HashMap<String, String>> new_data) {
		//just check whether new_data have scan data(sd, sc) that ori_data don't have.
		if (new_data.isEmpty()) {
			return false;
		}
		Iterator<String> new_section_it = new_data.keySet().iterator();
		while (new_section_it.hasNext()) {
			String new_section = new_section_it.next();
			if (!ori_data.containsKey(new_section)) {
				return true;
			}
			Iterator<String> new_option_it = new_data.get(new_section).keySet().iterator();
			while(new_option_it.hasNext()){
				String new_option = new_option_it.next();
				if (!ori_data.get(new_section).containsKey(new_option)) {
					return true;
				}
			}
		}
		return false;
	}
	
	/*
	 * scan update
	 */
	private void remove_invalid_build_path() {
		//software scan_dir and scan_cmd update
		HashMap<String, HashMap<String, String>> client_data = new HashMap<String, HashMap<String, String>>();
		client_data.putAll(deep_clone.clone(client_info.get_client_data()));
		Iterator<String> section_it = client_data.keySet().iterator();
		while (section_it.hasNext()) {
			String section = section_it.next();
			HashMap<String, String> section_data = new HashMap<String, String>();
			section_data.putAll(client_data.get(section));
			if (section.equals("preference")) {
				continue;
			}
			if (section.equals("Machine")) {
				continue;
			}
			if (section.equals("System")) {
				continue;
			}
			if (section.equals("CoreScript")) {
				continue;
			}
			if (section.equals("tools")) {
				continue;
			}
			Iterator<String> option_it = section_data.keySet().iterator();
			while (option_it.hasNext()) {
				String option = option_it.next();
				String value = section_data.get(option);
				if (option.equals("scan_dir")) {
					continue;
				} else if (option.equals("scan_cmd")){
					continue;
				} else if (option.equals("max_insts")) {
					continue;
				} else {
					File sw_path = new File(value);
					if (sw_path.exists()) {
						continue;
					} else {
						DATA_SERVER_LOGGER.warn(section + "." + option + ":" + value + ", not exist. skipped");
						client_info.delete_software_build(section, option);
					}
				}
			}	
		}
	}
	
	private void update_client_current_status(){
		status_enum system_status = calculate_client_current_status();
		HashMap<String, String> system_data = new HashMap<String, String>();
		system_data.put("status", system_status.get_description());
		client_info.update_system_data(system_data);		
	}
	
	private status_enum calculate_client_current_status(){
		HashMap<String, String> system_data = new HashMap<String, String>();
		system_data.putAll(client_info.get_client_system_data());
		state_enum client_state = switch_info.get_client_run_state();
		if (client_state.equals(state_enum.maintain)){
			return status_enum.SUSPEND;
		}
		String cpu_used = system_data.get("cpu");
		int cpu_used_int = 0;
		try{
			cpu_used_int = Integer.parseInt(cpu_used);
		} catch (Exception e) {
			return status_enum.UNKNOWN;
		}
		if (cpu_used_int > public_data.RUN_LIMITATION_CPU / 2){
			return status_enum.BUSY;
		} else {
			return status_enum.IDLE;
		}
	}
	
	private void update_system_property_data(){
		//1. set system log_path data (log4j 2 use)
		System.setProperty("log_path", client_info.get_client_preference_data().get("work_space"));
	}
	
	private Boolean debug_dump_client_data(){
		Boolean dump_status = Boolean.valueOf(true);
		if (!client_info.get_client_machine_data().get("debug").equals("1")){
			return dump_status;
		}
		String work_space = client_info.get_client_preference_data().get("work_space");
		String log_folder = public_data.WORKSPACE_LOG_DIR;
		String dump_file = work_space + "/" + log_folder + "/debug/local/client_data.txt";
		//generate title
		StringBuilder title_sb = new StringBuilder();
		title_sb.append("Time" + ",");
		title_sb.append("CPU" + ",");
		title_sb.append("MEM" + ",");
		title_sb.append("Space" + ",");
		title_sb.append("CoreScript");
		String title = title_sb.toString();
		//generate message line
		HashMap<String, String> system_data = new HashMap<String, String>();
		system_data.putAll(deep_clone.clone(client_info.get_client_system_data()));
		HashMap<String, String> corescript_data = new HashMap<String, String>();
		corescript_data.putAll(deep_clone.clone(client_info.get_client_corescript_data()));
		StringBuilder msg_sb = new StringBuilder();
		msg_sb.append(time_info.get_date_time() + ",");
		msg_sb.append(system_data.getOrDefault("cpu", "NA") + ",");
		msg_sb.append(system_data.getOrDefault("mem", "NA") + ",");
		msg_sb.append(system_data.getOrDefault("space", "NA") + ",");
		msg_sb.append(corescript_data.getOrDefault("version", "NA") + line_separator);
		String message = msg_sb.toString();
		//dump
		file_action.append_file_with_title(dump_file, title, message);
		return dump_status;
	}
	
	public void run() {
		try {
			monitor_run();
		} catch (Exception run_exception) {
			run_exception.printStackTrace();
			switch_info.set_client_stop_exception(run_exception);
			switch_info.set_client_stop_request(exit_enum.DUMP);
		}
	}

	private void monitor_run() {
		current_thread = Thread.currentThread();
		// ============== All static job start from here ==============
		// initial 1 : start client data worker: 1) config_sync 2) machine_sync
		config_runner.start();
		machine_runner.start();
		while (true) {
			if (machine_sync.machine_hash.containsKey("System") && config_sync.config_hash.containsKey("tmp_preference")) {
				if (machine_sync.machine_hash.get("System").containsKey("mem") && machine_sync.machine_hash.get("System").containsKey("cpu")) {
					break;
				}
			}
		}
 		// initial 2 : generate initial client data
		initial_merge_client_data(cmd_info);
		// initial 3 : update default current size into Pool Data
		// initial_thread_pool_setting();  1213 //should this item go to hall manager
		// initial 4 : Announce data server ready
		switch_info.set_data_server_power_up();
		// loop start
		while (!stop_request) {
			if (wait_request) {
				try {
					synchronized (this) {
						this.wait();
					}
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} else {
				DATA_SERVER_LOGGER.info("data_server Thread running...");
				switch_info.update_threads_active_map(thread_enum.data_runner, time_info.get_date_time());
			}
			// ============== All dynamic job start from here ==============
			// task 1: update client build data
			Boolean build_update = dynamic_merge_build_data();
			if (build_update){
				switch_info.set_client_updated();
			}
			// task 2: update client System data
			dynamic_merge_system_data();
			// task 3: update client current status
			update_client_current_status();			
			// task 4: check and remove invalid build path
			remove_invalid_build_path();
			// task 5: update max_sw_insts limitation
			update_max_sw_insts_limitation();
			// task 6: update system property data
			update_system_property_data();
			// task 7: dump client local data
			debug_dump_client_data();
			// HashMap<String, Integer> soft_ware =
			DATA_SERVER_LOGGER.debug(client_info.get_max_soft_insts());
			DATA_SERVER_LOGGER.debug(client_info.get_used_soft_insts());
			DATA_SERVER_LOGGER.debug(client_info.get_client_data());
			try {
				Thread.sleep(base_interval * 2 * 1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public void soft_stop() {
		config_runner.soft_stop();
		machine_runner.soft_stop();
		stop_request = true;
	}

	public void hard_stop() {
		config_runner.soft_stop();
		machine_runner.soft_stop();
		stop_request = true;
		if (current_thread != null) {
			current_thread.interrupt();
		}
	}

	public void wait_request() {
		config_runner.wait_request();
		machine_runner.wait_request();
		wait_request = true;
	}

	public void wake_request() {
		config_runner.wake_request();
		machine_runner.wake_request();
		wait_request = false;
		synchronized (this) {
			this.notify();
		}
	}

	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		cmd_parser cmd_run = new cmd_parser(args);
		HashMap<String, String> cmd_info = cmd_run.cmdline_parser();
		switch_data switch_info = new switch_data();
		client_data client_info = new client_data();
		data_server server_runner = new data_server(cmd_info, switch_info, client_info);
		server_runner.start();
		try {
			Thread.sleep(10 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// server_runner.soft_stop();
		System.out.println(client_info.get_client_data().toString());
	}
}