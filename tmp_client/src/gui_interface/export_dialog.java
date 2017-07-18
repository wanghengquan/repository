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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.Vector;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTabbedPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import javax.swing.event.TableModelEvent;
import javax.swing.table.DefaultTableModel;

import connect_tube.queue_compare;
import connect_tube.task_data;
import data_center.client_data;
import data_center.public_data;
import utility_funcs.deep_clone;

public class export_dialog extends JDialog implements ChangeListener{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private task_data task_info;
	private view_data view_info;
	private client_data client_info;
	private JTabbedPane tabbed_pane;

	public export_dialog(
			main_frame main_view,
			client_data client_info,
			task_data task_info,
			view_data view_info){
		super(main_view, "Select and generate report", true);
		this.task_info = task_info;
		this.view_info = view_info;
		Container container = this.getContentPane();
		container.add(construct_tab_pane(), BorderLayout.CENTER);
		//this.setLocation(800, 500);
		//this.setLocationRelativeTo(main_view);
		this.setSize(900, 700);
	}

	private JTabbedPane construct_tab_pane(){
		tabbed_pane = new JTabbedPane(JTabbedPane.TOP, JTabbedPane.SCROLL_TAB_LAYOUT);
		tabbed_pane.addChangeListener(this);
		ImageIcon icon_image = new ImageIcon(public_data.ICON_RPT_PNG);
		// pane 1: select suites
		tabbed_pane.addTab("1. Select Suites", icon_image, new suite_pane(this, task_info, view_info), "Suite setting.");
		// pane 2: title pane
		tabbed_pane.addTab("2. Select Titles", icon_image, new title_pane(this, task_info, view_info), "Title setting.");
		// pane 3: title pane
		tabbed_pane.addTab("3. Report Preview", icon_image, new preview_pane(this, task_info, view_info), "Report preview.");
		// pane 4: title pane
		tabbed_pane.addTab("4. Report Generate", icon_image, new generate_pane(this, client_info, task_info, view_info), "Generate a report.");
		return tabbed_pane;
	}
	
	@Override
	public void stateChanged(ChangeEvent arg0) {
		// TODO Auto-generated method stub
		int select_index = tabbed_pane.getSelectedIndex();
		tabbed_pane.setSelectedIndex(select_index);
	}
	
	public void go_to_next_pane(){
		int select_index = tabbed_pane.getSelectedIndex();
		tabbed_pane.setSelectedIndex(select_index + 1);
	}
	
	public void go_to_previous_pane(){
		int select_index = tabbed_pane.getSelectedIndex();
		tabbed_pane.setSelectedIndex(select_index - 1);
	}	
	
	public static void main(String[] args) {
		task_data task_info = new task_data();
		view_data view_info = new view_data();
		client_data client_info = new client_data();
		export_dialog sw_view = new export_dialog(null, client_info, task_info, view_info);
		sw_view.setVisible(true);
	}
	 
}

class suite_pane extends JPanel implements ActionListener{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private export_dialog tabbed_pane;
	private task_data task_info;
	private view_data view_info;
	private JTable suite_table;
	private Vector<String> table_column = new Vector<String>();
	private Vector<Vector<Object>> table_data = new Vector<Vector<Object>>();	
	private JButton previous, next;
	
	public suite_pane(
			export_dialog tabbed_pane, 
			task_data task_info,
			view_data view_info){
		this.tabbed_pane = tabbed_pane;
		this.task_info = task_info;
		this.view_info = view_info;
		this.setLayout(new BorderLayout());
		this.add(construct_top_panel(), BorderLayout.CENTER);
		this.add(construct_buttom_panel(), BorderLayout.SOUTH);
	}
		
