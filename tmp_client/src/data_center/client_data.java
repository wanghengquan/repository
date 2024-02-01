/*
 * File: tube_data.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package data_center;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import utility_funcs.data_check;
import utility_funcs.deep_clone;

public class client_data {
	// public property
	// {queue_name: {case_id_or_title: {}}}
	// protected property
	// private property
	private static final Logger CLIENT_DATA_LOGGER = LogManager.getLogger(client_data.class.getName());
	private ReadWriteLock rw_lock = new ReentrantReadWriteLock();
	private HashMap<String, HashMap<String, String>> client_hash = new HashMap<String, HashMap<String, String>>();
	private HashMap<String, Integer> max_soft_insts = new HashMap<String, Integer>();
	private HashMap<String, Integer> use_soft_insts = new HashMap<String, Integer>();
	private float registered_memory = 0.0f;
	private float registered_space = 0.0f;
	/*
	 * private String task_assign_mode = public_data.DEF_TASK_ASSIGN_MODE;
	 * private String thread_work_mode = public_data.DEF_MAX_THREAD_MODE;
	 * private int pool_current_size =
	 * Integer.parseInt(public_data.DEF_POOL_CURRENT_SIZE);//dup with pool_data,
	 * for data dump private String client_link_mode =
	 * public_data.DEF_CLIENT_LINK_MODE; private String client_work_space =
	 * public_data.DEF_WORK_SPACE; private String client_save_space =
	 * public_data.DEF_SAVE_SPACE;
	 */
	// public function
	// protected function
	// private function

	public client_data() {

	}

	public HashMap<String, String> get_database_info() {
		HashMap<String, String> result = new HashMap<String, String>();
		rw_lock.readLock().lock();
		try {
			result.put("client_hash", client_hash.toString());
			result.put("max_soft_insts", max_soft_insts.toString());
			result.put("use_soft_insts", use_soft_insts.toString());
			result.put("registered_memory", String.valueOf(registered_memory) + "(G)");
			result.put("registered_space", String.valueOf(registered_space) + "(G)");
		} finally {
			rw_lock.readLock().unlock();
		}
		return result;
	}
	
	public HashMap<String, String> console_database_update(
			HashMap<String, String> update_data
			) {
		rw_lock.writeLock().lock();
		HashMap<String, String> update_status = new HashMap<String, String>();
		try {
			Iterator<String> update_it = update_data.keySet().iterator();
			while (update_it.hasNext()) {
				String obj_name = update_it.next();
				String optin_value = update_data.get(obj_name);
				switch(obj_name) {
				case "client_hash":
					if (data_check.str_regexp_check(optin_value, ".+\\..+=.+" )){
						String optin_str = new String(optin_value.split("\\s*=\\s*")[0]);
						String value_str = new String(optin_value.split("\\s*=\\s*")[1]);
						String optin_str1 = new String(optin_str.split("\\s*\\.\\s*", 2)[0]);
						String optin_str2 = new String(optin_str.split("\\s*\\.\\s*", 2)[1]);
						if(client_hash.containsKey(optin_str1)) {
							HashMap<String, String> option_hash = client_hash.get(optin_str1);
							option_hash.put(optin_str2, value_str);
							update_status.put(obj_name, "PASS");
						} else {
							update_status.put(obj_name, "FAIL, " + optin_str1 + " doesn't exists.");
						}
					} else {
						update_status.put(obj_name, "FAIL, Wrong input string format, should be: sss.sss=sss");
					}
					break;
				case "use_soft_insts":
					if (data_check.str_regexp_check(optin_value, ".+=\\d+" )){
						String optin_str = new String(optin_value.split("\\s*=\\s*")[0]);
						String value_str = new String(optin_value.split("\\s*=\\s*")[1]);
						use_soft_insts.put(optin_str, Integer.valueOf(value_str));
						update_status.put(obj_name, "PASS");
					} else {
						update_status.put(obj_name, "FAIL, Wrong input string format, should be: sss=d");
					}
					break;					
				case "registered_memory":	
					if (data_check.str_regexp_check(optin_value, "\\d+\\.\\d+" )){
						String value_str = new String(optin_value.trim());
						registered_memory = Float.valueOf(value_str);
						update_status.put(obj_name, "PASS");
					} else {
						update_status.put(obj_name, "FAIL, Wrong input string format, should be: dd.dd");
					}
					break;
				case "registered_space":	
					if (data_check.str_regexp_check(optin_value, "\\d+\\.\\d+" )){
						String value_str = new String(optin_value.trim());
						registered_space = Float.valueOf(value_str);
						update_status.put(obj_name, "PASS");
					} else {
						update_status.put(obj_name, "FAIL, Wrong input string format, should be: dd.dd");
					}
					break;	
				default:
					update_status.put(obj_name, "FAIL, " + obj_name + " console update not supported yet.");
				}
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return update_status;
	}

	public HashMap<String, HashMap<String, String>> get_client_data() {
		rw_lock.readLock().lock();
		HashMap<String, HashMap<String, String>> temp = new HashMap<String, HashMap<String, String>>();
		try {
			temp.putAll(client_hash);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void set_client_data(HashMap<String, HashMap<String, String>> update_data) {
		rw_lock.writeLock().lock();
		try {
			client_hash.clear();
			client_hash.putAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public HashMap<String, String> get_client_system_data() {
		rw_lock.readLock().lock();
		HashMap<String, String> temp = new HashMap<String, String>();
		try {
			if (client_hash.containsKey("System")){
				temp.putAll(client_hash.get("System"));
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_client_system_data(HashMap<String, String> update_data) {
		rw_lock.writeLock().lock();
		try {
			if(client_hash.containsKey("System")){
				client_hash.remove("System");
			}
			client_hash.put("System", update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_client_system_data(HashMap<String, String> update_data) {
		rw_lock.writeLock().lock();
		try {
			HashMap<String, String> system_data = new HashMap<String, String>();
			if(client_hash.containsKey("System")){
				system_data.putAll(client_hash.get("System"));
			}
			system_data.putAll(update_data);
			client_hash.put("System", system_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public HashMap<String, String> get_client_machine_data() {
		rw_lock.readLock().lock();
		HashMap<String, String> temp = new HashMap<String, String>();
		try {
			if (client_hash.containsKey("Machine")){
				temp.putAll(client_hash.get("Machine"));
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_client_machine_data(HashMap<String, String> update_data) {
		rw_lock.writeLock().lock();
		try {
			if(client_hash.containsKey("Machine")){
				client_hash.remove("Machine");
			}
			client_hash.put("Machine", update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_client_machine_data(HashMap<String, String> update_data) {
		rw_lock.writeLock().lock();
		try {
			HashMap<String, String> machine_data = new HashMap<String, String>();
			if(client_hash.containsKey("Machine")){
				machine_data.putAll(client_hash.get("Machine"));
			}
			machine_data.putAll(update_data);
			client_hash.put("Machine", machine_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_client_machine_data(String key, String value) {
		rw_lock.writeLock().lock();
		try {
			HashMap<String, String> machine_data = new HashMap<String, String>();
			if(client_hash.containsKey("Machine")){
				machine_data.putAll(client_hash.get("Machine"));
			}
			machine_data.put(key, value);
			client_hash.put("Machine", machine_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public HashMap<String, String> get_client_tools_data() {
		rw_lock.readLock().lock();
		HashMap<String, String> temp = new HashMap<String, String>();
		try {
			if (client_hash.containsKey("tools")){
				temp.putAll(client_hash.get("tools"));
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_client_tools_data(HashMap<String, String> update_data) {
		rw_lock.writeLock().lock();
		try {
			if(client_hash.containsKey("tools")){
				client_hash.remove("tools");
			}
			client_hash.put("tools", update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_client_tools_data(HashMap<String, String> update_data) {
		rw_lock.writeLock().lock();
		try {
			HashMap<String, String> tools_data = new HashMap<String, String>();
			if(client_hash.containsKey("tools")){
				tools_data.putAll(client_hash.get("tools"));
			}
			tools_data.putAll(update_data);
			client_hash.put("tools", tools_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public HashMap<String, String> get_client_preference_data() {
		rw_lock.readLock().lock();
		HashMap<String, String> temp = new HashMap<String, String>();
		try {
			if (client_hash.containsKey("preference")){
				temp.putAll(client_hash.get("preference"));
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_client_preference_data(HashMap<String, String> update_data) {
		rw_lock.writeLock().lock();
		try {
			if(client_hash.containsKey("preference")){
				client_hash.remove("preference");
			}
			client_hash.put("preference", update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_client_preference_data(HashMap<String, String> update_data) {
		rw_lock.writeLock().lock();
		try {
			HashMap<String, String> preference_data = new HashMap<String, String>();
			if(client_hash.containsKey("preference")){
				preference_data.putAll(client_hash.get("preference"));
			}
			preference_data.putAll(update_data);
			client_hash.put("preference", preference_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public HashMap<String, String> get_client_software_data() {
		rw_lock.readLock().lock();
		HashMap<String, String> temp = new HashMap<String, String>();
		int counter = 1;
		String id_name = new String("");
		try {
			Iterator<String> section = client_hash.keySet().iterator();
			while(section.hasNext()){
				String section_name = section.next();
				if (section_name.equals("System") || section_name.equals("CoreScript") || section_name.equals("Machine") || section_name.equals("preference")){
					continue;
				}
				id_name = "SW" + String.valueOf(counter);
				temp.put(id_name, section_name);
				counter += 1;
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public HashMap<String, String> get_client_software_data(String software) {
		rw_lock.readLock().lock();
		HashMap<String, String> temp = new HashMap<String, String>();
		try {
			Iterator<String> section = client_hash.keySet().iterator();
			while(section.hasNext()){
				String section_name = section.next();
				if (section_name.equalsIgnoreCase(software)){
					temp.putAll(client_hash.get(section_name));
					break;
				}
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}	
	
	public HashMap<String, String> get_client_corescript_data() {
		rw_lock.readLock().lock();
		HashMap<String, String> temp = new HashMap<String, String>();
		try {
			if (client_hash.containsKey("CoreScript")){
				temp.putAll(client_hash.get("CoreScript"));
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_client_corescript_data(HashMap<String, String> update_data) {
		rw_lock.writeLock().lock();
		try {
			if(client_hash.containsKey("CoreScript")){
				client_hash.remove("CoreScript");
			}
			client_hash.put("CoreScript", update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_client_corescript_data(HashMap<String, String> update_data) {
		rw_lock.writeLock().lock();
		try {
			HashMap<String, String> corescript_data = new HashMap<String, String>();
			if(client_hash.containsKey("CoreScript")){
				corescript_data.putAll(client_hash.get("CoreScript"));
			}
			corescript_data.putAll(update_data);
			client_hash.put("CoreScript", corescript_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public void update_client_corescript_data(String key, String value) {
		rw_lock.writeLock().lock();
		try {
			HashMap<String, String> corescript_data = new HashMap<String, String>();
			if(client_hash.containsKey("CoreScript")){
				corescript_data.putAll(client_hash.get("CoreScript"));
			}
			corescript_data.put(key, value);
			client_hash.put("CoreScript", corescript_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_software_data(String section, HashMap<String, String> update_data) {
		rw_lock.writeLock().lock();
		try {
			if(client_hash.containsKey(section)){
				client_hash.remove(section);
			}
			client_hash.put(section, update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public void update_system_data(HashMap<String, String> update_data){
		rw_lock.writeLock().lock();
		try {
			HashMap<String, String> system_data =  client_hash.get("System");
			system_data.putAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_scan_build_data(HashMap<String, HashMap<String, String>> update_data){
		rw_lock.writeLock().lock();
		try {
			HashMap<String, HashMap<String, String>> temp_data = new HashMap<String, HashMap<String, String>>();
			temp_data.putAll(deep_clone.clone(client_hash));
			Iterator<String> section_it = temp_data.keySet().iterator();
			while(section_it.hasNext()){
				String section = section_it.next();
				if (!update_data.containsKey(section)){
					continue;
				}
				Iterator<String> option_it = temp_data.get(section).keySet().iterator();
				while(option_it.hasNext()){
					String option = option_it.next();
					if (option.startsWith("sd_") || option.startsWith("sc_")){
						client_hash.get(section).remove(option);
					}
				}
				client_hash.get(section).putAll(update_data.get(section));
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_scan_build_data(
			String section, 
			HashMap<String, String> update_data
			) {
		rw_lock.writeLock().lock();
		try {
			HashMap<String, String> temp_data = new HashMap<String, String>();
			temp_data.putAll(client_hash.get(section));
			Iterator<String> option_it = temp_data.keySet().iterator();
			while(option_it.hasNext()){
				String option = option_it.next();
				if (option.startsWith("sd_") || option.startsWith("sc_")){
					client_hash.get(section).remove(option);
				}
			}
			client_hash.get(section).putAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void delete_software_build(String section, String build) {
		rw_lock.writeLock().lock();
		try {
			HashMap<String, String> software_data =  client_hash.get(section);
			software_data.remove(build);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public HashMap<String, Integer> get_max_soft_insts() {
		rw_lock.readLock().lock();
		HashMap<String, Integer> temp = new HashMap<String, Integer>();
		try {
			temp.putAll(max_soft_insts);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_max_soft_insts(HashMap<String, Integer> update_data) {
		rw_lock.writeLock().lock();
		try {
			max_soft_insts.clear();
			max_soft_insts.putAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public HashMap<String, Integer> get_used_soft_insts() {
		rw_lock.readLock().lock();
		HashMap<String, Integer> temp = new HashMap<String, Integer>();
		try {
			temp.putAll(use_soft_insts);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	// release usage for every software
	public Boolean release_used_soft_insts(
			List<String> sw_list
			) {
		rw_lock.writeLock().lock();
		Boolean release_result = Boolean.valueOf(true);
		try {
			if(sw_list != null && !sw_list.isEmpty()){
				HashMap<String, Integer> future_soft_insts = new HashMap<String, Integer>();
				future_soft_insts.putAll(use_soft_insts);
				Iterator<String> sw_it = sw_list.iterator();
				while (sw_it.hasNext()) {
					String sw_name = sw_it.next();
					Integer sw_insts = future_soft_insts.get(sw_name);
					sw_insts = sw_insts - 1;
					if (sw_insts < 0) {
						sw_insts = 0;
						release_result = false;
						CLIENT_DATA_LOGGER.warn("Release warnning found for " + sw_name);
					}
					future_soft_insts.put(sw_name, sw_insts);
				}
				use_soft_insts.putAll(future_soft_insts);				
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return release_result;
	}
	
	// release usage for every software
	public Boolean release_used_soft_insts(
			HashMap<String, String> release_data,
			Boolean cmds_parallel
			) {
		rw_lock.writeLock().lock();
		Boolean release_result = Boolean.valueOf(true);
		try {
			if(release_data != null && !release_data.isEmpty()){
				HashMap<String, Integer> future_soft_insts = new HashMap<String, Integer>();
				future_soft_insts.putAll(use_soft_insts);
				Iterator<String> release_data_it = release_data.keySet().iterator();
				while (release_data_it.hasNext()) {
					String sw_name = release_data_it.next();
					Integer sw_insts = future_soft_insts.get(sw_name);
					String sw_builds = release_data.get(sw_name);
					ArrayList<String> sw_build_list = new ArrayList<String>();		
					if (sw_builds.contains(",")){
						sw_build_list.addAll(Arrays.asList(sw_builds.split("\\s*,\\s*")));
					} else if (sw_builds.contains(";")){
						sw_build_list.addAll(Arrays.asList(sw_builds.split("\\s*;\\s*")));
					} else{
						sw_build_list.add(sw_builds);
					}
					if (cmds_parallel) {
						sw_insts = sw_insts - sw_build_list.size();
					} else {
						sw_insts = sw_insts - 1;
					}
					if (sw_insts < 0) {
						sw_insts = 0;
						release_result = false;
						CLIENT_DATA_LOGGER.warn("Release warnning found for " + sw_name);
					}
					future_soft_insts.put(sw_name, sw_insts);
				}
				use_soft_insts.putAll(future_soft_insts);				
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return release_result;
	}

	public Boolean release_used_soft_insts_multi(
			HashMap<String, Integer> release_data
			) {
		rw_lock.writeLock().lock();
		Boolean release_result = Boolean.valueOf(true);
		try {
			HashMap<String, Integer> future_soft_insts = new HashMap<String, Integer>();
			future_soft_insts.putAll(use_soft_insts);
			Set<String> future_keys_set = future_soft_insts.keySet();
			Iterator<String> future_keys_it = future_keys_set.iterator();
			while (future_keys_it.hasNext()) {
				String sw_name = future_keys_it.next();
				Integer sw_insts = future_soft_insts.get(sw_name);
				sw_insts = sw_insts - release_data.get(sw_name);
				if (sw_insts < 0) {
					sw_insts = 0;
					release_result = false;
					CLIENT_DATA_LOGGER.warn("Release warnning found for " + sw_name);
				}
				future_soft_insts.put(sw_name, sw_insts);
			}
			use_soft_insts.putAll(future_soft_insts);
		} finally {
			rw_lock.writeLock().unlock();
		}
		return release_result;
	}

	public Boolean software_available_check(
			HashMap<String, String> request_data,
			Boolean cmds_parallel
			) {
		rw_lock.writeLock().lock();
		Boolean check_result = Boolean.valueOf(true);
		try {
			if(request_data != null && !request_data.isEmpty()){
				HashMap<String, Integer> current_soft_insts = new HashMap<String, Integer>();
				current_soft_insts.putAll(use_soft_insts);
				Iterator<String> request_data_it = request_data.keySet().iterator();
				while (request_data_it.hasNext()) {
					String sw_name = request_data_it.next();
					String sw_builds = request_data.get(sw_name);
					ArrayList<String> sw_build_list = new ArrayList<String>();		
					if (sw_builds.contains(",")){
						sw_build_list.addAll(Arrays.asList(sw_builds.split("\\s*,\\s*")));
					} else if (sw_builds.contains(";")){
						sw_build_list.addAll(Arrays.asList(sw_builds.split("\\s*;\\s*")));
					} else{
						sw_build_list.add(sw_builds);
					}
					Integer sw_insts = Integer.valueOf(0);
					if (current_soft_insts.containsKey(sw_name)) {
						sw_insts = current_soft_insts.get(sw_name);
					}
					Integer sw_max_insts = max_soft_insts.get(sw_name);
					if (cmds_parallel) {
						sw_insts = sw_insts + sw_build_list.size();
					} else {
						sw_insts = sw_insts + 1;
					}
					if (sw_insts > sw_max_insts) {
						check_result = false;
						break;
					}
				}				
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return check_result;
	}
	
	public Boolean booking_used_soft_insts(
			List<String> sw_list
			) {
		rw_lock.writeLock().lock();
		Boolean booking_result = Boolean.valueOf(true);
		try {
			if(sw_list != null && !sw_list.isEmpty()){
				HashMap<String, Integer> future_soft_insts = new HashMap<String, Integer>();
				future_soft_insts.putAll(use_soft_insts);
				Iterator<String> sw_it = sw_list.iterator();
				while (sw_it.hasNext()) {
					String sw_name = sw_it.next();
					Integer sw_insts = Integer.valueOf(0);
					if (future_soft_insts.containsKey(sw_name)) {
						sw_insts = future_soft_insts.get(sw_name);
					}
					sw_insts = sw_insts + 1;
					Integer sw_max_insts = max_soft_insts.get(sw_name);
					if (sw_insts > sw_max_insts) {
						booking_result = false;
						break;
					} else {
						future_soft_insts.put(sw_name, sw_insts);
					}
				}
				if (booking_result) {
					use_soft_insts.putAll(future_soft_insts);
				}				
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return booking_result;
	}
	
	public Boolean booking_used_soft_insts(
			HashMap<String, String> booking_data,
			Boolean cmds_parallel
			) {
		rw_lock.writeLock().lock();
		Boolean booking_result = Boolean.valueOf(true);
		try {
			if(booking_data != null && !booking_data.isEmpty()){
				HashMap<String, Integer> future_soft_insts = new HashMap<String, Integer>();
				future_soft_insts.putAll(use_soft_insts);
				Iterator<String> booking_data_it = booking_data.keySet().iterator();
				while (booking_data_it.hasNext()) {
					String sw_name = booking_data_it.next();
					String sw_builds = booking_data.get(sw_name);
					ArrayList<String> sw_build_list = new ArrayList<String>();		
					if (sw_builds.contains(",")){
						sw_build_list.addAll(Arrays.asList(sw_builds.split("\\s*,\\s*")));
					} else if (sw_builds.contains(";")){
						sw_build_list.addAll(Arrays.asList(sw_builds.split("\\s*;\\s*")));
					} else{
						sw_build_list.add(sw_builds);
					}
					Integer sw_insts = Integer.valueOf(0);
					if (future_soft_insts.containsKey(sw_name)) {
						sw_insts = future_soft_insts.get(sw_name);
					}
					Integer sw_max_insts = max_soft_insts.get(sw_name);
					if (cmds_parallel) {
						sw_insts = sw_insts + sw_build_list.size();
					} else {
						sw_insts = sw_insts + 1;
					}
					if (sw_insts > sw_max_insts) {
						booking_result = false;
						break;
					} else {
						future_soft_insts.put(sw_name, sw_insts);
					}
				}
				if (booking_result) {
					use_soft_insts.putAll(future_soft_insts);
				}				
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return booking_result;
	}

	public Boolean booking_used_soft_insts_multi(HashMap<String, Integer> booking_data) {
		rw_lock.writeLock().lock();
		Boolean booking_result = Boolean.valueOf(true);
		try {
			if(booking_data != null && !booking_data.isEmpty()){
				HashMap<String, Integer> future_soft_insts = new HashMap<String, Integer>();
				future_soft_insts.putAll(use_soft_insts);
				Set<String> future_keys_set = future_soft_insts.keySet();
				Iterator<String> future_keys_it = future_keys_set.iterator();
				while (future_keys_it.hasNext()) {
					String sw_name = future_keys_it.next();
					Integer sw_insts = future_soft_insts.get(sw_name);
					Integer sw_max_insts = max_soft_insts.get(sw_name);
					sw_insts = sw_insts + booking_data.get(sw_name);
					if (sw_insts > sw_max_insts) {
						booking_result = false;
						break;
					} else {
						future_soft_insts.put(sw_name, sw_insts);
					}
				}
				if (booking_result) {
					use_soft_insts.putAll(future_soft_insts);
				}				
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return booking_result;
	}

	public HashMap<String, Integer> get_available_software_insts() {
		rw_lock.writeLock().lock();
		HashMap<String, Integer> available_software_insts = new HashMap<String, Integer>();
		try {
			Set<String> soft_keys_set = max_soft_insts.keySet();
			Iterator<String> soft_keys_it = soft_keys_set.iterator();
			while (soft_keys_it.hasNext()) {
				String sw_name = soft_keys_it.next();
				Integer sw_max_insts = max_soft_insts.get(sw_name);
				Integer sw_use_insts = Integer.valueOf(0);
				Integer sw_free_insts = Integer.valueOf(0);
				if (use_soft_insts.containsKey(sw_name)) {
					sw_use_insts = use_soft_insts.get(sw_name);
				}
				sw_free_insts = sw_max_insts - sw_use_insts;
				available_software_insts.put(sw_name, sw_free_insts);
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
		return available_software_insts;
	}

	public void set_use_soft_insts(HashMap<String, Integer> update_data) {
		rw_lock.writeLock().lock();
		try {
			use_soft_insts.clear();
			use_soft_insts.putAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	//test_waiter registered_memory
	public void clean_registered_memory() {
		rw_lock.writeLock().lock();
		try {
			registered_memory = 0.0f;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public float get_registered_memory() {
		rw_lock.readLock().lock();
		float temp = 0.0f;
		try {
			temp = registered_memory;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void decrease_registered_memory(
			float value
			) {
		rw_lock.writeLock().lock();
		float new_value = 0.0f;
		try {
			new_value = registered_memory - value;
			if (new_value < 0) {
				registered_memory = 0.0f;
			} else {
				registered_memory = new_value;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void increase_registered_memory(
			float value
			) {
		rw_lock.writeLock().lock();
		try {
			registered_memory = registered_memory + value;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	//test_waiter registered_space
	public void clean_registered_space() {
		rw_lock.writeLock().lock();
		try {
			registered_space = 0.0f;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public float get_registered_space() {
		rw_lock.readLock().lock();
		float temp = 0.0f;
		try {
			temp = registered_space;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void decrease_registered_space(
			float value
			) {
		rw_lock.writeLock().lock();
		float new_value = 0.0f;
		try {
			new_value = registered_space - value;
			if (new_value < 0) {
				registered_space = 0.0f;
			} else {
				registered_space = new_value;
			}
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void increase_registered_space(
			float value
			) {
		rw_lock.writeLock().lock();
		try {
			registered_space = registered_space + value;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		CLIENT_DATA_LOGGER.warn("Share data");
	}
}