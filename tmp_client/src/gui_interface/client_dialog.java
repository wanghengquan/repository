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
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.HashMap;
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JPanel;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.table.JTableHeader;

import data_center.client_data;
import data_center.switch_data;

public class client_dialog extends JDialog implements ActionListener{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private switch_data switch_info;
	private client_data client_info;
	private Vector<String> client_column = new Vector<String>();
	private Vector<Vector<String>> client_data = new Vector<Vector<String>>();
	private Vector<String> terminal = new Vector<String>();
	private Vector<String> group = new Vector<String>();
	private Vector<String> max_threads = new Vector<String>();
	private Vector<String> client_private = new Vector<String>();
	private JButton apply;
	private JTable client_table;

	public client_dialog(main_frame main_view, switch_data switch_info, client_data client_info){
		super(main_view, "Client Setting", true);
		this.switch_info = switch_info;
		this.client_info = client_info;
		Container container = this.getContentPane();
		//container.add(new JTextField("Edit table and apply save:"), BorderLayout.NORTH);
		container.add(construct_table_panel(), BorderLayout.CENTER);
		container.add(construct_action_panel(), BorderLayout.SOUTH);
		JTableHeader table_head = client_table.getTableHeader();
		container.add(table_head, BorderLayout.NORTH);		
		this.setLocation(800, 500);
		this.setSize(400, 300);
	}
	
	public JTable construct_table_panel(){
		client_column.add("Item");
		client_column.add("Value");
		terminal.add("Terminal:");
		group.add("Group:");
		max_threads.add("Maximum Run Threads:");
		client_private.add("Private Client:");
		if(client_info.get_client_data().containsKey("Machine")){
			terminal.add(client_info.get_client_data().get("Machine").get("terminal"));
			group.add(client_info.get_client_data().get("Machine").get("group"));
			max_threads.add(client_info.get_client_data().get("Machine").get("max_threads"));
			client_private.add(client_info.get_client_data().get("Machine").get("private"));
		} else {
			terminal.add("Test");
			group.add("Test");
			max_threads.add("Test");
			client_private.add("Test");
		}
		client_data.add(terminal);
		client_data.add(group);
		client_data.add(max_threads);
		client_data.add(client_private);
		client_table = new JTable(client_data, client_column);
		return client_table;
	}
	
	public JPanel construct_action_panel(){
		JPanel action = new JPanel();
		apply = new JButton("Apply");
		apply.addActionListener(this);
		action.add(apply, BorderLayout.EAST);
		return action;
	}

	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub
		if (arg0.getSource().equals(apply)){
			HashMap<String, HashMap<String, String>> update_data = client_info.get_client_data();
			if (!update_data.containsKey("Machine")){
				return;
			}
			HashMap<String, String> machine_data = update_data.get("Machine");
			machine_data.put("terminal", (String) client_table.getValueAt(0, 1));
			machine_data.put("group", (String) client_table.getValueAt(1, 1));
			machine_data.put("max_threads", (String) client_table.getValueAt(2, 1));
			machine_data.put("private", (String) client_table.getValueAt(3, 1));
			client_info.set_client_data(update_data);
			switch_info.set_client_updated();
		}
	}
	
	public static void main(String[] args) {
		switch_data switch_info = new switch_data();
		client_data client_info = new client_data();		
		client_dialog client_view = new client_dialog(null, switch_info, client_info);
		client_view.setVisible(true);
	}
	
}