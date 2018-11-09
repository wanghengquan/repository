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
	
	public env_checker() {
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
			ENV_CHECKER_LOGGER.error("Run command failed:" + cmd);
			ENV_CHECKER_LOGGER.error(e.toString());
			for(Object item: e.getStackTrace()){
				ENV_CHECKER_LOGGER.error(item.toString());
			}			
		}
		Pattern version_patt = Pattern.compile("python\\s(\\d\\.\\d+.\\d+)", Pattern.CASE_INSENSITIVE);
		for (String line : excute_retruns){
			Matcher version_match = version_patt.matcher(line);
			if (version_match.find()) {
				ver_str = version_match.group(1);
				break;
			}
		}
		if (ver_str.equals("unknown")){
			ENV_CHECKER_LOGGER.error("Got unknown Python version. command returns:");
			for(String item: excute_retruns){
				ENV_CHECKER_LOGGER.error(item);
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
			ENV_CHECKER_LOGGER.error("ENV svn run command failed:" + cmd);
			ENV_CHECKER_LOGGER.error(e.toString());
			for(Object item: e.getStackTrace()){
				ENV_CHECKER_LOGGER.error(item.toString());
			}		
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
			ENV_CHECKER_LOGGER.error("Get python version error: unknown version");
			return false;
		}
		String[] ver_array = cur_ver.split("\\.");
		String cur_ver_str = ver_array[0] + "." + ver_array[1];
		Float cur_ver_float = Float.parseFloat(cur_ver_str);
		if (cur_ver_float >= public_data.BASE_PYTHONBASEVERSION && cur_ver_float <= 3.0f) {
			return true;
		} else {
			ENV_CHECKER_LOGGER.error("python version out of scope:" + cur_ver_float.toString());
			return false;
		}
	}

	private Boolean python_environ_check() {
		String cmd = "python " + public_data.TOOLS_PY_ENV;
		// Python ok
		ArrayList<String> excute_retruns = new ArrayList<String>();
		Boolean py_ok = new Boolean(false);
		try {
			excute_retruns.addAll(system_cmd.run(cmd));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			ENV_CHECKER_LOGGER.error("python env check error out");
		}
		Pattern ok_patt = Pattern.compile("python\\s*ok", Pattern.CASE_INSENSITIVE);
		for (String line : excute_retruns){
			Matcher ok_match = ok_patt.matcher(line);
			if (ok_match.find()) {
				py_ok = true;
				break;
			}
		}
		return py_ok;
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
			ENV_CHECKER_LOGGER.error("SVN version out of scope:" + cur_ver_float.toString());
			return false;
		}
	}
	
	public Boolean do_self_check() {
		Boolean check_result = new Boolean(false);
		Boolean python_pass = new Boolean(false);
		Boolean python_env = new Boolean(false);
		Boolean svn_pass = new Boolean(false);
		int check_counter = 0;
		//to minimize the wrong warning any success in 3 try will be considered as env ok.
		while(true){
			check_counter += 1;
			if (check_counter > 3){
				break;
			}
			python_pass = python_version_check();
			python_env = python_environ_check();
			svn_pass = svn_version_check();	
			if (python_pass && python_env && svn_pass) {
				check_result = true;
				break;
			} else {
				ENV_CHECKER_LOGGER.error("Self Check failed:");
				ENV_CHECKER_LOGGER.error("Client Python version:" + python_pass.toString());
				ENV_CHECKER_LOGGER.error("Client Python environ:" + python_env.toString());
				ENV_CHECKER_LOGGER.error("Client SVN version:" + svn_pass.toString());
				check_result = false;
			}
			try {
				Thread.sleep(500);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
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
		env_checker my_check = new env_checker(null);
		my_check.do_self_check();
	}
}