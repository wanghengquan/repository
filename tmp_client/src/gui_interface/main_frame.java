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

import java.awt.AWTException;
import java.awt.BorderLayout;
import java.awt.Font;
import java.awt.Image;
import java.awt.MenuItem;
import java.awt.PopupMenu;
import java.awt.SystemTray;
import java.awt.Toolkit;
import java.awt.TrayIcon;
import java.awt.TrayIcon.MessageType;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Enumeration;

import javax.swing.JFrame;
import javax.swing.UIManager;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.public_data;
import data_center.switch_data;

public class main_frame extends JFrame {
	// public property
	// protected property
	// private property
	private static final Logger MAIN_FRAME_LOGGER = LogManager.getLogger(main_frame.class.getName());
	private switch_data switch_info;
	// public function
	// protected function
	// private function
	public main_frame(switch_data switch_info) {
		this.switch_info = switch_info;
		default_font_set();
		initial_components();
		launch_system_tray();
		this.setVisible(true);
	}

	private void initial_components() {
		this.setLocation(600, 300);
		this.setSize(1200, 1000);
		Image icon_image = Toolkit.getDefaultToolkit().getImage(public_data.CONF_FRAME_PNG);
		this.setIconImage(icon_image);
		this.setTitle("TestRail Client");
		this.setJMenuBar(new menu_bar(this, switch_info));
		this.getContentPane().add(new work_pane(), BorderLayout.CENTER);
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	}

	private void launch_system_tray() {
		if (!SystemTray.isSupported()) {
			return;
		}
		String title = "TestRail Client";
		String company = "LATTICE";
		Image tray_image = Toolkit.getDefaultToolkit().getImage(public_data.CONF_TRAY_PNG);
		TrayIcon trayicon = new TrayIcon(tray_image, title + "@" + company, pop_menu());
		trayicon.setImageAutoSize(true);
		// trayicon.addActionListener(this);
		SystemTray systemTray = SystemTray.getSystemTray();
		try {
			systemTray.add(trayicon);
			trayicon.displayMessage(title, company, MessageType.INFO);
		} catch (AWTException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private PopupMenu pop_menu() {
		PopupMenu menu = new PopupMenu();
		MenuItem exit = new MenuItem("Close");
		exit.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent ex) {
				System.exit(0);
			}
		});
		MenuItem open = new MenuItem("Open");
		open.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent ex) {
				if (isVisible()) {
					toFront();
				} else {
					setVisible(true);
					toFront();
				}
			}
		});
		menu.add(open);
		menu.addSeparator();
		menu.add(exit);
		return menu;
	}

	public void default_font_set() {
		//UIManager.put("Menu.font", new Font("Serif", Font.PLAIN, 20));
		Font font = new Font("Serif", Font.PLAIN, 20);
		Enumeration<Object> keys = UIManager.getDefaults().keys();
		while (keys.hasMoreElements()) {
			Object key = keys.nextElement();
			Object value = UIManager.get(key);
			if (value instanceof javax.swing.plaf.FontUIResource) {
				UIManager.put(key, font);
			}
		}
	}

	public static void main(String[] args) {
		switch_data switch_info = new switch_data();
		main_frame top_view = new main_frame(switch_info);
	}
}
