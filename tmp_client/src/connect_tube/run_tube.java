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

import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.data_server;
import data_center.exchange_data;
import data_center.public_data;

public class run_tube extends Thread {
	// public property
	public static TreeMap<String, HashMap<String, HashMap<String, String>>> available_admin_queue_receive = new TreeMap<String, HashMap<String, HashMap<String, String>>>(
			new Comparator<String>() {
				public int compare(String queue_name1, String queue_name2) {
					// x_x_time@runxxx_time :
					// priority:match/assign task:job_from@run_number
					int int_pri1 = 0, int_pri2 = 0;
					int int_id1 = 0, int_id2 = 0;
					try {
						int_pri1 = get_srting_int(queue_name1, "^(\\d+)@");
						int_pri2 = get_srting_int(queue_name2, "^(\\d+)@");
						int_id1 = get_srting_int(queue_name1, "run_(\\d+)_");
						int_id2 = get_srting_int(queue_name2, "run_(\\d+)_");
					} catch (Exception e) {
						return queue_name1.compareTo(queue_name2);
					}
					if (int_pri1 > int_pri2) {
						return 1;
					} else if (int_pri1 < int_pri2) {
						return -1;
					} else {
						if (int_id1 > int_id2) {
							return 1;
						} else if (int_id1 < int_id2) {
							return -1;
						} else {
							return queue_name1.compareTo(queue_name2);
						}
					}
				}
			});
	// protected property
	// private property
	private static final Logger TUBE_LOGGER = LogManager.getLogger(run_tube.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread tube_thread;
	private exchange_data share_data;
	private int interval = public_data.PERF_THREAD_RUN_INTERVAL;

	// public function
	public run_tube(exchange_data share_data) {
		this.share_data = share_data;
	}

	// protected function
	// private function
	private static int get_srting_int(String str, String patt) {
		int i = 0;
		try {
			Pattern p = Pattern.compile(patt);
			Matcher m = p.matcher(str);
			if (m.find()) {
				i = Integer.valueOf(m.group(1));
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}
		return i;
	}

	public Boolean admin_queue_match_check(HashMap<String, HashMap<String, String>> queue_data,
			Map<String, HashMap<String, String>> client_current_data) {
		Boolean client_match = true;
		// check System match
		HashMap<String, String> system_data = queue_data.get("System");
		Set<String> system_set = system_data.keySet();
		Iterator<String> system_it = system_set.iterator();
		while (system_it.hasNext()) {
			String key_name = system_it.next();
			String value = system_data.get(key_name);
			if (key_name.equals("min_space")) {
				String client_available_space = client_current_data.get("System").get("space");
				if (Integer.valueOf(value) > Integer.valueOf(client_available_space)) {
					client_match = false;
					break;
				}
			} else {
				if (!value.contains(client_current_data.get("System").get(key_name))) {
					client_match = false;
					break;
				}
			}
		}
		if (!client_match) {
			return client_match;
		}
		// check machine match
		HashMap<String, String> machine_data = queue_data.get("Machine");
		Set<String> machine_set = machine_data.keySet();
		Iterator<String> machine_it = machine_set.iterator();
		while (machine_it.hasNext()) {
			String key_name = machine_it.next();
			String value = machine_data.get(key_name);
			if (!value.contains(client_current_data.get("Machine").get(key_name))) {
				client_match = false;
				break;
			}
		}
		if (!client_match) {
			return client_match;
		}
		// check software match
		HashMap<String, String> software_data = queue_data.get("Software");
		Set<String> software_set = software_data.keySet();
		Iterator<String> software_it = software_set.iterator();
		while (software_it.hasNext()) {
			String sw_name = software_it.next();
			String sw_build = software_data.get(sw_name);
			if (!client_current_data.containsKey(sw_name)) {
				client_match = false;
				break;
			}
			if (!client_current_data.get(sw_name).containsKey(sw_build)) {
				client_match = false;
				break;
			}
		}
		// return result
		return client_match;
	}

	private void update_available_admin_queue() {
		Map<String, HashMap<String, String>> client_current_data = new HashMap<String, HashMap<String, String>>();
		Map<String, HashMap<String, HashMap<String, String>>> total_admin_queue = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		client_current_data.putAll(data_server.client_hash);
		total_admin_queue.putAll(rmq_tube.remote_admin_queue_receive);
		total_admin_queue.putAll(local_tube.local_admin_queue_receive);
		Set<String> queue_set = total_admin_queue.keySet();
		Iterator<String> queue_it = queue_set.iterator();
		while (queue_it.hasNext()) {
			Boolean client_match = true;
			String queue_name = queue_it.next();
			HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
			// check System match
			client_match = admin_queue_match_check(queue_data, client_current_data);
			if (client_match) {
				available_admin_queue_receive.put(queue_name, queue_data);
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
			rmq_tube.read_admin_server(public_data.RMQ_ADMIN_NAME);
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
			String suite_files = share_data.get_suite_file_string();
			if (suite_files != null && !suite_files.equals("")) {
				local_tube local_tube_parser = new local_tube();
				String[] file_list = suite_files.split(";");
				for (String file : file_list) {
					local_tube_parser.generate_local_queue_hash(file);
				}
				share_data.set_suite_file_string("");
			}
			// 3. update available admin queue
			share_data.set_available_admin_queue_updating(1);
			update_available_admin_queue();
			share_data.set_available_admin_queue_updating(0);
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
		exchange_data share_data = new exchange_data();
		run_tube tube_runner = new run_tube(share_data);
		tube_runner.start();
	}
}