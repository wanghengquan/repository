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
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.io.FileUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.public_data;
import utility_funcs.des_decode;
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
	
	//create and writable
	protected Boolean get_task_path_ready(
			HashMap<String, HashMap<String, String>> task_data,
			HashMap<String, String> client_preference_data
			){
		task_prepare_info.add(">>>Prepare task path:");
		String task_path = task_data.get("Paths").get("task_path").trim();
		String case_mode = client_preference_data.get("case_mode").trim();
		File task_path_dobj = new File(task_path);
		if (case_mode.equalsIgnoreCase("keep_case")){
			if (task_path_dobj.isDirectory() && task_path_dobj.canWrite()){
				task_prepare_info.add("Info : Task path prepare Pass:" + task_path);
				return true;
			} else {
				task_prepare_info.add("Error: Task path cannot write:" + task_path);
				return false;
			}
		}
		//Create new case path if not have
		synchronized (this.getClass()) {
			if (!task_path_dobj.exists()){
				try {
					FileUtils.forceMkdir(task_path_dobj);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					// e.printStackTrace();
					task_prepare_info.add("Error: Prepare task path Fail:" + task_path);
					CASE_PREPARE_LOGGER.error("Prepare task path Fail:" + task_path);
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
	
	//export and writable
	protected Boolean get_case_path_ready(
			HashMap<String, HashMap<String, String>> task_data,
			HashMap<String, String> client_preference_data
			){
		task_prepare_info.add(line_separator + ">>>Prepare case path:");
		String source_path = task_data.get("Paths").get("design_source").trim();
		String case_path = task_data.get("Paths").get("case_path").trim();
		String task_path = task_data.get("Paths").get("task_path").trim();
		String case_mode = client_preference_data.get("case_mode").trim();
		File case_path_dobj = new File(case_path);
		if (case_mode.equalsIgnoreCase("keep_case")){
			if (case_path_dobj.isDirectory() && case_path_dobj.canWrite()){
				task_prepare_info.add("Info : Case path prepare Pass:" + case_path);
				return true;
			} else {
				task_prepare_info.add("Error: Case path cannot write:" + case_path);
				return false;
			}
		}		
		//export new case if not have
		// get access author key
		String auth_key = task_data.get("CaseInfo").get("auth_key").trim();
		String user_passwd = new String("NA_+_NA");
		try {
			user_passwd = des_decode.decrypt(auth_key, public_data.ENCRY_KEY);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			task_prepare_info.add("Error: Decode auth key failed.");
			CASE_PREPARE_LOGGER.error("Decode auth key failed.");
			return false;
		}
		String user_name = user_passwd.split("_\\+_")[0];
		String pass_word = user_passwd.split("_\\+_")[1];
		//get export command
		ArrayList<String> export_cmd_list = get_export_cmd(source_path, user_name, pass_word, case_path, task_path);
		task_prepare_info.add(">>>Export Task case with CMD(s):");
		task_prepare_info.addAll(export_cmd_list);		
		//run export
		synchronized (this.getClass()) {
			//delete ori design
			if (case_path_dobj.exists()){
				if(FileUtils.deleteQuietly(case_path_dobj)){
					task_prepare_info.add("Info : Previously run design remove Pass:" + case_path);
					CASE_PREPARE_LOGGER.debug("Previously run design remove Pass:" + case_path);
				} else {
					task_prepare_info.add("Warning: Previously run design remove Fail:" + case_path);
					CASE_PREPARE_LOGGER.warn("Previously run design deleted Fail:" + case_path);
				}
			}
			// export design
			for (String run_cmd : export_cmd_list) {
				try {
					task_prepare_info.addAll(system_cmd.run(run_cmd));
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
	
	//export and writable
	protected Boolean get_script_path_ready(
			HashMap<String, HashMap<String, String>> task_data
			){
		task_prepare_info.add(line_separator + ">>>Prepare script path:");
		// generate source URL
		String script_addr = task_data.get("Paths").get("script_source").trim();
		String task_path = task_data.get("Paths").get("task_path").trim();
		if (script_addr.equals("") || script_addr == null) {
			CASE_PREPARE_LOGGER.debug("Internal script used, no export need.");
			task_prepare_info.add("Info : Internal script used, no export need.");
			return true;
		}
		File script_dobj = new File(script_addr);
		String script_name = script_dobj.getName();	
		String script_path = task_path + '/' + script_name;
		File script_path_dobj = new File(script_path);
		// get access author key
		String auth_key = task_data.get("CaseInfo").get("auth_key").trim();
		String user_passwd = new String("NA_+_NA");
		try {
			user_passwd = des_decode.decrypt(auth_key, public_data.ENCRY_KEY);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			task_prepare_info.add("Error: Decode auth key failed.");
			CASE_PREPARE_LOGGER.error("Decode auth key failed.");
			return false;
		}
		String user_name = user_passwd.split("_\\+_")[0];
		String pass_word = user_passwd.split("_\\+_")[1];		
		// get export command
		ArrayList<String> export_cmd_list = get_export_cmd(script_addr, user_name, pass_word, task_path, task_path);
		task_prepare_info.add(">>>Export Task script with CMD(s):");
		task_prepare_info.addAll(export_cmd_list);
		//skip export if exists
		if (script_path_dobj.exists()){
			task_prepare_info.add("Info : Script exists, skip export:" + script_path);
			CASE_PREPARE_LOGGER.info("Script exists, skip export:" + script_path);
			return true;
		}		
		//run export
		synchronized (this.getClass()) {
			// export script
			for (String run_cmd : export_cmd_list) {
				try {
					task_prepare_info.addAll(system_cmd.run(run_cmd));
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

	/*
	 * Current we support the following address: repository + suite_path +
	 * design_name http://linux12v/test_dir + test_suite + test_case
	 * <host>:M:/test_dir + test_suite + test_case \\lsh-smb01\test_dir +
	 * test_suite + test_case /lsh/sw/test_test + test_suite + test_case
	 */
	private ArrayList<String> get_export_cmd(
			String case_url, 
			String user_name, 
			String pass_word, 
			String case_dir,
			String task_path) {
		String host_run = System.getProperty("os.name").toLowerCase();
		String[] url_array = case_url.split(":", 2);
		String host_src = url_array[0];
		ArrayList<String> cmd_array = new ArrayList<String>();
		if (host_src.length() > 1 && url_array.length > 1) {
			if (host_src.equalsIgnoreCase("http")) {
				// svn path
				cmd_array.add("svn export " + case_url + " " + case_dir + " --username=" + user_name + " --password="
						+ pass_word + " --no-auth-cache" + " --force");
			} else if (host_src.equalsIgnoreCase("ftp")){
				String account_str = new String();
				if (user_name.equals(public_data.FTP_USER)){
					account_str = ""; //default user means login with anonymous account (public_data.FTP_USER == anonymous)
				} else {
					account_str = " --ftp-user=" + user_name + "  --ftp-password=" + pass_word + " ";
				}
				String wget_str = new String();
				if (host_run.startsWith("windows")) {
					wget_str = public_data.TOOLS_WGET + " ";
				} else {
					wget_str = "wget ";
				}
				int cut_depth = case_url.split("/").length - 3 -1; // 3 remove the depth for ftp://shitl0012, 1 remove keep folder
				cmd_array.add(wget_str + case_url + " -r -q -nH --cut-dirs=" + String.valueOf(cut_depth) + " -P " + task_path + account_str); 
			} else {
				// client path
				if (host_run.startsWith("windows")) {
					if (url_array[1].startsWith("/")) {
						// 1 windows run linux src, linux path always start with
						// pscp -r -p -l jwang1 -pw lattice1
						// lsh-comedy:/public/jason_test/temp/src
						// c:/users\jwang1\Desktop
						cmd_array.add(public_data.TOOLS_PSCP + " -r -p -batch -l " + user_name + " -pw " + pass_word + " "
								+ case_url + " " + case_dir);
					} else {
						// 2 windows run windows src
						// D25970:D:/test_dir
						// xcopy \\D25970\D$\auto_install.bat
						// c:/user\jwang1\Desktop
						String dest_path = url_array[1].replaceFirst(":", "\\$");
						cmd_array.add("xcopy  \\\\" + url_array[0] + "\\" + dest_path.replace("/", "\\") + " "
								+ case_dir.replace("/", "\\\\") + "\\ /E /Y /A");
					}
				} else {
					// 1 linux run linux src
					// ./conf/sshpass/sshpass -p "lattice1" scp -r -l jwang1
					// lsh-opera:/public/jason_test/temp/jdk.rpm ./
					// 2 linux run windows src
					// ./conf/sshpass/sshpass -p "lattice" scp -r -l jwang1
					// D27639:M:/test.txt ./
					cmd_array.add(public_data.TOOLS_SSHPASS + " -p \"" + pass_word + "\" scp -r -p " + user_name + "@"
							+ case_url + " " + case_dir);
				}
			}
		} else {
			// direct path: cp -r case_url case_dir
			if (host_run.startsWith("windows")) {
				cmd_array.add(public_data.TOOLS_CP + " -r -p " + case_url + " " + case_dir);
			} else {
				cmd_array.add("cp -r -p " + case_url + " " + case_dir);
			}
		}
		return cmd_array;
	}
	
	protected Boolean get_task_case_ready(
			HashMap<String, HashMap<String, String>> task_data, 
			HashMap<String, String> client_preference_data
			){
		Boolean task_path_ok = get_task_path_ready(task_data, client_preference_data);
		Boolean case_path_ok = get_case_path_ready(task_data, client_preference_data);
		Boolean script_path_ok = get_script_path_ready(task_data);
		if (task_path_ok && case_path_ok && script_path_ok){
			return true;
		} else {
			return false;
		}
	}	

	protected String[] get_launch_command(
			HashMap<String, HashMap<String, String>> task_data
			) {
		String launch_cmd = task_data.get("LaunchCommand").get("cmd").trim().replaceAll("\\\\", "/");
		String launch_path = task_data.get("Paths").get("launch_path").trim();
		String work_space = task_data.get("Paths").get("work_space").trim();
		String case_path = task_data.get("Paths").get("case_path").trim();
		String design_path = new String("");
		design_path = new File(launch_path).toURI().relativize(new File(case_path).toURI()).getPath();
		// update launch command
		Pattern patt = Pattern.compile("(?:^|\\s)(\\S*\\.(?:pl|py|rb|jar|class|bat|exe))", Pattern.CASE_INSENSITIVE);
		launch_cmd = launch_cmd.replaceAll("\\$work_path", " " + work_space);
		launch_cmd = launch_cmd.replaceAll("\\$case_path", " " + case_path);
		launch_cmd = launch_cmd.replaceAll("\\$tool_path", " " + public_data.TOOLS_ROOT_PATH);
		Matcher match = patt.matcher(launch_cmd);
		String exe_path = new String("");
		Boolean abs_path_ok = new Boolean(false);
		Boolean ref_path_ok = new Boolean(false);
		if (match.find()){
			exe_path = match.group().trim();
			//abs path
			File exe1_fobj = new File(exe_path);
			if (exe1_fobj.exists() && exe1_fobj.isAbsolute()){
				abs_path_ok = true;
			}
			//ref path
			File exe2_fobj = new File(launch_path + "/" + exe_path);
			if (exe2_fobj.exists()){
				ref_path_ok = true;
			}
			if (!abs_path_ok && !ref_path_ok){
				launch_cmd = match.replaceFirst(" " + work_space + "/" + exe_path);
				//launch_cmd = match.replaceFirst(" " + work_space + "/$1");
			}
		}
		// replace blank space in ""
		String tmp_str = new String("@#@");
		// python --option1="test1  test2   test3" -o "test1   test3" --test
		Pattern patt2 = Pattern.compile("\\s(\\S+?)?\".+?\"", Pattern.CASE_INSENSITIVE);
		Matcher match2 = patt2.matcher(launch_cmd);
		while(match2.find()){
			String match_str = new String(match2.group().trim());
			launch_cmd = launch_cmd.replaceAll(match_str, match_str.replaceAll("\\s+", tmp_str));
		}
		// python --option1="test1@@@test2@@@test3" -o "test1@@@test3" --test
		// add default --design option for Core scripts
		String[] cmd_list = null;
		if (launch_cmd.contains("run_lattice.py"))
			cmd_list = (launch_cmd + " --design=" + design_path).split("\\s+");
		else if (launch_cmd.contains("run_icecube.py"))
			cmd_list = (launch_cmd + " --design=" + design_path).split("\\s+");
		else if (launch_cmd.contains("run_diamond.py"))
			cmd_list = (launch_cmd + " --design=" + design_path).split("\\s+");
		else if (launch_cmd.contains("run_diamondng.py"))
			cmd_list = (launch_cmd + " --design=" + design_path).split("\\s+");
		else if (launch_cmd.contains("run_radiant.py"))
			cmd_list = (launch_cmd + " --design=" + design_path).split("\\s+");
		else if (launch_cmd.contains("run_classic.py"))
			cmd_list = (launch_cmd + " --design=" + design_path).split("\\s+");
		else
			cmd_list = launch_cmd.split("\\s+");
		// replace the @#@
		String array[] = new String[cmd_list.length];              
		for(int j =0;j<cmd_list.length;j++){
		  array[j] = cmd_list[j].replaceAll(tmp_str, " ");
		}
		return array;
	}	
	
	protected HashMap<String, String> get_launch_environment(
			HashMap<String, HashMap<String, String>> task_data,
			HashMap<String, HashMap<String, String>> client_data) {
		HashMap<String, String> run_env = new HashMap<String, String>();
		// put Python unbuffered environ
		if (task_data.get("LaunchCommand").get("cmd").toLowerCase().contains("python")) {
			run_env.put("PYTHONUNBUFFERED", "1");
		}
		// put environ for software requirements
		String ignore_request = client_data.get("preference").getOrDefault("ignore_request", public_data.DEF_CLIENT_IGNORE_REQUEST);
		if (!ignore_request.contains("software")){
			Iterator<String> software_request_it = task_data.get("Software").keySet().iterator();
			while (software_request_it.hasNext()) {
				String software_name = software_request_it.next();
				String software_build = task_data.get("Software").get(software_name);
				String software_path = client_data.get(software_name).get(software_build);
				String software_env_name = "EXTERNAL_" + software_name.toUpperCase() + "_PATH";
				run_env.put(software_env_name, software_path);
			}
		}
		// put environ in task info Environment
		Iterator<String> env_request_it = task_data.get("Environment").keySet().iterator();
		while (env_request_it.hasNext()) {
			String env_name = env_request_it.next();
			String env_value = task_data.get("Environment").get(env_name);
			run_env.put(env_name, env_value);
		}
		return run_env;
	}	

	
	//following function are not used
	//
	//
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

	protected ArrayList<String> get_design_export(
			HashMap<String, HashMap<String, String>> task_data,
			String case_work_path
			) throws IOException, Exception {
		ArrayList<String> export_msg = new ArrayList<String>();
		// generate source URL
		String xlsx_dest = task_data.get("CaseInfo").get("xlsx_dest").trim();
		String repository = task_data.get("CaseInfo").get("repository").trim();
		repository = repository.replaceAll("\\$xlsx_dest", xlsx_dest);
		String suite_path = task_data.get("CaseInfo").get("suite_path").trim();
		String design_name = task_data.get("CaseInfo").get("design_name").trim();
		String design_src_url = repository + "/" + suite_path + "/" + design_name;
		// generate destination URL
		File design_name_fobj = new File(design_name);
		String design_base_name = design_name_fobj.getName();
		String design_des_url = case_work_path + "/" + design_base_name;
		// get access author key
		String auth_key = task_data.get("CaseInfo").get("auth_key").trim();
		String user_passwd = des_decode.decrypt(auth_key, public_data.ENCRY_KEY);
		String user_name = user_passwd.split("_\\+_")[0];
		String pass_word = user_passwd.split("_\\+_")[1];
		// clean local existing case
		File design_path_fobj = new File(design_des_url);
		if (design_path_fobj.exists()){
			if(FileUtils.deleteQuietly(design_path_fobj)){
				CASE_PREPARE_LOGGER.debug("Previously run design deleted pass:" + design_des_url);
			} else {
				CASE_PREPARE_LOGGER.info("Previously run design deleted pass:" + design_des_url);
			}
		}
		// get export command
		ArrayList<String> export_cmd_list = get_export_cmd(design_src_url, user_name, pass_word, design_des_url, case_work_path);
		// export design
		for (String run_cmd : export_cmd_list) {
			try {
				for (String line : system_cmd.run(run_cmd))
					export_msg.add(line);
			} catch (IOException e) {
				// e.printStackTrace();
				CASE_PREPARE_LOGGER.warn("run cmd fail:" + run_cmd);
			}
		}
		return export_msg;
	}

	protected ArrayList<String> get_script_export(HashMap<String, HashMap<String, String>> task_data,
			String case_work_path) throws IOException, Exception {
		ArrayList<String> export_msg = new ArrayList<String>();
		// generate source URL
		String script_addr = task_data.get("CaseInfo").get("script_address").trim();
		if (script_addr.equals("") || script_addr == null) {
			CASE_PREPARE_LOGGER.debug("Internal script used, no export need.");
			export_msg.add("Internal script used, no export need.");
			return export_msg;
		}
		// generate destination URL
		// = case_work_path
		// get access author key
		String auth_key = task_data.get("CaseInfo").get("auth_key").trim();
		String user_passwd = des_decode.decrypt(auth_key, public_data.ENCRY_KEY);
		String user_name = user_passwd.split("_\\+_")[0];
		String pass_word = user_passwd.split("_\\+_")[1];
		// get export command
		ArrayList<String> export_cmd_list = get_export_cmd(script_addr, user_name, pass_word, case_work_path, case_work_path);
		// export design
		for (String run_cmd : export_cmd_list) {
			try {
				for (String line : system_cmd.run(run_cmd))
					export_msg.add(line);
			} catch (IOException e) {
				e.printStackTrace();
				CASE_PREPARE_LOGGER.warn("run cmd fail:" + run_cmd);
			}
		}
		return export_msg;
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
		if (!ignore_request.contains("software")){
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

	protected ArrayList<String> get_case_ready(
			HashMap<String, HashMap<String, String>> task_data, 
			String working_dir
			) throws Exception {
		ArrayList<String> export_list = new ArrayList<String>();
		ArrayList<String> export_design = this.get_design_export(task_data, working_dir);
		ArrayList<String> export_script = this.get_script_export(task_data, working_dir);
		export_list.add(">>>Design export:");
		export_list.addAll(export_design);
		export_list.add(">>>Script export:");
		export_list.addAll(export_script);
		return export_list;
	}
}