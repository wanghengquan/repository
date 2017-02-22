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

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.File;

public class public_data {
	// base
	public final static String BASE_CURRENTVERSION = "2.05.01"; // External.Internal.DEV
	public final static String BASE_BUILDDATE = "2017/2/22";
	public final static String BASE_SUITEFILEVERSION = "1.05";
	public final static float BASE_JAVABASEVERSION = 1.8f;
	public final static float BASE_PYTHONBASEVERSION = 2.7f;
	public final static float BASE_SVNBASEVERSION = 1.4f;
	
	// Soft ware bin path
	private static String bin_path = get_bin_path();
	
	// external configure based on software bin path
	public final static String CONF_DEFAULT_INI = bin_path + "/conf/default.conf";
	public final static String CONF_FRAME_PNG = bin_path + "/conf/frame.png";
	public final static String CONF_TRAY_PNG = bin_path + "/conf/ico.png";

	// external tools based on software bin path
	public final static String TOOLS_SSHPASS = bin_path + "/tools/sshpass/sshpass";
	public final static String TOOLS_KILL_PROCESS = bin_path + "/tools/kill_process.py";
	public final static String TOOLS_KILL_WINPOP = bin_path + "/tools/kill_winpop.py";
	public final static String TOOLS_OS_NAME = bin_path + "/tools/os_name.py";
	public final static String TOOLS_GET_CPU = bin_path + "/tools/get_cpu.py";
	public final static String TOOLS_GET_MEM = bin_path + "/tools/get_mem.py";
	public final static String TOOLS_PSCP = bin_path + "/tools/pscp.exe";
	public final static String TOOLS_PUTTY = bin_path + "/tools/putty.exe";

	// link to RabbitMQ configuration data only shown here
	public final static String RMQ_HOST = "linux-D50553";
	public final static String RMQ_USER = "root";
	public final static String RMQ_PWD = "root";
	public final static String RMQ_RESULT_NAME = "Result";
	public final static String RMQ_INFO_NAME = "Info";
	public final static String RMQ_TASK_NAME = "task_queue";
	public final static String RMQ_ADMIN_NAME = "admin_queue";
	
	// link to SVN configuration data only shown here
	public final static String SVN_USER = "guest";
	public final static String SVN_PWD = "welcome";
	
	// Link to core script 
	public final static String CORE_NAME = "DEV";
	public final static String CORE_ADDR = "http://lshlabd0001/platform/trunk/bqs_scripts/DEV";	
	
	// Software default data command line, config, GUI have higher priority
	// Software
	public final static String DEF_SW_MAX_INSTANCES = "10";
	// Machine
	public final static String DEF_MACHINE_PRIVATE = "1"; //1 private, 0 public
	public final static String DEF_MAX_PROCS = "3"; 
	public final static String DEF_GROUP_NAME = "tmp_client";
	// Base
	public final static String DEF_WORK_PATH = System.getProperty("user.dir").replaceAll("\\\\", "/");
	public final static String DEF_SAVE_PATH = System.getProperty("user.dir").replaceAll("\\\\", "/");
	
	// performance calibration
	public final static int PERF_THREAD_RUN_INTERVAL = 5;
	
	private static final Logger PUB_LOGGER = LogManager.getLogger(public_data.class.getName());
	
	public public_data(){

	}
	
	private static String get_bin_path(){
		String class_path_str = public_data.class.getResource("").getPath();
		File class_path = new File(class_path_str);
		String bin_path = class_path.getParentFile().getParent();
		return bin_path.replaceAll("\\\\", "/");
	}
	
	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		@SuppressWarnings("unused")
		public_data my_data = new public_data();
		PUB_LOGGER.warn(TOOLS_KILL_PROCESS);
		
	}	
}