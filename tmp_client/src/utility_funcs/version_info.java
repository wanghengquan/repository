/*
 * File: data_check.java
 * Description: run system command line
 * Author: Jason.Wang
 * Date:2018/12/24
 * Modifier:
 * Date:
 * Description:
 */
package utility_funcs;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class version_info {
	private static final Logger VERSION_INFO_LOGGER = LogManager.getLogger(system_cmd.class.getName());
	
	public version_info() {

	}
	
	public static String get_python_version(
			String python_cmd
			) {
		String cmd = python_cmd + " --version ";
		// Python 2.7.2
		ArrayList<String> excute_retruns = new ArrayList<String>();
		String ver_str = new String("unknown");
		try {
			excute_retruns.addAll(system_cmd.run(cmd));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			VERSION_INFO_LOGGER.warn("Run command failed:" + cmd);
			VERSION_INFO_LOGGER.warn(e.toString());
			for(Object item: e.getStackTrace()){
				VERSION_INFO_LOGGER.warn(item.toString());
			}
		}
		Pattern version_patt = Pattern.compile("python\\s(\\d*\\.\\d*.\\d*)", Pattern.CASE_INSENSITIVE);
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
			VERSION_INFO_LOGGER.warn("Got unknown Python version. command returns:");
			for(String item: excute_retruns){
				VERSION_INFO_LOGGER.warn(item);
			}
		}
		return ver_str;
	}
	
	public static String get_java_version() {
		String ver_str = System.getProperty("java.version");
		return ver_str;
	}
	
	public static String get_svn_version(
			String svn_cmd
			) {
		String cmd = svn_cmd + " --version";
		// svn, version 1.6.11 (r934486)
		String ver_str = "unknown";
		ArrayList<String> excute_retruns = new ArrayList<String>();
		try {
			excute_retruns.addAll(system_cmd.run(cmd));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			VERSION_INFO_LOGGER.warn("Run command failed:" + cmd);
			VERSION_INFO_LOGGER.warn(e.toString());
			for(Object item: e.getStackTrace()){
				VERSION_INFO_LOGGER.warn(item.toString());
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
		if (ver_str.equals("unknown")){
			VERSION_INFO_LOGGER.warn("Got unknown SVN version. command returns:");
			for(String item: excute_retruns){
				VERSION_INFO_LOGGER.warn(item);
			}
		}		
		return ver_str;
	}
		
	public static Boolean version_suitable_check(
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
			VERSION_INFO_LOGGER.error("Min version error.");
			return ver_status;
		}
		if (cur_version == null || cur_version == "") {
			VERSION_INFO_LOGGER.error("Current version error.");
			return ver_status;
		}
		if (!min_version.contains(".")) {
			VERSION_INFO_LOGGER.error("Min version wrong format:" + min_version + ".");
			return ver_status;
		}		
		if (!cur_version.contains(".")) {
			VERSION_INFO_LOGGER.error("Current version wrong format:" + cur_version + ".");
			return ver_status;
		}
		if (max_version == null || max_version == "") {
			VERSION_INFO_LOGGER.info("Max version not given.");
		} else {
			if (!max_version.contains(".")) {
				VERSION_INFO_LOGGER.error("Max version wrong format:" + max_version + ".");
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
	
}