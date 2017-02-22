/*
 * File: cmd_parser.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package data_center;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import env_monitor.config_sync;
import env_monitor.machine_sync;


public class client_data extends Thread  {
	// public property
	// protected property
	// private property
	private static final Logger CLIENT_LOGGER = LogManager.getLogger(client_data.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread client_thread;
	private int interval = public_data.THREAD_RUN_INTERVAL;	
	// public function
	// protected function
	// private function	
	
	private void merge_client_data(){
		
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
				CLIENT_LOGGER.debug("Client Thread running...");
			}
			merge_client_data();
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
		exchange_data share_data = new exchange_data();
		config_sync ini_runner = new config_sync(share_data);
		machine_sync machine_runner = new machine_sync();
		ini_runner.run();
		machine_runner.run();
		
		ini_runner.run();
	}
}