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

public class capture_detail extends JFrame {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private task_data task_info;
	private String queue_name;
	private Vector<String> detail_column = new Vector<String>();
	private Vector<Vector<String>> detail_data = new Vector<Vector<String>>();
	private JTable detail_table;

	public capture_detail(String queue_name, task_data task_info) {
		this.queue_name = queue_name;
		this.task_info = task_info;
		this.setTitle("Detail info for " + queue_name + ":");
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
		HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
		if(!task_info.get_queue_data_from_received_admin_queues_treemap(queue_name).isEmpty()){
			queue_data.putAll(task_info.get_queue_data_from_received_admin_queues_treemap(queue_name));
		} else {
			queue_data.putAll(task_info.get_queue_data_from_processed_admin_queues_treemap(queue_name));
		}		
		ArrayList<String> items = new ArrayList<String>();
		items.add("ID");
		items.add("CaseInfo");
		items.add("Environment");
		items.add("LaunchCommand");
		items.add("Software");
		items.add("System");
		items.add("Machine");
        items.add("ClientPreference");
		items.add("Status");
		Iterator<String> item_it = items.iterator();
		while(item_it.hasNext()){
			String item = item_it.next();
			if (!queue_data.containsKey(item)){
				continue;
			}
			HashMap<String, String> section_data = new HashMap<String, String>();
			section_data.putAll(queue_data.get(item));
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
		JPanel jp_info = new JPanel(new GridLayout(2,1,1,1));
		String priority_str = new String(queue_name.split("@")[0]);
		Integer priority_int = Integer.valueOf(0);
		priority_int = Integer.valueOf(priority_str);
		int task_bit_int = priority_int / 100;
		int match_bit_int = priority_int % 100 / 10;
		int from_bit_int = priority_int % 10;
		//second line
		StringBuilder show_overall = new StringBuilder();
		show_overall.append("Overall Priority:" + priority_str);
		show_overall.append(" (Smaller number has higher priority, 000 > 911)");
		JLabel jl_line1 = new JLabel(show_overall.toString());
		jp_info.add(jl_line1);		
		//first line
		StringBuilder show_detail = new StringBuilder();
		show_detail.append("*: ");
		show_detail.append(String.valueOf(task_bit_int) + ": Task Priority; ");
		if (match_bit_int == 0){
			show_detail.append(String.valueOf(match_bit_int) + ": Assigned Task; " );
		} else {
			show_detail.append(String.valueOf(match_bit_int) + ": Matched Task; " );
		}
		if (from_bit_int == 0){
			show_detail.append(String.valueOf(from_bit_int) + ": Local Task; " );
		} else {
			show_detail.append(String.valueOf(from_bit_int) + ": Remote Task; " );
		}
		JLabel jl_line2 = new JLabel(show_detail.toString());
		jp_info.add(jl_line2);
		return jp_info;
	}

	public static void main(String[] args) {
		task_data task_info = new task_data();
		capture_detail compare_view = new capture_detail(null, task_info);
		compare_view.setVisible(true);
	}

}