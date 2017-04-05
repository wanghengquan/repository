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
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.swing.ButtonGroup;
import javax.swing.JButton;
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
	private JLabel jl_link_mode, jl_max_threads, jl_task_assign, jl_work_path, jl_save_path;
	private JRadioButton link_both, link_remote, link_local, thread_auto, thread_manual, task_auto, task_serial, task_parallel;
	private JTextField thread_text, jt_work_path, jt_save_path;
	private JButton discard, apply;

	public preference_dialog(main_frame main_view, switch_data switch_info, pool_data pool_info, client_data client_info){
		super(main_view, "Preference Setting", true);
		this.client_info = client_info;
		this.pool_info = pool_info;
		this.switch_info = switch_info;
		Container container = this.getContentPane();
		container.add(construct_preference_panel());
		this.setLocation(800, 500);
		this.setSize(500, 300);
	}
	
	private JPanel construct_preference_panel(){
		HashMap<String, HashMap<String, String>> client_data = new HashMap<String, HashMap<String, String>>();
		client_data.putAll(client_info.get_client_data());
		HashMap<String, String> preference_data = client_data.get("preference");
		preference_panel = new JPanel(new GridLayout(7,1,5,5));
		//step 0 : Title line
		JPanel jp_title = new JPanel(new GridLayout(1,1,5,5));
		jp_title.add(new JLabel("Preference items:"));
		jp_title.setBackground(Color.LIGHT_GRAY);
		//step 1 :input 1th line
		JPanel jp_center1 = new JPanel(new GridLayout(1,4,5,5));
		jl_link_mode = new JLabel("Link Server:");
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
		//step 4 : input 4th line
		JPanel jp_center4 = new JPanel(new GridLayout(1,2,5,5));
		jl_work_path = new JLabel("Work Space:");
		jt_work_path = new JTextField(preference_data.get("work_path"));
		jp_center4.add(jl_work_path);
		jp_center4.add(jt_work_path);
		//step 5 : input 5th line
		JPanel jp_center5 = new JPanel(new GridLayout(1,2,5,5));
		jl_save_path = new JLabel("Save Space:");
		jt_save_path = new JTextField(preference_data.get("save_path"));
		jp_center5.add(jl_save_path);
		jp_center5.add(jt_save_path);		
		//Step 3 : bottom line
		JPanel jp_bottom = new JPanel(new GridLayout(1,2,5,10));
		discard = new JButton("Discard");
		discard.addActionListener(this);
		apply = new JButton("Apply");
		apply.addActionListener(this);
		jp_bottom.add(discard);
		jp_bottom.add(apply);
		//final package
		preference_panel.add(jp_title);
		preference_panel.add(jp_center1);
		preference_panel.add(jp_center2);
		preference_panel.add(jp_center3);
		preference_panel.add(jp_center4);
		preference_panel.add(jp_center5);
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
		HashMap<String, HashMap<String, String>> client_data = new HashMap<String, HashMap<String, String>>();
		client_data.putAll(client_info.get_client_data());
		HashMap<String, String> preference_data = client_data.get("preference");		
		if(arg0.getSource().equals(discard)){
			initial_link_default_value(preference_data.get("link_mode"));
			initial_thread_default_value(preference_data.get("thread_mode"));
			initial_task_default_value(preference_data.get("task_mode"));
			jt_work_path.setText(preference_data.get("work_path"));
			jt_save_path.setText(preference_data.get("save_path"));
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
			//work path
			if(jt_work_path.getText().trim().equals("")){
				String message = new String("Empty work path found.");
				JOptionPane.showMessageDialog(null, message, "Wrong import value:", JOptionPane.INFORMATION_MESSAGE);
				return;				
			} else {
				File work_dobj = new File(jt_work_path.getText().trim());
				String message = new String("work path Not Exists.");
				if(work_dobj.exists()){
					preference_data.put("work_path", jt_work_path.getText().trim());
				} else {
					JOptionPane.showMessageDialog(null, message, "Wrong import value:", JOptionPane.INFORMATION_MESSAGE);
					return;					
				}
			}
			//save path
			if(jt_save_path.getText().trim().equals("")){
				String message = new String("Empty save path found.");
				JOptionPane.showMessageDialog(null, message, "Wrong import value:", JOptionPane.INFORMATION_MESSAGE);
				return;				
			} else {
				File save_dobj = new File(jt_save_path.getText().trim());
				String message = new String("save path Not Exists.");
				if(save_dobj.exists()){
					preference_data.put("save_path", jt_save_path.getText().trim());
				} else {
					JOptionPane.showMessageDialog(null, message, "Wrong import value:", JOptionPane.INFORMATION_MESSAGE);
					return;					
				}				
			}
			client_info.set_client_data(client_data);
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