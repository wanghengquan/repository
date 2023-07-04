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
import java.text.DecimalFormat;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import top_runner.top_launcher;
import utility_funcs.time_info;

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
	public final static String BASE_CURRENTVERSION = "2.14.66"; //main.xx.build. xx:odd for stable, even for develop
	public final static int BASE_CURRENTVERSION_INT = 21466; //version for code use
	public final static String BASE_BUILDDATE = "2023/06/30";
	public final static String BASE_SUITEFILEVERSION = "1.28";
	public final static String BASE_DEVELOPER_MAIL = "Jason.Wang@latticesemi.com";
	public final static String BASE_OPERATOR_MAIL = "Jason.Wang@latticesemi.com";
	public final static String BASE_JAVABASEVERSION = "1.8";
	public final static String BASE_PYTHONBASEVERSION = "2.7";
	public final static String BASE_PYTHONMAXVERSION = "4.0";
	public final static String BASE_SVNBASEVERSION = "1.4";

	// ========================
	// Client sensitive environment list
	public final static String ENV_SQUISH_RECORD = "SQUISH_RECORD";
	
	// ========================
	// Software bin path
	public final static String SW_HOME_PATH = get_home_path();

	// ========================
	// Client run limitation (system requirements)
	public final static int RUN_LIMITATION_CPU = 95;//client suspend when CPU usage large than this value
	public final static int RUN_LIMITATION_MEM = 95;//client suspend when MEM usage large than this value
	public final static String RUN_LIMITATION_SPACE = "50";//G, client suspend when disk space less than this value
	public final static int RUN_CPU_FILTER_LENGTH = 6;//client CPU monitor filter length, about 1 minute
	public final static int RUN_MEM_FILTER_LENGTH = 6;//client MEM monitor filter length, about 1 minute
	
	// ========================
	// log setting
	public final static String LOG_HOME = SW_HOME_PATH;
	public final static String FILE_NAME = "client.log";

	// ========================
	// email setting servers: 1:LSHMAIL1.latticesemi.com,  2:172.25.0.3
	public final static String MAIL_SERVER = "lscmail.latticesemi.com";
	public final static String MAIL_SERVER_USERNAME = "swqalab";//"jwang1";
	public final static String MAIL_SERVER_PASSWORD = "SwQaLab!";//"Quan@lattice123";

	// ========================
	// send email preference setting
	public final static int SEND_MAIL_TASK_BLOCK = 10;	
	
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
	public final static String ICON_SYNC_RUN = SW_HOME_PATH + "/image/sync.gif";
	public final static String ICON_SYNC_DONE = SW_HOME_PATH + "/image/done.png";
	
	// ========================
	// Remote update path
	public final static String UPDATE_URL = "http://lsh-tmp/tmp_client_release/update.xml";
	public final static String UPDATE_URL_DEV = "http://lsh-tmp/tmp_client_release/update_dev.xml";
	
	// ========================
	// Remote core script path
	public final static String CORE_SCRIPT_NAME = "DEV";
	public final static String CORE_SCRIPT_REMOTE_URL = "http://lsh-tmp/platform/trunk/tmp_scripts/" + CORE_SCRIPT_NAME; //lsh-tmp, lsh-guitar
	public final static String REMOTE_CORE_SCRIPT_DIR = "$work_path/" + CORE_SCRIPT_NAME;
	public final static String LOCAL_CORE_SCRIPT_DIR2 = SW_HOME_PATH + "/tools/corescripts2/" + CORE_SCRIPT_NAME;
	public final static String LOCAL_CORE_SCRIPT_DIR3 = SW_HOME_PATH + "/tools/corescripts3/" + CORE_SCRIPT_NAME;
	
	// ========================
	// workspace folder configuration, real path = work_space + following folder
	// name
	public final static String WORKSPACE_RESULT_DIR = "results";
	public final static String WORKSPACE_UPLOAD_DIR = "uploads";
	public final static String WORKSPACE_TEMP_DIR = "temp";
	public final static String WORKSPACE_LOG_DIR = "logs";
	public final static String [] WORKSPACE_RESERVED_DIR = 
		{CORE_SCRIPT_NAME, WORKSPACE_RESULT_DIR, WORKSPACE_UPLOAD_DIR, WORKSPACE_TEMP_DIR, WORKSPACE_LOG_DIR};
	
	// ========================
	// suite folder configuration
	// name	
	public final static String SUITE_DATA_REPORT_NAME = "suite_scan.csv";
	public final static String SUITE_LOCK_FILE_NAME = "suite_lock.txt";
	public final static String SUITE_LIST_FILE_NAME = "case_list.txt";
	
	// ========================
	// case folder configuration
	// name	
	public final static String CASE_REPORT_NAME = "case_report.txt";
	public final static String CASE_TIMEOUT_RUN = "_timeout.py";
	public final static String CASE_USER_PATTERN = "^run\\..*";
	public final static String CASE_STANDARD_PATTERN = "run_info.ini";
	public final static String CASE_INFO_FILE = "bqs.info";
	public final static String CASE_EXEC_FILE = "DEV/bin/run_radiant.py";
	public final static String CASE_CHECK_FILE = "bqs.conf";
	public final static String CASE_DATA_FILE = "bqs.data";
	
	// ========================
	// external tools based on software bin path
	public final static String TOOLS_ROOT_PATH = SW_HOME_PATH + "/tools";
	public final static String TOOLS_SSHPASS = SW_HOME_PATH + "/tools/sshpass/sshpass";
	public final static String TOOLS_KILL_PROCESS = SW_HOME_PATH + "/tools/kill_process.py";
	public final static String TOOLS_KILL_WINPOP = SW_HOME_PATH + "/tools/kill_winpop.py";
	public final static String TOOLS_EXP_CHECK = SW_HOME_PATH + "/tools/exp_check.py";
	public final static String TOOLS_MEM_CHECK = SW_HOME_PATH + "/tools/mem_check.py";
	public final static String TOOLS_OS_NAME = SW_HOME_PATH + "/tools/os_name.py";
	public final static String TOOLS_GET_CPU = SW_HOME_PATH + "/tools/get_cpu.py";
	public final static String TOOLS_GET_MEM = SW_HOME_PATH + "/tools/get_mem.py";
	public final static String TOOLS_PSCP = SW_HOME_PATH + "/tools/pscp.exe";
	public final static String TOOLS_CP = SW_HOME_PATH + "/tools/cp.exe";
	public final static String TOOLS_WGET = SW_HOME_PATH + "/tools/wget.exe";
	public final static String TOOLS_7ZA = SW_HOME_PATH + "/tools/7za.exe";
	public final static String TOOLS_TAR = SW_HOME_PATH + "/tools/tar.exe";
	public final static String TOOLS_WHICH = SW_HOME_PATH + "/tools/which.exe";
	public final static String TOOLS_PUTTY = SW_HOME_PATH + "/tools/putty.exe";
	public final static String TOOLS_PY_ENV = SW_HOME_PATH + "/tools/python_env.py";
	public final static String TOOLS_UPLOAD2 = SW_HOME_PATH + "/tools/upload2/excel2testrail.py";
	public final static String TOOLS_UPLOAD3 = SW_HOME_PATH + "/tools/upload3/run_suite.py";
	public final static String TOOLS_UPLOAD3_DYNAMIC = REMOTE_CORE_SCRIPT_DIR + "/tools/uploadSuites/run_suite.py";

	// ========================
	// external documents based on software bin path
	public final static String DOC_CLIENT_USAGE = SW_HOME_PATH + "/doc/usage.pdf";
	public final static String DOC_TMP_USAGE = SW_HOME_PATH + "/doc/TMP_doc";
	public final static String DOC_EXAMPLE_PATH = SW_HOME_PATH + "/doc/TMP_example";
	public final static String DOC_EIT_PATH = SW_HOME_PATH + "/doc/TMP_EIT_suites";

	// ========================
	// link to RabbitMQ configuration data shown here
	// manually check RabbitMQ queue status: http://linux-D50553:15672/#/queues
	public final static String RMQ_HOST = "lsh-tmp"; // "lsh-guitar", "lsh-tmp"
	public final static String RMQ_USER = "root";
	public final static String RMQ_PWD = "root";
	public final static String RMQ_RESULT_NAME = "result";
	public final static String RMQ_CLIENT_NAME = "monitor"; // client data
	public final static String RMQ_RUNTIME_NAME = "console_log";
	public final static String RMQ_TASK_QUEUE = "task_queue";
	public final static String RMQ_ADMIN_QUEUE = "admin_queue";
	public final static String RMQ_STOP_QUEUE = "stop_queue";


	// ========================
	// link to Other Clients configuration data shown here
	// manually check RabbitMQ queue status: http://linux-D50553:15672/#/queues
	public final static int SOCKET_DEF_LINK_PORT = 55555;
	public final static String SOCKET_DEF_ACKNOWLEDGE = "@received@";
	public final static String SOCKET_LINK_ACKNOWLEDGE = "@linked@";
	public final static String SOCKET_DEF_TERMINAL = "localhost";
	
	// ========================
	// terminal defaults
	public final static String TERMINAL_DEF_PROMPT = "->";	
	
	// ========================
	// Encryption public key
	public final static String ENCRY_KEY = "@Lattice";
	//SVN encryption string for: guest_+_welcome
	public final static String ENCRY_DEF_STRING = "Yjt7LEio8/f0c3/eaa3otw==";

	// ========================
	// link to SVN default user shown here
	public final static String SVN_USER = "guest";
	public final static String SVN_PWD = "welcome";
	public final static String SVN_URL = "http://lsh-tmp";//lsh-tmp, lsh-guitar

	// ========================
	// link to TMP server Database default user shown here
	public final static String TMP_DATABASE_USER = "public@latticesemi.com";
	public final static String TMP_DATABASE_PWD = "lattice";
	
	// ========================
	// link to FTP default user shown here
	public final static String FTP_USER = "guest";
	public final static String FTP_PWD = "welcome";

	// ========================
	// task case default setting
	public final static String TASK_DEF_TIMEOUT = "3600"; // in Seconds, 1 hour
	public final static float TASK_DEF_ESTIMATE_MEM_MAX = 16.0f; //in G, 16G
	public final static float TASK_DEF_ESTIMATE_MEM_MIN = 1.0f; //in G, 1G
	public final static float TASK_DEF_ESTIMATE_SPACE = 2.0f; //in G, 2G
	public final static String TASK_DEF_MAX_MEM_USG = "16";
	public final static String TASK_DEF_CMD_PARALLEL = "false"; // false, true
	public final static String TASK_DEF_CMD_DECISION = "last"; //last, all, <indiviual cmd>, <indiviual cmds> join with Python:and,or
	public final static String TASK_DEF_PRIORITY = "5"; // 0 > 2 > 9
	public final static String TASK_DEF_RESULT_KEEP = "auto"; // auto, zipped, unzipped
	public final static String TASK_DEF_MAX_THREADS = "0"; //no limitation
	public final static String TASK_DEF_HOST_RESTART = "false"; //no Restart need
	public final static String TASK_DEF_VIDEO_RECORD = "false"; // false, true
	public final static long TASK_DEF_RESTART_IDENTIFY_THRESHOLD = 600;
	public final static long TASK_DEF_RESTART_SYSTEM_THRESHOLD = 3600; //3600
    public final static String TASK_PRI_LOCALLY = "1"; 

	// ========================
	// performance calibration
    public final static int PERF_GUI_BASE_INTERVAL = 1;
	public final static int PERF_THREAD_BASE_INTERVAL = 5;
	public final static int PERF_DUP_REPORT_INTERVAL = 120;   //Case same status report interval
	public final static int PERF_POOL_CURRENT_SIZE = 3;      //Current max size to external
	public final static int PERF_POOL_WIN_MAX_SIZE = 10;
	public final static int PERF_POOL_LIN_MAX_SIZE = 100;
	public final static int PERF_POOL_MAXIMUM_SIZE = get_maximum_threads();	
	public final static int PERF_AUTO_MAXIMUM_CPU = 80;
	public final static int PERF_AUTO_MAXIMUM_MEM = 80;
	public final static int PERF_AUTO_ADJUST_CYCLE = 6;
	public final static float PERF_GOOD_MEM_USAGE_RATE = 0.80f;
	public final static int PERF_SQUISH_WIN_MAX_CPU = 30;
	public final static int PERF_SQUISH_WIN_MAX_MEM = 60;
	public final static int PERF_SQUISH_LIN_MAX_CPU = 20;
	public final static int PERF_SQUISH_LIN_MAX_MEM = 30;
	public final static int PERF_SQUISH_MAXIMUM_CPU = get_squish_max_cpu();
	public final static int PERF_SQUISH_MAXIMUM_MEM = get_squish_max_mem();
	public final static int PERF_QUEUE_DUMP_DELAY = 720;    // one hour
	public final static int PERF_MAX_WIN_WAITER	= 3;
	public final static int PERF_MAX_LIN_WAITER	= 12;
	public final static int PERF_MAX_TASK_WAITER = get_maximum_waiters();

	// ========================
	// Internal String replacement
	public final static String INTERNAL_STRING_SEMICOLON = "@SC@";   // ';'
	public final static String INTERNAL_STRING_BLANKSPACE = "@BS@";  // ' '
	public final static String INTERNAL_STRING_COLON = "@CL@";  	 // ':'
	
	// ========================
	// >>>>>>>>>>>>>>>>>>>>>>>>following data will be update by data_server.java
	// >>>>>>>>>>>>>>>>>>>>>>>>Please use fresh data in switch_data(switch_info)
	// ========================
	// ========================
	// Software default data command line > configuration;
	// Software GUI have higher priority
	public final static String DEF_SW_MAX_INSTANCES = "10";
	public final static int DEF_SCAN_CMD_TAKE_LINE = 10;
	public final static int DEF_GUI_BUILD_SHOW_LINE = 50;
	// Tools
	public final static String DEF_PYTHON_PATH = "python";
	public final static String DEF_PERL_PATH = "perl";
	public final static String DEF_RUBY_PATH = "ruby";
	public final static String DEF_SVN_PATH = "svn";
	public final static String DEF_GIT_PATH = "git";	
	// Machine
	public final static String DEF_GROUP_NAME = "tmp_client";
	public final static String DEF_MACHINE_PRIVATE = "1"; // 1 private, 0 public
	public final static String DEF_UNATTENDED_MODE = "0"; // 1 UNATTENDED(no user), 0 ATTENDED(user there)
	public final static String DEF_STABLE_VERSION = "1"; // 1 get stable update, 0 get develop update
	public final static String DEF_CLIENT_DEBUG_MODE = "0"; //1: Client run in debug mode
	// preference
	public final static String DEF_INTERFACE_MODE = "gui"; // "gui", "cmd", "int"(interactive)
	public final static String DEF_TASK_ASSIGN_MODE = "auto"; // "serial", parallel", "auto"
	public final static String DEF_MAX_THREAD_MODE = "auto"; // "manual", "auto"
	public final static String DEF_CLIENT_LINK_MODE = "both"; // "local","remote","both"
	public final static String DEF_CLIENT_CASE_MODE = "copy_case"; // "copy_case","hold_case"
	public final static String DEF_CLIENT_GREED_MODE = "auto"; // "auto","true","false"
	public final static String DEF_COPY_KEEP_PATH = "false";  //flatten copied case
	public final static String DEF_COPY_LAZY_COPY = "false";
	public final static String DEF_CLIENT_IGNORE_REQUEST = "null";//"all", "software", "system", "machine"
	public final static String DEF_SHOW_WELCOME = "1";
	public final static String DEF_AUTO_RESTART = "0";
	public final static String DEF_AUTO_RESTART_DAY = "7";
	public final static String DEF_WORK_SPACE = System.getProperty("user.dir").replaceAll("\\\\", "/");
	public final static String DEF_SAVE_SPACE = "";
	public final static String DEF_LSH_SAVE_SPACE = "//lsh-smb02/sw/qa/qadata";
	public final static String [] DEF_LSV_STORAGE_ID = {"\\\\ldc-smb01\\", "/disks/"};
	public final static int DEF_CLEANUP_QUEUE_SIZE = 1000;
	public final static int DEF_CLEANUP_TASK_TIMEOUT = 600;
	//look and feel
	public final static String DEF_SYSTEM_TABLE_FONT = get_default_table_font();

	public public_data() {
	}

	private static String get_home_path() {
		String bin_path = top_launcher.get_bin_path();
		File bin_dobj = new File(bin_path);
		String install_path = bin_dobj.getParentFile().getAbsolutePath().replaceAll("\\\\", "/");
		return install_path.replaceAll("\\\\", "/");
	}
	
	private static int get_squish_max_cpu(){
		String os = System.getProperty("os.name").toLowerCase();
		if (os.contains("windows")) {
			return public_data.PERF_SQUISH_WIN_MAX_CPU;
		} else {
			return public_data.PERF_SQUISH_LIN_MAX_CPU;
		}
	}
	
	private static int get_squish_max_mem(){
		String os = System.getProperty("os.name").toLowerCase();
		if (os.contains("windows")) {
			return public_data.PERF_SQUISH_WIN_MAX_MEM;
		} else {
			return public_data.PERF_SQUISH_LIN_MAX_MEM;
		}
	}
	
	private static int get_maximum_threads(){
		String os = System.getProperty("os.name").toLowerCase();
		if (os.contains("windows")) {
			return public_data.PERF_POOL_WIN_MAX_SIZE;
		} else {
			return public_data.PERF_POOL_LIN_MAX_SIZE;
		}
	}
	
	private static int get_maximum_waiters(){
		String os = System.getProperty("os.name").toLowerCase();
		if (os.contains("windows")) {
			return public_data.PERF_MAX_WIN_WAITER;
		} else {
			return public_data.PERF_MAX_LIN_WAITER;
		}
	}
	
	private static String get_default_table_font(){
		String os = System.getProperty("os.name").toLowerCase();
		if (os.contains("windows")) {
			return "Times New Roman";
		} else {
			return "Bitstream Charter";
		}
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
		System.out.println(System.getProperty("java.home"));
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
		//test
		String script_url = new String("");
		System.out.println(">" + script_url.substring(script_url.lastIndexOf("/") + 1));
		String base_name = new String("abc.aa"); 
		Pattern src_patt = Pattern.compile("\\s(" + base_name + ")\\s", Pattern.CASE_INSENSITIVE);
		Matcher exe_match = src_patt.matcher("1234 abc.aa cc");
		if (exe_match.find()){
			System.out.println(exe_match.group());
		}
		String queue_name = new String("555@t1r1_run_55555"); 
		queue_name = queue_name.split("@.+?_")[1];
		System.out.println(queue_name);
		System.out.println("====");
		System.out.println(System.getProperty("os.name"));
		System.out.println(System.getProperty("os.arch"));
		System.out.println(System.getProperty("os.version"));
		String build_name = new String("3.1?cmd_1");
		build_name = build_name.replaceAll("\\?" + "cmd_1", "");
		System.out.println(time_info.get_date_time());
        // <status>Passed</status>
		String ttt = new String("711@t0r0_run_200979_20230119_170715");
        Pattern p = Pattern.compile("(\\d{6})_\\d+$");
        Matcher m = p.matcher(ttt);
        if (m.find()) {
        	System.out.println(m.group(1));
        } 
        Integer memory_est = Integer.valueOf(80);
        Integer memory_exp = Integer.valueOf(96);
        System.out.println(memory_est + memory_exp);
        float rate = 100.85456f;
        System.out.println(memory_exp * rate);
        Float available = Float.valueOf(memory_exp * rate);
        available.intValue();
        DecimalFormat decimalformat = new DecimalFormat("0.00");
        System.out.println(decimalformat.format(rate)); 
        long tt = (long) 2.0854263E9;
        float rs = tt / (float)1024 / (float)1024 / (float)1024;
        System.out.println(rs);
        
	}
}
