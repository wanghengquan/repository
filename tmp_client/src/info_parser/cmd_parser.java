/*
 * File: cmd_parser.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package info_parser;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Set;
import java.util.Iterator;

import org.apache.commons.cli.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.public_data;
import top_runner.run_status.exit_enum;
import utility_funcs.data_check;

/*
 * PlatUML graph
 * @startuml
 * :Hello world;
 * :This is on defined on
 * several **lines**;
 * @enduml
 */
public class cmd_parser {
	// public property
	// protected property
	// public static HashMap<String, String> cmd_hash = new HashMap<String,
	// String>();
	// private property
	private final Logger CMD_PARSER_LOGGER = LogManager.getLogger(cmd_parser.class.getName());
	private String[] args;

	public cmd_parser(String[] args) {
		this.args = args;
	}

	// public function
	/*
	 * @startuml :option definition; :option parser; :option collect;
	 * 
	 * @enduml
	 */
	public HashMap<String, String> cmdline_parser() {
		HashMap<String, String> cmd_hash = new HashMap<String, String>();
		// 1. get defined options
		Options options_obj = get_options();
		// 2. option parser
		CommandLineParser parser = new DefaultParser();
		CommandLine commandline_obj = null;
		try {
			commandline_obj = parser.parse(options_obj, args);
		} catch (ParseException e1) {
			// TODO Auto-generated catch block
			// e1.printStackTrace();
			CMD_PARSER_LOGGER.error("Command line parse Failed.");
			get_help(options_obj);
		}
		// 3. collect option results
		// 3.1 cmd or gui model
		if (commandline_obj.hasOption('c')) {
			cmd_hash.put("cmd_gui", "cmd");
		} else if (commandline_obj.hasOption('g')) {
			cmd_hash.put("cmd_gui", "gui");
		} else {
			cmd_hash.put("cmd_gui", "gui");
		}
		// 3.2 remote or local model
		if (commandline_obj.hasOption('l')) {
			cmd_hash.put("link_mode", "local");
		}
		if (commandline_obj.hasOption('r')) {
			cmd_hash.put("link_mode", "remote");
		}
		// 3.3 ignore/skip task requirements check
		if (commandline_obj.hasOption('i')) {
			cmd_hash.put("ignore_request", commandline_obj.getOptionValue('i'));
		}
		// 3.4 suite file value
		if (commandline_obj.hasOption('f')) {
			String suite_file = new String(commandline_obj.getOptionValue('f'));
			cmd_hash.put("suite_file", get_absolute_path(suite_file));
		} else {
			cmd_hash.put("suite_file", "");
		}
		// 3.5 suite path value
		if (commandline_obj.hasOption('p')) {
			String suite_path = new String(commandline_obj.getOptionValue('p'));
			cmd_hash.put("suite_path", get_absolute_path(suite_path));
		} else {
			cmd_hash.put("suite_path", "");
		}
		// 3.6 suite list file for test suites inside
		if (commandline_obj.hasOption('L')) {
			String suite_path = new String(commandline_obj.getOptionValue('L'));
			cmd_hash.put("list_file", get_absolute_path(suite_path));
		} else {
			cmd_hash.put("list_file", "");
		}		
		// 3.7 key file value
		if (commandline_obj.hasOption('k')) {
			cmd_hash.put("key_file", commandline_obj.getOptionValue('k'));
		} else {
			cmd_hash.put("key_file", "");
		}
		// 3.8 execute file value
		if (commandline_obj.hasOption('x')) {
			cmd_hash.put("exe_file", commandline_obj.getOptionValue('x'));
		} else {
			cmd_hash.put("exe_file", "");
		}
		// 3.9 arguments for execute file
		if (commandline_obj.hasOption('a')) {
			cmd_hash.put("arguments", commandline_obj.getOptionValue('a').replaceAll("\\\\", "/"));
		} else {
			cmd_hash.put("arguments", "");
		}
		// 3.10 task environments setting
		if (commandline_obj.hasOption('e')) {
			cmd_hash.put("task_environ", commandline_obj.getOptionValue('e').replaceAll("\\\\;", public_data.INTERNAL_STRING_SEMICOLON));
		} else {
			cmd_hash.put("task_environ", "");
		}
		// 3.11 client environments setting
		if (commandline_obj.hasOption('E')) {
			cmd_hash.put("client_environ", commandline_obj.getOptionValue('E').replaceAll("\\\\;", public_data.INTERNAL_STRING_SEMICOLON));
		} else {
			cmd_hash.put("client_environ", "");
		}
		// 3.12 attended/unattended mode setting
		if (commandline_obj.hasOption('A')) {
			cmd_hash.put("unattended", "0");
		}
		if (commandline_obj.hasOption('U')) {
			cmd_hash.put("unattended", "1");
		}
		// 3.13 work path
		if (commandline_obj.hasOption('w')) {
			String work_space = new String(commandline_obj.getOptionValue('w'));
			cmd_hash.put("work_space", get_absolute_path(work_space));
		}
		// 3.14 save path
		if (commandline_obj.hasOption('s')) {
			String save_space = new String(commandline_obj.getOptionValue('s'));
			cmd_hash.put("save_space", get_absolute_path(save_space));
		}
		// 3.15 max threads
		if (commandline_obj.hasOption('t')) {
			cmd_hash.put("max_threads", commandline_obj.getOptionValue('t'));
		}
		if (commandline_obj.hasOption('T')) {
			cmd_hash.put("pool_size", commandline_obj.getOptionValue('T'));
		}
		// 3.16 debug mode
		if (commandline_obj.hasOption('d')) {
			cmd_hash.put("debug", "1");
		} else {
			cmd_hash.put("debug", "0");
		}
		// 3.17 case mode
		if (commandline_obj.hasOption('K')) {
			cmd_hash.put("case_mode", "keep_case");
		}		
		if (commandline_obj.hasOption('C')) {
			cmd_hash.put("case_mode", "copy_case");
		}	
		// 3.18 case mode
		if (commandline_obj.hasOption('H')) {
			cmd_hash.put("path_keep", "true");
		}		
		if (commandline_obj.hasOption('F')) {
			cmd_hash.put("path_keep", "false");
		}	
		// 3.19 result keep value
		if (commandline_obj.hasOption('R')) {
			cmd_hash.put("result_keep", commandline_obj.getOptionValue('R'));
		}	
		// 3.20 interactive or not
		if (commandline_obj.hasOption('I')) {
			cmd_hash.put("interactive", "1");
			cmd_hash.put("cmd_gui", "cmd");
			cmd_hash.put("link_mode", "remote");
		} else {
			cmd_hash.put("interactive", "0");
		}
		// 3.21 help definition
		if (commandline_obj.hasOption('h')) {
			get_help(options_obj);
		}
		// 3.22 run sanity check
		if (!run_input_data_check(cmd_hash)){
			get_help(options_obj);
		}
		return cmd_hash;
	}

