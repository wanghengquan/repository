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
import utility_funcs.deep_clone;
import utility_funcs.file_action;
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
 *tmp_preference:	thread_mode = auto, manual
 *					task_mode = auto, parallel, serial
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
	private String user_home_dir = System.getProperty("user.home");
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

	private String get_read_config_file(){
		String conf_path = new String(public_data.CONF_DEFAULT_INI);
		String terminal = machine_sync.get_host_name();
		String pri0_conf_path = user_home_dir + "/client_conf/" + terminal + ".ini";
		String pri1_conf_path = public_data.CONF_ROOT_PATH + "/" + user_name + "_" + terminal + ".ini";
		File pri0_fobj = new File(pri0_conf_path);
		File pri1_fobj = new File(pri1_conf_path);
		if(pri1_fobj.exists()){
			conf_path = pri1_conf_path;
		}		
		if(pri0_fobj.exists()){
			conf_path = pri0_conf_path;
		}
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
		try {
			FileUtils.copyFile(def_fobj, pri0_fobj);
			final_conf_path = pri0_conf_path;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			try {
				FileUtils.copyFile(def_fobj, pri1_fobj);
				final_conf_path = pri1_conf_path;
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				// e1.printStackTrace();
				final_conf_path = def_conf_path;
			}
		}
        return final_conf_path;
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
		ini_parser ini_runner = new ini_parser(get_read_config_file());
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
				ini_parser ini_dump = new ini_parser(get_write_config_file());
				dump_client_data(ini_dump);
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