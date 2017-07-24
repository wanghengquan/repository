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
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.commons.configuration2.ex.ConfigurationException;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import info_parser.ini_parser;
import utility_funcs.deep_clone;
import utility_funcs.file_action;
import utility_funcs.system_cmd;
import data_center.client_data;
import data_center.exit_enum;
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
 * 		tmp_base:	thread_mode = auto, manual
 *tmp_preference:	task_mode = auto, parallel, serial
 * 					max_threads = 5
 * 					work_path=	xxx
 * 					save_path=	xxx
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
	private String line_separator = System.getProperty("line.separator");
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

	private HashMap<String, String> get_scan_dirs(String scan_path) {
		HashMap<String, String> scan_dirs = new HashMap<String, String>();
		File scan_handler = new File(scan_path);
		if(!scan_handler.exists()){
			CONFIG_SYNC_LOGGER.warn("Scan path not exist:" + scan_path);
			return scan_dirs;
		}
		if(!scan_handler.isDirectory()){
			CONFIG_SYNC_LOGGER.warn("Scan path not a Directory:" + scan_path);
			return scan_dirs;
		}	
		File[] all_handlers = scan_handler.listFiles();
		for (File sub_handler : all_handlers) {
			String build_name = sub_handler.getName();
			if (!sub_handler.isDirectory()) {
				continue;
			}
			File success_file = new File(sub_handler.getAbsolutePath() + "/success.ini");
			if (!success_file.exists() || !success_file.canRead()) {
				continue;
			}
			ini_parser build_parser = new ini_parser(success_file.getAbsolutePath().replaceAll("\\\\", "/"));
			HashMap<String, HashMap<String, String>> build_data = new HashMap<String, HashMap<String, String>>();
			try {
				build_data = build_parser.read_ini_data();
			} catch (ConfigurationException e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
				CONFIG_SYNC_LOGGER.warn("Wrong format for:" + success_file.getAbsolutePath() + ", skipped.");
				continue;
			} catch (Exception e) {
				CONFIG_SYNC_LOGGER.warn("Wrong format for:" + success_file.getAbsolutePath() + ", skipped.");
				continue;				
			}
			if (!build_data.containsKey("root")) {
				continue;
			}
			if (!build_data.get("root").containsKey("path")) {
				continue;
			}
			String path = build_data.get("root").get("path");
			CONFIG_SYNC_LOGGER.debug("Catch SW path:" + path);
			scan_dirs.put(build_name, path);
		}
		return scan_dirs;
	}

	private HashMap<String, String> get_extra_scan_cmd_dirs(String scan_cmd) {
		HashMap<String, String> extra_dirs = new HashMap<String, String>();
		ArrayList<String> cmd_output = new ArrayList<String>();
		scan_cmd = scan_cmd.replaceAll("\\$work_path", config_hash.get("tmp_preference").get("work_path"));
		scan_cmd = scan_cmd.replaceAll("\\$tool_path", public_data.TOOLS_ROOT);
		try {
			cmd_output.addAll(system_cmd.run(scan_cmd));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			CONFIG_SYNC_LOGGER.warn("Run scan command failed");
			return extra_dirs;
		}
		int build_counter = 0;
		for (String line : cmd_output){
			if (!line.startsWith("build:")){
				continue;
			}
			String build = line.split(":", 2)[1];
			String build_name = build.split("=")[0].trim();
			String build_path = build.split("=")[1].trim();
			File path_dobj = new File(build_path);
			if (!path_dobj.exists()){
				continue;
			}
			if (build_counter > 9) {
				break;//only top 10 build will be take
			}
			extra_dirs.put("ex_" + build_name, build_path);
			build_counter++;
		}
		return extra_dirs;
	}
	
	private Boolean get_build_diff(String section, HashMap<String, String> scan_data) {
		if (scan_data.isEmpty()) {
			return false;
		}
		HashMap<String, String> recording_data = new HashMap<String, String>();
		recording_data.putAll(client_info.get_client_data().get(section));
		Iterator<String> scan_options_it = scan_data.keySet().iterator();
		while (scan_options_it.hasNext()) {
			String scan_option = scan_options_it.next();
			if (!recording_data.containsKey(scan_option)) {
				return true;
			}
		}
		return false;
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
					File scan_dir = new File(section_data.get("scan_dir"));
					if (scan_dir.exists() && scan_dir.isDirectory()) {
						update_data.put("scan_dir", section_data.get("scan_dir"));
					} else {
						CONFIG_SYNC_LOGGER.warn(section + ".scan_dir, not exist. skipped");
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

	/*
	 * scan update
	 */
	private Boolean update_dynamic_data() {
		//software scan_dir and scan_cmd update
		int client_updated = 0;
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
			Iterator<String> option_it = section_data.keySet().iterator();
			while (option_it.hasNext()) {
				String option = option_it.next();
				String value = section_data.get(option);
				if (option.equals("scan_dir")) {
					HashMap<String, String> scan_data = new HashMap<String, String>();
					scan_data.putAll(get_scan_dirs(value));
					Boolean new_update = get_build_diff(section, scan_data);
					if (new_update) {
                        client_info.append_software_build(section, scan_data);
                        client_updated++; // internal config file save
					}
				} else if (option.equals("scan_cmd")){
					HashMap<String, String> extra_data = new HashMap<String, String>();
					extra_data.putAll(get_extra_scan_cmd_dirs(value));
					client_info.update_software_scan_cmd_build(section, extra_data);
				} else if (option.equals("max_insts")) {
					continue;
				} else {
					File sw_path = new File(value);
					if (sw_path.exists()) {
						continue;
					} else {
						client_info.delete_software_build(section, option);
						client_updated++;
						CONFIG_SYNC_LOGGER.warn(section + "." + option + ":" + value + ", not exist. skipped");
					}
				}
			}	
		}
		if (client_updated > 0) {
			return true;
		} else {
			return false;
		}
	}

	private Boolean dump_client_data(ini_parser ini_runner) {
		Boolean dump_status = new Boolean(true);
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
		HashMap<String, String> tmp_preference_data = new HashMap<String, String>();
		HashMap<String, String> tmp_machine_data = new HashMap<String, String>();
		tmp_preference_data.put("link_mode", write_data.get("preference").get("link_mode"));
		tmp_preference_data.put("thread_mode", write_data.get("preference").get("thread_mode"));
		tmp_preference_data.put("task_mode", write_data.get("preference").get("task_mode"));
		tmp_preference_data.put("max_threads", write_data.get("preference").get("max_threads"));
		tmp_preference_data.put("show_welcome", write_data.get("preference").get("show_welcome"));
		tmp_preference_data.put("work_path", write_data.get("preference").get("work_path"));
		tmp_preference_data.put("save_path", write_data.get("preference").get("save_path"));
		tmp_machine_data.put("terminal", write_data.get("Machine").get("terminal"));
		tmp_machine_data.put("group", write_data.get("Machine").get("group"));
		tmp_machine_data.put("private", write_data.get("Machine").get("private"));
		tmp_machine_data.put("unattended", write_data.get("Machine").get("unattended"));
		write_data.remove("preference");
		write_data.remove("Machine");
		write_data.remove("System");
		write_data.put("tmp_preference", tmp_preference_data);
		write_data.put("tmp_machine", tmp_machine_data);
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

	public void run() {
		try {
			monitor_run();
		} catch (Exception run_exception) {
			run_exception.printStackTrace();
			String dump_path = client_info.get_client_data().get("preference").get("work_path") 
					+ "/" + public_data.WORKSPACE_LOG_DIR + "/core_dump/dump.log";
			file_action.append_file(dump_path, run_exception.toString() + line_separator);
			for(Object item: run_exception.getStackTrace()){
				file_action.append_file(dump_path, "    at " + item.toString() + line_separator);
			}			
			switch_info.set_client_stop_request(exit_enum.DUMP);
		}
	}

	private void monitor_run() {
		conf_thread = Thread.currentThread();
		// ============== All static job start from here ==============
		// initial 1 : get overall configuration data
		ini_parser ini_runner = new ini_parser(public_data.CONF_DEFAULT_INI);
		HashMap<String, HashMap<String, String>> ini_data = new HashMap<String, HashMap<String, String>>();
		try {
			ini_data.putAll(ini_runner.read_ini_data());
		} catch (ConfigurationException e1) {
			// TODO Auto-generated catch block
			// e1.printStackTrace();
			CONFIG_SYNC_LOGGER.warn("config sync get initial config data failed");
			switch_info.set_client_stop_request(exit_enum.DATA);
		}
		// initial 2 : update initial(static) data
		update_static_data(ini_data);
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
				CONFIG_SYNC_LOGGER.debug(config_hash.toString());
			}
			// ============== All dynamic job start from here ==============
			// task 1 : dump configuration updating
			Boolean dump_request = switch_info.impl_dump_config_request();
			if (dump_request) {
				dump_client_data(ini_runner);
			}
			// task 2 : update data in loop
			Boolean config_updated = update_dynamic_data();
			if (config_updated) {
				switch_info.set_client_updated();
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