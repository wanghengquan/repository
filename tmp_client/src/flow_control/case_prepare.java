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

public class case_prepare {
	// public property
	// protected property
	// private property
	private static final Logger CASE_PREPARE_LOGGER = LogManager.getLogger(task_waiter.class.getName());
	// private String line_separator = System.getProperty("line.separator");
	private String file_seprator = System.getProperty("file.separator");

	public case_prepare() {
	}

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
			String case_work_path) {
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
				cmd_array.add(wget_str + case_url + " -r -q -nH --cut-dirs=" + String.valueOf(cut_depth) + " -P " + case_work_path + account_str); 
			} else {
				// client path
				if (host_run.startsWith("windows")) {
					if (url_array[1].startsWith("/")) {
						// 1 windows run linux src, linux path always start with
						// /
						// pscp -r -p -l jwang1 -pw lattice1
						// lsh-comedy:/public/jason_test/temp/src
						// c:/users\jwang1\Desktop
						cmd_array.add(public_data.TOOLS_PSCP + " -r -p -l -batch" + user_name + " -pw " + pass_word + " "
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
			// direct path
			// cp -r case_url case_dir
			if (host_run.startsWith("windows")) {
				cmd_array.add(public_data.TOOLS_CP + " -r -p " + case_url + " " + case_dir);
			} else {
				cmd_array.add("cp -r -p " + case_url + " " + case_dir);
			}
		}
		return cmd_array;
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