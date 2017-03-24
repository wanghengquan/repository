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
import java.awt.Container;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
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

public class preference_dialog extends JDialog implements ActionListener, Runnable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private switch_data switch_info;
	private client_data client_info;
	private JPanel preference_panel;
	private JLabel jl_max_threads, jl_task_assign;
	private JRadioButton thread_auto, thread_manual, task_auto, task_serial, task_parallel;
	private JTextField thread_text;
	private JButton discard, apply;

	public preference_dialog(main_frame main_view, switch_data switch_info, client_data client_info){
		super(main_view, "Preference Setting", true);
		this.client_info = client_info;
		this.switch_info = switch_info;
		Container container = this.getContentPane();
		container.add(construct_preference_panel());
		this.setLocation(800, 500);
		this.setSize(500, 200);
	}
	
	private JPanel construct_preference_panel(){
		preference_panel = new JPanel(new BorderLayout());
		//step 0 : Title line
		JPanel jp_title = new JPanel(new GridLayout(1,1,10,10));
		jp_title.add(new JLabel("Preference items:"));
		//step 1 : center line
		JPanel jp_center = new JPanel(new GridLayout(4,4,5,5));
		//first line
		jl_max_threads = new JLabel("Max Threads:");
		thread_auto = new JRadioButton("Auto");
		thread_manual = new JRadioButton("Manually");
		thread_text = new JTextField("NA");
		initial_thread_default_value();
		ButtonGroup thread_group = new ButtonGroup();
		thread_group.add(thread_auto);
		thread_group.add(thread_manual);
		//input first line
		jp_center.add(jl_max_threads);
		jp_center.add(thread_auto);
		jp_center.add(thread_manual);
		jp_center.add(thread_text);
		//step 2 : second line
		jl_task_assign = new JLabel("Task Assign:");
		task_auto = new JRadioButton("Auto");
		task_serial = new JRadioButton("Serial");
		task_parallel = new JRadioButton("Parallel");
		initial_task_default_value();
		ButtonGroup task_group = new ButtonGroup();
		task_group.add(task_auto);
		task_group.add(task_serial);
		task_group.add(task_parallel);
		//input second line
		jp_center.add(jl_task_assign);
		jp_center.add(task_auto);
		jp_center.add(task_serial);
		jp_center.add(task_parallel);	
		//input third line
		jp_center.add(new JLabel());
		jp_center.add(new JLabel());
		jp_center.add(new JLabel());
		jp_center.add(new JLabel());
		//input 4th line
		jp_center.add(new JLabel());
		jp_center.add(new JLabel());
		jp_center.add(new JLabel());
		jp_center.add(new JLabel());		
		//Step 3 : bottom line
		JPanel jp_bottom = new JPanel(new GridLayout(1,2,5,10));
		discard = new JButton("Discard");
		discard.addActionListener(this);
		apply = new JButton("Apply");
		apply.addActionListener(this);
		jp_bottom.add(discard);
		jp_bottom.add(apply);
		//final package
		preference_panel.add(jp_title, BorderLayout.NORTH);
		preference_panel.add(jp_center, BorderLayout.CENTER);
		preference_panel.add(jp_bottom, BorderLayout.SOUTH);
		return preference_panel;
	}

	private void initial_thread_default_value(){
		if(switch_info.get_thread_work_mode().equals("auto")){
			thread_auto.setSelected(true);
			thread_manual.setSelected(false);
			thread_text.setEnabled(false);
		} else {
			thread_auto.setSelected(false);
			thread_manual.setSelected(true);
			thread_text.setEnabled(true);			
		}
	}
	
	private void initial_task_default_value(){
		if(switch_info.get_task_work_mode().equals("auto")){
			task_auto.setSelected(true);
			task_serial.setSelected(false);
			task_parallel.setSelected(false);
		} else if (switch_info.get_task_work_mode().equals("serial")) {
			task_auto.setSelected(false);
			task_serial.setSelected(true);
			task_parallel.setSelected(false);			
		} else {
			task_auto.setSelected(false);
			task_serial.setSelected(false);
			task_parallel.setSelected(true);			
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
		if(arg0.getSource().equals(discard)){
			initial_thread_default_value();
			initial_task_default_value();
		}
		if(arg0.getSource().equals(apply)){
			if(thread_auto.isSelected()){
				switch_info.set_thread_work_mode("auto");
			} else {
				switch_info.set_thread_work_mode("manual");
				int new_value = get_srting_int(thread_text.getText());
				if (new_value < 0 || new_value > public_data.PERF_POOL_MAXIMUM_THREAD){
					String message = new String("Client accept data: 0 ~ " + String.valueOf(public_data.PERF_POOL_MAXIMUM_THREAD));
					JOptionPane.showMessageDialog(null, message, "Wrong import value:", JOptionPane.INFORMATION_MESSAGE);
					return;
				}
				switch_info.set_current_max_thread(new_value);
			}
			if(task_auto.isSelected()){
				switch_info.set_task_work_mode("auto");
			} else if (task_serial.isSelected()){
				switch_info.set_task_work_mode("serial");
			} else {
				switch_info.set_task_work_mode("parallel");
			}
		}		
	}

	@Override
	public void run() {
		// TODO Auto-generated method stub
		while (true) {	
			if (SwingUtilities.isEventDispatchThread()) {
				if(thread_manual.isSelected() && !thread_text.isEnabled()){
					thread_text.setEnabled(true);
					thread_text.setText(switch_info.get_current_max_thread().toString());
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
							thread_text.setText(switch_info.get_current_max_thread().toString());
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
		preference_dialog preference_view = new preference_dialog(null, switch_info, client_info);
		new Thread(preference_view).start();
		preference_view.setVisible(true);
	}
}