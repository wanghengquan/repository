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
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.TreeMap;
import java.util.concurrent.Callable;
import java.util.concurrent.CountDownLatch;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import data_center.public_data;
import flow_control.cmd_attr;
import flow_control.cmd_enum;

//import utility_funcs.system_cmd;

public class system_call implements Callable<Object> {
	private String case_dir;
	private TreeMap<String, HashMap<cmd_attr, List<String>>> launch_cmds;
	private Boolean cmds_parallel;
	private String cmds_decision;
	private HashMap<String, String> tools_data;
	private int timeout = 0;
	private String last_cmd = new String("");
	private HashMap<String, cmd_enum> cmd_status = new HashMap<String, cmd_enum>();
	//private ArrayList<String> disabled_cmds = new ArrayList<String>();
	//private String line_separator = System.getProperty("line.separator");

	public system_call(
			TreeMap<String, HashMap<cmd_attr, List<String>>> launch_cmds, 
			Boolean cmds_parallel,
			String cmds_decision,
			String case_dir, 
			int timeout,
			HashMap<String, String> tools_data
			) {
		this.launch_cmds = launch_cmds;
		this.cmds_parallel = cmds_parallel;
		this.cmds_decision = cmds_decision;
		this.case_dir = case_dir;
		this.timeout = timeout;
		this.tools_data = tools_data;
	}
	
	private ArrayList<String> get_exectrl_items(
			List<String> ctl_lst
			) {
		ArrayList<String> ctrl_items = new ArrayList<String>();
		for (String ctl_str:ctl_lst) {
			ctl_str = ctl_str.replaceAll("\\(", "");
			ctl_str = ctl_str.replaceAll("\\)", "");
			ctl_str = ctl_str.replaceAll("and", "");
			ctl_str = ctl_str.replaceAll("not", "");
			ctl_str = ctl_str.replaceAll("or", "");
			for (String ctrl_item: ctl_str.trim().split("\\s+")) {
				ctrl_items.add(ctrl_item);
			}
		}
		return ctrl_items;
	}
	
	private Boolean exectrl_legal_check(
			List<String> ctl_lst,
			Set<String> available_cmds
			) {
		Boolean check_result = Boolean.valueOf(true);
		//Available check
		ArrayList<String> ctrl_items = new ArrayList<String>();
		ctrl_items.addAll(get_exectrl_items(ctl_lst));
		for (String ctrl_item: ctrl_items) {
			if (!available_cmds.contains(ctrl_item)) {
				return false;
			}
		}
		return check_result;
	}
	
	private Boolean exectrl_ready_check(
			List<String> ctl_lst
			) {
		Boolean check_result = Boolean.valueOf(true);
		ArrayList<String> ctrl_items = new ArrayList<String>();
		ctrl_items.addAll(get_exectrl_items(ctl_lst));
		for (String item: ctrl_items) {
			if(!cmd_status.containsKey(item) || cmd_status.get(item).equals(cmd_enum.UNKNOWN)) {
				return false;
			}
		}
		return check_result;
	}	
	
	private String exectrl_result_update(
			String eval_str
			) {
		Iterator<String> cmd_it = cmd_status.keySet().iterator();
		while(cmd_it.hasNext()) {
			String cmd_index = cmd_it.next();
			if(cmd_status.containsKey(cmd_index) && cmd_status.get(cmd_index).equals(cmd_enum.PASSED)) {
				eval_str.replaceAll(cmd_index, "True");
			} else {
				eval_str.replaceAll(cmd_index, "False");
			}
		}
		return eval_str;
	}
	
	private Boolean exectrl_expression_check(
			List<String> ctl_lst
			) {
		Boolean check_result = Boolean.valueOf(true);
		String pyton = new String(tools_data.getOrDefault("python", public_data.DEF_PYTHON_PATH));
		for(String eval_item: ctl_lst) {
			String eval_str = new String(exectrl_result_update(eval_item));
			if(!exp_eval.python_eval_bol(pyton, eval_str)) {
				return false;
			}
		}
		return check_result;
	}
	
