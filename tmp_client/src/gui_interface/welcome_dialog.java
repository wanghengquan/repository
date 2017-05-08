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
import java.io.File;
import java.util.HashMap;

import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;

import data_center.client_data;
import data_center.switch_data;

public class welcome_dialog extends JDialog implements ActionListener {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private switch_data switch_info;
	private client_data client_info;
	private JTextField jt_work, jt_save;
	private JCheckBox jc_welcome;
	private JButton jb_discard, jb_apply;
	private String line_separator = System.getProperty("line.separator");

	public welcome_dialog(main_frame main_view, switch_data switch_info, client_data client_info) {
		super(main_view, "Welcome & Initial Setting", true);
		this.client_info = client_info;
		this.switch_info = switch_info;
		Container container = this.getContentPane();
		container.add(construct_welcome_panel());
		//this.setLocation(400, 400);
		this.setLocationRelativeTo(main_view);
		this.setSize(700, 500);
	}

	private JPanel construct_welcome_panel() {
		JPanel jp_welcome = new JPanel(new BorderLayout());
		jp_welcome.add(get_welcome_letter(), BorderLayout.NORTH);
		jp_welcome.add(get_initial_setting(), BorderLayout.CENTER);
		jp_welcome.add(get_jb_apply_panel(), BorderLayout.SOUTH);
		return jp_welcome;
	}

	private JPanel get_welcome_letter() {
		JPanel letter_panel = new JPanel(new BorderLayout());
		// welcome label
		JLabel letter_label = new JLabel("Welcome to TMP Client:");
		letter_label.setBackground(Color.LIGHT_GRAY);
		letter_panel.add(letter_label, BorderLayout.NORTH);
		// welcome letters
		JTextArea letter_area = new JTextArea();
		letter_area.setLineWrap(true);
		letter_area
				.append("Please setting your 'Work Space' and 'Save Space' in following Text Fields." + line_separator);
		letter_area.append("Work Space: Where TMP Client store runtime result locally" + line_separator);
		letter_area.append("Save Space: Where TMP Client copy local result to (Also called 'Unify result store space')"
				+ line_separator);
		letter_area
				.append("Bydefault:Save Space will be same with Work Space which means TMP Client will not copy the local result to remote space."
						+ line_separator);
		letter_area.append("If we leave the 'Save Space' blank TMP Client will also skip copy action." + line_separator);
		letter_area.append(line_separator);
		letter_area.append("We strongly suggest you review all TMP Client setting in:Menu Bar --> 'Setting'.");
		letter_area.setEditable(false);
		JScrollPane sp = new JScrollPane(letter_area);
		letter_panel.add(sp, BorderLayout.SOUTH);
		// return
		return letter_panel;
	}

	private JPanel get_initial_setting() {
		HashMap<String, HashMap<String, String>> client_data = new HashMap<String, HashMap<String, String>>();
		client_data.putAll(client_info.get_client_data());
		HashMap<String, String> preference_data = client_data.get("preference");
		JPanel initial_panel = new JPanel(new GridLayout(2, 2, 5, 5));
		// work space
		JLabel jl_work = new JLabel("Work Space");
		jt_work = new JTextField();
		if (preference_data == null) {
			jt_work.setText("Test");
		} else {
			jt_work.setText(preference_data.get("work_path"));
		}
		// save space
		JLabel jl_save = new JLabel("Save Space");
		jt_save = new JTextField();
		if (preference_data == null) {
			jt_save.setText("Test");
		} else {
			jt_save.setText(preference_data.get("save_path"));
		}
		// package
		initial_panel.add(jl_work);
		initial_panel.add(jt_work);
		initial_panel.add(jl_save);
		initial_panel.add(jt_save);
		return initial_panel;
	}

	private JPanel get_jb_apply_panel() {
		JPanel jb_apply_panel = new JPanel(new BorderLayout());
		// checkbox panel
		JPanel check_panel = new JPanel(new BorderLayout());
		jc_welcome = new JCheckBox("Don't show welcome setting next time.");
		check_panel.add(jc_welcome, BorderLayout.WEST);
		// button panel
		JPanel button_panel = new JPanel(new GridLayout(1, 2, 5, 5));
		jb_discard = new JButton("Discard");
		jb_discard.addActionListener(this);
		jb_apply = new JButton("Apply");
		jb_apply.addActionListener(this);
		button_panel.add(jb_discard);
		button_panel.add(jb_apply);
		// package
		jb_apply_panel.add(check_panel, BorderLayout.NORTH);
		jb_apply_panel.add(button_panel, BorderLayout.SOUTH);
		return jb_apply_panel;
	}

	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub
		HashMap<String, HashMap<String, String>> client_data = new HashMap<String, HashMap<String, String>>();
		client_data.putAll(client_info.get_client_data());
		HashMap<String, String> preference_data = client_data.get("preference");
		if (arg0.getSource().equals(jb_discard)) {
			jc_welcome.setSelected(false);
			if (preference_data == null) {
				jt_work.setText("Test");
				jt_save.setText("Test");
			} else {
				jt_work.setText(preference_data.get("work_path"));
				jt_save.setText(preference_data.get("save_path"));
			}
		}
		if (arg0.getSource().equals(jb_apply)) {
			if (jc_welcome.isSelected()) {
				preference_data.put("show_welcome", "0");
			}
			// work path
			if (jt_work.getText().trim().equals("")) {
				String message = new String("Empty work path found.");
				JOptionPane.showMessageDialog(null, message, "Wrong import value:", JOptionPane.INFORMATION_MESSAGE);
				return;
			} else {
				File work_dobj = new File(jt_work.getText().trim());
				String message = new String("work path Not Exists.");
				if (work_dobj.exists()) {
					preference_data.put("work_path", jt_work.getText().trim().replaceAll("\\\\", "/"));
				} else {
					JOptionPane.showMessageDialog(null, message, "Wrong import value:",
							JOptionPane.INFORMATION_MESSAGE);
					return;
				}
			}
			// save path
			String save_path = new String();
			if (jt_save.getText().trim().equals("")) {
				save_path = jt_work.getText().trim().replaceAll("\\\\", "/");
			} else {
				save_path = jt_save.getText().trim().replaceAll("\\\\", "/");
			}
			File save_dobj = new File(save_path);
			String message = new String("save path Not Exists.");
			if (save_dobj.exists()) {
				preference_data.put("save_path", save_path);
			} else {
				JOptionPane.showMessageDialog(null, message, "Wrong import value:", JOptionPane.INFORMATION_MESSAGE);
				return;
			}
			client_info.set_client_data(client_data);
			switch_info.set_client_updated();
		}
	}

	public static void main(String[] args) {
		switch_data switch_info = new switch_data();
		client_data client_info = new client_data();
		welcome_dialog welcome_view = new welcome_dialog(null, switch_info, client_info);
		welcome_view.setVisible(true);
	}
}