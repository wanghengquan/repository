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
import java.util.Map;
import java.util.TreeMap;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.exchange_data;
import data_center.public_data;


public class run_tube extends Thread  {
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
		//1. start rmq tube (admin queque)
		try {
			rmq_tube.read_admin_server(public_data.RMQ_ADMIN_NAME);
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			//e1.printStackTrace();
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
				TUBE_LOGGER.warn("Client Thread running...");
			}
			//2. update local tube
			
			//3. update available admin queue
			
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
		config_sync ini_runner = new config_sync(share_data);
		machine_sync machine_runner = new machine_sync();
		ini_runner.run();
		machine_runner.run();
		ini_runner.run();
	}
}