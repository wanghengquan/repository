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
import java.awt.Color;
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
import javax.swing.SwingUtilities;
import javax.swing.UIManager;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.task_data;
import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;
import flow_control.pool_data;

public class main_frame extends JFrame {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	// public property
	// protected property
	// private property
	private static final Logger MAIN_FRAME_LOGGER = LogManager.getLogger(main_frame.class.getName());
	private switch_data switch_info;
	private client_data client_info;
	private view_data view_info;
	private task_data task_info;
	private pool_data pool_info;
	
	// public function
	// protected function
	// private function
	public main_frame(
			switch_data switch_info, 
			client_data client_info, 
			view_data view_info, 
			task_data task_info, 
			pool_data pool_info) {
		this.switch_info = switch_info;
		this.client_info = client_info;
		this.view_info = view_info;
		this.task_info = task_info;
		this.pool_info = pool_info;
	}

	public void gui_constructor(){
		default_font_set();
		initial_components();
		launch_system_tray();
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
	
	private void initial_components() {
		this.setLocation(400, 100);
		this.setSize(1200, 1000);
		Image icon_image = Toolkit.getDefaultToolkit().getImage(public_data.ICON_FRAME_PNG);
		this.setIconImage(icon_image);
		this.setTitle("TestRail Client");
		this.setJMenuBar(new menu_bar(this, switch_info, client_info, view_info));
		work_panel task_insts = new work_panel(view_info, client_info, task_info);
		this.getContentPane().add(task_insts, BorderLayout.CENTER);
		status_bar status_insts = new status_bar(switch_info, client_info, pool_info);
		new Thread(status_insts).start();
		this.getContentPane().add(status_insts, BorderLayout.SOUTH);
		this.getContentPane().setBackground(Color.white);
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		new Thread(task_insts).start();
		
	}

	private void launch_system_tray() {
		if (!SystemTray.isSupported()) {
			return;
		}
		String title = "TestRail Client";
		String company = "LATTICE";
		Image tray_image = Toolkit.getDefaultToolkit().getImage(public_data.ICON_TRAY_PNG);
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
		MenuItem close = new MenuItem("Close");
		close.addActionListener(new ActionListener() {
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
		menu.add(close);
		return menu;
	}

	public static void main(String[] args) {
		switch_data switch_info = new switch_data();
		view_data view_info = new view_data();
		task_data task_info = new task_data();
		client_data client_info = new client_data();
		pool_data pool_info = new pool_data(public_data.PERF_POOL_MAXIMUM_THREAD);
		main_frame top_view = new main_frame(switch_info, client_info, view_info, task_info, pool_info);
		view_info.set_view_debug(true);
		MAIN_FRAME_LOGGER.warn("GUI start");
		if (SwingUtilities.isEventDispatchThread()) {
			top_view.gui_constructor();
			top_view.setVisible(true);
		} else {
			SwingUtilities.invokeLater(new Runnable(){
				@Override
				public void run() {
					// TODO Auto-generated method stub
					top_view.gui_constructor();
					top_view.setVisible(true);
				}
			});
		}
	}
}