	private JPanel construct_top_panel(){
		JPanel top_panel = new JPanel(new BorderLayout());
		table_column.add("ID");
		table_column.add("Queue Name");
		table_column.add("Status");
		table_column.add("Select");
		TreeMap<String, HashMap<String, HashMap<String, String>>> received_admin_queues_treemap = new TreeMap<String, HashMap<String, HashMap<String, String>>>(
				new queue_compare());
		TreeMap<String, HashMap<String, HashMap<String, String>>> processed_admin_queues_treemap = new TreeMap<String, HashMap<String, HashMap<String, String>>>(
				new queue_compare());
		received_admin_queues_treemap = deep_clone.clone(task_info.get_received_admin_queues_treemap());
		processed_admin_queues_treemap = deep_clone.clone(task_info.get_processed_admin_queues_treemap());
		TreeMap<String, HashMap<String, HashMap<String, String>>> total_admin_queues_treemap = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		total_admin_queues_treemap.putAll(received_admin_queues_treemap);
		total_admin_queues_treemap.putAll(processed_admin_queues_treemap);
		ArrayList<String> processing_admin_queue_list = task_info.get_processing_admin_queue_list();
		ArrayList<String> running_admin_queue_list = task_info.get_running_admin_queue_list();
		ArrayList<String> finished_admin_queue_list = task_info.get_finished_admin_queue_list();
		TreeSet<String> key_set = new TreeSet<String>(new queue_compare());
		key_set.addAll(total_admin_queues_treemap.keySet());
		Iterator<String> key_it = key_set.iterator();
		int show_id = 1;
		while(key_it.hasNext()){
			Vector<Object> initial_line = new Vector<Object>();
			String queue_name = key_it.next();
			String status = new String("");
			if (finished_admin_queue_list.contains(queue_name)) {
				status = "Finished";
			} else if (running_admin_queue_list.contains(queue_name)) {
				status = "Running";
			} else if (processing_admin_queue_list.contains(queue_name)) {
				status = "Processing";
			} else {
				status = task_info.get_captured_admin_queues_treemap().get(queue_name).get("Status")
						.get("admin_status");
			}
			initial_line.add(String.valueOf(show_id));
			initial_line.add(queue_name);
			initial_line.add(status);
			initial_line.add(new JCheckBox());
			table_data.add(initial_line);
			show_id++;
		}
		DefaultTableModel dm = new DefaultTableModel();
		dm.setDataVector(table_data, table_column);		
		suite_table = new JTable(dm){
			/**
			 * 
			*/
			private static final long serialVersionUID = 1L;

			public void tableChanged(TableModelEvent e) {
				super.tableChanged(e);
				repaint();
			}
		}; 
		suite_table.getColumn("Select").setCellEditor(
				new checkbox_editor(new JCheckBox()));
		suite_table.getColumn("Select").setCellRenderer(new checkbox_render());
		suite_table.getColumn("ID").setMaxWidth(50);
		suite_table.getColumn("Select").setMaxWidth(100);		
		JScrollPane scro_panel = new JScrollPane(suite_table);
		top_panel.add(scro_panel, BorderLayout.CENTER);		
		return top_panel;
	}
	
	private JPanel construct_buttom_panel(){
		JPanel south_panel = new JPanel(new BorderLayout());
		previous = new JButton("Previous");
		previous.addActionListener(this);
		next = new JButton("Next");
		next.addActionListener(this);
		south_panel.add(previous, BorderLayout.WEST);
		south_panel.add(next, BorderLayout.EAST);
		return south_panel;
	}

	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub
		if(arg0.getSource().equals(previous)){
			tabbed_pane.go_to_previous_pane();
		}
		if(arg0.getSource().equals(next)){
			for(int index = 0; index < suite_table.getRowCount();index++){
				String queue_name = (String) suite_table.getValueAt(index, 1);
				JCheckBox check_box = (JCheckBox) suite_table.getValueAt(index, 3);
				if(check_box.isSelected()){
					view_info.add_export_title_list(queue_name);
				} else {
					view_info.remove_export_title_list(queue_name);
				}
			}			
			tabbed_pane.go_to_next_pane();
		}
	}
}


class title_pane extends JPanel implements ActionListener{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private export_dialog tabbed_pane;
	@SuppressWarnings("unused")
	private task_data task_info;
	private view_data view_info;
	private Vector<String> table_column = new Vector<String>();
	private Vector<Vector<Object>> table_data = new Vector<Vector<Object>>();	
	private JTable title_table;	
	private JButton previous, next;
	
	public title_pane(export_dialog tabbed_pane, task_data task_info, view_data view_info){
		this.tabbed_pane = tabbed_pane;
		this.task_info = task_info;
		this.view_info = view_info;
		this.setLayout(new BorderLayout());
		this.add(construct_top_panel(), BorderLayout.CENTER);
		this.add(construct_buttom_panel(), BorderLayout.SOUTH);
	}
		
	private JPanel construct_top_panel(){
		JPanel top_panel = new JPanel(new BorderLayout());
		table_column.add("ID");
		table_column.add("Available Titles");
		table_column.add("Select");
		ArrayList<String> title_items = new ArrayList<String>();
		title_items.add("ID");
		title_items.add("Suite");
		title_items.add("Design");
		title_items.add("Status");
		title_items.add("Reason");
		title_items.add("Time");
		int show_id = 1;
		for (String item : title_items){
			Vector<Object> initial_line = new Vector<Object>();

			initial_line.add(String.valueOf(show_id));
			initial_line.add(item);
			initial_line.add(new JCheckBox());
			table_data.add(initial_line);
			show_id++;
		}		
		DefaultTableModel dm = new DefaultTableModel();
		dm.setDataVector(table_data, table_column);
		title_table = new JTable(dm){
			/**
			 * 
			*/
			private static final long serialVersionUID = 1L;

			public void tableChanged(TableModelEvent e) {
				super.tableChanged(e);
				repaint();
			}
		}; 
		title_table.getColumn("Select").setCellEditor(
				new checkbox_editor(new JCheckBox()));
		title_table.getColumn("Select").setCellRenderer(new checkbox_render());
		title_table.getColumn("ID").setMaxWidth(50);
		title_table.getColumn("Select").setMaxWidth(100);
		JScrollPane scro_panel = new JScrollPane(title_table);
		top_panel.add(scro_panel, BorderLayout.CENTER);
		return top_panel;
	}
	
