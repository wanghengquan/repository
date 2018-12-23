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
//import java.util.Vector;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.Vector;

import javax.swing.JMenu;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JPopupMenu;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.JTable;
//import javax.swing.table.DefaultTableModel;
import javax.swing.ListSelectionModel;
import javax.swing.SwingUtilities;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.task_data;
import data_center.client_data;
import data_center.public_data;
import flow_control.queue_enum;
import utility_funcs.time_info;

public class queue_panel extends JSplitPane implements Runnable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 2L;
	private static final Logger QUEUE_PANEL_LOGGER = LogManager.getLogger(queue_panel.class.getName());
	private main_frame main_view;
	private view_data view_info;
	private client_data client_info;
	private task_data task_info;
	private panel_table reject_table;
	private panel_table capture_table;
	private Vector<String> reject_column = new Vector<String>();
	private Vector<String> capture_column = new Vector<String>();
	private Vector<Vector<String>> reject_data = new Vector<Vector<String>>(); // show
																				// on
																				// table
	private Vector<Vector<String>> capture_data = new Vector<Vector<String>>(); // show
																				// on
																				// table

	public queue_panel(main_frame main_view, view_data view_info, client_data client_info, task_data task_info) {
		super(JSplitPane.VERTICAL_SPLIT);
		this.main_view = main_view;
		this.view_info = view_info;
		this.task_info = task_info;
		this.client_info = client_info;
		reject_column.add("Rejected Queue");
		reject_column.add("Reason");
		capture_column.add("Captured Queue");
		capture_column.add("Status");
		reject_table = new panel_table(reject_data, reject_column);
		reject_table.getColumn("Rejected Queue").setMinWidth(150);
		reject_table.getColumn("Reason").setMinWidth(150);
		capture_table = new panel_table(capture_data, capture_column);
		capture_table.getColumn("Captured Queue").setMinWidth(150);
		capture_table.getColumn("Status").setMinWidth(100);		
		this.setDividerLocation(400);
		this.setDividerSize(10);
		this.setOneTouchExpandable(true);
		this.setContinuousLayout(true);
		this.setTopComponent(panel_top_component());
		this.setBottomComponent(panel_bottom_component());
	}

	private Component panel_top_component() {
		JPanel reject_panel = new JPanel(new BorderLayout());
		reject_table.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		reject_pop_memu reject_menu = new reject_pop_memu(main_view, reject_table, client_info, task_info, view_info);
		reject_table.addMouseListener(new MouseAdapter() {
			//for windows popmenu
			public void mouseReleased(MouseEvent e1) {
				if (reject_table.getSelectedRows().length > 0) {
					if (e1.isPopupTrigger()) {
						reject_menu.show(e1.getComponent(), e1.getX(), e1.getY());
					}
				} else {
					QUEUE_PANEL_LOGGER.info("No line selected");
				}
			}
			//for Linux popmenu
			public void mousePressed(MouseEvent e1) {
				if (reject_table.getSelectedRows().length > 0) {
					if (e1.isPopupTrigger()) {
						reject_menu.show(e1.getComponent(), e1.getX(), e1.getY());
					}
				} else {
					QUEUE_PANEL_LOGGER.info("No line selected");
				}
			}
			
			public void mouseClicked(MouseEvent e) {
				if (reject_table.getSelectedRows().length > 0) {
					int i = e.getButton();
					if(i != MouseEvent.BUTTON1){
						QUEUE_PANEL_LOGGER.info("non Button1 clicked, skip.");
						return;
					}
					int click_count = e.getClickCount();
					if(click_count < 2){
						QUEUE_PANEL_LOGGER.info("click count:" + String.valueOf(click_count) + ", skip.");
						return;
					}
					String select_queue = (String) reject_table.getValueAt(reject_table.getSelectedRow(), 0);
					QUEUE_PANEL_LOGGER.info("Enable queue:" + select_queue);
					reject_detail detail_view = new reject_detail(select_queue, client_info, task_info);
					detail_view.setLocationRelativeTo(main_view);
					detail_view.setVisible(true);
				} else {
					QUEUE_PANEL_LOGGER.error("No line selected");
				}
			}
		});
		JScrollPane scroll_panel = new JScrollPane(reject_table);
		reject_panel.add(scroll_panel);
		return reject_panel;
	}	
	
	private Boolean is_selected_queue_deletable(){
		Boolean run_status = new Boolean(false);
		String queue_name = (String) capture_table.getValueAt(capture_table.getSelectedRow(), 0);
		String status = (String) capture_table.getValueAt(capture_table.getSelectedRow(), 1);
		if(task_info.get_thread_pool_admin_queue_list().contains(queue_name)){
			return run_status;
		}
		switch (queue_enum.valueOf(status.toUpperCase())) {
		case FINISHED :
			run_status = true;
			break;
		case STOPPED :
			run_status = true;
			break;
		case PAUSED :
			run_status = true;
			break;			
		default:
			run_status = false;
			break;
		}
		return run_status;
	}
	
	private Boolean is_selected_queue_submitable(){
		Boolean run_status = new Boolean(false);
		String queue_name = (String) capture_table.getValueAt(capture_table.getSelectedRow(), 0);
		String status = (String) capture_table.getValueAt(capture_table.getSelectedRow(), 1);
		if(!status.equals(queue_enum.FINISHED.get_description())){
			return run_status;
		}
		if(task_info.get_thread_pool_admin_queue_list().contains(queue_name)){
			return run_status;
		}
		run_status = true;
		return run_status;
	}
	
	private Component panel_bottom_component() {
		JPanel capture_panel = new JPanel(new BorderLayout());
		capture_table.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		capture_pop_memu capture_menu = new capture_pop_memu(main_view, capture_table, task_info, client_info, view_info);
		capture_table.addMouseListener(new MouseAdapter() {
			//for windows popmenu
			public void mouseReleased(MouseEvent e) {
				if (capture_table.getSelectedRows().length > 0) {
					if (e.isPopupTrigger()) {
						//1. delete setting
						if (is_selected_queue_deletable()){
							capture_menu.enable_delete_item();
						} else {
							capture_menu.disable_delete_item();
						}
						//2. submit setting
						if (is_selected_queue_submitable()){
							capture_menu.enable_submit_item();
						} else {
							capture_menu.disable_submit_item();
						}
						//3. play stop pause setting
						String status = (String) capture_table.getValueAt(capture_table.getSelectedRow(), 1);
						// queue_enum status = queue_enum.valueOf((String) capture_table.getValueAt(capture_table.getSelectedRow(), 1));
						capture_menu.initial_queue_available_actions(status);
						capture_menu.show(e.getComponent(), e.getX(), e.getY());
					}
				} else {
					QUEUE_PANEL_LOGGER.info("No line selected");
				}
			}
			//for linux popmenu
			public void mousePressed(MouseEvent e) {
				if (capture_table.getSelectedRows().length > 0) {
					if (e.isPopupTrigger()) {
						//1. delete setting
						if (is_selected_queue_deletable()){
							capture_menu.enable_delete_item();
						} else {
							capture_menu.disable_delete_item();
						}
						//2. submit setting
						if (is_selected_queue_submitable()){
							capture_menu.enable_submit_item();
						} else {
							capture_menu.disable_submit_item();
						}						
						//3. play stop pause setting
						String status = (String) capture_table.getValueAt(capture_table.getSelectedRow(), 1);
						capture_menu.initial_queue_available_actions(status);						
						capture_menu.show(e.getComponent(), e.getX(), e.getY());
					}
				} else {
					QUEUE_PANEL_LOGGER.info("No line selected");
				}
			}
			
			public void mouseClicked(MouseEvent e) {
				if (capture_table.getSelectedRows().length > 0) {
					int i = e.getButton();
					if(i != MouseEvent.BUTTON1){
						QUEUE_PANEL_LOGGER.info("non Button1 clicked, skip.");
						return;
					}
					int click_count = e.getClickCount();
					if(click_count < 2){
						QUEUE_PANEL_LOGGER.info("click count:" + String.valueOf(click_count) + ", skip.");
						return;
					}
					String select_queue = (String) capture_table.getValueAt(capture_table.getSelectedRow(), 0);
					QUEUE_PANEL_LOGGER.info("Double click and show queue:" + select_queue);
					view_info.set_watching_queue(select_queue);
					view_info.set_watching_queue_area(watch_enum.ALL);
				} else {
					QUEUE_PANEL_LOGGER.error("No line selected");
				}
			}
		});
		JScrollPane scroll_panel = new JScrollPane(capture_table);
		capture_panel.add(scroll_panel);
		return capture_panel;
	}

	private Boolean update_rejected_queue_data() {
		Boolean show_update = new Boolean(false);
		TreeMap<String, String> rejected_treemap = task_info.get_rejected_admin_reason_treemap();// source
		Set<String> rejected_set = new TreeSet<String>(new queue_compare(view_info.get_rejected_sorting_request()));
		rejected_set.addAll(rejected_treemap.keySet());
		Iterator<String> rejected_it = rejected_set.iterator();
		Vector<Vector<String>> new_data = new Vector<Vector<String>>();
		while (rejected_it.hasNext()) {
			String queue_name = rejected_it.next();
			String reject_reason = rejected_treemap.get(queue_name);
			// add watching vector
			Vector<String> show_line = new Vector<String>();
			show_line.add(queue_name);
			show_line.add(reject_reason);
			new_data.add(show_line);
			show_update = true;
		}
		reject_data.clear();
		reject_data.addAll(new_data);
		return show_update;
	}

	private Boolean update_captured_queue_data() {
		Boolean show_update = new Boolean(false);
		Set<String> captured_set = new TreeSet<String>(new queue_compare(view_info.get_captured_sorting_request()));
		captured_set.addAll(task_info.get_captured_admin_queues_treemap().keySet());
		//Set<String> captured_set = task_info.get_captured_admin_queues_treemap().keySet();
		ArrayList<String> processing_admin_queue_list = task_info.get_processing_admin_queue_list();
		ArrayList<String> running_admin_queue_list = task_info.get_running_admin_queue_list();
		ArrayList<String> finished_admin_queue_list = task_info.get_finished_admin_queue_list();
		ArrayList<String> emptied_admin_queue_list = task_info.get_emptied_admin_queue_list();
		captured_set.addAll(emptied_admin_queue_list);// source data
		captured_set.addAll(finished_admin_queue_list);
		// //show data
		Iterator<String> captured_it = captured_set.iterator();
		Vector<Vector<String>> vector_data = new Vector<Vector<String>>();
		TreeMap<String, queue_enum> treemap_data = new TreeMap<String, queue_enum>(new queue_compare(view_info.get_captured_sorting_request()));
		while (captured_it.hasNext()) {
			String queue_name = captured_it.next();
			queue_enum status = queue_enum.UNKNOWN;
			//start the priority, running is the second level info base on first level(processing, stopped, paused, finished)
			if (finished_admin_queue_list.contains(queue_name)) {
				status = queue_enum.FINISHED;
			} else if (emptied_admin_queue_list.contains(queue_name)) {
				status = queue_enum.PROCESSING;				
			} else if (processing_admin_queue_list.contains(queue_name)) {
				status = queue_enum.PROCESSING;
			} else {
				String admin_status = task_info.get_captured_admin_queues_treemap().get(queue_name).get("Status")
						.get("admin_status");
				if (admin_status.equals(queue_enum.STOPPED.get_description())){
					status = queue_enum.STOPPED;
				} else if (admin_status.equals(queue_enum.REMOTESTOPED.get_description())){
					status = queue_enum.STOPPED;
				} else if (admin_status.equals(queue_enum.PAUSED.get_description())){
					status = queue_enum.PAUSED;
				} else if (admin_status.equals(queue_enum.REMOTEPAUSED.get_description())){
					status = queue_enum.PAUSED;
				} else if (admin_status.equals(queue_enum.PROCESSING.get_description())){
					status = queue_enum.PROCESSING;
				} else if (admin_status.equals(queue_enum.REMOTEPROCESSIONG.get_description())) {
					status = queue_enum.PROCESSING;
				} else if (admin_status.equals(queue_enum.REMOTEDONE.get_description())) {
					status = queue_enum.FINISHED;
				} else {
					status = queue_enum.UNKNOWN;
				}
			}
			if (status.equals(queue_enum.PROCESSING)){
				if (running_admin_queue_list.contains(queue_name)){
					status = queue_enum.RUNNING;
				}
			}
			// watching vector data
			Vector<String> show_line = new Vector<String>();
			show_line.add(queue_name);
			show_line.add(status.get_description());
			vector_data.add(show_line);
			// watching map data for future sorting
			treemap_data.put(queue_name, status);
			show_update = true;
		}
		capture_data.clear();
		//sort by status data update
		if (view_info.get_captured_sorting_request().equals(sort_enum.STATUS)){
			capture_data.addAll(get_status_sorted_data(treemap_data));
		} else {
			capture_data.addAll(vector_data);
		}
		return show_update;
	}

	private Vector<Vector<String>> get_status_sorted_data(
			TreeMap<String, queue_enum> ori_data){
		Vector<Vector<String>> status_sorted_data = new Vector<Vector<String>>();
        for (int index = 0; index < queue_enum.values().length; index++ ){
        	Iterator<String> queue_it = ori_data.keySet().iterator();
        	while(queue_it.hasNext()){
        		String queue_name = queue_it.next();
        		queue_enum queue_status = ori_data.get(queue_name);
        		if (queue_status.get_index() == index){
        			Vector<String> show_line = new Vector<String>();
        			show_line.add(queue_name);
        			show_line.add(queue_status.get_description());
        			status_sorted_data.add(show_line);
        		}
        	}
        }
		return status_sorted_data;
	}
	
	private Boolean update_select_rejected_queue() {
		Boolean update_status = new Boolean(true);
		String selected_queue = new String();
		int select_index = reject_table.getSelectedRow();
		int total_rows = reject_table.getRowCount();
		if (select_index >= 0 && select_index < total_rows) {
			selected_queue = (String) reject_table.getValueAt(select_index, 0);
		} else {
			update_status = false;
		}
		view_info.set_select_rejected_queue_name(selected_queue);
		return update_status;
	}

	private Boolean update_select_captured_queue() {
		Boolean update_status = new Boolean(true);
		String selected_queue = new String();
		int select_index = capture_table.getSelectedRow();
		int total_rows = capture_table.getRowCount();
		if (select_index >= 0 && select_index < total_rows) {
			selected_queue = (String) capture_table.getValueAt(select_index, 0);
		} else {
			update_status = false;
		}
		view_info.set_select_captured_queue_name(selected_queue);
		return update_status;
	}

	@Override
	public void run() {
		// TODO Auto-generated method stub
		while (true) {
			if (view_info.get_view_debug()) {
				Vector<Vector<String>> reject_new = new Vector<Vector<String>>();
				for (int i = 0; i < 5; i++) {
					Vector<String> reject_line = new Vector<String>();
					reject_line.add("001@run123_" + String.valueOf(i));
					reject_line.add(time_info.get_date_time());
					reject_new.add(reject_line);
				}
				reject_data.clear();
				reject_data.addAll(reject_new);
				Vector<Vector<String>> capture_new = new Vector<Vector<String>>();
				for (int i = 0; i < 5; i++) {
					Vector<String> capture_line = new Vector<String>();
					capture_line.add("001@run123_" + String.valueOf(i));
					capture_line.add(time_info.get_date_time());
					capture_new.add(capture_line);
				}
				capture_data.clear();
				capture_data.addAll(capture_new);
				SwingUtilities.invokeLater(new Runnable() {
					@Override
					public void run() {
						// TODO Auto-generated method stub
						reject_table.validate();
						reject_table.updateUI();
						capture_table.validate();
						capture_table.updateUI();
					}
				});				
			} else {
				SwingUtilities.invokeLater(new Runnable() {
					@Override
					public void run() {
						// TODO Auto-generated method stub
						update_select_rejected_queue();
						update_select_captured_queue();
						update_rejected_queue_data();
						update_captured_queue_data();						
						reject_table.validate();
						reject_table.updateUI();
						capture_table.validate();
						capture_table.updateUI();
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

class reject_pop_memu extends JPopupMenu implements ActionListener {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private main_frame main_view;
	private JTable table;
	private client_data client_info;
	private task_data task_info;
	private view_data view_info;
	private JMenuItem sort_priority, sort_runid, sort_time;
	private JMenuItem details, delete;

	public reject_pop_memu(main_frame main_view, JTable table, client_data client_info, task_data task_info, view_data view_info) {
		this.main_view = main_view;
		this.table = table;
		this.client_info = client_info;
		this.task_info = task_info;
		this.view_info = view_info;
		//sorting function
		JMenu sort = new JMenu("Sort");
		sort_priority = new JMenuItem("Priority");
		sort_priority.addActionListener(this);
		sort_runid = new JMenuItem("RunID");
		sort_runid.addActionListener(this);
		sort_time = new JMenuItem("Time");
		sort_time.addActionListener(this);
		sort.add(sort_priority);
		sort.add(sort_runid);
		sort.add(sort_time);
		this.add(sort);
		this.addSeparator();
		//details function
		details = new JMenuItem("Details");
		details.addActionListener(this);
		this.add(details);
		//delete function
		delete = new JMenuItem("Delete");
		delete.addActionListener(this);
		this.add(delete);
	}

	public reject_pop_memu get_reject_pop_menu() {
		return this;
	}

	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub
		if (arg0.getSource().equals(sort_priority)) {
			System.out.println("sort_priority clicked");
			view_info.set_rejected_sorting_request(sort_enum.PRIORITY);
		}
		if (arg0.getSource().equals(sort_runid)) {
			System.out.println("sort_runid clicked");
			view_info.set_rejected_sorting_request(sort_enum.RUNID);
		}
		if (arg0.getSource().equals(sort_time)) {
			System.out.println("sort_time clicked");
			view_info.set_rejected_sorting_request(sort_enum.TIME);
		}		
		if (arg0.getSource().equals(details)) {
			System.out.println("reject details clicked");
			String select_queue = (String) table.getValueAt(table.getSelectedRow(), 0);
			reject_detail detail_view = new reject_detail(select_queue, client_info, task_info);
			detail_view.setLocationRelativeTo(main_view);
			detail_view.setVisible(true);
		}
		if (arg0.getSource().equals(delete)) {
			System.out.println("reject delete clicked");
			String select_queue = (String) table.getValueAt(table.getSelectedRow(), 0);
			task_info.remove_queue_from_received_admin_queues_treemap(select_queue);
			task_info.remove_rejected_admin_reason_treemap(select_queue);// source
		}	
	}
}

class capture_pop_memu extends JPopupMenu implements ActionListener {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private JTable table;
	private JMenuItem show;
	private JMenuItem sort_priority, sort_runid, sort_time, sort_status;
	private JMenuItem run_play, run_pause, run_stop;
	private JMenuItem details, results, submit;
	private JMenuItem delete;
	private main_frame main_view;
	private task_data task_info;
	private client_data client_info;
	private view_data view_info;
	private String line_separator = System.getProperty("line.separator");
	private String file_seprator = System.getProperty("file.separator");

	public capture_pop_memu(main_frame main_view, JTable table, task_data task_info, client_data client_info, view_data view_info) {
		this.main_view = main_view;
		this.table = table;
		this.task_info = task_info;
		this.client_info = client_info;
		this.view_info = view_info;
		show = new JMenuItem("Show");
		show.addActionListener(this);
		this.add(show);
		this.addSeparator();
		JMenu sort = new JMenu("Sort");
		sort_priority = new JMenuItem("Priority");
		sort_priority.addActionListener(this);
		sort_runid = new JMenuItem("RunID");
		sort_runid.addActionListener(this);
		sort_time = new JMenuItem("Time");
		sort_time.addActionListener(this);
		sort_status = new JMenuItem("Status");
		sort_status.addActionListener(this);		
		sort.add(sort_priority);
		sort.add(sort_runid);
		sort.add(sort_time);
		sort.add(sort_status);
		this.add(sort);
		this.addSeparator();
		JMenu run = new JMenu("Run");
		run_play = new JMenuItem("Play");
		run_play.addActionListener(this);
		run_pause = new JMenuItem("Pause");
		run_pause.addActionListener(this);
		run_stop = new JMenuItem("Stop");
		run_stop.addActionListener(this);
		run.add(run_play);
		run.add(run_pause);
		run.add(run_stop);
		this.add(run);
		this.addSeparator();
		details = new JMenuItem("Details");
		details.addActionListener(this);
		results = new JMenuItem("Results");
		results.addActionListener(this);
		submit = new JMenuItem("Submit");
		submit.addActionListener(this);		
		this.add(details);
		this.add(results);
		this.add(submit);
		this.addSeparator();
		delete = new JMenuItem("Delete");
		delete.addActionListener(this);
		this.add(delete);
	}

	public capture_pop_memu get_capture_pop_menu() {
		return this;
	}

	public void disable_submit_item() {
		submit.setEnabled(false);
	}

	public void enable_submit_item() {
		submit.setEnabled(true);
	}	
	
	public void disable_delete_item() {
		delete.setEnabled(false);
	}

	public void enable_delete_item() {
		delete.setEnabled(true);
	}
	
	public void initial_queue_available_actions(String action){
		if (action.equals(queue_enum.FINISHED.get_description())){
			run_play.setEnabled(false);
			run_pause.setEnabled(false);
			run_stop.setEnabled(true);
		} else if (action.equals(queue_enum.STOPPED.get_description())){
			run_play.setEnabled(true);
			run_pause.setEnabled(false);
			run_stop.setEnabled(false);			
		} else if (action.equals(queue_enum.PAUSED.get_description())){
			run_play.setEnabled(true);
			run_pause.setEnabled(false);
			run_stop.setEnabled(true);			
		} else if (action.equals(queue_enum.PROCESSING.get_description())){
			run_play.setEnabled(false);
			run_pause.setEnabled(true);
			run_stop.setEnabled(true);			
		} else if (action.equals(queue_enum.RUNNING.get_description())){
			run_play.setEnabled(false);
			run_pause.setEnabled(true);
			run_stop.setEnabled(true);			
		} else {
			run_play.setEnabled(false);
			run_pause.setEnabled(false);
			run_stop.setEnabled(false);	
		}
	}
	
	public void open_result_folder(String queue_name){
		String title = "Open Folder Failed:";
		String message = new String("");
		if (queue_name == null){
			message = "Cannot open run DIR, unknow error." + line_separator;
			JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
			return;			
		}
		HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
		if (task_info.get_captured_admin_queues_treemap().containsKey(queue_name)){
			admin_data.putAll(task_info.get_captured_admin_queues_treemap().get(queue_name));
		} else if (task_info.get_processed_admin_queues_treemap().containsKey(queue_name)){
			admin_data.putAll(task_info.get_processed_admin_queues_treemap().get(queue_name));
		} else {
			message = "Cannot open run DIR, "+ queue_name + " not exists." + line_separator;
			JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
			return;	
		}
		HashMap<String, String> preference_data = new HashMap<String, String>();
		preference_data.putAll(client_info.get_client_preference_data());
		//get work_space
		// common info prepare
		String xlsx_dest = new String("NA");
		if (admin_data.get("CaseInfo").containsKey("xlsx_dest")){
			xlsx_dest = admin_data.get("CaseInfo").get("xlsx_dest").trim();
		}
		String repository = admin_data.get("CaseInfo").get("repository").trim();	
		String suite_path = admin_data.get("CaseInfo").get("suite_path").trim();	
		String tmp_result = public_data.WORKSPACE_RESULT_DIR;
		String prj_name = "prj" + admin_data.get("ID").get("project");
		String run_name = "run" + admin_data.get("ID").get("run");
		String work_space = preference_data.get("work_space");
		String case_mode = preference_data.get("case_mode");
		String task_path = new String("");
		//get depot_space
		repository = repository.replaceAll("\\$xlsx_dest", xlsx_dest);
		String depot_space = repository + "/" + suite_path;
		//get work_path
		if (case_mode.equalsIgnoreCase("keep_case")){
			task_path = depot_space;
		} else {
			String[] path_array = new String[] { work_space, tmp_result, prj_name, run_name };
			task_path = String.join(file_seprator, path_array);	
		}	
		File task_path_fobj = new File(task_path);
		if(!task_path_fobj.exists()){
			message = "Cannot open run DIR, "+ task_path + " not exists." + line_separator;
			JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
			return;			
		}
		message = "Can not open path with system register browser" + line_separator + task_path;
		if(Desktop.isDesktopSupported()){
			Desktop desktop = Desktop.getDesktop();
			try {
				desktop.open(task_path_fobj);
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
		if (arg0.getSource().equals(show)) {
			System.out.println("show details clicked");
			String select_queue = (String) table.getValueAt(table.getSelectedRow(), 0);
			view_info.set_watching_queue(select_queue);
			view_info.set_watching_queue_area(watch_enum.ALL);
		}
		if (arg0.getSource().equals(sort_priority)) {
			System.out.println("sort_priority clicked");
			view_info.set_captured_sorting_request(sort_enum.PRIORITY);
		}
		if (arg0.getSource().equals(sort_runid)) {
			System.out.println("sort_runid clicked");
			view_info.set_captured_sorting_request(sort_enum.RUNID);
		}
		if (arg0.getSource().equals(sort_time)) {
			System.out.println("sort_time clicked");
			view_info.set_captured_sorting_request(sort_enum.TIME);
		}
		if (arg0.getSource().equals(sort_status)) {
			System.out.println("sort_status clicked");
			view_info.set_captured_sorting_request(sort_enum.STATUS);
		}		
		if (arg0.getSource().equals(run_play)) {
			System.out.println("run_play clicked");
			view_info.set_run_action_request(queue_enum.PROCESSING);
		}
		if (arg0.getSource().equals(run_pause)) {
			System.out.println("run_pause clicked");
			view_info.set_run_action_request(queue_enum.PAUSED);
		}
		if (arg0.getSource().equals(run_stop)) {
			System.out.println("run_stop clicked");
			view_info.set_run_action_request(queue_enum.STOPPED);
		}
		if (arg0.getSource().equals(details)) {
			System.out.println("detail clicked");
			String select_queue = (String) table.getValueAt(table.getSelectedRow(), 0);
			capture_detail detail_view = new capture_detail(select_queue, task_info);
			detail_view.setLocationRelativeTo(main_view);
			detail_view.setVisible(true);
		}	
		if (arg0.getSource().equals(results)) {
			System.out.println("results clicked");
			String queue_name = (String) table.getValueAt(table.getSelectedRow(), 0);
			open_result_folder(queue_name);
		}	
		if (arg0.getSource().equals(submit)) {
			System.out.println("submit clicked");
			String queue_name = (String) table.getValueAt(table.getSelectedRow(), 0);
			submit_dialog submit_view = new submit_dialog(main_view, task_info, queue_name);
			submit_view.setLocationRelativeTo(main_view);
			submit_view.setVisible(true);
		}			
		if (arg0.getSource().equals(delete)) {
			System.out.println("delete clicked");
			int select_index = table.getSelectedRow();
			if (select_index < 0){
				return;
			}
			String queue_name = (String) table.getValueAt(select_index, 0);
			view_info.add_delete_request_queue(queue_name);
		}		
	}

}