	private String get_absolute_path(
			String raw_paths){
		String [] path_list = raw_paths.split(",");
		ArrayList<String> return_list = new ArrayList<String>();
		for (String path: path_list){
			if (path.contains("$")){
				//Special path variable inside skip convert
				return_list.add(path);
				continue;
			}
			File raw_file = new File(path);
			return_list.add(raw_file.getAbsolutePath().replaceAll("\\\\", "/"));
		}
		return String.join(",", return_list);
	}
	
	private Boolean run_input_data_check(
			HashMap<String, String> cmd_hash){
		Boolean check_satus = new Boolean(true);
		Iterator<String> option_it = cmd_hash.keySet().iterator();
		while(option_it.hasNext()){
			String option_name = option_it.next();
			String option_value = cmd_hash.get(option_name);
			switch (option_name){
			case "ignore_request":
				if(!data_check.str_choice_check(option_value, new String [] {"", "all", "software", "system", "machine"} )){
					CMD_PARSER_LOGGER.error("Command line parse Failed.");
					check_satus = false;
				}
				break;
			case "max_threads":
				if (!data_check.num_scope_check(option_value, 0, public_data.PERF_POOL_MAXIMUM_SIZE)){
					CMD_PARSER_LOGGER.warn("Config file:Invalid max_threads setting");
					check_satus = false;
				}
				break;
			case "pool_size":
				if (!data_check.num_scope_check(option_value, 0, public_data.PERF_POOL_MAXIMUM_SIZE)){
					CMD_PARSER_LOGGER.warn("Config file:Invalid pool_size setting");
					check_satus = false;
				}
				break;
			case "save_space":
				if (!data_check.str_path_check(option_value)){
					CMD_PARSER_LOGGER.warn("Config file:Invalid save_space setting");
					check_satus = false;
				}
				break;
			case "work_space":
				if (!data_check.str_path_check(option_value)){
					CMD_PARSER_LOGGER.warn("Config file:Invalid work_space setting");
					check_satus = false;
				}
				break;
			default:
				break;
			}
		}
		return check_satus;
	}
	
