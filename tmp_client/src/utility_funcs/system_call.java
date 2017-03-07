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

public class system_call implements Callable<Object> {
	private String case_dir;
	private String[] cmds;
	private Map<String, String> envs;
	private int timeout = 0;
	private String line_seprator = System.getProperty("line.separator");

	public system_call(String[] cmds, Map<String, String> envs) {
		this.cmds = cmds;
		this.envs = envs;
	}

	public system_call(String[] cmds, Map<String, String> envs, String case_dir, int timeout) {
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
		return string_list;
	}
}
