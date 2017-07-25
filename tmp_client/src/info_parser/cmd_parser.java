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
	// public static HashMap<String, String> cmd_hash = new HashMap<String, String>();
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
		// 3.3 suite file value
		if (commandline_obj.hasOption('f')) {
			cmd_hash.put("suite_file", commandline_obj.getOptionValue('f'));
		} else {
			cmd_hash.put("suite_file", "");
		}
		// 3.4 work path
		if (commandline_obj.hasOption('w')) {
			cmd_hash.put("work_path", commandline_obj.getOptionValue('w'));
		}
		// 3.5 save path
		if (commandline_obj.hasOption('s')) {
			cmd_hash.put("save_path", commandline_obj.getOptionValue('s'));
		}
		// 3.6 max threads
		if (commandline_obj.hasOption('t')) {
			cmd_hash.put("max_threads", commandline_obj.getOptionValue('t'));
		} else {
			cmd_hash.put("max_threads", "3");
		}		
		// 3.7 debug model
		if (commandline_obj.hasOption('d')) {
			cmd_hash.put("debug", "true");
		} else {
			cmd_hash.put("debug", "false");
		}
		// 3.8 help definition
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
		options_obj.addOption(Option.builder("c").longOpt("cmd").desc("Client will run in Command modle").build());
		options_obj.addOption(Option.builder("g").longOpt("gui").desc("Client will run in GUI modle").build());
		options_obj.addOption(Option.builder("l").longOpt("local").desc("Client will run in LOCAL modle").build());
		options_obj.addOption(Option.builder("r").longOpt("remote").desc("Client will run in REMOTE modle").build());
		options_obj.addOption(
				Option.builder("f").longOpt("suite-file").hasArg().desc("Test suite file for Local run").build());
		options_obj.addOption(Option.builder("w").longOpt("work-path").hasArg()
				.desc("Case run place, if not present will use current launch path").build());
		options_obj.addOption(Option.builder("s").longOpt("save-path").hasArg()
				.desc("Storage place for completed case, if not present will use current work_path").build());
		options_obj.addOption(Option.builder("t").longOpt("max-threads").hasArg()
				.desc("Client will launch multi-threads").build());		
		options_obj.addOption(Option.builder("d").longOpt("debug").desc("Client will run in debug modle").build());
		options_obj.addOption(Option.builder("h").longOpt("help").desc("Client will run in help modle").build());
		return options_obj;
	}

	/*
	 * print help message
	 */
	private void get_help(Options options_obj) {
		String usage = "java -jar tmp_client.jar -c [-l -f <file_path1,file_path2>] [-t 3] [-w <work path>] [-s <save path>]";
		String header = "Here is details:\n\n";
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