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

import top_runner.top_launcher;

public class public_data {
	// private static final Logger PUB_LOGGER =
	// LogManager.getLogger(public_data.class.getName());
	// ========================
	// >>>>>>>>>>>>>>>>>>>>>>>>following data can be use directly
	// >>>>>>>>>>>>>>>>>>>>>>>>
	// ========================

	// ========================
	// base 
	// end with 0: long term version, otherwise developing version
	public final static String BASE_CURRENTVERSION = "2.07.01"; //2.06.12 External.Internal.DEV
	public final static int BASE_CURRENTVERSION_INT = 20701; // version for code use
	public final static String BASE_BUILDDATE = "2018/02/27";
	public final static String BASE_SUITEFILEVERSION = "1.09";
	public final static String BASE_CONTACT_MAIL = "Jason.Wang@latticesemi.com";
	public final static float BASE_JAVABASEVERSION = 1.8f;
	public final static float BASE_PYTHONBASEVERSION = 2.7f;
	public final static float BASE_SVNBASEVERSION = 1.4f;

	// ========================
	// Soft ware bin path
	public final static String SW_HOME_PATH = get_home_path();

	// ========================
	// Client run limitation (system requirements)
	public final static int RUN_LIMITATION_CPU = 98;//client suspend when CPU usage large than this value
	public final static int RUN_LIMITATION_MEM = 98;//client suspend when MEM usage large than this value
	public final static int RUN_LIMITATION_SPACE = 5;//client suspend when disk space less than this value
	
	// ========================
	// log setting
	public final static String LOG_HOME = SW_HOME_PATH;
	public final static String FILE_NAME = "client.log";

	// ========================
	// external configure based on software bin path
	public final static String CONF_ROOT_PATH = SW_HOME_PATH + "/conf";
	public final static String CONF_DEFAULT_INI = SW_HOME_PATH + "/conf/default.ini";

	// ========================
	// external configure based on software bin path
	public final static String ICON_FRAME_PNG = SW_HOME_PATH + "/image/frame.png";
	public final static String ICON_TRAY_PNG = SW_HOME_PATH + "/image/ico.png";
	public final static String ICON_SOFTWARE_TAB_PNG = SW_HOME_PATH + "/image/tab.png";
	public final static String ICON_IMPORT_FILE = SW_HOME_PATH + "/image/file.png";
	public final static String ICON_IMPORT_PATH = SW_HOME_PATH + "/image/folder.png";
	public final static String ICON_RPT_SUITE_PNG = SW_HOME_PATH + "/image/suite.png";
	public final static String ICON_RPT_TITLE_PNG = SW_HOME_PATH + "/image/title.png";
	public final static String ICON_RPT_PREVIEW_PNG = SW_HOME_PATH + "/image/view.png";
	public final static String ICON_RPT_GENERATE_PNG = SW_HOME_PATH + "/image/gen.png";
	public final static String ICON_ATTENDED_MODE = SW_HOME_PATH + "/image/engineer.png";
	public final static String ICON_UNATTENDED_MODE = SW_HOME_PATH + "/image/robot.png";
	public final static String ICON_PRIVATE_MODE = SW_HOME_PATH + "/image/private.png";
	public final static String ICON_PUBLIC_MODE = SW_HOME_PATH + "/image/public.png";
	
	// ========================
	// Remote update path
	public final static String UPDATE_URL = "http://d50534/test/job_1/client_update/update.xml";
	public final static String UPDATE_URL_DEV = "http://d50534/test/job_1/client_update/update_dev.xml";
	
	// ========================
	// workspace folder configuration, real path = work_space + following folder
	// name
	public final static String WORKSPACE_RESULT_DIR = "results";
	public final static String WORKSPACE_UPLOAD_DIR = "uploads";
	public final static String WORKSPACE_LOG_DIR = "logs";
	
	// ========================
	// case folder configuration
	// name	
	public final static String CASE_REPORT_NAME = "case_report.txt";
	public final static String CASE_TIMEOUT_RUN = "_timeout.py";

	// ========================
	// external tools based on software bin path
	public final static String TOOLS_ROOT_PATH = SW_HOME_PATH + "/tools";
	public final static String TOOLS_SSHPASS = SW_HOME_PATH + "/tools/sshpass/sshpass";
	public final static String TOOLS_KILL_PROCESS = SW_HOME_PATH + "/tools/kill_process.py";
	public final static String TOOLS_KILL_WINPOP = SW_HOME_PATH + "/tools/kill_winpop.py";
	public final static String TOOLS_OS_NAME = SW_HOME_PATH + "/tools/os_name.py";
	public final static String TOOLS_GET_CPU = SW_HOME_PATH + "/tools/get_cpu.py";
	public final static String TOOLS_GET_MEM = SW_HOME_PATH + "/tools/get_mem.py";
	public final static String TOOLS_PSCP = SW_HOME_PATH + "/tools/pscp.exe";
	public final static String TOOLS_CP = SW_HOME_PATH + "/tools/cp.exe";
	public final static String TOOLS_WGET = SW_HOME_PATH + "/tools/wget.exe";
	public final static String TOOLS_PUTTY = SW_HOME_PATH + "/tools/putty.exe";
	public final static String TOOLS_UPLOAD = SW_HOME_PATH + "/tools/upload/excel2testrail.py";

