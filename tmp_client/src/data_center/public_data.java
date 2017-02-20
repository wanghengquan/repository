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
	public final static String CurrentVersion = "2.05.01"; // External.Internal.DEV
	public final static String BuildDate = "2017/2/20";
	public final static String SuiteFileVersion = "1.05";
	public final static float JavaBaseVersion = 1.8f;
	public final static float PythonBaseVersion = 2.7f;
	public final static float SvnBaseVersion = 1.4f;
	
	//Soft ware bin path
	private static String bin_path = get_bin_path();
	
	// external configure based on software bin path
	public final static String default_conf = bin_path + "/conf/default.ini";
	public final static String frame_conf = bin_path + "/conf/frame.png";
	public final static String tray_conf = bin_path + "/conf/ico.png";

	// external tools based on software bin path
	public final static String sshpass_tool = bin_path + "/tools/sshpass/sshpass";
	public final static String kill_process_tool = bin_path + "/tools/kill_process.py";
	public final static String kill_winpop_tool = bin_path + "/tools/kill_winpop.py";
	public final static String os_name_tool = bin_path + "/tools/os_name.py";
	public final static String get_cpu_tool = bin_path + "/tools/get_cpu.py";
	public final static String get_mem_tool = bin_path + "/tools/get_mem.py";
	public final static String pscp_tool = bin_path + "/tools/pscp.exe";
	public final static String putty_tool = bin_path + "/tools/putty.exe";

	// link to RabbitMQ configuration file has a higher priority then internal
	public static String RABBITMQ_HOST = "lsh-reg01";
	public static String RABBITMQ_USER = "root";
	public static String RABBITMQ_PWD = "root";
	public final static String QUEUE_RESULT_NAME = "Result";
	public final static String QUEUE_INFO_NAME = "Info";
	public final static String TASK_QUEUE_NAME = "task_queue";
	public final static String ADMIN_QUEUE_NAME = "admin_queue";

	// min system requirements:
	public static Long DiskLeft = 2L; // G
	
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
		PUB_LOGGER.warn(kill_process_tool);
		
	}	
}