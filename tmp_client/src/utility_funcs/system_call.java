/*
 * File: system_cmd.java
 * Description: run system command line
 * Author: Jason.Wang
 * Date:2017/02/15
 * Modifier:
 * Date:
 * Description:
 */
package utility_funcs;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.Callable;

import data_center.public_data;
import utility_funcs.system_cmd;

class system_call implements Callable<Object> {
	private String case_dir;
	private String[] cmds;
	private Map<String, String> envs;
	private int timeout = 0;

	void run_case(String[] cmds, Map<String, String> envs) {
		this.cmds = cmds;
		this.envs = envs;
	}

	void run_case(String[] cmds, Map<String, String> envs, String case_dir, int timeout) {
		this.cmds = cmds;
		this.envs = envs;
		this.case_dir = case_dir;
		this.timeout = timeout;
	}

	public Object call() throws Exception {
		ArrayList<String> string_list = new ArrayList<>();
		if (this.case_dir != null && !this.case_dir.isEmpty())
			string_list = system_cmd.run(cmds, envs, case_dir, timeout);
		else
			string_list = system_cmd.run(cmds, envs);
		if (case_dir == null) {
			file_action.append_file("log/run.log", string_list.toString());
		} else {
			String local_rpt_path = case_dir + "/" + public_data.case_rpt;
			file_action.append_file(local_rpt_path, public_data.line_separator);
			file_action.append_file(local_rpt_path, "[Run]" + public_data.line_separator);
			file_action.append_file(local_rpt_path, ">>>Eev set:" + public_data.line_separator);
			Set<String> env_set = envs.keySet();
			Iterator<String> env_it = env_set.iterator();
			while (env_it.hasNext()) {
				String env_key = env_it.next();
				String env_value = envs.get(env_key);
				file_action.append_file(local_rpt_path,
						"Eev variable: " + env_key + " = " + env_value + " " + publicData.line_separator);
			}
			file_action.append_file(local_rpt_path, ">>>Case run:" + publicData.line_separator);
			for (String line : string_list)
				file_action.append_file(local_rpt_path, line + publicData.line_separator);
		}
		return string_list;
	}
}
