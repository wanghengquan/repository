/*
 * File: system_info.java
 * Description: run system command line
 * Author: Jason.Wang
 * Date:2017/02/16
 * Modifier:
 * Date:
 * Description:
 */

package env_monitor;

import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.commons.configuration2.ex.ConfigurationException;
import org.apache.commons.io.FileUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import info_parser.ini_parser;
import top_runner.run_manager.thread_enum;
import top_runner.run_status.exit_enum;
import utility_funcs.data_check;
import utility_funcs.deep_clone;
import utility_funcs.time_info;
import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;

/*
 * This class used to get the basic information of the client and dump data to configure file
 * return machine_hash:
 * 		radiant	:	dng_b1	=	xxx
 * 					ng1_0.954=	xxx
 * 					scan_dir=	xxx
 * 					max_insts=	xxx
 * 					scan_cmd=	xxx   //for extra user defined build path scan
 * 		....(other software)
 * 
 * 		tmp_machine:terminal=	xxx
 * 					group	=	xxx
 * 					private = 	0
 * 					unattended = 1  unattended mode (no user there)
 * 
 *tmp_preference:	thread_mode = auto, manual
 *					task_mode = auto, parallel, serial
 * 					max_threads = 5
 * 					work_space =	xxx
 * 					save_space =	xxx
 * 					
 */
