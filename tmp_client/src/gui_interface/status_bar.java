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
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.util.HashMap;

import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.SwingUtilities;

import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;
import flow_control.pool_data;
import top_runner.run_status.state_enum;

public class status_bar extends JPanel implements Runnable, MouseListener{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private main_frame main_view;
	private client_data client_info;
	private switch_data switch_info;
	private pool_data pool_info;
	private String line_separator = System.getProperty("line.separator");
	JTextField jt_thread, jt_link, jt_state, jt_cpu, jt_mem;
	JLabel icon_belong,icon_mode;	
	ImageIcon engineer_image, robot_image, private_image, public_image;


	public status_bar(
			main_frame main_view,
			client_data client_info, 
			switch_data switch_info, 
			pool_data pool_info){
		this.main_view = main_view;
		this.pool_info = pool_info;
		this.client_info = client_info;
		this.switch_info = switch_info;
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
		//work state
		JLabel jl_state = new JLabel("State:");
		jt_state = new JTextField();
		jt_state.setEditable(false);
		bar_panel.add(jl_state);
		bar_panel.add(jt_state);		
		//working threads part
		JLabel jl_thread = new JLabel("Thread(s):");
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
			mode = client_info.get_client_machine_data().getOrDefault("unattended", public_data.DEF_UNATTENDED_MODE);
		}
		icon_mode = new JLabel();
		if(mode.equals("0")){
			icon_mode.setIcon(engineer_image);
			icon_mode.setToolTipText("Client run in Attended mode.");
		} else {
			icon_mode.setIcon(robot_image);
			icon_mode.setToolTipText("Client run in Unattended mode.");
		}
		icon_mode.addMouseListener(this);
		bar_panel.add(icon_mode);		
		//private/public mode
		String belong = new String(public_data.DEF_MACHINE_PRIVATE);
		if (client_info.get_client_data().containsKey("Machine")) {
			belong = client_info.get_client_machine_data().getOrDefault("private", public_data.DEF_UNATTENDED_MODE);
		}
		icon_belong = new JLabel();
		if(belong.equals("1")){
			icon_belong.setIcon(private_image);
			icon_belong.setToolTipText("Run in Private mode, only task assigned to this client will be take!");
		} else {
			icon_belong.setIcon(public_image);
			icon_belong.setToolTipText("Run in Public mode, all assigned/matched task will be take!");
		}
		icon_belong.addMouseListener(this);
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
		//for jl_state
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		status_layout.setConstraints(jl_state, layout_s);
		//for jt_state
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		status_layout.setConstraints(jt_state, layout_s);		
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
	
	private void update_state_data(){
		state_enum state_info = switch_info.get_client_run_state();
		String state_str = state_info.get_description();
		jt_state.setText(state_str.substring(0, 1).toUpperCase() + state_str.substring(1));
		if (state_info.equals(state_enum.maintain)){
			jt_state.setToolTipText("Reason:" + switch_info.get_client_maintain_list().toString());
		} else {
			jt_state.setToolTipText("");
		}
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
			icon_mode.setToolTipText("Client run in 'Attended' mode.");
		} else {
			icon_mode.setIcon(robot_image);
			icon_mode.setToolTipText("Client run in 'Unattended' mode.");
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
			icon_belong.setToolTipText("Client run in 'Private' mode, only assigned tasks will be take.");
		} else {
			icon_belong.setIcon(public_image);
			icon_belong.setToolTipText("Client run in 'Public' mode, all matched tasks will be take!");
		}		
	}
	
	@Override
	public void run() {
		// TODO Auto-generated method stub
		while (true) {
			if (SwingUtilities.isEventDispatchThread()) {
				update_link_data();
				update_state_data();
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
						update_state_data();
						update_thread_data();
						update_system_data();
						update_belong_data();
						update_attended_data();
					}
				});
			}
			try {
				Thread.sleep(1000 * public_data.PERF_GUI_BASE_INTERVAL);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}		
	}

	@Override
	public void mouseClicked(MouseEvent arg0) {
		// TODO Auto-generated method stub
		if (arg0.getSource().equals(icon_mode)){
			String title = new String("Client mode switch confirmation");
			StringBuilder message = new StringBuilder("");
			String current_mode = new String("");
			current_mode = client_info.get_client_machine_data().getOrDefault("unattended", public_data.DEF_UNATTENDED_MODE);
			if (current_mode.equals("0")){ //attended mode
				message.append("Client running in 'Attended' mode, Would you like to switch to 'Unattended' mode?" + line_separator);
				message.append("In 'Unattended' mode, Client will:" + line_separator);
				message.append("    1. Disable message popup." + line_separator);
				message.append("    2. Enable 'Work Space' auto cleanup." + line_separator);
				message.append("    3. Enable Client self update." + line_separator);
				int user_input = JOptionPane.showConfirmDialog(main_view, message, title, JOptionPane.YES_NO_OPTION);
				if (user_input == 0){ //yes means 0
					client_info.update_client_machine_data("unattended", "1");
					switch_info.set_client_updated();
				}
			} else {
				message.append("Client running in 'Unattended' mode, Would you like to switch to 'Attended' mode?" + line_separator);
				message.append("In 'Attended' mode, Client will:" + line_separator);
				message.append("    1. Enable message popup." + line_separator);
				message.append("    2. Disable 'Work Space' auto cleanup, User need to do it manually." + line_separator);
				message.append("    3. Disable Client self update, User need to do it manually." + line_separator);				
				int user_input = JOptionPane.showConfirmDialog(main_view, message, title, JOptionPane.YES_NO_OPTION);
				if (user_input == 0){ //yes means 0
					client_info.update_client_machine_data("unattended", "0");
					switch_info.set_client_updated();
				}	
			}
		}
		if (arg0.getSource().equals(icon_belong)){
			String title = new String("Client mode switch confirmation");
			StringBuilder message = new StringBuilder("");
			String current_mode = new String("");
			current_mode = client_info.get_client_machine_data().getOrDefault("private", public_data.DEF_MACHINE_PRIVATE);
			if (current_mode.equals("1")){ //Private mode
				message.append("Client running in 'Private' mode, Would you like to switch to 'Public' mode?" + line_separator);
				message.append("In 'Public' mode: Client accepts all matched jobs." + line_separator);
				int user_input = JOptionPane.showConfirmDialog(null, message, title, JOptionPane.YES_NO_OPTION);
				if (user_input == 0){ //yes means 0
					client_info.update_client_machine_data("private", "0");
					switch_info.set_client_updated();
				}
			} else {
				message.append("Client running in 'Public' mode, Would you like to switch to 'Private' mode?" + line_separator);
				message.append("In 'Private' mode: Client only takes assigned jobs." + line_separator);
				int user_input = JOptionPane.showConfirmDialog(null, message, title, JOptionPane.YES_NO_OPTION);
				if (user_input == 0){ //yes means 0
					client_info.update_client_machine_data("private", "1");
					switch_info.set_client_updated();
				}	
			}
		}		
	}

	@Override
	public void mouseEntered(MouseEvent arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void mouseExited(MouseEvent arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void mousePressed(MouseEvent arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void mouseReleased(MouseEvent arg0) {
		// TODO Auto-generated method stub
		
	}
}