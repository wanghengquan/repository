package public_lib;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.lang.management.OperatingSystemMXBean;
import java.net.*; 

import javax.swing.JOptionPane;

import windowsMonitor.IMonitorService;
import windowsMonitor.MonitorInfoBean;
import windowsMonitor.MonitorServiceImpl;
/*
 * This class used to get the basic information of the client.
 * 1: Memory 
 */
public class Monitor extends Thread{
	private final static String confFile="conf/clientConf.conf";
	private final static String osScript = "conf/os_name.py";
	private String group_name;
	private String host_name;
	private String host_ip;
	private String max_procs;
	public String os = "unknown";
	public String os_arch = "unknown";
	private String os_type;
	private String memory_left;
	private String cpu_used;
	private String disk_left;
	private String diamond;
	private String radiant;
	private String high_priority;
	private String priority0;
	private String priority1;
	private String other_software;
	private String modelsim;
	private String questasim;
	private String riviera;
	private String icecube;
	private String squish;
	private String alive="True";
	private String admin_request="0";
	private static Boolean client_env_change = false;
	private static List<String> scan_diamond_list = new ArrayList<>();
	private static List<String> scan_radiant_list = new ArrayList<>();	
	public volatile static Boolean Suspend = false;
	public machine_data machine_instance;
    public Threadpool poolInstance;
    
	public void setAdmin_request(Boolean admin_request) {
		if(admin_request)
		    this.admin_request =  "1";
		else
			this.admin_request =  "0";
	}
	
	public String getGroup_name() {
		group_name = ReadWriteConf.readValue(confFile, "group").trim();
		return group_name;
	}
	public void setGroup_name(String group_name) {
		this.group_name = group_name;
		ReadWriteConf.writeProperties(confFile, "group_name", this.group_name);
	}
	
	public String getHost_name() {
		if (ReadWriteConf.readValue(confFile, "terminal") == null){
			InetAddress addr=null;
			String address="";
			try{
				addr=InetAddress.getLocalHost();
				address=addr.getHostName().toString();
			}catch(Exception e){
				e.printStackTrace();
			}
			host_name = address;
		} else {
			host_name = ReadWriteConf.readValue(confFile, "terminal").trim();
		}
		return host_name;
	}
	
	public void setHost_name() {
		/*
		 * left empty
		 */
		;
	}
	public String getHost_ip2() {
		InetAddress addr=null;
		String ip="";
		try{
			addr=InetAddress.getLocalHost();
			//addr = InetAddress.getLoopbackAddress();
			ip=addr.getHostAddress().toString();
		}catch(Exception e){
			e.printStackTrace();
		}
		this.host_ip = ip;
		return host_ip;
	}
	public String getHost_ip(){
		    try{
	            for (Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces(); interfaces.hasMoreElements();) {
	                NetworkInterface networkInterface = interfaces.nextElement();
	                if (networkInterface.isLoopback() || networkInterface.isVirtual() || !networkInterface.isUp()) {
	                    continue;
	                }
	                Enumeration<InetAddress> addresses = networkInterface.getInetAddresses();
	                if (addresses.hasMoreElements()) {
	                	InetAddress ia = (InetAddress) addresses.nextElement();
	                    if (ia instanceof Inet6Address)
	                        continue;
	                    this.host_ip =ia.getHostAddress();
	                    break;
	                   //System.out.println( addresses.nextElement());
	                }
	            }
            }catch(Exception e){
    			e.printStackTrace();
            }
		    //System.out.println( host_ip);
            return host_ip;
            
        
    }

	public void setHost_ip() {
		/*
		 * left empty
		 */
	}
	public String getMax_procs() {
		max_procs = ReadWriteConf.readValue(confFile, "max_procs");
		return max_procs;
	}
	public void setMax_procs(String max_procs) {
		this.max_procs = max_procs;
		ReadWriteConf.writeProperties(confFile, "max_procs", this.max_procs);
	}
	public String getOsType() {
		String os = System.getProperty("os.name").toLowerCase();
		if (os.indexOf("windows") >= 0){
			this.os_type = "windows";
		}
		else if (os.indexOf("linux") >= 0){
			this.os_type = "linux";
		}
		else{
			this.os_type = "unknown";
		}
		return this.os_type;
	}
	
