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
import java.io.File;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Vector;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTabbedPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;
import utility_funcs.deep_clone;

public class software_dialog extends JDialog implements ChangeListener{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private client_data client_info;
	private switch_data switch_info;
	private JTabbedPane tabbed_pane;

	public software_dialog(main_frame main_view, switch_data switch_info, client_data client_info){
		super(main_view, "Software Setting", true);
		this.client_info = client_info;
		this.switch_info = switch_info;
		Container container = this.getContentPane();
		container.add(construct_tab_pane(), BorderLayout.CENTER);
		//this.setLocation(800, 500);
		//this.setLocationRelativeTo(main_view);
		this.setSize(700, 500);
	}

	private JTabbedPane construct_tab_pane(){
		tabbed_pane = new JTabbedPane(JTabbedPane.LEFT, JTabbedPane.SCROLL_TAB_LAYOUT);
		tabbed_pane.addChangeListener(this);
		HashMap<String, HashMap<String, String>> client_hash = new HashMap<String, HashMap<String, String>>();
		client_hash.putAll(client_info.get_client_data());
		Iterator<String> client_hash_it = client_hash.keySet().iterator();
		while(client_hash_it.hasNext()){
			String section_name = client_hash_it.next();
			if (section_name.equalsIgnoreCase("preference")){
				continue;
			}
			if (section_name.equalsIgnoreCase("system")){
				continue;
			}
			if (section_name.equalsIgnoreCase("machine")){
				continue;
			}
			//Icon icon_image = (Icon) Toolkit.getDefaultToolkit().getImage(public_data.ICON_TAB_ICO);
			ImageIcon icon_image = new ImageIcon(public_data.ICON_SOFTWARE_TAB_PNG);
			String shown_tab_name = new String();
			shown_tab_name = section_name.substring(0, 1).toUpperCase() + section_name.substring(1);
			tabbed_pane.addTab(shown_tab_name, icon_image, new value_pane(section_name, switch_info, client_info), "Click and show");
		}
		return tabbed_pane;
	}
	
	@Override
	public void stateChanged(ChangeEvent arg0) {
		// TODO Auto-generated method stub
		int select_index = tabbed_pane.getSelectedIndex();
		tabbed_pane.setSelectedIndex(select_index);
	}
	
	public static void main(String[] args) {
		switch_data switch_info = new switch_data();
		client_data client_info = new client_data();		
		software_dialog sw_view = new software_dialog(null, switch_info, client_info);
		sw_view.setVisible(true);
	}
	 
}

class value_pane extends JPanel implements ActionListener{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private client_data client_info;
	private switch_data switch_info;
	private String tab_name;
	private JTable build_table;
	private JTextField jt_max_insts, jt_scan_dir;
	private Vector<String> table_column = new Vector<String>();
	private Vector<Vector<String>> table_data = new Vector<Vector<String>>();	
	private JButton discard, apply;
	
	public value_pane(String tab_name, switch_data switch_info, client_data client_info){
		this.tab_name = tab_name;
		this.client_info = client_info;
		this.switch_info = switch_info;
		this.setLayout(new BorderLayout());
		this.add(construct_top_panel(), BorderLayout.NORTH);
		this.add(construct_center_panel(), BorderLayout.CENTER);
		this.add(construct_south_panel(), BorderLayout.SOUTH);
	}
		
	private JPanel construct_top_panel(){
		JPanel top_panel = new JPanel(new GridLayout(2,2,5,5));
		JLabel jl_max_insts = new JLabel("Max Instances Num:");
		jt_max_insts = new JTextField("");
		JLabel jl_scan_dir = new JLabel("Auto Scan Directory:");
		jt_scan_dir = new JTextField("");
		if (client_info.get_client_data().containsKey(tab_name)){
			jt_max_insts.setText(client_info.get_client_data().get(tab_name).get("max_insts"));
			jt_scan_dir.setText(client_info.get_client_data().get(tab_name).get("scan_dir"));
		} else {
			jt_max_insts.setText("Test");
			jt_scan_dir.setText("Test");
		}
		top_panel.add(jl_max_insts);
		top_panel.add(jt_max_insts);
		top_panel.add(jl_scan_dir);
		top_panel.add(jt_scan_dir);
		return top_panel;
	}
		