	// protected function
	// private function
	/*
	 * return option definition
	 */
	private Options get_options() {
		Options options_obj = new Options();
		options_obj.addOption(Option.builder("c").longOpt("cmd").desc("Client will run in Command mode").build());
		options_obj.addOption(Option.builder("g").longOpt("gui").desc("Client will run in GUI mode, default mode.").build());
		options_obj.addOption(
				Option.builder("I").longOpt("console").desc("Client will run in interactive console mode").build());
		options_obj.addOption(Option.builder("l").longOpt("local").desc("Client will run in LOCAL mode").build());
		options_obj.addOption(Option.builder("r").longOpt("remote").desc("Client will run in REMOTE mode").build());
		options_obj.addOption(Option.builder("A").longOpt("attended").desc("Client will run in attended mode").build());
		options_obj.addOption(
				Option.builder("U").longOpt("unattended").desc("Client will run in unattended mode").build());
		options_obj.addOption(Option.builder("i").longOpt("ignore-request").hasArg()
				.desc("Client will ignore/skip the suite_file/task requirement(software, system, machine, all) check")
				.build());
		options_obj.addOption(Option.builder("f").longOpt("suite-file").hasArg()
				.desc("Test suite file for Local run, $unit_path represent the path to <install_path>/doc/TMP_EIT_suites, use \",\" to separate multiple suite files")
				.build());
		options_obj.addOption(Option.builder("p").longOpt("suite-path").hasArg()
				.desc("Test suite path for Local run, all test case in this folder will be run unless a list.txt in path root, use \",\" to separate multiple suite paths")
				.build());
		options_obj.addOption(Option.builder("L").longOpt("list-file").hasArg()
				.desc("Test suites list file for Local run")
				.build());
		options_obj.addOption(Option.builder("k").longOpt("key-file").hasArg()
				.desc("The key file to help client consider the path is a case path, Work with -p(suite path)")
				.build());
		options_obj.addOption(Option.builder("K").longOpt("keep-case")
				.desc("Case mode:Keep case in it's original path(depot space) and run it in that place")
				.build());
		options_obj.addOption(Option.builder("C").longOpt("copy-case")
				.desc("Case mode:Copy case to client work space and run it in this new place, Default")
				.build());
		options_obj.addOption(Option.builder("H").longOpt("hierarchical")
				.desc("Keep the original directory tree structure(which will have a potential issue about overwite results)")
				.build());
		options_obj.addOption(Option.builder("F").longOpt("flattened")
				.desc("Flatten original hierarchical path into one folder with the name of task id")
				.build());
		options_obj.addOption(Option.builder("R").longOpt("result-keep").hasArg()
				.desc("How to save the run results, available value: auto, zipped, unzipped").build());		
		options_obj.addOption(Option.builder("x").longOpt("exe-file").hasArg()
				.desc("The execute file in every case path, Work with -p(suite path)").build());
		options_obj.addOption(Option.builder("a").longOpt("arguments").hasArg()
				.desc("The arguments for execute file , Work with -x(exe_file)").build());
		options_obj.addOption(Option.builder("e").longOpt("task-environ").hasArg()
				.desc("Task level extra environment setting.").build());
		options_obj.addOption(Option.builder("E").longOpt("client-environ").hasArg()
				.desc("Client/global level extra environment setting, will affect all tasks.").build());
		options_obj.addOption(Option.builder("w").longOpt("work-space").hasArg()
				.desc("Case run place, if not present will use current launch path").build());
		options_obj.addOption(Option.builder("s").longOpt("save-space").hasArg()
				.desc("Storage place for case remote store, if not present will use current work_space").build());
		options_obj.addOption(
				Option.builder("t").longOpt("max-threads").hasArg()
				.desc("Client will launch $t threads, available value:0 ~ " + public_data.PERF_POOL_MAXIMUM_SIZE).build());
		options_obj.addOption(
				Option.builder("T").longOpt("pool-size").hasArg()
				.desc("Top size for Thread Pool initial setting, available value:0 ~ " + public_data.PERF_POOL_MAXIMUM_SIZE).build());
		options_obj.addOption(Option.builder("d").longOpt("debug").desc("Client will run in debug mode").build());
		options_obj.addOption(Option.builder("h").longOpt("help").desc("Client will run in help mode").build());
		return options_obj;
	}

	/*
	 * print help message
	 */
	private void get_help(Options options_obj) {
		String usage = "[clientc.exe|client|java -jar client.jar] [-h|-d] [-c|-g|-I] [-A|-U] [-r | -l (-f <file_path1,file_path2>|-p <dir_path1,dir_path2> -k <key_file> -x <exe_file> [-a arguments] | -L <list_file>)] [-K|-C] [-H|-F] [-e|E <env1=value1,env2=value2...>] [-i <software,system,machine>] [-t 3] [-T 6] [-w <work path>] [-s <save path>]";
		String header = "Here is the details:\n\n";
		String footer = "\nPlease report issues at Jason.Wang@latticesemi.com";
		HelpFormatter formatter = new HelpFormatter();
		formatter.printHelp(usage, header, options_obj, footer);
		System.exit(exit_enum.NORMAL.get_index());
	}

	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		cmd_parser my_parser = new cmd_parser(args);
		HashMap<String, String> cmd_data = my_parser.cmdline_parser();
		Set<String> options = cmd_data.keySet();
		Iterator<String> it = options.iterator();
		while (it.hasNext()) {
			String option_key = it.next();
			String option_value = cmd_data.get(option_key);
			System.out.println(option_key + " = " + option_value);
		}
	}
}