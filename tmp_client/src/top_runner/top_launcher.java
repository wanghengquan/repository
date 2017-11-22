/*
 * File: cmd_parser.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package top_runner;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.HashMap;
//import java.util.Scanner;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.core.config.ConfigurationSource;
import org.apache.logging.log4j.core.config.Configurator;

import connect_tube.task_data;
import data_center.client_data;
import data_center.exit_enum;
import data_center.public_data;
import data_center.switch_data;
import env_monitor.machine_sync;
import env_monitor.self_check;
import flow_control.pool_data;
import gui_interface.view_data;
import info_parser.cmd_parser;
import top_runner.run_manager.client_manager;

public class top_launcher {
	// public property
	// protected property
	// private property
	// private static final Logger TOP_LAUNCHER_LOGGER =
	// LogManager.getLogger(tmp_manager.class.getName());
	private static Logger TOP_LAUNCHER_LOGGER = null;
	// private Thread current_thread;

	public top_launcher() {

	}

	public static String get_bin_path() {
		String class_path = System.getProperty("java.class.path");
		String path_split = System.getProperty("path.separator");
		String bin_path = class_path.split(path_split)[0].replaceAll("\\\\", "/");
		if (bin_path.endsWith(".jar") || bin_path.endsWith("client") || bin_path.endsWith(".exe")
				|| bin_path.endsWith(".so")) {
			bin_path = bin_path.substring(0, bin_path.lastIndexOf("/") + 1);
		}
		File file = new File(bin_path);
		bin_path = file.getAbsolutePath().replaceAll("\\\\", "/");
		return bin_path;
	}

	private static void initial_log_config() {
		ConfigurationSource source;
		String bin_path = get_bin_path();
		System.out.println(">>>Info: SW bin path:" + bin_path);
		File bin_dobj = new File(bin_path);
		String conf_path = bin_dobj.getParentFile().toString().replaceAll("\\\\", "/") + "/conf/log4j2.xml";
		System.out.println(">>>Info: SW log config path:" + conf_path);
		File file = new File(conf_path);
		try {
			source = new ConfigurationSource(new FileInputStream(file), file);
			Configurator.initialize(null, source);
			TOP_LAUNCHER_LOGGER = LogManager.getLogger(top_launcher.class.getName());
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private static Boolean run_self_check() {
		self_check my_check = new self_check();
		return my_check.do_self_check();
	}

	private static void run_client_insts_check(
			switch_data switch_info, 
			String run_mode, 
			String unattended_mode) {
		int start_insts = switch_info.get_system_client_insts();
		System.out.println(">>>Info: " + String.valueOf(start_insts) + " TMP Client(s) launched with your account already.");
		/*
		if (run_mode.equals("cmd")) {
			if ((start_insts > 0) && (!unattended_mode.equals("1"))) {
				//both yes and no need to add 1 insts.
				//yes: add one more insts
				//no: add one since exit will decrease by default
				//switch_info.increase_system_client_insts();		
				@SuppressWarnings("resource")
				Scanner user_input = new Scanner(System.in);
				int input_count = 0;
				while (true) {
					System.out.println(">>>Info: Do you want to launch a new one? y/n");
					String user_choice = user_input.nextLine();
					if (user_choice.equals("y")) {
						break;
					}
					if (user_choice.equals("n")) {
						System.exit(exit_enum.USER.get_index());
					}
					input_count++;
					if (input_count > 9) {
						System.exit(exit_enum.USER.get_index());
					}
				}
				//user_input.close(); for future use	
			}
			switch_info.increase_system_client_insts();
		}
		*/
	}

	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		System.out.println(">>>Info: Current Version:" + public_data.BASE_CURRENTVERSION);
		System.out.println(">>>Info: Build Date:" + public_data.BASE_BUILDDATE);
		System.out.println(">>>Info: Contact Us:" + public_data.BASE_CONTACT_MAIL);
		System.out.println("");
		System.out.println(">>>Info: Launch dir:" + System.getProperty("user.dir").replaceAll("\\\\", "/"));
		initial_log_config();
		TOP_LAUNCHER_LOGGER.debug("Debug output test");
		TOP_LAUNCHER_LOGGER.info("Info output test");
		TOP_LAUNCHER_LOGGER.warn("Warn output test");
		TOP_LAUNCHER_LOGGER.error("Error output test");
		TOP_LAUNCHER_LOGGER.fatal("Fatal output test");
		// initial 1 : Get data ready
		switch_data switch_info = new switch_data();
		client_data client_info = new client_data();
		task_data task_info = new task_data();
		view_data view_info = new view_data();
		pool_data pool_info = new pool_data(public_data.PERF_POOL_MAXIMUM_SIZE);
		cmd_parser cmd_run = new cmd_parser(args);
		HashMap<String, String> cmd_info = cmd_run.cmdline_parser();
		// initial 2 : run self check
		if (!run_self_check()) {
			TOP_LAUNCHER_LOGGER.error(">>>Self check failed.");
			System.exit(exit_enum.RUNENV.get_index());
		}
		// initial 3 : run client instances check
		run_client_insts_check(switch_info, cmd_info.get("cmd_gui"), cmd_info.getOrDefault("unattended", ""));
		// initial 4 : client manager launch
		client_manager manager = new client_manager(switch_info, client_info, task_info, view_info, pool_info,
				cmd_info);
		manager.start();
		System.out.println(">>>Info: Run Machine:" + machine_sync.get_host_name());
		System.out.println(">>>Info: Run Account:" + System.getProperty("user.name"));
	}
}