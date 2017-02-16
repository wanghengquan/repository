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

public class public_data {
	// base
	public final static String CurrentVersion = "2.05.01"; // External.Internal.DEV
	public final static String BuildDate = "2017/2/20";
	public final static String SuiteFileVersion = "1.05";
	public final static float JavaBaseVersion = 1.8f;
	public final static float PythonBaseVersion = 2.7f;
	public final static float SvnBaseVersion = 1.4f;

	// external configure based on software bin path
	public final static String default_conf = "conf/default.ini";
	public final static String frame_conf = "conf/frame.png";
	public final static String tray_conf = "conf/ico.png";

	// external tools based on software bin path
	public final static String sshpass_tool = "tools/sshpass/sshpass";
	public final static String kill_process_tool = "tools/kill_process.py";
	public final static String kill_winpop_tool = "tools/kill_winpop.py";
	public final static String os_name_tool = "tools/os_name.py";
	public final static String pscp_tool = "tools/pscp.exe";
	public final static String putty_tool = "tools/putty.exe";

	// link to RabbitMQ configuration file has a higher priority then internal
	public static String RABBITMQ_HOST = "lsh-reg01";
	public static String RABBITMQ_USER = "root";
	public static String RABBITMQ_PWD = "root";

	// min system requirements:
	public static Long DiskLeft = 2L; // G
}