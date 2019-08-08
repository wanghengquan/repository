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

import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

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
	
	public void update_scan_build_data(String section, HashMap<String, String> update_data) {
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

	// release 1 usage for every software
	public Boolean release_used_soft_insts(HashMap<String, String> release_data) {
		rw_lock.writeLock().lock();
		Boolean release_result = new Boolean(true);
		try {
			if(release_data != null && !release_data.isEmpty()){
				HashMap<String, Integer> future_soft_insts = new HashMap<String, Integer>();
				future_soft_insts.putAll(use_soft_insts);
				Set<String> release_data_set = release_data.keySet();
				Iterator<String> release_data_it = release_data_set.iterator();
				while (release_data_it.hasNext()) {
					String sw_name = release_data_it.next();
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

	public Boolean release_used_soft_insts_multi(HashMap<String, Integer> release_data) {
		rw_lock.writeLock().lock();
		Boolean release_result = new Boolean(true);
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

	// software name , build
	// booking 1 usage for every used software
	public Boolean booking_used_soft_insts(HashMap<String, String> booking_data) {
		rw_lock.writeLock().lock();
		Boolean booking_result = new Boolean(true);
		try {
			if(booking_data != null && !booking_data.isEmpty()){
				HashMap<String, Integer> future_soft_insts = new HashMap<String, Integer>();
				future_soft_insts.putAll(use_soft_insts);
				Set<String> booking_data_set = booking_data.keySet();
				Iterator<String> booking_data_it = booking_data_set.iterator();
				while (booking_data_it.hasNext()) {
					String sw_name = booking_data_it.next();
					Integer sw_insts = new Integer(0);
					if (future_soft_insts.containsKey(sw_name)) {
						sw_insts = future_soft_insts.get(sw_name);
					}
					Integer sw_max_insts = max_soft_insts.get(sw_name);
					sw_insts = sw_insts + 1; // booking 1 usage for every software
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
		Boolean booking_result = new Boolean(true);
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
				Integer sw_use_insts = new Integer(0);
				Integer sw_free_insts = new Integer(0);
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

	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		CLIENT_DATA_LOGGER.warn("Share data");
	}
}