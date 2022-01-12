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
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTable;
import javax.swing.table.JTableHeader;

import data_center.client_data;
import data_center.switch_data;

public class client_dialog extends JDialog implements ActionListener {
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
	private Vector<String> account = new Vector<String>();
	private Vector<String> client_private = new Vector<String>();
	private Vector<String> unattended = new Vector<String>();
	//private Vector<String> debug_mode = new Vector<String>();
	
	private JButton discard, apply, close;
	private JTable client_table;

	public client_dialog(
			main_frame main_view, 
			switch_data switch_info, 
			client_data client_info
			) {
		super(main_view, "Client Setting:", true);
		this.switch_info = switch_info;
		this.client_info = client_info;
		Container container = this.getContentPane();
		// container.add(new JTextField("Edit table and apply save:"),
		// BorderLayout.NORTH);
		container.add(construct_table_panel(), BorderLayout.CENTER);
		container.add(construct_action_panel(), BorderLayout.SOUTH);
		JTableHeader table_head = client_table.getTableHeader();
		container.add(table_head, BorderLayout.NORTH);
		//this.setLocation(800, 500);
		//this.setLocationRelativeTo(main_view);
		this.setSize(450, 300);
	}

	public void reset_table_data() {
		terminal.clear();
		group.clear();
		account.clear();
		client_private.clear();
		client_data.clear();
		unattended.clear();
		//debug_mode.clear();
		terminal.add("Terminal:");
		group.add("Group:");
		account.add("Account:");
		client_private.add("Private Client:");
		unattended.add("Unattended Mode:");
		//debug_mode.add("Debug Mode:");
		if (client_info.get_client_data().containsKey("Machine")) {
			terminal.add(client_info.get_client_machine_data().get("terminal"));
			group.add(client_info.get_client_machine_data().get("group"));
			account.add(System.getProperty("user.name"));
			client_private.add(client_info.get_client_machine_data().get("private"));
			unattended.add(client_info.get_client_machine_data().get("unattended"));
			//debug_mode.add(client_info.get_client_machine_data().get("debug"));
		} else {
			terminal.add("Test");
			group.add("Test");
			account.add("Test");
			client_private.add("Test");
			unattended.add("Test");
			//debug_mode.add("Test");
		}
		client_data.add(terminal);
		client_data.add(group);
		client_data.add(account);
		client_data.add(client_private);
		client_data.add(unattended);
		//client_data.add(debug_mode);
	}

	public JTable construct_table_panel() {
		client_column.add("Item");
		client_column.add("Value");
		reset_table_data();
		client_table = new setting_table(client_data, client_column);
		client_table.getColumn("Item").setMaxWidth(200);
		client_table.getColumn("Item").setMinWidth(150);		
		return client_table;
	}

	public JPanel construct_action_panel() {
		JPanel action_panel = new JPanel(new GridLayout(2,1,5,5));
		//comments
		JPanel comment = new JPanel(new GridLayout(1, 1, 5, 5));
		comment.add(new JLabel("*:Account value is read-only."));
		//action
		JPanel action = new JPanel(new GridLayout(1, 4, 5, 5));
		discard = new JButton("Discard");
		discard.addActionListener(this);
		apply = new JButton("Apply");
		apply.addActionListener(this);
		close = new JButton("Close");
		close.addActionListener(this);		
		action.add(discard);
		action.add(new JLabel(""));
		action.add(apply);
		action.add(close);
		action_panel.add(comment);
		action_panel.add(action);
		return action_panel;
	}

	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub
		if (arg0.getSource().equals(discard)) {
			reset_table_data();
			client_table.updateUI();		
		}		
		if (arg0.getSource().equals(apply)) {
			HashMap<String, String> machine_data = new HashMap<String, String>();
			machine_data.put("terminal", (String) client_table.getValueAt(0, 1));
			machine_data.put("group", (String) client_table.getValueAt(1, 1));
			machine_data.put("account", System.getProperty("user.name"));
			machine_data.put("private", (String) client_table.getValueAt(3, 1));
			machine_data.put("unattended", (String) client_table.getValueAt(4, 1));
			//machine_data.put("debug", (String) client_table.getValueAt(5, 1));
			client_info.update_client_machine_data(machine_data);
			switch_info.set_client_updated();			
		}
		if (arg0.getSource().equals(close)) {
			this.dispose();
		}
	}

	public static void main(String[] args) {
		switch_data switch_info = new switch_data();
		client_data client_info = new client_data();
		client_dialog client_view = new client_dialog(null, switch_info, client_info);
		client_view.setVisible(true);
	}

}