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
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
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
import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTabbedPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.SwingUtilities;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import javax.swing.event.TableModelEvent;
import javax.swing.table.DefaultTableModel;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.queue_compare;
import connect_tube.task_data;
import data_center.client_data;
import data_center.public_data;
import utility_funcs.deep_clone;
import utility_funcs.file_action;

public class export_dialog extends JDialog implements ChangeListener{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private task_data task_info;
	private view_data view_info;
	private client_data client_info;
	private JTabbedPane tabbed_pane;
	private preview_pane previe_gui;

	public export_dialog(
			main_frame main_view,
			client_data client_info,
			task_data task_info,
			view_data view_info){
		super(main_view, "Select and generate report", true);
		//this.setTitle("Select and generate report");
		//Image icon_image = Toolkit.getDefaultToolkit().getImage(public_data.ICON_FRAME_PNG);
		//this.setIconImage(icon_image);		
		this.task_info = task_info;
		this.view_info = view_info;
		this.client_info = client_info;
		Container container = this.getContentPane();
		container.add(construct_tab_pane(), BorderLayout.CENTER);
		this.setSize(900, 700);
	}

	private JTabbedPane construct_tab_pane(){
		tabbed_pane = new JTabbedPane(JTabbedPane.TOP, JTabbedPane.SCROLL_TAB_LAYOUT);
		tabbed_pane.addChangeListener(this);
		ImageIcon icon_image_suite = new ImageIcon(public_data.ICON_RPT_SUITE_PNG);
		ImageIcon icon_image_title = new ImageIcon(public_data.ICON_RPT_TITLE_PNG);
		ImageIcon icon_image_preview = new ImageIcon(public_data.ICON_RPT_PREVIEW_PNG);
		ImageIcon icon_image_generate = new ImageIcon(public_data.ICON_RPT_GENERATE_PNG);
		// pane 1: select suites
		tabbed_pane.addTab(report_enum.SUITE.toString(), icon_image_suite, new suite_pane(this, task_info, view_info), report_enum.SUITE.get_description());
		// pane 2: title pane
		tabbed_pane.addTab(report_enum.TITLE.toString(), icon_image_title, new title_pane(this, task_info, view_info), report_enum.TITLE.get_description());
		// pane 3: preview pane
		previe_gui = new preview_pane(this, task_info, view_info);
		tabbed_pane.addTab(report_enum.PREVIEW.toString(), icon_image_preview, previe_gui, report_enum.PREVIEW.get_description());
		Thread preview_thread = new Thread(previe_gui);
		preview_thread.start();
		previe_gui.wait_request();
		// pane 4: generate pane
		tabbed_pane.addTab(report_enum.GENERATE.toString(), icon_image_generate, new generate_pane(this, client_info, task_info, view_info), report_enum.GENERATE.get_description());
		return tabbed_pane;
	}
	
	@Override
	public void stateChanged(ChangeEvent arg0) {
		// TODO Auto-generated method stub
		int select_index = tabbed_pane.getSelectedIndex();
		tabbed_pane.setSelectedIndex(select_index);
	}
	
	public void close_dialog(){
		previe_gui.soft_stop();
		this.setVisible(false);
		this.dispose();
	}
	
	public void go_to_next_pane(){
		int select_index = tabbed_pane.getSelectedIndex();
		int result_index = 0;
		if(select_index >= report_enum.values().length - 1){
			tabbed_pane.setSelectedIndex(select_index);
			result_index = select_index;
		} else {
			tabbed_pane.setSelectedIndex(select_index + 1);
			result_index = select_index + 1;
		}
		if(result_index == report_enum.PREVIEW.get_index()){
			previe_gui.wake_request();
		} else {
			previe_gui.wait_request();
		}
	}
	
