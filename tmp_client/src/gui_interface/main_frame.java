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

import java.io.File;
import java.util.List;

import java.awt.AWTException;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
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
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.Enumeration;
import java.util.HashMap;

import javax.swing.JFrame;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;

import connect_tube.local_tube;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.task_data;
import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;
import flow_control.pool_data;
import flow_control.post_data;
import top_runner.run_status.exit_enum;
import utility_funcs.time_info;

import java.awt.dnd.DnDConstants;
import java.awt.dnd.DropTarget;
import java.awt.dnd.DropTargetAdapter;
import java.awt.dnd.DropTargetDropEvent;
import java.awt.datatransfer.DataFlavor;

import javax.swing.*;

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
	private post_data post_info;

	// public function
	// protected function
	// private function
	public main_frame(
			switch_data switch_info, 
			client_data client_info, 
			view_data view_info, 
			task_data task_info,
			pool_data pool_info,
			post_data post_info) {
		this.switch_info = switch_info;
		this.client_info = client_info;
		this.view_info = view_info;
		this.task_info = task_info;
		this.pool_info = pool_info;
		this.post_info = post_info;
	}

	public void gui_constructor() {
		set_size_location();
		set_default_font();
		set_system_look_feel();
		initial_components();
		launch_system_tray();
	}

	public void set_size_location(){
		this.setSize(1200, 1000);
		Toolkit kit = Toolkit.getDefaultToolkit();
		Dimension screenSize = kit.getScreenSize();
		int screenWidth = screenSize.width/2;
		int screenHeight = screenSize.height/2;
		int height = this.getHeight();
		int width = this.getWidth();
		this.setLocation(screenWidth-width/2, screenHeight-height/2);
	}
	
	public void show_welcome_letter() {
		// show welcome if need
		HashMap<String, HashMap<String, String>> client_data = new HashMap<String, HashMap<String, String>>();
		client_data.putAll(client_info.get_client_data());
		HashMap<String, String> preference_data = client_data.get("preference");
		if (preference_data != null && preference_data.get("show_welcome").equals("1")) {
			welcome_dialog welcome_view = new welcome_dialog(this, switch_info, client_info);
			welcome_view.setLocationRelativeTo(this);
			welcome_view.setVisible(true);
		}
	}

	private void set_default_font() {
		// UIManager.put("Menu.font", new Font("Serif", Font.PLAIN, 20));
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

	private void set_system_look_feel(){
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception ex) {
        	MAIN_FRAME_LOGGER.warn("GUI setting System look and feel failed.");
        }
	}
	
	private void initial_components() {
		//this.setLocation(300, 50);
		//this.setLocationRelativeTo(null);
		//this.setSize(1200, 1000);
		Image icon_image = Toolkit.getDefaultToolkit().getImage(public_data.ICON_FRAME_PNG);
		this.setIconImage(icon_image);
		this.setTitle("TestRail Client");
		this.setJMenuBar(new menu_bar(this, switch_info, client_info, view_info, pool_info, task_info, post_info));
		work_panel task_insts = new work_panel(this, view_info, client_info, task_info);
		this.getContentPane().add(task_insts, BorderLayout.CENTER);
		status_bar status_insts = new status_bar(this, client_info, switch_info, pool_info, post_info);
		new Thread(status_insts).start();
		this.getContentPane().add(status_insts, BorderLayout.SOUTH);
		this.getContentPane().setBackground(Color.white);
		this.setDefaultCloseOperation(JFrame.HIDE_ON_CLOSE);
        this.openDrag(task_insts);
		new Thread(task_insts).start();
	}


    private void openDrag(work_panel task_insts) {
        new DropTarget(task_insts, DnDConstants.ACTION_COPY_OR_MOVE, new DropTargetAdapter() {
            @Override
            public void drop(DropTargetDropEvent dtde) {
                try {
                    if(dtde.isDataFlavorSupported(DataFlavor.javaFileListFlavor)){
                        dtde.acceptDrop(DnDConstants.ACTION_COPY_OR_MOVE);
                        @SuppressWarnings("unchecked")
						List<File> list = 
						    (List<File>)(dtde.getTransferable().getTransferData(DataFlavor.javaFileListFlavor));
                        for(File file:list){
                            String link_mode = client_info.get_client_preference_data().get("link_mode");
                            if (link_mode.equals("remote")){
                                String title = "Link mode error";
                                String message = "Client run in remote mode, cannot import local suite file. " +
                                        "Please go and setting in \"Setting --> Preference...\"";
                                JOptionPane.showMessageDialog(null, message,
                                        title, JOptionPane.INFORMATION_MESSAGE);
                                return;
                            }
                            String user_file = file.getAbsolutePath().replaceAll("\\\\", "/");
                            if (user_file.length() > 0){
                                drag_import_local_task_data(user_file, "");
                            }
                        }
                        dtde.dropComplete(true);
                    } else {
                        dtde.rejectDrop();
                    }
                } catch (Exception e){e.printStackTrace();}
            }
        });
    }

    private void drag_import_local_task_data(
            String task_files,
            String task_env){
        if (local_tube.suite_file_sanity_check(task_files)){
            MAIN_FRAME_LOGGER.warn("Importing suite file:" + task_files);
        } else {
        	String line_separator = System.getProperty("line.separator");
            MAIN_FRAME_LOGGER.warn("Importing suite file failed:" + task_files);
            String title = new String("Import suite file error");
            String message = new String("File:" + task_files + line_separator + local_tube.suite_file_error_msg);
            JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
            return;
        }
        String import_time_id = time_info.get_date_time();
        HashMap <String, String> task_data = new HashMap <String, String>();
        task_data.put("path", task_files);
        task_data.put("env", task_env);
        task_info.update_local_file_imported_task_map(import_time_id, task_data);
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

	private void launch_system_tray() {
		if (!SystemTray.isSupported()) {
			return;
		}
		String title = "TestRail Client";
		String company = "LATTICE";
		Image tray_image = Toolkit.getDefaultToolkit().getImage(public_data.ICON_TRAY_PNG);
		TrayIcon trayicon = new TrayIcon(tray_image, title + "@" + company, pop_menu());
		trayicon.addMouseListener(new MouseAdapter() {
			public void mouseClicked(MouseEvent e) {
				int click_count = e.getClickCount();
				if(click_count < 2){
					MAIN_FRAME_LOGGER.info("click count:" + String.valueOf(click_count) + ", skip.");
					return;
				} else {
					show_main_view();
				}
			}
		});
		trayicon.setImageAutoSize(true);
		// trayicon.addActionListener(this);
		SystemTray systemTray = SystemTray.getSystemTray();
		try {
			systemTray.add(trayicon);
			trayicon.displayMessage(title, company, MessageType.INFO);
		} catch (AWTException e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			MAIN_FRAME_LOGGER.warn("SystemTray Launch Failed.");
		}
	}

	private PopupMenu pop_menu() {
		PopupMenu menu = new PopupMenu();
		MenuItem close = new MenuItem("Close");
		close.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent ex) {
				switch_info.set_client_stop_request(exit_enum.NORMAL);
			}
		});
		MenuItem open = new MenuItem("Open");
		open.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent ex) {
				show_main_view();
			}
		});
		menu.add(open);
		menu.addSeparator();
		menu.add(close);
		return menu;
	}

	private void show_main_view(){
		if (this.isVisible()) {
			this.toFront();
		} else {
			this.setVisible(true);
			this.toFront();
		}
	}
	
	public static void main(String[] args) {
		switch_data switch_info = new switch_data();
		view_data view_info = new view_data();
		task_data task_info = new task_data();
		client_data client_info = new client_data();
		pool_data pool_info = new pool_data(public_data.PERF_POOL_MAXIMUM_SIZE);
		post_data post_info = new post_data();
		main_frame top_view = new main_frame(switch_info, client_info, view_info, task_info, pool_info, post_info);
		view_info.set_view_debug(true);
		MAIN_FRAME_LOGGER.warn("GUI start");
		if (SwingUtilities.isEventDispatchThread()) {
			top_view.gui_constructor();
			top_view.setVisible(true);
			top_view.show_welcome_letter();
		} else {
			SwingUtilities.invokeLater(new Runnable() {
				@Override
				public void run() {
					// TODO Auto-generated method stub
					top_view.gui_constructor();
					top_view.setVisible(true);
					top_view.show_welcome_letter();
				}
			});
		}
	}
}
