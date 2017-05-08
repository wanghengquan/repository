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
import java.awt.Image;
import java.awt.Toolkit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTable;
import javax.swing.table.JTableHeader;

import connect_tube.task_data;
import data_center.client_data;
import data_center.public_data;

public class detail_dialog extends JFrame {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private task_data task_info;
	private client_data client_info;
	private String queue_name;
	private Vector<String> compare_column = new Vector<String>();
	private Vector<Vector<String>> compare_data = new Vector<Vector<String>>();
	private JTable compare_table;

	public detail_dialog(String queue_name, client_data client_info, task_data task_info) {
		this.queue_name = queue_name;
		this.task_info = task_info;
		this.client_info = client_info;
		this.setTitle("Detail info for " + queue_name + ":");
		Image icon_image = Toolkit.getDefaultToolkit().getImage(public_data.ICON_FRAME_PNG);
		this.setIconImage(icon_image);
		Container container = this.getContentPane();
		container.add(construct_table_panel(), BorderLayout.CENTER);
		JTableHeader table_head = compare_table.getTableHeader();
		container.add(table_head, BorderLayout.NORTH);
		container.add(construct_bottom_panel(), BorderLayout.SOUTH);
		//this.setLocation(800, 500);
		this.setLocationRelativeTo(null);
		this.setSize(700, 300);
	}

	public JTable construct_table_panel() {
		compare_column.add("Item");
		compare_column.add("Request Value");
		compare_column.add("Available Value");
		List<String> check_list = new ArrayList<String>();
		check_list.add("Software");
		check_list.add("System");
		check_list.add("Machine");
		HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, HashMap<String, String>> client_data = new HashMap<String, HashMap<String, String>>();
		admin_data.putAll(task_info.get_queue_data_from_received_admin_queues_treemap(queue_name));
		client_data.putAll(client_info.get_client_data());
		Iterator<String> admin_it = admin_data.keySet().iterator();
		while (admin_it.hasNext()) {
			String admin_section = admin_it.next();
			if (!check_list.contains(admin_section)) {
				continue;
			}
			HashMap<String, String> section_data = new HashMap<String, String>();
			section_data.putAll(admin_data.get(admin_section));
			Iterator<String> option_it = section_data.keySet().iterator();
			while (option_it.hasNext()) {
				String option = option_it.next();
				String value = section_data.get(option);
				Vector<String> new_line = new Vector<String>();
				new_line.add(admin_section + "." + option);
				new_line.add(value);
				if (admin_section.equals("Machine") || admin_section.equals("System")) {
					if (client_data.get(admin_section).containsKey(option)) {
						new_line.add(client_data.get(admin_section).get(option));
					} else {
						new_line.add("NA");
					}
				} else if (admin_section.equals("Software")) {
					if (client_data.containsKey(option)) {
						List<String> available_sw_list = new ArrayList<String>();
						Iterator<String> sw_it = client_data.get(option).keySet().iterator();
						while (sw_it.hasNext()) {
							String sw_build = sw_it.next();
							if (sw_build.equals("scan_dir") || sw_build.equals("max_insts")) {
								continue;
							}
							available_sw_list.add(sw_build);
						}
						if (available_sw_list.size() == 0) {
							new_line.add("NA");
						} else {
							new_line.add(String.join(",", available_sw_list));
						}
					} else {
						new_line.add("NA");
					}
				}
				compare_data.add(new_line);
			}
		}
		compare_table = new info_table(compare_data, compare_column);
		return compare_table;
	}

	public JPanel construct_bottom_panel() {
		JPanel jp_info = new JPanel(new BorderLayout());
		JLabel jl_info = new JLabel();
		String private_status = new String();
		HashMap<String, HashMap<String, String>> client_data = new HashMap<String, HashMap<String, String>>();
		client_data.putAll(client_info.get_client_data());
		if (client_data.containsKey("Machine")) {
			private_status = client_data.get("Machine").get("private");
		}
		if (private_status.equals("")) {
			jl_info.setText("*: Unknown Client Private/Public Mode.");
		} else if (private_status.equals("0")) {
			jl_info.setText("*: Client work in Public Mode: All 'Matched' and 'Assigned' task will be run.");
		} else {
			jl_info.setText("*: Client work in Private Mode: Olny 'Assigned' task will be run.");
		}
		jp_info.add(jl_info, BorderLayout.WEST);
		return jp_info;
	}

	public static void main(String[] args) {
		task_data task_info = new task_data();
		client_data client_info = new client_data();
		detail_dialog compare_view = new detail_dialog(null, client_info, task_info);
		compare_view.setVisible(true);
	}

}