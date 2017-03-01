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
import data_center.public_data;
import data_center.switch_data;

/*
 * This class used to get the basic information of the client.
 * return machine_hash:
 * 		radiant	:	dng_b1	=	xxx
 * 					ng1_0.954=	xxx
 * 					scan_dir=	xxx
 * 					max_insts=	xxx
 * 		....(other software)
 * 		tmp_machine:terminal=	xxx
 * 					group	=	xxx
 * 					max_procs=	xxx
 * 					private = 	0
 * 		tmp_base:	rmq_host=	xxx	
 * 					rmq_user=	xxx
 * 					rmq_pwd	=	xxx
 * 					work_path=	xxx
 * 					save_path=	xxx
 */
public class config_sync extends Thread {
	// public property
	public static ConcurrentHashMap<String, HashMap<String, String>> config_hash = new ConcurrentHashMap<String, HashMap<String, String>>();
	// protected property
	// private property
	private static final Logger CONFIG_LOGGER = LogManager.getLogger(config_sync.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread conf_thread;
	private switch_data switch_info;
	private int interval = public_data.PERF_THREAD_RUN_INTERVAL;
	// public function
	public config_sync(int interval) {
		this.interval = interval;
	}

	public config_sync(switch_data switch_info) {
		this.switch_info = switch_info;
	}	
	// protected function
	// private function
	private HashMap<String, String> get_scan_dirs(String scan_path){
		HashMap<String, String> scan_dirs = new HashMap<String, String>();
		File scan_handler = new File(scan_path);
		File [] all_handlers = scan_handler.listFiles();
		for(File sub_handler: all_handlers){
			String build_name = sub_handler.getName();
			if (!sub_handler.isDirectory()){
				continue;
			}
			File success_file = new File(sub_handler.getAbsolutePath() + "/success.ini");
			if (!success_file.exists() || !success_file.canRead()){
				continue;
			}
			ini_parser build_parser = new ini_parser(success_file.getAbsolutePath().replaceAll("\\\\", "/"));
			HashMap<String, HashMap<String, String>> build_data = new HashMap<String, HashMap<String, String>>();
			try {
				build_data = build_parser.read_ini_data();
			} catch (ConfigurationException e) {
				// TODO Auto-generated catch block
				//e.printStackTrace();
				CONFIG_LOGGER.warn("Wrong format for:" + success_file.getAbsolutePath() + ", skipped.");
				continue;
			}
			if (!build_data.containsKey("root")){
				continue;
			}
			if (!build_data.get("root").containsKey("path")){
				continue;
			}
			String path = build_data.get("root").get("path");
			CONFIG_LOGGER.debug("Catch SW path: path");
			scan_dirs.put(build_name,path);
		}
		return scan_dirs;
	}
	
	private Boolean get_build_diff(String section, HashMap<String, String> scan_data){
		if (scan_data.isEmpty()){
			return false;
		}
		HashMap<String, String> recording_data = config_hash.get(section);
		Set<String> scan_options = scan_data.keySet();
		Iterator<String> scan_options_it = scan_options.iterator();
		while(scan_options_it.hasNext()){
			String scan_option = scan_options_it.next();
			String scan_value = scan_data.get(scan_option);
			if (!recording_data.containsKey(scan_option)){
				return true;
			}
			if (!scan_value.equalsIgnoreCase(recording_data.get(scan_option))){
				return true;
			}
		}
		return false;
	}
	
	private void update_static_data(HashMap<String, HashMap<String, String>> ini_data) {
		Set<String> config_sections = ini_data.keySet();
		Iterator<String> section_it = config_sections.iterator();
		while (section_it.hasNext()) {
			String section = section_it.next();
			HashMap<String, String> section_data = ini_data.get(section);
			HashMap<String, String> update_data = new HashMap<String, String>();
			if (section.equalsIgnoreCase("tmp_base") || section.equalsIgnoreCase("tmp_machine")) {
				config_hash.put(section, section_data);
			} else {
				// consider as software section
				Set<String> options_set = section_data.keySet();
				Iterator<String> option_it = options_set.iterator();
				while(option_it.hasNext()){
					String option = option_it.next();
					String value = section_data.get(option);
					if (option.equalsIgnoreCase("scan_dir") || option.equalsIgnoreCase("max_insts")){
						continue;
					} else {
						File sw_path = new File(value);
						if (sw_path.exists() && sw_path.isDirectory()){
							update_data.put(option, value);
						} else {
							CONFIG_LOGGER.warn(section + "." + option + ":" + value + ", not exist. skipped");
						}
					}
				}
				if (section_data.containsKey("scan_dir") && !section_data.get("scan_dir").equals("")){
					File scan_dir = new File(section_data.get("scan_dir"));
					if (scan_dir.exists() && scan_dir.isDirectory()){
						update_data.put("scan_dir", section_data.get("scan_dir"));
					} else {
						CONFIG_LOGGER.warn(section + ".scan_dir, not exist. skipped");
					}
				}
				if (section_data.containsKey("max_insts") && !section_data.get("max_insts").equals("")){
					update_data.put("max_insts", section_data.get("max_insts"));
				} else {
					update_data.put("max_insts", public_data.DEF_SW_MAX_INSTANCES);
				}
				config_hash.put(section, update_data);
			}
		}
	}

	private Boolean update_dynamic_data() {
		int config_updated = 0;
		Set<String> config_sections = config_hash.keySet();
		Iterator<String> section_it = config_sections.iterator();
		while(section_it.hasNext()){
			String section = section_it.next();
			HashMap<String, String> section_data = config_hash.get(section);
			if (section.equalsIgnoreCase("tmp_base") || section.equalsIgnoreCase("tmp_machine")){
				continue;
			}
			HashMap<String, String> update_data = new HashMap<String, String>();
			Set<String> options_set = section_data.keySet();
			Iterator<String> option_it = options_set.iterator();
			while(option_it.hasNext()){
				String option = option_it.next();
				String value = section_data.get(option);
				if (option.equals("scan_dir")){
					update_data.put(option, value);
					HashMap<String, String> scan_data = get_scan_dirs(value);
					Boolean new_update  = get_build_diff(section, scan_data);
					if (new_update){
						update_data.putAll(scan_data);
						config_updated++; //internal config file save
						switch_info.set_config_update_announce(1);
					}
				} else if (option.equals("max_insts")){
					update_data.put(option, value);
				} else {
					File sw_path = new File(value);
					if (sw_path.exists()){
						update_data.put(option, value);
					} else {
						CONFIG_LOGGER.warn(section + "." + option + ":" + value + ", not exist. skipped");
					}
				}
			}
			config_hash.put(section, update_data);
		}
		if (config_updated > 0){
			return true;
		} else {
			return false;
		}
	}

	private void save_config_data(ini_parser ini_runner){
		HashMap<String, HashMap<String, String>> write_data = new HashMap<String, HashMap<String, String>>();
		write_data.putAll(config_hash);
		try {
			ini_runner.write_ini_data(write_data);
		} catch (ConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
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
		//step 0:get config data
		conf_thread = Thread.currentThread();
		ini_parser ini_runner = new ini_parser(public_data.CONF_DEFAULT_INI);
		HashMap<String, HashMap<String, String>> ini_data = new HashMap<String, HashMap<String, String>>();
		try {
			ini_data = ini_runner.read_ini_data();
		} catch (ConfigurationException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		//step 1:update initial(static) data
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
				CONFIG_LOGGER.warn("config sync Thread running...");
			}
			//step2:update data in loop
			Boolean config_updated = update_dynamic_data();
			if (config_updated){
				save_config_data(ini_runner);
			}
			//step3:save request acknowledge
			int save_request = switch_info.get_config_save_request();
			if (save_request > 0){
				save_config_data(ini_runner);
			}
			switch_info.set_config_save_request(0);
			try {
				Thread.sleep(interval * 1000);
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
		config_sync ini_runner = new config_sync(switch_info);
		ini_runner.start();
	}
}