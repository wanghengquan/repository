/*
 * File: cmd_parser.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package flow_control;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.local_tube;
import connect_tube.run_tube;
import connect_tube.task_data;
import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;

public class task_waiter extends Thread {
	// public property
	// protected property
	// private property
	private static final Logger WAITER_LOGGER = LogManager.getLogger(task_waiter.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private int waiter_index;
	private String waiter_status;
	private Thread waiter_thread;
	private pool_data pool_info;
	private task_data task_info;
	private client_data client_info;
	private switch_data switch_info;
	private String line_seprator = System.getProperty("line.separator");
	private int interval = public_data.PERF_THREAD_RUN_INTERVAL;
	// public function
	// protected function
	// private function

	public task_waiter(int waiter_index, pool_data pool_info, task_data task_info, client_data client_info,
			switch_data switch_info) {
		this.waiter_index = waiter_index;
		this.pool_info = pool_info;
		this.task_info = task_info;
		this.client_info = client_info;
		this.switch_info = switch_info;
	}

	protected int get_waiter_index() {
		return this.waiter_index;
	}

	protected String get_waiter_status() {
		return this.waiter_status;
	}

	protected Thread get_waiter_thread() {
		return waiter_thread;
	}
	
	private String get_right_task_queue() {
		String queue_name = new String();
		ArrayList<String> processing_queue_list = task_info.get_processing_admin_queue_list();
		ArrayList<String> runable_queue_list = get_runable_queue_list(processing_queue_list);
		int queue_list_size = runable_queue_list.size();
		int select_queue_index = 0;
		if (queue_list_size == 0) {
			return queue_name;
		}
		String queue_work_mode = switch_info.get_queue_work_mode();
		if (queue_work_mode.equalsIgnoreCase("serial")) {
			queue_name = get_highest_queue_name(runable_queue_list);
		} else if (queue_work_mode.equalsIgnoreCase("parallel")) {
			select_queue_index = (waiter_index + 1) % queue_list_size;
			if (select_queue_index == 0) {
				select_queue_index = queue_list_size;
			}
			queue_name = runable_queue_list.get(select_queue_index);
		} else {
			// auto mode run higher priority queue list
			ArrayList<String> higher_priority_queue_list = get_higher_priority_queue_list(
					runable_queue_list);
			int sub_queue_list_size = higher_priority_queue_list.size();
			select_queue_index = (waiter_index + 1) % sub_queue_list_size;
			if (select_queue_index == 0) {
				select_queue_index = sub_queue_list_size;
			}
			queue_name = higher_priority_queue_list.get(select_queue_index);
		}
		return queue_name;
	}

	//sorting the queue list based on current resource info
	//Machine and System have already sorted in capture level on Software need to rechecks
	private ArrayList<String> get_runable_queue_list(ArrayList<String> full_list){
		ArrayList<String> runable_queue_list = new ArrayList<String>();
		HashMap<String, Integer> available_software_insts = client_info.get_available_software_insts();
		for(String queue_name : full_list){
			HashMap<String, HashMap<String, String>> request_data = run_tube.captured_admin_queues.get(queue_name);
			if (!request_data.containsKey("Software")){
				runable_queue_list.add(queue_name);
				continue;
			}
			//with software request queue
			Boolean match_request = new Boolean(true);
			HashMap<String, String> sw_request_data = request_data.get("Software");
			Set<String> sw_request_set = sw_request_data.keySet();
			Iterator<String> sw_request_it = sw_request_set.iterator();
			while(sw_request_it.hasNext()){
				String sw_request_name = sw_request_it.next();
				if (!available_software_insts.containsKey(sw_request_name)){
					match_request = false;
					break;
				}
				int available_sw_number = available_software_insts.get(sw_request_name);
				if (available_sw_number < 1){
					match_request = false;
					break;
				}
			}
			if (match_request){
				runable_queue_list.add(queue_name);
			}
		}
		return runable_queue_list;
	}
	
	private ArrayList<String> get_higher_priority_queue_list(ArrayList<String> full_list) {
		ArrayList<String> higher_priority_queue_list = new ArrayList<String>();
		int highest_priority = get_highest_queue_priority(full_list);
		for (String queue_name : full_list) {
			int queue_priority = get_srting_int(queue_name, "^(\\d+)@");
			if (queue_priority == highest_priority){
				higher_priority_queue_list.add(queue_name);
			}
		}
		return higher_priority_queue_list;
	}

	private int get_highest_queue_priority(ArrayList<String> full_list) {
		int record_priority = 999;
		for (String queue_name : full_list) {
			int queue_priority = get_srting_int(queue_name, "^(\\d+)@");
			if (queue_priority < record_priority){
				record_priority = queue_priority;
			}
		}
		return record_priority;
	}

	private String get_highest_queue_name(ArrayList<String> full_list) {
		int record_priority = 999;
		String record_queue = new String();
		for (String queue_name : full_list) {
			int queue_priority = get_srting_int(queue_name, "^(\\d+)@");
			if (queue_priority < record_priority){
				record_priority = queue_priority;
				record_queue = queue_name;
			}
		}
		return record_queue;
	}
	
	private int get_srting_int(String str, String patt) {
		int i = 0;
		try {
			Pattern p = Pattern.compile(patt);
			Matcher m = p.matcher(str);
			if (m.find()) {
				i = Integer.valueOf(m.group(1));
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}
		return i;
	}

	private HashMap<String, HashMap<String, String>> get_task_case_data(String queue_name){
		Boolean local_queue = new Boolean(false);
		if (queue_name.contains("0@")){
			local_queue = true;
		}
		if (local_queue) {
			TreeMap<String, HashMap<String, HashMap<String, String>>> local_task_data = local_tube.local_task_queue_tube_map.get("queue_name");
			
		}
	}
	/*
	 * private get_task_case_data(){
	 * 
	 * }
	 * 
	 * private prepare_task_case(){
	 * 
	 * }
	 * 
	 * private launch_task_case(){
	 * 
	 * }
	 */
	public void run() {
		try {
			monitor_run();
		} catch (Exception run_exception) {
			run_exception.printStackTrace();
			System.exit(1);
		}
	}

	private void monitor_run() {
		waiter_thread = Thread.currentThread();
		while (!stop_request) {
			if (wait_request) {
				WAITER_LOGGER.warn("Waiter_" + String.valueOf(waiter_index) + " waiting...");
				try {
					synchronized (this) {
						this.wait();
					}
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} else {
				this.waiter_status = "work";
				WAITER_LOGGER.warn("Waiter_" + String.valueOf(waiter_index) + " running...");
			}
			try {
				Thread.sleep(interval * 1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			// ============== All job start from here ==============
			// Step 0 check available thread
			if (pool_info.get_available_thread() == 0){
				continue;
			}
			// Step 1 get working queue
			String queue_name = get_right_task_queue();
			if (queue_name == null){
				continue;
			}
			// Step 2 resource booking (thread, software usage)   
			// Please release if case not launched  !!!
			Boolean thread_booking = pool_info.booking_used_thread(1);
			if (!thread_booking) {
				continue;
			}
			//now we have booking thread, if software booking failed we need to release it also.
			HashMap<String, String> software_cost = run_tube.captured_admin_queues.get(queue_name).get("Software");
			Boolean software_booking = client_info.booking_use_soft_insts(software_cost);
			if (!software_booking){
				pool_info.release_used_thread(1);
				continue;
			}
			// step 3 get one test case
			HashMap<String, HashMap<String, String>> get_case = get_task_case_data();
			// Step 3 prepare case
			HashMap case_data = get_task_case_ready(queue_name);
		}
	}

	public void soft_stop() {
		stop_request = true;
		this.waiter_status = "stop";
	}

	public void hard_stop() {
		stop_request = true;
		if (waiter_thread != null) {
			waiter_thread.interrupt();
		}
		this.waiter_status = "stop";
	}

	public void wait_request() {
		this.waiter_status = "wait";
		wait_request = true;
	}

	public void wake_request() {
		this.waiter_status = "work";
		wait_request = false;
		synchronized (this) {
			this.notify();
		}
	}

	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		// pool_data pool_instance = new pool_data(10);
		// task_data task_data_instance = new task_data(null);

		task_waiter waiter = new task_waiter(0, null, null, null, null);
		waiter.start();
		try {
			Thread.sleep(5 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		waiter.wait_request();
		System.out.println(waiter.get_waiter_status());
		try {
			Thread.sleep(5 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		waiter.wake_request();
		System.out.println(waiter.get_waiter_status());
		try {
			Thread.sleep(5 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(waiter.get_waiter_status());
	}
}