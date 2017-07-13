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

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import env_monitor.config_sync;
import env_monitor.machine_sync;
import flow_control.pool_data;
import info_parser.cmd_parser;
import utility_funcs.file_action;

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
 * 
 * 		Machine	:	terminal=	xxx
 * 					ip		=	xxx
 * 					group	=	xxx
 * 					private	=	0/1
 * 					unattended = 0/1
 * 
 * 	 preference :	thread_mode = xx
 * 					task_mode = xx
 * 					link_mode = both (from command line)
 * 					max_threads = xx
 *                  show_welcome = xx
 * 					work_path = xx
 * 					save_path = xx
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
	private pool_data pool_info;
	private String line_separator = System.getProperty("line.separator");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;
	// sub threads need to be launched
	config_sync config_runner;
	machine_sync machine_runner;
	// public function
	// protected function
	// private function

	public data_server(HashMap<String, String> cmd_info, switch_data switch_info, client_data client_info,
			pool_data pool_info) {
		this.cmd_info = cmd_info;
		this.client_info = client_info;
		this.switch_info = switch_info;
		this.pool_info = pool_info;
		this.config_runner = new config_sync(switch_info, client_info);
		this.machine_runner = new machine_sync(switch_info);
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
		// configuration data > scan data > default data
		HashMap<String, String> machine_data = new HashMap<String, String>();
		machine_data.put("private", public_data.DEF_MACHINE_PRIVATE);
		machine_data.put("group", public_data.DEF_GROUP_NAME);
		machine_data.put("unattended", public_data.DEF_UNATTENDED_MODE);
		machine_data.putAll(machine_hash.get("Machine")); // Scan data
		machine_data.putAll(config_hash.get("tmp_machine")); // configuration
																// data
		client_data.put("Machine", machine_data);
		// 4. merge preference data (for software use):
		// command data > config data > data in public_data
		HashMap<String, String> preference_data = new HashMap<String, String>();
		preference_data.put("thread_mode", public_data.DEF_MAX_THREAD_MODE);
		preference_data.put("task_mode", public_data.DEF_TASK_ASSIGN_MODE);
		preference_data.put("link_mode", public_data.DEF_CLIENT_LINK_MODE);
		preference_data.put("max_threads", public_data.DEF_POOL_CURRENT_SIZE);
		preference_data.put("show_welcome", public_data.DEF_SHOW_WELCOME);
		preference_data.put("work_path", public_data.DEF_WORK_PATH);
		preference_data.put("save_path", public_data.DEF_SAVE_PATH);
		preference_data.putAll(config_hash.get("tmp_preference"));
		preference_data.putAll(cmd_hash);
		client_data.put("preference", preference_data);
		client_info.set_client_data(client_data);
		DATA_SERVER_LOGGER.debug(client_data.toString());
	}

	// this function may get slipped condition
	private void dynamic_merge_client_data() {
		HashMap<String, HashMap<String, String>> client_data = new HashMap<String, HashMap<String, String>>();
		client_data.putAll(client_info.get_client_data());
		HashMap<String, HashMap<String, String>> machine_hash = new HashMap<String, HashMap<String, String>>();
		HashMap<String, HashMap<String, String>> config_hash = new HashMap<String, HashMap<String, String>>();
		machine_hash.putAll(machine_sync.machine_hash);
		config_hash.putAll(config_sync.config_hash);
		// 1. merge Software data modified by auto scan
		Iterator<String> config_it = config_hash.keySet().iterator();
		while (config_it.hasNext()) {
			String option = config_it.next();
			HashMap<String, String> option_data = new HashMap<String, String>();
			option_data.putAll(config_hash.get(option));
			if (option.contains("tmp_")) {
				continue;
			}
			client_data.get(option).putAll(option_data);
		}
		// 2. merge System data
		client_data.put("System", machine_hash.get("System"));
		client_info.set_client_data(client_data);
		DATA_SERVER_LOGGER.debug(client_data.toString());
	}

	private void update_max_sw_insts_limitation() {
		HashMap<String, Integer> max_soft_insts = new HashMap<String, Integer>();
		HashMap<String, HashMap<String, String>> client_hash = new HashMap<String, HashMap<String, String>>();
		client_hash.putAll(client_info.get_client_data());
		Iterator<String> key_it = client_hash.keySet().iterator();
		while (key_it.hasNext()) {
			String key = key_it.next();
			if (key.equalsIgnoreCase("preference")) {
				continue;
			}
			if (key.equalsIgnoreCase("machine")) {
				continue;
			}
			if (!client_hash.get(key).containsKey("max_insts")) {
				continue;
			}
			Integer insts_value = Integer.valueOf(client_hash.get(key).get("max_insts"));
			max_soft_insts.put(key, insts_value);
		}
		client_info.set_max_soft_insts(max_soft_insts);
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
			switch_info.set_client_stop_request();;
		}
	}

	private void monitor_run() {
		current_thread = Thread.currentThread();
		// ============== All static job start from here ==============
		// initial 1 : start client data worker: 1) config_sync 2) machine_sync
		config_runner.start();
		machine_runner.start();
		while (true) {
			if (machine_sync.machine_hash.containsKey("System") && machine_sync.machine_hash.get("System").size() > 3) {
				break;
			}
		}
		// initial 2 : generate initial client data
		initial_merge_client_data(cmd_info);
		// initial 3 : update default current size into Pool Data
		String current_max_threads = client_info.get_client_data().get("preference").get("max_threads");
		pool_info.set_pool_current_size(Integer.parseInt(current_max_threads));
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
			}
			// ============== All dynamic job start from here ==============
			// task 1: update client data hash
			dynamic_merge_client_data();
			// task 2: update max_sw_insts limitation
			update_max_sw_insts_limitation();
			// HashMap<String, Integer> soft_ware =
			DATA_SERVER_LOGGER.debug(client_info.get_max_soft_insts());
			DATA_SERVER_LOGGER.debug(client_info.get_use_soft_insts());
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
		HashMap<String, String> cmd_info = cmd_run.cmdline_parser();
		switch_data switch_info = new switch_data();
		client_data client_info = new client_data();
		pool_data pool_info = new pool_data(10);
		data_server server_runner = new data_server(cmd_info, switch_info, client_info, pool_info);
		server_runner.start();
		try {
			Thread.sleep(10 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// server_runner.soft_stop();
	}
}