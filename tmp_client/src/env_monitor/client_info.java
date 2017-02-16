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

import java.io.IOException;
import java.util.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

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

	public String get_os() {
		String run_cmd = "python " + osScript;
		try {
			ArrayList<String> excute_retruns = execute_system_cmd.run(cmd);
			this.os = excute_retruns.get(1);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			this.os = "unknown";
		}
		return this.os;
	}

	public String getOsArch() {
		String cmd = "python " + osScript;
		try {
			ArrayList<String> excute_retruns = execute_system_cmd.run(cmd);
			this.os = excute_retruns.get(1);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			this.os = "unknown";
		}
		if (this.os.contains("_")) {
			this.os_arch = this.os.split("_")[1];
		} else {
			this.os_arch = "unknown";
		}
		return this.os_arch;
	}

	public void setOs() {
		/*
		 * left empty
		 */
	}
	// protected function
	// private function

}