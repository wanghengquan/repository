/*
 * File: self_check.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package env_monitor;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.exit_enum;
import data_center.public_data;
import data_center.switch_data;
import utility_funcs.system_cmd;


public class env_checker extends Thread {
	// public property
	// protected property
	// private property
	private static final Logger ENV_CHECKER_LOGGER = LogManager.getLogger(env_checker.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;	
	private Thread current_thread;		
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;	
	private switch_data switch_info;
	// private String line_separator = System.getProperty("line.separator");
	// public function
	// protected function
	// private function

	public env_checker(switch_data switch_info) {
		this.switch_info = switch_info;
	}
	
	private String get_python_version() {
		String cmd = "python --version ";
		// Python 2.7.2
		ArrayList<String> excute_retruns = new ArrayList<String>();
		String ver_str = new String("unknown");
		try {
			excute_retruns.addAll(system_cmd.run(cmd));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
		}
		Pattern version_patt = Pattern.compile("python\\s(\\d\\.\\d+.\\d+)", Pattern.CASE_INSENSITIVE);
		for (String line : excute_retruns){
			Matcher version_match = version_patt.matcher(line);
			if (version_match.find()) {
				ver_str = version_match.group(1);
				break;
			}
		}
		return ver_str;
	}

	private String get_java_version() {
		String ver_str = System.getProperty("java.version");
		return ver_str;
	}

	private String get_svn_version() {
		String cmd = "svn --version";
		// svn, version 1.6.11 (r934486)
		String ver_str = "unknown";
		ArrayList<String> excute_retruns = new ArrayList<String>();
		try {
			excute_retruns.addAll(system_cmd.run(cmd));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
		}
		Pattern version_patt = Pattern.compile("svn.+\\s+(\\d\\.\\d\\.\\d+)", Pattern.CASE_INSENSITIVE);
		for (String line : excute_retruns){
			Matcher version_match = version_patt.matcher(line);
			if (version_match.find()) {
				ver_str = version_match.group(1);
				break;
			}
		}
		return ver_str;
	}

	@SuppressWarnings("unused")
	private Boolean java_version_check() {
		String cur_ver = get_java_version();
		if (cur_ver.equals("unknown")) {
			return false;
		}
		String[] ver_array = cur_ver.split("\\.");
		String cur_ver_str = ver_array[0] + "." + ver_array[1];
		Float cur_ver_float = Float.parseFloat(cur_ver_str);
		if (cur_ver_float >= public_data.BASE_JAVABASEVERSION) {
			return true;
		} else {
			ENV_CHECKER_LOGGER.error("Java version out of scope.");
			return false;
		}
	}

	private Boolean python_version_check() {
		String cur_ver = get_python_version();
		if (cur_ver.equals("unknown")) {
			return false;
		}
		String[] ver_array = cur_ver.split("\\.");
		String cur_ver_str = ver_array[0] + "." + ver_array[1];
		Float cur_ver_float = Float.parseFloat(cur_ver_str);
		if (cur_ver_float >= public_data.BASE_PYTHONBASEVERSION && cur_ver_float <= 3.0f) {
			return true;
		} else {
			ENV_CHECKER_LOGGER.error("python version out of scope.");
			return false;
		}
	}

	private Boolean svn_version_check() {
		String cur_ver = get_svn_version();
		if (cur_ver.equals("unknown")) {
			return false;
		}
		String[] ver_array = cur_ver.split("\\.");
		String cur_ver_str = ver_array[0] + "." + ver_array[1];
		Float cur_ver_float = Float.parseFloat(cur_ver_str);
		if (cur_ver_float >= public_data.BASE_SVNBASEVERSION) {
			return true;
		} else {
			ENV_CHECKER_LOGGER.error("SVN version out of scope.");
			return false;
		}
	}
	
	public Boolean do_self_check() {
		Boolean check_result = new Boolean(false);
		//Boolean java_pass = java_version_check();
		Boolean python_pass = python_version_check();
		Boolean svn_pass = svn_version_check();
		if (python_pass && svn_pass) {
			check_result = true;
		} else {
			ENV_CHECKER_LOGGER.error("Self Check failed, System error out.");
			//ENV_CHECKER_LOGGER.error("Client JAVA version:" + get_java_version());
			ENV_CHECKER_LOGGER.error("Client Python version:" + get_python_version());
			ENV_CHECKER_LOGGER.error("Client SVN version:" + get_svn_version());
		}
		return check_result;
	}

	public void run() {
		try {
			monitor_run();
		} catch (Exception run_exception) {
			run_exception.printStackTrace();
			switch_info.set_client_stop_exception(run_exception);
			switch_info.set_client_stop_request(exit_enum.DUMP);
		}
	}
	
	private void monitor_run() {
		current_thread = Thread.currentThread();
		// ============== All static job start from here ==============
		// initial 1 : get all runner
		// start loop:
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
				ENV_CHECKER_LOGGER.debug("Client Thread running...");
			}
			// ============== All dynamic job start from here ==============
			// task 0 : run env check
			if (do_self_check()){
				switch_info.set_client_environ_issue(false);
			} else {
				switch_info.set_client_environ_issue(true);
			}
			// task 1 : 
			try {
				Thread.sleep(base_interval * 1 * 1000);
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
		if (current_thread != null) {
			current_thread.interrupt();
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
		self_check my_check = new self_check();
		my_check.do_self_check();
	}
}