/*
 * File: menu_bar.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/03/11
 * Modifier:
 * Date:
 * Description:
 */
package gui_interface;

import java.awt.BorderLayout;
import java.awt.Component;
import java.util.Vector;

import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

public class queue_pane extends JSplitPane{
	/**
	 * 
	 */
	private static final long serialVersionUID = 2L;

	public queue_pane(){
		super(JSplitPane.VERTICAL_SPLIT);
		this.setDividerLocation(400);
		this.setDividerSize(10);
		this.setOneTouchExpandable(true);
		this.setContinuousLayout(true);
		this.setTopComponent(panel_top_component());
		this.setBottomComponent(panel_bottom_component());
	}
	
	private Component panel_top_component(){
		JPanel work_panel= new JPanel(new BorderLayout());
		DefaultTableModel work_table_model = new DefaultTableModel();
		Vector<String> table_name = new Vector<String>();
		table_name.add("Reject Queue");
		table_name.add("Reason");
		Vector<Vector<String>> table_data = new Vector<Vector<String>>();
		for (int row = 1; row <100;row++){
			Vector<String> row_data = new Vector<String>();
			row_data.add("Queue" + row);
			row_data.add("Reason" + row);
			table_data.add(row_data);
		}
		work_table_model.setDataVector(table_data, table_name);
		JTable work_table = new JTable(work_table_model);
		JScrollPane scroll_panel= new JScrollPane(work_table);
		work_panel.add(scroll_panel);
		return work_panel;
	}
	
	private Component panel_bottom_component(){
		JPanel work_panel= new JPanel(new BorderLayout());
		DefaultTableModel work_table_model = new DefaultTableModel();
		Vector<String> table_name = new Vector<String>();
		table_name.add("Captured Queue");
		table_name.add("Status");
		Vector<Vector<String>> table_data = new Vector<Vector<String>>();
		for (int row = 1; row <100;row++){
			Vector<String> row_data = new Vector<String>();
			row_data.add("Queue" + row);
			row_data.add("Status" + row);
			table_data.add(row_data);
		}
		work_table_model.setDataVector(table_data, table_name);
		JTable work_table = new JTable(work_table_model);
		JScrollPane scroll_panel= new JScrollPane(work_table);
		work_panel.add(scroll_panel);
		return work_panel;
	}	
}