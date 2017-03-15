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

import javax.swing.JMenuItem;
import javax.swing.JPanel;
import javax.swing.JPopupMenu;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.JTable;
//import javax.swing.table.DefaultTableModel;
import javax.swing.ListSelectionModel;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class queue_panel extends JSplitPane{
	/**
	 * 
	 */
	private static final long serialVersionUID = 2L;
	private static final Logger QUEUE_PANEL_LOGGER = LogManager.getLogger(queue_panel.class.getName());
	private view_data view_info;
	private JTable reject_table;
	private JTable capture_table;

	public queue_panel(view_data view_info){
		super(JSplitPane.VERTICAL_SPLIT);
		this.view_info = view_info;
		this.setDividerLocation(400);
		this.setDividerSize(10);
		this.setOneTouchExpandable(true);
		this.setContinuousLayout(true);
		this.setTopComponent(panel_top_component());
		this.setBottomComponent(panel_bottom_component());
	}
	
	private Component panel_top_component(){
		JPanel work_panel= new JPanel(new BorderLayout());
		reject_table = view_info.get_reject_table();
		reject_table.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		reject_pop_memu reject_menu = new reject_pop_memu(reject_table);
		reject_table.addMouseListener(new MouseAdapter() {
			public void mouseReleased(MouseEvent e) {
				if (reject_table.getSelectedRows().length > 0) {
					if (e.isPopupTrigger()) {
						reject_menu.show(e.getComponent(), e.getX(), e.getY());
					}
				} else {
					QUEUE_PANEL_LOGGER.warn("No line selected");
				}
			}
		});		
		JScrollPane scroll_panel= new JScrollPane(reject_table);
		work_panel.add(scroll_panel);
		return work_panel;
	}
	
	private Component panel_bottom_component(){
		JPanel work_panel= new JPanel(new BorderLayout());
		capture_table = view_info.get_capture_table();
		capture_table.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		capture_pop_memu capture_menu = new capture_pop_memu(view_info, capture_table);
		reject_table.addMouseListener(new MouseAdapter() {
			public void mouseReleased(MouseEvent e) {
				if (capture_table.getSelectedRows().length > 0) {
					if (e.isPopupTrigger()) {
						capture_menu.show(e.getComponent(), e.getX(), e.getY());
					}
				} else {
					QUEUE_PANEL_LOGGER.warn("No line selected");
				}
			}
		});			
		JScrollPane scroll_panel= new JScrollPane(capture_table);
		work_panel.add(scroll_panel);
		return work_panel;
	}	
}

class reject_pop_memu extends JPopupMenu implements ActionListener {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private JTable table;
	private JMenuItem details;

	public reject_pop_memu(JTable table) {
		this.table = table;
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
	private view_data view_info;

	public capture_pop_memu(view_data view_info, JTable table) {
		this.table = table;
		this.view_info = view_info;
		show = new JMenuItem("Show");
		show.addActionListener(this);
		this.add(show);
	}

	public capture_pop_memu get_capture_pop_menu() {
		return this;
	}

	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub
		if (arg0.getSource().equals(show)) {
			System.out.println("show details clicked");
			String select_queue = (String) table.getValueAt(table.getSelectedRow(), 0);
			System.out.println("Show queue name:" + select_queue);
			view_info.set_watching_request(select_queue);
		}
	}

}


