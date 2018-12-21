/*
 * File: main_frame.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/03/11
 * Modifier:
 * Date:
 * Description:
 */
package gui_interface;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Container;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.util.HashMap;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTabbedPane;
import javax.swing.JTextField;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.local_tube;
import connect_tube.task_data;
import data_center.client_data;
import data_center.public_data;
import utility_funcs.time_info;

public class import_dialog extends JDialog implements ChangeListener{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private task_data task_info;
	private client_data client_info;
	private JTabbedPane tabbed_pane;

	public import_dialog(
			main_frame main_view,
			client_data client_info,
			task_data task_info){
		super(main_view, "Import local tasks", true);
		//this.setTitle("Select and generate report");
		//Image icon_image = Toolkit.getDefaultToolkit().getImage(public_data.ICON_FRAME_PNG);
		//this.setIconImage(icon_image);		
		this.task_info = task_info;
		this.client_info = client_info;
		Container container = this.getContentPane();
		container.add(construct_tab_pane(), BorderLayout.CENTER);
		this.setSize(600, 350);
	}

	private JTabbedPane construct_tab_pane(){
		tabbed_pane = new JTabbedPane(JTabbedPane.TOP, JTabbedPane.SCROLL_TAB_LAYOUT);
		tabbed_pane.addChangeListener(this);
		ImageIcon icon_image_file = new ImageIcon(public_data.ICON_IMPORT_FILE);
		ImageIcon icon_image_path = new ImageIcon(public_data.ICON_IMPORT_PATH);
		// pane 1: task from suite file
		tabbed_pane.addTab("Suite File", icon_image_file, new file_pane(this, task_info, client_info), "Import task form suite File");
		// pane 2: task form suite path
		tabbed_pane.addTab("Suite Path", icon_image_path, new path_pane(this, task_info, client_info), "Import task form suite Path");
		return tabbed_pane;
	}
	
	@Override
	public void stateChanged(ChangeEvent arg0) {
		// TODO Auto-generated method stub
		int select_index = tabbed_pane.getSelectedIndex();
		tabbed_pane.setSelectedIndex(select_index);
	}
	public static void main(String[] args) {
		task_data task_info = new task_data();
		client_data client_info = new client_data();
		import_dialog sw_view = new import_dialog(null, client_info, task_info);
		sw_view.setVisible(true);
	}
}

class file_pane extends JPanel implements ActionListener{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static final Logger FILE_PANE_LOGGER = LogManager.getLogger(file_pane.class.getName());	
	private import_dialog tabbed_pane;
	private task_data task_info;
	private client_data client_info;
	private JLabel jl_user_file, jl_user_env, jl_unit_file, jl_unit_env;
	private JTextField jt_user_file, jt_user_env, jt_unit_file, jt_unit_env;
	private JButton jb_user_file, jb_unit_file;
	private JButton close, apply;
	
	public file_pane(
			import_dialog tabbed_pane, 
			task_data task_info,
			client_data client_info){
		this.tabbed_pane = tabbed_pane;
		this.task_info = task_info;
		this.client_info = client_info;
		this.setLayout(new BorderLayout());
		this.add(construct_top_panel(), BorderLayout.CENTER);
		this.add(construct_buttom_panel(), BorderLayout.SOUTH);
	}
		
