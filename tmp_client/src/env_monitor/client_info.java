/*
 * File: system_info.java
 * Description: run system command line
 * Author: Jason.Wang
 * Date:2017/02/16
 * Modifier:
 * Date:
 * Description:
 */

package env_monitor;

import java.io.File;
import java.io.IOException;
import java.util.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.public_data;
import utility_funcs.system_cmd;
import utility_funcs.linux_info;

/*
 * This class used to get the basic information of the client.
 * return client_hash:
 * 		System	:	os		=	type_arch
 * 					type	=	windows/linux
 * 					arch	=	32b/64b
 * 					space	=	xxG
 * 					cpu		=	xx%
 * 					mem		=	xxG
 * 		Machine	:	terminal=	xxx
 * 					group	=	xxx 	
 */
public class client_info extends Thread {
	// public property
	// protected property
	protected static HashMap<String, HashMap<String, String>> client_hash = new HashMap<String, HashMap<String, String>>();
	// private property
	private static final Logger INFO_LOGGER = LogManager.getLogger(client_info.class.getName());

	// public function
	public client_info() {

	}

	// protected function
	// private function
	private String get_os() {
		String run_cmd = "python " + public_data.os_name_tool;
		String os_name = new String();
		try {
			ArrayList<String> excute_retruns = system_cmd.run(run_cmd);
			os_name = excute_retruns.get(1);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			INFO_LOGGER.warn("Cannot resolve Operation System name");
			os_name = "unknown";
		}
		return os_name;
	}

	public String get_disk_left() {
		File file = new File("..");
		String disk_left = new String();
		// long total_space = file.getTotalSpace();
		long free_space = file.getFreeSpace();
		// long used_space = total_space - free_space;
		disk_left = free_space / 1024 / 1024 / 1024 + "G";
		return disk_left;
	}
	
	public String get_cpu_usage() {
		
		return disk_left;
	}
}