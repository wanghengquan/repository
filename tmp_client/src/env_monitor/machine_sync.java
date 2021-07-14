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
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.public_data;
import data_center.switch_data;
import oshi.SystemInfo;
import oshi.hardware.CentralProcessor;
import oshi.hardware.GlobalMemory;
import oshi.hardware.HardwareAbstractionLayer;
import oshi.software.os.OperatingSystem;
import oshi.util.Util;
import top_runner.run_status.exit_enum;
import utility_funcs.system_cmd;
import utility_funcs.time_info;
import utility_funcs.linux_info;

/*
 * This class used to get the basic information of the client.
 * return machine_hash:
 * 		System	:	os		=	family + version
 *                  os_family = windows7
 *                  os_version = 7
 *                  os_bits =   64
 * 					os_type	=	windows/linux
 * 					os_arch	=	32b/64b
 * 					space	=	xxG
 * 					cpu		=	xx%
 * 					mem		=	xx%
 * 		Machine	:	terminal=	xxx
 * 					ip		=	xxx 
 *                  start_time = xxx	
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
	private static final Logger MACHINE_SYNC_LOGGER = LogManager.getLogger(machine_sync.class.getName());
	private switch_data switch_info;
	private static SystemInfo sys_info = new SystemInfo();
	private static HardwareAbstractionLayer hw_info = sys_info.getHardware();
	private static OperatingSystem os_info = sys_info.getOperatingSystem();
	private static LinkedList<Double> cpu_list =new LinkedList<Double>();
	private static LinkedList<Long> mem_list =new LinkedList<Long>();
	
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
	
	private String get_os_type() {
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
		String os_name = new String("unknown");
		String os_family = new String(get_os_family());
		String os_version = new String(get_os_version());
		os_name = os_family + os_version;
		return os_name;
	}
	
	private String get_os_version() {
		String os_version = new String("X.X");
		Pattern ver_patt = Pattern.compile("\\d*(\\.\\d*)?", Pattern.CASE_INSENSITIVE);
		Matcher ver_match = ver_patt.matcher(os_info.getVersionInfo().getVersion());
		if (ver_match.find()){
			os_version = ver_match.group().trim(); 
		}
		return os_version;
	}	
	
	private String get_os_family() {
		String os_family = new String("NA");
		String ori_name = os_info.getFamily().toLowerCase();
		if (ori_name.contains("windows")) {
			os_family = "windows";
		} else if (ori_name.contains("ubuntu")) {
			os_family = "ubuntu";
		} else if (ori_name.contains("centos")) {
			os_family = "centos";
		} else if (ori_name.contains("red")) {
			os_family = "redhat";
		} else {
			os_family = "NA";
		}
		return os_family;
	}
	
	public static String get_disk_left() {
		File file = new File("..");
		String disk_left = new String();
		long free_space = file.getFreeSpace();
		disk_left = free_space / 1024 / 1024 / 1024 + "";
		return disk_left;
	}
	
	public static String get_disk_left(String work_space) {
		File file = new File(work_space);
		String disk_left = new String();
		long free_space = file.getFreeSpace();
		disk_left = free_space / 1024 / 1024 / 1024 + "";
		return disk_left;
	}	

	public static String get_avail_space() {
		File file = new File("..");
		String disk_avail = new String();
		long free_space = file.getUsableSpace();
		disk_avail = free_space / 1024 / 1024 / 1024 + "";
		return disk_avail;
	}
	
	public static String get_avail_space(String work_space) {
		File file = new File(work_space);
		String disk_avail = new String();
		long free_space = file.getUsableSpace();
		disk_avail = free_space / 1024 / 1024 / 1024 + "";
		return disk_avail;
	}
	
	private String get_cpu_usage() {
		String cpu_usage = new String("NA");
		CentralProcessor processor = hw_info.getProcessor();
        long[] prevTicks = processor.getSystemCpuLoadTicks();
        Util.sleep(1000);
        double current_data = processor.getSystemCpuLoadBetweenTicks(prevTicks) * 100;
        cpu_list.addFirst(current_data);
        if (cpu_list.size() > public_data.RUN_CPU_FILTER_LENGTH) {
        	cpu_list.removeLast();
        }
        double sum = 0.0;
        for(double tick_data: cpu_list) {
        	sum = sum + tick_data;
        }
        double average_data = sum / cpu_list.size();
        cpu_usage = String.valueOf(Math.round(average_data));
        return cpu_usage;
	}
	
	
	public static String get_cpu_usage_ori() {
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
				MACHINE_SYNC_LOGGER.warn("Cannot resolve System CPU usage");
				cpu_usage = "NA";
			}
			return cpu_usage;
		} else {
			int cpu_usage_int = linux_info.cpu_usage(5);
			return String.valueOf(cpu_usage_int);
		}
	}

	private String get_mem_usage() {
		String mem_usage = new String("NA");
		GlobalMemory memory = hw_info.getMemory();
		long current_data = (memory.getTotal() - memory.getAvailable()) * 100 / memory.getTotal();
        mem_list.addFirst(current_data);
        if (mem_list.size() > public_data.RUN_MEM_FILTER_LENGTH) {//60 seconds average
        	mem_list.removeLast();
        }
        long sum = 0;
        for(long tick_data: mem_list) {
        	sum = sum + tick_data;
        }
        long average_data = sum / mem_list.size();
        mem_usage = String.valueOf(average_data);
        return mem_usage;
	}
	
	public static String get_mem_usage_ori() {
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
				MACHINE_SYNC_LOGGER.warn("Cannot resolve System MEM usage");
				mem_usage = "NA";
			}
			return mem_usage;
		} else {
			int mem_usage_int = linux_info.memory_usage();
			return String.valueOf(mem_usage_int);
		}
	}

	public static String get_host_name() {
		InetAddress addr = null;
		String host_name = "unknown_host";
		try {
			addr = InetAddress.getLocalHost();
			host_name = addr.getHostName().toString();
		} catch (Exception e) {
			// e.printStackTrace();
			MACHINE_SYNC_LOGGER.warn("Cannot resolve host name");
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
			MACHINE_SYNC_LOGGER.warn("Cannot resolve host ip address");
			host_ip = "NA";
		}
		return host_ip;
	}

	private void update_static_data() {
		HashMap<String, String> system_data = new HashMap<String, String>();
		HashMap<String, String> machine_data = new HashMap<String, String>();
		system_data.put("os", get_os());
		system_data.put("os_family", get_os_family());
		system_data.put("os_version", get_os_version());
		system_data.put("os_type", get_os_type());
		system_data.put("os_arch", System.getProperty("os.arch").toLowerCase());
		system_data.put("os_bits", String.valueOf(os_info.getBitness()));
		machine_data.put("terminal",get_host_name());
		machine_data.put("ip", get_host_ip());
		machine_data.put("start_time", get_start_time());
		machine_hash.put("System", system_data);
		machine_hash.put("Machine", machine_data);
	}

	/*
	 * update machine_hash: System : space = xxG cpu = xx% mem = xx%
	 */
	private void update_dynamic_data() {
		HashMap<String, String> system_data = new HashMap<String, String>();
		system_data.putAll(machine_hash.get("System"));
		String space = get_avail_space();
		String cpu = get_cpu_usage();
		String mem = get_mem_usage();
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
			switch_info.set_client_stop_exception(run_exception);
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
				MACHINE_SYNC_LOGGER.debug("machine_sync Thread running...");
				MACHINE_SYNC_LOGGER.debug(machine_sync.machine_hash.toString());
			}
			// ============== All dynamic job start from here ==============
			// task 1 : update machine data
			update_dynamic_data();
			// task final: status update
			switch_info.set_machine_runner_active_time(time_info.get_date_time());
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

	public static void test_print() {
		System.out.println(os_info.getFamily());
		System.out.println(os_info.getManufacturer());
		System.out.println(os_info.getVersionInfo());
	}
	
	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		machine_sync.test_print();
		/*
		client_update.start();
		System.out.println(client_update.get_start_time());
		System.exit(exit_enum.NORMAL.get_index());
		MACHINE_SYNC_LOGGER.warn("thread start...");
		try {
			Thread.sleep(10 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(machine_sync.machine_hash.toString());
		client_update.wait_request();
		MACHINE_SYNC_LOGGER.warn("thread wait...");
		try {
			Thread.sleep(10 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		MACHINE_SYNC_LOGGER.warn("thread wake...");
		client_update.wake_request();
		System.out.println(machine_sync.machine_hash.toString());
		try {
			Thread.sleep(10 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		MACHINE_SYNC_LOGGER.warn("thread stop...");
		client_update.soft_stop();
		try {
			Thread.sleep(10 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("Main finished");
		*/
	}
}