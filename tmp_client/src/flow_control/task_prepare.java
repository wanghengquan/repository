/*
 * File: cmd_parser.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package flow_control;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.io.FileUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.public_data;
import utility_funcs.des_decode;
import utility_funcs.file_action;
import utility_funcs.system_cmd;

public class task_prepare {
	// public property
	// protected property
	// private property
	private static final Logger CASE_PREPARE_LOGGER = LogManager.getLogger(task_prepare.class.getName());
	protected ArrayList<String> task_prepare_info = new ArrayList<String>();
	private String line_separator = System.getProperty("line.separator");
	private String file_seprator = System.getProperty("file.separator");
    
	public task_prepare() {
	}	
	
	protected Boolean get_task_case_ready(
			HashMap<String, String> client_tools,
			HashMap<String, HashMap<String, String>> task_data
			){
		Boolean task_path_ok = get_task_path_ready(task_data);
		Boolean case_path_ok = get_case_path_ready(client_tools, task_data);
		Boolean script_path_ok = get_script_path_ready(client_tools, task_data);
		if (task_path_ok && case_path_ok && script_path_ok){
			return true;
		} else {
			return false;
		}
	}	
	
	//create and writable
	protected Boolean get_task_path_ready(
			HashMap<String, HashMap<String, String>> task_data
			){
		task_prepare_info.add(">Prepare task path:");
		String task_path = task_data.get("Paths").get("task_path").trim();
		String case_mode = task_data.get("Preference").get("case_mode").trim();
		File task_path_dobj = new File(task_path);
		if (case_mode.equalsIgnoreCase("hold_case")){
			if (task_path_dobj.isDirectory() && task_path_dobj.canWrite()){
				task_prepare_info.add("Info : Task path prepare Pass:" + task_path);
				return true;
			} else {
				task_prepare_info.add("Error: Task path cannot write:" + task_path);
				return false;
			}
		}
		//Create new task path if not have
		synchronized (this.getClass()) {
			if (!task_path_dobj.exists()){
				try {
					FileUtils.forceMkdir(task_path_dobj);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					// e.printStackTrace();
					task_prepare_info.add("Error: Create task path Failed:" + task_path);
					CASE_PREPARE_LOGGER.warn("Create task path Failed:" + task_path);
					return false;
				}
			}
		}
		if (task_path_dobj.isDirectory() && task_path_dobj.canWrite()){
			task_prepare_info.add("Info : Task path prepare Pass:" + task_path);
			return true;
		} else {
			task_prepare_info.add("Error: Task path cannot write:" + task_path);
			return false;
		}	
	}
	
	protected Boolean get_case_path_ready(
			HashMap<String, String> client_tools,
			HashMap<String, HashMap<String, String>> task_data
			){
		task_prepare_info.add(line_separator + ">Prepare case path:");
		String source_url = task_data.get("Paths").get("design_url").trim();
		String case_path = task_data.get("Paths").get("case_path").trim();
		//String case_name = task_data.get("Paths").get("case_name").trim();
		String base_name = task_data.get("Paths").get("base_name").trim();
		String case_mode = task_data.get("Preference").get("case_mode").trim();
		String lazy_copy = task_data.get("Preference").get("lazy_copy").trim();	
		//step 1: skip flow if in hold case or lazy copy mode
		File case_path_dobj = new File(case_path);
		if (case_mode.equalsIgnoreCase("hold_case")){
			if (case_path_dobj.isDirectory() && case_path_dobj.canWrite()){
				task_prepare_info.add("Info : Case path prepare Pass:" + case_path);
				return true;
			} else {
				task_prepare_info.add("Error: Case path cannot write:" + case_path);
				return false;
			}
		}
		if (lazy_copy.equalsIgnoreCase("true") && case_path_dobj.exists()){
			task_prepare_info.add("Info : Lazy mode case path prepare Skipped:" + case_path);
			return true;
		}		
		//step 2: get user_passwd
		String user_passwd = new String("NA_+_NA");
		user_passwd = get_auth_key(task_data.get("CaseInfo").get("auth_key").trim());
		if (user_passwd.equals("") || !user_passwd.contains("_+_")) {
			task_prepare_info.add("Error : Wrong auth_key given, regenerate it with Client->Tools->Keygen");
			return false;
		}
		String user_name = user_passwd.split("_\\+_")[0];
		String pass_word = user_passwd.split("_\\+_")[1];		
		//step 3: get source version if have
		String source_version = new String("");
		if (task_data.get("CaseInfo").containsKey("version")){
			source_version = task_data.get("CaseInfo").get("version").trim();
		}
		//step 4: url/zip identify
		url_enum durl_type = get_url_type(source_url, "durl_type", task_data.get("CaseInfo"));
		zip_enum dzip_type = get_zip_type(source_url, "dzip_type", task_data.get("CaseInfo"));
		//step 5: remove existing case
		Boolean remove_ok = remove_exist_path(case_path, base_name);
		if (!remove_ok) {
			return false;
		}
		//step 6: get case parent path ready
		Boolean parent_ok = build_parent_path(case_path);
		if (!parent_ok) {
			return false;
		}
		//step 7: run source export
		Boolean export_ok = run_src_export(source_url, durl_type, dzip_type, source_version, user_name, pass_word, case_path, base_name, client_tools);
		if (!export_ok) {
			return false;
		}
		//step 8: run unzip if need
		Boolean unzip_ok = run_src_unzip(dzip_type, case_path, base_name);
		if (!unzip_ok) {
			return false;
		}
		return true;
	}
	
	protected Boolean get_script_path_ready(
			HashMap<String, String> client_tools,
			HashMap<String, HashMap<String, String>> task_data
			){
		task_prepare_info.add(line_separator + ">Prepare script path:");
		String script_url = task_data.get("Paths").get("script_url").trim();
		String script_path = task_data.get("Paths").get("script_path").trim();
		String script_base = task_data.get("Paths").get("script_base").trim();
		//String script_name = task_data.get("Paths").get("script_name").trim();
		String work_space = task_data.get("Paths").get("work_space").trim();
		String case_path = task_data.get("Paths").get("case_path").trim();
		String tool_path = public_data.TOOLS_ROOT_PATH;
		String case_mode = task_data.get("Preference").get("case_mode").trim();
		String keep_path = task_data.get("Preference").get("keep_path").trim();
		if (script_url == null || script_url.equals("")) {
			CASE_PREPARE_LOGGER.debug("Internal script used, no export needed.");
			task_prepare_info.add("Info : Internal script used, no export needed.");
			return true;
		}
		if(script_url.startsWith(work_space) || script_url.startsWith(case_path) || script_url.startsWith(tool_path)) {
			CASE_PREPARE_LOGGER.debug("Local script used, no export needed.");
			task_prepare_info.add("Info : Local script used, no export needed.");
			return true;
		}
		String lazy_copy = task_data.get("Preference").get("lazy_copy").trim();		
		File script_path_dobj = new File(script_path);
		if (lazy_copy.equalsIgnoreCase("true") && script_path_dobj.exists()){
			task_prepare_info.add("Info : Lazy mode script path prepare Skipped:" + case_path);
			return true;
		}		
		//step 1: get user_passwd
		String user_passwd = new String("NA_+_NA");
		user_passwd = get_auth_key(task_data.get("CaseInfo").get("auth_key").trim());
		if (user_passwd.equals("") || !user_passwd.contains("_+_")) {
			task_prepare_info.add("Error : Wrong auth_key given, regenerate it with Client->Tools->Keygen");
			return false;
		}
		String user_name = user_passwd.split("_\\+_")[0];
		String pass_word = user_passwd.split("_\\+_")[1];		
		//step 2: get source version if have
		String script_version = new String("");
		if (task_data.get("CaseInfo").containsKey("script_version")){
			script_version = task_data.get("CaseInfo").get("script_version").trim();
		}
		//step 3: url/zip identify
		url_enum surl_type = get_url_type(script_url, "surl_type", task_data.get("CaseInfo"));
		zip_enum szip_type = get_zip_type(script_url, "szip_type", task_data.get("CaseInfo"));
		//step 4: remove existing script
		if (case_mode.equals("hold_case") || keep_path.equals("true")) {
			task_prepare_info.add("Warning : hold_case/keep_path mode, skip existing script remove");
		} else {
			Boolean remove_ok = remove_exist_path(script_path, script_base);
			if (!remove_ok) {
				return false;
			}
		}
		//step 5: get case parent path ready
		Boolean parent_ok = build_parent_path(script_path);
		if (!parent_ok) {
			return false;
		}
		//step 6: run script export
		Boolean export_ok = run_src_export(
				script_url, surl_type, szip_type, script_version, user_name, pass_word, script_path, script_base, client_tools);
		if (!export_ok) {
			return false;
		}
		//step 7: run unzip if need
		Boolean unzip_ok = run_src_unzip(szip_type, script_path, script_base);
		if (!unzip_ok) {
			return false;
		}
		return true;
	}
	
	private String get_auth_key(String encrypt_string) {
		String user_passwd = new String("");
		try {
			user_passwd = des_decode.decrypt(encrypt_string, public_data.ENCRY_KEY);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			task_prepare_info.add("Error: Decode auth key failed.");
			CASE_PREPARE_LOGGER.error("Decode auth key failed.");
			return user_passwd;
		}
		return user_passwd;
	}
	
	private url_enum get_url_type(
			String url,
			String url_category,
			HashMap<String, String> task_caseinfo_data) {
		//task defined type
		if (task_caseinfo_data.containsKey(url_category)) {
			try {
				return url_enum.valueOf(task_caseinfo_data.get(url_category).toUpperCase());
			} catch (Exception e) {
				task_prepare_info.add("Error: Wrong user url type:" + task_caseinfo_data.get(url_category));
				CASE_PREPARE_LOGGER.error("Error: Wrong user url type:" + task_caseinfo_data.get(url_category));
			}			
		}
		//auto identify flow
		String[] url_array = url.split(":", 2);
		String host_str = url_array[0];
		if (url.contains(public_data.SVN_URL)) {
			return url_enum.SVN;
		}
		if (host_str.length() < 2 || url_array.length < 2) {
			////lsh-prince/sw/test_dir
			//D:/temp/regression_suite
			return url_enum.LOCAL;
		}
		if (host_str.equalsIgnoreCase(url_enum.HTTPS.toString())) {
			return url_enum.HTTPS;
		}
		if (host_str.equalsIgnoreCase(url_enum.HTTP.toString())) {
			return url_enum.HTTP;
		}
		if (host_str.equalsIgnoreCase(url_enum.FTP.toString())) {
			return url_enum.FTP;
		}	
		return url_enum.REMOTE;
	}
	
	private zip_enum get_zip_type(
			String url,
			String zip_category,
			HashMap<String, String> task_caseinfo_data) {
		//task defined type
		if (task_caseinfo_data.containsKey(zip_category)) {
			try {
				return zip_enum.valueOf(task_caseinfo_data.get(zip_category).toUpperCase());
			} catch (Exception e) {
				task_prepare_info.add("Error: Wrong user zip type:" + task_caseinfo_data.get(zip_category));
				CASE_PREPARE_LOGGER.error("Error: Wrong user zip type:" + task_caseinfo_data.get(zip_category));
			}			
		}
		//auto identify flow
		String[] url_array = url.split("/");
		String basename = url_array[url_array.length - 1];
		if (!basename.contains(".")) {
			return zip_enum.NO;
		}
		if (basename.contains(zip_enum.TARGZ.get_description())) {
			return zip_enum.TARGZ;
		}
		if (basename.contains(zip_enum.TARBZ.get_description())) {
			return zip_enum.TARBZ;
		}
		if (basename.contains(zip_enum.TARBZ2.get_description())) {
			return zip_enum.TARBZ2;
		}
		if (basename.contains(zip_enum.SEVENZ.get_description())) {
			return zip_enum.SEVENZ;
		}
		if (basename.contains(zip_enum.BZ2.get_description())) {
			return zip_enum.BZ2;
		}
		if (basename.contains(zip_enum.BZIP2.get_description())) {
			return zip_enum.BZIP2;
		}
		if (basename.contains(zip_enum.TBZ2.get_description())) {
			return zip_enum.TBZ2;
		}
		if (basename.contains(zip_enum.TBZ.get_description())) {
			return zip_enum.TBZ;
		}
		if (basename.contains(zip_enum.GZ.get_description())) {
			return zip_enum.GZ;
		}		
		if (basename.contains(zip_enum.GZIP.get_description())) {
			return zip_enum.GZIP;
		}		
		if (basename.contains(zip_enum.TGZ.get_description())) {
			return zip_enum.TGZ;
		}
		if (basename.contains(zip_enum.TAR.get_description())) {
			return zip_enum.TAR;
		}		
		if (basename.contains(zip_enum.ZIP.get_description())) {
			return zip_enum.ZIP;
		}			
		return zip_enum.UNKNOWN;
	}	
	
	private Boolean remove_exist_path(
			String case_path,
			String base_name) {
		File case_path_dobj = new File(case_path);
		File case_parent_path = case_path_dobj.getParentFile();
		File zip_case_fobj = new File(case_parent_path.getAbsolutePath() + "/" + base_name);
		synchronized (this.getClass()) {
			//delete ori design
			if (case_path_dobj.exists()){
				if(FileUtils.deleteQuietly(case_path_dobj)){
					task_prepare_info.add("Info : Previously directory remove Pass:" + case_path);
					CASE_PREPARE_LOGGER.debug("Previously directory remove Pass:" + case_path);
				} else {
					task_prepare_info.add("Error: Previously directory remove Fail:" + case_path);
					CASE_PREPARE_LOGGER.warn("Previously directory remove Fail:" + case_path);
					return false;
				}
			}
			//delete ori zipped file
			if (zip_case_fobj.exists()){
				if(FileUtils.deleteQuietly(zip_case_fobj)){
					task_prepare_info.add("Info : Previously file remove Pass:" + case_path);
					CASE_PREPARE_LOGGER.debug("Previously file remove Pass:" + case_path);
				} else {
					task_prepare_info.add("Error: Previously file remove Fail:" + case_path);
					CASE_PREPARE_LOGGER.warn("Previously file remove Fail:" + case_path);
					return false;
				}
			}
			//delete ori log file
			file_action.del_file_match_extension(case_parent_path.getAbsolutePath(), ".txt");
			file_action.del_file_match_extension(case_parent_path.getAbsolutePath(), ".log");
			file_action.del_file_match_extension(case_parent_path.getAbsolutePath(), ".csv");	
		}
		return true;
	}	
	
	private Boolean build_parent_path(
			String case_path) {
		File case_path_dobj = new File(case_path);
		synchronized (this.getClass()) {
			// prepare export dir
			File case_parent_path = case_path_dobj.getParentFile();
			if (!case_parent_path.exists()){
				try {
					FileUtils.forceMkdir(case_parent_path);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					// e.printStackTrace();
					task_prepare_info.add("Error: Prepare parent path Fail:" + case_parent_path.getAbsolutePath());
					CASE_PREPARE_LOGGER.error("Prepare parent path Fail:" + case_parent_path.getAbsolutePath());
					return false;
				}
			}	
		}
		return true;
	}
	
	private Boolean run_src_unzip(
		zip_enum dzip_type,
		String case_path,
		String base_name){
		ArrayList<String> cmd_array = new ArrayList<String>();
		String case_parent_path = case_path.substring(0, case_path.lastIndexOf("/"));
		//step 1:check source
		task_prepare_info.add(">Unzip Task case with CMD(s):");		
		if(dzip_type.equals(zip_enum.NO)) {
			task_prepare_info.add(">Source found, no extract needed.");
			return true;
		}
		if(dzip_type.equals(zip_enum.UNKNOWN)) {
			task_prepare_info.add(">Source considered, no extract needed.");
			return true;
		}
		//step 2:get unzip command
		switch (dzip_type) {	
		case SEVENZ:
			cmd_array.add(get_7z_cmd_str(base_name));
			break;
		case BZ2:
			cmd_array.add(get_bzip2_cmd_str(base_name));
			break;
		case BZIP2:
			cmd_array.add(get_bzip2_cmd_str(base_name));
			break;
		case TBZ2:
			cmd_array.addAll(get_tar_bzip2_cmd_str(base_name));
			break;
		case TBZ:
			cmd_array.addAll(get_tar_bzip2_cmd_str(base_name));
			break;
		case GZ:
			cmd_array.add(get_gzip_cmd_str(base_name));
			break;
		case GZIP:
			cmd_array.add(get_gzip_cmd_str(base_name));
			break;			
		case TGZ:
			cmd_array.addAll(get_tar_gzip_cmd_str(base_name));
			break;
		case TAR:
			cmd_array.add(get_tar_cmd_str(base_name));
			break;
		case ZIP:
			cmd_array.add(get_zip_cmd_str(base_name));
			break;
		case TARGZ:
			cmd_array.addAll(get_tar_gzip_cmd_str(base_name));
			break;
		case TARBZ:
			cmd_array.addAll(get_tar_bzip2_cmd_str(base_name));
			break;
		case TARBZ2:
			cmd_array.addAll(get_tar_bzip2_cmd_str(base_name));
			break;		
		default:
			break;
		}
		//step 3:command lines check
		if (cmd_array.isEmpty()) {
			task_prepare_info.add("Warning : No unzip command found for given source:" + base_name);
			return false;
		}
		task_prepare_info.addAll(cmd_array);
		task_prepare_info.add("Work Path:" + case_parent_path);
		//step 4:unzip commands run check
		Boolean run_ok = run_common_cmds(cmd_array, case_parent_path);
		if (!run_ok) {
			return false;
		}
		//step 5: final case path check
		File case_path_dobj = new File(case_path);
		if (!case_path_dobj.exists()) {
			task_prepare_info.add("Error: Case path do not exists:" + case_path);
			return false;
		}
		return true;
	}	
	
	private String get_7z_cmd_str(
			String base_name) {
		StringBuilder exe_cmd = new StringBuilder("");
		String os_type = System.getProperty("os.name").toLowerCase();
		//Step1: cmd_str 
		String cmd_str = new String("");
		if(os_type.startsWith("windows")){
			cmd_str = public_data.TOOLS_7ZA;
		} else {
			task_prepare_info.add("Error: .7z file do not supported on Linux side.");
			return exe_cmd.toString();
		}
		exe_cmd.append(cmd_str);
		exe_cmd.append(" ");
		exe_cmd.append("x -y");
		exe_cmd.append(" ");
		exe_cmd.append(base_name);
		return exe_cmd.toString();
	}
	
	private String get_bzip2_cmd_str(
			String base_name) {
		StringBuilder exe_cmd = new StringBuilder("");
		String os_type = System.getProperty("os.name").toLowerCase();
		//Step1: cmd_str 
		String cmd_str = new String("");
		if(os_type.startsWith("windows")){
			cmd_str = public_data.TOOLS_7ZA;
		} else {
			cmd_str = "bunzip2";
		}		
		//Step2: option_str 
		String option_str = new String("");
		if(os_type.startsWith("windows")){
			option_str = "x -y";
		} else {
			option_str = "-f";
		}
		//
		exe_cmd.append(cmd_str);
		exe_cmd.append(" ");
		exe_cmd.append(option_str);
		exe_cmd.append(" ");
		exe_cmd.append(base_name);
		return exe_cmd.toString();
	}	
	
	private ArrayList<String> get_tar_bzip2_cmd_str(
			String base_name) {
		ArrayList<String> cmd_list = new ArrayList<String>();
		String os_type = System.getProperty("os.name").toLowerCase();
		//Step1: cmd_str 
		if(os_type.startsWith("windows")){
			cmd_list.add(public_data.TOOLS_7ZA + " x -y " + base_name);
			cmd_list.add(public_data.TOOLS_7ZA + " x -y " + base_name.split("\\.")[0] + ".tar");
		} else {
			cmd_list.add("tar -xj -f " + base_name);
		}
		return cmd_list;
	}	
	
	private String get_gzip_cmd_str(
			String base_name) {
		StringBuilder exe_cmd = new StringBuilder("");
		String os_type = System.getProperty("os.name").toLowerCase();
		//Step1: cmd_str 
		String cmd_str = new String("");
		if(os_type.startsWith("windows")){
			cmd_str = public_data.TOOLS_7ZA;
		} else {
			cmd_str = "gunzip";
		}		
		//Step2: option_str 
		String option_str = new String("");
		if(os_type.startsWith("windows")){
			option_str = "x -y";
		} else {
			option_str = "-f";
		}
		//
		exe_cmd.append(cmd_str);
		exe_cmd.append(" ");
		exe_cmd.append(option_str);
		exe_cmd.append(" ");
		exe_cmd.append(base_name);
		return exe_cmd.toString();
	}	
	
	private ArrayList<String> get_tar_gzip_cmd_str(
			String base_name) {
		ArrayList<String> cmd_list = new ArrayList<String>();
		String os_type = System.getProperty("os.name").toLowerCase();
		//Step1: cmd_str 
		if(os_type.startsWith("windows")){
			cmd_list.add(public_data.TOOLS_7ZA + " x -y " + base_name);
			cmd_list.add(public_data.TOOLS_7ZA + " x -y " + base_name.split("\\.")[0] + ".tar");
		} else {
			cmd_list.add("tar -xz -f " + base_name);
		}
		return cmd_list;
	}
	
	private String get_tar_cmd_str(
			String base_name) {
		StringBuilder exe_cmd = new StringBuilder("");
		String os_type = System.getProperty("os.name").toLowerCase();
		//Step1: cmd_str 
		String cmd_str = new String("");
		if(os_type.startsWith("windows")){
			cmd_str = public_data.TOOLS_7ZA;
		} else {
			cmd_str = "tar";
		}		
		//Step2: option_str 
		String option_str = new String("");
		if(os_type.startsWith("windows")){
			option_str = "x -y";
		} else {
			option_str = "-x -f";
		}
		//
		exe_cmd.append(cmd_str);
		exe_cmd.append(" ");
		exe_cmd.append(option_str);
		exe_cmd.append(" ");
		exe_cmd.append(base_name);
		return exe_cmd.toString();
	}

	private String get_zip_cmd_str(
			String base_name) {
		StringBuilder exe_cmd = new StringBuilder("");
		String os_type = System.getProperty("os.name").toLowerCase();
		//Step1: cmd_str 
		String cmd_str = new String("");
		if(os_type.startsWith("windows")){
			cmd_str = public_data.TOOLS_7ZA;
		} else {
			cmd_str = "unzip";
		}		
		//Step2: option_str 
		String option_str = new String("");
		if(os_type.startsWith("windows")){
			option_str = "x -y";
		} else {
			option_str = "-o -q";
		}
		//
		exe_cmd.append(cmd_str);
		exe_cmd.append(" ");
		exe_cmd.append(option_str);
		exe_cmd.append(" ");
		exe_cmd.append(base_name);
		return exe_cmd.toString();
	}
	
	private Boolean run_src_export(
			String case_url,
			url_enum url_type,
			zip_enum zip_type,
			String ver_number,
			String user_name, 
			String pass_word, 
			String case_path,
			String base_name,
			HashMap<String, String> client_tools) {
		ArrayList<String> cmd_array = new ArrayList<String>();
		switch (url_type) {
		case SVN:
			String svn_cmd = new String(client_tools.getOrDefault("svn", public_data.DEF_SVN_PATH));
			cmd_array.add(get_svn_cmd_str(svn_cmd, case_url, zip_type, ver_number, user_name, pass_word, case_path, base_name));
			break;
		case HTTPS:
			cmd_array.add(get_https_cmd_str(case_url, zip_type, case_path, base_name));
			break;
		case HTTP:
			cmd_array.add(get_http_cmd_str(case_url, zip_type, user_name, pass_word, case_path, base_name));
			break;
		case FTP:
			cmd_array.add(get_ftp_cmd_str(case_url, zip_type, user_name, pass_word, case_path));
			break;
		case REMOTE:
			cmd_array.add(get_remote_cmd_str(case_url, zip_type, user_name, pass_word, case_path));
			break;
		case LOCAL:
			cmd_array.add(get_local_cmd_str(case_url, case_path));
			break;	
		default:
			break;
		} 
		task_prepare_info.add(">Export Task case with CMD(s):");
		task_prepare_info.addAll(cmd_array);
		Boolean export_ok = run_common_cmds(cmd_array, System.getProperty("user.dir"));
		return export_ok;
	}
    
	private String get_svn_cmd_str(
			String svn_cmd,
			String case_url,
			zip_enum zip_type,
			String ver_number,
			String user_name, 
			String pass_word,
			String case_path,
			String base_name) {
		StringBuilder exe_cmd = new StringBuilder();
		String case_parent_path = case_path.substring(0, case_path.lastIndexOf("/"));
		//get export command
		String cmd_str = new String("");
		if (ver_number.length() > 0){
			cmd_str = svn_cmd + " export -r " + ver_number;
		} else {
			cmd_str = svn_cmd + " export";
		}
		//get export path
		String export_path = new String("");
		if (zip_type.equals(zip_enum.NO)) {
			export_path = case_path;
		} else {
			export_path = case_parent_path + "/" + base_name;
		}
		//generate command
		exe_cmd.append(cmd_str);
		exe_cmd.append(" ");
		exe_cmd.append(case_url);
		exe_cmd.append(" ");
		exe_cmd.append(export_path);
		exe_cmd.append(" --username=");
		exe_cmd.append(user_name);
		exe_cmd.append(" --password=");
		exe_cmd.append(pass_word);
		exe_cmd.append(" --no-auth-cache --force");
		return exe_cmd.toString();
	}
	
	private String get_https_cmd_str(
			String case_url,
			zip_enum zip_type,
			String case_path,
			String base_name) {
		StringBuilder exe_cmd = new StringBuilder();
		String os_type = System.getProperty("os.name").toLowerCase();
		String case_parent_path = case_path.substring(0, case_path.lastIndexOf("/"));		
		//Step1: cmd_str 
		String cmd_str = new String("");
		if(os_type.startsWith("windows")){
			cmd_str = public_data.TOOLS_WGET;
		} else {
			cmd_str = "wget";
		}
		//Step2: export path
		String export_path = new String(case_parent_path);
		//==
		//Stepx:command build start	
		exe_cmd.append(cmd_str);
		exe_cmd.append(" ");
		exe_cmd.append(case_url);
		exe_cmd.append(" -P ");
		exe_cmd.append(export_path);
		exe_cmd.append(" ");
		exe_cmd.append("--no-check-certificate");
		return exe_cmd.toString();
	}
	
	private String get_http_cmd_str(
			String case_url,
			zip_enum zip_type,
			String user_name, 
			String pass_word,
			String case_path,
			String base_name) {
		StringBuilder exe_cmd = new StringBuilder();
		String os_type = System.getProperty("os.name").toLowerCase();
		String case_parent_path = case_path.substring(0, case_path.lastIndexOf("/"));		
		//Step1: cmd_str 
		String cmd_str = new String("");
		if(os_type.startsWith("windows")){
			cmd_str = public_data.TOOLS_WGET;
		} else {
			cmd_str = "wget";
		}
		//Step2: export path
		String export_path = new String("");
		if(zip_type.equals(zip_enum.NO)){
			export_path = case_path;
		} else {
			export_path = case_parent_path + "/" + base_name;
		}
		//Step3: account string
		String account_str = new String(" --http-user=" + user_name + "  --http-password=" + pass_word + " ");
		//==
		//Stepx:command build start	
		exe_cmd.append(cmd_str);
		exe_cmd.append(" ");
		exe_cmd.append(case_url);
		exe_cmd.append(" -P ");
		exe_cmd.append(export_path);
		exe_cmd.append(" ");
		exe_cmd.append(account_str);
		return exe_cmd.toString();
	}
	
	private String get_ftp_cmd_str(
			String case_url,
			zip_enum zip_type,
			String user_name, 
			String pass_word,
			String case_path) {
		StringBuilder exe_cmd = new StringBuilder();
		String os_type = System.getProperty("os.name").toLowerCase();
		String case_parent_path = case_path.substring(0, case_path.lastIndexOf("/"));		
		//Step1: cmd_str 
		String cmd_str = new String("");
		if(os_type.startsWith("windows")){
			cmd_str = public_data.TOOLS_WGET;
		} else {
			cmd_str = "wget";
		}
		//Step2: cut_depth counting. 3 remove the depth of ftp://shitl0012, 1 for last design name	
		int cut_depth = case_url.split("/").length - 3 - 1;
		//Step3: export path
		String export_path = new String(case_parent_path);
		//Step4: account string
		String account_str = new String("");
		if (user_name.equals(public_data.FTP_USER)){
			account_str = ""; //default user means login with anonymous account (public_data.FTP_USER == anonymous)
		} else {
			account_str = " --ftp-user=" + user_name + "  --ftp-password=" + pass_word + " ";
		}		
		//==
		//Stepx:command build start	
		exe_cmd.append(cmd_str);
		exe_cmd.append(" ");
		exe_cmd.append(case_url);
		exe_cmd.append(" ");
		exe_cmd.append("-r -q -nH --cut-dirs=" + String.valueOf(cut_depth) + " -P");
		exe_cmd.append(" ");
		exe_cmd.append(export_path);
		exe_cmd.append(" ");
		exe_cmd.append(account_str);
		return exe_cmd.toString();
	}	
	
	private String get_remote_cmd_str(
			String case_url,
			zip_enum zip_type,
			String user_name, 
			String pass_word,
			String case_path) {
		String remote_cmd = new String();
		String os_type = System.getProperty("os.name").toLowerCase();
		String[] url_array = case_url.split(":", 2);
		if(os_type.startsWith("windows")){
			if (url_array[1].startsWith("/")) {
				//windows client, Linux repository/source
				remote_cmd = get_remote_cmd_winc_lins(case_url, zip_type, user_name, pass_word, case_path);
			} else {
				//windows client, Windows repository/source
				remote_cmd = get_remote_cmd_winc_wins(case_url, zip_type, user_name, pass_word, case_path);
			}
		} else {
			//Linux client
			remote_cmd = get_remote_cmd_linc(case_url, zip_type, user_name, pass_word, case_path);
		}
		return remote_cmd;
	}	
	
	private String get_remote_cmd_winc_lins(
			String case_url,
			zip_enum zip_type,
			String user_name, 
			String pass_word,
			String case_path) {
		StringBuilder exe_cmd = new StringBuilder();
		String case_parent_path = case_path.substring(0, case_path.lastIndexOf("/"));
        // win client Lin source
		// pscp -r -p -l jwang1 -pw lattice1 lsh-comedy:/public/jason_test c:/users/jwang1/Desktop
		//Step1: cmd_str 
		String cmd_str = new String(public_data.TOOLS_PSCP);
		//Step2: export path
		String export_path = new String("");
		if(zip_type.equals(zip_enum.NO)){
			export_path = case_path;
		} else {
			export_path = case_parent_path;
		}		
		//Step3: account string	
		//==
		//Stepx:command build start	
		exe_cmd.append(cmd_str);
		exe_cmd.append(" ");
		exe_cmd.append("-r -p -batch -l " + user_name + " -pw " + pass_word);
		exe_cmd.append(" ");
		exe_cmd.append(case_url);
		exe_cmd.append(" ");
		exe_cmd.append(export_path);
		return exe_cmd.toString();		
	}
	
	private String get_remote_cmd_winc_wins(
			String case_url,
			zip_enum zip_type,
			String user_name, 
			String pass_word,
			String case_path) {
		StringBuilder exe_cmd = new StringBuilder();
		String case_parent_path = case_path.substring(0, case_path.lastIndexOf("/"));
		String[] url_array = case_url.split(":", 2);
        // win client win source
		// D25970:D:/test_dir
		// xcopy \\D25970\D$\auto_install.bat c:\\user\jwang1\Desktop  /E /Y /A
		//Step1: cmd_str 
		String cmd_str = new String("xcopy");
		//Step2: export path
		String export_path = new String("");
		if(zip_type.equals(zip_enum.NO)){
			export_path = case_path;
		} else {
			export_path = case_parent_path;
		}		
		//Step3: option string
		String option_str = new String("");
		if(zip_type.equals(zip_enum.NO)){
			option_str = " /E /Y /A /I ";	
		} else {
			option_str = " /Y /A";
		}
		//==
		//Stepx:command build start	
		exe_cmd.append(cmd_str);
		exe_cmd.append(" ");
		exe_cmd.append("\\\\" + url_array[0] + "\\" +url_array[1].replaceFirst(":", "\\$").replace("/", "\\"));
		exe_cmd.append(" ");
		exe_cmd.append(export_path.replace("/", "\\"));
		exe_cmd.append(" ");
		exe_cmd.append(option_str);
		return exe_cmd.toString();		
	}	
	
	private String get_remote_cmd_linc(
			String case_url,
			zip_enum zip_type,
			String user_name, 
			String pass_word,
			String case_path) {
		StringBuilder exe_cmd = new StringBuilder();
		String case_parent_path = case_path.substring(0, case_path.lastIndexOf("/"));
        // win client Lin source
		// pscp -r -p -l jwang1 -pw lattice1 lsh-comedy:/public/jason_test c:/users/jwang1/Desktop
		//Step1: cmd_str 
		String cmd_str = new String(public_data.TOOLS_SSHPASS);
		//Step2: export path
		String export_path = new String("");
		if(zip_type.equals(zip_enum.NO)){
			export_path = case_path;
		} else {
			export_path = case_parent_path;
		}	
		//==
		//Stepx:command build start	
		exe_cmd.append(cmd_str);
		exe_cmd.append(" ");
		exe_cmd.append(" -p " + pass_word + " scp -r -p ");
		exe_cmd.append(" ");
		exe_cmd.append(user_name + "@" + case_url);
		exe_cmd.append(" ");
		exe_cmd.append(export_path);
		return exe_cmd.toString();		
	}	
	
	private String get_local_cmd_str(
			String case_url,
			String case_path) {
		StringBuilder exe_cmd = new StringBuilder();
		String case_parent_path = case_path.substring(0, case_path.lastIndexOf("/"));
		String os_type = System.getProperty("os.name").toLowerCase();
		//Step1: cmd_str 
		String cmd_str = new String("");
		if(os_type.startsWith("windows")){
			cmd_str = public_data.TOOLS_CP;
		} else {
			cmd_str = "cp";
		}
		//generate command
		exe_cmd.append(cmd_str);
		exe_cmd.append(" ");
		exe_cmd.append("-r -p");
		exe_cmd.append(" ");
		exe_cmd.append(case_url);
		exe_cmd.append(" ");
		exe_cmd.append(case_parent_path);
		return exe_cmd.toString();
	}
	
	private Boolean run_common_cmds(
			ArrayList<String> export_cmd_list,
			String work_path) {
		synchronized (this.getClass()) {
			// export design
			for (String run_cmd : export_cmd_list) {
				try {
					task_prepare_info.addAll(system_cmd.run(run_cmd, work_path));
				} catch (Exception e) {
					// e.printStackTrace();
					task_prepare_info.add("Error: Run cmd Fail:" + run_cmd);
					CASE_PREPARE_LOGGER.error("Run cmd Fail:" + run_cmd);
					return false;
				}
			}
		}
		return true;
	}
	
	protected TreeMap<String, HashMap<cmd_attr, List<String>>> get_launch_commands(
			String python_version,
			Boolean corescript_link_status,
			HashMap<String, String> client_tools,
			HashMap<String, HashMap<String, String>> task_data,
			HashMap<String, HashMap<String, String>> client_data
			) {
		task_prepare_info.add(line_separator + ">Prepare Launch CMDs(LCs):");
		TreeMap<String, HashMap<cmd_attr, List<String>>> launch_cmds = new TreeMap<String, HashMap<cmd_attr, List<String>>>(new cmdid_compare());
		Iterator<String> option_it  = task_data.get("LaunchCommand").keySet().iterator();
		while (option_it.hasNext()) {
			String option_name = option_it.next();
			if(!option_name.startsWith("cmd_") && !option_name.equalsIgnoreCase("cmd")) {
				continue;
			}
			//job command line prepare
			HashMap<cmd_attr, List<String>> cmd_data = new HashMap<cmd_attr, List<String>>();
			String cmd_string  = new String(task_data.get("LaunchCommand").get(option_name));
			cmd_data.put(cmd_attr.command, Arrays.asList(get_launch_cmd(cmd_string, python_version, corescript_link_status, client_tools, task_data)));
			//job environment prepare
			HashMap<String, String> cmd_env = new HashMap<String, String>();
			cmd_env.putAll(get_launch_env(option_name, python_version, corescript_link_status, task_data, client_data));
			if(cmd_env.getOrDefault("FORCE_" + option_name.toUpperCase(), "NA").equals("0")) {
				task_prepare_info.add("Warning:ENV command force off, skip command:" + option_name);
				task_prepare_info.add("FORCE_" + option_name + ":0");
				task_prepare_info.add("");
				continue;
			}
			List<String> env_array = new ArrayList<String>();
			Iterator<String> env_it = cmd_env.keySet().iterator();
			while(env_it.hasNext()) {
				String env_key = env_it.next();
				String env_value = cmd_env.get(env_key);
				env_array.add(env_key + "=" + env_value);
			}
			cmd_data.put(cmd_attr.environ, env_array);
			//job software depends prepare
			List<String> sws_array = new ArrayList<String>();
			sws_array.addAll(get_tool_software_depends(option_name, task_data, client_data).keySet());
			cmd_data.put(cmd_attr.deptool, sws_array);
			//job run control prepare
			List<String> ctl_array = new ArrayList<String>();
			String ctl_string = new String(task_data.get("LaunchCommand").getOrDefault("exe_ctrl", "").trim());
			for(String ctl_item: ctl_string.split("\\s*,\\s*")) {
				if(ctl_item.contains("?" + option_name)) {
					ctl_array.add(ctl_item.replaceAll("\\?" + option_name, ""));
				}
			}
			cmd_data.put(cmd_attr.exectrl, ctl_array);
			launch_cmds.put(option_name, cmd_data);
		}
		//Sanity check for multiple commands mode
		if (launch_cmds.size() > 1 && launch_cmds.containsKey("cmd")) {
			task_prepare_info.add("Warning:Multiple command lines found, skip 'cmd' run.");
			task_prepare_info.add("");
			launch_cmds.remove("cmd");
		}
		//Show details
		Iterator<String> cmd_it = launch_cmds.keySet().iterator();
		while (cmd_it.hasNext()) {
			String cmd_index = cmd_it.next();
			task_prepare_info.add(">LC" + ":" + cmd_index);
			task_prepare_info.add("exectrl:" + launch_cmds.get(cmd_index).get(cmd_attr.exectrl).toString());
			task_prepare_info.add("environ:" + launch_cmds.get(cmd_index).get(cmd_attr.environ).toString());
			task_prepare_info.add("command:" + String.join(" ", launch_cmds.get(cmd_index).get(cmd_attr.command)));
			task_prepare_info.add("deptool:" + launch_cmds.get(cmd_index).get(cmd_attr.deptool).toString());
			task_prepare_info.add("");
		}
		return launch_cmds;
	}

	protected String[] get_launch_cmd(
			String cmd_string,
			String python_version,
			Boolean corescript_link_status,
			HashMap<String, String> client_tools,
			HashMap<String, HashMap<String, String>> task_data
			) {
		String launch_cmd = cmd_string.trim().replaceAll("\\\\", "/");
		String launch_path = task_data.get("Paths").get("launch_path").trim();
		String work_space = task_data.get("Paths").get("work_space").trim();
		String case_path = task_data.get("Paths").get("case_path").trim();
		String case_name = task_data.get("Paths").get("case_name").trim();
		String task_name = "T" + task_data.get("ID").get("id_index").trim();
		//String base_name = task_data.get("Paths").get("base_name").trim();
		String design_path = new String("");
		String tmp_str = new String(public_data.INTERNAL_STRING_BLANKSPACE);
		String case_parent_path = case_path.substring(0, case_path.lastIndexOf("/"));
		design_path = new File(launch_path).toURI().relativize(new File(case_path).toURI()).getPath();
		launch_cmd = launch_cmd.replaceAll("\\$work_path", " " + work_space);
		launch_cmd = launch_cmd.replaceAll("\\$case_path", " " + case_path);
		launch_cmd = launch_cmd.replaceAll("\\$tool_path", " " + public_data.TOOLS_ROOT_PATH);		
		//step 1: update command line tool path
		for (String tool:client_tools.keySet()) {
			Pattern tool_patt = Pattern.compile(String.format("^\\s*(%s)\\s", tool), Pattern.CASE_INSENSITIVE);
			Matcher tool_match = tool_patt.matcher(launch_cmd);
			if (tool_match.find()){
				//update tool to abs path
				//remove tool .exe to avoid future impacting in exe_patt replacing
				launch_cmd = tool_match.replaceFirst(client_tools.get(tool).replace(".exe", "") + " ");
			}
		}
		//step 2: update launch command command path
		Pattern exe_patt = Pattern.compile("(?:^|\\s)(\\S*\\.(?:pl|py|rb|jar|class|bat|exe|sh|csh|bash))", Pattern.CASE_INSENSITIVE);
		Matcher exe_match = exe_patt.matcher(launch_cmd);
		String exe_path = new String("");
		if (exe_match.find()){
			exe_path = exe_match.group().trim();
		} else {
			task_prepare_info.add("No executable program found for command:" + launch_cmd);
			task_prepare_info.add("Supported exe file type:pl,py,rb,jar,class,bat,exe,sh,csh,bash");
			task_prepare_info.add("");
			return launch_cmd.split(" ", 2);
		}
		Boolean abs_path_ok = Boolean.valueOf(false);
		Boolean ref_path_ok = Boolean.valueOf(false);
		Boolean par_path_ok = Boolean.valueOf(false);
		//abs path
		File exe1_fobj = new File(exe_path);
		if (exe1_fobj.exists() && exe1_fobj.isAbsolute()){
			abs_path_ok = true;
		}
		//ref path 1
		File exe2_fobj = new File(launch_path + "/" + exe_path);
		if (exe2_fobj.exists()){
			ref_path_ok = true;
		}
		//parent path 2
		File exe3_fobj = new File(case_parent_path + "/" + exe_path);
		if (exe3_fobj.exists()){
			launch_cmd = exe_match.replaceFirst(" " + case_parent_path + "/" + exe_path);
			par_path_ok = true;
		}		
		if (!abs_path_ok && !ref_path_ok && !par_path_ok){
			String corescript_path = new String("");
			if (python_version.startsWith("2")) {
				corescript_path = public_data.LOCAL_CORE_SCRIPT_DIR2;
			} else if (python_version.startsWith("3")) {
				if(corescript_link_status) {
					corescript_path = public_data.REMOTE_CORE_SCRIPT_DIR.replaceAll("\\$work_path", " " + work_space);
				} else {
					corescript_path = public_data.LOCAL_CORE_SCRIPT_DIR3;
				}
			} else {
				corescript_path = public_data.LOCAL_CORE_SCRIPT_DIR3;
			}
			launch_cmd = exe_match.replaceFirst(" " + corescript_path.replace(public_data.CORE_SCRIPT_NAME, "") + exe_path);
		}
		//step 3: update launch command design path(if have)
		Pattern src_patt = Pattern.compile("(?:=|\\s)(" + case_name + ")\\s");
		Matcher src_match = src_patt.matcher(launch_cmd);
		String src_path = new String("");
		if (src_match.find()) {
			src_path = src_match.group().trim();
			//case in launch path
			File src_fobj1 = new File(launch_path + "/" + src_path);
			if (src_fobj1.exists()){
				launch_cmd = src_match.replaceFirst(launch_path + "/" + src_path);
			}
			//case in case parent path
			File src_fobj2 = new File(case_parent_path + "/" + src_path);
			if (src_fobj2.exists()){
				launch_cmd = src_match.replaceFirst(case_parent_path + "/" + src_path);
			}		
		}
		//step 4: replace blank space in ""
		// python --option1="test1  test2   test3" -o "test1   test3" --test
		Pattern patt2 = Pattern.compile("\\s(\\S+?)?\".+?\"", Pattern.CASE_INSENSITIVE);
		Matcher match2 = patt2.matcher(launch_cmd);
		while(match2.find()){
			String match_str = new String(match2.group().trim());
            launch_cmd = launch_cmd.replace(match_str, match_str.replaceAll("\\s+", tmp_str)
                    .replaceAll("\"", ""));
        }
		// python --option1="test1@@@test2@@@test3" -o "test1@@@test3" --test
		//step 5: add default --design option for Core scripts
		String[] cmd_list = null;
		if (launch_path.equalsIgnoreCase(case_path))
			cmd_list = launch_cmd.split("\\s+");
		else if (launch_cmd.contains("run_lattice.py"))
			cmd_list = (launch_cmd + " --design=" + design_path + " --test-id=" + task_name).split("\\s+");
		else if (launch_cmd.contains("run_icecube.py"))
			cmd_list = (launch_cmd + " --design=" + design_path + " --test-id=" + task_name).split("\\s+");
		else if (launch_cmd.contains("run_diamond.py"))
			cmd_list = (launch_cmd + " --design=" + design_path + " --test-id=" + task_name).split("\\s+");
		else if (launch_cmd.contains("run_diamondng.py"))
			cmd_list = (launch_cmd + " --design=" + design_path + " --test-id=" + task_name).split("\\s+");
		else if (launch_cmd.contains("run_radiant.py"))
			cmd_list = (launch_cmd + " --design=" + design_path + " --test-id=" + task_name).split("\\s+");
		else if (launch_cmd.contains("run_vivado.py"))
			cmd_list = (launch_cmd + " --design=" + design_path + " --test-id=" + task_name).split("\\s+");
		else if (launch_cmd.contains("run_classic.py"))
			cmd_list = (launch_cmd + " --design=" + design_path + " --test-id=" + task_name).split("\\s+");
		else
			cmd_list = launch_cmd.split("\\s+");
		// replace the @#@
		String array[] = new String[cmd_list.length];              
		for(int j =0;j<cmd_list.length;j++){
		  array[j] = cmd_list[j].replaceAll(tmp_str, " ");
		}
		return array;
	}	
	
	private int get_cmd_index(
			String cmd_index
			) {
		int int_id = 0;
		Pattern p = Pattern.compile("_(\\d+)$");
		Matcher m = p.matcher(cmd_index);
		if (m.find()) {
			int_id = Integer.valueOf(m.group(1));
		}
		return int_id;
	}
	
	protected HashMap<String, String> get_launch_env(
			String cmd_index,
			String python_version,
			Boolean corescript_link_status,
			HashMap<String, HashMap<String, String>> task_data,
			HashMap<String, HashMap<String, String>> client_data
			) {
		HashMap<String, String> run_env = new HashMap<String, String>();
		// put Python unbuffered environment
		if (task_data.get("LaunchCommand").get(cmd_index).toLowerCase().contains("python")) {
			run_env.put("PYTHONUNBUFFERED", "1");
		}
		// put system level default tools path
		String python_path = new String();
		python_path = client_data.get("tools").getOrDefault("python", public_data.DEF_PYTHON_PATH);
		File python_fobj = new File(python_path);
		if (python_path.equalsIgnoreCase("python")) {
			run_env.put("EXTERNAL_PYTHON_PATH",  python_path);
		} else if(python_fobj.isFile()) {
			run_env.put("EXTERNAL_PYTHON_PATH", python_fobj.getParent().replaceAll("\\\\", "/"));
		} else {
			run_env.put("EXTERNAL_PYTHON_PATH", python_path.replaceAll("\\\\", "/"));
		}
		// put external core script path
		String work_space = task_data.get("Paths").get("work_space").trim();
		String core_path = new String(public_data.CORE_SCRIPT_NAME);
		if (python_version.startsWith("2")) {
			core_path = public_data.LOCAL_CORE_SCRIPT_DIR2;
		} else if (python_version.startsWith("3")) {
			if(corescript_link_status) {
				core_path = public_data.REMOTE_CORE_SCRIPT_DIR.replaceAll("\\$work_path", work_space);
			} else {
				core_path = public_data.LOCAL_CORE_SCRIPT_DIR3;
			}
		} else {
			core_path = public_data.LOCAL_CORE_SCRIPT_DIR3;
		}
		run_env.put("EXTERNAL_DEV_PATH", core_path);
		// put environ for software requirements in sub process
		String ignore_request = client_data.get("preference").getOrDefault("ignore_request", public_data.DEF_CLIENT_IGNORE_REQUEST);
		if (!ignore_request.contains("software") && !ignore_request.contains("all")){
			Iterator<String> software_request_it = task_data.get("Software").keySet().iterator();
			while (software_request_it.hasNext()) {
				String software_name = software_request_it.next();
				//request_build can be: ng3_1p.1@cmd_2, ng3_1p.2@cmd_1, ng3_1p.33
				String request_build = task_data.get("Software").get(software_name);
				String software_path = new String("");
				software_path = get_correct_build_path(software_name, request_build, cmd_index, client_data);
				if(software_path == null || software_path.equals("")) {
					continue;
				}
				String software_env_name = "EXTERNAL_" + software_name.toUpperCase() + "_PATH";
				run_env.put(software_env_name, software_path);
			}
		}
		// put environ in task info Environment
		Iterator<String> env_request_it = task_data.get("Environment").keySet().iterator();
		while (env_request_it.hasNext()) {
			String env_name = env_request_it.next();
			String env_value = task_data.get("Environment").get(env_name);
			//ignore control option
			if(env_name.equalsIgnoreCase("override")) {
				continue;
			}
			if(env_value.contains("@cmd")) {
				if(env_value.endsWith(cmd_index)) {
					env_value = env_value.replaceAll("@.*$", "");
				} else {
					continue;
				}
			}
			if (env_value.contains("@all")) {
				env_value = env_value.replaceAll("@.*$", "");
			}
			run_env.put(env_name, get_updated_environment_string(env_value, cmd_index, task_data, client_data));
		} 
		return run_env;
	}

	protected HashMap<String, String> get_tool_software_depends(
			String cmd_index,
			HashMap<String, HashMap<String, String>> task_data,
			HashMap<String, HashMap<String, String>> client_data
			) {
		HashMap<String, String> dep_tools = new HashMap<String, String>();
		// put environ for software requirements in sub process
		String ignore_request = client_data.get("preference").getOrDefault("ignore_request", public_data.DEF_CLIENT_IGNORE_REQUEST);
		if (!ignore_request.contains("software") && !ignore_request.contains("all")){
			Iterator<String> software_request_it = task_data.get("Software").keySet().iterator();
			while (software_request_it.hasNext()) {
				String software_name = software_request_it.next();
				//request_build can be: ng3_1p.1@cmd_2, ng3_1p.2@cmd_1, ng3_1p.33
				String request_build = new String("");
				request_build = get_correct_build_name(software_name, task_data.get("Software").get(software_name), cmd_index);
				if (request_build == null || request_build.equals("")) {
					continue;
				}
				dep_tools.put(software_name, request_build);
			}
		}
		return dep_tools;
	}
	
	private String get_correct_build_path(
			String software_name,
			String available_builds,
			String cmd_index,
			HashMap<String, HashMap<String, String>> client_data
			) {
		String software_path = new String("");
		if (available_builds == null || available_builds.equals("")) {
			return software_path;
		}
		ArrayList<String> available_builds_list = new ArrayList<String>();		
		if (available_builds.contains(",")){
			available_builds_list.addAll(Arrays.asList(available_builds.split("\\s*,\\s*")));
		} else if (available_builds.contains(";")){
			available_builds_list.addAll(Arrays.asList(available_builds.split("\\s*;\\s*")));
		} else{
			available_builds_list.add(available_builds);
		}
		if (available_builds_list.size() == 1) {
			if (available_builds.contains("@cmd")) {
				if (available_builds.contains(cmd_index)) {
					software_path = client_data.get(software_name).get(available_builds.replaceAll("@.*$", ""));
				}
			} else {
				software_path = client_data.get(software_name).get(available_builds);
			}
		} else if (available_builds_list.size() > 1) {
			//search by location 
			int cmd_index_int = get_cmd_index(cmd_index);
			if (cmd_index_int > 0 && cmd_index_int <= available_builds_list.size()) {
				String index_build = new String(available_builds_list.get(cmd_index_int - 1));
				if (!index_build.contains("@cmd")) {
					software_path = client_data.get(software_name).get(index_build);
				}
			}
			//override with explicit instruction
			for(String build_string:available_builds_list) {
				if (build_string.endsWith("@" + cmd_index)) {
					software_path = client_data.get(software_name).get(build_string.replaceAll("@.*$", ""));
					break;
				}
			}
		} else {
			;
		}
		return software_path;
	}
	
	private String get_correct_build_name(
			String software_name,
			String available_builds,
			String cmd_index
			) {
		String build_name = new String("");
		if (available_builds == null || available_builds.equals("")) {
			return build_name;
		}
		ArrayList<String> available_builds_list = new ArrayList<String>();		
		if (available_builds.contains(",")){
			available_builds_list.addAll(Arrays.asList(available_builds.split("\\s*,\\s*")));
		} else if (available_builds.contains(";")){
			available_builds_list.addAll(Arrays.asList(available_builds.split("\\s*;\\s*")));
		} else{
			available_builds_list.add(available_builds);
		}
		if (available_builds_list.size() == 1) {
			if (available_builds.contains("@cmd")) {
				if (available_builds.contains(cmd_index)) {
					build_name = available_builds.replaceAll("@.*$", "");
				}
			} else {
				build_name = available_builds;
			}
		} else if (available_builds_list.size() > 1) {
			//search by location 
			int cmd_index_int = get_cmd_index(cmd_index);
			if (cmd_index_int > 0 && cmd_index_int <= available_builds_list.size()) {
				String index_build = new String(available_builds_list.get(cmd_index_int - 1));
				if (!index_build.contains("@cmd")) {
					build_name = index_build;
				}
			}
			//override with explicit instruction
			for(String build_string:available_builds_list) {
				if (build_string.endsWith("@" + cmd_index)) {
					build_name = build_string.replaceAll("@.*$", "");
					break;
				}
			}
		} else {
			;
		}
		return build_name;
	}
	
	private String get_updated_environment_string(
			String env_string,
			String cmd_index,
			HashMap<String, HashMap<String, String>> task_data,
			HashMap<String, HashMap<String, String>> client_data
			){
		if(!env_string.contains("$")) {
			return env_string;
		}
		Iterator<String> software_request_it = task_data.get("Software").keySet().iterator();
		while (software_request_it.hasNext()) {
			String software_name = software_request_it.next();
			if (!env_string.contains("$" + software_name)){
				continue;
			}
			String software_builds = task_data.get("Software").get(software_name);
			String software_path = new String("");
			software_path = get_correct_build_path(software_name, software_builds, cmd_index, client_data);
			env_string = env_string.replaceAll("\\$" + software_name, software_path);
		}
		return env_string;
	}
	
	//====================following methods deprecated
	//================================================================
	protected String get_working_dir(
			HashMap<String, HashMap<String, String>> task_data, 
			String work_space)
			throws IOException {
		String work_dir_ready = new String("");
		File work_dir_fobj = new File(work_space);
		if (!work_dir_fobj.exists()) {
			CASE_PREPARE_LOGGER.warn("Work space do not exists:" + work_space);
			return work_dir_ready;
		}
		String tmp_result_dir = public_data.WORKSPACE_RESULT_DIR;
		String prj_dir_name = "prj" + task_data.get("ID").get("project");
		String run_dir_name = "run" + task_data.get("ID").get("run");
		String case_dir_name = "T" + task_data.get("ID").get("id");
		String[] path_array = new String[] { work_space, tmp_result_dir, prj_dir_name, run_dir_name, case_dir_name };
		String case_work_path = String.join(file_seprator, path_array);
		case_work_path = case_work_path.replaceAll("\\\\", "/");
		File case_work_path_fobj = new File(case_work_path);
		// delete previously run result.
		if (case_work_path_fobj.exists() && case_work_path_fobj.isDirectory()) {
			if (FileUtils.deleteQuietly(case_work_path_fobj)) {
				CASE_PREPARE_LOGGER.debug("Previously run case cleanup Pass:" + case_work_path);
			} else {
				CASE_PREPARE_LOGGER.info("Previously run case cleanup Fail:" + case_work_path);
			}
		}
		//Create new case path if not have
		synchronized (this.getClass()) {
			FileUtils.forceMkdir(case_work_path_fobj);
		}
		return case_work_path;
	}

	protected String get_run_directory(
			HashMap<String, HashMap<String, String>> task_data,
			String case_work_path){
		String launch_dir = new String("");
		String design_name = task_data.get("CaseInfo").get("design_name").trim();
		File design_name_fobj = new File(design_name);
		String design_base_name = design_name_fobj.getName();
		String case_path = case_work_path + "/" + design_base_name;
		if (task_data.get("LaunchCommand").containsKey("dir")){
			launch_dir = task_data.get("LaunchCommand").get("dir").trim();
			launch_dir = launch_dir.replaceAll("\\$case_path", case_path);
		} else {
			launch_dir = case_work_path;
		}
		return launch_dir;
	}
	
	protected String[] get_run_command(
			HashMap<String, HashMap<String, String>> task_data,
			String case_work_path,
			String work_space
			) {
		String launch_cmd = task_data.get("LaunchCommand").get("cmd").trim();
		String script_addr = task_data.get("CaseInfo").get("script_address").trim();
		String design_name = task_data.get("CaseInfo").get("design_name").trim();
		File design_name_fobj = new File(design_name);
		String design_base_name = design_name_fobj.getName();
		String case_path = case_work_path + "/" + design_base_name;
		script_addr = script_addr.replaceAll("\\$work_path", work_space);// = work_space
		script_addr = script_addr.replaceAll("\\$case_path", case_path);
		script_addr = script_addr.replaceAll("\\$tool_path", public_data.TOOLS_ROOT_PATH);
		// user command used
		if (script_addr.length() > 1) {
			return launch_cmd.split("\\s+");
		}
		// internal script cmd used
		// core script will be export to work space
		Pattern patt = Pattern.compile("(?:^|\\s)(\\S*\\.(?:pl|py|rb|jar|class|bat|exe))", Pattern.CASE_INSENSITIVE);
		if (launch_cmd.contains("$work_path")){
			launch_cmd = launch_cmd.replaceAll("\\$work_path", " " + work_space);
		} else if (launch_cmd.contains("$case_path")){
			launch_cmd = launch_cmd.replaceAll("\\$case_path", " " + case_path);
		} else if (launch_cmd.contains("$tool_path")){	
			launch_cmd = launch_cmd.replaceAll("\\$tool_path", " " + public_data.TOOLS_ROOT_PATH);
		} else {
			Matcher match = patt.matcher(launch_cmd);
			launch_cmd = match.replaceFirst(" " + work_space + "/$1");
		}
		// add default --deisgn option
		String[] cmd_list;
		if (launch_cmd.contains("run_lattice.py"))
			cmd_list = (launch_cmd + " --design=" + design_base_name).split("\\s+");
		else if (launch_cmd.contains("run_icecube.py"))
			cmd_list = (launch_cmd + " --design=" + design_base_name).split("\\s+");
		else if (launch_cmd.contains("run_diamond.py"))
			cmd_list = (launch_cmd + " --design=" + design_base_name).split("\\s+");
		else if (launch_cmd.contains("run_diamondng.py"))
			cmd_list = (launch_cmd + " --design=" + design_base_name).split("\\s+");
		else if (launch_cmd.contains("run_radiant.py"))
			cmd_list = (launch_cmd + " --design=" + design_base_name).split("\\s+");
		else if (launch_cmd.contains("run_classic.py"))
			cmd_list = (launch_cmd + " --design=" + design_base_name).split("\\s+");
		else
			cmd_list = launch_cmd.split("\\s+");
		return cmd_list;
	}

	protected HashMap<String, String> get_run_environment(
			HashMap<String, HashMap<String, String>> task_data,
			HashMap<String, HashMap<String, String>> client_data) {
		HashMap<String, String> run_env = new HashMap<String, String>();
		// put python unbuffered environ
		if (task_data.get("LaunchCommand").get("cmd").toLowerCase().contains("python")) {
			run_env.put("PYTHONUNBUFFERED", "1");
		}
		// put environ for software requirements
		String ignore_request = client_data.get("preference").getOrDefault("ignore_request", public_data.DEF_CLIENT_IGNORE_REQUEST);
		if (!ignore_request.contains("software") && !ignore_request.contains("all")){
			Set<String> software_request_set = task_data.get("Software").keySet();
			Iterator<String> software_request_it = software_request_set.iterator();
			while (software_request_it.hasNext()) {
				String software_name = software_request_it.next();
				String software_build = task_data.get("Software").get(software_name);
				String software_path = client_data.get(software_name).get(software_build);
				String software_env_name = "EXTERNAL_" + software_name.toUpperCase() + "_PATH";
				run_env.put(software_env_name, software_path);
			}
		}
		// put environ in task info Environment
		Set<String> env_request_set = task_data.get("Environment").keySet();
		Iterator<String> env_request_it = env_request_set.iterator();
		while (env_request_it.hasNext()) {
			String env_name = env_request_it.next();
			String env_value = task_data.get("Environment").get(env_name);
			run_env.put(env_name, env_value);
		}
		return run_env;
	}
}