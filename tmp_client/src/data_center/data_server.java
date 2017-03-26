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

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import env_monitor.config_sync;
import env_monitor.machine_sync;
import flow_control.pool_data;
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
 * 					max_threads=	int
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
	private pool_data pool_info;
	// private String line_seprator = System.getProperty("line.separator");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;
	// sub threads need to be launched
	config_sync config_runner;
	machine_sync machine_runner;
	// public function
	// protected function
	// private function

	public data_server(switch_data switch_info, client_data client_info, pool_data pool_info) {
		this.client_info = client_info;
		this.switch_info = switch_info;
		this.pool_info = pool_info;
		this.config_runner = new config_sync(switch_info, client_info);
		this.machine_runner = new machine_sync();
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
			if (option.equalsIgnoreCase("tmp_base") || option.equalsIgnoreCase("tmp_machine")) {
				continue;
			}
			client_data.put(option, option_data);
		}
		// 2. merge System data
		client_data.put("System", machine_hash.get("System"));
		// 3. merge Machine data configuration data > scan data > default data
		// in
		// public_data
		HashMap<String, String> machine_data = new HashMap<String, String>();
		machine_data.put("max_threads", public_data.DEF_POOL_CURRENT_SIZE);
		machine_data.put("private", public_data.DEF_MACHINE_PRIVATE);
		machine_data.put("group", public_data.DEF_GROUP_NAME);
		machine_data.putAll(machine_hash.get("Machine")); // Scan data
		machine_data.putAll(config_hash.get("tmp_machine")); // configuration data
		client_data.put("Machine", machine_data);
		// 4. merge base data (for software use) command data > config data >
		// default data in public_data
		HashMap<String, String> base_data = new HashMap<String, String>();
		// base_data.put("save_path", public_data.DEF_SAVE_PATH);
		base_data.put("work_path", public_data.DEF_WORK_PATH);
		base_data.putAll(config_hash.get("tmp_base"));
		base_data.putAll(cmd_hash);
		client_data.put("base", base_data);
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
		// 1. merge Software data modified in GUI
		Iterator<String> config_it = config_hash.keySet().iterator();
		while (config_it.hasNext()) {
			String option = config_it.next();
			HashMap<String, String> option_data = new HashMap<String, String>();
			option_data.putAll(config_hash.get(option));
			if (option.equalsIgnoreCase("tmp_base") || option.equalsIgnoreCase("tmp_machine")) {
				continue;
			}
			/*
			if (option_data.containsKey("scan_dir")) {
				option_data.remove("scan_dir");
			}
			if (option_data.containsKey("max_insts")) {
				option_data.remove("max_insts");
			}
			*/
			client_data.get(option).putAll(option_data);
		}
		// 2. merge System data
		client_data.put("System", machine_hash.get("System"));
		client_info.set_client_data(client_data);
		DATA_SERVER_LOGGER.debug(client_data.toString());
	}

	private void update_max_sw_insts_limitation() {
		HashMap<String, Integer> max_soft_insts = new HashMap<String, Integer>();
		HashMap<String, HashMap<String, String>> client_hash = new HashMap<String, HashMap<String, String>> ();
		client_hash.putAll(client_info.get_client_data());
		Set<String> key_set = client_hash.keySet();
		Iterator<String> key_it = key_set.iterator();
		while (key_it.hasNext()) {
			String key = key_it.next();
			if (key.equalsIgnoreCase("base")) {
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
			System.exit(1);
		}
	}

	private void monitor_run() {
		client_thread = Thread.currentThread();
		// ============== All static job start from here ==============
		// initial 1 : start client data worker: 1) config_sync 2) machine_sync
		config_runner.start();
		machine_runner.start();
		while (true) {
			if (machine_sync.machine_hash.containsKey("System") && machine_sync.machine_hash.get("System").size() > 3) {
				break;
			}
		}
		// initial 2 : get command hash data
		HashMap<String, String> cmd_hash = cmd_parser.cmd_hash;
		// initial 3 : generate initial client data
		initial_merge_client_data(cmd_hash);
		// initial 4 : update default current size into Pool Data
		String max_threads = client_info.get_client_data().get("Machine").get("max_threads");
		pool_info.set_pool_current_size(Integer.parseInt(max_threads));
		// initial 5 : Announce data server ready
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
				DATA_SERVER_LOGGER.debug("data_server Thread running...");
			}
			// ============== All dynamic job start from here ==============
			// task 1: update client data hash
			dynamic_merge_client_data();
			// task 2: update max_sw_insts limitation
			update_max_sw_insts_limitation();
			// HashMap<String, Integer> soft_ware =
			DATA_SERVER_LOGGER.warn(client_info.get_max_soft_insts());
			DATA_SERVER_LOGGER.warn(client_info.get_use_soft_insts());
			DATA_SERVER_LOGGER.warn(client_info.get_client_data());
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
		client_data client_info = new client_data();
		pool_data pool_info = new pool_data(10);
		data_server server_runner = new data_server(switch_info, client_info, pool_info);
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