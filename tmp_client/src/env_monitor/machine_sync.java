/*
 * File: system_info.java
 * Description: run system command line
 * Author: Jason.Wang
 * Date:2017/02/16
 * Modifier:
 * Date:
 * Description:
 */

package env_monitor;

import java.io.File;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.exit_enum;
import data_center.public_data;
import data_center.switch_data;
import utility_funcs.system_cmd;
import utility_funcs.linux_info;

/*
 * This class used to get the basic information of the client.
 * return machine_hash:
 * 		System	:	os		=	type_arch
 * 					os_type	=	windows/linux
 * 					os_arch	=	32b/64b
 * 					space	=	xxG
 * 					cpu		=	xx%
 * 					mem		=	xx%
 * 		Machine	:	terminal=	xxx
 * 					ip		=	xxx 	
 */
public class machine_sync extends Thread {
	// public property
	// protected property
	public static ConcurrentHashMap<String, HashMap<String, String>> machine_hash = new ConcurrentHashMap<String, HashMap<String, String>>();
	// private property
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread machine_thread;
	//private String line_separator = System.getProperty("line.separator");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;
	private static final Logger INFO_LOGGER = LogManager.getLogger(machine_sync.class.getName());
	private switch_data switch_info;

	// public function update data every interval seconds
	public machine_sync(int base_interval) {
		this.base_interval = base_interval;
	}

	// public function default update data every 5 seconds
	public machine_sync(switch_data switch_info) {
		this.switch_info = switch_info;
	}

	// protected function
	// private function
	private String get_start_time(){
		String start_time = new String();
		start_time = String.valueOf(System.currentTimeMillis() / 1000);
		return start_time;
	}
	
	public String get_os_type() {
		String os = System.getProperty("os.name").toLowerCase();
		String os_type = new String();
		if (os.contains("windows")) {
			os_type = "windows";
		} else if (os.contains("linux")) {
			os_type = "linux";
		} else {
			os_type = "unknown";
		}
		return os_type;
	}

	private String get_os() {
		String run_cmd = "python " + public_data.TOOLS_OS_NAME;
		String os_name = new String();
		try {
			ArrayList<String> excute_retruns = system_cmd.run(run_cmd);
			os_name = excute_retruns.get(1);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			INFO_LOGGER.warn("Cannot resolve Operation System name");
			os_name = "unknown";
		}
		return os_name;
	}

	private String get_disk_left() {
		File file = new File("..");
		String disk_left = new String();
		// long total_space = file.getTotalSpace();
		long free_space = file.getFreeSpace();
		// long used_space = total_space - free_space;
		disk_left = free_space / 1024 / 1024 / 1024 + "";
		return disk_left;
	}

	private String get_cpu_usage() {
		String systemType = System.getProperties().getProperty("os.name");
		String cpu_usage = new String();
		if (systemType.contains("Windows")) {
			String run_cmd = "python " + public_data.TOOLS_GET_CPU;
			try {
				ArrayList<String> excute_retruns = system_cmd.run(run_cmd);
				cpu_usage = excute_retruns.get(1);
				int cpu_used_int = Integer.parseInt(cpu_usage);
				cpu_usage = String.valueOf(cpu_used_int);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
				INFO_LOGGER.warn("Cannot resolve Operation System name");
				cpu_usage = "NA";
			}
			return cpu_usage;
		} else {
			int cpu_usage_int = linux_info.cpu_usage(5);
			return String.valueOf(cpu_usage_int);
		}
	}

	private String get_mem_usage() {
		String systemType = System.getProperties().getProperty("os.name");
		String mem_usage = new String();
		if (systemType.contains("Windows")) {
			String run_cmd = "python " + public_data.TOOLS_GET_MEM;
			try {
				ArrayList<String> excute_retruns = system_cmd.run(run_cmd);
				mem_usage = excute_retruns.get(1);
				int mem_used_int = Integer.parseInt(mem_usage);
				mem_usage = String.valueOf(mem_used_int);				
			} catch (Exception e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
				INFO_LOGGER.warn("Cannot resolve Operation System name");
				mem_usage = "NA";
			}
			return mem_usage;
		} else {
			int mem_usage_int = linux_info.memory_usage();
			return String.valueOf(mem_usage_int);
		}
	}

	private String get_host_name() {
		InetAddress addr = null;
		String host_name = "";
		try {
			addr = InetAddress.getLocalHost();
			host_name = addr.getHostName().toString();
		} catch (Exception e) {
			// e.printStackTrace();
			INFO_LOGGER.warn("Cannot resolve host name");
		}
		return host_name;
	}

