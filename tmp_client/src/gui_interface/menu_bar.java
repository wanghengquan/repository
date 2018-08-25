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

import java.awt.Desktop;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.IOException;
import java.net.URI;

import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.task_data;
import data_center.client_data;
import data_center.exit_enum;
import data_center.public_data;
import data_center.switch_data;
import flow_control.pool_data;
import flow_control.queue_enum;

public class menu_bar extends JMenuBar implements ActionListener {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static final Logger MENU_BAR_LOGGER = LogManager.getLogger(menu_bar.class.getName());
	private main_frame main_view;
	private switch_data switch_info;
	private client_data client_info;
	private task_data task_info;
	private pool_data pool_info;
	private view_data view_info;
	String work_space = new String();
	JMenuItem imports, import_user_suite, import_unit_suite, exports, exit;
	JMenuItem view_all, view_waiting, view_processing, view_passed, view_failed, view_tbd, view_timeout, view_halted;
	JMenuItem play, pause, stop;
	JMenuItem retest_all, retest_selected, retest_passed, retest_failed, retest_tbd, retest_timeout, retest_halted;
	JMenuItem upload, key_gen;
	JMenuItem client, software, preference;
	JMenuItem usage, client_help, tmp_doc, tmp_example, contact, about;
	private String line_separator = System.getProperty("line.separator");	
	
	public menu_bar(
			main_frame main_view, 
			switch_data switch_info, 
			client_data client_info, 
			view_data view_info,
			pool_data pool_info,
			task_data task_info) {
		this.main_view = main_view;
		this.switch_info = switch_info;
		this.client_info = client_info;
		this.view_info = view_info;
		this.pool_info = pool_info;
		this.task_info = task_info;
		this.add(construct_file_menu());
		this.add(construct_view_menu());
		this.add(construct_run_menu());
		this.add(construct_tool_menu());
		this.add(construct_setting_menu());
		this.add(construct_help_menu());
		if (client_info.get_client_data().containsKey("preference")) {
			work_space = client_info.get_client_data().get("preference").get("work_space");
		} else {
			work_space = public_data.DEF_WORK_SPACE;
		}
	}

	public menu_bar get_menu_bar() {
		return this;
	}

	public JMenu construct_file_menu() {
		JMenu file = new JMenu("File");
		//JMenu imports = new JMenu("Import");		
		//import_user_suite = new JMenuItem("User suite...");
		//import_user_suite.addActionListener(this);
		//import_unit_suite = new JMenuItem("Unit suite...");
		//import_unit_suite.addActionListener(this);
		//imports.add(import_user_suite);
		//imports.add(import_unit_suite);
		imports = new JMenuItem("Imports...");
		imports.addActionListener(this);
		file.add(imports);
		exports = new JMenuItem("Exports...");
		//exports.setEnabled(false);
		exports.addActionListener(this);
		file.add(exports);
		file.addSeparator();
		exit = new JMenuItem("Exit");
		exit.addActionListener(this);
		file.add(exit);
		return file;
	}

	public JMenu construct_view_menu() {
		JMenu view = new JMenu("View");
		view_all = new JMenuItem(watch_enum.ALL.get_description());
		view_all.addActionListener(this);
		view_waiting = new JMenuItem(watch_enum.WAITING.get_description());
		view_waiting.addActionListener(this);
		view_processing = new JMenuItem(watch_enum.PROCESSING.get_description());
		view_processing.addActionListener(this);
		view_passed = new JMenuItem(watch_enum.PASSED.get_description());
		view_passed.addActionListener(this);
		view_failed = new JMenuItem(watch_enum.FAILED.get_description());
		view_failed.addActionListener(this);
		view_tbd = new JMenuItem(watch_enum.TBD.get_description());
		view_tbd.addActionListener(this);
		view_timeout = new JMenuItem(watch_enum.TIMEOUT.get_description());
		view_timeout.addActionListener(this);
		view_halted = new JMenuItem(watch_enum.HALTED.get_description());
		view_halted.addActionListener(this);		
		view.add(view_all);
		view.add(view_waiting);
		view.add(view_processing);
		view.add(view_failed);
		view.add(view_passed);
		view.add(view_tbd);
		view.add(view_timeout);
		view.add(view_halted);
		return view;
	}

