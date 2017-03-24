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
import java.awt.Image;
import java.awt.Toolkit;

import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JProgressBar;
import javax.swing.SwingUtilities;

import data_center.public_data;
import data_center.switch_data;

interface status_value {
	static final int client_check_ok = 20;
	static final int core_script_ok = 40;
	static final int data_server_ok = 60;
	static final int tube_server_ok = 80;
	static final int hall_server_ok	= 99;	
}

public class start_progress extends JDialog implements Runnable, status_value{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private switch_data switch_info;
	private JProgressBar jpb_progress;
	private JLabel jl_info;
	private Integer progress_count = new Integer(0);

	public start_progress(switch_data switch_info){
		this.switch_info = switch_info;
		this.setTitle("TMP Client Starting... ");
		Image icon_image = Toolkit.getDefaultToolkit().getImage(public_data.ICON_FRAME_PNG);
		this.setIconImage(icon_image);			
		Container container = this.getContentPane();
		container.add(construct_top_panel(), BorderLayout.CENTER);
		container.add(construct_bottom_panel(), BorderLayout.SOUTH);
		this.setLocation(800, 500);
		this.setSize(400, 100);
	}
	
	public JPanel construct_top_panel(){
		JPanel jp_info = new JPanel(new BorderLayout());
		jpb_progress = new JProgressBar();
		jpb_progress.setStringPainted(true);
		//jpb_progress.setIndeterminate(true);
		jp_info.add(jpb_progress, BorderLayout.CENTER);
		return jp_info;		
	}
	
	public JPanel construct_bottom_panel(){
		JPanel jp_info = new JPanel(new BorderLayout());
		jl_info = new JLabel();
		jp_info.add(jl_info, BorderLayout.CENTER);
		return jp_info;
	}
	
	@Override
	public void run() {
		// TODO Auto-generated method stub
		for(progress_count = 1; progress_count < 101; progress_count++){
			if (SwingUtilities.isEventDispatchThread()) {
				jpb_progress.setValue(progress_count);
				if(progress_count.equals(100)){
					switch_info.set_back_ground_power_up();
				}
			} else {
				SwingUtilities.invokeLater(new Runnable(){
					@Override
					public void run() {
						// TODO Auto-generated method stub
						jpb_progress.setValue(progress_count);
						if(progress_count.equals(100)){
							switch_info.set_back_ground_power_up();
						}						
					}
				});
			}
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
	}
	

	
	
	public static void main(String[] args) {
		switch_data switch_info = new switch_data();		
		start_progress progress_view = new start_progress(switch_info);
		new Thread(progress_view).start();
		progress_view.setVisible(true);
	}
	
}