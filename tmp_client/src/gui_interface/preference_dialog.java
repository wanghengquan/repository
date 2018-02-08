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

import java.awt.Color;
import java.awt.Container;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.swing.ButtonGroup;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JTextField;
import javax.swing.SwingUtilities;

import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;
import flow_control.pool_data;

public class preference_dialog extends JDialog implements ActionListener, Runnable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private switch_data switch_info;
	private client_data client_info;
	private pool_data pool_info;
	private JPanel preference_panel;
	private JLabel jl_link_mode, jl_max_threads, jl_task_assign, jl_case_mode, jl_ignore_request, jl_work_path, jl_save_path;
	private JRadioButton link_both, link_remote, link_local, thread_auto, thread_manual, task_auto, task_serial, task_parallel, keep_case, copy_case;
	private JCheckBox path_keep, ignore_software, ignore_system, ignore_machine;
	private JTextField thread_text, jt_work_path, jt_save_path;
	private JButton discard, apply, close;

	public preference_dialog(main_frame main_view, switch_data switch_info, pool_data pool_info, client_data client_info){
		super(main_view, "Preference Setting", true);
		this.client_info = client_info;
		this.pool_info = pool_info;
		this.switch_info = switch_info;
		Container container = this.getContentPane();
		container.add(construct_preference_panel());
		//this.setLocation(800, 500);
		//this.setLocationRelativeTo(main_view);
		this.setSize(650, 400);
	}
	
	private JPanel construct_preference_panel(){
		HashMap<String, String> preference_data = new HashMap<String, String>();
		preference_data.putAll(client_info.get_client_preference_data());
		preference_panel = new JPanel(new GridLayout(9,1,5,5));
		//step 0 : Title line
		JPanel jp_title = new JPanel(new GridLayout(1,1,5,5));
		jp_title.add(new JLabel("Preference items:"));
		jp_title.setBackground(Color.LIGHT_GRAY);
		//step 1 :input 1th line
		JPanel jp_center1 = new JPanel(new GridLayout(1,4,5,5));
		jl_link_mode = new JLabel("Link Server:");
		jl_link_mode.setToolTipText("Client connect server select.");
		link_both = new JRadioButton("Both");
		link_remote = new JRadioButton("Remote");
		link_local = new JRadioButton("Local");		
		initial_link_default_value(preference_data.get("link_mode"));
		ButtonGroup link_group = new ButtonGroup();
		link_group.add(link_both);
		link_group.add(link_remote);
		link_group.add(link_local);
		jp_center1.add(jl_link_mode);
		jp_center1.add(link_both);
		jp_center1.add(link_remote);
		jp_center1.add(link_local);
		//step 2 : input 2th line
		JPanel jp_center2 = new JPanel(new GridLayout(1,4,5,5));
		jl_max_threads = new JLabel("Max Threads:");
		jl_max_threads.setToolTipText("Maximum thread number launched for task/case run(one thread for one task/case)");
		thread_auto = new JRadioButton("Auto");
		thread_manual = new JRadioButton("Manually");
		thread_text = new JTextField(preference_data.get("max_threads"));
		initial_thread_default_value(preference_data.get("thread_mode"));
		ButtonGroup thread_group = new ButtonGroup();
		thread_group.add(thread_auto);
		thread_group.add(thread_manual);
		jp_center2.add(jl_max_threads);
		jp_center2.add(thread_auto);
		jp_center2.add(thread_manual);
		jp_center2.add(thread_text);
		//step 3 : input 3th line
		JPanel jp_center3 = new JPanel(new GridLayout(1,4,5,5));
		jl_task_assign = new JLabel("Task Assign:");
		jl_task_assign.setToolTipText("The method for Client processing available task queues.");
		task_auto = new JRadioButton("Auto");
		task_serial = new JRadioButton("Serial");
		task_parallel = new JRadioButton("Parallel");
		initial_task_default_value(preference_data.get("task_mode"));
		ButtonGroup task_group = new ButtonGroup();
		task_group.add(task_auto);
		task_group.add(task_serial);
		task_group.add(task_parallel);
		jp_center3.add(jl_task_assign);
		jp_center3.add(task_auto);
		jp_center3.add(task_serial);
		jp_center3.add(task_parallel);
		//step 4 : input 4th
		JPanel jp_center4 = new JPanel(new GridLayout(1,4,5,5));
		jl_case_mode = new JLabel("Case Mode:");
		jl_case_mode.setToolTipText("The method for Client processing case, copy first or just run in that place.");
		keep_case = new JRadioButton("Keep Case");
		copy_case = new JRadioButton("Copy Case");
		ButtonGroup case_group = new ButtonGroup();
		case_group.add(keep_case);
		case_group.add(copy_case);
		path_keep = new JCheckBox("Keep Structure");
		initial_case_default_value(preference_data.get("case_mode"), preference_data.get("path_keep"));
		jp_center4.add(jl_case_mode);
		jp_center4.add(keep_case);
		jp_center4.add(copy_case);
		jp_center4.add(path_keep);
		//step 5 : input 5th 
		JPanel jp_center5 = new JPanel(new GridLayout(1,4,5,5));
		jl_ignore_request = new JLabel("Ignore Request:");
		jl_ignore_request.setToolTipText("Client will ignore/skip the task requirements check.");
		ignore_software = new JCheckBox("Software");
		ignore_system = new JCheckBox("System");
		ignore_machine = new JCheckBox("Machine");
		initial_ignore_default_value(preference_data.get("ignore_request"));
		jp_center5.add(jl_ignore_request);
		jp_center5.add(ignore_software);
		jp_center5.add(ignore_system);
		jp_center5.add(ignore_machine);		
		//step 6 : input 6th line
		GridBagLayout input6_layout = new GridBagLayout();
		JPanel jp_center6 = new JPanel(input6_layout);
		jl_work_path = new JLabel("Work Space:");
		jl_work_path.setToolTipText("Client will export task case in this place and run here.");
		jt_work_path = new JTextField(preference_data.get("work_space"));
		jp_center6.add(jl_work_path);
		jp_center6.add(jt_work_path);
		GridBagConstraints input6_s = new GridBagConstraints();
		//for jl_work_path
		input6_s.fill = GridBagConstraints.BOTH;
		input6_s.gridwidth=1;
		input6_s.weightx = 0;
		input6_s.weighty=0;
		input6_layout.setConstraints(jl_work_path, input6_s);	
		//for jt_work_path
		input6_s.gridwidth=0;
		input6_s.weightx = 1;
		input6_s.weighty=0;
		input6_layout.setConstraints(jt_work_path, input6_s);		
		//step 7 : input 7th line
		GridBagLayout input7_layout = new GridBagLayout();
		JPanel jp_center7 = new JPanel(input7_layout);
		jl_save_path = new JLabel("Save Space:");
		jl_save_path.setToolTipText("Client try to copy task case to this place, if same as \"Work Space\" client will skip copy action.");
		jt_save_path = new JTextField(preference_data.get("save_space"));
		jp_center7.add(jl_save_path);
		jp_center7.add(jt_save_path);
		GridBagConstraints input7_s = new GridBagConstraints();
		//for jl_work_path
		input7_s.fill = GridBagConstraints.BOTH;
		input7_s.gridwidth=1;
		input7_s.weightx = 0;
		input7_s.weighty=0;
		input7_layout.setConstraints(jl_save_path, input7_s);	
		//for jt_work_path
		input7_s.gridwidth=0;
		input7_s.weightx = 1;
		input7_s.weighty=0;
		input7_layout.setConstraints(jt_save_path, input7_s);		
		//Step 3 : bottom line
		JPanel jp_bottom = new JPanel(new GridLayout(1,4,5,10));
		discard = new JButton("Discard");
		discard.addActionListener(this);
		apply = new JButton("Apply");
		apply.addActionListener(this);
		close = new JButton("Close");
		close.addActionListener(this);		
		jp_bottom.add(discard);
		jp_bottom.add(new JLabel(""));
		jp_bottom.add(apply);
		jp_bottom.add(close);
		//final package
		preference_panel.add(jp_title);
		preference_panel.add(jp_center1);
		preference_panel.add(jp_center2);
		preference_panel.add(jp_center3);
		preference_panel.add(jp_center4);
		preference_panel.add(jp_center5);
		preference_panel.add(jp_center6);
		preference_panel.add(jp_center7);
		preference_panel.add(jp_bottom);
		return preference_panel;
	}

	private void initial_link_default_value(String link_mode){
		switch(link_mode){
		case "both":
			link_both.setSelected(true);
			link_remote.setSelected(false);
			link_local.setSelected(false);
			break;
		case "remote":
			link_both.setSelected(false);
			link_remote.setSelected(true);
			link_local.setSelected(false);
			break;
		case "local":
			link_both.setSelected(false);
			link_remote.setSelected(false);
			link_local.setSelected(true);
			break;
		default:
			link_both.setSelected(false);
			link_remote.setSelected(false);
			link_local.setSelected(false);			
		}
	}
	
	private void initial_thread_default_value(String thread_mode){
		if(thread_mode.equals("auto")){
			thread_auto.setSelected(true);
			thread_manual.setSelected(false);
			thread_text.setEnabled(false);
		} else {
			thread_auto.setSelected(false);
			thread_manual.setSelected(true);
			thread_text.setEnabled(true);			
		}
	}
	
	private void initial_case_default_value(String case_mode, String keep_structure){
		if(case_mode.equalsIgnoreCase("keep_case")){
			keep_case.setSelected(true);
			copy_case.setSelected(false);
			path_keep.setEnabled(false);
		} else {
			keep_case.setSelected(false);
			copy_case.setSelected(true);
			path_keep.setEnabled(true);
			if (keep_structure.equalsIgnoreCase("true")){
				path_keep.setSelected(true);
			} else {
				path_keep.setSelected(false);
			}
		}
		
	}
	
	private void initial_ignore_default_value(String ignore_request){
		if (ignore_request.contains("machine")){
			ignore_machine.setSelected(true);
		} else {
			ignore_machine.setSelected(false);
		}
		if (ignore_request.contains("system")){
			ignore_system.setSelected(true);
		} else {
			ignore_system.setSelected(false);
		}
		if (ignore_request.contains("software")){
			ignore_software.setSelected(true);
		} else {
			ignore_software.setSelected(false);
		}		
	}
	
	private void initial_task_default_value(String task_mode){
		switch(task_mode){
		case "auto":
			task_auto.setSelected(true);
			task_serial.setSelected(false);
			task_parallel.setSelected(false);
			break;
		case "serial":
			task_auto.setSelected(false);
			task_serial.setSelected(true);
			task_parallel.setSelected(false);
			break;
		case "parallel":
			task_auto.setSelected(false);
			task_serial.setSelected(false);
			task_parallel.setSelected(true);
			break;
		default:
			task_auto.setSelected(false);
			task_serial.setSelected(false);
			task_parallel.setSelected(false);
		}
	}	
	
	private int get_srting_int(String str) {
		int i = -1;
		try {
			Pattern p = Pattern.compile("^(\\d+)$");
			Matcher m = p.matcher(str);
			if (m.find()) {
				i = Integer.valueOf(m.group(1));
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}
		return i;
	}
	
	@Override
	public void actionPerformed(ActionEvent arg0) {		
		// TODO Auto-generated method stub
		HashMap<String, String> preference_data = new HashMap<String, String>();
		preference_data.putAll(client_info.get_client_preference_data());
		if(arg0.getSource().equals(discard)){
			initial_link_default_value(preference_data.get("link_mode"));
			initial_thread_default_value(preference_data.get("thread_mode"));
			initial_task_default_value(preference_data.get("task_mode"));
			initial_ignore_default_value(preference_data.get("ignore_request"));
			thread_text.setText(preference_data.get("max_threads"));
			jt_work_path.setText(preference_data.get("work_space"));
			jt_save_path.setText(preference_data.get("save_space"));
		}
		if (arg0.getSource().equals(close)) {
			this.dispose();		
		}
		if(arg0.getSource().equals(apply)){
			//link mode
			if(link_both.isSelected()){
				preference_data.put("link_mode", "both");
			} else if (link_remote.isSelected()){
				preference_data.put("link_mode", "remote");
			} else {
				preference_data.put("link_mode", "local");
			}
			//thread mode
			if(thread_auto.isSelected()){
				preference_data.put("thread_mode", "auto");
			} else {
				preference_data.put("thread_mode", "manual");
				int new_value = get_srting_int(thread_text.getText());
				if (new_value < 0 || new_value > public_data.PERF_POOL_MAXIMUM_SIZE){
					String message = new String("Client accept value: 0 ~ " + String.valueOf(public_data.PERF_POOL_MAXIMUM_SIZE));
					JOptionPane.showMessageDialog(null, message, "Wrong import value:", JOptionPane.INFORMATION_MESSAGE);
					return;
				}
				pool_info.set_pool_current_size(new_value);
				preference_data.put("max_threads", String.valueOf(new_value));//dup for download data to config file
			}
			//task mode
			if(task_auto.isSelected()){
				preference_data.put("task_mode", "auto");
			} else if (task_serial.isSelected()){
				preference_data.put("task_mode", "serial");
			} else {
				preference_data.put("task_mode", "parallel");
			}
			//case mode
			if(keep_case.isSelected()){
				preference_data.put("case_mode", "keep_case");
			} else {
				preference_data.put("case_mode", "copy_case");
				if(path_keep.isSelected()){
					preference_data.put("path_keep", "true");
				} else {
					preference_data.put("path_keep", "false");
				}
			}
			//ignore request
			ArrayList<String> ignore_list = new ArrayList<String>();
			if (ignore_machine.isSelected()){
				ignore_list.add("machine");
			}
			if (ignore_system.isSelected()){
				ignore_list.add("system");
			}
			if (ignore_software.isSelected()){
				ignore_list.add("software");
			}
			preference_data.put("ignore_request", String.join(",", ignore_list));
			//work space
			if(jt_work_path.getText().trim().equals("")){
				String message = new String("Empty work space found.");
				JOptionPane.showMessageDialog(null, message, "Wrong import value:", JOptionPane.INFORMATION_MESSAGE);
				return;				
			} else {
				File work_dobj = new File(jt_work_path.getText().trim());
				String message = new String("work space Not Exists.");
				if(work_dobj.exists()){
					preference_data.put("work_space", jt_work_path.getText().trim().replaceAll("\\\\", "/"));
				} else {
					JOptionPane.showMessageDialog(null, message, "Wrong import value:", JOptionPane.INFORMATION_MESSAGE);
					return;					
				}
			}
			// save space
			String save_space = new String();
			if (jt_save_path.getText().trim().equals("")) {
				save_space = jt_work_path.getText().trim().replaceAll("\\\\", "/");
			} else {
				save_space = jt_save_path.getText().trim().replaceAll("\\\\", "/");
			}
			File save_dobj = new File(save_space);
			String message = new String("save space Not Exists.");
			if (save_dobj.exists()) {
				preference_data.put("save_space", save_space);
			} else {
				JOptionPane.showMessageDialog(null, message, "Wrong import value:", JOptionPane.INFORMATION_MESSAGE);
				return;
			}
			//input data
			client_info.set_client_preference_data(preference_data);
			switch_info.set_client_updated();
		}		
	}

	@Override
	public void run() {
		// TODO Auto-generated method stub
		while (true) {	
			if (SwingUtilities.isEventDispatchThread()) {
				if(thread_manual.isSelected() && !thread_text.isEnabled()){
					thread_text.setEnabled(true);
					thread_text.setText(String.valueOf(pool_info.get_pool_current_size()));
				}
				if(thread_auto.isSelected() && thread_text.isEnabled()){
					thread_text.setEnabled(false);
				}
				if(copy_case.isSelected() && !path_keep.isEnabled()){
					path_keep.setEnabled(true);
					if (client_info.get_client_preference_data().get("path_keep").equalsIgnoreCase("true")){
						path_keep.setSelected(true);
					} else {
						path_keep.setSelected(false);
					}
				}				
				if(keep_case.isSelected() && path_keep.isEnabled()){
					path_keep.setEnabled(false);
				}
			} else {
				SwingUtilities.invokeLater(new Runnable(){
					@Override
					public void run() {
						// TODO Auto-generated method stub
						if(thread_manual.isSelected() && !thread_text.isEnabled()){
							thread_text.setEnabled(true);
							thread_text.setText(String.valueOf(pool_info.get_pool_current_size()));
						}
						if(thread_auto.isSelected() && thread_text.isEnabled()){
							thread_text.setEnabled(false);
						}
						if(copy_case.isSelected() && !path_keep.isEnabled()){
							path_keep.setEnabled(true);
							if (client_info.get_client_preference_data().get("path_keep").equalsIgnoreCase("true")){
								path_keep.setSelected(true);
							} else {
								path_keep.setSelected(false);
							}
						}				
						if(keep_case.isSelected() && path_keep.isEnabled()){
							path_keep.setEnabled(false);
						}
					}
				});
			}
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	public static void main(String[] args) {
		switch_data switch_info = new switch_data();
		client_data client_info = new client_data();
		pool_data pool_info = new pool_data(public_data.PERF_POOL_MAXIMUM_SIZE);
		preference_dialog preference_view = new preference_dialog(null, switch_info, pool_info, client_info);
		new Thread(preference_view).start();
		preference_view.setVisible(true);
	}
}