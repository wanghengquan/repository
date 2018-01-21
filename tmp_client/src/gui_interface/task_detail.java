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
import java.util.Vector;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.JTableHeader;

import connect_tube.task_data;
import data_center.public_data;

public class task_detail extends JFrame {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private task_data task_info;
	private String queue_name;
	private String task_id;
	private Vector<String> detail_column = new Vector<String>();
	private Vector<Vector<String>> detail_data = new Vector<Vector<String>>();
	private JTable detail_table;

	public task_detail(String queue_name, String task_id, task_data task_info) {
		this.queue_name = queue_name;
		this.task_id = task_id;
		this.task_info = task_info;
		this.setTitle("Detail info for " + task_id + ":");
		Image icon_image = Toolkit.getDefaultToolkit().getImage(public_data.ICON_FRAME_PNG);
		this.setIconImage(icon_image);
		Container container = this.getContentPane();
		container.add(construct_table_panel(), BorderLayout.CENTER);
		JTableHeader table_head = detail_table.getTableHeader();
		container.add(table_head, BorderLayout.NORTH);
		container.add(construct_bottom_panel(), BorderLayout.SOUTH);
		this.setLocation(600, 400);
		//this.setLocationRelativeTo(null);
		this.setSize(800, 500);
	}

	public JPanel construct_table_panel() {
		detail_column.add("Item");
		detail_column.add("Details/Requirements");
		HashMap<String, HashMap<String, String>> task_data = new HashMap<String, HashMap<String, String>>();
		
		//get_case_from_processed_task_queues_map
		if(!task_info.get_case_from_processed_task_queues_map(queue_name, task_id).isEmpty()){
			task_data.putAll(task_info.get_case_from_processed_task_queues_map(queue_name, task_id));
		} else {
			task_data.putAll(task_info.get_case_from_received_task_queues_map(queue_name, task_id));
		}				
		ArrayList<String> items = new ArrayList<String>();
		items.add("ID");
		items.add("CaseInfo");
		items.add("Environment");
		items.add("LaunchCommand");
		items.add("Software");
		items.add("System");
		items.add("Machine");
		items.add("Status");
		items.add("Paths");
		Iterator<String> item_it = items.iterator();
		while(item_it.hasNext()){
			String item = item_it.next();
			if (!task_data.containsKey(item)){
				continue;
			}
			HashMap<String, String> section_data = new HashMap<String, String>();
			section_data.putAll(task_data.get(item));
			if(section_data.size() < 1){
				Vector<String> empty_line = new Vector<String>();
				empty_line.add(item);
				empty_line.add("NA");
				detail_data.add(empty_line);
				continue;
			}
			Iterator<String> option_it = section_data.keySet().iterator();
			int option_count = 0;
			while(option_it.hasNext()){
				Vector<String> detail_line = new Vector<String>();
				String option = option_it.next();
				String value = section_data.getOrDefault(option, "NA");
				if(option_count == 0){
					detail_line.add(item);
				} else {
					detail_line.add(" ");
				}
				detail_line.add(option + "=" + value);
				detail_data.add(detail_line);
				option_count++;
			}
		}
		detail_table = new info_table(detail_data, detail_column);
		detail_table.getColumn("Item").setMaxWidth(200);
		detail_table.getColumn("Item").setMinWidth(150);
		//insert table
		JPanel table_panel = new JPanel(new BorderLayout());
		JScrollPane scroll_panel = new JScrollPane(detail_table);
		table_panel.add(scroll_panel);
		return table_panel;
	}

	public JPanel construct_bottom_panel() {
		JPanel jp_info = new JPanel(new BorderLayout());
		JLabel jl_info = new JLabel(" ");
		jp_info.add(jl_info, BorderLayout.WEST);
		return jp_info;
	}

	public static void main(String[] args) {
		task_data task_info = new task_data();
		capture_detail compare_view = new capture_detail(null, task_info);
		compare_view.setVisible(true);
	}

}