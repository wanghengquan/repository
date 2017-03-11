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
import java.awt.Image;
import java.awt.MenuItem;
import java.awt.PopupMenu;
import java.awt.SystemTray;
import java.awt.Toolkit;
import java.awt.TrayIcon;
import java.awt.TrayIcon.MessageType;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JFrame;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.public_data;

public class main_frame extends JFrame{
	// public property
	// protected property
	// private property
	private static final Logger MAIN_FRAME_LOGGER = LogManager.getLogger(main_frame.class.getName());

	// public function
	// protected function
	// private function
	public main_frame() {
		initial_components();
		launch_system_tray();
		this.setVisible(true);
	}

	private void initial_components(){ 
		this.setSize(600, 800);
		Image icon_image = Toolkit.getDefaultToolkit().getImage(public_data.CONF_FRAME_PNG);
		this.setIconImage(icon_image);
		this.setTitle("TestRail Client");		
		this.setJMenuBar(new menu_bar());
	}
	
	private void launch_system_tray(){
		if (!SystemTray.isSupported()) {
			return;
		}
		String title = "TestRail Client";
		String company = "LATTICE";
		Image tray_image = Toolkit.getDefaultToolkit().getImage(public_data.CONF_TRAY_PNG);
		TrayIcon trayicon = new TrayIcon(tray_image, title + "@" + company, pop_menu());
		trayicon.setImageAutoSize(true);
		//trayicon.addActionListener(this);
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
	
	public static void main(String[] args) {
		main_frame top_view = new main_frame();
	}	
}