	private JPanel construct_buttom_panel(){
		JPanel south_panel = new JPanel(new BorderLayout());
		previous = new JButton("Previous");
		previous.addActionListener(this);
		next = new JButton("Next");
		next.addActionListener(this);
		south_panel.add(previous, BorderLayout.WEST);
		south_panel.add(next, BorderLayout.EAST);
		return south_panel;
	}

	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub
		if(arg0.getSource().equals(previous)){
			tabbed_pane.go_to_previous_pane();
		}
		if(arg0.getSource().equals(next)){
			for(int index = 0; index < title_table.getRowCount();index++){
				String title = (String) title_table.getValueAt(index, 1);
				JCheckBox check_box = (JCheckBox) title_table.getValueAt(index, 2);
				if(check_box.isSelected()){
					view_info.add_export_title_list(title);
				} else {
					view_info.remove_export_title_list(title);
				}
			}
			tabbed_pane.go_to_next_pane();
		}
	}
}

class preview_pane extends JPanel implements ActionListener{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private export_dialog tabbed_pane;
	private task_data task_info;
	private view_data view_info;
	private Vector<String> table_column = new Vector<String>();
	private Vector<Vector<Object>> table_data = new Vector<Vector<Object>>();	
	private JTable preview_table;	
	private JButton previous, next;
	
	public preview_pane(
			export_dialog tabbed_pane, 
			task_data task_info,
			view_data view_info){
		this.tabbed_pane = tabbed_pane;
		this.task_info = task_info;
		this.view_info = view_info;
		this.setLayout(new BorderLayout());
		this.add(construct_top_panel(), BorderLayout.CENTER);
		this.add(construct_buttom_panel(), BorderLayout.SOUTH);
	}
		
	private JPanel construct_top_panel(){
		JPanel top_panel = new JPanel(new BorderLayout());
		table_column.addAll(view_info.get_export_title_list());
		ArrayList<String> queue_list = new ArrayList<String>();
		queue_list.addAll(view_info.get_export_queue_list());
		for (String queue_name : queue_list){
			TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>(new queue_comparator());
			queue_data.putAll(task_info.get_queue_data_from_received_task_queues_map(queue_name));
			queue_data.putAll(task_info.get_queue_data_from_processed_task_queues_map(queue_name));
			if(queue_data.isEmpty()){
				continue;
			}
			Iterator<String> case_it = queue_data.keySet().iterator();
			while(case_it.hasNext()){
				String case_id = case_it.next();
				Vector<Object> initial_line = new Vector<Object>();				
				for(String title: table_column){
					switch (title){
					case "ID":
						initial_line.add(case_id);
						break;
					case "Suite":
						initial_line.add(queue_data.get(case_id).get("ID").getOrDefault("suite", "NA"));
						break;						
					case "Design":
						initial_line.add(queue_data.get(case_id).get("CaseInfo").getOrDefault("design_name", "NA"));
						break;
					case "Status":
						initial_line.add(queue_data.get(case_id).get("Status").getOrDefault("cmd_status", "NA"));
						break;	
					case "Reason":
						initial_line.add(queue_data.get(case_id).get("Status").getOrDefault("cmd_reason", "NA"));
						break;
					case "Time":
						initial_line.add(queue_data.get(case_id).get("Status").getOrDefault("run_time", "NA"));
						break;
					default:
						initial_line.add("NA");
					}
				}
				table_data.add(initial_line);
			}
		}		
		DefaultTableModel dm = new DefaultTableModel();
		dm.setDataVector(table_data, table_column);
		preview_table = new JTable(dm){
			/**
			 * 
			*/
			private static final long serialVersionUID = 1L;

			public void tableChanged(TableModelEvent e) {
				super.tableChanged(e);
				repaint();
			}
		}; 
		//preview_table.getColumn("ID").setMaxWidth(50);
		JScrollPane scro_panel = new JScrollPane(preview_table);
		top_panel.add(scro_panel, BorderLayout.CENTER);
		return top_panel;
	}
	
