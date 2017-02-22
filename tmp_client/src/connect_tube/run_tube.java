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

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.public_data;


public class run_tube extends Thread  {
	// public property
	// protected property
	// private property
	private static final Logger TUBE_LOGGER = LogManager.getLogger(run_tube.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread tube_thread;
	private int interval = public_data.PERF_THREAD_RUN_INTERVAL;	
	// public function
	public run_tube(){
		
	}
	// protected function
	// private function	
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