	public String getOs() {
		String cmd = "python " + osScript;
		try {
			ArrayList<String> excute_retruns =  execute_system_cmd.run(cmd);
			this.os = excute_retruns.get(1);
		} catch (IOException e) {
			//TODO Auto-generated catch block
			e.printStackTrace();
			this.os = "unknown";
		}
		return this.os;
	}	
	
	public String getOsArch() {
		String cmd = "python " + osScript;
		try {
			ArrayList<String> excute_retruns =  execute_system_cmd.run(cmd);
			this.os = excute_retruns.get(1);
		} catch (IOException e) {
			//TODO Auto-generated catch block
			e.printStackTrace();
			this.os = "unknown";
		}
		if (this.os.contains("_")){
			this.os_arch = this.os.split("_")[1];
		} else{
			this.os_arch = "unknown";
		}
		return this.os_arch;
	}	
	
	public void setOs() {
		/*
		 * left empty
		 */
	}
	public String getMemory_left() {
		return memory_left;
	}
	public void setMemory_left_Cpu_used() throws Exception { 
		// At here, Linux CPU is not used.
		String systemType=System.getProperties().getProperty("os.name");	
		//on linux
		if(systemType.indexOf("indows")<0){
			this.cpu_used =  OSUtils.cpuUsage()+"%";
			this.memory_left = OSUtils.memoryUsage()+"%";		
		}
		else{
			IMonitorService service = new MonitorServiceImpl();  
	        MonitorInfoBean monitorInfo = service.getMonitorInfoBean();  
	        float percent = 100 - (float) monitorInfo.getUsedMemory() / monitorInfo.getTotalMemorySize() *100;
	        DecimalFormat df = new DecimalFormat("#.0");
			this.cpu_used = monitorInfo.getCpuRatio()+"%";
			this.memory_left = df.format (percent)+"%";
		}
	}
	public String getCpu_used() {
		
		return cpu_used;
	}
	public void setCpu_used(String cpu_used) {
		/*
		 * left empty
		 */
	}
	public String getDisk_left() {
		File file = new File(".."); 
        long total_space = file.getTotalSpace();  
        long free_space = file.getFreeSpace();  
        long used_space = total_space - free_space;  
		this.disk_left = free_space / 1024 / 1024 / 1024 + "G";
		//disk_left = ReadWriteConf.readValue(confFile, "disk_left");
		return this.disk_left;
	}
	public void setDisk_left(String disk_left) {
		/*
		 * Left empty
		 */
		
	}