	private JPanel construct_buttom_panel(){
		JPanel south_panel = new JPanel(new BorderLayout());
		previous = new JButton("Previous");
		previous.addActionListener(this);
		next = new JButton("Next");
		next.addActionListener(this);
		south_panel.add(previous, BorderLayout.WEST);
		south_panel.add(next, BorderLayout.EAST);
		return south_panel;
	}

	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub
		if(arg0.getSource().equals(previous)){
			tabbed_pane.go_to_previous_pane();
		}
		if(arg0.getSource().equals(next)){
			tabbed_pane.go_to_next_pane();
		}
	}
}


class generate_pane extends JPanel implements ActionListener{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private export_dialog tabbed_pane;
	private task_data task_info;
	private view_data view_info;
	private client_data client_info;
	private Vector<String> table_column = new Vector<String>();
	private Vector<Vector<Object>> table_data = new Vector<Vector<Object>>();
	private JTextField file_path = new JTextField("");
	private JTextField file_name = new JTextField("");
	private JButton open_button = new JButton("Select");
	private JButton generate = new JButton("Generate");
	private JButton previous, next;
	
	public generate_pane(
			export_dialog tabbed_pane,
			client_data client_info,
			task_data task_info,
			view_data view_info){
		this.tabbed_pane = tabbed_pane;
		this.task_info = task_info;
		this.view_info = view_info;
		this.client_info = client_info;
		file_path.setText(client_info.get_client_data().get("preference").get("work_path"));
		file_name.setText("client_report.csv");
		this.setLayout(new BorderLayout());
		this.add(construct_top_panel(), BorderLayout.CENTER);
		this.add(construct_buttom_panel(), BorderLayout.SOUTH);
	}
		
	private JPanel construct_top_panel(){
		JPanel top_panel = new JPanel(new GridLayout(4,3,5,5));
		JLabel path_label = new JLabel("Export Path:");
		//line 1
		top_panel.add(path_label);
		top_panel.add(file_path);
		top_panel.add(open_button);
		//line 2
		JLabel file_label = new JLabel("Export Name:");
		top_panel.add(file_label);
		top_panel.add(file_name);
		top_panel.add(new JLabel());
		//line 3
		top_panel.add(new JLabel());
		top_panel.add(new JLabel());
		top_panel.add(new JLabel());
		//line 4 
		top_panel.add(new JLabel());
		top_panel.add(new JLabel());
		top_panel.add(generate);
		return top_panel;
	}
	
	private JPanel construct_buttom_panel(){
		JPanel south_panel = new JPanel(new BorderLayout());
		previous = new JButton("Previous");
		previous.addActionListener(this);
		next = new JButton("Next");
		next.addActionListener(this);
		south_panel.add(previous, BorderLayout.WEST);
		south_panel.add(next, BorderLayout.EAST);
		return south_panel;
	}

	private void update_table_column(){
		table_column.addAll(view_info.get_export_title_list());
	}
	
	private void update_table_data(){
		ArrayList<String> queue_list = new ArrayList<String>();
		queue_list.addAll(view_info.get_export_queue_list());
		for (String queue_name : queue_list){
			TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>(new queue_comparator());
			queue_data.putAll(task_info.get_queue_data_from_received_task_queues_map(queue_name));
			queue_data.putAll(task_info.get_queue_data_from_processed_task_queues_map(queue_name));
			if(queue_data.isEmpty()){
				continue;
			}
			Iterator<String> case_it = queue_data.keySet().iterator();
			while(case_it.hasNext()){
				String case_id = case_it.next();
				Vector<Object> initial_line = new Vector<Object>();				
				for(String title: table_column){
					switch (title){
					case "ID":
						initial_line.add(case_id);
						break;
					case "Suite":
						initial_line.add(queue_data.get(case_id).get("ID").getOrDefault("suite", "NA"));
						break;						
					case "Design":
						initial_line.add(queue_data.get(case_id).get("CaseInfo").getOrDefault("design_name", "NA"));
						break;
					case "Status":
						initial_line.add(queue_data.get(case_id).get("Status").getOrDefault("cmd_status", "NA"));
						break;	
					case "Reason":
						initial_line.add(queue_data.get(case_id).get("Status").getOrDefault("cmd_reason", "NA"));
						break;
					case "Time":
						initial_line.add(queue_data.get(case_id).get("Status").getOrDefault("run_time", "NA"));
						break;
					default:
						initial_line.add("NA");
					}
				}
				table_data.add(initial_line);
			}
		}
	}
	
	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub
		if(arg0.getSource().equals(generate)){
			update_table_column();
			update_table_data();
			String text_path = new String(file_path.getText());
			String text_name = new String(file_name.getText());
			String export_file = text_path + "/" + text_name;			
		}		
		if(arg0.getSource().equals(previous)){
			tabbed_pane.go_to_previous_pane();
		}
		if(arg0.getSource().equals(next)){
			tabbed_pane.go_to_next_pane();
		}
	}
}
