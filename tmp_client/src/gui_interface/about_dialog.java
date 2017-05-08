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
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTable;
import javax.swing.table.JTableHeader;

import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;
import self_update.app_update;

public class about_dialog extends JDialog implements ActionListener {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Vector<String> about_column = new Vector<String>();
	private Vector<Vector<String>> about_data = new Vector<Vector<String>>();
	private Vector<String> version = new Vector<String>();
	private Vector<String> date = new Vector<String>();
	private Vector<String> support_suite = new Vector<String>();
	private switch_data switch_info;
	private client_data client_info;
	private JButton close, update;

	public about_dialog(main_frame main_view, switch_data switch_info, client_data client_info) {
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
		support_suite.add("Support Suite File:");
		support_suite.add(public_data.BASE_SUITEFILEVERSION);
		about_data.add(support_suite);
		JTable about_table = new info_table(about_data, about_column);
		about_table.setRowHeight(24);
		container.add(about_table, BorderLayout.CENTER);
		JTableHeader table_head = about_table.getTableHeader();
		container.add(table_head, BorderLayout.NORTH);
		container.add(construct_action_panel(), BorderLayout.SOUTH);
		//this.setLocation(800, 500);
		this.setLocationRelativeTo(main_view);
		this.pack();
		this.setSize(400, 300);
	}

	public JPanel construct_action_panel() {
		JPanel action = new JPanel(new GridLayout(1, 2, 5, 10));
		close = new JButton("Close");
		close.addActionListener(this);
		update = new JButton("Check Update");
		update.addActionListener(this);
		action.add(close);
		action.add(update);
		return action;
	}
	
	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub
		if(arg0.getSource().equals(close)){
			this.dispose();
		}
		if(arg0.getSource().equals(update)){
			//this.setVisible(false);
			this.dispose();
			app_update update_obj = new app_update(switch_info, client_info);
			if(!update_obj.gui_manual_update()){
				String message = new String("TMP Client new version not available...");
				String title = new String("Update message");
				JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
			}
		}
	}
	
	public static void main(String[] args) {
		client_data client_info = new client_data();
		switch_data switch_info = new switch_data();
		about_dialog about_info = new about_dialog(null, switch_info, client_info);
		about_info.setVisible(true);
	}
}