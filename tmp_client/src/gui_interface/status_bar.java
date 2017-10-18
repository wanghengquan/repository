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

import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.GridLayout;
import java.util.HashMap;

import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.SwingUtilities;

import data_center.client_data;
import data_center.public_data;
import flow_control.pool_data;

public class status_bar extends JPanel implements Runnable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private client_data client_info;
	private pool_data pool_info;
	JTextField jt_thread, jt_link, jt_cpu, jt_mem;
	JLabel icon_belong,icon_mode;	
	ImageIcon engineer_image, robot_image, private_image, public_image;


	public status_bar(client_data client_info, pool_data pool_info){
		this.pool_info = pool_info;
		this.client_info = client_info;
		engineer_image = new ImageIcon(public_data.ICON_ATTENDED_MODE);
		robot_image = new ImageIcon(public_data.ICON_UNATTENDED_MODE);
		private_image = new ImageIcon(public_data.ICON_PRIVATE_MODE);
		public_image = new ImageIcon(public_data.ICON_PUBLIC_MODE);
		this.setLayout(new GridLayout(1,1,5,5));
		this.add(construct_status_bar());
	}
	
	private JPanel construct_status_bar(){
		GridBagLayout status_layout = new GridBagLayout();
		JPanel bar_panel = new JPanel(status_layout);
		//link to part
		JLabel jl_link = new JLabel("Link To:");
		jt_link = new JTextField();
		jt_link.setEditable(false);
		bar_panel.add(jl_link);
		bar_panel.add(jt_link);
		//blank cell1
		JPanel blank_cell1 = new JPanel();
		bar_panel.add(blank_cell1);
		//working threads part
		JLabel jl_thread = new JLabel("Working Thread(s):");
		jt_thread = new JTextField();
		jt_thread.setEditable(false);
		bar_panel.add(jl_thread);
		bar_panel.add(jt_thread);
		//blank cell2
		JPanel blank_cell2 = new JPanel();
		bar_panel.add(blank_cell2);		
		//system info part
		JLabel jl_system = new JLabel("System Info: ");
		JLabel jl_cpu = new JLabel(" CPU:");
		jl_cpu.setHorizontalAlignment(SwingConstants.RIGHT);
		jt_cpu = new JTextField();
		jt_cpu.setEditable(false);
		JLabel jl_mem = new JLabel(" MEM:");
		jl_mem.setHorizontalAlignment(SwingConstants.RIGHT);
		jt_mem = new JTextField();
		jt_mem.setEditable(false);
		bar_panel.add(jl_system);
		bar_panel.add(jl_cpu);
		bar_panel.add(jt_cpu);
		bar_panel.add(jl_mem);
		bar_panel.add(jt_mem);
		//blank cell3
		JPanel blank_cell3 = new JPanel();
		bar_panel.add(blank_cell3);
		//attended mode
		String mode = new String(public_data.DEF_UNATTENDED_MODE);
		if (client_info.get_client_data().containsKey("Machine")) {
			mode = client_info.get_client_data().get("Machine").getOrDefault("unattended", public_data.DEF_UNATTENDED_MODE);
		}
		icon_mode = new JLabel();
		if(mode.equals("0")){
			icon_mode.setIcon(engineer_image);
			icon_mode.setToolTipText("Client run in Attended mode.");
		} else {
			icon_mode.setIcon(robot_image);
			icon_mode.setToolTipText("Client run in Unattended mode.");
		}
		bar_panel.add(icon_mode);		
		//private/public mode
		String belong = new String(public_data.DEF_MACHINE_PRIVATE);
		if (client_info.get_client_data().containsKey("Machine")) {
			belong = client_info.get_client_data().get("Machine").getOrDefault("private", public_data.DEF_UNATTENDED_MODE);
		}
		icon_belong = new JLabel();
		if(belong.equals("1")){
			icon_belong.setIcon(private_image);
			icon_belong.setToolTipText("Run in Private mode, only task assigned to this client will be take!");
		} else {
			icon_belong.setIcon(public_image);
			icon_belong.setToolTipText("Run in Public mode, all assigned/matched task will be take!");
		}
		bar_panel.add(icon_belong);
		//Setting
		GridBagConstraints layout_s = new GridBagConstraints();
		layout_s.fill = GridBagConstraints.BOTH;
		//for jl_link
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		status_layout.setConstraints(jl_link, layout_s);
		//for jt_link
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		status_layout.setConstraints(jt_link, layout_s);	
		//for blank_cell1
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		status_layout.setConstraints(blank_cell1, layout_s);
		//for jl_thread
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		status_layout.setConstraints(jl_thread, layout_s);
		//for jt_thread
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		status_layout.setConstraints(jt_thread, layout_s);
		//for blank_cell2
		layout_s.gridwidth=1;
		layout_s.weightx = 0.5;
		layout_s.weighty=0;
		status_layout.setConstraints(blank_cell2, layout_s);
		//for jl_system
		layout_s.gridwidth=2;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		status_layout.setConstraints(jl_system, layout_s);	
		//for jl_cpu
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		status_layout.setConstraints(jl_cpu, layout_s);	
		//for jt_cpu
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		status_layout.setConstraints(jt_cpu, layout_s);
		//for jl_mem
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		status_layout.setConstraints(jl_mem, layout_s);	
		//for jt_mem
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		status_layout.setConstraints(jt_mem, layout_s);	
		//for blank_cell3
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		status_layout.setConstraints(blank_cell3, layout_s);
		//for icon_mode
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		status_layout.setConstraints(icon_mode, layout_s);
		//for icon_belong
		layout_s.gridwidth=0;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		status_layout.setConstraints(icon_belong, layout_s);		
		return bar_panel;
	}
	
	private void update_link_data(){
		HashMap<String, HashMap<String, String>> client_hash = new HashMap<String, HashMap<String, String>>();
		client_hash.putAll(client_info.get_client_data());
		String link_info = new String("NA");
		if(client_hash.containsKey("preference")){
			link_info = client_hash.get("preference").get("link_mode");
		}
		jt_link.setText(link_info.substring(0, 1).toUpperCase() + link_info.substring(1));
	}
	
	private void update_thread_data(){
		int max_thread = pool_info.get_pool_current_size();
		int use_thread = pool_info.get_pool_used_threads();
		String show_info = String.valueOf(use_thread) + "/" + String.valueOf(max_thread);
		jt_thread.setText(show_info);
	}
	
	private void update_system_data(){
		HashMap<String, HashMap<String, String>> client_hash = new HashMap<String, HashMap<String, String>>();
		client_hash.putAll(client_info.get_client_data());
		String cpu_info = new String();
		String mem_info = new String();
		if(client_hash.containsKey("System")){
			cpu_info = client_hash.get("System").get("cpu");
		} else {
			cpu_info = "NA";
		}
		if(client_hash.containsKey("System")){
			mem_info = client_hash.get("System").get("mem");
		} else {
			mem_info = "NA";
		}
		jt_cpu.setText(cpu_info);
		jt_mem.setText(mem_info);
	}	
	
	private void update_attended_data(){
		HashMap<String, HashMap<String, String>> client_hash = new HashMap<String, HashMap<String, String>>();
		client_hash.putAll(client_info.get_client_data());	
		if(!client_hash.containsKey("Machine")){
			return;
		}
		String mode = new String(client_hash.get("Machine").getOrDefault("unattended", public_data.DEF_UNATTENDED_MODE));
		if(mode.equals("0")){
			icon_mode.setIcon(engineer_image);
			icon_mode.setToolTipText("Client run in Attended mode.");
		} else {
			icon_mode.setIcon(robot_image);
			icon_mode.setToolTipText("Client run in Unattended mode.");
		}		
	}
	
	private void update_belong_data(){
		HashMap<String, HashMap<String, String>> client_hash = new HashMap<String, HashMap<String, String>>();
		client_hash.putAll(client_info.get_client_data());	
		if(!client_hash.containsKey("Machine")){
			return;
		}
		String belong = new String(client_hash.get("Machine").getOrDefault("private", public_data.DEF_MACHINE_PRIVATE));
		if(belong.equals("1")){
			icon_belong.setIcon(private_image);
			icon_belong.setToolTipText("Client run in Private mode, only task assign to this client will be take!");
		} else {
			icon_belong.setIcon(public_image);
			icon_belong.setToolTipText("Client run in Public mode, all matched task will be take!");
		}		
	}
	
	@Override
	public void run() {
		// TODO Auto-generated method stub
		while (true) {
			if (SwingUtilities.isEventDispatchThread()) {
				update_link_data();
				update_thread_data();
				update_system_data();
				update_belong_data();
				update_attended_data();
			} else {
				SwingUtilities.invokeLater(new Runnable(){
					@Override
					public void run() {
						// TODO Auto-generated method stub
						update_link_data();
						update_thread_data();
						update_system_data();
						update_belong_data();
						update_attended_data();
					}
				});
			}
			try {
				Thread.sleep(2000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}		
	}
}