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


import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.switch_data;


public class shut_down extends Thread {
	// public property
	// protected property
	// private property
	private static final Logger SHUT_DOWN_LOGGER = LogManager.getLogger(shut_down.class.getName());
	private switch_data switch_info;
	// sub threads need to be launched
	// public function
	// protected function
	// private function

	public shut_down(switch_data switch_info) {
		this.switch_info = switch_info;
	}

	public void run() {
		try {
			SHUT_DOWN_LOGGER.info("shut_down hook called.");
			System.out.println(">>>Info: shut_down hook called.");
			// shut down task 1:
			switch_info.decrease_system_client_insts();
			// shut down task 2:
		} catch (Exception run_exception) {
			run_exception.printStackTrace();			
			System.exit(1);
		}
	}

	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		switch_data switch_info = new switch_data();
		shut_down sh = new shut_down(switch_info);
		Runtime.getRuntime().addShutdownHook(sh);
		System.exit(1);
		try {
			Thread.sleep(10000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
		
}