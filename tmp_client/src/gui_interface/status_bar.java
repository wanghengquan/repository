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
import java.awt.GridLayout;
import java.util.HashMap;

import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.SwingUtilities;

import data_center.client_data;
import data_center.switch_data;
import flow_control.pool_data;

public class status_bar extends JPanel implements Runnable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private client_data client_info;
	private switch_data switch_info;
	private pool_data pool_info;
	JTextField jt_thread, jt_cpu, jt_mem;

	public status_bar(switch_data switch_info, client_data client_info, pool_data pool_info){
		this.pool_info = pool_info;
		this.switch_info = switch_info;
		this.client_info = client_info;
		this.setLayout(new BorderLayout());
		//container.add(new JTextField("Edit table and apply save:"), BorderLayout.NORTH);
		this.add(construct_thread_panel(), BorderLayout.WEST);
		this.add(construct_system_panel(), BorderLayout.EAST);	
	}
	
	private JPanel construct_thread_panel(){
		JPanel jp_thread = new JPanel(new GridLayout(1,2,10,5));
		JLabel jl_thread = new JLabel("Working Thread(s):");
		jt_thread = new JTextField();
		jt_thread.setEditable(false);
		jp_thread.add(jl_thread);
		jp_thread.add(jt_thread);
		return jp_thread;
	}
	
	private JPanel construct_system_panel(){
		JPanel jp_system = new JPanel(new GridLayout(1,5,5,5));
		JLabel jl_system = new JLabel("System Info:");
		jp_system.add(jl_system);
		//cpu info
		JLabel jl_cpu = new JLabel("CPU:");
		jl_cpu.setHorizontalAlignment(SwingConstants.RIGHT);
		jt_cpu = new JTextField();
		jt_cpu.setEnabled(false);
		JLabel jl_mem = new JLabel("MEM");
		jl_mem.setHorizontalAlignment(SwingConstants.RIGHT);
		jt_mem = new JTextField();
		jt_mem.setEnabled(false);
		jp_system.add(jl_cpu);
		jp_system.add(jt_cpu);
		jp_system.add(jl_mem);
		jp_system.add(jt_mem);
		return jp_system;
	}
	
	private void update_thread_data(){
		int max_thread = switch_info.get_current_max_thread();
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
	
	@Override
	public void run() {
		// TODO Auto-generated method stub
		while (true) {
			if (SwingUtilities.isEventDispatchThread()) {
				update_thread_data();
				update_system_data();
			} else {
				SwingUtilities.invokeLater(new Runnable(){
					@Override
					public void run() {
						// TODO Auto-generated method stub
						update_thread_data();
						update_system_data();
					}
				});
			}
			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}		
	}
}