/*
 * File: menu_bar.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/03/11
 * Modifier:
 * Date:
 * Description:
 */
package gui_interface;


import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;

import javax.swing.JFileChooser;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.client_data;
import data_center.switch_data;

public class menu_bar extends JMenuBar implements ActionListener{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static final Logger MENU_BAR_LOGGER = LogManager.getLogger(menu_bar.class.getName());
	private main_frame main_view;
	private switch_data switch_info;
	private client_data client_info;
	private view_data view_info;
	
	JMenuItem imports, exports, exit;
	JMenuItem view_all, view_waiting, view_processing, view_passed, view_failed, view_tbd, view_timeout;
	JMenuItem play, pause, stop;
	JMenuItem retest_all, retest_selected, retest_passed, retest_failed, retest_tbd, retest_timeout;
	JMenuItem upload, key_gen;
	JMenuItem client, software, performance;
	JMenuItem usage, about;
	
	public menu_bar(main_frame main_view, switch_data switch_info, client_data client_info, view_data view_info){
		this.main_view = main_view;
		this.switch_info = switch_info;
		this.client_info = client_info;
		this.view_info = view_info;
		this.add(construct_file_menu());
		this.add(construct_view_menu());
		this.add(construct_run_menu());
		this.add(construct_tool_menu());
		this.add(construct_setting_menu());
		this.add(construct_help_menu());
	}
	
	public menu_bar get_menu_bar(){
		return this;
	}
	
	public JMenu construct_file_menu(){
		JMenu file = new JMenu("File");
		imports = new JMenuItem("Import...");
		imports.addActionListener(this);
		file.add(imports);
		exports = new JMenuItem("Export...");
		exports.addActionListener(this);
		file.add(exports);		
		file.addSeparator();	
		exit = new JMenuItem("Exit");
		exit.addActionListener(this);
		file.add(exit);
		return file;
	}
	
	public JMenu construct_view_menu(){
		JMenu view = new JMenu("View");
		view_all = new JMenuItem("All");
		view_all.addActionListener(this);
		view_waiting = new JMenuItem("Waiting");
		view_waiting.addActionListener(this);		
		view_processing = new JMenuItem("Processing");
		view_processing.addActionListener(this);
		view_passed = new JMenuItem("Passed");
		view_passed.addActionListener(this);
		view_failed = new JMenuItem("Failed");
		view_failed.addActionListener(this);		
		view_tbd = new JMenuItem("TBD");
		view_tbd.addActionListener(this);		
		view_timeout = new JMenuItem("Timeout");
		view_timeout.addActionListener(this);
		view.add(view_all);	
		view.add(view_waiting);	
		view.add(view_processing);	
		view.add(view_failed);
		view.add(view_passed);	
		view.add(view_tbd);
		view.add(view_timeout);
		return view;
	}
	
	public JMenu construct_run_menu(){
		JMenu run = new JMenu("Run");
		play = new JMenuItem("Play");
		play.addActionListener(this);
		pause = new JMenuItem("Pause");
		pause.addActionListener(this);
		stop = new JMenuItem("Stop");
		stop.addActionListener(this);
		run.add(play);
		run.add(pause);	
		run.add(stop);
		JMenu retest = new JMenu("Rtest...");
		retest_all = new JMenuItem("All");
		retest_all.addActionListener(this);
		retest_selected = new JMenuItem("Selected");
		retest_selected.addActionListener(this);
		retest_failed = new JMenuItem("Failed");
		retest_failed.addActionListener(this);
		retest_passed = new JMenuItem("Passed");
		retest_passed.addActionListener(this);
		retest_tbd = new JMenuItem("TBD");
		retest_tbd.addActionListener(this);		
		retest_timeout = new JMenuItem("Timeout");
		retest_timeout.addActionListener(this);
		retest.add(retest_all);
		retest.add(retest_selected);
		retest.add(retest_failed);
		retest.add(retest_passed);
		retest.add(retest_tbd);
		retest.add(retest_timeout);
		run.addSeparator();
		run.add(retest);
		return run;
	}
	
	public JMenu construct_tool_menu(){
		JMenu tools = new JMenu("Tools");
		upload = new JMenuItem("Upload...");
		upload.addActionListener(this);
		key_gen = new JMenuItem("Keygen...");
		key_gen.addActionListener(this);
		tools.add(upload);
		tools.add(key_gen);
		return tools;
	}
	
	public JMenu construct_setting_menu(){
		JMenu setting = new JMenu("Setting");
		client = new JMenuItem("Client...");
		client.addActionListener(this);
		software = new JMenuItem("Software...");
		software.addActionListener(this);
		performance = new JMenuItem("Performance...");
		performance.addActionListener(this);
		setting.add(client);
		setting.add(software);
		setting.add(performance);
		return setting;
	}
	
