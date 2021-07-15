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
import java.util.Iterator;
import java.util.Vector;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTabbedPane;
import javax.swing.JTable;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

import connect_tube.task_data;
import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;
import flow_control.pool_data;
import flow_control.post_data;

public class database_dialog extends JDialog implements ChangeListener{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private switch_data switch_info;
	private client_data client_info;
	private task_data task_info;
	private view_data view_info;
	private pool_data pool_info;
	private post_data post_info;
	
	private JTabbedPane tabbed_pane;

	public database_dialog(
			main_frame main_view, 
			switch_data switch_info, 
			client_data client_info,
			view_data view_info,
			task_data task_info,
			pool_data pool_info,
			post_data post_info
			){
		super(main_view, "Database View", true);
		this.switch_info = switch_info;
		this.client_info = client_info;
		this.view_info = view_info;		
		this.task_info = task_info;
		this.pool_info = pool_info;
		this.post_info = post_info;
		Container container = this.getContentPane();
		container.add(construct_tab_pane(), BorderLayout.CENTER);
		//this.setLocation(800, 500);
		//this.setLocationRelativeTo(main_view);
		this.setSize(1000, 800);
	}

	private JTabbedPane construct_tab_pane(){
		tabbed_pane = new JTabbedPane(JTabbedPane.TOP, JTabbedPane.SCROLL_TAB_LAYOUT);
		tabbed_pane.addChangeListener(this);
		String [] database_list = new String [] {"switch", "client", "view", "task", "pool", "post"};
		for (String database : database_list){
			//Icon icon_image = (Icon) Toolkit.getDefaultToolkit().getImage(public_data.ICON_TAB_ICO);
			String database_name = new String("");
			database_name = database.substring(0, 1).toUpperCase() + database.substring(1);
			ImageIcon icon_image = new ImageIcon(public_data.ICON_SOFTWARE_TAB_PNG);
			tabbed_pane.addTab(database_name, icon_image, new database_pane(database, switch_info, client_info, view_info, task_info, pool_info, post_info, this), "Click and show");
		}
		return tabbed_pane;
	}
	
	@Override
	public void stateChanged(ChangeEvent arg0) {
		// TODO Auto-generated method stub
		int select_index = tabbed_pane.getSelectedIndex();
		tabbed_pane.setSelectedIndex(select_index);
	}
	
	public static void main(String[] args) {
		switch_data switch_info = new switch_data();
		client_data client_info = new client_data();
		task_data task_info = new task_data();
		view_data view_info = new view_data();
		pool_data pool_info = new pool_data();
		post_data post_info = new post_data();
		database_dialog sw_view = new database_dialog(null, switch_info, client_info, view_info, task_info, pool_info, post_info);
		sw_view.setVisible(true);
	}
}

class database_pane extends JPanel implements ActionListener{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private switch_data switch_info;
	private client_data client_info;
	private task_data task_info;
	private view_data view_info;
	private pool_data pool_info;
	private post_data post_info;
	private database_dialog top_panel;
	private String tab_name;
	private JTable db_table;
	//private JTextField jt_max_insts, jt_scan_dir;
	private Vector<String> table_column = new Vector<String>();
	private Vector<Vector<String>> table_data = new Vector<Vector<String>>();
	private JButton close;
	
	public database_pane(
			String tab_name, 
			switch_data switch_info, 
			client_data client_info,
			view_data view_info,
			task_data task_info,
			pool_data pool_info,
			post_data post_info,
			database_dialog top_panel
			){
		this.tab_name = tab_name;
		this.switch_info = switch_info;
		this.client_info = client_info;
		this.view_info = view_info;		
		this.task_info = task_info;
		this.pool_info = pool_info;
		this.post_info = post_info;
		this.top_panel = top_panel;
		this.setLayout(new BorderLayout());
		this.add(construct_center_panel(), BorderLayout.CENTER);
		this.add(construct_south_panel(), BorderLayout.SOUTH);
	}
		
	private JPanel construct_center_panel(){
		JPanel center_panel = new JPanel(new BorderLayout());
		table_column.add("Option");
		table_column.add("Value");
		HashMap<String, String> data_map = new HashMap<String, String>();
		switch(tab_name){
		case "switch":
			data_map.putAll(switch_info.get_database_info());
			break;
		case "client":
			data_map.putAll(client_info.get_database_info());
			break;
		case "view":
			data_map.putAll(view_info.get_database_info());
			break;
		case "task":
			data_map.putAll(task_info.get_database_info());
			break;
		case "pool":
			data_map.putAll(pool_info.get_database_info());
			break;
		case "post":
			data_map.putAll(post_info.get_database_info());
			break;
		default:
			break;
		}
		Iterator<String> data_map_it = data_map.keySet().iterator();
		while(data_map_it.hasNext()){
			String option = new String(data_map_it.next());
			String value = new String(data_map.get(option));
			Vector<String> one_line = new Vector<String>();
			one_line.add(option);
			one_line.add(value);
			table_data.add(one_line);
		}
		db_table = new setting_table(table_data, table_column);
		db_table.getColumn("Option").setMinWidth(200);
		db_table.getColumn("Option").setMaxWidth(300);
		JScrollPane scro_panel = new JScrollPane(db_table);
		center_panel.add(scro_panel, BorderLayout.CENTER);
		return center_panel;
	}
	
	private JPanel construct_south_panel(){
		JPanel south_panel = new JPanel(new GridLayout(1,4,5,20));
		close = new JButton("Close");
		close.addActionListener(this);		
		south_panel.add(new JLabel(""));
		south_panel.add(new JLabel(""));
		south_panel.add(new JLabel(""));
		south_panel.add(close);
		return south_panel;
	}
	
	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub
		if (arg0.getSource().equals(close)) {
			top_panel.dispose();		
		}
	}
}
