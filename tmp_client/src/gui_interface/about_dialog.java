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
import java.util.Vector;

import javax.swing.JDialog;
import javax.swing.JTable;
import javax.swing.table.JTableHeader;

import data_center.public_data;

public class about_dialog extends JDialog {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Vector<String> about_column = new Vector<String>();
	private Vector<Vector<String>> about_data = new Vector<Vector<String>>();
	private Vector<String> version = new Vector<String>();
	private Vector<String> date = new Vector<String>();
	private Vector<String> support_suite = new Vector<String>();

	public about_dialog(main_frame main_view) {
		super(main_view, "About TestRail Client", true);
		Container container = this.getContentPane();
		about_column.add("Item");
		about_column.add("Value");
		version.add("Build Version:");
		version.add(public_data.BASE_CURRENTVERSION);
		about_data.add(version);
		date.add("Build Date:");
		date.add(public_data.BASE_BUILDDATE);
		about_data.add(date);
		support_suite.add("Support Suit File:");
		support_suite.add(public_data.BASE_SUITEFILEVERSION);
		about_data.add(support_suite);
		JTable about_table = new info_table(about_data, about_column);
		about_table.setRowHeight(24);
		container.add(about_table, BorderLayout.CENTER);
		JTableHeader table_head = about_table.getTableHeader();
		container.add(table_head, BorderLayout.NORTH);
		this.setLocation(800, 500);
		this.setSize(400, 300);
	}

	public static void main(String[] args) {
		about_dialog about_info = new about_dialog(null);
		about_info.setVisible(true);
	}
}