	public JMenu construct_help_menu(){
		JMenu help = new JMenu("Help");
		usage = new JMenuItem("Usage...");
		usage.addActionListener(this);
		about = new JMenuItem("About...");
		about.addActionListener(this);
		help.add(usage);
		help.addSeparator();
		help.add(about);
		return help;
	}

	@Override
	public void actionPerformed(ActionEvent e) {
		// TODO Auto-generated method stub
		if(e.getSource().equals(imports)){
			JFileChooser import_file =  new JFileChooser(System.getProperty("user.dir")); 
			import_file.setDialogTitle("Select Test Suite file");
			int return_value = import_file.showOpenDialog(null);
			if (return_value == JFileChooser.APPROVE_OPTION){
				File local_suite_file = import_file.getSelectedFile();
				String path = local_suite_file.getAbsolutePath().replaceAll("\\\\", "/");
				switch_info.set_suite_file(path);
				MENU_BAR_LOGGER.warn("Importing suite file:" + switch_info.get_suite_file());
			}
		}
		if(e.getSource().equals(exports)){
			MENU_BAR_LOGGER.warn("Export clicked");
		}		
		if(e.getSource().equals(exit)){
			System.exit(0);
		}
		if(e.getSource().equals(view_all)){
			MENU_BAR_LOGGER.warn("view_all clicked");
			view_info.set_watching_queue_area("all");
		}
		if(e.getSource().equals(view_waiting)){
			MENU_BAR_LOGGER.warn("view_waiting clicked");
			view_info.set_watching_queue_area("waiting");
		}		
		if(e.getSource().equals(view_processing)){
			MENU_BAR_LOGGER.warn("view_processing clicked");
			view_info.set_watching_queue_area("processing");
		}
		if(e.getSource().equals(view_passed)){
			MENU_BAR_LOGGER.warn("view_passed clicked");
			view_info.set_watching_queue_area("passed");
		}		
		if(e.getSource().equals(view_failed)){
			MENU_BAR_LOGGER.warn("view_failed clicked");
			view_info.set_watching_queue_area("failed");
		}
		if(e.getSource().equals(view_tbd)){
			MENU_BAR_LOGGER.warn("view_tbd clicked");
			view_info.set_watching_queue_area("tbd");
		}
		if(e.getSource().equals(view_timeout)){
			MENU_BAR_LOGGER.warn("view_timeout clicked");
			view_info.set_watching_queue_area("timeout");
		}		
		if(e.getSource().equals(play)){
			MENU_BAR_LOGGER.warn("play clicked");
			view_info.set_run_action_request("processing");
		}
		if(e.getSource().equals(pause)){
			MENU_BAR_LOGGER.warn("pause clicked");
			view_info.set_run_action_request("pause");
		}
		if(e.getSource().equals(stop)){
			MENU_BAR_LOGGER.warn("stop clicked");
			view_info.set_run_action_request("stop");
		}
		if(e.getSource().equals(retest_all)){
			MENU_BAR_LOGGER.warn("retest_all clicked");
			view_info.set_retest_queue_area("all");
		}
		if(e.getSource().equals(retest_selected)){
			MENU_BAR_LOGGER.warn("retest_selected clicked");
			view_info.set_retest_queue_area("selected");
		}
		if(e.getSource().equals(retest_passed)){
			MENU_BAR_LOGGER.warn("retest_passed clicked");
			view_info.set_retest_queue_area("passed");
		}	
		if(e.getSource().equals(retest_failed)){
			MENU_BAR_LOGGER.warn("retest_failed clicked");
			view_info.set_retest_queue_area("failed");
		}
		if(e.getSource().equals(retest_tbd)){
			MENU_BAR_LOGGER.warn("retest_tbd clicked");
			view_info.set_retest_queue_area("tbd");
		}
		if(e.getSource().equals(retest_timeout)){
			MENU_BAR_LOGGER.warn("retest_timeout clicked");
			view_info.set_retest_queue_area("timeout");
		}
		if(e.getSource().equals(upload)){
			MENU_BAR_LOGGER.warn("upload clicked");
			new upload_dialog(client_info).setVisible(true);
		}
		if(e.getSource().equals(key_gen)){
			new encode_dialog(main_view).setVisible(true);
		}
		if(e.getSource().equals(client)){
			new client_dialog(main_view).setVisible(true);
		}
		if(e.getSource().equals(software)){
			new software_dialog(main_view).setVisible(true);
		}
		if(e.getSource().equals(performance)){
			new performance(main_view).setVisible(true);
		}
		if(e.getSource().equals(usage)){
			MENU_BAR_LOGGER.warn("usage clicked");
		}	
		if(e.getSource().equals(about)){
			MENU_BAR_LOGGER.warn("about clicked");
		}
	}
}