	private cmd_enum get_cmd_status(
			ArrayList<String> call_output
			) {
		cmd_enum cmd_result = cmd_enum.UNKNOWN;
		String status = new String("NA");
		if(call_output == null || call_output.isEmpty()) {
			return cmd_result;
		}
		// <status>Passed</status>
		Pattern p = Pattern.compile("result>(.+?)</");
		for (String line : call_output) {
			if (!line.contains("<result>")) {
				continue;
			}
			Matcher m = p.matcher(line);
			if (!m.find()) {
				continue;
			}
			status = m.group(1);
			//break; to find the last one
			switch (status) {
			case "Passed":
				cmd_result = cmd_enum.PASSED;
				break;
			case "Failed":
				cmd_result = cmd_enum.FAILED;
				break;
			case "TBD":
				cmd_result = cmd_enum.TBD;
				break;
			case "Timeout":
				cmd_result = cmd_enum.TIMEOUT;
				break;
			case "Case_Issue":
				cmd_result = cmd_enum.CASEISSUE;
				break;
			case "SW_Issue":
				cmd_result = cmd_enum.SWISSUE;
				break;
			default:
				cmd_result = cmd_enum.UNKNOWN;
			}
		}
		return cmd_result;
	}
	
	private Boolean cmds_decision_check(
			String cmds_decision,
			HashMap<String, cmd_enum> cmd_status
			) {
		Boolean status = Boolean.valueOf(true);
		if (cmds_decision.equalsIgnoreCase("last")) {
			return true;
		}
		if (cmds_decision.equalsIgnoreCase("all")) {
			return true;
		}
		if (cmd_status.containsKey(cmds_decision)) {
			return true;
		}
		cmds_decision = cmds_decision.replaceAll("\\(", "");
		cmds_decision = cmds_decision.replaceAll("\\)", "");
		cmds_decision = cmds_decision.replaceAll("and", "");
		cmds_decision = cmds_decision.replaceAll("or", "");
		for (String item: cmds_decision.trim().split("\\s+")) {
			if(!cmd_status.containsKey(item)) {
				status = false;
				break;
			}
		}
		return status;
	}
	
	private cmd_enum get_all_cmds_status(
			HashMap<String, cmd_enum> cmd_status
			) {
		cmd_enum status = cmd_enum.UNKNOWN;
		for(String cmd_index: cmd_status.keySet()) {
			if(cmd_status.get(cmd_index).compareTo(status)>0) {
				status = cmd_status.get(cmd_index);
			}
		}
		return status;
	}
	
	private cmd_enum logic_calculate(
			ArrayList<cmd_enum> data_list,
			ArrayList<String> op_list
			) {
		cmd_enum status = cmd_enum.UNKNOWN;
		cmd_enum data1 = data_list.get(0);
		cmd_enum data2 = data_list.get(1);
		String op = op_list.get(0);
		if (op.equalsIgnoreCase("and")) {
			if (data1.compareTo(data2) > 0) {
				return data1;
			} else {
				return data2;
			}
		} else if (op.equalsIgnoreCase("or")) {
			if (data1.compareTo(data2) > 0) {
				return data2;
			} else {
				return data1;
			}
		} else {
			return status;
		}
	}
	
	private cmd_enum get_logic_cmd_status(
			String cmds_decision,
			HashMap<String, cmd_enum> cmd_status
			){
		cmd_enum status = cmd_enum.UNKNOWN;
		//cmds_decision: a or b and c or d
		cmds_decision = cmds_decision.replaceAll("^\\(", "");
		cmds_decision = cmds_decision.replaceAll("\\)$", "");
		ArrayList<cmd_enum> data_list = new ArrayList<cmd_enum>();
		ArrayList<String> op_list = new ArrayList<String>();
		for (String item: cmds_decision.trim().split("\\s+")) {
			if (item.equalsIgnoreCase("or")||item.equalsIgnoreCase("and")) {
				op_list.add(item);
			} else {
				data_list.add(cmd_status.getOrDefault(item, cmd_enum.UNKNOWN));
			}
			if (op_list.size() == 1 && data_list.size() == 2) {
				status = logic_calculate(data_list, op_list);
				data_list.clear();
				op_list.clear();
				data_list.add(status);
			}
		}
		return status;
	}
	