	public void go_to_previous_pane(){
		int select_index = tabbed_pane.getSelectedIndex();
		int result_index = 0;
		if(select_index <= 0){
			tabbed_pane.setSelectedIndex(select_index);
			result_index = select_index;
		} else {
			tabbed_pane.setSelectedIndex(select_index - 1);
			result_index = select_index - 1;
		}
		if(result_index == report_enum.PREVIEW.get_index()){
			previe_gui.wake_request();
		} else {
			previe_gui.wait_request();
		}		
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
			} else if (!task_info.get_captured_admin_queues_treemap().containsKey(queue_name)){
				status = "Unknown";
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
		suite_table.setRowHeight(24);
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
					view_info.add_export_queue_list(queue_name);
				} else {
					view_info.remove_export_queue_list(queue_name);
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
		title_table.setRowHeight(24);
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

class preview_pane extends JPanel implements ActionListener, Runnable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private export_dialog tabbed_pane;
	private task_data task_info;
	private view_data view_info;
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread current_thread;
	private Vector<String> table_column = new Vector<String>();
	private Vector<Vector<Object>> table_data = new Vector<Vector<Object>>();	
	private JTable preview_table;
	private JPanel top_panel;
	private DefaultTableModel data_model;
	private JButton previous, next;
	private static final Logger PREVIEW_PANE_LOGGER = LogManager.getLogger(preview_pane.class.getName());
	
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
		top_panel = new JPanel(new BorderLayout());
		data_model = new DefaultTableModel();
		//table_column.add("ID");
		//table_column.add("Design");
		//table_column.add("Status");
		//preview_table = new JTable(table_data, table_column);
		data_model.setDataVector(table_data, table_column);
		preview_table = new JTable(data_model); 
		//preview_table.getColumn("ID").setMaxWidth(50);
		preview_table.setRowHeight(24);
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

	private void update_table_column(){
		table_column.clear();
		table_column.addAll(view_info.get_export_title_list());
	}
	
	private void update_table_data(){
		table_data.clear();
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
	public void run() {
		// TODO Auto-generated method stub
		while (!stop_request) {
			if (wait_request) {
				try {
					synchronized (this) {
						this.wait();
					}
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} else {
				PREVIEW_PANE_LOGGER.info("preview runner Thread running...");
			}
			// ============== All dynamic job start from here ==============			
			update_table_column();
			update_table_data();
			data_model.setDataVector(table_data, table_column);
			//System.out.println(">>>>>>>>>>>>>>>>>>>>>>");
			//System.out.println(table_column.toString());
			//System.out.println(table_data.toString());
			if (SwingUtilities.isEventDispatchThread()) {
				preview_table.validate();
				preview_table.updateUI();
				top_panel.updateUI();
			} else {
				SwingUtilities.invokeLater(new Runnable(){
					@Override
					public void run() {
						// TODO Auto-generated method stub
						preview_table.validate();
						preview_table.updateUI();
						top_panel.updateUI();
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
	
	public void soft_stop() {
		stop_request = true;
	}

	public void hard_stop() {
		stop_request = true;
		if (current_thread != null) {
			current_thread.interrupt();
		}
	}

	public void wait_request() {
		wait_request = true;
	}

	public void wake_request() {
		wait_request = false;
		synchronized (this) {
			this.notify();
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
	private Vector<Vector<String>> table_data = new Vector<Vector<String>>();
	private JTextField file_path = new JTextField("");
	private JTextField file_name = new JTextField("");
	private JButton open = new JButton("Open");
	private JButton close = new JButton("Close");
	private JButton generate = new JButton("Generate");
	private JButton clear = new JButton("Clear");
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
		this.setLayout(new BorderLayout());
		this.add(construct_top_panel(), BorderLayout.CENTER);
		this.add(construct_buttom_panel(), BorderLayout.SOUTH);
	}
		
	private JPanel construct_top_panel(){
		//JPanel top_panel = new JPanel(new GridLayout(11,3,5,5));
		GridBagLayout layout = new GridBagLayout();
		JPanel top_panel = new JPanel(layout);
		if (client_info.get_client_data().containsKey("preference")){
			file_path.setText(client_info.get_client_data().get("preference").get("work_path"));
		} else {
			file_path.setText("NA");
		}
		file_name.setText("client_report.csv");
		JLabel general = new JLabel("Please select and click \"Generate\" button.");
		JLabel path_label = new JLabel("Export Path:");
		JLabel blank_label1 = new JLabel("");
		JLabel blank_label2 = new JLabel("");
		JLabel blank_label3 = new JLabel("");
		JLabel blank_label4 = new JLabel("");
		JLabel file_label = new JLabel("Export Name:");
		JLabel blank_cell1 = new JLabel("");
		JLabel blank_cell2 = new JLabel("");
		top_panel.add(general);
		top_panel.add(blank_label1);
		top_panel.add(path_label);
		top_panel.add(file_path);
		top_panel.add(open);
		open.addActionListener(this);
		top_panel.add(blank_label2);
		top_panel.add(file_label);
		top_panel.add(file_name);
		top_panel.add(clear);
		clear.addActionListener(this);
		top_panel.add(blank_label3);		
		top_panel.add(blank_cell1);
		top_panel.add(blank_cell2);
		top_panel.add(generate);
		generate.addActionListener(this);
		top_panel.add(close);
		close.addActionListener(this);
		top_panel.add(blank_label4);
		//setting constrains =============================
		GridBagConstraints s = new GridBagConstraints();
		s.fill = GridBagConstraints.BOTH;
		//general
        s.gridwidth=0;
        s.weightx = 0;
        s.weighty=0.2;
        layout.setConstraints(general, s);
        //blank_label1
        s.gridwidth=0;
        s.weightx = 0;
        s.weighty=0.5;
        layout.setConstraints(blank_label1, s);        
		//path_label
        s.gridwidth=1;
        s.weightx = 0;
        s.weighty=0;
        layout.setConstraints(path_label, s);
        //file_path
        s.gridwidth=3;
        s.weightx = 0;
        s.weighty=0;
        layout.setConstraints(file_path, s);
        //open
        s.gridwidth=0;
        s.weightx = 0;
        s.weighty=0;
        layout.setConstraints(open, s); 
        //blank_label2
        s.gridwidth=0;
        s.weightx = 0;
        s.weighty=0.2;
        layout.setConstraints(blank_label2, s);
        //file_label
        s.gridwidth=1;
        s.weightx = 0;
        s.weighty=0;
        layout.setConstraints(file_label, s); 
        //file_name
        s.gridwidth=3;
        s.weightx = 0;
        s.weighty=0;
        layout.setConstraints(file_name, s);
        //clear
        s.gridwidth=0;
        s.weightx = 0;
        s.weighty=0;
        layout.setConstraints(clear, s);
        //blank_label3
        s.gridwidth=0;
        s.weightx = 0;
        s.weighty=0.5;
        layout.setConstraints(blank_label3, s);        
        //blank_cell1
        s.gridwidth=1;
        s.weightx = 0;
        s.weighty=0;
        layout.setConstraints(blank_cell1, s);
        //blank_cell2
        s.gridwidth=2;
        s.weightx = 1;
        s.weighty=0;
        layout.setConstraints(blank_cell2, s);
        //generate
        s.gridwidth=1;
        s.weightx = 0;
        s.weighty=0;
        layout.setConstraints(generate, s);
        //close
        s.gridwidth=0;
        s.weightx = 0;
        s.weighty=0;
        layout.setConstraints(close, s);
        //blank_label4
        s.gridwidth=0;
        s.weightx = 0;
        s.weighty=0;
        layout.setConstraints(blank_label4, s);        
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
		System.out.println("queue list:" + queue_list.toString());
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
				Vector<String> initial_line = new Vector<String>();				
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
			String next_line = System.getProperty("line.separator");
			StringBuilder contents = new StringBuilder();
			contents.append(String.join(",", table_column) + next_line);
			for (Vector<String> line_data : table_data){
				contents.append(String.join(",", line_data) + next_line);
			}
			file_action.force_write_file(export_file, contents.toString());
		}
		if(arg0.getSource().equals(clear)){
			file_name.setText("");
		}
		if(arg0.getSource().equals(close)){
			tabbed_pane.close_dialog();
		}		
		if(arg0.getSource().equals(open)){
			//JFileChooser import_file =  new JFileChooser(work_path);
			JFileChooser import_path =  new JFileChooser(public_data.DEF_WORK_PATH);
			import_path.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);//
			import_path.setDialogTitle("Select Export Folder");
			int return_value = import_path.showOpenDialog(null);
			if (return_value == JFileChooser.APPROVE_OPTION){
				File open_path = import_path.getSelectedFile();
				String path = open_path.getAbsolutePath().replaceAll("\\\\", "/");
				file_path.setText(path);
			}
		}		
		if(arg0.getSource().equals(previous)){
			tabbed_pane.go_to_previous_pane();
		}
		if(arg0.getSource().equals(next)){
			tabbed_pane.go_to_next_pane();
		}
	}
}