	private JPanel construct_center_panel(){
		JPanel center_panel = new JPanel(new BorderLayout());
		table_column.add("Build");
		table_column.add("Path");
		for (int i = 0; i < 10; i++){
			Vector<String> initial_line = new Vector<String>();
			initial_line.add("");
			initial_line.add("");
			table_data.add(initial_line);
		}
		HashMap<String, String> software_info = new HashMap<String, String>();
		software_info.putAll(client_info.get_client_data().get(tab_name));
		Iterator<String> software_info_it = software_info.keySet().iterator();
		int j = 0;
		while(software_info_it.hasNext()){
			if (j > 9){
				break;
			}
			String build_name = software_info_it.next();
			String build_path = software_info.get(build_name);
			if(build_name.equals("scan_dir") || build_name.equals("max_insts")){
				continue;
			}
			table_data.get(j).set(0, build_name);
			table_data.get(j).set(1, build_path);
			j++;
		}
		build_table = new setting_table(table_data, table_column);
		build_table.getColumn("Build").setMaxWidth(200);
		JScrollPane scro_panel = new JScrollPane(build_table);
		center_panel.add(scro_panel, BorderLayout.CENTER);
		return center_panel;
	}
	
	private JPanel construct_south_panel(){
		JPanel south_panel = new JPanel(new GridLayout(1,2,5,20));
		discard = new JButton("Discard");
		discard.addActionListener(this);
		apply = new JButton("Apply");
		apply.addActionListener(this);
		south_panel.add(discard);
		south_panel.add(apply);
		return south_panel;
	}

	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub
		if(arg0.getSource().equals(discard)){
			table_data.clear();
			for (int i = 0; i < 10; i++){
				Vector<String> initial_line = new Vector<String>();
				initial_line.add("");
				initial_line.add("");
				table_data.add(initial_line);
			}
			HashMap<String, String> software_info = new HashMap<String, String>();
			software_info.putAll(client_info.get_client_data().get(tab_name));
			Iterator<String> software_info_it = software_info.keySet().iterator();
			int j = 0;
			while(software_info_it.hasNext()){
				if (j > 9){
					break;
				}
				String build_name = software_info_it.next();
				String build_path = software_info.get(build_name);
				if(build_name.equals("scan_dir") || build_name.equals("max_insts")){
					continue;
				}				
				table_data.get(j).set(0, build_name);
				table_data.get(j).set(1, build_path);
				j++;
			}
			build_table.updateUI();
			jt_max_insts.setText(client_info.get_client_data().get(tab_name).get("max_insts"));
			jt_scan_dir.setText(client_info.get_client_data().get(tab_name).get("scan_dir"));			
		}
		if(arg0.getSource().equals(apply)){
			HashMap<String, HashMap<String, String>> client_hash = new HashMap<String, HashMap<String, String>>();
			HashMap<String, String> new_data = new HashMap<String, String>();
			for (int i = 0; i < 10; i++){
				String build = (String) build_table.getValueAt(i, 0);
				String path = (String) build_table.getValueAt(i, 1);
				path = path.replaceAll("\\\\", "/");
				build = build.replaceAll(" ", "");
				File path_dobj = new File(path);
				if(build == null || build.equals("")){
					continue;
				}
				if(!path_dobj.exists()){
					JOptionPane.showMessageDialog(null, "Row"+ String.valueOf(i) + ":" + path + ".", "File Path Error:", JOptionPane.INFORMATION_MESSAGE);
					return;
				}
				new_data.put(build, path);
			}
			//client_hash.putAll(client_info.get_client_data());
			client_hash.putAll(deep_clone.clone(client_info.get_client_data()));
			new_data.put("scan_dir", jt_scan_dir.getText());
			new_data.put("max_insts", jt_max_insts.getText());
			client_hash.put(tab_name, new_data);
			client_info.set_client_data(client_hash);
			switch_info.set_client_updated();
		}
	}
}
