/*
 * File: public_data.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package data_center;

import java.io.File;

import top_control.tmp_manager;

public class public_data {
	//private static final Logger PUB_LOGGER = LogManager.getLogger(public_data.class.getName());
	//========================
	//>>>>>>>>>>>>>>>>>>>>>>>>following data can be use directly
	//>>>>>>>>>>>>>>>>>>>>>>>>
	//========================
	
	//========================
	// base
	public final static String BASE_CURRENTVERSION = "2.05.01"; // External.Internal.DEV
	public final static String BASE_BUILDDATE = "2017/3/22";
	public final static String BASE_SUITEFILEVERSION = "1.05";
	public final static String BASE_CONTACT_MAIL = "Jason.Wang@latticesemi.com";
	public final static float BASE_JAVABASEVERSION = 1.8f;
	public final static float BASE_PYTHONBASEVERSION = 2.7f;
	public final static float BASE_SVNBASEVERSION = 1.4f;
	
	//========================
	// Soft ware bin path
	public final static String SW_BIN_PATH = get_bin_path();
	
	//========================
	// log setting
	public final static String LOG_HOME = "D:/logs123";
	public final static String FILE_NAME = "123.log";
	
	//========================
	// external configure based on software bin path
	public final static String CONF_DEFAULT_INI = SW_BIN_PATH + "/conf/default.conf";

	//========================
	// external configure based on software bin path
	public final static String ICON_FRAME_PNG = SW_BIN_PATH + "/image/frame.png";
	public final static String ICON_TRAY_PNG = SW_BIN_PATH + "/image/ico.png";
	public final static String ICON_TAB_PNG = SW_BIN_PATH + "/image/tab.png";
	
	//========================
	// workspace folder configuration, real path = work_path + following folder name
	public final static String WORKSPACE_RESULT_DIR = "results";
	public final static String WORKSPACE_UPLOAD_DIR = "uploads";
	public final static String WORKSPACE_LOG_DIR = "logs";
	public final static String WORKSPACE_CASE_REPORT_NAME = "case_report.txt";
	
	//========================
	// external tools based on software bin path
	public final static String TOOLS_SSHPASS = SW_BIN_PATH + "/tools/sshpass/sshpass";
	public final static String TOOLS_KILL_PROCESS = SW_BIN_PATH + "/tools/kill_process.py";
	public final static String TOOLS_KILL_WINPOP = SW_BIN_PATH + "/tools/kill_winpop.py";
	public final static String TOOLS_OS_NAME = SW_BIN_PATH + "/tools/os_name.py";
	public final static String TOOLS_GET_CPU = SW_BIN_PATH + "/tools/get_cpu.py";
	public final static String TOOLS_GET_MEM = SW_BIN_PATH + "/tools/get_mem.py";
	public final static String TOOLS_PSCP = SW_BIN_PATH + "/tools/pscp.exe";
	public final static String TOOLS_CP = SW_BIN_PATH + "/tools/cp.exe";
	public final static String TOOLS_PUTTY = SW_BIN_PATH + "/tools/putty.exe";
	public final static String TOOLS_UPLOAD = SW_BIN_PATH + "/tools/upload/excel2testrail.py";

	//========================
	// external documents based on software bin path
	public final static String DOC_USAGE = SW_BIN_PATH + "/doc/usage.pdf";
	
	//========================
	// link to RabbitMQ configuration data only shown here
	public final static String RMQ_HOST = "linux-D50553"; //"linux-D50553" "lsh-reg01"
	public final static String RMQ_USER = "root";
	public final static String RMQ_PWD = "root";
	public final static String RMQ_RESULT_NAME = "result";
	public final static String RMQ_CLIENT_NAME = "monitor";  //client data
	public final static String RMQ_TASK_NAME = "task_queue";
	public final static String RMQ_ADMIN_NAME = "admin_queue";
	public final static String RMQ_RUNTIME_NAME = "logs";
	
	//========================
	// Encryption public key
	public final static String ENCRY_KEY = "@Lattice";
	public final static String ENCRY_DEF_STRING = "Yjt7LEio8/f0c3/eaa3otw=="; //SVN encryption string for: guest_+_welcome
	
	//========================
	// link to SVN configuration data only shown here
	public final static String SVN_USER = "guest";
	public final static String SVN_PWD = "welcome";
	
	//========================
	// Link to core script 
	public final static String CORE_SCRIPT_NAME = "DEV";
	public final static String CORE_SCRIPT_ADDR = "http://lshlabd0001/platform/trunk/bqs_scripts/DEV";	
	
	//========================
	// task case default setting
	public final static String TASK_DEF_TIMEOUT = "3600"; //in Seconds, 1 hour 
	public final static String TASK_DEF_PRIORITY = "5"; //0 > 2 > 9
	
	//========================
	// performance calibration
	public final static int PERF_THREAD_BASE_INTERVAL = 5;
	public final static int PERF_POOL_MAXIMUM_SIZE = 15;
	
	//========================
	//>>>>>>>>>>>>>>>>>>>>>>>>following data will be update by data_server.java
	//>>>>>>>>>>>>>>>>>>>>>>>>Please use fresh data in switch_data(switch_info)
	//========================
	//========================
	// Software default data command line > configuration; 
	// Software GUI have higher priority
	public final static String DEF_SW_MAX_INSTANCES = "10";
	// Machine
	public final static String DEF_GROUP_NAME = "tmp_client";	
	public final static String DEF_MACHINE_PRIVATE = "1"; //1 private, 0 public 
	// preference
	public final static String DEF_TASK_ASSIGN_MODE = "auto"; //"serial", "parallel", "auto"
	public final static String DEF_MAX_THREAD_MODE = "auto"; //"manual", "auto"
	public final static String DEF_CLIENT_LINK_MODE = "both"; //"local", "remote", "both"
	public final static String DEF_POOL_CURRENT_SIZE = "5";
	public final static String DEF_WORK_PATH = System.getProperty("user.dir").replaceAll("\\\\", "/");
	public final static String DEF_SAVE_PATH = System.getProperty("user.dir").replaceAll("\\\\", "/");	
	
	public public_data(){
	}
	
	private static String get_bin_path(){
		String bin_path = tmp_manager.get_bin_path();
		File bin_dobj = new File(bin_path);
		String install_path = bin_dobj.getParentFile().getAbsolutePath();
		System.out.println(">>>>>>>>>>");
		System.out.println(install_path);
		return install_path.replaceAll("\\\\", "/");
	}
	
	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		@SuppressWarnings("unused")
		public_data my_data = new public_data();
		System.out.println(System.getProperty("file.separator"));
		System.out.println(System.getProperty("path.separator"));
		System.out.println(System.getProperty("line.separator"));
		System.out.println(System.getProperty("user.name")); 
		System.out.println(System.getProperty("user.home")); 
		System.out.println(System.getProperty("user.dir")); 
		System.out.println(System.getProperty("os.name")); 
		System.out.println(System.getProperty("os.arch")); 
		System.out.println(System.getProperty("os.version"));
		String path = System.getProperty("user.dir"); 
		System.out.println(path);
		String haha = path.replaceAll("\\\\", "/"); 
		System.out.println(haha);
		File path_dobj = new File(path);
		File[] file_list = path_dobj.listFiles();
		for(File file: file_list){
			if(file.isDirectory()){
				continue;
			}
			System.out.println(file.getName());
		}
		Thread client_thread = Thread.currentThread();
		System.out.println(client_thread.getName());
	}	
}