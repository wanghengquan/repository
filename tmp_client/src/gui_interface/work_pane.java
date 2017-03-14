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
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.Vector;

import javax.swing.JMenuItem;
import javax.swing.JPanel;
import javax.swing.JPopupMenu;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.JTable;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.DefaultTableModel;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


public class work_pane extends JSplitPane {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static final Logger WORK_PANE_LOGGER = LogManager.getLogger(work_pane.class.getName());
	private view_data view_info;
	private JTable work_table;

	public work_pane(view_data view_info) {
		super();
		this.view_info = view_info;
		this.setDividerLocation(300);
		this.setDividerSize(10);
		this.setOneTouchExpandable(true);
		this.setContinuousLayout(true);
		this.setLeftComponent(new queue_pane());
		this.setRightComponent(panel_right_component());
	}

	public JTable get_work_table() {
		return this.work_table;
	}

	private Component panel_right_component() {
		JPanel work_panel = new JPanel(new BorderLayout());
		Vector<String> table_name = new Vector<String>();
		table_name.add("ID");
		table_name.add("Suite");
		table_name.add("Design");
		table_name.add("Status");
		table_name.add("Results");
		DefaultTableModel work_tm = new DefaultTableModel() {
			private static final long serialVersionUID = 1L;

			public boolean isCellEditable(int row, int column) {
				return false;
			}

			public int getColumnCount() {
				return table_name.size();
			}

			public int getRowCount() {
				return view_info.get_work_data().size();
			}

			public Object getValueAt(int row, int column) {
				if (!view_info.get_work_data().isEmpty()) {
					return ((Vector<String>) view_info.get_work_data().elementAt(row)).elementAt(column);
				} else {
					return null;
				}
			}

		};
		work_tm.setColumnIdentifiers(table_name);
		work_table = new JTable(work_tm);
		table_pop_memu table_menu = new table_pop_memu(work_table);
		work_table.addMouseListener(new MouseAdapter() {
			public void mouseReleased(MouseEvent e) {
				if (work_table.getSelectedRows().length > 0) {
					if (e.isPopupTrigger()) {
						table_menu.show(e.getComponent(), e.getX(), e.getY());
					}
				} else {
					WORK_PANE_LOGGER.warn("No line selected");
				}
			}
		});
		JScrollPane scroll_panel = new JScrollPane(work_table);
		work_panel.add(scroll_panel);
		return work_panel;
	}
}

class table_pop_memu extends JPopupMenu implements ActionListener {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private JTable table;
	private JMenuItem retest, details, results;

	public table_pop_memu(JTable table) {
		this.table = table;
		retest = new JMenuItem("Retest");
		retest.addActionListener(this);
		details = new JMenuItem("Details");
		details.addActionListener(this);
		results = new JMenuItem("Results");
		results.addActionListener(this);
		this.add(retest);
		this.addSeparator();
		this.add(details);
		this.add(results);
	}

	public table_pop_memu get_table_pop_menu() {
		return this;
	}

	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub
		if (arg0.getSource().equals(retest)) {
			System.out.println("retest clicked");
		}
		if (arg0.getSource().equals(details)) {
			System.out.println("details clicked");
		}
		if (arg0.getSource().equals(results)) {
			System.out.println("results clicked");
		}
	}

}