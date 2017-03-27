/*
 * File: cmd_parser.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package top_control;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.core.config.ConfigurationSource;
import org.apache.logging.log4j.core.config.Configurator;

import connect_tube.task_data;
import connect_tube.tube_server;
import data_center.client_data;
import data_center.data_server;
import data_center.public_data;
import data_center.switch_data;
import flow_control.hall_manager;
import flow_control.pool_data;
import gui_interface.view_data;
import gui_interface.view_server;


public class tmp_manager extends Thread  {
	// public property
	// protected property
	// private property
	private static final Logger TMP_MANAGER_LOGGER = LogManager.getLogger(tmp_manager.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread client_thread;
	//private String line_seprator = System.getProperty("line.separator");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;	
	// public function
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
				TMP_MANAGER_LOGGER.debug("Client Thread running...");
			}
			
			// System.out.println("Thread running...");
			try {
				Thread.sleep(base_interval * 2 * 1000);
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
		//log config
		String class_path_str = public_data.class.getResource("").getPath();
		File class_path = new File(class_path_str);
		String bin_path = class_path.getParentFile().getParent();
		String cfg_path = bin_path + "/conf/log4j2.xml"; 
		ConfigurationSource source = null;
		try {
			source = new ConfigurationSource(new FileInputStream(cfg_path));
		} catch (FileNotFoundException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		Configurator.initialize(null, source);
		
		
		
		switch_data switch_info = new switch_data();
		task_data task_info = new task_data();
		client_data client_info = new client_data();
		view_data view_info = new view_data();
		pool_data pool_info = new pool_data(public_data.PERF_POOL_MAXIMUM_SIZE);
		view_server view_runner = new view_server(switch_info, client_info, task_info, view_info, pool_info);
		view_runner.start();
		data_server data_runner = new data_server(switch_info, client_info, pool_info);		
		data_runner.start();
		while(true){
			if (switch_info.get_data_server_power_up()){
				System.out.println(">>>data server power up");
				break;
			}
		}
		tube_server tube_runner = new tube_server(switch_info, client_info, pool_info, task_info);
		tube_runner.start();
		while(true){
			if (switch_info.get_tube_server_power_up()){
				System.out.println(">>>tube server power up");
				break;
			}
		}
		hall_manager jason = new hall_manager(switch_info, client_info, pool_info, task_info, view_info);
		jason.start();
		try {
			Thread.sleep(10*1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}