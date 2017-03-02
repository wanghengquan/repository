/*
 * File: cmd_parser.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package connect_tube;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;

public class run_tube extends Thread {
	// public property
	public static ConcurrentHashMap<String, HashMap<String, HashMap<String, String>>> captured_admin_queues = new ConcurrentHashMap<String, HashMap<String, HashMap<String, String>>>();
	// protected property
	// private property
	private static final Logger TUBE_LOGGER = LogManager.getLogger(run_tube.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread tube_thread;
	private switch_data switch_info;
	private client_data client_info;
	private int interval = public_data.PERF_THREAD_RUN_INTERVAL;

	// public function
	public run_tube(switch_data switch_info, client_data client_info) {
		this.switch_info = switch_info;
		this.client_info = client_info;
	}

	// protected function
	// private function

	public Boolean admin_queue_match_check(HashMap<String, HashMap<String, String>> queue_data,
			Map<String, HashMap<String, String>> client_hash) {
		Boolean client_match = true;
		// check System match
		HashMap<String, String> system_require_data = queue_data.get("System");
		Set<String> system_require_set = system_require_data.keySet();
		Iterator<String> system_require_it = system_require_set.iterator();
		while (system_require_it.hasNext()) {
			String key_name = system_require_it.next();
			String value = system_require_data.get(key_name);
			if (key_name.equals("min_space")) {
				String client_available_space = client_hash.get("System").get("space");
				if (Integer.valueOf(value) > Integer.valueOf(client_available_space)) {
					client_match = false;
					break;
				}
			} else {
				if (!value.contains(client_hash.get("System").get(key_name))) {
					client_match = false;
					break;
				}
			}
		}
		if (!client_match) {
			return client_match;
		}
		// check machine match
		HashMap<String, String> machine_require_data = queue_data.get("Machine");
		Set<String> machine_require_set = machine_require_data.keySet();
		Iterator<String> machine_require_it = machine_require_set.iterator();
		while (machine_require_it.hasNext()) {
			String key_name = machine_require_it.next();
			String value = machine_require_data.get(key_name);
			if (!value.contains(client_hash.get("Machine").get(key_name))) {
				client_match = false;
				break;
			}
		}
		String client_current_private = client_hash.get("Machine").get("private");
		if (client_current_private.equals("1")){
			if (!machine_require_data.containsKey("terminal")){
				client_match = false;
				return client_match;
			}
		}
		if (!client_match) {
			return client_match;
		}
		// check software match
		HashMap<String, String> software_require_data = queue_data.get("Software");
		Set<String> software_require_set = software_require_data.keySet();
		Iterator<String> software_require_it = software_require_set.iterator();
		while (software_require_it.hasNext()) {
			String sw_name = software_require_it.next();
			String sw_build = software_require_data.get(sw_name);
			if (!client_hash.containsKey(sw_name)) {
				client_match = false;
				break;
			}
			if (!client_hash.get(sw_name).containsKey(sw_build)) {
				client_match = false;
				break;
			}
		}
		// return result
		return client_match;
	}

	private void update_captured_admin_queues() {
		Map<String, HashMap<String, String>> client_hash = new HashMap<String, HashMap<String, String>>();
		Map<String, HashMap<String, HashMap<String, String>>> total_admin_queue = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		client_hash.putAll(client_info.client_hash);
		total_admin_queue.putAll(rmq_tube.remote_admin_queue_receive_treemap);
		total_admin_queue.putAll(local_tube.local_admin_queue_receive_treemap);
		Set<String> queue_set = total_admin_queue.keySet();
		Iterator<String> queue_it = queue_set.iterator();
		while (queue_it.hasNext()) {
			Boolean client_match = true;
			String queue_name = queue_it.next();
			HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
			// check System match
			client_match = admin_queue_match_check(queue_data, client_hash);
			if (client_match) {
				captured_admin_queues.put(queue_name, queue_data);
			}
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
		tube_thread = Thread.currentThread();
		// 1. start rmq tube (admin queque)
		try {
			rmq_tube.read_admin_server(public_data.RMQ_ADMIN_NAME, client_info.get_client_data().get("Machine").get("terminal"));
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			// e1.printStackTrace();
			TUBE_LOGGER.error("Link to RabbitMQ server failed");
		}
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
				TUBE_LOGGER.warn("Tube Thread running...");
			}
			// 2. update local tube
			String suite_files = switch_info.get_suite_file_string();
			if (suite_files != null && !suite_files.equals("")) {
				local_tube local_tube_parser = new local_tube();
				String[] file_list = suite_files.split(";");
				for (String file : file_list) {
					local_tube_parser.generate_local_queue_hash(file, client_info.get_client_data().get("Machine").get("terminal"));
				}
				switch_info.set_suite_file_string("");
			}
			// 3. update available admin queue
			switch_info.set_available_admin_queue_updating(1);
			update_captured_admin_queues();
			switch_info.set_available_admin_queue_updating(0);
			//System.out.println(available_admin_queue_receive.toString());
			// 4. send machine data
			
			
			
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
		if (tube_thread != null) {
			tube_thread.interrupt();
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
		run_tube tube_runner = new run_tube(switch_info, client_info);
		tube_runner.start();
	}
}