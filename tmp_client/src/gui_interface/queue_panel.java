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
//import java.util.Vector;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.Vector;

import javax.swing.JMenu;
import javax.swing.JMenuItem;
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
import utility_funcs.time_info;

public class queue_panel extends JSplitPane implements Runnable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 2L;
	private static final Logger QUEUE_PANEL_LOGGER = LogManager.getLogger(queue_panel.class.getName());
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

	public queue_panel(view_data view_info, client_data client_info, task_data task_info) {
		super(JSplitPane.VERTICAL_SPLIT);
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
		capture_table.getColumn("Status").setMinWidth(150);		
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
		reject_pop_memu reject_menu = new reject_pop_memu(reject_table, client_info, task_info);
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
					new reject_detail(select_queue, client_info, task_info).setVisible(true);					
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
		if(!status.equalsIgnoreCase("finished")){
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
		capture_pop_memu capture_menu = new capture_pop_memu(capture_table, task_info, view_info);
		capture_table.addMouseListener(new MouseAdapter() {
			//for windows popmenu
			public void mouseReleased(MouseEvent e) {
				if (capture_table.getSelectedRows().length > 0) {
					if (e.isPopupTrigger()) {
						if (is_selected_queue_deletable()){
							capture_menu.enable_delete_item();
						} else {
							capture_menu.disable_delete_item();
						}
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
						if (is_selected_queue_deletable()){
							capture_menu.enable_delete_item();
						} else {
							capture_menu.disable_delete_item();
						}						
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
					view_info.set_watching_queue_area("all");
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
		TreeMap<String, String> reject_treemap = task_info.get_rejected_admin_reason_treemap();// source
		Iterator<String> reject_treemap_it = reject_treemap.keySet().iterator();
		Vector<Vector<String>> new_data = new Vector<Vector<String>>();
		while (reject_treemap_it.hasNext()) {
			String queue_name = reject_treemap_it.next();
			String reject_reason = reject_treemap.get(queue_name);
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
		Set<String> captured_set = new TreeSet<String>(new queue_comparator());
		captured_set.addAll(task_info.get_captured_admin_queues_treemap().keySet());
		ArrayList<String> processing_admin_queue_list = task_info.get_processing_admin_queue_list();
		ArrayList<String> running_admin_queue_list = task_info.get_running_admin_queue_list();
		ArrayList<String> finished_admin_queue_list = task_info.get_finished_admin_queue_list();
		captured_set.addAll(finished_admin_queue_list);// source data
		// //show data
		Iterator<String> captured_it = captured_set.iterator();
		Vector<Vector<String>> new_data = new Vector<Vector<String>>();
		while (captured_it.hasNext()) {
			String queue_name = captured_it.next();
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
			// add watching vector
			Vector<String> show_line = new Vector<String>();
			show_line.add(queue_name);
			show_line.add(status);
			new_data.add(show_line);
			show_update = true;
		}
		capture_data.clear();
		capture_data.addAll(new_data);
		return show_update;
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
		view_info.set_select_rejected_queue(selected_queue);
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
		view_info.set_select_captured_queue(selected_queue);
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
	private JTable table;
	private client_data client_info;
	private task_data task_info;
	private JMenuItem details;

	public reject_pop_memu(JTable table, client_data client_info, task_data task_info) {
		this.table = table;
		this.client_info = client_info;
		this.task_info = task_info;
		details = new JMenuItem("Details");
		details.addActionListener(this);
		this.add(details);
	}

	public reject_pop_memu get_reject_pop_menu() {
		return this;
	}

	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub
		if (arg0.getSource().equals(details)) {
			System.out.println("reject details clicked");
			String select_queue = (String) table.getValueAt(table.getSelectedRow(), 0);
			reject_detail detail_view = new reject_detail(select_queue, client_info, task_info);
			detail_view.setVisible(true);
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
	private JMenuItem run_play, run_pause, run_stop;
	private JMenuItem detail;
	private JMenuItem delete;
	private task_data task_info;
	private view_data view_info;

	public capture_pop_memu(JTable table, task_data task_info, view_data view_info) {
		this.table = table;
		this.task_info = task_info;
		this.view_info = view_info;
		show = new JMenuItem("Show");
		show.addActionListener(this);
		this.add(show);
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
		detail = new JMenuItem("Detail");
		detail.addActionListener(this);
		this.add(detail);
		this.addSeparator();
		delete = new JMenuItem("Delete");
		delete.addActionListener(this);
		this.add(delete);
	}

	public capture_pop_memu get_capture_pop_menu() {
		return this;
	}

	public void disable_delete_item() {
		delete.setEnabled(false);
	}

	public void enable_delete_item() {
		delete.setEnabled(true);
	}
	
	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub
		if (arg0.getSource().equals(show)) {
			System.out.println("show details clicked");
			String select_queue = (String) table.getValueAt(table.getSelectedRow(), 0);
			view_info.set_watching_queue(select_queue);
			view_info.set_watching_queue_area("all");
		}
		if (arg0.getSource().equals(run_play)) {
			System.out.println("run_play clicked");
			view_info.set_run_action_request("processing");
		}
		if (arg0.getSource().equals(run_pause)) {
			System.out.println("run_pause clicked");
			view_info.set_run_action_request("pause");
		}
		if (arg0.getSource().equals(run_stop)) {
			System.out.println("run_stop clicked");
			view_info.set_run_action_request("stop");
		}
		if (arg0.getSource().equals(detail)) {
			System.out.println("detail clicked");
			String select_queue = (String) table.getValueAt(table.getSelectedRow(), 0);
			capture_detail detail_view = new capture_detail(select_queue, task_info);
			detail_view.setVisible(true);
		}		
		if (arg0.getSource().equals(delete)) {
			System.out.println("delete clicked");
			int select_index = table.getSelectedRow();
			if (select_index < 0){
				return;
			}
			String queue_name = (String) table.getValueAt(select_index, 0);
			view_info.add_delete_finished_queue(queue_name);
		}		
	}

}