public class config_sync extends Thread {
	// public property
	public static ConcurrentHashMap<String, HashMap<String, String>> config_hash = new ConcurrentHashMap<String, HashMap<String, String>>();
	// protected property
	// private property
	private static final Logger CONFIG_SYNC_LOGGER = LogManager.getLogger(config_sync.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread conf_thread;
	private client_data client_info;
	private switch_data switch_info;
	//private String line_separator = System.getProperty("line.separator");
	private String user_home_dir = System.getProperty("user.home").replaceAll("\\\\", "/");
	private String user_name = System.getProperty("user.name");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;

	// public function
	public config_sync() {

	}

	public config_sync(switch_data switch_info, client_data client_info) {
		this.switch_info = switch_info;
		this.client_info = client_info;
	}
	// protected function
	// private function

	private HashMap<String, HashMap<String, String>> import_data_verification(
			HashMap<String, HashMap<String, String>> ini_data
			) {
		HashMap<String, HashMap<String, String>> verified_data = new HashMap<String, HashMap<String, String>>();
		Iterator<String> section_it = ini_data.keySet().iterator();
		while(section_it.hasNext()){
			String section_name = section_it.next();
			Iterator<String> option_it = ini_data.get(section_name).keySet().iterator();
			HashMap<String, String> verified_section_data = new HashMap<String, String>();
			while(option_it.hasNext()){
				String option_key = option_it.next();
				String option_value = ini_data.get(section_name).get(option_key);
				switch (option_key.toLowerCase()) {
				case "interface_mode":
					if (!data_check.str_choice_check(option_value, new String [] {"gui", "cmd", "int"} )){
						option_value = public_data.DEF_INTERFACE_MODE;
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid interface_mode setting:" + section_name + ">" + option_key + ", default value will be used.");
					}
					break;				
				case "max_insts"://software external max instances should match thread pool size
					if (!data_check.num_scope_check(option_value, 0, public_data.PERF_POOL_MAXIMUM_SIZE)){
						option_value = public_data.DEF_SW_MAX_INSTANCES;
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid max_insts setting:" + section_name + ">" + option_key + ", default value will be used.");
					}
					break;
				case "scan_dir":
					if (!data_check.str_paths_check(option_value)){
						option_value = "";
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid scan_dir setting:" + section_name + ">" + option_key + ", Ignore it");
					}
					break;
				case "private":
					if (!data_check.str_choice_check(option_value, new String [] {"0", "1"} )){
						option_value = public_data.DEF_MACHINE_PRIVATE;
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid private setting:" + section_name + ">" + option_key + ", default value will be used.");
					}
					break;
				case "unattended":
					if (!data_check.str_choice_check(option_value, new String [] {"0", "1"} )){
						option_value = public_data.DEF_UNATTENDED_MODE;
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid unattended setting:" + section_name + ">" + option_key + ", default value will be used.");
					}
					break;
				case "auto_restart":
					if (!data_check.str_choice_check(option_value, new String [] {"0", "1"} )){
						option_value = public_data.DEF_AUTO_RESTART;
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid auto_restart setting:" + section_name + ">" + option_key + ", default value will be used.");
					}
					break;
				case "case_mode":
					if (!data_check.str_choice_check(option_value, new String [] {"copy_case", "hold_case"} )){
						option_value = public_data.DEF_CLIENT_CASE_MODE;
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid case_mode setting:" + section_name + ">" + option_key + ", default value will be used.");
					}
					break;
				case "dev_mails":
					if (!data_check.str_regexp_check(option_value, "(\\w)+(.\\w+)*@(\\w)+((.\\w+)+)")){
						option_value = public_data.BASE_DEVELOPER_MAIL;
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid dev_mails setting:" + section_name + ">" + option_key + ", default value will be used.");
					}
					break;
				case "opr_mails":
					if (!data_check.str_regexp_check(option_value, "(\\w)+(.\\w+)*@(\\w)+((.\\w+)+)")){
						option_value = public_data.BASE_OPERATOR_MAIL;
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid opr_mails setting:" + section_name + ">" + option_key + ", default value will be used.");
					}
					break;					
				case "ignore_request":
					if (!data_check.str_choice_check(option_value, new String [] {"", "all", "software", "system", "machine"} )){
						option_value = public_data.DEF_CLIENT_IGNORE_REQUEST;
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid ignore_request setting:" + section_name + ">" + option_key + ", default value will be used.");
					} 
					break;
				case "link_mode":
					if (!data_check.str_choice_check(option_value, new String [] {"local", "remote", "both"} )){
						option_value = public_data.DEF_CLIENT_LINK_MODE;
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid link_mode setting:" + section_name + ">" + option_key + ", default value will be used.");
					}
					break;
				case "pool_size":
					if (!data_check.num_scope_check(option_value, 0, public_data.PERF_POOL_MAXIMUM_SIZE)){
						option_value = String.valueOf(public_data.PERF_POOL_MAXIMUM_SIZE);
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid pool_size setting:" + section_name + ">" + option_key + ", default value will be used.");
					}
					break;				
				case "max_threads":
					if (!data_check.num_scope_check(option_value, 0, public_data.PERF_POOL_MAXIMUM_SIZE)){
						option_value = String.valueOf(public_data.PERF_POOL_CURRENT_SIZE);
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid max_threads setting:" + section_name + ">" + option_key + ", default value will be used.");
					}
					break;
				case "keep_path":
					if (!data_check.str_choice_check(option_value, new String [] {"false", "true"} )){
						option_value = public_data.DEF_COPY_KEEP_PATH;
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid keep_path setting:" + section_name + ">" + option_key + ", default value will be used.");
					}
					break;
				case "lazy_copy":
					if (!data_check.str_choice_check(option_value, new String [] {"false", "true"} )){
						option_value = public_data.DEF_COPY_LAZY_COPY;
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid lazy_copy setting:" + section_name + ">" + option_key + ", default value will be used.");
					}
					break;					
				case "result_keep":
					if (!data_check.str_choice_check(option_value, new String [] {"auto", "zipped", "unzipped"} )){
						option_value = public_data.TASK_DEF_RESULT_KEEP;
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid result_keep setting:" + section_name + ">" + option_key + ", default value will be used.");
					}
					break;
				case "save_space":
					if (option_value.equals("")){
						;
					} else if (data_check.str_regexp_check(option_value,public_data.DEF_LSH_SAVE_SPACE_PATTERN)) {
						;
					} else if (!data_check.str_path_check(option_value)){
						option_value = public_data.DEF_SAVE_SPACE;
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid save_space setting:" + section_name + ">" + option_key + ":" + option_value + ", default value will be used.");
					}
					break;
				case "work_space":
					if (!data_check.str_path_check(option_value)){
						option_value = public_data.DEF_WORK_SPACE;
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid work_space setting:" + section_name + ">" + option_key + ", default value will be used.");
					}
					break;
				case "show_welcome":
					if (!data_check.str_choice_check(option_value, new String [] {"0", "1"} )){
						option_value = public_data.DEF_SHOW_WELCOME;
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid show_welcome setting:" + section_name + ">" + option_key + ", default value will be used.");
					}
					break;
				case "space_reserve":
					if (!data_check.num_scope_check(option_value, 1, Integer.MAX_VALUE)){
						option_value = public_data.RUN_LIMITATION_SPACE;
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid space_reserve setting:" + section_name + ">" + option_key + ", default value will be used.");
					}
					break;
				case "stable_version":
					if (!data_check.str_choice_check(option_value, new String [] {"0", "1"} )){
						option_value = public_data.DEF_STABLE_VERSION;
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid stable_version setting:" + section_name + ">" + option_key + ", default value will be used.");
					}
					break;
				case "task_mode":
					if (!data_check.str_choice_check(option_value, new String [] {"serial", "parallel", "auto"} )){
						option_value = public_data.DEF_TASK_ASSIGN_MODE;
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid task_mode setting:" + section_name + ">" + option_key + ", default value will be used.");
					}
					break;
				case "thread_mode":
					if (!data_check.str_choice_check(option_value, new String [] {"manual", "auto"} )){
						option_value = public_data.DEF_MAX_THREAD_MODE;
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid thread_mode setting:" + section_name + ">" + option_key + ", default value will be used.");
					}
					break;
				case "debug":
					if (!data_check.str_choice_check(option_value, new String [] {"0", "1"} )){
						option_value = public_data.DEF_CLIENT_DEBUG_MODE;
						CONFIG_SYNC_LOGGER.warn("Config file:Invalid debug setting:" + section_name + ">" + option_key + ", default value will be used.");
					}
					break;					
				default:
					break;
				}
				verified_section_data.put(option_key, option_value);
			}
			verified_data.put(section_name, verified_section_data);
		}
		return verified_data;
	}
	
	private void update_static_data(HashMap<String, HashMap<String, String>> ini_data) {
		//different section in ini file means different software
		Iterator<String> section_it = ini_data.keySet().iterator();
		while (section_it.hasNext()) {
			String section = section_it.next();
			HashMap<String, String> section_data = new HashMap<String, String>();
			section_data.putAll(ini_data.get(section));
			HashMap<String, String> update_data = new HashMap<String, String>();
			if (section.contains("tmp_")) {
				// for section "tmp_preference" , "tmp_machine" and something
				// start with "tmp_"
				config_hash.put(section, section_data);
			} else {
				// consider as software section
				Iterator<String> option_it = section_data.keySet().iterator();
				while (option_it.hasNext()) {
					String option = option_it.next();
					String value = section_data.get(option);
					//bypass scan_dir, scan_cmd and max_insts
					if (option.contains("scan_") || option.equalsIgnoreCase("max_insts")) {
						continue;
					} else {
						File sw_path = new File(value);
						if (sw_path.exists() && sw_path.isDirectory()) {
							update_data.put(option, value);
						} else {
							CONFIG_SYNC_LOGGER.warn(section + "." + option + ":" + value + ", not exist. skipped");
						}
					}
				}
				if (section_data.containsKey("scan_dir") && !section_data.get("scan_dir").equals("")) {
					if (data_check.str_paths_check(section_data.get("scan_dir"))) {
						update_data.put("scan_dir", section_data.get("scan_dir"));
					} else {
						CONFIG_SYNC_LOGGER.warn(section + ".scan_dir, not exists. skipped");
					}
				}
				if (section_data.containsKey("scan_cmd") && !section_data.get("scan_cmd").equals("")) {
					update_data.put("scan_cmd", section_data.get("scan_cmd"));
				}				
				if (section_data.containsKey("max_insts") && !section_data.get("max_insts").equals("")) {
					update_data.put("max_insts", section_data.get("max_insts"));
				} else {
					update_data.put("max_insts", public_data.DEF_SW_MAX_INSTANCES);
				}
				config_hash.put(section, update_data);
			}
		}
	}

	private Boolean dump_client_data(
			ini_parser ini_runner,
			HashMap<String, HashMap<String, String>> ini_data
			) {
		Boolean dump_status = Boolean.valueOf(true);
		HashMap<String, HashMap<String, String>> write_data = new HashMap<String, HashMap<String, String>>();
		write_data.putAll(deep_clone.clone(client_info.get_client_data()));
		CONFIG_SYNC_LOGGER.info("Dumping ini data:" + client_info.get_client_data().toString());
		if (!write_data.containsKey("preference")) {
			dump_status = false;
			return dump_status;
		}
		if (!write_data.containsKey("Machine")) {
			dump_status = false;
			return dump_status;
		}
		if (!write_data.containsKey("System")) {
			dump_status = false;
			return dump_status;
		}
		String interface_mode = write_data.get("preference").get("interface_mode");
		HashMap<String, String> tmp_preference_data = new HashMap<String, String>();
		HashMap<String, String> cfg_preference_data = new HashMap<String, String>();
		HashMap<String, String> tmp_machine_data = new HashMap<String, String>();
		HashMap<String, String> cfg_machine_data = new HashMap<String, String>();
		HashMap<String, String> tmp_tools_data = new HashMap<String, String>();
		HashMap<String, String> cfg_tools_data = new HashMap<String, String>();
		//tmp_preference update
		tmp_preference_data.put("interface_mode", write_data.get("preference").get("interface_mode"));
		tmp_preference_data.put("link_mode", write_data.get("preference").get("link_mode"));
		tmp_preference_data.put("ignore_request", write_data.get("preference").get("ignore_request"));
		tmp_preference_data.put("thread_mode", write_data.get("preference").get("thread_mode"));
		tmp_preference_data.put("task_mode", write_data.get("preference").get("task_mode"));
		tmp_preference_data.put("case_mode", write_data.get("preference").get("case_mode"));
		tmp_preference_data.put("result_keep", write_data.get("preference").get("result_keep"));
		tmp_preference_data.put("keep_path", write_data.get("preference").get("keep_path"));
		tmp_preference_data.put("lazy_copy", write_data.get("preference").get("lazy_copy"));
		tmp_preference_data.put("pool_size", write_data.get("preference").get("pool_size"));
		tmp_preference_data.put("max_threads", write_data.get("preference").get("max_threads"));
		tmp_preference_data.put("show_welcome", write_data.get("preference").get("show_welcome"));
		tmp_preference_data.put("auto_restart", write_data.get("preference").get("auto_restart"));
		tmp_preference_data.put("stable_version", write_data.get("preference").get("stable_version"));
		tmp_preference_data.put("dev_mails", write_data.get("preference").get("dev_mails"));
		tmp_preference_data.put("opr_mails", write_data.get("preference").get("opr_mails"));
		tmp_preference_data.put("space_reserve", write_data.get("preference").get("space_reserve"));
		tmp_preference_data.put("work_space", write_data.get("preference").get("work_space"));
		tmp_preference_data.put("save_space", write_data.get("preference").get("save_space"));
		tmp_preference_data.put("debug_mode", write_data.get("preference").get("debug_mode"));
		tmp_preference_data.put("greed_mode", write_data.get("preference").get("greed_mode"));
		if (ini_data.containsKey("tmp_preference")) {
			cfg_preference_data.putAll(ini_data.get("tmp_preference"));
		}
		cfg_preference_data.put("work_space", write_data.get("preference").get("work_space"));
		cfg_preference_data.put("save_space", write_data.get("preference").get("save_space"));
		cfg_preference_data.put("interface_mode", write_data.get("preference").get("interface_mode"));
		//tmp_machine update
		tmp_machine_data.put("terminal", write_data.get("Machine").get("terminal"));
		tmp_machine_data.put("group", write_data.get("Machine").get("group"));
		tmp_machine_data.put("private", write_data.get("Machine").get("private"));
		tmp_machine_data.put("unattended", write_data.get("Machine").get("unattended"));
		if (ini_data.containsKey("tmp_machine")) {
			cfg_machine_data.putAll(ini_data.get("tmp_machine"));
		}
		//tmp_tools update
		tmp_tools_data.put("python", write_data.get("tools").get("python"));
		tmp_tools_data.put("perl", write_data.get("tools").get("perl"));
		tmp_tools_data.put("ruby", write_data.get("tools").get("ruby"));
		tmp_tools_data.put("svn", write_data.get("tools").get("svn"));
		tmp_tools_data.put("git", write_data.get("tools").get("git"));
		if (ini_data.containsKey("tmp_tools")) {
			cfg_tools_data.putAll(ini_data.get("tmp_tools"));
		}
		//confirm the data for different mode
		if (interface_mode.equalsIgnoreCase("gui")){
			write_data.put("tmp_preference", tmp_preference_data);
			write_data.put("tmp_machine", tmp_machine_data);
			write_data.put("tmp_tools", tmp_tools_data);
		} else {
			write_data.put("tmp_preference", cfg_preference_data);
			write_data.put("tmp_machine", cfg_machine_data);
			write_data.put("tmp_tools", cfg_tools_data);
		}
		//remove others
		write_data.remove("preference");
		write_data.remove("Machine");
		write_data.remove("System");
		write_data.remove("tools");
		write_data.remove("CoreScript");
		CONFIG_SYNC_LOGGER.info(write_data.toString());
		try {
			ini_runner.write_ini_data(write_data);
		} catch (ConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			CONFIG_SYNC_LOGGER.warn("Dump config data failed.");
			dump_status = false;
		}
		return dump_status;
	}

	private String get_read_config_file(){
		String conf_path = new String(public_data.CONF_DEFAULT_INI);
		String terminal = machine_sync.get_host_name();
		String pri0_conf_path = user_home_dir + "/client_conf/" + terminal + ".ini";
		String pri1_conf_path = public_data.CONF_ROOT_PATH + "/" + user_name + "_" + terminal + ".ini";
		File pri0_fobj = new File(pri0_conf_path);
		File pri1_fobj = new File(pri1_conf_path);
		if(pri1_fobj.exists() && pri1_fobj.canRead() && pri1_fobj.length() > 0){
			conf_path = pri1_conf_path;
		}		
		if(pri0_fobj.exists() && pri0_fobj.canRead() && pri0_fobj.length() > 0){
			conf_path = pri0_conf_path;
		}
		CONFIG_SYNC_LOGGER.warn("TMP Client reading config:" + conf_path);
		return conf_path;
	}
	
	private String get_write_config_file(){
		String terminal = machine_sync.get_host_name();
		String def_conf_path = new String(public_data.CONF_DEFAULT_INI);
		String pri0_conf_path = user_home_dir + "/client_conf/" + terminal + ".ini";
		String pri1_conf_path = public_data.CONF_ROOT_PATH + "/" + user_name + "_" + terminal + ".ini";
		String final_conf_path = new String(public_data.CONF_DEFAULT_INI);
		File def_fobj = new File(def_conf_path);
		File pri0_fobj = new File(pri0_conf_path);
		File pri1_fobj = new File(pri1_conf_path);
		if (!pri0_fobj.exists()){
			try {
				FileUtils.copyFile(def_fobj, pri0_fobj);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				CONFIG_SYNC_LOGGER.warn("Create default pri0 ini file failed");
			}
		}
		if (!pri1_fobj.exists()){
			try {
				FileUtils.copyFile(def_fobj, pri1_fobj);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				CONFIG_SYNC_LOGGER.warn("Create default pri1 ini file failed");
			}
		}		
		if(pri0_fobj.exists() && pri0_fobj.canWrite()){
			final_conf_path = pri0_conf_path;
		} else if (pri1_fobj.exists() && pri1_fobj.canWrite()){
			final_conf_path = pri1_conf_path;
		} else {
			final_conf_path = def_conf_path;
		}
		CONFIG_SYNC_LOGGER.warn("TMP Client dumping config:" + final_conf_path);
        return final_conf_path;
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
		conf_thread = Thread.currentThread();
		// ============== All static job start from here ==============
		// initial 1 : get overall configuration data
		ini_parser ini_runner = new ini_parser(get_read_config_file());
		HashMap<String, HashMap<String, String>> ini_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, HashMap<String, String>> verified_ini_data = new HashMap<String, HashMap<String, String>>();
		try {
			ini_data.putAll(ini_runner.read_ini_data());
		} catch (ConfigurationException e1) {
			// TODO Auto-generated catch block
			// e1.printStackTrace();
			CONFIG_SYNC_LOGGER.warn("config sync get initial config data failed");
			switch_info.set_client_stop_request(exit_enum.DATA);
		}
		// initial 2 : update initial(static) data
		verified_ini_data.putAll(import_data_verification(ini_data));
		update_static_data(verified_ini_data);
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
				CONFIG_SYNC_LOGGER.debug("config sync Thread running...");
				switch_info.update_threads_active_map(thread_enum.config_runner, time_info.get_date_time());
			}
			// ============== All dynamic job start from here ==============
			// task 1 : dump configuration updating
			Boolean dump_request = switch_info.impl_dump_config_request();
			if (dump_request) {
				ini_parser ini_dump = new ini_parser(get_write_config_file());
				dump_client_data(ini_dump, verified_ini_data);
			}
			try {
				Thread.sleep(base_interval * 2 * 1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public void soft_stop() {
		stop_request = true;
	}

	public void hard_stop() {
		stop_request = true;
		if (conf_thread != null) {
			conf_thread.interrupt();
		}
	}

	public void wait_request() {
		wait_request = true;
	}

	public void wake_request() {
		wait_request = false;
		synchronized (this) {
			this.notify();
		}
	}

	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		switch_data switch_info = new switch_data();
		client_data client_info = new client_data();
		config_sync ini_runner = new config_sync(switch_info, client_info);
		ini_runner.start();
	}
}