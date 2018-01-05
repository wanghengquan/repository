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

import java.util.HashMap;
import java.util.Set;
import java.util.Iterator;

import org.apache.commons.cli.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.exit_enum;

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
			cmd_hash.put("suite_file", commandline_obj.getOptionValue('f').replaceAll("\\\\", "/"));
		} else {
			cmd_hash.put("suite_file", "");
		}
		// 3.5 suite path value
		if (commandline_obj.hasOption('p')) {
			cmd_hash.put("suite_path", commandline_obj.getOptionValue('p').replaceAll("\\\\", "/"));
		} else {
			cmd_hash.put("suite_path", "");
		}
		// 3.6 key file value
		if (commandline_obj.hasOption('k')) {
			cmd_hash.put("key_file", commandline_obj.getOptionValue('k'));
		} else {
			cmd_hash.put("key_file", "");
		}
		// 3.7 execute file value
		if (commandline_obj.hasOption('x')) {
			cmd_hash.put("exe_file", commandline_obj.getOptionValue('x'));
		} else {
			cmd_hash.put("exe_file", "");
		}
		// 3.8 arguments for execute file
		if (commandline_obj.hasOption('a')) {
			cmd_hash.put("arguments", commandline_obj.getOptionValue('a').replaceAll("\\\\", "/"));
		} else {
			cmd_hash.put("arguments", "");
		}
		// 3.9 task environments setting
		if (commandline_obj.hasOption('e')) {
			cmd_hash.put("task_environ", commandline_obj.getOptionValue('e'));
		} else {
			cmd_hash.put("task_environ", "");
		}
		// 3.10 client environments setting
		if (commandline_obj.hasOption('E')) {
			cmd_hash.put("client_environ", commandline_obj.getOptionValue('E'));
		} else {
			cmd_hash.put("client_environ", "");
		}
		// 3.11 attended/unattended mode setting
		if (commandline_obj.hasOption('A')) {
			cmd_hash.put("unattended", "0");
		}
		if (commandline_obj.hasOption('U')) {
			cmd_hash.put("unattended", "1");
		}
		// 3.12 work path
		if (commandline_obj.hasOption('w')) {
			cmd_hash.put("work_space", commandline_obj.getOptionValue('w').replaceAll("\\\\", "/"));
		}
		// 3.13 save path
		if (commandline_obj.hasOption('s')) {
			cmd_hash.put("save_space", commandline_obj.getOptionValue('s').replaceAll("\\\\", "/"));
		}
		// 3.14 max threads
		if (commandline_obj.hasOption('t')) {
			cmd_hash.put("max_threads", commandline_obj.getOptionValue('t'));
		}
		// 3.15 debug mode
		if (commandline_obj.hasOption('d')) {
			cmd_hash.put("debug", "true");
		} else {
			cmd_hash.put("debug", "false");
		}
		// 3.16 case mode
		if (commandline_obj.hasOption('K')) {
			cmd_hash.put("case_mode", "keep_case");
		}		
		if (commandline_obj.hasOption('C')) {
			cmd_hash.put("case_mode", "copy_case");
		}	
		// 3.17 case mode
		if (commandline_obj.hasOption('H')) {
			cmd_hash.put("structure", "true");
		}		
		if (commandline_obj.hasOption('F')) {
			cmd_hash.put("structure", "false");
		}		
		// 3.16 help definition
		if (commandline_obj.hasOption('h')) {
			get_help(options_obj);
		}
		return cmd_hash;
	}

	// protected function
	// private function
	/*
	 * return option definition
	 */
	private Options get_options() {
		Options options_obj = new Options();
		options_obj.addOption(Option.builder("c").longOpt("cmd").desc("Client will run in Command mode").build());
		options_obj.addOption(
				Option.builder("g").longOpt("gui").desc("Client will run in GUI mode, default mode.").build());
		options_obj.addOption(Option.builder("l").longOpt("local").desc("Client will run in LOCAL mode").build());
		options_obj.addOption(Option.builder("r").longOpt("remote").desc("Client will run in REMOTE mode").build());
		options_obj.addOption(Option.builder("A").longOpt("attended").desc("Client will run in attended mode").build());
		options_obj.addOption(
				Option.builder("U").longOpt("unattended").desc("Client will run in unattended mode").build());
		options_obj.addOption(Option.builder("i").longOpt("ignore-request").hasArg()
				.desc("Client will ignore/skip the suite_file/task requirement(software, system, machine) check")
				.build());
		options_obj.addOption(Option.builder("f").longOpt("suite-file").hasArg()
				.desc("Test suite file for Local run, $unit_path represent the path to <install_path>/doc/TMP_EIT_suites")
				.build());
		options_obj.addOption(Option.builder("p").longOpt("suite-path").hasArg()
				.desc("Test suite path for Local run, all test case in this folder will be run unless a list.txt in path root")
				.build());
		options_obj.addOption(Option.builder("k").longOpt("key-file").hasArg()
				.desc("The key file to help client consider the path is a case path, Work with -p(suite path)")
				.build());
		options_obj.addOption(Option.builder("K").longOpt("keep-case")
				.desc("Case mode:Keep case in it's original path(depot space) and run it in that place")
				.build());
		options_obj.addOption(Option.builder("C").longOpt("copy-case")
				.desc("Case mode:Copy case to client work space and run it in this new place")
				.build());
		options_obj.addOption(Option.builder("H").longOpt("hierarchical")
				.desc("Keep the original directory tree structure(which will have a potential issue about overwite results)")
				.build());
		options_obj.addOption(Option.builder("F").longOpt("flattened")
				.desc("Flatten original test suite into one by one in the same folder")
				.build());
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
				Option.builder("t").longOpt("max-threads").hasArg().desc("Client will launch $t threads").build());
		options_obj.addOption(Option.builder("d").longOpt("debug").desc("Client will run in debug mode").build());
		options_obj.addOption(Option.builder("h").longOpt("help").desc("Client will run in help mode").build());
		return options_obj;
	}

	/*
	 * print help message
	 */
	private void get_help(Options options_obj) {
		String usage = "[clientc.exe|client|java -jar client.jar] [-c|-g] [-A|-U] [-r | -l (-f <file_path1,file_path2>|-p <dir_path1,dir_path2> -k <key_file> -x <exe_file> [-a arguments])] [-K|-C] [-H|-F] [-e|E <env1=value1,env2=value2...>] [-i <software,system,machine>] [-t 3] [-w <work path>] [-s <save path>]";
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