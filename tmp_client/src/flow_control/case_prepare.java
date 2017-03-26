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
	//private String line_seprator = System.getProperty("line.separator");
	private String file_seprator = System.getProperty("file.separator");

	public case_prepare() {
	}

	protected String get_working_dir(HashMap<String, HashMap<String, String>> task_data, String work_dir)
			throws IOException {
		String work_dir_ready = new String("");
		File work_dir_fobj = new File(work_dir);
		if (!work_dir_fobj.exists()) {
			CASE_PREPARE_LOGGER.warn("Work space do not exists:" + work_dir);
			return work_dir_ready;
		}
		String tmp_result_dir = public_data.WORKSPACE_RESULT_DIR;
		String prj_dir_name = "prj" + task_data.get("ID").get("project");
		String run_dir_name = "run" + task_data.get("ID").get("run");
		String case_dir_name = "T" + task_data.get("ID").get("id");
		String[] path_array = new String[] { work_dir, tmp_result_dir, prj_dir_name, run_dir_name, case_dir_name };
		String case_work_path = String.join(file_seprator, path_array);
		case_work_path = case_work_path.replaceAll("\\\\", "/");
		File case_work_path_fobj = new File(case_work_path);
		// delete previously run result.
		if (case_work_path_fobj.exists() && case_work_path_fobj.isDirectory()) {
			if (FileUtils.deleteQuietly(case_work_path_fobj)) {
				CASE_PREPARE_LOGGER.debug("Previously run case deleted pass:" + case_work_path);
			} else {
				CASE_PREPARE_LOGGER.info("Previously run case deleted fail:" + case_work_path);
			}
		} else {
			// create new case path if not have
			FileUtils.forceMkdir(case_work_path_fobj);
		}
		return case_work_path;
	}

	protected ArrayList<String> get_design_export(HashMap<String, HashMap<String, String>> task_data,
			String case_work_path) throws IOException, Exception {
		ArrayList<String> export_msg = new ArrayList<String>();
		// generate source URL
		String repository = task_data.get("CaseInfo").get("repository");
		String suite_path = task_data.get("CaseInfo").get("suite_path");
		String design_name = task_data.get("CaseInfo").get("design_name");
		String design_src_url = repository + "/" + suite_path + "/" + design_name;
		// generate destination URL
		File design_name_fobj = new File(design_name);
		String design_base_name = design_name_fobj.getName();
		String design_des_url = case_work_path + "/" +design_base_name;
		// get access author key
		String auth_key = task_data.get("CaseInfo").get("auth_key");
		String user_passwd = des_decode.decrypt(auth_key, public_data.ENCRY_KEY);
		String user_name = user_passwd.split("_\\+_")[0];
		String pass_word = user_passwd.split("_\\+_")[1];
		// get export command
		ArrayList<String> export_cmd_list = get_export_cmd(design_src_url, user_name, pass_word, design_des_url);
		// export design
		for (String run_cmd : export_cmd_list) {
			try {
				for (String line : system_cmd.run(run_cmd))
					export_msg.add(line);
			} catch (IOException e) {
				//e.printStackTrace();
				CASE_PREPARE_LOGGER.warn("run cmd fail:" + run_cmd);
			}
		}
		return export_msg;
	}

	protected ArrayList<String> get_script_export(HashMap<String, HashMap<String, String>> task_data,
			String case_work_path) throws IOException, Exception {
		ArrayList<String> export_msg = new ArrayList<String>();
		// generate source URL 
		String script_addr = task_data.get("CaseInfo").get("script_address");
		if (script_addr.equals("") || script_addr == null) {
			CASE_PREPARE_LOGGER.warn("Internal script used, no export need.");
			export_msg.add("Internal script used, no export need.");
			return export_msg;
		}
		// generate destination URL
		// = case_work_path
		// get access author key
		String auth_key = task_data.get("CaseInfo").get("auth_key");
		String user_passwd = des_decode.decrypt(auth_key, public_data.ENCRY_KEY);
		String user_name = user_passwd.split("_\\+_")[0];
		String pass_word = user_passwd.split("_\\+_")[1];
		// get export command
		ArrayList<String> export_cmd_list = get_export_cmd(script_addr, user_name, pass_word, case_work_path);
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

	protected String[] get_run_command(HashMap<String, HashMap<String, String>> task_data, String work_path) {
		String launch_cmd = task_data.get("LaunchCommand").get("cmd");
		String script_addr = task_data.get("CaseInfo").get("script_address");
		// user command used
		if (script_addr.length() > 1) {
			return launch_cmd.split(" ");
		}
		// internal script cmd used
		// core script will be export to work space
		Pattern patt = Pattern.compile("(?:^|\\s)(\\S*\\.(?:pl|py|rb|jar|class|bat|exe))", Pattern.CASE_INSENSITIVE);
		Matcher match = patt.matcher(launch_cmd);
		launch_cmd = match.replaceFirst(" " + work_path + "/$1");
		// add default --deisgn option
		String design_name = task_data.get("CaseInfo").get("design_name");
		File design_name_fobj = new File(design_name);
		String design_base_name = design_name_fobj.getName();
		String[] cmd_list;
		if (launch_cmd.contains("run_lattice.py"))
			cmd_list = (launch_cmd + " --design=" + design_base_name).split(" ");
		else if (launch_cmd.contains("run_icecube.py"))
			cmd_list = (launch_cmd + " --design=" + design_base_name).split(" ");
		else if (launch_cmd.contains("run_diamond.py"))
			cmd_list = (launch_cmd + " --design=" + design_base_name).split(" ");
		else if (launch_cmd.contains("run_diamondng.py"))
			cmd_list = (launch_cmd + " --design=" + design_base_name).split(" ");
		else if (launch_cmd.contains("run_radiant.py"))
			cmd_list = (launch_cmd + " --design=" + design_base_name).split(" ");
		else if (launch_cmd.contains("run_classic.py"))
			cmd_list = (launch_cmd + " --design=" + design_base_name).split(" ");
		else
			cmd_list = launch_cmd.split(" ");
		return cmd_list;
	}

	protected HashMap<String, String> get_run_environment(
			HashMap<String, HashMap<String, String>> task_data,
			HashMap<String, HashMap<String, String>> client_data){
		HashMap<String, String> run_env = new HashMap<String, String>();
		//put python unbuffered environ
		if(task_data.get("LaunchCommand").get("cmd").toLowerCase().contains("python")){
			run_env.put("PYTHONUNBUFFERED", "1");
		}
		//put environ for software requirements
		Set<String> software_request_set = task_data.get("Software").keySet();
		Iterator<String> software_request_it = software_request_set.iterator();
		while(software_request_it.hasNext()){
			String software_name = software_request_it.next();
			String software_build = task_data.get("Software").get(software_name);
			String software_path = client_data.get(software_name).get(software_build);
			String software_env_name = "EXTERNAL_" + software_name.toUpperCase() + "_PATH";
			run_env.put(software_env_name, software_path);
		}
		//put environ in task info Environment
		Set<String> env_request_set = task_data.get("Environment").keySet();
		Iterator<String> env_request_it = env_request_set.iterator();
		while(env_request_it.hasNext()){
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
	private ArrayList<String> get_export_cmd(String case_url, String user_name, String pass_word, String case_dir) {
		String host_run = System.getProperty("os.name").toLowerCase();
		String[] url_array = case_url.split(":", 2);
		String host_src = url_array[0];
		ArrayList<String> cmd_array = new ArrayList<String>();
		if (host_src.length() > 1 && url_array.length > 1) {
			if (host_src.equalsIgnoreCase("http")) {
				// svn path
				cmd_array.add("svn export " + case_url + " " + case_dir + " --username=" + user_name + " --password="
						+ pass_word + " --no-auth-cache" + " --force");
			} else {
				// client path
				if (host_run.startsWith("windows")) {
					if (url_array[1].startsWith("/")) {
						// 1 windows run linux src, linux path always start with
						// /
						// pscp -r -l jwang1 -pw lattice1
						// lsh-comedy:/public/jason_test/temp/src
						// c:/users\jwang1\Desktop
						cmd_array.add(public_data.TOOLS_PSCP + " -r -p -l " + user_name + " -pw " + pass_word + " "
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
			) throws Exception{
		ArrayList<String> export_list = new ArrayList<String>();
		ArrayList<String> export_design = this.get_design_export(task_data, working_dir);
		ArrayList<String> export_script = this.get_script_export(task_data, working_dir);
		export_list.addAll(export_design);
		export_list.addAll(export_script);
		return export_list;		
	}
}