	private cmd_enum get_individul_cmd_status(
			String cmds_decision,
			HashMap<String, cmd_enum> cmd_status
			) {
		cmd_enum status = cmd_enum.UNKNOWN;
		cmds_decision = cmds_decision.replaceAll("\\(", "");
		cmds_decision = cmds_decision.replaceAll("\\)", "");
		cmds_decision = cmds_decision.trim();
		if (cmd_status.containsKey(cmds_decision)) {
			status = cmd_status.get(cmds_decision);
		}
		return status;
	}
	
	private ArrayList<String> generate_final_cmd_result(
			String cmds_decision, 
			HashMap<String, cmd_enum> cmd_status,
			String last_cmd
			) {
		ArrayList<String> return_list = new ArrayList<String>();
		cmd_enum final_status = cmd_enum.UNKNOWN;
		if (!cmds_decision_check(cmds_decision, cmd_status)) {
			final_status = get_individul_cmd_status(last_cmd, cmd_status);
			return_list.add(">Decision string wrong format:" + cmds_decision);
			return_list.add(">Format:" + "last(Default) | all | <cmd_name> | cmd_1 and/or cmd_2");
			return_list.add(">Last run command will be checked.");
			return_list.add("");
		} else if (cmds_decision.equalsIgnoreCase("last")) {
			final_status = get_individul_cmd_status(last_cmd, cmd_status);
		} else if (cmds_decision.equalsIgnoreCase("all")) {
			final_status = get_all_cmds_status(cmd_status);
		} else if (cmds_decision.contains("and") || cmds_decision.contains("or")) {
			final_status = get_logic_cmd_status(cmds_decision, cmd_status);
		} else {
			final_status = get_individul_cmd_status(cmds_decision, cmd_status);
		}
		return_list.add("<status>"+ final_status.get_description() +"</status>");
		return return_list;
	}
	
