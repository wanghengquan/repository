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
import java.awt.Desktop;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.Vector;

import javax.swing.JMenu;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JPopupMenu;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.JTable;
import javax.swing.SwingUtilities;
//import javax.swing.table.AbstractTableModel;
//import javax.swing.table.DefaultTableModel;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.task_data;
import connect_tube.taskid_compare;
import data_center.client_data;
import flow_control.import_data;
import flow_control.task_enum;
import utility_funcs.deep_clone;
import utility_funcs.time_info;

public class work_panel extends JSplitPane implements Runnable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static final Logger WORK_PANEl_LOGGER = LogManager.getLogger(work_panel.class.getName());
	private view_data view_info;
	private task_data task_info;
	private client_data client_info;
	private panel_table work_table;
	private Vector<String> work_column = new Vector<String>();
	private Vector<Vector<String>> work_data = new Vector<Vector<String>>(); //show on table

	public work_panel(view_data view_info, client_data client_info, task_data task_info) {
		super();//default constructor
		this.view_info = view_info;
		this.client_info = client_info;
		this.task_info = task_info;
		work_column.add("ID");
		work_column.add("Suite");
		work_column.add("Design");
		work_column.add("Status");
		work_column.add("Reason");
		work_column.add("Time");
		work_table = new panel_table(work_data, work_column);
		work_table.getColumn("ID").setMinWidth(50);
		work_table.getColumn("ID").setMaxWidth(150);
		work_table.getColumn("Suite").setMinWidth(100);
		work_table.getColumn("Suite").setMaxWidth(250);
		work_table.getColumn("Design").setMinWidth(300);
		work_table.getColumn("Status").setMinWidth(100);
		work_table.getColumn("Status").setMaxWidth(200);
		work_table.getColumn("Reason").setMinWidth(100);
		work_table.getColumn("Time").setMinWidth(150);
		work_table.getColumn("Time").setMaxWidth(200);
		this.setDividerLocation(300);
		this.setDividerSize(10);
		this.setOneTouchExpandable(true);
		this.setContinuousLayout(true);
		queue_panel admin_insts = new queue_panel(view_info, client_info, task_info);
		this.setLeftComponent(admin_insts);
		this.setRightComponent(panel_right_component());
		new Thread(admin_insts).start();
	}

	private int get_processing_lines(panel_table work_table){
		int proc_lines = 0;
		int[] select_rows = work_table.getSelectedRows();
		for(int row_index : select_rows){
			String status = (String) work_table.getValueAt(row_index, 3);
			if (status.equalsIgnoreCase("processing")){
				proc_lines++;
			}
		}
		return proc_lines;
	}
	
	private Component panel_right_component() {
		JPanel work_panel = new JPanel(new BorderLayout());
		table_pop_memu table_menu = new table_pop_memu(work_table, task_info, view_info);
		work_table.setShowVerticalLines(true);
		work_table.setShowHorizontalLines(true);
		work_table.addMouseListener(new MouseAdapter() {
			//for windows popmenu
			public void mouseReleased(MouseEvent e) {
				if (work_table.getSelectedRows().length > 0) {
					if (e.isPopupTrigger()) {
						if(get_processing_lines(work_table) > 0){
							table_menu.enable_terminate_item();
						} else {
							table_menu.disable_terminate_item();
						}
						table_menu.show(e.getComponent(), e.getX(), e.getY());
					}
				} else {
					WORK_PANEl_LOGGER.info("No line selected");
				}
			}
			//for linux popmenu
			public void mousePressed(MouseEvent e) {
				if (work_table.getSelectedRows().length > 0) {
					if (e.isPopupTrigger()) {
						if(get_processing_lines(work_table) > 0){
							table_menu.enable_terminate_item();
						} else {
							table_menu.disable_terminate_item();
						}						
						table_menu.show(e.getComponent(), e.getX(), e.getY());
					}
				} else {
					WORK_PANEl_LOGGER.info("No line selected");
				}
			}
			
			public void mouseClicked(MouseEvent e) {
				if (work_table.getSelectedRows().length > 0) {
					int i = e.getButton();
					if(i != MouseEvent.BUTTON1){
						WORK_PANEl_LOGGER.info("non Button1 clicked, skip.");
						return;
					}
					int click_count = e.getClickCount();
					if(click_count < 2){
						WORK_PANEl_LOGGER.info("click count:" + String.valueOf(click_count) + ", skip.");
						return;
					}
					String select_task = (String) work_table.getValueAt(work_table.getSelectedRow(), 0);
					WORK_PANEl_LOGGER.warn("clicked task:" + select_task);
					table_menu.open_result_folder(select_task);
				} else {
					WORK_PANEl_LOGGER.error("No line selected");
				}
			}		
		});
		JScrollPane scroll_panel = new JScrollPane(work_table);
		work_panel.add(scroll_panel);
		return work_panel;
	}
	

	private Vector<String> get_one_report_line(
			HashMap<String, HashMap<String, String>> design_data, 
			watch_enum watching_area) {
		Vector<String> add_line = new Vector<String>();
		if(!watching_area.equals(watch_enum.ALL)){
			if(!design_data.get("Status").containsKey("cmd_status")){
				return add_line;//empty line which will be ignore
			}
		}
		if(watching_area.equals(watch_enum.PASSED)){
			if (!design_data.get("Status").get("cmd_status").equals(task_enum.PASSED.get_description())){
				return add_line;//non-passed line which will be ignore
			}
		}
		if(watching_area.equals(watch_enum.FAILED)){
			if (!design_data.get("Status").get("cmd_status").equals(task_enum.FAILED.get_description())){
				return add_line;//non-failed line which will be ignore
			}
		}
		if(watching_area.equals(watch_enum.TBD)){
			if (!design_data.get("Status").get("cmd_status").equals(task_enum.TBD.get_description())){
				return add_line;//non-tbd line which will be ignore
			}
		}		
		if(watching_area.equals(watch_enum.TIMEOUT)){
			if (!design_data.get("Status").get("cmd_status").equals(task_enum.TIMEOUT.get_description())){
				return add_line;//non-timeout line which will be ignore
			}
		}
		if(watching_area.equals(watch_enum.PROCESSING)){
			if (!design_data.get("Status").get("cmd_status").equals(task_enum.PROCESSING.get_description())){
				return add_line;//non-processing line which will be ignore
			}
		}
		if(watching_area.equals(watch_enum.WAITING)){
			if (!design_data.get("Status").get("cmd_status").equals(task_enum.WAITING.get_description())){
				return add_line;//non-waiting line which will be ignore
			}
		}		
		if (design_data.get("ID").containsKey("id")) {
			add_line.add(design_data.get("ID").get("id"));
		} else {
			add_line.add("NA");
		}
		if (design_data.get("ID").containsKey("suite")) {
			add_line.add(design_data.get("ID").get("suite"));
		} else {
			add_line.add("NA");
		}
		if (design_data.get("CaseInfo").containsKey("design_name")) {
			add_line.add(design_data.get("CaseInfo").get("design_name"));
		} else {
			add_line.add("NA");
		}
		if (design_data.get("Status").containsKey("cmd_status")) {
			add_line.add(design_data.get("Status").get("cmd_status"));
		} else {
			add_line.add("Waiting");
		}
		if (design_data.get("Status").containsKey("cmd_reason")) {
			add_line.add(design_data.get("Status").get("cmd_reason"));
		} else {
			add_line.add("NA");
		}
		if (design_data.get("Status").containsKey("run_time")) {
			add_line.add(design_data.get("Status").get("run_time"));
		} else {
			add_line.add("NA");
		}
		return add_line;
	}

	private Vector<Vector<String>> get_blank_data(){
		Vector<Vector<String>> blank_data = new Vector<Vector<String>>();
		Vector<String> add_line = new Vector<String>();
		add_line.add("No data found.");
		add_line.add("..");
		add_line.add("..");
		add_line.add("..");
		add_line.add("..");
		add_line.add("..");
		blank_data.add(add_line);
		return blank_data;
	}
	
	private Boolean update_working_queue_data() {
		Boolean show_update = new Boolean(true);
		String watching_queue = view_info.get_watching_queue();
		watch_enum watching_area = view_info.get_watching_queue_area();
		if (watching_queue.equals("")) {
			return show_update; // no watching queue selected
		}
		if (watching_area.equals(watch_enum.UNKNOWN)){
			watching_area = watch_enum.ALL;
		}
		Vector<Vector<String>> new_data = new Vector<Vector<String>>();
		Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> processed_task_queues_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
		// try import non exists queue data
		if (!task_info.get_processed_task_queues_map().containsKey(watching_queue)) {
			//both admin and task should be successfully import otherwise skip import
			import_disk_admin_data_to_processed_data(watching_queue);
			Boolean task_import_status = import_disk_task_data_to_processed_data(watching_queue);
			if (!task_import_status){
				WORK_PANEl_LOGGER.info("Import queue data failed:" + watching_queue + ", " + watching_area.get_description());
				work_data.clear();
				work_data.addAll(get_blank_data());
				return show_update; // no data show
			}
		}
		processed_task_queues_map.putAll(task_info.get_processed_task_queues_map());
		if (!processed_task_queues_map.containsKey(watching_queue)) {
			work_data.clear();
			work_data.addAll(get_blank_data());
			return show_update;
		}
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>(new taskid_compare());
		queue_data.putAll(deep_clone.clone(processed_task_queues_map.get(watching_queue)));
		if (queue_data.size() < 1) {
			work_data.clear();
			work_data.addAll(get_blank_data());
			return show_update;
		}
		Iterator<String> case_it = queue_data.keySet().iterator();
		while (case_it.hasNext()) {
			String case_id = case_it.next();
			HashMap<String, HashMap<String, String>> design_data = queue_data.get(case_id);
			Vector<String> add_line = get_one_report_line(design_data, watching_area);
			if(add_line.isEmpty()){
				continue;
			}
			new_data.add(add_line);
		}
		work_data.clear();
		work_data.addAll(new_data);
		return show_update;
	}	
	
	private Boolean import_disk_admin_data_to_processed_data(String queue_name) {
		Boolean import_status = new Boolean(false);
		HashMap<String, HashMap<String, String>> import_admin_data = new HashMap<String, HashMap<String, String>>();
		import_admin_data.putAll(
				import_data.import_disk_finished_admin_data(queue_name, client_info));
		if (import_admin_data.isEmpty()){
			import_status = false;
		} else {
			task_info.update_queue_to_processed_admin_queues_treemap(queue_name, import_admin_data);
			import_status = true;
		}		
		return import_status;
	}
	
	private Boolean import_disk_task_data_to_processed_data(String queue_name) {
		Boolean import_status = new Boolean(false);
		TreeMap<String, HashMap<String, HashMap<String, String>>> import_task_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		import_task_data.putAll(
				import_data.import_disk_finished_task_data(queue_name, client_info));
		if (import_task_data.isEmpty()){
			import_status = false;
		} else {
			task_info.update_queue_to_processed_task_queues_map(queue_name, import_task_data);
			import_status = true;
		}
		return import_status;
	}
	
	private Boolean update_selected_task_case(){
		Boolean update_status = new Boolean(false);
		int [] select_index = work_table.getSelectedRows();
		List<String> select_case = new ArrayList<String>();
		for (int index : select_index){
			if(work_table.getRowCount() > index){
				String case_id = (String) work_table.getValueAt(index, 0);
				select_case.add(case_id);
			}
		}
		view_info.set_select_task_case(select_case);
		return update_status;
	}
	
	@Override
	public void run() {
		// TODO Auto-generated method stub
		while (true) {
			if (view_info.get_view_debug()){
				Vector<Vector<String>> new_data = new Vector<Vector<String>>();
				for (int i = 0; i < 5; i++) {
					Vector<String> work_line = new Vector<String>();
					work_line.add(String.valueOf(i));
					work_line.add("suite");
					work_line.add("design");
					work_line.add("status");
					work_line.add("reason");
					work_line.add(time_info.get_man_date_time());
					new_data.add(work_line);
				}
				work_data.clear();
				work_data.addAll(new_data);
			} else {
				update_selected_task_case();
				update_working_queue_data();
			}
			if (SwingUtilities.isEventDispatchThread()) {
				work_table.validate();
				work_table.updateUI();
			} else {
				SwingUtilities.invokeLater(new Runnable(){
					@Override
					public void run() {
						// TODO Auto-generated method stub
						work_table.validate();
						work_table.updateUI();
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
}

class table_pop_memu extends JPopupMenu implements ActionListener {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private JTable table;
	private JMenuItem retest;
	private JMenuItem terminate;
	private view_data view_info;
	private task_data task_info;
	private JMenuItem view_all, view_processing, view_waiting, view_failed, view_passed, view_tbd, view_timeout;
	private JMenuItem details, results;
	private String line_separator = System.getProperty("line.separator");

	public table_pop_memu(JTable table, task_data task_info, view_data view_info) {
		this.table = table;
		this.task_info = task_info;
		this.view_info = view_info;
		retest = new JMenuItem("Retest");
		retest.addActionListener(this);
		terminate = new JMenuItem("Terminate");
		terminate.addActionListener(this);
		JMenu view = new JMenu("View");
		view_all = new JMenuItem(watch_enum.ALL.get_description());
		view_all.addActionListener(this);
		view_waiting = new JMenuItem(watch_enum.WAITING.get_description());
		view_waiting.addActionListener(this);
		view_processing = new JMenuItem(watch_enum.PROCESSING.get_description());
		view_processing.addActionListener(this);		
		view_failed = new JMenuItem(watch_enum.FAILED.get_description());
		view_failed.addActionListener(this);
		view_passed = new JMenuItem(watch_enum.PASSED.get_description());
		view_passed.addActionListener(this);
		view_tbd = new JMenuItem(watch_enum.TBD.get_description());
		view_tbd.addActionListener(this);		
		view_timeout = new JMenuItem(watch_enum.TIMEOUT.get_description());
		view_timeout.addActionListener(this);
		view.add(view_all);
		view.add(view_waiting);
		view.add(view_processing);
		view.add(view_failed);
		view.add(view_passed);
		view.add(view_tbd);
		view.add(view_timeout);
		details = new JMenuItem("Details");
		details.addActionListener(this);
		results = new JMenuItem("Results");
		results.addActionListener(this);
		this.add(retest);
		this.add(terminate);
		this.addSeparator();
		this.add(view);
		this.addSeparator();
		this.add(details);
		this.add(results);
	}

	public table_pop_memu get_table_pop_menu() {
		return this;
	} 
	
	public void disable_terminate_item() {
		terminate.setEnabled(false);
	}
	
	public void enable_terminate_item() {
		terminate.setEnabled(true);
	}
	
	public void open_result_folder(String prefer_id){
		String title = "Open Folder Failed:";
		String message = "Cannot open case result DIR, unknow error." + line_separator;			
		String watching_queue = view_info.get_watching_queue();
		List<String> case_list = view_info.get_select_task_case();
		if(case_list.size() < 1){
			JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
			return;
		}
		String case_id = new String();
		if (prefer_id == null){
			case_id = case_list.get(0);
		} else {
			case_id = prefer_id;
		}
		HashMap<String, HashMap<String, String>> case_data = new HashMap<String, HashMap<String, String>>();
		String work_path = new String();
		try{
			case_data.putAll(task_info.get_case_from_processed_task_queues_map(watching_queue, case_id));
			work_path = case_data.get("Status").get("location");
		} catch (Exception e){
			JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
			return;
		}
		message = "Can not open path with system register browser" + line_separator + work_path;
		if(Desktop.isDesktopSupported()){
			Desktop desktop = Desktop.getDesktop();
			try {
				desktop.open(new File(work_path));
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
			} catch (IllegalArgumentException e2){
				e2.printStackTrace();
				JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
			}
		} else {
			JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
		}	
	}
	
	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub
		if (arg0.getSource().equals(retest)) {
			System.out.println("retest clicked");
			view_info.set_retest_queue_area(retest_enum.SELECTED);
		}
		if (arg0.getSource().equals(terminate)) {
			System.out.println("terminate clicked");
			view_info.set_stop_case_request();
		}		
		if (arg0.getSource().equals(view_all)) {
			System.out.println("view all");
			view_info.set_watching_queue_area(watch_enum.ALL);
		}
		if (arg0.getSource().equals(view_processing)) {
			System.out.println("view failed");
			view_info.set_watching_queue_area(watch_enum.PROCESSING);
		}
		if (arg0.getSource().equals(view_waiting)) {
			System.out.println("view waiting");
			view_info.set_watching_queue_area(watch_enum.WAITING);
		}			
		if (arg0.getSource().equals(view_failed)) {
			System.out.println("view failed");
			view_info.set_watching_queue_area(watch_enum.FAILED);
		}
		if (arg0.getSource().equals(view_passed)) {
			System.out.println("view passed");
			view_info.set_watching_queue_area(watch_enum.PASSED);
		}
		if (arg0.getSource().equals(view_tbd)) {
			System.out.println("view tbd");
			view_info.set_watching_queue_area(watch_enum.TBD);
		}
		if (arg0.getSource().equals(view_timeout)) {
			System.out.println("view timeout");
			view_info.set_watching_queue_area(watch_enum.TIMEOUT);
		}
		if (arg0.getSource().equals(details)) {
			System.out.println("details clicked");
			String watching_queue = view_info.get_watching_queue();
			String select_case = (String) table.getValueAt(table.getSelectedRow(), 0);
			task_detail detail_view = new task_detail(watching_queue, select_case, task_info);
			detail_view.setVisible(true);			
		}
		if (arg0.getSource().equals(results)) {
			System.out.println("results clicked");
			open_result_folder(null);
		}
	}
}

// Unused!!!
/*
class work_table_model extends AbstractTableModel {

	private static final long serialVersionUID = 1L;
	private view_data view_info;

	public work_table_model(view_data view_info) {
		this.view_info = view_info;
	}

	@Override
	public int getColumnCount() {
		// TODO Auto-generated method stub
		//return view_info.get_work_column().size();
		return 6;
	}

	@Override
	public int getRowCount() {
		// TODO Auto-generated method stub
		return view_info.get_work_data().size();
	}

	@Override
	public Object getValueAt(int row, int column) {
		// TODO Auto-generated method stub
		if (!view_info.get_work_data().isEmpty()) {
			return ((Vector<String>) view_info.get_work_data().elementAt(row)).elementAt(column);
		} else {
			return null;
		}
	}
}
*/