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

import java.awt.Container;

import javax.swing.JDialog;
import javax.swing.JLabel;

public class client_dialog extends JDialog{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public client_dialog(main_frame main_view){
		super(main_view, "Client Setting", true);
		Container container = this.getContentPane();
		container.add(new JLabel("test"));
		this.setLocation(800, 500);
		this.setSize(500, 500);
	}
		
}