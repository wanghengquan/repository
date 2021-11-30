/*
 * File: welcome_dialog.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/04/05
 * Modifier:
 * Date:
 * Description:
 */
package gui_interface;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Container;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.HashMap;

import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;

import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;
import utility_funcs.deep_clone;

public class debug_dialog extends JDialog implements ActionListener {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private switch_data switch_info;
	private client_data client_info;
	private JCheckBox jc_debug;
	private JButton jb_apply, jb_close;
	private String line_separator = System.getProperty("line.separator");

	public debug_dialog(
			main_frame main_view, 
			switch_data switch_info, 
			client_data client_info
			) {
		super(main_view, "Debug Mode Confirm", true);
		this.client_info = client_info;
		this.switch_info = switch_info;
		Container container = this.getContentPane();
		container.add(construct_debug_panel());
		this.setSize(800, 550);
	}

	private JPanel construct_debug_panel() {
		JPanel jp_debug = new JPanel(new BorderLayout());
		jp_debug.add(get_detail_letter(), BorderLayout.CENTER);
		jp_debug.add(get_jb_apply_panel(), BorderLayout.SOUTH);
		return jp_debug;
	}

	private JPanel get_detail_letter() {
		JPanel letter_panel = new JPanel(new BorderLayout());
		// welcome label
		JLabel letter_label = new JLabel("Client 'Debug Mode' Confirm:");
		letter_label.setBackground(Color.LIGHT_GRAY);
		letter_panel.add(letter_label, BorderLayout.NORTH);
		// welcome letters
		JTextArea letter_area = new JTextArea();
		letter_area.setLineWrap(true);
		letter_area.append("Client Debug mode support following features:" + line_separator);
		letter_area.append("1. Verbose console log output." + line_separator);
		letter_area.append("    In debug mode console report severity will downgrade to 'Debug', Debug info will be reported." + line_separator);
		letter_area.append(line_separator);
		letter_area.append("2. Debug log file:" + line_separator);
		letter_area.append("    More log file generated in '<work_space>/logs/debug' including:client input and output message,  system usage data." + line_separator);
		letter_area.append(line_separator);
		letter_area.append("3. Enhanced GUI features:" + line_separator);
		letter_area.append("    'Tools -> Debug -> Threads': Action buttons will be enabled for thread control." + line_separator);
		letter_area.append("    'Tools -> Debug -> Database': database data can be update." + line_separator);
		letter_area.append(line_separator);
		letter_area.setEditable(false);
		JScrollPane sp = new JScrollPane(letter_area);
		letter_panel.add(sp, BorderLayout.CENTER);
		// return
		return letter_panel;
	}


	private JPanel get_jb_apply_panel() {
		HashMap<String, String> preference_data = new HashMap<String, String>();
		preference_data.putAll(deep_clone.clone(client_info.get_client_preference_data()));
		JPanel jb_apply_panel = new JPanel(new BorderLayout());
		// checkbox panel
		JPanel check_panel = new JPanel(new BorderLayout());
		jc_debug = new JCheckBox("Check and Apply to enable Client 'Debug' mode.");
		if (preference_data.getOrDefault("debug_mode", public_data.DEF_CLIENT_DEBUG_MODE).equals("1")){
			jc_debug.setSelected(true);
		} else {
			jc_debug.setSelected(false);
		}		
		check_panel.add(jc_debug, BorderLayout.WEST);
		// button panel
		JPanel button_panel = new JPanel(new GridLayout(1, 4, 5, 5));
		jb_apply = new JButton("Apply");
		jb_apply.addActionListener(this);
		jb_close = new JButton("Close");
		jb_close.addActionListener(this);		
		button_panel.add(new JLabel(""));
		button_panel.add(new JLabel(""));
		button_panel.add(jb_apply);
		button_panel.add(jb_close);
		// package
		jb_apply_panel.add(check_panel, BorderLayout.NORTH);
		jb_apply_panel.add(button_panel, BorderLayout.SOUTH);
		return jb_apply_panel;
	}

	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub
		HashMap<String, String> preference_data = new HashMap<String, String>();
		preference_data.putAll(deep_clone.clone(client_info.get_client_preference_data()));
		if (arg0.getSource().equals(jb_apply)) {
			if (jc_debug.isSelected()) {
				preference_data.put("debug_mode", "1");
			} else {
				preference_data.put("debug_mode", "0");
			}
			client_info.set_client_preference_data(preference_data);
			switch_info.set_client_updated();			
		}
		if(arg0.getSource().equals(jb_close)){
			this.dispose();
		}		
	}

	public static void main(String[] args) {
		switch_data switch_info = new switch_data();
		client_data client_info = new client_data();
		debug_dialog welcome_view = new debug_dialog(null, switch_info, client_info);
		welcome_view.setVisible(true);
	}
}