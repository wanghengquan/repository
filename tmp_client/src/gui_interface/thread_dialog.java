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

import java.awt.Container;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.HashMap;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.SwingUtilities;

import cmd_interface.console_server;
import connect_link.link_server;
import connect_tube.tube_server;
import data_center.data_server;
import data_center.switch_data;
import flow_control.hall_manager;
import top_runner.run_manager.client_manager;
import top_runner.run_manager.thread_enum;
import utility_funcs.time_info;

public class thread_dialog extends JDialog implements ActionListener, Runnable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private switch_data switch_info;
	private JTextField jt_cm_status, jt_cm_update;
	private JTextField jt_vs_status, jt_vs_update;
	private JTextField jt_cs_status, jt_cs_update;
	private JTextField jt_ds_status, jt_ds_update;
	private JTextField jt_ls_status, jt_ls_update;
	private JTextField jt_hm_status, jt_hm_update;
	private JTextField jt_ts_status, jt_ts_update;
	private JButton cm_play, cm_pause, cm_stop;
	private JButton vs_play, vs_pause, vs_stop;
	private JButton cs_play, cs_pause, cs_stop;
	private JButton ds_play, ds_pause, ds_stop;
	private JButton ls_play, ls_pause, ls_stop;
	private JButton hm_play, hm_pause, hm_stop;
	private JButton ts_play, ts_pause, ts_stop;
	private JButton close;

	public thread_dialog(
			main_frame main_view, 
			switch_data switch_info
			){
		super(main_view, "Thread View", true);
		this.switch_info = switch_info;
		Container container = this.getContentPane();
		container.add(construct_thread_panel());
		//this.setLocation(800, 500);
		//this.setLocationRelativeTo(main_view);
		this.setSize(800, 400);
	}
	
	private String thread_status_calculate(
			thread_enum thread_request, 
			HashMap<thread_enum, String> active_map
			){
		String status = new String("Inactive");
		//current time
		long current_time = time_info.get_timestamp();
		String previous_time_str = new String(active_map.getOrDefault(thread_request, "0"));
		long previous_time = 0;
		previous_time = time_info.get_timestamp_yyMMdd_HHmmss(previous_time_str);
		if (current_time - previous_time > 60) {
			status = "Inactive";
		} else {
			status = "Active";
		}
		return status;
	}
	
	private JPanel construct_thread_panel(){
		HashMap<thread_enum, String> active_map = new HashMap<thread_enum, String>();
		active_map.putAll(switch_info.get_threads_active_map());
		//=================================first part 
		GridBagLayout thread_layout = new GridBagLayout();
		JPanel thread_panel = new JPanel(thread_layout);
		//step 0 : Title line
		JLabel thread_title = new JLabel("Threads");
		JLabel status_title = new JLabel("Status");
		JLabel update_title = new JLabel("Update Time");
		JLabel action_title = new JLabel("Action");
		thread_panel.add(thread_title);
		thread_panel.add(status_title);
		thread_panel.add(update_title);
		thread_panel.add(action_title);
		//step 1 :input 1th line
		JLabel jl_cm_lable = new JLabel(thread_enum.top_runner.get_description());
		jt_cm_status = new JTextField(thread_status_calculate(thread_enum.top_runner, active_map));
		jt_cm_update = new JTextField(active_map.getOrDefault(thread_enum.top_runner, "NA"));
		jt_cm_status.setEditable(false);
		jt_cm_update.setEditable(false);
		JPanel jp_cm_action = new JPanel(new GridLayout(1,3,8,8));
		cm_play = new JButton("Play");
		cm_play.addActionListener(this);
		cm_pause = new JButton("Pause");
		cm_pause.addActionListener(this);
		cm_stop = new JButton("Stop");
		cm_stop.addActionListener(this);
		jp_cm_action.add(cm_play);
		jp_cm_action.add(cm_pause);
		jp_cm_action.add(cm_stop);
		thread_panel.add(jl_cm_lable);
		thread_panel.add(jt_cm_status);
		thread_panel.add(jt_cm_update);
		thread_panel.add(jp_cm_action);
		//step 2 :input 2th line
		JLabel jl_vs_lable = new JLabel(thread_enum.view_runner.get_description());
		jt_vs_status = new JTextField(thread_status_calculate(thread_enum.view_runner, active_map));
		jt_vs_update = new JTextField(active_map.getOrDefault(thread_enum.view_runner, "NA"));
		jt_vs_status.setEditable(false);
		jt_vs_update.setEditable(false);
		JPanel jp_vs_action = new JPanel(new GridLayout(1,3,8,8));
		vs_play = new JButton("Play");
		vs_play.addActionListener(this);
		vs_pause = new JButton("Pause");
		vs_pause.addActionListener(this);
		vs_stop = new JButton("Stop");
		vs_stop.addActionListener(this);
		jp_vs_action.add(vs_play);
		jp_vs_action.add(vs_pause);
		jp_vs_action.add(vs_stop);
		thread_panel.add(jl_vs_lable);
		thread_panel.add(jt_vs_status);
		thread_panel.add(jt_vs_update);
		thread_panel.add(jp_vs_action);
		//step 3 :input 3th line
		JLabel jl_cs_lable = new JLabel(thread_enum.console_runner.get_description());
		jt_cs_status = new JTextField(thread_status_calculate(thread_enum.console_runner, active_map));
		jt_cs_update = new JTextField(active_map.getOrDefault(thread_enum.console_runner, "NA"));		
		jt_cs_status.setEditable(false);
		jt_cs_update.setEditable(false);
		JPanel jp_cs_action = new JPanel(new GridLayout(1,3,8,8));
		cs_play = new JButton("Play");
		cs_play.addActionListener(this);
		cs_pause = new JButton("Pause");
		cs_pause.addActionListener(this);
		cs_stop = new JButton("Stop");
		cs_stop.addActionListener(this);
		jp_cs_action.add(cs_play);
		jp_cs_action.add(cs_pause);
		jp_cs_action.add(cs_stop);
		thread_panel.add(jl_cs_lable);
		thread_panel.add(jt_cs_status);
		thread_panel.add(jt_cs_update);
		thread_panel.add(jp_cs_action);		
		//step 4 :input 4th line
		JLabel jl_ds_lable = new JLabel(thread_enum.data_runner.get_description());
		jt_ds_status = new JTextField(thread_status_calculate(thread_enum.data_runner, active_map));
		jt_ds_update = new JTextField(active_map.getOrDefault(thread_enum.data_runner, "NA"));
		jt_ds_status.setEditable(false);
		jt_ds_update.setEditable(false);
		JPanel jp_ds_action = new JPanel(new GridLayout(1,3,8,8));
		ds_play = new JButton("Play");
		ds_play.addActionListener(this);
		ds_pause = new JButton("Pause");
		ds_pause.addActionListener(this);
		ds_stop = new JButton("Stop");
		ds_stop.addActionListener(this);
		jp_ds_action.add(ds_play);
		jp_ds_action.add(ds_pause);
		jp_ds_action.add(ds_stop);
		thread_panel.add(jl_ds_lable);
		thread_panel.add(jt_ds_status);
		thread_panel.add(jt_ds_update);
		thread_panel.add(jp_ds_action);			
		//step 5 :input 5th line
		JLabel jl_ls_lable = new JLabel(thread_enum.link_runner.get_description());
		jt_ls_status = new JTextField(thread_status_calculate(thread_enum.link_runner, active_map));
		jt_ls_update = new JTextField(active_map.getOrDefault(thread_enum.link_runner, "NA"));
		jt_ls_status.setEditable(false);
		jt_ls_update.setEditable(false);
		JPanel jp_ls_action = new JPanel(new GridLayout(1,3,8,8));
		ls_play = new JButton("Play");
		ls_play.addActionListener(this);
		ls_pause = new JButton("Pause");
		ls_pause.addActionListener(this);
		ls_stop = new JButton("Stop");
		ls_stop.addActionListener(this);
		jp_ls_action.add(ls_play);
		jp_ls_action.add(ls_pause);
		jp_ls_action.add(ls_stop);
		thread_panel.add(jl_ls_lable);
		thread_panel.add(jt_ls_status);
		thread_panel.add(jt_ls_update);
		thread_panel.add(jp_ls_action);		
		//step 6 :input 6th line
		JLabel jl_hm_lable = new JLabel(thread_enum.hall_runner.get_description());
		jt_hm_status = new JTextField(thread_status_calculate(thread_enum.hall_runner, active_map));
		jt_hm_update = new JTextField(active_map.getOrDefault(thread_enum.hall_runner, "NA"));
		jt_hm_status.setEditable(false);
		jt_hm_update.setEditable(false);
		JPanel jp_hm_action = new JPanel(new GridLayout(1,3,8,8));
		hm_play = new JButton("Play");
		hm_play.addActionListener(this);
		hm_pause = new JButton("Pause");
		hm_pause.addActionListener(this);
		hm_stop = new JButton("Stop");
		hm_stop.addActionListener(this);
		jp_hm_action.add(hm_play);
		jp_hm_action.add(hm_pause);
		jp_hm_action.add(hm_stop);
		thread_panel.add(jl_hm_lable);
		thread_panel.add(jt_hm_status);
		thread_panel.add(jt_hm_update);
		thread_panel.add(jp_hm_action);
		//step 7 :input 7th line
		JLabel jl_ts_lable = new JLabel(thread_enum.tube_runner.get_description());
		jt_ts_status = new JTextField(thread_status_calculate(thread_enum.tube_runner, active_map));
		jt_ts_update = new JTextField(active_map.getOrDefault(thread_enum.tube_runner, "NA"));		
		jt_ts_status.setEditable(false);
		jt_ts_update.setEditable(false);
		JPanel jp_ts_action = new JPanel(new GridLayout(1,3,8,8));
		ts_play = new JButton("Play");
		ts_play.addActionListener(this);
		ts_pause = new JButton("Pause");
		ts_pause.addActionListener(this);
		ts_stop = new JButton("Stop");
		ts_stop.addActionListener(this);
		jp_ts_action.add(ts_play);
		jp_ts_action.add(ts_pause);
		jp_ts_action.add(ts_stop);
		thread_panel.add(jl_ts_lable);
		thread_panel.add(jt_ts_status);
		thread_panel.add(jt_ts_update);
		thread_panel.add(jp_ts_action);
		//empty line
		JLabel jl_empty_line = new JLabel("");
		thread_panel.add(jl_empty_line);
		//bottom
		JLabel jl_empty_lable = new JLabel("");
		close = new JButton("Close");
		close.addActionListener(this);
		thread_panel.add(jl_empty_lable);
		thread_panel.add(close);
		//==============layout it
		GridBagConstraints layout_cons = new GridBagConstraints();
		layout_cons.fill = GridBagConstraints.BOTH;
		//step 0 : Title line
		layout_cons.gridwidth=1;
		layout_cons.weightx = 0;
		layout_cons.weighty= 0.2;
		thread_layout.setConstraints(thread_title, layout_cons);
		layout_cons.gridwidth=1;
		layout_cons.weightx = 0;
		layout_cons.weighty= 0.2;
		thread_layout.setConstraints(status_title, layout_cons);
		layout_cons.gridwidth=2;
		layout_cons.weightx = 0;
		layout_cons.weighty= 0.2;
		thread_layout.setConstraints(update_title, layout_cons);
		layout_cons.gridwidth=0;
		layout_cons.weightx = 0;
		layout_cons.weighty= 0.2;
		thread_layout.setConstraints(action_title, layout_cons);	
		//step 1 :input 1th line
		layout_cons.gridwidth=1;
		layout_cons.weightx = 0;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jl_cm_lable, layout_cons);
		layout_cons.gridwidth=1;
		layout_cons.weightx = 0.5;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jt_cm_status, layout_cons);
		layout_cons.gridwidth=2;
		layout_cons.weightx = 0.5;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jt_cm_update, layout_cons);
		layout_cons.gridwidth=0;
		layout_cons.weightx = 0;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jp_cm_action, layout_cons);
		//step 2 :input 2th line
		layout_cons.gridwidth=1;
		layout_cons.weightx = 0;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jl_vs_lable, layout_cons);
		layout_cons.gridwidth=1;
		layout_cons.weightx = 0.5;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jt_vs_status, layout_cons);
		layout_cons.gridwidth=2;
		layout_cons.weightx = 0.5;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jt_vs_update, layout_cons);
		layout_cons.gridwidth=0;
		layout_cons.weightx = 0;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jp_vs_action, layout_cons);
		//step 3 :input 3th line
		layout_cons.gridwidth=1;
		layout_cons.weightx = 0;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jl_cs_lable, layout_cons);
		layout_cons.gridwidth=1;
		layout_cons.weightx = 0.5;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jt_cs_status, layout_cons);
		layout_cons.gridwidth=2;
		layout_cons.weightx = 0.5;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jt_cs_update, layout_cons);
		layout_cons.gridwidth=0;
		layout_cons.weightx = 0;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jp_cs_action, layout_cons);		
		//step 4 :input 4th line
		layout_cons.gridwidth=1;
		layout_cons.weightx = 0;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jl_ds_lable, layout_cons);
		layout_cons.gridwidth=1;
		layout_cons.weightx = 0.5;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jt_ds_status, layout_cons);
		layout_cons.gridwidth=2;
		layout_cons.weightx = 0.5;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jt_ds_update, layout_cons);
		layout_cons.gridwidth=0;
		layout_cons.weightx = 0;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jp_ds_action, layout_cons);
		//step 5 :input 5th line
		layout_cons.gridwidth=1;
		layout_cons.weightx = 0;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jl_ls_lable, layout_cons);
		layout_cons.gridwidth=1;
		layout_cons.weightx = 0.5;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jt_ls_status, layout_cons);
		layout_cons.gridwidth=2;
		layout_cons.weightx = 0.5;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jt_ls_update, layout_cons);
		layout_cons.gridwidth=0;
		layout_cons.weightx = 0;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jp_ls_action, layout_cons);
		//step 6 :input 6th line
		layout_cons.gridwidth=1;
		layout_cons.weightx = 0;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jl_hm_lable, layout_cons);
		layout_cons.gridwidth=1;
		layout_cons.weightx = 0.5;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jt_hm_status, layout_cons);
		layout_cons.gridwidth=2;
		layout_cons.weightx = 0.5;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jt_hm_update, layout_cons);
		layout_cons.gridwidth=0;
		layout_cons.weightx = 0;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jp_hm_action, layout_cons);
		//step 7 :input 7th line
		layout_cons.gridwidth=1;
		layout_cons.weightx = 0;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jl_ts_lable, layout_cons);
		layout_cons.gridwidth=1;
		layout_cons.weightx = 0.5;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jt_ts_status, layout_cons);
		layout_cons.gridwidth=2;
		layout_cons.weightx = 0.5;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jt_ts_update, layout_cons);
		layout_cons.gridwidth=0;
		layout_cons.weightx = 0;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jp_ts_action, layout_cons);
		//empty line
		layout_cons.gridwidth=0;
		layout_cons.weightx = 0;
		layout_cons.weighty= 0.8;
		thread_layout.setConstraints(jl_empty_line, layout_cons);
		//bottom
		layout_cons.gridwidth=4;
		layout_cons.weightx = 1;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(jl_empty_lable, layout_cons);
		layout_cons.gridwidth=0;
		layout_cons.weightx = 0;
		layout_cons.weighty= 0;
		thread_layout.setConstraints(close, layout_cons);		
		return thread_panel;
	}
	
	private void thread_data_update() {
		HashMap<thread_enum, String> threads_active_map = new HashMap<thread_enum, String>();
		threads_active_map.putAll(switch_info.get_threads_active_map());
		client_manager top_runner = (client_manager) switch_info.get_threads_object_map(thread_enum.top_runner);
		view_server view_runner = (view_server) switch_info.get_threads_object_map(thread_enum.view_runner);
		console_server console_runner = (console_server) switch_info.get_threads_object_map(thread_enum.console_runner);
		data_server data_runner = (data_server) switch_info.get_threads_object_map(thread_enum.data_runner);
		link_server link_runner = (link_server) switch_info.get_threads_object_map(thread_enum.link_runner);
		hall_manager hall_runner = (hall_manager) switch_info.get_threads_object_map(thread_enum.hall_runner);
		tube_server tube_runner = (tube_server) switch_info.get_threads_object_map(thread_enum.tube_runner);
		//top_runner
		if (top_runner.isAlive()) {
			jt_cm_status.setText(top_runner.getState().toString());
		} else {
			jt_cm_status.setText("Inactive");
		}
		jt_cm_update.setText(threads_active_map.getOrDefault(thread_enum.top_runner, "NA"));
		//view_runner
		if (view_runner.isAlive()) {
			jt_vs_status.setText(view_runner.getState().toString());
		} else {
			jt_vs_status.setText("Inactive");
		}
		jt_vs_update.setText(threads_active_map.getOrDefault(thread_enum.view_runner, "NA"));
		//console_runner
		if (console_runner.isAlive()) {
			jt_cs_status.setText(console_runner.getState().toString());
		} else {
			jt_cs_status.setText("Inactive");
		}
		jt_cs_update.setText(threads_active_map.getOrDefault(thread_enum.console_runner, "NA"));
		//data_runner
		if (data_runner.isAlive()) {
			jt_ds_status.setText(data_runner.getState().toString());
		} else {
			jt_ds_status.setText("Inactive");
		}
		jt_ds_update.setText(threads_active_map.getOrDefault(thread_enum.data_runner, "NA"));
		//link_runner
		if (link_runner.isAlive()) {
			jt_ls_status.setText(link_runner.getState().toString());
		} else {
			jt_ls_status.setText("Inactive");
		}
		jt_ls_update.setText(threads_active_map.getOrDefault(thread_enum.link_runner, "NA"));
		//hall_runner
		if (hall_runner.isAlive()) {
			jt_hm_status.setText(hall_runner.getState().toString());
		} else {
			jt_hm_status.setText("Inactive");
		}
		jt_hm_update.setText(threads_active_map.getOrDefault(thread_enum.hall_runner, "NA"));
		//tube_runner
		if (tube_runner.isAlive()) {
			jt_ts_status.setText(tube_runner.getState().toString());
		} else {
			jt_ts_status.setText("Inactive");
		}
		jt_ts_update.setText(threads_active_map.getOrDefault(thread_enum.tube_runner, "NA"));
	}
	
	@Override
	public void run() {
		// TODO Auto-generated method stub
		while (true) {	
			if (SwingUtilities.isEventDispatchThread()) {
				thread_data_update();
			} else {
				SwingUtilities.invokeLater(new Runnable(){
					@Override
					public void run() {
						// TODO Auto-generated method stub
						thread_data_update();
					}
				});
			}
			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}	
	
	@Override
	public void actionPerformed(ActionEvent arg0) {
		client_manager top_runner = (client_manager) switch_info.get_threads_object_map(thread_enum.top_runner);
		view_server view_runner = (view_server) switch_info.get_threads_object_map(thread_enum.view_runner);
		console_server console_runner = (console_server) switch_info.get_threads_object_map(thread_enum.console_runner);
		data_server data_runner = (data_server) switch_info.get_threads_object_map(thread_enum.data_runner);
		link_server link_runner = (link_server) switch_info.get_threads_object_map(thread_enum.link_runner);
		hall_manager hall_runner = (hall_manager) switch_info.get_threads_object_map(thread_enum.hall_runner);
		tube_server tube_runner = (tube_server) switch_info.get_threads_object_map(thread_enum.tube_runner);
		// TODO Auto-generated method stub
		if (arg0.getSource().equals(close)) {
			this.dispose();
		}
		if (arg0.getSource().equals(cm_play)) {
			if (top_runner.isAlive()) {
				top_runner.wake_request();
			}
		}
		if (arg0.getSource().equals(cm_pause)) {
			top_runner.wait_request();
		}
		if (arg0.getSource().equals(cm_stop)) {
			top_runner.soft_stop();
			cm_play.setEnabled(false);
			cm_pause.setEnabled(false);
		}
		if (arg0.getSource().equals(vs_play)) {
			if (view_runner.isAlive()) {
				view_runner.wake_request();
			}
		}
		if (arg0.getSource().equals(vs_pause)) {
			view_runner.wait_request();
		}
		if (arg0.getSource().equals(vs_stop)) {
			view_runner.soft_stop();
			vs_play.setEnabled(false);
			vs_pause.setEnabled(false);
		}
		if (arg0.getSource().equals(cs_play)) {
			if (console_runner.isAlive()) {
				console_runner.wake_request();
			}
		}
		if (arg0.getSource().equals(cs_pause)) {
			console_runner.wait_request();
		}
		if (arg0.getSource().equals(cs_stop)) {
			console_runner.soft_stop();
			cs_play.setEnabled(false);
			cs_pause.setEnabled(false);
		}
		if (arg0.getSource().equals(ds_play)) {
			if (data_runner.isAlive()) {
				data_runner.wake_request();
			}
		}
		if (arg0.getSource().equals(ds_pause)) {
			data_runner.wait_request();
		}
		if (arg0.getSource().equals(ds_stop)) {
			data_runner.soft_stop();
			ds_play.setEnabled(false);
			ds_pause.setEnabled(false);
		}
		if (arg0.getSource().equals(ls_play)) {
			if (link_runner.isAlive()) {
				link_runner.wake_request();
			}
		}
		if (arg0.getSource().equals(ls_pause)) {
			link_runner.wait_request();
		}
		if (arg0.getSource().equals(ls_stop)) {
			link_runner.soft_stop();
			ls_play.setEnabled(false);
			ls_pause.setEnabled(false);
		}
		if (arg0.getSource().equals(hm_play)) {
			if (hall_runner.isAlive()) {
				hall_runner.wake_request();
			}
		}
		if (arg0.getSource().equals(hm_pause)) {
			hall_runner.wait_request();
		}
		if (arg0.getSource().equals(hm_stop)) {
			hall_runner.soft_stop();
			hm_play.setEnabled(false);
			hm_pause.setEnabled(false);
		}
		if (arg0.getSource().equals(ts_play)) {
			if (tube_runner.isAlive()) {
				tube_runner.wake_request();
			}
		}
		if (arg0.getSource().equals(ts_pause)) {
			tube_runner.wait_request();
		}
		if (arg0.getSource().equals(ts_stop)) {
			tube_runner.soft_stop();
			ts_play.setEnabled(false);
			ts_pause.setEnabled(false);
		}
	}
	
	public static void main(String[] args) {
		switch_data switch_info = new switch_data();
		thread_dialog thread_view = new thread_dialog(null, switch_info);
		thread_view.setVisible(true);
	}
}