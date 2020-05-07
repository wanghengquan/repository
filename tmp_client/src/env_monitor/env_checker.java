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

import java.io.File;
import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;
import top_runner.run_status.exit_enum;
import utility_funcs.system_cmd;


public class env_checker extends TimerTask {
	// public property
	// protected property
	// private property
	private static final Logger ENV_CHECKER_LOGGER = LogManager.getLogger(env_checker.class.getName());	
	private switch_data switch_info;
	private client_data client_info;
	// private String line_separator = System.getProperty("line.separator");
	// public function
	// protected function
	// private function

	public env_checker(
			switch_data switch_info, 
			client_data client_info) {
		this.switch_info = switch_info;
		this.client_info = client_info;
	}
	
	public env_checker() {
	}	
	
	private String get_tools_path(String tool) {
		String which_cmd = new String("");
		String host_run = System.getProperty("os.name").toLowerCase();
		if (host_run.startsWith("windows")) {
			which_cmd = public_data.TOOLS_WHICH + " ";
		} else {
			which_cmd = "which ";
		}
		String cmd = new String(which_cmd + " " + tool);
		ArrayList<String> excute_retruns = new ArrayList<String>();
		String path_str = new String("unknown");
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
		Pattern path_patt = Pattern.compile(tool, Pattern.CASE_INSENSITIVE);
		for (String line : excute_retruns){
		    if(line == null || line == "")
		        continue;
		    if(line.contains("which")){
		    	continue;
		    }
			Matcher path_match = path_patt.matcher(line);
			if (path_match.find()) {
				path_str = line;
				break;
			}
		}
		if (path_str.equals("unknown")){
			ENV_CHECKER_LOGGER.error("Got unknown info for command:" + cmd);
			for(String item: excute_retruns){
				ENV_CHECKER_LOGGER.error(item);
			}
		}
		return path_str;
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
		    if(line == null || line == "")
		        continue;
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
            if(line == null || line == "")
                continue;
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

	private Boolean tool_path_check(String tool_name) {
		String tool_path = get_tools_path(tool_name);
		if (tool_path.equals("unknown")) {
			ENV_CHECKER_LOGGER.error("Get " + tool_name + " path error");
			return false;
		}
		ENV_CHECKER_LOGGER.info(tool_name.toUpperCase() + " default path:" + tool_path);
		File tool = new File(tool_path);
		if (!tool.canExecute()){
			ENV_CHECKER_LOGGER.error(tool_name.toUpperCase() + " is not executable");
			return false;
		}
		System.setProperty(tool_name.toLowerCase(), tool.getParent().replaceAll("\\\\", "/"));
		return true;
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
		Boolean py_ok = Boolean.valueOf(false);
		try {
			excute_retruns.addAll(system_cmd.run(cmd));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			ENV_CHECKER_LOGGER.error("python env check error out");
		}
		Pattern ok_patt = Pattern.compile("python\\s*ok", Pattern.CASE_INSENSITIVE);
		for (String line : excute_retruns){
            if(line == null || line == "")
                continue;
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
	
	private Boolean work_path_check(String check_path) {
		File check_fh = new File(check_path);
		if (check_fh.canWrite()){
			return true;
		} else {
			return false;
		}
	}
	
	public void report_default_tools(){
		tool_path_check("python");
		tool_path_check("svn");
	}
	
	public Boolean do_self_check(String work_path) {
		Boolean check_result = Boolean.valueOf(false);
		Boolean python_pass = Boolean.valueOf(false);
		Boolean python_env = Boolean.valueOf(false);
		Boolean svn_pass = Boolean.valueOf(false);
		Boolean writable_pass = Boolean.valueOf(false);
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
			writable_pass = work_path_check(work_path);
			if (python_pass && python_env && svn_pass && writable_pass) {
				check_result = true;
				break;
			} else {
				ENV_CHECKER_LOGGER.error("Self Check failed:");
				ENV_CHECKER_LOGGER.error("Client Python version:" + python_pass.toString());
				ENV_CHECKER_LOGGER.error("Client Python environ:" + python_env.toString());
				ENV_CHECKER_LOGGER.error("Client SVN version:" + svn_pass.toString());
				ENV_CHECKER_LOGGER.error("Work Path writable Check:" + writable_pass.toString());
				ENV_CHECKER_LOGGER.error("Work Path"  + " " + work_path);
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
		String work_space = new String("");
		work_space = client_info.get_client_preference_data().getOrDefault("work_space", public_data.DEF_WORK_SPACE);
		if (do_self_check(work_space)){
			switch_info.set_client_environ_issue(false);
		} else {
			switch_info.set_client_environ_issue(true);
		}
	}
	
	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		Timer my_timer = new Timer();
		my_timer.scheduleAtFixedRate(new env_checker(null,null), 1000, 5000);		
	}
}