	public JMenu construct_run_menu() {
		JMenu run = new JMenu("Run");
		play = new JMenuItem("Play");
		play.addActionListener(this);
		pause = new JMenuItem("Pause");
		pause.addActionListener(this);
		stop = new JMenuItem("Stop");
		stop.addActionListener(this);
		run.add(play);
		run.add(pause);
		run.add(stop);
		JMenu retest = new JMenu("Retest");
		retest_all = new JMenuItem(retest_enum.ALL.get_description());
		retest_all.addActionListener(this);
		retest_selected = new JMenuItem(retest_enum.SELECTED.get_description());
		retest_selected.addActionListener(this);
		retest_failed = new JMenuItem(retest_enum.FAILED.get_description());
		retest_failed.addActionListener(this);
		retest_passed = new JMenuItem(retest_enum.PASSED.get_description());
		retest_passed.addActionListener(this);
		retest_tbd = new JMenuItem(retest_enum.TBD.get_description());
		retest_tbd.addActionListener(this);
		retest_timeout = new JMenuItem(retest_enum.TIMEOUT.get_description());
		retest_timeout.addActionListener(this);
		retest_halted = new JMenuItem(retest_enum.HALTED.get_description());
		retest_halted.addActionListener(this);		
		retest.add(retest_all);
		retest.add(retest_selected);
		retest.add(retest_failed);
		retest.add(retest_passed);
		retest.add(retest_tbd);
		retest.add(retest_timeout);
		retest.add(retest_halted);
		run.addSeparator();
		run.add(retest);
		return run;
	}

	public JMenu construct_tool_menu() {
		JMenu tools = new JMenu("Tools");
		upload = new JMenuItem("Upload...");
		upload.addActionListener(this);
		key_gen = new JMenuItem("Keygen...");
		key_gen.addActionListener(this);
		tools.add(upload);
		tools.add(key_gen);
		return tools;
	}

	public JMenu construct_setting_menu() {
		JMenu setting = new JMenu("Setting");
		client = new JMenuItem("Client...");
		client.addActionListener(this);
		software = new JMenuItem("Software...");
		software.addActionListener(this);
		preference = new JMenuItem("Preference...");
		preference.addActionListener(this);
		setting.add(client);
		setting.add(software);
		setting.add(preference);
		return setting;
	}

	public JMenu construct_help_menu() {
		JMenu help = new JMenu("Help");
		JMenu usage = new JMenu("Usage");
		client_help = new JMenuItem("Client Help...");
		client_help.addActionListener(this);		
		tmp_doc = new JMenuItem("TMP Doc...");
		tmp_doc.addActionListener(this);		
		tmp_example = new JMenuItem("TMP Example...");
		tmp_example.addActionListener(this);		
		usage.add(client_help);
		usage.add(tmp_doc);
		usage.add(tmp_example);
		contact = new JMenuItem("Contact...");
		contact.addActionListener(this);
		about = new JMenuItem("About...");
		about.addActionListener(this);
		help.add(usage);
		help.addSeparator();
		help.add(contact);
		help.addSeparator();
		help.add(about);
		return help;
	}

