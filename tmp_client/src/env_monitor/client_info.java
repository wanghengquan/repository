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
import java.io.IOException;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.public_data;
import utility_funcs.system_cmd;
import utility_funcs.linux_info;

/*
 * This class used to get the basic information of the client.
 * return client_hash:
 * 		System	:	os		=	type_arch
 * 					type	=	windows/linux
 * 					arch	=	32b/64b
 * 					space	=	xxG
 * 					cpu		=	xx%
 * 					mem		=	xx%
 * 		Machine	:	terminal=	xxx
 * 					ip		=	xxx 	
 */
public class client_info extends Thread {
	// public property
	// protected property
	public static ConcurrentHashMap<String, HashMap<String, String>> client_hash = new ConcurrentHashMap<String, HashMap<String, String>>();
	// private property
	public static Boolean data_updating = new Boolean(false);
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread info_thread;
	public int interval;
	private static final Logger INFO_LOGGER = LogManager.getLogger(client_info.class.getName());

	// public function update data every interval seconds
	public client_info(int interval) {
		this.interval = interval;
	}

	// public function default update data every 5 seconds
	public client_info() {
		this.interval = 5;
	}

	// protected function
	// private function
	private String get_os() {
		String run_cmd = "python " + public_data.os_name_tool;
		String os_name = new String();
		try {
			ArrayList<String> excute_retruns = system_cmd.run(run_cmd);
			os_name = excute_retruns.get(1);
		} catch (IOException e) {
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
		disk_left = free_space / 1024 / 1024 / 1024 + "G";
		return disk_left;
	}

	private String get_cpu_usage() {
		String systemType = System.getProperties().getProperty("os.name");
		String cpu_usage = new String();
		if (systemType.contains("Windows")) {
			String run_cmd = "python " + public_data.get_cpu_tool;
			try {
				ArrayList<String> excute_retruns = system_cmd.run(run_cmd);
				cpu_usage = excute_retruns.get(1);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
				INFO_LOGGER.warn("Cannot resolve Operation System name");
				cpu_usage = "--";
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
			String run_cmd = "python " + public_data.get_mem_tool;
			try {
				ArrayList<String> excute_retruns = system_cmd.run(run_cmd);
				mem_usage = excute_retruns.get(1);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
				INFO_LOGGER.warn("Cannot resolve Operation System name");
				mem_usage = "--";
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
		String host_ip = null;
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
	 * update client_hash: System : os = type_arch type = windows/linux arch =
	 * 32b/64b Machine : terminal= xxx ip = xxx
	 */
	private void update_static_data() {
		HashMap<String, String> system_data = new HashMap<String, String>();
		HashMap<String, String> machine_data = new HashMap<String, String>();
		String type = new String();
		String arch = new String();
		String os = get_os();
		if (os.equalsIgnoreCase("unknown")) {
			type = "NA";
			arch = "NA";
		} else {
			type = os.split("_")[0];
			arch = os.split("_")[1];
		}
		String terminal = get_host_name();
		String ip = get_host_ip();
		system_data.put("os", os);
		system_data.put("type", type);
		system_data.put("arch", arch);
		machine_data.put("terminal", terminal);
		machine_data.put("ip", ip);
		client_hash.put("System", system_data);
		client_hash.put("Machine", machine_data);
	}

	/*
	 * update client_hash: System : space = xxG cpu = xx% mem = xx%
	 */
	private void update_dynamic_data() {
		HashMap<String, String> system_data = new HashMap<String, String>();
		String space = get_disk_left();
		String cpu = get_cpu_usage();
		String mem = get_mem_usage();
		system_data.put("space", space);
		system_data.put("cpu", cpu);
		system_data.put("mem", mem);
		client_hash.put("System", system_data);
	}

	public void run() {
		try {
			monitor_run();
		} catch (Exception run_exception) {
			run_exception.printStackTrace();
			System.exit(1);
		}
	}

	private void monitor_run() {
		info_thread = Thread.currentThread();
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
				INFO_LOGGER.debug("Client info Thread running...");
			}
			data_updating = true;
			update_dynamic_data();
			// System.out.println("Thread running...");
			data_updating = false;
			try {
				Thread.sleep(interval * 1000);
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
		if (info_thread != null) {
			info_thread.interrupt();
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
		client_info client_update = new client_info(1);
		client_update.start();
		INFO_LOGGER.warn("thread start...");
		try {
			Thread.sleep(10 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(client_info.client_hash.toString());
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