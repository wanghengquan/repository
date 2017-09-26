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

import java.awt.*;
import java.awt.event.*;

import javax.swing.*;

import data_center.public_data;
import utility_funcs.des_encode;

public class encode_dialog extends JFrame {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private JLabel label_username = new JLabel("Username:");
	private JLabel label_passwd01 = new JLabel("Password:");
	private JLabel label_passwd02 = new JLabel("Password:");
	private JTextField field_username = new JTextField("", 20);
	private JPasswordField field_passwd01 = new JPasswordField("", 20);
	private JPasswordField field_passwd02 = new JPasswordField("", 20);
	private JButton gen_button = new JButton("Generate");
	private JButton rst_button = new JButton("Reset");
	private JTextField key_value = new JTextField(40);

	public encode_dialog(main_frame main_view) {
		// super(main_view, "Encryption", true);
		super();
		this.setTitle("Encryption");
		Image icon_image = Toolkit.getDefaultToolkit().getImage(public_data.ICON_FRAME_PNG);
		this.setIconImage(icon_image);
		Container my_container = this.getContentPane();
		my_container.setLayout(new GridLayout(2, 1, 10, 10));
		JPanel p1 = new JPanel(new GridLayout(4, 2, 10, 10));
		JPanel p3 = new JPanel(new GridLayout(1, 1, 5, 5));
		p1.add(label_username);
		p1.add(field_username);
		p1.add(label_passwd01);
		p1.add(field_passwd01);
		p1.add(label_passwd02);
		p1.add(field_passwd02);
		p1.add(rst_button);
		p1.add(gen_button);
		p3.add(key_value);
		my_container.add(p1);
		my_container.add(p3);
		rst_button.addActionListener(new resetAction());
		gen_button.addActionListener(new genAction());
		my_container.setBackground(Color.white);
		this.setSize(400, 300);
		//this.setLocationRelativeTo(main_view);
		//this.setLocation(600, 600);
	}

	class resetAction implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			field_username.setText("");
			field_passwd01.setText("");
			field_passwd02.setText("");
			key_value.setText("");
		}
	}

	class genAction implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			String user = field_username.getText();
			@SuppressWarnings("deprecation")
			String psw1 = field_passwd01.getText();
			@SuppressWarnings("deprecation")
			String psw2 = field_passwd02.getText();
			if (!psw1.equals(psw2)) {
				JOptionPane.showMessageDialog(null, "Password missmatch, try again.");
				field_passwd01.setText("");
				field_passwd02.setText("");
				key_value.setText("");
			} else {
				String encode_data = user + "_+_" + psw1;
				String my_value = null;
				try {
					my_value = des_encode.encrypt(encode_data, public_data.ENCRY_KEY);
				} catch (Exception e1) {
					e1.printStackTrace();
					my_value = "Exception Found, contact QA team";
				}
				key_value.setText(my_value);
			}
		}
	}
}