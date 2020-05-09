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
import utility_funcs.deep_clone;

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
	private JRadioButton link_both, link_remote, link_local, thread_auto, thread_manual, task_auto, task_serial, task_parallel, hold_case, copy_case;
	private JCheckBox keep_path, lazy_copy, ignore_software, ignore_system, ignore_machine;
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
		this.setSize(650, 500);
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
		thread_text = new JTextField(String.valueOf(pool_info.get_pool_current_size()));
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
		jl_case_mode.setToolTipText("The method for Client get case ready, copy to workspace<default> or just run in original place.");
		hold_case = new JRadioButton("Hold Case");
		hold_case.setToolTipText("Client run case/task in it's original place.");
		copy_case = new JRadioButton("Copy Case");
		copy_case.setToolTipText("Client export/copy case to current work_space first and run it.");
		ButtonGroup case_group = new ButtonGroup();
		case_group.add(hold_case);
		case_group.add(copy_case);
		keep_path = new JCheckBox("Keep Path");
		keep_path.setToolTipText("Client keep the original task case path(relative path based on suite path).");
		lazy_copy = new JCheckBox("Lazy Copy");
		lazy_copy.setToolTipText("If work space have this case already, run it directly.");
		JPanel jp_copy_option = new JPanel(new GridLayout(2,1,5,5));
		jp_copy_option.add(keep_path);
		jp_copy_option.add(lazy_copy);
		initial_case_default_value(preference_data.get("case_mode"), preference_data.get("keep_path"), preference_data.get("lazy_copy"));
		jp_center4.add(jl_case_mode);
		jp_center4.add(hold_case);
		jp_center4.add(copy_case);
		jp_center4.add(jp_copy_option);
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
		jl_work_path.setToolTipText("Client will export task case to this place and run here.");
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
		discard.setToolTipText("Restore previous data.");
		discard.addActionListener(this);
		apply = new JButton("Apply");
		apply.setToolTipText("Apply new setting.");
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
	
	private void initial_case_default_value(
			String case_mode_str, 
			String keep_path_str,
			String lazy_copy_str){
		if(case_mode_str.equalsIgnoreCase("hold_case")){
			hold_case.setSelected(true);
			copy_case.setSelected(false);
			keep_path.setEnabled(false);
			lazy_copy.setEnabled(false);
		} else {
			hold_case.setSelected(false);
			copy_case.setSelected(true);
			keep_path.setEnabled(true);
			lazy_copy.setEnabled(true);
			if (keep_path_str.equalsIgnoreCase("true")){
				keep_path.setSelected(true);
			} else {
				keep_path.setSelected(false);
			}
			if (lazy_copy_str.equalsIgnoreCase("true")){
				lazy_copy.setSelected(true);
			} else {
				lazy_copy.setSelected(false);
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
		preference_data.putAll(deep_clone.clone(client_info.get_client_preference_data()));
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
				int pool_size = pool_info.get_pool_maximum_size();
				if (new_value < 0 || new_value > pool_size){
					String message = new String("Client accept value: 0 ~ " + String.valueOf(pool_size));
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
			if(hold_case.isSelected()){
				preference_data.put("case_mode", "hold_case");
			} else {
				preference_data.put("case_mode", "copy_case");
				if(keep_path.isSelected()){
					preference_data.put("keep_path", "true");
				} else {
					preference_data.put("keep_path", "false");
				}
				if(lazy_copy.isSelected()){
					preference_data.put("lazy_copy", "true");
				} else {
					preference_data.put("lazy_copy", "false");
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
			String new_work_space = jt_work_path.getText().trim().replaceAll("\\\\", "/");
			String ori_work_space = preference_data.getOrDefault("work_space", public_data.DEF_WORK_SPACE);
			if(new_work_space.equals("")){
				String message = new String("Empty work space found.");
				JOptionPane.showMessageDialog(null, message, "Wrong import value:", JOptionPane.INFORMATION_MESSAGE);
				return;				
			} else {
				File work_dobj = new File(new_work_space);
				String message = new String("work space Not Exists.");
				if(work_dobj.exists()){
					preference_data.put("work_space_temp", new_work_space);
					if (!new_work_space.equals(ori_work_space)){
						switch_info.set_work_space_update_request(true);
					}
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
            String save_spaces[] = save_space.split(",");
            String message = new String("save space Not Exists:");
            for(String tmp_space:save_spaces){
                File work_dobj = new File(tmp_space.trim());
                if(!work_dobj.exists()){
                    System.out.println(tmp_space.trim());
                    JOptionPane.showMessageDialog(null, message+tmp_space, "Wrong import value:", JOptionPane.INFORMATION_MESSAGE);
                    return;
                }
            }
            preference_data.put("save_space", save_space);
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
				if(copy_case.isSelected()){
					if (!keep_path.isEnabled()) {
						keep_path.setEnabled(true);
					}
					if (!lazy_copy.isEnabled()) {
						lazy_copy.setEnabled(true);
					}
				}				
				if(hold_case.isSelected()){
					if (keep_path.isEnabled()) {
						keep_path.setEnabled(false);
					}
					if (lazy_copy.isEnabled()) {
						lazy_copy.setEnabled(false);
					}
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
						if(copy_case.isSelected()){
							if (!keep_path.isEnabled()) {
								keep_path.setEnabled(true);
							}
							if (!lazy_copy.isEnabled()) {
								lazy_copy.setEnabled(true);
							}
						}				
						if(hold_case.isSelected()){
							if (keep_path.isEnabled()) {
								keep_path.setEnabled(false);
							}
							if (lazy_copy.isEnabled()) {
								lazy_copy.setEnabled(false);
							}
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