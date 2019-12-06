/*
 * File: cmd_parser.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package top_runner.run_status;

import java.util.HashMap;
import java.util.Observable;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_link.link_server;
import connect_tube.task_data;
import connect_tube.tube_server;
import data_center.client_data;
import data_center.data_server;
import data_center.switch_data;
import flow_control.post_data;
import flow_control.hall_manager;
import flow_control.pool_data;
import gui_interface.view_data;
import gui_interface.view_server;
import top_runner.run_status.abstract_status;
import top_runner.run_status.initial_status;
import top_runner.run_status.maintain_status;
import top_runner.run_status.stop_status;
import top_runner.run_status.work_status;

public class client_status extends Observable  {
    public final abstract_status INITIAL = new initial_status(this);  
    public final abstract_status WORK = new work_status(this);  
    public final abstract_status MAINTAIN = new maintain_status(this);  
    public final abstract_status STOP = new stop_status(this);
	protected switch_data switch_info;
	protected client_data client_info;
	protected task_data task_info;
	protected view_data view_info;
	protected pool_data pool_info;
	protected HashMap<String, String> cmd_info;
	protected post_data post_info;
	protected view_server view_runner;
	protected tube_server tube_runner;
	protected data_server data_runner;
	protected hall_manager hall_runner;
	protected link_server task_server;
	protected link_server cmd_server;
	protected final Logger STATUS_LOGGER = LogManager.getLogger(client_status.class.getName());
    private abstract_status current_status = INITIAL; 
    
    public client_status(){
    	
    }
    
	public client_status(
			switch_data switch_info, 
			client_data client_info,
			task_data task_info,
			view_data view_info,
			pool_data pool_info,
			HashMap<String, String> cmd_info,
			post_data post_info,
			view_server view_runner,
			tube_server tube_runner,
			data_server data_runner,
			hall_manager hall_runner,
			link_server task_server,
			link_server cmd_server){
		this.switch_info = switch_info;
		this.client_info = client_info;
		this.task_info = task_info;
		this.view_info = view_info;
		this.pool_info = pool_info;
		this.cmd_info = cmd_info;
		this.post_info = post_info;
		this.view_runner = view_runner;
		this.tube_runner = tube_runner;
		this.data_runner = data_runner;
		this.hall_runner = hall_runner;
		this.task_server = task_server;
		this.cmd_server = cmd_server;
	}	
	
	public void set_current_status(abstract_status new_status) {  
        this.current_status = new_status;
        switch_info.set_client_run_state(current_status.get_current_status());
        setChanged();  
        notifyObservers();  
    } 

    public void to_work_status() { 
    	current_status.to_work(); 
    	switch_info.set_client_run_state(state_enum.work);
    }  

    public void to_maintain_status() {  
    	current_status.to_maintain(); 
    	switch_info.set_client_run_state(state_enum.maintain);
    } 
    
    public void to_stop_status() {  
    	current_status.to_stop(); 
    	switch_info.set_client_run_state(state_enum.stop);
    }
    
    public void do_state_things(){
    	current_status.do_state_things();
	}    
    
    public state_enum get_current_status() {  
    	return current_status.get_current_status();  
    }
 
	//=============================================================
	//public methods
    
    public static void main(String[] args){  
    	client_status client =new client_status();    
    	System.out.println(client.get_current_status().get_description()); 
    	try {
			Thread.sleep(1000 * 5);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	client.to_stop_status();          
    	System.out.println(client.get_current_status().get_description());
    }
}