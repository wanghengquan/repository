/*
 * File: system_cmd.java
 * Description: run system command line
 * Author: Jason.Wang
 * Date:2017/02/15
 * Modifier:
 * Date:
 * Description:
 */
package utility_funcs;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.TreeMap;
import java.util.concurrent.Callable;
import java.util.concurrent.CountDownLatch;

//import utility_funcs.system_cmd;

public class system_call implements Callable<Object> {
	private String case_dir;
	private TreeMap<String, HashMap<String, List<String>>> launch_jobs;
	private Boolean cmd_parallel;
	private int timeout = 0;
	//private String line_separator = System.getProperty("line.separator");

	public system_call(
			TreeMap<String, HashMap<String, List<String>>> launch_jobs, 
			Boolean cmd_parallel,
			String case_dir, 
			int timeout
			) {
		this.launch_jobs = launch_jobs;
		this.cmd_parallel = cmd_parallel;
		this.case_dir = case_dir;
		this.timeout = timeout;
	}
	
	public Object call() {
		ArrayList<String> string_list = new ArrayList<>();
		CountDownLatch job_latch = new CountDownLatch(launch_jobs.size());
		Iterator<String> job_it = launch_jobs.keySet().iterator();
		while(job_it.hasNext()) {
			String job_title = job_it.next();
			List<String> cmd_str = launch_jobs.get(job_title).get("cmd");
			List<String> env_str = launch_jobs.get(job_title).get("env");
			HashMap<String, String> env_map = new HashMap<String, String>();
			for(String item : env_str) {
				if (!item.contains("=")) {
					continue;
				}
				String key = item.split("=", 2)[0];
				String value = item.split("=", 2)[1];
				env_map.put(key, value);
			}
			if (cmd_parallel) {
				ArrayList<String> result_parallel = new ArrayList<>();
				new Thread() {
					public void run() {
						result_parallel.add("LJ:" + job_title);
						try {
							result_parallel.addAll(system_cmd.run(cmd_str, env_map, case_dir, timeout));
						} catch (Exception e) {
							// TODO Auto-generated catch block
							result_parallel.add(">>>Run job failed:" + job_title);
						}
						job_latch.countDown();
						result_parallel.add("");
						synchronized (this.getClass()) {
							string_list.addAll(result_parallel);
						}
					}
				}.start();
			} else {
				ArrayList<String> result_serial = new ArrayList<>();
				result_serial.add("LJ:" + job_title);
				try {
					result_serial.addAll(system_cmd.run(cmd_str, env_map, case_dir, timeout));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					result_serial.add(">>>Run job failed:" + job_title);
				}
				result_serial.add("");
				string_list.addAll(result_serial);
			}
		}
		if(cmd_parallel) {
			try {
				job_latch.await();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				string_list.add(">>>InterruptedException for wait all parallel jobs.");
			}
		}
		return string_list;
	}
}
