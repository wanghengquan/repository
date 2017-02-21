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
import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import info_parser.ini_parser;
import data_center.public_data;

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
	private Thread info_thread;

	// public function
	public config_sync() {

	}

	// protected function
	// private function
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
				if (section_data.containsKey("scan_dir") && !section_data.get("scan_dir").equals("")){
					update_data.put("scan_dir", section_data.get("scan_dir"));
				}
				if (section_data.containsKey("max_insts") && !section_data.get("max_insts").equals("")){
					update_data.put("max_insts", section_data.get("max_insts"));
				} else {
					update_data.put("max_insts", public_data.SW_MAX_INSTANCES);
				}
				config_hash.put(section, update_data);
			}
		}
	}

	private void update_dynamic_data() {

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
		info_thread = Thread.currentThread();
		ini_parser ini_runner = new ini_parser(public_data.DEFAULT_INI);
		HashMap<String, HashMap<String, String>> read_data = ini_runner.read_ini_data();
		update_static_data(read_data);
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
				CONFIG_LOGGER.debug("Client info Thread running...");
			}
			update_dynamic_data();
			// System.out.println("Thread running...");
			try {
				Thread.sleep(5 * 1000);
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
		if (info_thread != null) {
			info_thread.interrupt();
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
		ini_parser ini_runner = new ini_parser(public_data.DEFAULT_INI);
		TreeMap<String, TreeMap<String, String>> read_data = ini_runner.read_ini_data();
		config_sync.config_hash.putAll(read_data);;

	}

}