	@Override
	public void actionPerformed(ActionEvent e) {
		// TODO Auto-generated method stub
		if (e.getSource().equals(imports)) {
			MENU_BAR_LOGGER.warn("Imports clicked");
			import_dialog import_view = new import_dialog(main_view, client_info, task_info);
			import_view.setLocationRelativeTo(main_view);
			import_view.setVisible(true);			
		}
		if (e.getSource().equals(exports)) {
			MENU_BAR_LOGGER.warn("Exports clicked");
			export_dialog export_view = new export_dialog(main_view, client_info, task_info, view_info);
			export_view.setLocationRelativeTo(main_view);
			export_view.setVisible(true);			
		}
		if (e.getSource().equals(exit)) {
			switch_info.set_client_stop_request(exit_enum.NORMAL);
			main_view.setVisible(false);
		}
		if (e.getSource().equals(view_all)) {
			MENU_BAR_LOGGER.warn("view_all clicked");
			view_info.set_watching_queue_area(watch_enum.ALL);
		}
		if (e.getSource().equals(view_waiting)) {
			MENU_BAR_LOGGER.warn("view_waiting clicked");
			view_info.set_watching_queue_area(watch_enum.WAITING);
		}
		if (e.getSource().equals(view_processing)) {
			MENU_BAR_LOGGER.warn("view_processing clicked");
			view_info.set_watching_queue_area(watch_enum.PROCESSING);
		}
		if (e.getSource().equals(view_passed)) {
			MENU_BAR_LOGGER.warn("view_passed clicked");
			view_info.set_watching_queue_area(watch_enum.PASSED);
		}
		if (e.getSource().equals(view_failed)) {
			MENU_BAR_LOGGER.warn("view_failed clicked");
			view_info.set_watching_queue_area(watch_enum.FAILED);
		}
		if (e.getSource().equals(view_tbd)) {
			MENU_BAR_LOGGER.warn("view_tbd clicked");
			view_info.set_watching_queue_area(watch_enum.TBD);
		}
		if (e.getSource().equals(view_timeout)) {
			MENU_BAR_LOGGER.warn("view_timeout clicked");
			view_info.set_watching_queue_area(watch_enum.TIMEOUT);
		}
		if (e.getSource().equals(view_halted)) {
			MENU_BAR_LOGGER.warn("view_halted clicked");
			view_info.set_watching_queue_area(watch_enum.HALTED);
		}		
		if (e.getSource().equals(play)) {
			MENU_BAR_LOGGER.warn("play clicked");
			view_info.set_run_action_request(queue_enum.PROCESSING);
		}
		if (e.getSource().equals(pause)) {
			MENU_BAR_LOGGER.warn("pause clicked");
			view_info.set_run_action_request(queue_enum.PAUSED);
		}
		if (e.getSource().equals(stop)) {
			MENU_BAR_LOGGER.warn("stop clicked");
			view_info.set_run_action_request(queue_enum.STOPPED);
		}
		if (e.getSource().equals(retest_all)) {
			MENU_BAR_LOGGER.warn("retest_all clicked");
			view_info.set_retest_queue_area(retest_enum.ALL);
		}
		if (e.getSource().equals(retest_selected)) {
			MENU_BAR_LOGGER.warn("retest_selected clicked");
			view_info.set_retest_queue_area(retest_enum.SELECTED);
		}
		if (e.getSource().equals(retest_passed)) {
			MENU_BAR_LOGGER.warn("retest_passed clicked");
			view_info.set_retest_queue_area(retest_enum.PASSED);
		}
		if (e.getSource().equals(retest_failed)) {
			MENU_BAR_LOGGER.warn("retest_failed clicked");
			view_info.set_retest_queue_area(retest_enum.FAILED);
		}
		if (e.getSource().equals(retest_tbd)) {
			MENU_BAR_LOGGER.warn("retest_tbd clicked");
			view_info.set_retest_queue_area(retest_enum.TBD);
		}
		if (e.getSource().equals(retest_timeout)) {
			MENU_BAR_LOGGER.warn("retest_timeout clicked");
			view_info.set_retest_queue_area(retest_enum.TIMEOUT);
		}
		if (e.getSource().equals(retest_halted)) {
			MENU_BAR_LOGGER.warn("retest_halted clicked");
			view_info.set_retest_queue_area(retest_enum.HALTED);
		}		
		if (e.getSource().equals(upload)) {
			MENU_BAR_LOGGER.warn("upload clicked");
			upload_dialog upload_view = new upload_dialog(client_info);
			upload_view.setLocationRelativeTo(main_view);
			upload_view.setVisible(true);
		}
		if (e.getSource().equals(key_gen)) {
			encode_dialog encode_view = new encode_dialog(main_view);
			encode_view.setLocationRelativeTo(main_view);
			encode_view.setVisible(true);
		}
		if (e.getSource().equals(client)) {
			client_dialog client_view = new client_dialog(main_view, switch_info, client_info);
			client_view.setLocationRelativeTo(main_view);
			client_view.setVisible(true);
		}
		if (e.getSource().equals(software)) {
			software_dialog software_view = new software_dialog(main_view, switch_info, client_info);
			software_view.setLocationRelativeTo(main_view);
			software_view.setVisible(true);
		}
		if (e.getSource().equals(preference)) {
			preference_dialog pref_view = new preference_dialog(main_view, switch_info, pool_info, client_info);
			new Thread(pref_view).start();
			pref_view.setLocationRelativeTo(main_view);
			pref_view.setVisible(true);
		}
		if (e.getSource().equals(client_help)) {
			MENU_BAR_LOGGER.warn("client usage clicked");
			String message = new String("Cannot open usage file:" + line_separator + public_data.DOC_CLIENT_USAGE);
			String title = new String("Open usage file failed");
			if (Desktop.isDesktopSupported()) {
				Desktop desktop = Desktop.getDesktop();
				try {
					desktop.open(new File(public_data.DOC_CLIENT_USAGE));
				} catch (IOException client_exception) {
					// TODO Auto-generated catch block
					client_exception.printStackTrace();
					JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
				}
			} else {
				JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
			}
		}
		if (e.getSource().equals(tmp_doc)) {
			MENU_BAR_LOGGER.warn("tmp client usage clicked");
			String message = new String("Cannot open usage folder:" + line_separator + public_data.DOC_TMP_USAGE);
			String title = new String("Open TMP documents folder failed");
			if (Desktop.isDesktopSupported()) {
				Desktop desktop = Desktop.getDesktop();
				try {
					desktop.open(new File(public_data.DOC_TMP_USAGE));
				} catch (IOException tmp_doc_exception) {
					// TODO Auto-generated catch block
					tmp_doc_exception.printStackTrace();
					JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
				}
			} else {
				JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
			}	
		}
		if (e.getSource().equals(tmp_example)) {
			MENU_BAR_LOGGER.warn("tmp example usage clicked");
			String message = new String("Cannot open usage file:" + line_separator + public_data.DOC_EXAMPLE_PATH);
			String title = new String("Open example folder failed");
			if (Desktop.isDesktopSupported()) {
				Desktop desktop = Desktop.getDesktop();
				try {
					desktop.open(new File(public_data.DOC_EXAMPLE_PATH));
				} catch (IOException tmp_example_exception) {
					// TODO Auto-generated catch block
					tmp_example_exception.printStackTrace();
					JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
				}
			} else {
				JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
			}
		}		
		if (e.getSource().equals(contact)) {
			MENU_BAR_LOGGER.warn("Contact clicked");
			String title = "Open Mail Failed:";
			String message = "Can not open system registered mail." + line_separator + "Please send mail to:"
					+ public_data.BASE_DEVELOPER_MAIL;
			if (Desktop.isDesktopSupported()) {
				Desktop desktop = Desktop.getDesktop();
				try {
					desktop.mail(new URI("mailto:" + public_data.BASE_DEVELOPER_MAIL));
				} catch (Exception contact_e) {
					// TODO Auto-generated catch block
					// contact_e.printStackTrace();
					JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
				} 
			} else {
				JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
			}
		}
		if (e.getSource().equals(about)) {
			MENU_BAR_LOGGER.warn("about clicked");
			about_dialog about_view = new about_dialog(main_view, client_info, switch_info);
			about_view.setLocationRelativeTo(main_view);
			about_view.setVisible(true);
		}
	}
}