	// ========================
	// external documents based on software bin path
	public final static String DOC_CLIENT_USAGE = SW_HOME_PATH + "/doc/usage.pdf";
	public final static String DOC_TMP_USAGE = SW_HOME_PATH + "/doc/TMP_doc";
	public final static String DOC_EXAMPLE_PATH = SW_HOME_PATH + "/doc/TMP_example";
	public final static String DOC_EIT_PATH = SW_HOME_PATH + "/doc/TMP_EIT_suites";

	// ========================
	// link to RabbitMQ configuration data only shown here
	// manually check RabbitMQ queue status: http://linux-D50553:15672/#/queues
	public final static String RMQ_HOST = "linux-D50553"; // "linux-D50553", "lsh-reg01"
	public final static String RMQ_USER = "root";
	public final static String RMQ_PWD = "root";
	public final static String RMQ_RESULT_NAME = "result";
	public final static String RMQ_CLIENT_NAME = "monitor"; // client data
	public final static String RMQ_TASK_NAME = "task_queue";
	public final static String RMQ_ADMIN_NAME = "admin_queue";
	public final static String RMQ_RUNTIME_NAME = "logs";

	// ========================
	// Encryption public key
	public final static String ENCRY_KEY = "@Lattice";
	//SVN encryption string for: guest_+_welcome
	public final static String ENCRY_DEF_STRING = "Yjt7LEio8/f0c3/eaa3otw==";

	// ========================
	// link to SVN default user shown here
	public final static String SVN_USER = "guest";
	public final static String SVN_PWD = "welcome";

	// ========================
	// link to FTP default user shown here
	public final static String FTP_USER = "guest";
	public final static String FTP_PWD = "welcome";
	
	// ========================
	// Link to core script
	public final static String CORE_SCRIPT_NAME = "DEV";
	public final static String CORE_SCRIPT_ADDR = "http://lshlabd0011/platform/trunk/bqs_scripts/DEV";

	// ========================
	// task case default setting
	public final static String TASK_DEF_TIMEOUT = "3600"; // in Seconds, 1 hour
	public final static String TASK_DEF_PRIORITY = "5"; // 0 > 2 > 9
	public final static String TASK_DEF_RESULT_KEEP = "auto"; // auto, zipped, unzipped 

	// ========================
	// performance calibration
	public final static int PERF_THREAD_BASE_INTERVAL = 5;
	public final static int PERF_DUP_REPORT_INTERVAL = 60;   //Case same status report interval
	public final static int PERF_POOL_MAXIMUM_SIZE = 30;
	public final static int PERF_AUTO_MAXIMUM_CPU = 70;
	public final static int PERF_AUTO_MAXIMUM_MEM = 85;
	public final static int PERF_AUTO_ADJUST_CYCLE = 5;

	// ========================
	// >>>>>>>>>>>>>>>>>>>>>>>>following data will be update by data_server.java
	// >>>>>>>>>>>>>>>>>>>>>>>>Please use fresh data in switch_data(switch_info)
	// ========================
	// ========================
	// Software default data command line > configuration;
	// Software GUI have higher priority
	public final static String DEF_SW_MAX_INSTANCES = "10";
	public final static int DEF_SCAN_CMD_TAKE_LINE = 10;
	public final static int DEF_GUI_BUILD_SHOW_LINE = 30;
	// Machine
	public final static String DEF_GROUP_NAME = "tmp_client";
	public final static String DEF_MACHINE_PRIVATE = "1"; // 1 private, 0 public
	public final static String DEF_UNATTENDED_MODE = "0"; // 1 UNATTENDED(no user), 0 ATTENDED(user there)
	public final static String DEF_STABLE_VERSION = "1"; // 1 get stable update, 0 get develop update
	// preference
	public final static String DEF_TASK_ASSIGN_MODE = "auto"; // "serial", parallel", "auto"
	public final static String DEF_MAX_THREAD_MODE = "auto"; // "manual", "auto"
	public final static String DEF_CLIENT_LINK_MODE = "both"; // "local","remote","both"
	public final static String DEF_CLIENT_CASE_MODE = "copy_case"; // "copy_case","keep_case"
	public final static String DEF_COPY_PATH_KEEP = "false";  //flatten copied case
	public final static String DEF_CLIENT_IGNORE_REQUEST = "null";//"software", "system", "machine"
	public final static String DEF_POOL_CURRENT_SIZE = "5";
	public final static String DEF_SHOW_WELCOME = "1";
	public final static String DEF_AUTO_RESTART = "0";
	public final static String DEF_AUTO_RESTART_DAY = "7";
	public final static String DEF_WORK_SPACE = System.getProperty("user.dir").replaceAll("\\\\", "/");
	public final static String DEF_SAVE_SPACE = System.getProperty("user.dir").replaceAll("\\\\", "/");

	public public_data() {
	}

	private static String get_home_path() {
		String bin_path = top_launcher.get_bin_path();
		File bin_dobj = new File(bin_path);
		String install_path = bin_dobj.getParentFile().getAbsolutePath().replaceAll("\\\\", "/");
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
		for (File file : file_list) {
			if (file.isDirectory()) {
				continue;
			}
			System.out.println(file.getName());
		}
		Thread client_thread = Thread.currentThread();
		System.out.println(client_thread.getName());
	}
}