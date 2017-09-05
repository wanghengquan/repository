/*
 * File: cmd_parser.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package top_runner.run_manager;


import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.exit_enum;
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
			System.out.println(">>>Info: Shut down hook called.");
			// shut down task 1:
			switch_info.decrease_system_client_insts();
			int start_insts = switch_info.get_system_client_insts();
			System.out.println(">>>Info: " + String.valueOf(start_insts) + " TMP Client(s) launched now.");
			// shut down task 2:
		} catch (Exception run_exception) {
			run_exception.printStackTrace();			
			System.exit(exit_enum.DUMP.get_index());
		}
	}

	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		switch_data switch_info = new switch_data();
		shut_down sh = new shut_down(switch_info);
		Runtime.getRuntime().addShutdownHook(sh);
		System.exit(exit_enum.NORMAL.get_index());
		try {
			Thread.sleep(10000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
		
}