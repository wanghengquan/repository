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
	// protected property
	// private property
	private static final Logger DATA_SERVER_LOGGER = LogManager.getLogger(data_server.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread client_thread;
	private client_data client_info;
	private switch_data switch_info;
	private int interval = public_data.PERF_THREAD_RUN_INTERVAL;
	// public function
	// protected function
	// private function

	public data_server(client_data client_info, switch_data switch_info) {
		this.client_info = client_info;
		this.switch_info = switch_info;
	}

	private void initial_merge_client_data(HashMap<String, String> cmd_hash) {
		HashMap<String, HashMap<String, String>> client_data = new HashMap<String, HashMap<String, String>>();
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
			client_data.put(option, option_data);
		}
		// 2. merge System data
		client_data.put("System", machine_hash.get("System"));
		// 3. merge Machine data config data > scan data > default data in
		// public_data
		HashMap<String, String> machine_data = new HashMap<String, String>();
		machine_data.put("max_procs", public_data.DEF_MAX_PROCS);
		machine_data.put("private", public_data.DEF_MACHINE_PRIVATE);
		machine_data.put("group", public_data.DEF_GROUP_NAME);
		machine_data.putAll(machine_hash.get("Machine")); // Scan data
		machine_data.putAll(config_hash.get("tmp_machine")); // Config data
		client_data.put("Machine", machine_data);
		// 4. merge base data (for software use) command data > config data >
		// default data in public_data
		HashMap<String, String> base_data = new HashMap<String, String>();
		base_data.put("save_path", public_data.DEF_SAVE_PATH);
		base_data.put("work_path", public_data.DEF_WORK_PATH);
		base_data.putAll(config_hash.get("tmp_base"));
		base_data.putAll(cmd_hash);
		client_data.put("base", base_data);
		client_info.set_client_data(client_data);
		DATA_SERVER_LOGGER.warn(client_data.toString());
	}

	private void update_max_sw_insts_limitation() {
		HashMap<String, Integer> max_soft_insts = new HashMap<String, Integer>();
		ConcurrentHashMap<String, HashMap<String, String>> config_hash = config_sync.config_hash;
		Set<String> key_set = config_hash.keySet();
		Iterator<String> key_it = key_set.iterator();
		while(key_it.hasNext()){
			String key = key_it.next();
			if (key.equalsIgnoreCase("tmp_")){
				continue;
			}
			if (!config_hash.get(key).containsKey("max_insts")){
				continue;
			}
			Integer insts_value = Integer.valueOf(config_hash.get(key).get("max_insts"));
			max_soft_insts.put(key, insts_value);
		}
		client_info.set_max_soft_insts(max_soft_insts);
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
		// ============== All static job start from here ==============
		// initial 1 : start client data worker: 1) config_sync 2) machine_sync
		config_sync config_runner = new config_sync(switch_info, client_info);
		machine_sync machine_runner = new machine_sync();
		config_runner.start();
		machine_runner.start();
		// initial 2 : get command hash data
		HashMap<String, String> cmd_hash = cmd_parser.cmd_hash;
		// initial 3 : generate initial client data
		initial_merge_client_data(cmd_hash);
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
				DATA_SERVER_LOGGER.warn("client_data Thread running...");
			}
			// ============== All dynamic job start from here ==============
			//task 1: update client data hash
			//merge_client_data(cmd_hash);
			//task 2: update max_sw_insts limitation
			update_max_sw_insts_limitation();
			//task 3: send client info to Remote server
			send_client_info();
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
		switch_data switch_info = new switch_data();
		config_sync config_runner = new config_sync(switch_info);
		machine_sync machine_runner = new machine_sync();
		client_data share_client_data = new client_data();
		data_server client_available = new data_server(share_client_data);
		config_runner.start();
		machine_runner.start();
		client_available.start();
	}
}