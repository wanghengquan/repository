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
	public final static String CURRENTVERSION = "2.05.01"; // External.Internal.DEV
	public final static String BUILDDATE = "2017/2/20";
	public final static String SUITEFILEVERSION = "1.05";
	public final static float JAVABASEVERSION = 1.8f;
	public final static float PYTHONBASEVERSION = 2.7f;
	public final static float SVNBASEVERSION = 1.4f;
	
	//Soft ware bin path
	private static String bin_path = get_bin_path();
	
	// external configure based on software bin path
	public final static String DEFAULT_INI = bin_path + "/conf/default.conf";
	public final static String FRAME_PNG = bin_path + "/conf/frame.png";
	public final static String TRAY_PNG = bin_path + "/conf/ico.png";

	// external tools based on software bin path
	public final static String SSHPASS_TOOL = bin_path + "/tools/sshpass/sshpass";
	public final static String KILL_PROCESS_TOOL = bin_path + "/tools/kill_process.py";
	public final static String KILL_WINPOP_TOOL = bin_path + "/tools/kill_winpop.py";
	public final static String OS_NAME_TOOL = bin_path + "/tools/os_name.py";
	public final static String GET_CPU_TOOL = bin_path + "/tools/get_cpu.py";
	public final static String GET_MEM_TOOL = bin_path + "/tools/get_mem.py";
	public final static String PSCP_TOOL = bin_path + "/tools/pscp.exe";
	public final static String PUTTY_TOOL = bin_path + "/tools/putty.exe";

	// link to RabbitMQ configuration file has a higher priority then internal
	public static String rabbitmq_host = "lsh-reg01";
	public static String rabbitmq_user = "root";
	public static String rabbitmq_pwd = "root";
	public final static String QUEUE_RESULT_NAME = "Result";
	public final static String QUEUE_INFO_NAME = "Info";
	public final static String TASK_QUEUE_NAME = "task_queue";
	public final static String ADMIN_QUEUE_NAME = "admin_queue";
	
	// performance calibration
	public final static String SW_MAX_INSTANCES = "10";
	
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
		public_data my_data = new public_data();
		PUB_LOGGER.warn(KILL_PROCESS_TOOL);
		
	}	
}