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

import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import env_monitor.config_sync;
import env_monitor.machine_sync;
import info_parser.cmd_parser;

/*
 * This class used to get the basic information of the client.
 * return machine_hash:
 * 		diamond	:	build	=	xxxx
 * 					scan_dir=	xxxx
 * 					max_insts = int
 * 		radiant	:	build	=	xxxx
 * 					scan_dir=	xxxx
 * 					max_insts = int 
 * 		...
 * 		System	:	os		=	type_arch
 * 					os_type	=	windows/linux
 * 					os_arch	=	32b/64b
 * 					space	=	xx	G
 * 					cpu		=	xx	%
 * 					mem		=	xx	%
 * 		Machine	:	terminal=	xxx
 * 					ip		=	xxx
 * 					group	=	xxx
 * 					max_procs=	int
 * 					private	=	0/1
 * 		base	:	save_path = xx
 * 					work_path = xx
 * 					gui_cmd	  = gui/cmd
 * 					suite_file= xx
 * 					local_remore = remote
 * 					debug		= false
 */
public class data_server extends Thread {
	// public property
	public static ConcurrentHashMap<String, HashMap<String, String>> client_hash = new ConcurrentHashMap<String, HashMap<String, String>>();
	// protected property
	// private property
	private static final Logger DATA_LOGGER = LogManager.getLogger(data_server.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread client_thread;
	private int interval = public_data.PERF_THREAD_RUN_INTERVAL;
	// public function
	// protected function
	// private function

	private void merge_client_data(HashMap<String, String> cmd_hash) {
		ConcurrentHashMap<String, HashMap<String, String>> machine_hash = machine_sync.machine_hash;
		ConcurrentHashMap<String, HashMap<String, String>> config_hash = config_sync.config_hash;
		// 0. ready check
		if (machine_hash.size() < 2) {
			return;
		}
		if (config_hash.size() < 2) {
			return;
		}
		// 1. merge Software data
		Set<String> config_section = config_hash.keySet();
		Iterator<String> config_it = config_section.iterator();
		while (config_it.hasNext()) {
			String option = config_it.next();
			HashMap<String, String> option_data = config_hash.get(option);
			if (option.equalsIgnoreCase("tmp_base") || option.equalsIgnoreCase("tmp_machine")) {
				continue;
			}
			client_hash.put(option, option_data);
		}
		// 2. merge System data
		client_hash.put("System", machine_hash.get("System"));
		// 3. merge Machine data config data > scan data > default data in
		// public_data
		HashMap<String, String> machine_data = new HashMap<String, String>();
		machine_data.put("max_procs", public_data.DEF_MAX_PROCS);
		machine_data.put("private", public_data.DEF_MACHINE_PRIVATE);
		machine_data.put("group", public_data.DEF_GROUP_NAME);
		machine_data.putAll(machine_hash.get("Machine")); // Scan data
		machine_data.putAll(config_hash.get("tmp_machine")); // Config data
		client_hash.put("Machine", machine_data);
		// 4. merge base data (for software use) command data > config data >
		// default data in public_data
		HashMap<String, String> base_data = new HashMap<String, String>();
		base_data.put("save_path", public_data.DEF_SAVE_PATH);
		base_data.put("work_path", public_data.DEF_WORK_PATH);
		base_data.putAll(config_hash.get("tmp_base"));
		base_data.putAll(cmd_hash);
		client_hash.put("base", base_data);
		DATA_LOGGER.warn(client_hash.toString());
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
		client_thread = Thread.currentThread();
		HashMap<String, String> cmd_hash = cmd_parser.cmd_hash;
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
				DATA_LOGGER.warn("client_data Thread running...");
			}
			merge_client_data(cmd_hash);
			// System.out.println("Thread running...");
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
		if (client_thread != null) {
			client_thread.interrupt();
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
		cmd_parser cmd_run = new cmd_parser(args);
		cmd_run.cmdline_parser();
		exchange_data share_data = new exchange_data();
		config_sync config_runner = new config_sync(share_data);
		machine_sync machine_runner = new machine_sync();
		data_server client_available = new data_server();
		config_runner.start();
		machine_runner.start();
		client_available.start();
	}
}