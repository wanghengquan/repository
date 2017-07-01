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

import data_center.public_data;
import data_center.switch_data;
import utility_funcs.system_cmd;

public class self_check {
	// public property
	// protected property
	// private property
	private static final Logger SELF_CHECK_LOGGER = LogManager.getLogger(self_check.class.getName());
	// private String line_separator = System.getProperty("line.separator");
	private switch_data switch_info;
	// public function
	// protected function
	// private function

	public self_check(switch_data switch_info) {
		this.switch_info = switch_info;
	}
	
	private String get_python_version() {
		String cmd = "python --version ";
		// Python 2.7.2
		String raw_input = new String();
		String ver_str = new String("unknown");
		try {
			ArrayList<String> excute_retruns = system_cmd.run(cmd);
			raw_input = excute_retruns.get(1);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
		}
		Pattern version_patt = Pattern.compile("python\\s(\\d\\.\\d+.\\d+)", Pattern.CASE_INSENSITIVE);
		Matcher version_match = version_patt.matcher(raw_input);
		if (version_match.find()) {
			ver_str = version_match.group(1);
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
		String raw_input = "";
		String ver_str = "unknown";
		try {
			ArrayList<String> excute_retruns = system_cmd.run(cmd);
			raw_input = excute_retruns.get(1);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
		}
		Pattern version_patt = Pattern.compile("svn.+\\s+(\\d\\.\\d\\.\\d+)", Pattern.CASE_INSENSITIVE);
		Matcher version_match = version_patt.matcher(raw_input);
		if (version_match.find()) {
			ver_str = version_match.group(1);
		}
		return ver_str;
	}

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
			SELF_CHECK_LOGGER.error("Java version out of scope.");
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
			SELF_CHECK_LOGGER.error("python version out of scope.");
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
			SELF_CHECK_LOGGER.error("SVN version out of scope.");
			return false;
		}
	}
	
	public Boolean do_self_check() {
		Boolean check_result = new Boolean(false);
		Boolean java_pass = java_version_check();
		Boolean python_pass = python_version_check();
		Boolean svn_pass = svn_version_check();
		if (java_pass && python_pass && svn_pass) {
			switch_info.set_client_self_check(true);
			check_result = true;
		} else {
			SELF_CHECK_LOGGER.error("Self Check failed, System error out.");
			SELF_CHECK_LOGGER.error("Client JAVA version:" + get_java_version());
			SELF_CHECK_LOGGER.error("Client Python version:" + get_python_version());
			SELF_CHECK_LOGGER.error("Client SVN version:" + get_svn_version());
		}
		return check_result;
	}

	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		switch_data switch_info = new switch_data();
		self_check my_check = new self_check(switch_info);
		my_check.do_self_check();
	}
}