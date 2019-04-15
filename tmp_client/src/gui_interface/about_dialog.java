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
import javax.swing.JCheckBox;
import javax.swing.JDialog;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTable;
import javax.swing.table.JTableHeader;

import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;
import self_update.app_update;
import utility_funcs.time_info;

public class about_dialog extends JDialog implements ActionListener {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Vector<String> about_column = new Vector<String>();
	private Vector<Vector<String>> about_data = new Vector<Vector<String>>();
	private Vector<String> version = new Vector<String>();
	private Vector<String> date = new Vector<String>();
	private Vector<String> corescript = new Vector<String>();
	private Vector<String> support_suite = new Vector<String>();
	private Vector<String> rumtime = new Vector<String>();
	private client_data client_info;
	private switch_data switch_info;
	private JCheckBox jc_test;
	private JButton close, update;

	public about_dialog(
			main_frame main_view, 
			client_data client_info, 
			switch_data switch_info) {
		super(main_view, "About TestRail Client", true);
		this.client_info = client_info;
		this.switch_info = switch_info;
		Container container = this.getContentPane();
		about_column.add("Item");
		about_column.add("Value");
		version.add("Build Version:");
		version.add(public_data.BASE_CURRENTVERSION);
		about_data.add(version);
		date.add("Build Date:");
		date.add(public_data.BASE_BUILDDATE);
		about_data.add(date);
		corescript.add("Core Version:");
		String version = new String("");
		String status = new String("");
		version = client_info.get_client_corescript_data().get("version");
		status = client_info.get_client_corescript_data().get("status");
		corescript.add(version + "<" + status + ">");
		about_data.add(corescript);
		support_suite.add("Support Suite File:");
		support_suite.add(public_data.BASE_SUITEFILEVERSION);
		about_data.add(support_suite);
		rumtime.add("Client Run Time:");
		rumtime.add(this.get_client_runtime());
		about_data.add(rumtime);
		JTable about_table = new info_table(about_data, about_column);
		about_table.getColumn("Item").setMinWidth(100);
		about_table.getColumn("Value").setMinWidth(100);
		about_table.setRowHeight(24);
		container.add(about_table, BorderLayout.CENTER);
		JTableHeader table_head = about_table.getTableHeader();
		container.add(table_head, BorderLayout.NORTH);
		container.add(construct_action_panel(), BorderLayout.SOUTH);
		//this.setLocation(800, 500);
		this.setSize(450, 300);
	}

	public JPanel construct_action_panel() {
		JPanel action = new JPanel(new GridLayout(2, 1, 5, 5));
		HashMap<String, String> preference_data = new HashMap<String, String>();
		preference_data.putAll(client_info.get_client_preference_data());
		//join internal test
		jc_test = new JCheckBox("Join internal test and Get latest developing version.");
		action.add(jc_test);
		String config_value = new String(public_data.DEF_STABLE_VERSION);
		config_value = preference_data.getOrDefault("stable_version", public_data.DEF_STABLE_VERSION);
		if(config_value.equals("1")){
			jc_test.setSelected(false);
		} else {
			jc_test.setSelected(true);
		}
		// acction button
		JPanel action_button = new JPanel(new GridLayout(1, 2, 5, 10));
		close = new JButton("Close");
		close.addActionListener(this);
		update = new JButton("Check Update");
		update.addActionListener(this);
		action_button.add(close);
		action_button.add(update);
		action.add(action_button);
		return action;
	}
	
	private String get_client_runtime(){
		String start_time = new String("0");
		try{
			start_time = client_info.get_client_machine_data().get("start_time");
		} catch (Exception e){
			return "NA";
		}
		String current_time = String.valueOf(System.currentTimeMillis() / 1000);
		return time_info.get_runtime_string_dhms(start_time, current_time);	
	}
	
	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub
		// dump check box first
		HashMap<String, String> update_data = new HashMap<String, String>();
		update_data.putAll(client_info.get_client_preference_data());
		if (update_data != null) {
			if(jc_test.isSelected()){
				update_data.put("stable_version", "0");
			} else {
				update_data.put("stable_version", "1");
			}
			client_info.set_client_preference_data(update_data);
			switch_info.set_client_updated();			
		}
		// action perform
		if(arg0.getSource().equals(close)){
			this.dispose();
		} 
		if(arg0.getSource().equals(update)){
			//this.setVisible(false);
			this.dispose();
			app_update update_obj = new app_update(client_info, switch_info);
			update_obj.gui_manual_update();
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			if(update_obj.update_skipped){
				String message = new String("TMP Client new version not available...");
				String title = new String("Update message");
				JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
			}
		}
	}
	
	public static void main(String[] args) {
		client_data client_info = new client_data();
		switch_data switch_info = new switch_data();
		about_dialog about_info = new about_dialog(null, client_info, switch_info);
		about_info.setVisible(true);
	}
}