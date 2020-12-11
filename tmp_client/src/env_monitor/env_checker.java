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
import utility_funcs.time_info;


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
		Pattern version_patt = Pattern.compile("svn.+\\s+(\\d\\.\\d+\\.\\d+)", Pattern.CASE_INSENSITIVE);
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
		if (version_suitable_check(public_data.BASE_JAVABASEVERSION, cur_ver_str, null)) {
			return true;
		} else {
			ENV_CHECKER_LOGGER.error("Java version out of scope." + cur_ver_str);
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
		if (version_suitable_check(public_data.BASE_PYTHONBASEVERSION, cur_ver_str, public_data.BASE_PYTHONMAXVERSION)) {
			return true;
		} else {
			ENV_CHECKER_LOGGER.error("Python version out of scope:" + cur_ver_str);
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
			ENV_CHECKER_LOGGER.error("Python env check error out");
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
		if (version_suitable_check(public_data.BASE_SVNBASEVERSION, cur_ver_str, null)) {
			return true;
		} else {
			ENV_CHECKER_LOGGER.error("SVN version out of scope:" + cur_ver_str);
			return false;
		}
	}
	
	private Boolean version_suitable_check(
			String min_version,
			String cur_version,
			String max_version) {
		//This function used to do version
		//input: min version requirements, xx.xx
		//		 cur version for check, xx.xx
		//       max version requirements, xx.xx
		//output: true or false
		Boolean ver_status = Boolean.valueOf(false);
		if (min_version == null || min_version == "") {
			ENV_CHECKER_LOGGER.error("Min version error.");
			return ver_status;
		}
		if (cur_version == null || cur_version == "") {
			ENV_CHECKER_LOGGER.error("Current version error.");
			return ver_status;
		}
		if (!min_version.contains(".")) {
			ENV_CHECKER_LOGGER.error("Min version wrong format:" + min_version + ".");
			return ver_status;
		}		
		if (!cur_version.contains(".")) {
			ENV_CHECKER_LOGGER.error("Current version wrong format:" + cur_version + ".");
			return ver_status;
		}
		if (max_version == null || max_version == "") {
			ENV_CHECKER_LOGGER.info("Max version not given.");
		} else {
			if (!max_version.contains(".")) {
				ENV_CHECKER_LOGGER.error("Max version wrong format:" + max_version + ".");
				return ver_status;
			}
		}
		//data parser
		String[] min_array = min_version.split("\\.");
		int min_main = Integer.valueOf(min_array[0]);
		int min_sub = Integer.valueOf(min_array[1]);
		String[] cur_array = cur_version.split("\\.");
		int cur_main = Integer.valueOf(cur_array[0]);
		int cur_sub = Integer.valueOf(cur_array[1]);
		//cur version >= min version verification
		if (min_main > cur_main) {
			ver_status = false;
		} else if (min_main < cur_main) {
			ver_status = true;
		} else {
			if (min_sub > cur_sub) {
				ver_status = false;
			} else {
				ver_status = true;
			}
		}
		if (ver_status.equals(false)) {
			return ver_status;
		}
		//cur version <= max
		if (max_version == null || max_version == "") {
			return ver_status;
		}
		String[] max_array = max_version.split("\\.");
		int max_main = Integer.valueOf(max_array[0]);
		int max_sub = Integer.valueOf(max_array[1]);
		if (cur_main > max_main) {
			ver_status = false;
		} else if (cur_main < max_main) {
			ver_status = true;
		} else {
			if (cur_sub > max_sub) {
				ver_status = false;
			} else {
				ver_status = true;
			}
		}
		return ver_status;		
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
				check_result = false;
			}
			try {
				Thread.sleep(500);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if (!check_result) {
			ENV_CHECKER_LOGGER.error("==Self Check failed==" + time_info.get_date_time());
			ENV_CHECKER_LOGGER.error("Client Python version:" + python_pass.toString());
			ENV_CHECKER_LOGGER.error("Client Python environ:" + python_env.toString());
			ENV_CHECKER_LOGGER.error("Client SVN version:" + svn_pass.toString());
			ENV_CHECKER_LOGGER.error("Work Path writable Check:" + writable_pass.toString());
			ENV_CHECKER_LOGGER.error("Work Path:" + work_path);
			ENV_CHECKER_LOGGER.error("");
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