	private JPanel construct_top_panel(){
		GridBagLayout part1_layout = new GridBagLayout();
		JPanel p1 = new JPanel(part1_layout);
		//step 0 : Title line
		JPanel title1 = new JPanel(new GridLayout(1,1,5,5));
		title1.add(new JLabel("User suite files inputs:"));
		title1.setBackground(Color.LIGHT_GRAY);
		p1.add(title1);
		//step 1 : user suite file import
		jl_user_file = new JLabel("User Suite:");
		jl_user_file.setToolTipText("User suite file imports.");
		jt_user_file = new JTextField("", 128);
		jb_user_file = new JButton("Select");
		jb_user_file.addActionListener(this);
		p1.add(jl_user_file);
		p1.add(jt_user_file);
		p1.add(jb_user_file);
		//step 2 : user suite extra environment import
		jl_user_env = new JLabel("Extra environ:");
		jl_user_env.setToolTipText("User extra environments setting, optional, demo:env1=value1,env2=value2");
		jt_user_env = new JTextField("", 128);
		p1.add(jl_user_env);
		p1.add(jt_user_env);
		//step 3 : Title line
		JPanel title2 = new JPanel(new GridLayout(1,1,5,5));
		title2.add(new JLabel("Unit suite files inputs:"));
		title2.setBackground(Color.LIGHT_GRAY);
		p1.add(title2);
		//step 4 : unit suite file import
		jl_unit_file = new JLabel("Unit Suite:");
		jl_unit_file.setToolTipText("Unit suite file imports.");
		jt_unit_file = new JTextField("", 128);
		jb_unit_file = new JButton("Select");
		jb_unit_file.addActionListener(this);
		p1.add(jl_unit_file);
		p1.add(jt_unit_file);
		p1.add(jb_unit_file);
		//step 5 : user suite extra environment import
		jl_unit_env = new JLabel("Extra environ:");
		jl_unit_env.setToolTipText("Unit extra environments setting, optional, demo:env1=value1,env2=value2");
		jt_unit_env = new JTextField("", 128);
		p1.add(jl_unit_env);
		p1.add(jt_unit_env);
		//layout it 
		GridBagConstraints layout_s = new GridBagConstraints();
		layout_s.fill = GridBagConstraints.BOTH;
		//for title1
		layout_s.gridwidth=0;
		layout_s.weightx = 1;
		layout_s.weighty=0.5;
		part1_layout.setConstraints(title1, layout_s);
		//for jl_user_file
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(jl_user_file, layout_s);
		//for jt_user_file
		layout_s.gridwidth=2;
		layout_s.weightx = 1;
		layout_s.weighty=0;
		part1_layout.setConstraints(jt_user_file, layout_s);
		//for jb_user_file
		layout_s.gridwidth=0;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(jb_user_file, layout_s);		
		//for jl_user_env
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(jl_user_env, layout_s);	
		//for jt_user_env
		layout_s.gridwidth=0;
		layout_s.weightx = 1;
		layout_s.weighty=0;
		part1_layout.setConstraints(jt_user_env, layout_s);		
		//for title2
		layout_s.gridwidth=0;
		layout_s.weightx = 1;
		layout_s.weighty=0.5;
		part1_layout.setConstraints(title2, layout_s);		
		//for jl_unit_file
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(jl_unit_file, layout_s);		
		//for jt_unit_file
		layout_s.gridwidth=2;
		layout_s.weightx = 1;
		layout_s.weighty=0;
		part1_layout.setConstraints(jt_unit_file, layout_s);
		//for jb_unit_file
		layout_s.gridwidth=0;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(jb_unit_file, layout_s);		
		//for jl_unit_env
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(jl_unit_env, layout_s);	
		//for jt_unit_env
		layout_s.gridwidth=0;
		layout_s.weightx = 1;
		layout_s.weighty=0;
		part1_layout.setConstraints(jt_unit_env, layout_s);			
		return p1;
	}
	
	private JPanel construct_buttom_panel(){
		GridBagLayout part1_layout = new GridBagLayout();
		JPanel p2 = new JPanel(part1_layout);
		JLabel blank_line1 = new JLabel("");
		p2.add(blank_line1);
		close = new JButton("Close");
		close.setToolTipText("Close this window");
		close.addActionListener(this);
		p2.add(close);		
		apply = new JButton("Apply");
		apply.setToolTipText("Implements the imports");
		apply.addActionListener(this);
		p2.add(apply);		
		//layout it 
		GridBagConstraints layout_s = new GridBagConstraints();
		layout_s.fill = GridBagConstraints.BOTH;
		//for blank_line1
		layout_s.gridwidth=5;
		layout_s.weightx = 1;
		layout_s.weighty=0;
		part1_layout.setConstraints(blank_line1, layout_s);		
		//for close
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(close, layout_s);
		//for apply
		layout_s.gridwidth=0;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(apply, layout_s);		
		return p2;
	}

