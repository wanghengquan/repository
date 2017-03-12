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

import data_center.switch_data;

public class menu_bar extends JMenuBar implements ActionListener{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static final Logger MENU_BAR_LOGGER = LogManager.getLogger(menu_bar.class.getName());
	private main_frame main_view;
	private switch_data switch_info;
	
	JMenuItem imports, exit;
	JMenuItem play, pause, stop;
	JMenuItem retest_all, retest_selected, retest_passed, retest_failed, retest_timeout;
	JMenuItem upload, key_gen;
	JMenuItem client, software, performance;
	JMenuItem usage, about;
	
	public menu_bar(main_frame main_view, switch_data switch_info){
		this.main_view = main_view;
		this.switch_info = switch_info;
		this.add(construct_file_menu());
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
		imports = new JMenuItem("Imports");
		imports.addActionListener(this);
		file.add(imports);
		file.addSeparator();	
		exit = new JMenuItem("Exit");
		exit.addActionListener(this);
		file.add(exit);
		return file;
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
		JMenu retest = new JMenu("Rtest");
		retest_all = new JMenuItem("All");
		retest_all.addActionListener(this);
		retest_selected = new JMenuItem("Selected");
		retest_selected.addActionListener(this);
		retest_failed = new JMenuItem("Failed");
		retest_failed.addActionListener(this);
		retest_passed = new JMenuItem("Passed");
		retest_passed.addActionListener(this);
		retest_timeout = new JMenuItem("Timeout");
		retest_timeout.addActionListener(this);
		retest.add(retest_all);
		retest.add(retest_selected);
		retest.add(retest_failed);
		retest.add(retest_passed);
		retest.add(retest_timeout);
		run.add(retest);
		return run;
	}
	
	public JMenu construct_tool_menu(){
		JMenu tools = new JMenu("Tools");
		upload = new JMenuItem("Up Load");
		upload.addActionListener(this);
		key_gen = new JMenuItem("Key Gen");
		key_gen.addActionListener(this);
		tools.add(upload);
		tools.add(key_gen);
		return tools;
	}
	
	public JMenu construct_setting_menu(){
		JMenu setting = new JMenu("Setting");
		client = new JMenuItem("Client");
		client.addActionListener(this);
		software = new JMenuItem("Software");
		software.addActionListener(this);
		performance = new JMenuItem("Performance");
		performance.addActionListener(this);
		setting.add(client);
		setting.add(software);
		setting.add(performance);
		return setting;
	}
	
	public JMenu construct_help_menu(){
		JMenu help = new JMenu("Help");
		help.add("Usage");
		usage = new JMenuItem("Usage");
		usage.addActionListener(this);
		about = new JMenuItem("About");
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
		if(e.getSource().equals(exit)){
			System.exit(0);
		}
		if(e.getSource().equals(play)){
			
		}
		if(e.getSource().equals(pause)){
			
		}
		if(e.getSource().equals(stop)){
			
		}
		if(e.getSource().equals(retest_all)){
			
		}
		if(e.getSource().equals(retest_selected)){
			
		}
		if(e.getSource().equals(retest_passed)){
			
		}	
		if(e.getSource().equals(retest_failed)){
			
		}	
		if(e.getSource().equals(retest_timeout)){
			
		}
		if(e.getSource().equals(upload)){
			
		}
		if(e.getSource().equals(key_gen)){
			
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
			
		}	
		if(e.getSource().equals(about)){
			
		}
	}
}