	public static void SetScanDiamond(){
		/*
		 * This function used to get the diamond from the scan_dir path, and write it into the conf file
		 */
		try{
			String scan_dir = ConfigurationFile.getProfileString(confFile, "diamond", "scan_dir", null);
			if(scan_dir != null){
				File scan_hand = new File(scan_dir);
				if(scan_hand.exists()  && scan_hand.isDirectory()){
					//we need to find success.log under directory.
					File [] all_hands = scan_hand.listFiles();
					for(int file_num=0;file_num<all_hands.length;file_num++){
						File sub_hand = all_hands[file_num];
						String sub_hand_str = sub_hand.toString();
						if(sub_hand.isDirectory()){
							File success_log = new File(sub_hand.getAbsolutePath()+"/success.log");
							if(success_log.exists() && !scan_diamond_list.contains(sub_hand_str)){
								Monitor.client_env_change = true;
								scan_diamond_list.add(sub_hand_str);
								System.out.println(">>>Warning: Diamond updated, Task queue update later...");
								File version_hand = new File(sub_hand.getAbsolutePath() + "/diamond/3.8_x64");
								if (version_hand.exists()){
									ConfigurationFile.setProfileString(confFile, "diamond", sub_hand.getName(), sub_hand.getAbsolutePath().replaceAll("\\\\", "/") + "/diamond/3.8_x64");
								}else {
									ConfigurationFile.setProfileString(confFile, "diamond", sub_hand.getName(), sub_hand.getAbsolutePath().replaceAll("\\\\", "/")  + "/diamond/3.9_x64");
								}
							}
						}
					}
				}
			}
		}catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static void SetScanRadiant(){
		/*
		 * This function used to get the diamond from the scan_dir path, and write it into the conf file
		 */
		String scan_dir = "";
		try {
			scan_dir = ConfigurationFile.getProfileString(confFile, "radiant", "scan_dir", null);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if (scan_dir == null || scan_dir == ""){
			return;
		}
		File scan_drh = new File(scan_dir);
		if (!scan_drh.exists() || scan_drh.isFile()){
			return;
		}
		File [] item_list = scan_drh.listFiles();
		for(File item: item_list){
			File success_frh = new File(item.getAbsolutePath(), "success.log");
			if (success_frh.exists() && !scan_radiant_list.contains(item.toString())){
				Monitor.client_env_change = true;
				scan_radiant_list.add(item.toString());
				System.out.println(">>>Warning: Radiant updated, Task queue update later...");
				File version_drh = new File(item.getAbsolutePath());
				if(version_drh.exists()){
					try {
						ConfigurationFile.setProfileString(confFile, "radiant", item.getName(), version_drh.getAbsolutePath().replaceAll("\\\\", "/"));
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
		}
	}
	
	public String getDiamond() {
		SetScanDiamond();
		//diamond = ReadWriteConf.readValue(confFile, "diamond");
		try {
			diamond = ConfigurationFile.getSectionString(confFile,"diamond","null").trim();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			diamond= "";
		}
		return diamond;
	}
	public void setDiamond(String diamond) {
		this.diamond = diamond;
	}
	
	public String getRadiant(){
		SetScanRadiant();
		try {
			radiant = ConfigurationFile.getSectionString(confFile,"radiant","null").trim();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			radiant= "";
		}
		return radiant;		
	}
	
	public void setRadiant(String radiant) {
		this.radiant = radiant;
	}	
	
	public String getHigh_priority() {
		high_priority = ReadWriteConf.readValue(confFile, "high_priority");
		return high_priority;
	}
	
	public String get_priority0() {
		String priority0_str = new String();
		priority0_str = ReadWriteConf.readValue(confFile, "priority0").trim();
		if (priority0_str == null){
			priority0 = "";
		} else {
			priority0 = priority0_str;
		}
		return priority0;
	}
	
	public String get_priority1() {
		String priority1_str = new String();
		priority1_str = ReadWriteConf.readValue(confFile, "priority1").trim();
		if (priority1_str == null){
			priority1 = "";
		} else {
			priority1 = priority1_str;
		}
		return priority1;
	}
	
	public String get_machine_type() {
		String machine_type = new String();
		machine_type = ReadWriteConf.readValue(confFile, "machine_type").trim();
		return machine_type;
	}
	
	public void setHigh_priority(String high_priority) {
		this.high_priority = high_priority;
	}
	public String getOther_software() {
		//other_software = ReadWriteConf.readValue(confFile, "other_software");
		try {
			other_software = ConfigurationFile.getSectionString(confFile,"soft","");
			questasim = ConfigurationFile.getSectionString(confFile,"questasim","",true);
			riviera   = ConfigurationFile.getSectionString(confFile,"riviera","",true);
			icecube   = ConfigurationFile.getSectionString(confFile,"icecube","",true);
			modelsim   = ConfigurationFile.getSectionString(confFile,"modelsim","",true);
			squish = ConfigurationFile.getSectionString(confFile,"squish","",true);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			other_software = "";
			questasim = "";
			riviera = "";
			icecube = "";
			modelsim = "";
			squish = "";
		}
		return other_software;
	}
	public void setOther_software(String other_software) {
		this.other_software = other_software;
		//this.questasim_path = questasim_path;
		//this.riviera_path = riviera_path;
		//this.icecube_path = icecube_path;
	}
	
	public String getAlive() {
		return "True";
	}
	public void setAlive(String alive) {
		this.alive = alive;
	}
	@SuppressWarnings("rawtypes")
	public HashMap<String, String> init() throws Exception{
		getGroup_name();
		getHost_name();
		getHost_ip();
		getMax_procs();
		getOsType();
		getOs();
		setMemory_left_Cpu_used();
		getDisk_left();
		getDiamond();
		getRadiant();
		getHigh_priority();
		getOther_software();
		getAlive();
		HashMap<String, String>     hashmap     =     new HashMap<String, String>();   
        hashmap.put("group_name",    group_name);
        hashmap.put("host_name",    host_name); 
        hashmap.put("host_ip",    host_ip); 
        hashmap.put("max_procs",    max_procs); 
        hashmap.put("os_type",    os_type); 
        hashmap.put("os",    os); 
        hashmap.put("memory_left",    memory_left); 
        hashmap.put("cpu_used",    cpu_used); 
        hashmap.put("disk_left",    disk_left); 
        hashmap.put("diamond",    diamond); 
        hashmap.put("radiant",    radiant); 
        hashmap.put("high_priority",    high_priority); 
        hashmap.put("other_software",    other_software); 
        hashmap.put("questasim",    questasim); 
        hashmap.put("riviera",    riviera); 
        hashmap.put("icecube",    icecube); 
        hashmap.put("modelsim",    modelsim); 
        hashmap.put("squish",    squish); 
        //hashmap.put("alive",    alive); 
        return hashmap;
	}
	public String xmlString(Boolean simple) throws Exception{
		/*<?xml version="1.0" encoding="UTF-8" ?>
		<client ip=锟斤拷192.168.48.81锟斤拷 machine=锟斤拷d25315锟斤拷 group=锟斤拷FE锟斤拷 processNum=5>
		<info>
			<memory-left>200M</memory-left>
			<cpu-used>30%</cpu-used>
			<disk-left>100G<disk-left>
			<os>win7_32b</os>
			<diamond>c:\lscc\diamond3.3, c:\lscc\diamond3.4, c:\lscc\diamond3.5</diamond>
			<other-software>all other software path</other-software>
		</info>
		</client>*/
		String init_info = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
		init_info += "\n<client>";
		if (!simple){
			HashMap<String, String> hashmap = init();
			Set<?>     set     =     hashmap.entrySet();   
	        Iterator<?>     iterator     =     set.iterator();   
	        while (iterator.hasNext()) {   
	          Map.Entry     mapentry     =     (Map.Entry)     iterator.next();   
	          init_info +="\n"+"<"+mapentry.getKey()+">"+mapentry.getValue()+"</"+mapentry.getKey()+">";
	          //System.out.println(mapentry.getKey()     +     "=>"     +     mapentry.getValue());   
	      }
        }else{
			init_info += "\n<host_name>"+getHost_name()+"</host_name>";
		}
		if(this.admin_request == "1")
			init_info += "\n<admin_request>"+"1"+" </admin_request>";
		init_info =init_info+ "\n"+this.machine_instance.ReadUpdate(true,0,0);
        init_info += "\n</client>";
		return init_info;
	}
	
	public Boolean ClientAvailableCheck(){
		Boolean client_work = false;
		File file = new File(".."); 
        Long free_space = file.getUsableSpace();  
		Long disk_left = free_space / 1024 / 1024 / 1024;
		if (disk_left > publicData.DiskLeft){
			client_work = true;
		} else {
			client_work= false;
		}
		Monitor.Suspend = !client_work;
		if (TopRun.dug_model){
			System.out.println(">>>Debug: Client work env status," + client_work);
			System.out.println(">>>Debug: Min disk, " + publicData.DiskLeft + "G");
			System.out.println(">>>Debug: disk left, " + disk_left + "G");
		}
		return client_work;
	}
	
	public void run(){
		try{
			monitor_run();
		} catch (Exception run_exception){
			run_exception.printStackTrace();
			file_action.append_file(publicData.monitordump, run_exception.toString());
			System.exit(1);
		}
	}
	
	public void monitor_run() {
		String my_os = getOs();
		String my_os_type = getOsType();
		rabbitMQ rabbitmq_instance = new rabbitMQ(poolInstance);
		rabbitmq_instance.start();
		Boolean rabbitmq_working = true;
		int flag_number=1;
		int update_flag = 1; 
		while (true){
			//client turn on/off
			Boolean client_available = ClientAvailableCheck();
			if (client_available){
				if (!rabbitmq_working){
					System.out.println(">>>Warning:Client start to getting tasks...");
					rabbitmq_instance.wakeRequest();
					rabbitmq_working = true;
				}
			} else {
				System.out.println(">>>Warning:Client Suspended, Reason:[disk]...");
				if (rabbitmq_working){	
					rabbitmq_instance.waitRequest();
					rabbitmq_working = false;
					}	
			}
			//environment diamond/ng update
			SetScanDiamond();
			SetScanRadiant();
			//monitor for link run
			if (TopRun.local_model){
				;
			} else {
				if(flag_number%6 == 0){
					try {
						//System.out.println(xmlString(false));
						String content = xmlString(false);
						rabbitMQ.client_send("monitor", content);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
						Date dt=new Date();
						String localeString=dt.toString();
						file_action.print_out_to_file_to_gui("In Monitor run,\n"+localeString+"\nCan not send message to server\n");
					}
					flag_number = 0;
				}else{
					try {
						//System.out.println(xmlString(true));
						if (update_flag == 1 || Monitor.client_env_change){
							setAdmin_request(true);
							rabbitMQ.client_send("monitor", xmlString(true));
							setAdmin_request(false);
							update_flag = 0;
							Monitor.client_env_change = false;
						} else
							rabbitMQ.client_send("monitor", xmlString(true));
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
						Date dt=new Date();
						String localeString=dt.toString();
						file_action.print_out_to_file_to_gui("In Monitor run,\n"+localeString+"\nCan not send message(2) to server");
					}
				}
				flag_number += 1;
			}
			try {
				Thread.sleep(15*1000);
				System.out.println(">>>Info: Client Machine Data Updating...");
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				Date dt=new Date();
		 	    String localeString=dt.toString();
				file_action.print_out_to_file_to_gui("In Monitor run:\n"+localeString+"\nCan not to sleep");
			}			
		}
	}
	
	public  Monitor(Threadpool instance){
		poolInstance = instance;
		machine_instance = new machine_data(instance);
	}
	
	public  Monitor(){
		;
	}
	
	public static void mainc(String[] argv) throws Exception{
		Monitor demo = new Monitor();
		demo.getHost_ip2();
		//System.out.println(demo.getHost_ip2());
		//System.exit(1);
		demo.start();
		System.out.println(demo.xmlString(true));
		System.out.println("--------------");
		HashMap<String, String> hashmap = demo.init();
		Set     set     =     hashmap.entrySet();   
        Iterator     iterator     =     set.iterator();   
        while (iterator.hasNext()) {   
          Map.Entry mapentry  =  (Map.Entry) iterator.next();   
          System.out.println(mapentry.getKey()     +     "=>"     +     mapentry.getValue());   
      }
	}

	public static void main(String[] argv) throws Exception{
		Monitor sys_info = new Monitor();
		sys_info.setMemory_left_Cpu_used();
		System.out.println(sys_info.cpu_used) ;
		System.out.println(sys_info.memory_left) ;
	}
	
}