	private void impoart_local_task_data(
			String task_file,
			String task_env){
		if (local_tube.suite_file_sanity_check(task_file)){
			FILE_PANE_LOGGER.warn("Importing suite file:" + task_file);
		} else {
			FILE_PANE_LOGGER.warn("Importing suite file failed:" + task_file);
			String title = new String("Import suite file error");
			String message = new String(local_tube.suite_file_error_msg);
			JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
			return;
		}
		String import_time_id = time_info.get_date_time();
		HashMap <String, String> task_data = new HashMap <String, String>();
		task_data.put("path", task_file);
		task_data.put("env", task_env);
		task_info.update_local_file_imported_task_map(import_time_id, task_data);
		try {
			Thread.sleep(1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub
		if(arg0.getSource().equals(jb_user_file)){
			String work_space = new String();
			if (client_info.get_client_data().containsKey("preference")) {
				work_space = client_info.get_client_preference_data().get("work_space");
			} else {
				work_space = public_data.DEF_WORK_SPACE;
			}			
			JFileChooser import_file = new JFileChooser(work_space);
			import_file.setDialogTitle("Select Test Suite File");
			int return_value = import_file.showOpenDialog(null);
			if (return_value == JFileChooser.APPROVE_OPTION) {
				File local_suite_file = import_file.getSelectedFile();
				String path = local_suite_file.getAbsolutePath().replaceAll("\\\\", "/");
				jt_user_file.setText(path);
			}
		}
		if(arg0.getSource().equals(jb_unit_file)){				
			JFileChooser import_file = new JFileChooser(public_data.DOC_EIT_PATH);
			import_file.setDialogTitle("Select Unit Suite File");
			int return_value = import_file.showOpenDialog(null);
			if (return_value == JFileChooser.APPROVE_OPTION) {
				File local_suite_file = import_file.getSelectedFile();
				String path = local_suite_file.getAbsolutePath().replaceAll("\\\\", "/");
				jt_unit_file.setText(path);
			}
		}		
		if(arg0.getSource().equals(close)){
			tabbed_pane.dispose();
		}
		if(arg0.getSource().equals(apply)){
			String link_mode = client_info.get_client_preference_data().get("link_mode");
			if (link_mode.equals("remote")){
				String title = new String("Link mode error");
				String message = new String("Client run in remote mode, cannot import local suite file. Please go and setting in \"Setting --> Preference...\"");
				JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
				return;
			}
			String user_file = jt_user_file.getText().replaceAll("\\\\", "/");
			String user_env = jt_user_env.getText().replaceAll("\\\\;", public_data.INTERNAL_STRING_SEMICOLON);
			if (user_file.length() > 0){
				impoart_local_task_data(user_file, user_env);
			}			
			String unit_file = jt_unit_file.getText().replaceAll("\\\\", "/");
			String unit_env = jt_unit_env.getText().replaceAll("\\\\;", public_data.INTERNAL_STRING_SEMICOLON);
			if (unit_file.length() > 0){
				impoart_local_task_data(unit_file, unit_env);
			}
			tabbed_pane.dispose();
		}
	}
}


class path_pane extends JPanel implements ActionListener{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static final Logger PATH_PANE_LOGGER = LogManager.getLogger(file_pane.class.getName());
	private import_dialog tabbed_pane;
	private task_data task_info;
	@SuppressWarnings("unused")
	private client_data client_info;
	private JLabel jl_suite_path, jl_key_file, jl_exe_file, jl_arguments, jl_extra_env;
	private JTextField jt_suite_path, jt_key_file, jt_exe_file, jt_arguments, jt_extra_env;
	private JButton jb_suite_path, close, apply;
	
	public path_pane(
			import_dialog tabbed_pane, 
			task_data task_info,
			client_data client_info){
		this.tabbed_pane = tabbed_pane;
		this.task_info = task_info;
		this.client_info = client_info;
		this.setLayout(new BorderLayout());
		this.add(construct_top_panel(), BorderLayout.CENTER);
		this.add(construct_buttom_panel(), BorderLayout.SOUTH);
	}
		
	private JPanel construct_top_panel(){
		GridBagLayout part1_layout = new GridBagLayout();
		JPanel p1 = new JPanel(part1_layout);
		//step 0 : Title line
		JPanel title1 = new JPanel(new GridLayout(1,1,5,5));
		title1.add(new JLabel("User suite Path inputs:"));
		title1.setBackground(Color.LIGHT_GRAY);
		p1.add(title1);
		//step 1 : user suite path import
		jl_suite_path = new JLabel("Suite Path:");
		jl_suite_path.setToolTipText("Suite path imports.");
		jt_suite_path = new JTextField("", 128);
		jb_suite_path = new JButton("Select");
		jb_suite_path.addActionListener(this);
		p1.add(jl_suite_path);
		p1.add(jt_suite_path);
		p1.add(jb_suite_path);
		//step 2 : user key file 
		jl_key_file = new JLabel("Key File:");
		jl_key_file.setToolTipText("The key file to help client consider the path is a case path");
		jt_key_file = new JTextField("", 128);
		p1.add(jl_key_file);
		p1.add(jt_key_file);
		//step 3 : user exe file
		jl_exe_file = new JLabel("EXE File:");
		jl_exe_file.setToolTipText("The execute file in every case path");
		jt_exe_file = new JTextField("", 128);
		p1.add(jl_exe_file);
		p1.add(jt_exe_file);
		//step 4 : jl_arguments
		jl_arguments = new JLabel("Arguments:");
		jl_arguments.setToolTipText("The arguments for execute file, optional");
		jt_arguments = new JTextField("", 128);
		p1.add(jl_arguments);
		p1.add(jt_arguments);		
		//step 5 : jl_extra_env
		jl_extra_env = new JLabel("Extra environ:");
		jl_extra_env.setToolTipText("Run extra environments setting, optional, demo:env1=value1,env2=value2");
		jt_extra_env = new JTextField("", 128);
		p1.add(jl_extra_env);
		p1.add(jt_extra_env);
		//layout it 
		GridBagConstraints layout_s = new GridBagConstraints();
		layout_s.fill = GridBagConstraints.BOTH;
		//for title1
		layout_s.gridwidth=0;
		layout_s.weightx = 1;
		layout_s.weighty=0.5;
		part1_layout.setConstraints(title1, layout_s);
		//for jl_suite_path
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(jl_suite_path, layout_s);
		//for jt_suite_path
		layout_s.gridwidth=3;
		layout_s.weightx = 1;
		layout_s.weighty=0;
		part1_layout.setConstraints(jt_suite_path, layout_s);
		//for jb_suite_path
		layout_s.gridwidth=0;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(jb_suite_path, layout_s);		
		//for jl_key_file
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(jl_key_file, layout_s);	
		//for jt_key_file
		layout_s.gridwidth=0;
		layout_s.weightx = 1;
		layout_s.weighty=0;
		part1_layout.setConstraints(jt_key_file, layout_s);		
		//for jl_exe_file
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(jl_exe_file, layout_s);		
		//for jt_exe_file
		layout_s.gridwidth=0;
		layout_s.weightx = 1;
		layout_s.weighty=0;
		part1_layout.setConstraints(jt_exe_file, layout_s);		
		//for jl_arguments
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(jl_arguments, layout_s);
		//for jt_arguments
		layout_s.gridwidth=0;
		layout_s.weightx = 1;
		layout_s.weighty=0;
		part1_layout.setConstraints(jt_arguments, layout_s);		
		//for jl_extra_env
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(jl_extra_env, layout_s);	
		//for jt_extra_env
		layout_s.gridwidth=0;
		layout_s.weightx = 1;
		layout_s.weighty=0;
		part1_layout.setConstraints(jt_extra_env, layout_s);			
		return p1;
	}
	
	private JPanel construct_buttom_panel(){
		GridBagLayout part1_layout = new GridBagLayout();
		JPanel p2 = new JPanel(part1_layout);
		JLabel blank_line1 = new JLabel("");
		p2.add(blank_line1);
		close = new JButton("Close");
		close.setToolTipText("Close this window");
		close.addActionListener(this);
		p2.add(close);		
		apply = new JButton("Apply");
		apply.setToolTipText("Implements the imports");
		apply.addActionListener(this);
		p2.add(apply);
		//layout it 
		GridBagConstraints layout_s = new GridBagConstraints();
		layout_s.fill = GridBagConstraints.BOTH;
		//for blank_line1
		layout_s.gridwidth=5;
		layout_s.weightx = 1;
		layout_s.weighty=0;
		part1_layout.setConstraints(blank_line1, layout_s);		
		//for close
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(close, layout_s);
		//for apply
		layout_s.gridwidth=0;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(apply, layout_s);		
		return p2;
	}

	private void impoart_local_task_data(
			String task_path,
			String task_key,
			String task_exe,
			String task_arg,
			String task_evn){
		if (local_tube.suite_path_sanity_check(task_path, task_key)){
			PATH_PANE_LOGGER.warn("Importing suite file:" + task_path);
		} else {
			PATH_PANE_LOGGER.warn("Importing suite file failed:" + task_path);
			String title = new String("Import suite file error");
			String message = new String(local_tube.suite_file_error_msg);
			JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
			return;
		}
		String import_time_id = time_info.get_date_time();
		HashMap <String, String> task_data = new HashMap <String, String>();
		task_data.put("path", task_path);
		task_data.put("key", task_key);
		task_data.put("exe", task_exe);
		task_data.put("arg", task_arg);
		task_data.put("env", task_evn);
		task_info.update_local_path_imported_task_map(import_time_id, task_data);
		try {
			Thread.sleep(1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}	
	
	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub  
		if(arg0.getSource().equals(jb_suite_path)){
			JFileChooser import_path =  new JFileChooser(public_data.DEF_WORK_SPACE);
			import_path.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);//
			import_path.setDialogTitle("Select Suite Path");
			int return_value = import_path.showOpenDialog(null);
			if (return_value == JFileChooser.APPROVE_OPTION){
				File open_path = import_path.getSelectedFile();
				String path = open_path.getAbsolutePath().replaceAll("\\\\", "/");
				jt_suite_path.setText(path);
			}	
		}		
		if(arg0.getSource().equals(close)){
			tabbed_pane.dispose();
		}
		if(arg0.getSource().equals(apply)){
			String suite_path = jt_suite_path.getText().replaceAll("\\\\", "/");
			String suite_key = jt_key_file.getText();
			String suite_exe = jt_exe_file.getText();
			String suite_arg = jt_arguments.getText();
			String suite_env = jt_extra_env.getText().replaceAll("\\\\;", public_data.INTERNAL_STRING_SEMICOLON);
			if (suite_path.length() > 0){
				impoart_local_task_data(suite_path, suite_key, suite_exe, suite_arg, suite_env);
			}
			tabbed_pane.dispose();
		}
	}
}