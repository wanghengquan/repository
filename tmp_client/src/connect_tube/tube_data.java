/*
 * File: tube_data.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package connect_tube;

import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.exchange_data;

public class tube_data {
	// public property
	// {queue_name: {case_id_or_title: {}}}	
	// protected property
	// private property
	private Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> task_queues_data = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
	private static final Logger TUBE_LOGGER = LogManager.getLogger(tube_data.class.getName());
	// public function
	// protected function
	// private function
	private exchange_data share_data;
	private TreeMap<String, HashMap<String, HashMap<String, String>>> running_admin_queue = new TreeMap<String, HashMap<String, HashMap<String, String>>>(
			new Comparator<String>() {
				public int compare(String queue_name1, String queue_name2) {
					// x_x_time@runxxx_time :
					// priority:match/assign task:job_from@run_number
					int int_pri1 = 0, int_pri2 = 0;
					int int_id1 = 0, int_id2 = 0;
					try {
						int_pri1 = get_srting_int(queue_name1, "^(\\d+)@");
						int_pri2 = get_srting_int(queue_name2, "^(\\d+)@");
						int_id1 = get_srting_int(queue_name1, "run_(\\d+)_");
						int_id2 = get_srting_int(queue_name2, "run_(\\d+)_");
					} catch (Exception e) {
						return queue_name1.compareTo(queue_name2);
					}
					if (int_pri1 > int_pri2) {
						return 1;
					} else if (int_pri1 < int_pri2) {
						return -1;
					} else {
						if (int_id1 > int_id2) {
							return 1;
						} else if (int_id1 < int_id2) {
							return -1;
						} else {
							return queue_name1.compareTo(queue_name2);
						}
					}
				}
			});		
	private TreeMap<String, HashMap<String, HashMap<String, String>>> finished_admin_queue = new TreeMap<String, HashMap<String, HashMap<String, String>>>(
			new Comparator<String>() {
				public int compare(String queue_name1, String queue_name2) {
					// x_x_time@runxxx_time :
					// priority:match/assign task:job_from@run_number
					int int_pri1 = 0, int_pri2 = 0;
					int int_id1 = 0, int_id2 = 0;
					try {
						int_pri1 = get_srting_int(queue_name1, "^(\\d+)@");
						int_pri2 = get_srting_int(queue_name2, "^(\\d+)@");
						int_id1 = get_srting_int(queue_name1, "run_(\\d+)_");
						int_id2 = get_srting_int(queue_name2, "run_(\\d+)_");
					} catch (Exception e) {
						return queue_name1.compareTo(queue_name2);
					}
					if (int_pri1 > int_pri2) {
						return 1;
					} else if (int_pri1 < int_pri2) {
						return -1;
					} else {
						if (int_id1 > int_id2) {
							return 1;
						} else if (int_id1 < int_id2) {
							return -1;
						} else {
							return queue_name1.compareTo(queue_name2);
						}
					}
				}
			});	


	public tube_data(exchange_data share_data) {
		this.share_data = share_data;
	}

	//push test case into 
	public synchronized void push() {
		
	}
	
	private static int get_srting_int(String str, String patt) {
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
	/*
	 * main entry for test
	 */
	public static void main(String[] args) {

	}
}