	private String get_host_ip() {
		String host_ip = new String("NA");
		try {
			for (Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces(); interfaces
					.hasMoreElements();) {
				NetworkInterface networkInterface = interfaces.nextElement();
				if (networkInterface.isLoopback() || networkInterface.isVirtual() || !networkInterface.isUp()) {
					continue;
				}
				Enumeration<InetAddress> addresses = networkInterface.getInetAddresses();
				if (addresses.hasMoreElements()) {
					InetAddress ia = (InetAddress) addresses.nextElement();
					if (ia instanceof Inet6Address)
						continue;
					host_ip = ia.getHostAddress();
					break;
				}
			}
		} catch (Exception e) {
			// e.printStackTrace();
			INFO_LOGGER.warn("Cannot resolve host ip address");
			host_ip = "NA";
		}
		return host_ip;
	}

	/*
	 * update machine_hash: System : os = type_arch type = windows/linux arch =
	 * 32b/64b Machine : terminal= xxx ip = xxx
	 */
	private void update_static_data() {
		HashMap<String, String> system_data = new HashMap<String, String>();
		HashMap<String, String> machine_data = new HashMap<String, String>();
		String type = get_os_type();
		String arch = new String();
		String os = get_os();
		if (os.equalsIgnoreCase("unknown")) {
			// type = "NA";
			arch = "NA";
		} else {
			if(os.contains("_")){
				arch = os.split("_")[1];
			} else {
				arch = "NA";
			}
		}
		String terminal = get_host_name();
		String ip = get_host_ip();
		String start_time = get_start_time();
		system_data.put("os", os);
		system_data.put("os_type", type);
		system_data.put("os_arch", arch);
		machine_data.put("terminal", terminal);
		machine_data.put("ip", ip);
		machine_data.put("start_time", start_time);
		machine_hash.put("System", system_data);
		machine_hash.put("Machine", machine_data);
	}

	/*
	 * update machine_hash: System : space = xxG cpu = xx% mem = xx%
	 */
	private void update_dynamic_data() {
		HashMap<String, String> ori_data = machine_hash.get("System");
		HashMap<String, String> system_data = new HashMap<String, String>();
		String space = get_disk_left();
		String cpu = get_cpu_usage();
		String mem = get_mem_usage();
		system_data.putAll(ori_data);
		system_data.put("space", space);
		system_data.put("cpu", cpu);
		system_data.put("mem", mem);
		machine_hash.put("System", system_data);
	}

	public void run() {
		try {
			monitor_run();
		} catch (Exception run_exception) {
			run_exception.printStackTrace();	
			switch_info.set_client_stop_request(exit_enum.DUMP);
		}
	}

	private void monitor_run() {
		machine_thread = Thread.currentThread();
		// ============== All static job start from here ==============
		// initial 1 : update static machine data
		update_static_data();
		while (!stop_request) {
			if (wait_request) {
				try {
					synchronized (this) {
						this.wait();
					}
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} else {
				INFO_LOGGER.debug("machine_sync Thread running...");
				INFO_LOGGER.debug(machine_sync.machine_hash.toString());
			}
			// ============== All dynamic job start from here ==============
			// task 1 : update machine data
			update_dynamic_data();
			try {
				Thread.sleep(base_interval * 2 * 1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public void soft_stop() {
		stop_request = true;
	}

	public void hard_stop() {
		stop_request = true;
		if (machine_thread != null) {
			machine_thread.interrupt();
		}
	}

	public void wait_request() {
		wait_request = true;
	}

	public void wake_request() {
		wait_request = false;
		synchronized (this) {
			this.notify();
		}
	}

	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		machine_sync client_update = new machine_sync(1);
		client_update.start();
		System.out.println(client_update.get_start_time());
		System.exit(0);
		INFO_LOGGER.warn("thread start...");
		try {
			Thread.sleep(10 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(machine_sync.machine_hash.toString());
		client_update.wait_request();
		INFO_LOGGER.warn("thread wait...");
		try {
			Thread.sleep(10 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		INFO_LOGGER.warn("thread wake...");
		client_update.wake_request();
		System.out.println(machine_sync.machine_hash.toString());
		try {
			Thread.sleep(10 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		INFO_LOGGER.warn("thread stop...");
		client_update.soft_stop();
		try {
			Thread.sleep(10 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("Main finished");
	}
}