	public Object call() {
		ArrayList<String> string_list = new ArrayList<String>();
		CountDownLatch job_latch = new CountDownLatch(launch_cmds.size());
		Iterator<String> job_it = launch_cmds.keySet().iterator();
		Object parallel_lock = new Object();
		while(job_it.hasNext()) {
			String job_title = job_it.next();
			cmd_status.put(job_title, cmd_enum.UNKNOWN);
			List<String> cmd_lst = launch_cmds.get(job_title).get(cmd_attr.command);
			List<String> env_lst = launch_cmds.get(job_title).get(cmd_attr.environ);
			List<String> ctl_lst = launch_cmds.get(job_title).get(cmd_attr.exectrl);
			//Environment prepare
			HashMap<String, String> env_map = new HashMap<String, String>();
			for(String item : env_lst) {
				if (!item.contains("=")) {
					string_list.add(">Illegial environment setting:"+ job_title + "," + item);
					string_list.add(">Format:<a>=<1>;<b>=<2>@<cmd_x>");
					string_list.add(">Demo  :a=1;b=2@cmd_1");
					string_list.add("");
					continue;
				}
				String key = item.split("=", 2)[0];
				String value = item.split("=", 2)[1];
				env_map.put(key, value);
			}
			String force_cmd_env = new String("FORCE_" + job_title.toUpperCase());
			//exectrl legal check if no force cmd run.
			if(!env_map.getOrDefault(force_cmd_env, "NA").equals("1")) {
				if(!exectrl_legal_check(ctl_lst, launch_cmds.keySet())) {
					string_list.add(">>>LC:" + job_title);
					string_list.add(">Illegial exe_ctrl:" + job_title + "," + ctl_lst.toString());
					string_list.add(">It could be:");
					string_list.add(">  1:exe_ctrl required Command not in cmd list:" + launch_cmds.keySet().toString());
					string_list.add(">  2:Wrong exe_ctrl format.");
					string_list.add(">Format:(Expression)?<target_cmd1>;(Expression)?<target_cmd2>");
					string_list.add(">Demo  :(cmd_1 and cmd_2)?cmd_3");
					string_list.add(">Launch Command skipped.");
					string_list.add("");
					cmd_status.put(job_title, cmd_enum.BLOCKED);
					if(cmds_parallel) {
						job_latch.countDown();
					}
					continue;
				}			
			}
			//Run command
			if (cmds_parallel) {
				new Thread() {
					public void run() {
						ArrayList<String> result_parallel = new ArrayList<>();
						result_parallel.add(">>>LC:" + job_title);
						//force_cmd_env won't be happened here since we removed it during prepare
						if (env_map.getOrDefault(force_cmd_env, "NA").equals("1")) {
							result_parallel.add(">ENV command force on, skip exectrl check.");
							result_parallel.add(">" + force_cmd_env + ":" + env_map.get(force_cmd_env));
						} else {
							synchronized (parallel_lock) {
								while (!exectrl_ready_check(ctl_lst)) {
									result_parallel.add(">Warning:exectrl not ready, waiting...");
									try {
										parallel_lock.wait();
									} catch (InterruptedException e) {
										// TODO Auto-generated catch block
										e.printStackTrace();
									}
								}
								if (!exectrl_expression_check(ctl_lst)) {
									result_parallel.add(">exectrl=False, skip command run.");
									result_parallel.add(">exectrl:" + ctl_lst.toString());
									result_parallel.add(">cmd_status:" + cmd_status.toString());
									result_parallel.add("");
									job_latch.countDown();
									cmd_status.put(job_title, cmd_enum.UNKNOWN);
									string_list.addAll(result_parallel);
									return;
								}
							}
						}
						//run command
						last_cmd = job_title;
						try {
							result_parallel.addAll(system_cmd.run(cmd_lst, env_map, case_dir, timeout));
						} catch (Exception e) {
							// TODO Auto-generated catch block
							result_parallel.add(">Run Command failed:" + job_title);
						}
						result_parallel.add("");
						job_latch.countDown();
						synchronized (parallel_lock) {
							cmd_status.put(job_title, get_cmd_status(result_parallel));
							string_list.addAll(result_parallel);
							parallel_lock.notify();
						}
					}
				}.start();
			} else {
				ArrayList<String> result_serial = new ArrayList<>();
				result_serial.add(">>>LC:" + job_title);
				//force_cmd_env won't be happened here since we removed it during prepare
				if (env_map.getOrDefault(force_cmd_env, "NA").equals("1")) {
					result_serial.add(">ENV command force on, skip exectrl check.");
					result_serial.add(">" + force_cmd_env + ":" + env_map.get(force_cmd_env));
					result_serial.add("");
				} else {
					//exectrl ready check
					if(!exectrl_ready_check(ctl_lst)) {
						result_serial.add(">Warning:exectrl not ready, skip command run.");
						result_serial.add("");
						cmd_status.put(job_title, cmd_enum.BLOCKED);
						string_list.addAll(result_serial);
						continue;
					}
					//exectrl check
					if(!exectrl_expression_check(ctl_lst)) {
						result_serial.add(">exectrl=False, skip command run.");
						result_serial.add(">exectrl:" + ctl_lst.toString());
						result_serial.add(">cmd_status:" + cmd_status.toString());
						result_serial.add("");
						cmd_status.put(job_title, cmd_enum.UNKNOWN);
						string_list.addAll(result_serial);
						continue;
					}
				}
				//run command
				last_cmd = job_title;
				try {
					result_serial.addAll(system_cmd.run(cmd_lst, env_map, case_dir, timeout));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					result_serial.add(">Run command failed:" + job_title);
				}
				result_serial.add("");
				cmd_status.put(job_title, get_cmd_status(result_serial));
				string_list.addAll(result_serial);
			}
		}
		if(cmds_parallel) {
			try {
				job_latch.await();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				string_list.add(">InterruptedException for wait all parallel jobs.");
			}
		}
		string_list.addAll(generate_final_cmd_result(cmds_decision, cmd_status, last_cmd));
		return string_list;
	}
}