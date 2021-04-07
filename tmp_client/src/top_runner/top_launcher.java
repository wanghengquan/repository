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
//import java.util.Properties;
//import java.util.Scanner;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.core.config.ConfigurationSource;
import org.apache.logging.log4j.core.config.Configurator;

import connect_tube.task_data;
import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;
import env_monitor.machine_sync;
import flow_control.post_data;
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
        if(System.getProperty("user.name").equals("ywang4")) {
            //Modified by Yin, add /tmp_client, 09/28/18
            class_path = System.getProperty("user.dir") + "/tmp_client/bin";
        }
        String path_split =  System.getProperty("path.separator");
        String bin_path = class_path.split(path_split)[0].replaceAll("\\\\", "/");
        if (bin_path.endsWith(".jar") || bin_path.endsWith("client") || bin_path.endsWith(".exe")
                || bin_path.endsWith(".so")) {
            bin_path = bin_path.substring(0, bin_path.lastIndexOf("/") + 1);
        }
        File file = new File(bin_path);
        bin_path = file.getAbsolutePath().replaceAll("\\\\", "/");
        return bin_path;
    }

	private static void initial_log_config(String bin_path) {
		ConfigurationSource source;
		File bin_dobj = new File(bin_path);
		String conf_path = bin_dobj.getParentFile().toString().replaceAll("\\\\", "/") + "/conf/log4j2.xml";
		//System.out.println(">>>Info: SW log config path:" + conf_path);
		try {
			Thread.sleep(1000);
		} catch (InterruptedException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		File file = new File(conf_path);
		try {
			source = new ConfigurationSource(new FileInputStream(file), file);
			Configurator.initialize(null, source);
			TOP_LAUNCHER_LOGGER = LogManager.getLogger(top_launcher.class.getName());
			TOP_LAUNCHER_LOGGER.debug("");
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//TOP_LAUNCHER_LOGGER.debug("Debug output testing...");
		//TOP_LAUNCHER_LOGGER.info("Info output testing...");
		//TOP_LAUNCHER_LOGGER.warn("Warn output testing...");
		//TOP_LAUNCHER_LOGGER.error("Error output testing...");
		//TOP_LAUNCHER_LOGGER.fatal("Fatal output testing...");
	}

	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		System.out.println(">>>Info: Current Version:" + public_data.BASE_CURRENTVERSION);
		System.out.println(">>>Info: Build Date:" + public_data.BASE_BUILDDATE);
		System.out.println(">>>Info: Contact us:" + public_data.BASE_DEVELOPER_MAIL);
		System.out.println("");
		String work_path = new String(System.getProperty("user.dir").replaceAll("\\\\", "/"));
		String bin_path = get_bin_path();
		System.out.println(">>>Info: Bin Path:" + bin_path);
		System.out.println(">>>Info: Launch DIR:" + work_path);
		System.out.println(">>>Info: RuntimeLog:" + work_path + "/logs/console.log");
		System.setProperty("log_path", work_path);
		// initial 0 : Get log ready
		initial_log_config(bin_path);
		// initial 1 : Get data ready
		switch_data switch_info = new switch_data();
		client_data client_info = new client_data();
		task_data task_info = new task_data();
		view_data view_info = new view_data();
		pool_data pool_info = new pool_data();
		post_data post_info = new post_data();
		cmd_parser cmd_run = new cmd_parser(args);
		HashMap<String, String> cmd_info = cmd_run.cmdline_parser();
		// initial 2 : client manager launch
		client_manager manager = new client_manager(
				switch_info, 
				client_info, 
				task_info, 
				view_info, 
				pool_info,
				cmd_info,
				post_info);
		manager.start();
		System.out.println(">>>Info: Run Machine:" + machine_sync.get_host_name());
		System.out.println(">>>Info: Run Account:" + System.getProperty("user.name"));
		int start_insts = switch_info.get_system_client_insts();
		System.out.println(">>>Info: " + String.valueOf(start_insts) + " TMP Client(s) launched with your account already.");
	}
}