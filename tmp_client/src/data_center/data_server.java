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

import connect_tube.rmq_tube;
import env_monitor.config_sync;
import env_monitor.machine_sync;
import flow_control.pool_data;
import info_parser.cmd_parser;
import info_parser.xml_parser;

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
	private pool_data pool_info;
	private int interval = public_data.PERF_THREAD_RUN_INTERVAL;
	// public function
	// protected function
	// private function

	public data_server(client_data client_info, switch_data switch_info, pool_data pool_info) {
		this.client_info = client_info;
		this.switch_info = switch_info;
		this.pool_info = pool_info;
	}

	private void initial_merge_client_data(HashMap<String, String> cmd_hash) {
		HashMap<String, HashMap<String, String>> client_data = new HashMap<String, HashMap<String, String>>();
		ConcurrentHashMap<String, HashMap<String, String>> machine_hash = machine_sync.machine_hash;
		ConcurrentHashMap<String, HashMap<String, String>> config_hash = config_sync.config_hash;
		// 0. ready check
		while (machine_hash.size() > 2) {
			break;
		}
		while (config_hash.size() > 2) {
			break;
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
		// 3. merge Machine data configuration data > scan data > default data in
		// public_data
		HashMap<String, String> machine_data = new HashMap<String, String>();
		machine_data.put("max_procs", public_data.DEF_MAX_PROCS);
		machine_data.put("private", public_data.DEF_MACHINE_PRIVATE);
		machine_data.put("group", public_data.DEF_GROUP_NAME);
		machine_data.putAll(machine_hash.get("Machine")); // Scan data
		machine_data.putAll(config_hash.get("tmp_machine")); // configuration data
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

	//this function may get slipped condition
	private void dynamic_merge_client_data() {
		HashMap<String, HashMap<String, String>> client_data = client_info.get_client_data();
		ConcurrentHashMap<String, HashMap<String, String>> machine_hash = machine_sync.machine_hash;
		ConcurrentHashMap<String, HashMap<String, String>> config_hash = config_sync.config_hash;
		// 1. merge Software data except "scan_dir" and "max_insts" incase user modified in GUI
		Set<String> config_section = config_hash.keySet();
		Iterator<String> config_it = config_section.iterator();
		while (config_it.hasNext()) {
			String option = config_it.next();
			HashMap<String, String> option_data = config_hash.get(option);
			if (option.equalsIgnoreCase("tmp_base") || option.equalsIgnoreCase("tmp_machine")) {
				continue;
			}
			if(option_data.containsKey("scan_dir")){
				option_data.remove("scan_dir");
			}
			if(option_data.containsKey("max_insts")){
				option_data.remove("max_insts");
			}			
			client_data.get(option).putAll(option_data);
		}
		// 2. merge System data
		client_data.put("System", machine_hash.get("System"));
		client_info.set_client_data(client_data);
		DATA_SERVER_LOGGER.warn(client_data.toString());
	}
	
	private void update_max_sw_insts_limitation() {
		HashMap<String, Integer> max_soft_insts = new HashMap<String, Integer>();
		HashMap<String, HashMap<String, String>> client_hash = client_info.get_client_data();
		Set<String> key_set = client_hash.keySet();
		Iterator<String> key_it = key_set.iterator();
		while(key_it.hasNext()){
			String key = key_it.next();
			if (key.equalsIgnoreCase("base")){
				continue;
			}
			if (key.equalsIgnoreCase("machine")){
				continue;
			}			
			if (!client_hash.get(key).containsKey("max_insts")){
				continue;
			}
			Integer insts_value = Integer.valueOf(client_hash.get(key).get("max_insts"));
			max_soft_insts.put(key, insts_value);
		}
		client_info.set_max_soft_insts(max_soft_insts);
	}

	private Boolean send_client_info(String mode){
		Boolean send_status = new Boolean(true);
		HashMap<String, HashMap<String, String>> client_hash = client_info.get_client_data();
		HashMap<String, String> simple_data = new HashMap<String, String>();
		HashMap<String, String> complex_data = new HashMap<String, String>();
		String host_name = client_hash.get("Machine").get("terminal");
		String admin_request = "0";
		if(switch_info.get_send_admin_request()){
			admin_request = "1";
		}
		String status = client_hash.get("Machine").get("status");
		int used_thread = pool_info.get_used_thread();
		String max_thread = switch_info.get_pool_max_procs();
		String processNum = String.valueOf(used_thread) + "/" + max_thread;
		simple_data.put("host_name", host_name);
		simple_data.put("admin_request", admin_request);
		simple_data.put("status", status);
		simple_data.put("processNum", processNum);
		//complex data send
		String host_ip = client_hash.get("Machine").get("ip");
		String os = client_hash.get("System").get("os");
		String group_name = client_hash.get("Machine").get("group");
		String memory_left = client_hash.get("System").get("mem");
		String disk_left = client_hash.get("System").get("space");
		String cpu_used = client_hash.get("System").get("cpu");
		String os_type = client_hash.get("System").get("os_type");
		String high_priority = "NA";
		String max_procs = switch_info.get_pool_max_procs();
		complex_data.putAll(simple_data);
		complex_data.put("host_ip", host_ip);
		complex_data.put("os", os);
		complex_data.put("group_name", group_name);
		complex_data.put("memory_left", memory_left);
		complex_data.put("disk_left", disk_left);
		complex_data.put("cpu_used", cpu_used);
		complex_data.put("os_type", os_type);
		complex_data.put("high_priority", high_priority);
		complex_data.put("max_procs", max_procs);
		String send_msg = new String();
		xml_parser parser = new xml_parser();
		if (mode.equals("simple")){
			send_msg = parser.create_client_document_string(simple_data);
		} else {
			send_msg = parser.create_client_document_string(complex_data);
		}
		send_status = rmq_tube.basic_send(public_data.RMQ_INFO_NAME, send_msg);
		return send_status;
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
		// initial 4 : send client detail info
		send_client_info("complex");
		int send_count = 0;
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
			dynamic_merge_client_data();
			//task 2: update max_sw_insts limitation
			update_max_sw_insts_limitation();
			//task 3: send client info to Remote server
			if (send_count < 6){
				send_count++;
				send_client_info("simple");
			} else {
				send_count = 0;
				send_client_info("complex");
			}
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