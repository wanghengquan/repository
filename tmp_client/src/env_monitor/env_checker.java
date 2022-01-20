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
import java.io.IOException;
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
import utility_funcs.version_info;


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
	
	private Boolean python_version_check() {
		String python_cmd = new String("");
		python_cmd = client_info.get_client_tools_data().getOrDefault("python", public_data.DEF_PYTHON_PATH);
		String cur_ver = version_info.get_python_version(python_cmd);
		if (cur_ver.equals("unknown")) {
			ENV_CHECKER_LOGGER.warn("Get Python version error: unknown version");
			return false;
		}
		String[] ver_array = cur_ver.split("\\.");
		String cur_ver_str = ver_array[0] + "." + ver_array[1];
		if (version_info.version_suitable_check(public_data.BASE_PYTHONBASEVERSION, cur_ver_str, public_data.BASE_PYTHONMAXVERSION)) {
			return true;
		} else {
			ENV_CHECKER_LOGGER.warn("Python version out of scope:" + cur_ver_str);
			return false;
		}
	}

	private Boolean python_environ_check() {
		String python_path = new String("");
		python_path = client_info.get_client_tools_data().getOrDefault("python", public_data.DEF_PYTHON_PATH);
		String cmd = python_path + " " + public_data.TOOLS_PY_ENV;
		// Python ok
		ArrayList<String> excute_retruns = new ArrayList<String>();
		Boolean py_ok = Boolean.valueOf(false);
		try {
			excute_retruns.addAll(system_cmd.run(cmd));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			ENV_CHECKER_LOGGER.warn("Python environment check error out");
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
	
	private Boolean work_path_check(String check_path) {
		File check_fh = new File(check_path);
		if (check_fh.canWrite()){
			return true;
		} else {
			return false;
		}
	}
	
	private void run_environ_monitor() {
		String work_space = new String("");
		work_space = client_info.get_client_preference_data().getOrDefault("work_space", public_data.DEF_WORK_SPACE);	
		Boolean check_result = Boolean.valueOf(false);
		Boolean python_pass = Boolean.valueOf(false);
		Boolean python_env = Boolean.valueOf(false);
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
			writable_pass = work_path_check(work_space);
			if (python_pass && python_env && writable_pass) {
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
			ENV_CHECKER_LOGGER.warn("==Self Check failed==" + time_info.get_date_time());
			ENV_CHECKER_LOGGER.warn("Client Python Version:" + python_pass.toString());
			ENV_CHECKER_LOGGER.warn("Client Python Environ:" + python_env.toString());
			ENV_CHECKER_LOGGER.warn("Work Path Writable Check:" + writable_pass.toString());
			ENV_CHECKER_LOGGER.warn("Work Path:" + work_space);
			ENV_CHECKER_LOGGER.warn("");
			switch_info.set_client_environ_issue(true);
		} else {
			switch_info.set_client_environ_issue(false);
		}
	}

	private void remote_corescript_monitor() {
		String svn_path = new String(public_data.DEF_SVN_PATH);
		svn_path = client_info.get_client_tools_data().getOrDefault("svn", public_data.DEF_SVN_PATH);
		if(svn_version_check(svn_path) && remote_corescript_available(svn_path)) {
			switch_info.set_remote_corescript_linked(true);
		} else {
			switch_info.set_remote_corescript_linked(false);
		}
	}
	
	private Boolean svn_version_check(
			String svn_path
			) {
		File svn_fobj = new File(svn_path);
		if (!svn_fobj.exists()) {
			ENV_CHECKER_LOGGER.info("SVN doesn't exists:" + svn_path);
			return false;
		}
		String cur_ver = version_info.get_svn_version(svn_path);
		if (cur_ver.equals("unknown")) {
			ENV_CHECKER_LOGGER.warn("SVN version error: unknown version");
			return false;
		}
		String[] ver_array = cur_ver.split("\\.");
		String cur_ver_str = ver_array[0] + "." + ver_array[1];
		if (version_info.version_suitable_check(public_data.BASE_SVNBASEVERSION, cur_ver_str, null)) {
			return true;
		} else {
			ENV_CHECKER_LOGGER.warn("SVN version out of scope:" + cur_ver_str);
			return false;
		}
	}
	
	private Boolean remote_corescript_available(
			String svn_path){
		Boolean status = Boolean.valueOf(false);
		String core_addr = public_data.CORE_SCRIPT_REMOTE_URL;
		String svn_user = public_data.SVN_USER;
		String svn_pwd = public_data.SVN_PWD;
		String usr_cmd = new String(" --username=" + svn_user + " --password=" + svn_pwd + " --no-auth-cache");
		String work_space = client_info.get_client_preference_data().get("work_space");
		ArrayList<String> info_return = new ArrayList<String>();
        try {
            info_return.addAll(system_cmd.run(svn_path + " info " + core_addr + " " + usr_cmd, work_space));
        }catch (IOException e){
            e.printStackTrace();
        }
        Pattern patt = Pattern.compile(".+?:\\s+(\\d+)$");
        for (String line: info_return){
        	Matcher m = patt.matcher(line);
        	if(m.find()){
        		status = true;
        		break;
        	}
        }
        if (!status) {
        	ENV_CHECKER_LOGGER.warn("Remote Corescript not available.");
        }
        return status;
	}
	
	private void python_version_monitor() {
		String python_cmd = new String("");
		python_cmd = client_info.get_client_tools_data().getOrDefault("python", public_data.DEF_PYTHON_PATH);
		String cur_ver = version_info.get_python_version(python_cmd);
		switch_info.set_system_python_version(cur_ver);
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
		//Python version check
		python_version_monitor();
		//run environ check
		run_environ_monitor();
		//remote core link status check
		remote_corescript_monitor();
	}
	
	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		Timer my_timer = new Timer();
		my_timer.scheduleAtFixedRate(new env_checker(null,null), 1000, 5000);		
	}
}