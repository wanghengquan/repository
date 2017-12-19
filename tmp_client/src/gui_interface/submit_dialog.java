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
import java.util.HashMap;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;

import connect_tube.task_data;
import data_center.public_data;
import flow_control.task_enum;
import utility_funcs.des_encode;
import utility_funcs.time_info;

public class submit_dialog extends JDialog implements ActionListener {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private task_data task_info;
	private JButton close;
	private String queue_name;
	private String line_separator = System.getProperty("line.separator");

	public submit_dialog(main_frame main_view, task_data task_info, String queue_name) {
		super(main_view, "Task Submit Code", true);
		this.task_info = task_info;
		this.queue_name = queue_name;
		Container container = this.getContentPane();
		container.add(construct_view_panel(), BorderLayout.CENTER);
		container.add(construct_action_panel(), BorderLayout.SOUTH);
		//this.setLocation(800, 500);
		this.setSize(450, 300);
	}

	public JPanel construct_view_panel() {
		JPanel view_panel = new JPanel(new BorderLayout());
		// welcome label
		//JLabel submit_label = new JLabel("Detail Submit Code:");
		//submit_label.setBackground(Color.LIGHT_GRAY);
		//view_panel.add(submit_label, BorderLayout.NORTH);
		// welcome letters
		JTextArea letter_area = new JTextArea();
		letter_area.setLineWrap(true);
		letter_area.append(get_task_queue_run_id(queue_name) + line_separator);
		letter_area.setEditable(false);
		JScrollPane sp = new JScrollPane(letter_area);
		view_panel.add(sp, BorderLayout.CENTER);
		// return
		return view_panel;
	}
	
	public JPanel construct_action_panel() {
		JPanel action = new JPanel(new GridLayout(1, 3, 5, 5));
		close = new JButton("Close");
		close.addActionListener(this);
		action.add(new JLabel(""));
		action.add(new JLabel(""));
		action.add(close);
		return action;
	}
	
	private String get_run_suite_data_string(
			String queue_name){
		String result_string = new String("");
		HashMap<String, HashMap<task_enum, Integer>> summary_map = new HashMap<String, HashMap<task_enum, Integer>>();
		summary_map.putAll(task_info.get_client_run_case_summary_data_map());
		HashMap<task_enum, Integer> run_queue_data = new HashMap<task_enum, Integer>();
		if (summary_map.containsKey(queue_name)){
			run_queue_data.putAll(summary_map.get(queue_name));
		} else {
			System.out.println(">>>No run data found for :" + queue_name);
			return result_string;
		}
		result_string = run_queue_data.toString();
		return result_string;
	}
	
	private String get_run_suite_final_result(
			String queue_name){
		String run_result = new String("Unknown");
		HashMap<String, HashMap<task_enum, Integer>> summary_map = new HashMap<String, HashMap<task_enum, Integer>>();
		summary_map.putAll(task_info.get_client_run_case_summary_data_map());
		HashMap<task_enum, Integer> run_queue_data = new HashMap<task_enum, Integer>();
		if (summary_map.containsKey(queue_name)){
			run_queue_data.putAll(summary_map.get(queue_name));
		} else {
			System.out.println("No run data found for :" + queue_name);
			return run_result;
		}
		Integer pass_num = run_queue_data.getOrDefault(task_enum.PASSED, 0);
		Integer fail_num = run_queue_data.getOrDefault(task_enum.FAILED, 0);
		Integer tbd_num = run_queue_data.getOrDefault(task_enum.TBD, 0);
		Integer timeout_num = run_queue_data.getOrDefault(task_enum.TIMEOUT, 0);
		Integer others_num = run_queue_data.getOrDefault(task_enum.OTHERS, 0);
		Integer total_num = pass_num + fail_num + tbd_num + timeout_num + others_num;
		if (total_num < 1){
			run_result = "Unknown";
		}else if (fail_num > 0){
			run_result = "Failed";
		}else if (pass_num < 1){
			run_result = "Failed";
		} else {
			run_result = "Passed";
		}
		return run_result;
	}	
	
	private String get_task_queue_run_id(
			String queue_name){
		String run_id = new String("Unknown Issue");
		HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
		admin_data.putAll(task_info.get_queue_data_from_processed_admin_queues_treemap(queue_name));
		if (admin_data.isEmpty()){
			admin_data.putAll(task_info.get_queue_data_from_received_admin_queues_treemap(queue_name));
		}
		if (admin_data.isEmpty()){
			System.out.println("No queue data found for Run ID generate:" + queue_name);
			run_id = "No queue data found for Run ID generate.";
			return run_id;			
		}
		String run_suite_name = admin_data.get("ID").get("suite");
		String run_suite_result = get_run_suite_final_result(queue_name);
		String encode_string = run_suite_name + "_" + get_run_suite_data_string(queue_name) + "_" + time_info.get_date_time();
		String encryption_code = "unknown";
		try {
			encryption_code = des_encode.encrypt(encode_string, public_data.ENCRY_KEY);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		run_id = run_suite_name + "_" + run_suite_result + "_<" + encryption_code + ">";
		return run_id;
	}	
	
	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub
		// action perform
		if(arg0.getSource().equals(close)){
			this.dispose();
		} 
	}
	
	public static void main(String[] args) {
		task_data task_info = new task_data();
		String queue_name = new String("");
		submit_dialog submit_info = new submit_dialog(null, task_info, queue_name);
		submit_info.setVisible(true);
	}
}