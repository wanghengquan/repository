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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Observable;

import connect_tube.task_data;
import connect_tube.tube_server;
import data_center.client_data;
import data_center.data_server;
import data_center.switch_data;
import flow_control.export_data;
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
	protected view_server view_runner;
	protected tube_server tube_runner;
	protected data_server data_runner;
	protected hall_manager hall_runner;
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
			view_server view_runner,
			tube_server tube_runner,
			data_server data_runner,
			hall_manager hall_runner){
		this.switch_info = switch_info;
		this.client_info = client_info;
		this.task_info = task_info;
		this.view_info = view_info;
		this.pool_info = pool_info;
		this.cmd_info = cmd_info;
		this.view_runner = view_runner;
		this.tube_runner = tube_runner;
		this.data_runner = data_runner;
		this.hall_runner = hall_runner;
	}	
	
	public void set_current_status(abstract_status new_status) {  
        this.current_status = new_status;  
        setChanged();  
        notifyObservers();  
    } 

    public void to_work_status() {  
    	current_status.to_work(); 
    }  

    public void to_maintain_status() {  
    	current_status.to_maintain();  
    } 
    
    public void to_stop_status() {  
    	current_status.to_stop();  
    }
    
    public String get_current_status() {  
    	return current_status.get_current_status();  
    }
    
    public void dump_finished_data(){
    	//by default result waiter will dump finished data except:
    	//1) case number less than 20
    	//2) suite is watching
    	//so when client stopped we need dump these finished suite
    	ArrayList<String> finished_admin_queue_list = new ArrayList<String>();
    	finished_admin_queue_list.addAll(task_info.get_finished_admin_queue_list());
		for (String dump_queue : finished_admin_queue_list) {
			if (!task_info.get_processed_task_queues_map().containsKey(dump_queue)) {
				continue;// no queue data to dump (already dumped)
			}
			// dumping task queue
			Boolean admin_dump = export_data.export_disk_finished_admin_queue_data(dump_queue, client_info, task_info);
			Boolean task_dump = export_data.export_disk_finished_task_queue_data(dump_queue, client_info, task_info);
			if (admin_dump && task_dump) {
				task_info.remove_queue_from_processed_admin_queues_treemap(dump_queue);
				task_info.remove_queue_from_processed_task_queues_map(dump_queue);
			}
		}
    }
    
    public void dump_memory_data(){
		export_data.dump_disk_received_admin_data(client_info, task_info);
		export_data.dump_disk_processed_admin_data(client_info, task_info);
		export_data.dump_disk_received_task_data(client_info, task_info);
		export_data.dump_disk_processed_task_data(client_info, task_info);	
    }
    
    public static void main(String[] args){  
    	client_status client =new client_status();    
    	System.out.println(client.get_current_status()); 
    	try {
			Thread.sleep(1000 * 5);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	client.to_stop_status();          
    	System.out.println(client.get_current_status());
    }
}