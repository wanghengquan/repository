/*
 * File: client_state.java
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
import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;

import data_center.exit_enum;
import data_center.public_data;
import flow_control.export_data;

class stop_status extends abstract_status {
	
	public stop_status(client_status client) {
		super(client);
	}

	public void to_stop() {
		System.out.println(">>>Info: Go to stop");
		client.set_current_status(client.STOP);
	}

	public void to_work() {
		System.out.println(">>>Info: Go to work");
		client.set_current_status(client.WORK);
	}

	public void to_maintain() {
		System.out.println(">>>Info: Go to maintain");
		client.set_current_status(client.MAINTAIN);
	}
	
	public void do_state_things(){
		System.out.println(">>>Info: Run state things");
		report_processed_data();
		dump_finished_data();
		dump_memory_data();		
		try {
			Thread.sleep(public_data.PERF_THREAD_BASE_INTERVAL * 100);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
		final_stop_with_exit_state();		
	}
	
	//=============================================================
	//methods for locals	
	private void final_stop_with_exit_state(){
    	exit_enum exit_state = exit_enum.OTHERS;
    	for (exit_enum current_state: client.switch_info.get_client_stop_request().keySet()){
    		if(current_state.get_index() < exit_state.get_index()){
    			exit_state = current_state;
    		}
    	}
    	System.out.println(">>>Info: Client Exit Code:" + exit_state.get_index());
    	System.out.println(">>>Info: Client Exit Reason:" + exit_state.get_description());
    	System.exit(exit_state.get_index());
    }
	
	private void report_processed_data(){
    	//by default result waiter will dump finished data except:
    	//1) task not finished
    	ArrayList<String> reported_admin_queue_list = new ArrayList<String>();
    	reported_admin_queue_list.addAll(client.task_info.get_reported_admin_queue_list()); 
    	Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> processed_task_queues_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
    	processed_task_queues_map.putAll(client.task_info.get_processed_task_queues_map());
    	Iterator<String> queue_it = processed_task_queues_map.keySet().iterator();
    	while(queue_it.hasNext()){
    		String queue_name = queue_it.next();
    		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
    		queue_data.putAll(processed_task_queues_map.get(queue_name));
    		if (reported_admin_queue_list.contains(queue_name)){
    			continue;
    		}
    		export_data.export_disk_finished_task_queue_report(queue_name, client.client_info, client.task_info);
    	}
    }
    
	private void dump_finished_data(){
    	//by default result waiter will dump finished data except:
    	//1) case number less than 20
    	//2) suite is watching
    	//so when client stopped we need dump these finished suite
    	ArrayList<String> finished_admin_queue_list = new ArrayList<String>();
    	finished_admin_queue_list.addAll(client.task_info.get_finished_admin_queue_list());
		for (String dump_queue : finished_admin_queue_list) {
			if (!client.task_info.get_processed_task_queues_map().containsKey(dump_queue)) {
				continue;// no queue data to dump (already dumped)
			}
			// dumping task queue
			Boolean admin_dump = export_data.export_disk_finished_admin_queue_data(dump_queue, client.client_info, client.task_info);
			Boolean task_dump = export_data.export_disk_finished_task_queue_data(dump_queue, client.client_info, client.task_info);
			if (admin_dump && task_dump) {
				client.task_info.remove_queue_from_processed_admin_queues_treemap(dump_queue);
				client.task_info.remove_queue_from_processed_task_queues_map(dump_queue);
			}
		}
    }
    
	private void dump_memory_data(){
		export_data.dump_disk_received_admin_data(client.client_info, client.task_info);
		export_data.dump_disk_processed_admin_data(client.client_info, client.task_info);
		export_data.dump_disk_received_task_data(client.client_info, client.task_info);
		export_data.dump_disk_processed_task_data(client.client_info, client.task_info);	
    }	
	
}