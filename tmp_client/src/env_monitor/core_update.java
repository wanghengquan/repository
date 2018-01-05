package env_monitor;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.exit_enum;
import data_center.public_data;
import utility_funcs.system_cmd;

public class core_update {
	/*
	 * This function used to update trunk from svn. For general, this function
	 * should do during no process is running.
	 * 
	 * And we have to make sure there is SVN in the client machine. 1. check
	 * trunk directory is exists or not 2. check trunk status 3. if need, update
	 * it. 4. When the client is start, this function also need to check.
	 */
	private static final Logger CORE_LOGGER = LogManager.getLogger(core_update.class.getName());
	private String core_name = public_data.CORE_SCRIPT_NAME;
	private String core_addr = public_data.CORE_SCRIPT_ADDR;
	private String svn_user = public_data.SVN_USER;
	private String svn_pwd = public_data.SVN_PWD;
	private String line_separator = System.getProperty("line.separator");

	public core_update(){
		
	}
	
	public void update(String work_space) {
		String user_cmd = " --username=" + svn_user + " --password=" + svn_pwd + " --no-auth-cache";
		File trunk_handle = new File(core_name);
		if (trunk_handle.exists() && trunk_handle.isDirectory()) {
			// 1. go to trunk directory
			// 2. execute svn info, find URL
			// 3. find, execute svn update
			// 4. else:
			// 1. clean trunk
			// 2. execute svn checkout
			try {
				// System.out.println("trunk exists");
				ArrayList<String> info_return = system_cmd.run("svn info " + core_name + " " + user_cmd, work_space);
				StringBuffer cmdout = new StringBuffer();
				Boolean find_url = false;
				for (String line : info_return) {
					cmdout.append(line).append(line_separator);
					if (line.matches(core_addr) || line.indexOf(core_addr) != -1)
						find_url = true;
				}
				if (find_url) {
					try {
						ArrayList<String> excute_returns = system_cmd.run("svn update " + core_name + " " + user_cmd,
								work_space);
						CORE_LOGGER.debug(excute_returns.toString());
					} catch (IOException e) {
						// TODO Auto-generated catch block
						// e.printStackTrace();
					}
				} else {
					ArrayList<String> excute_returns = system_cmd.run("svn co " + user_cmd + " " + core_addr,
							work_space);
					CORE_LOGGER.debug(excute_returns.toString());
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} else {
			try {
				ArrayList<String> excute_returns = system_cmd.run("svn co " + core_addr + " " + user_cmd, work_space);
				CORE_LOGGER.debug(excute_returns.toString());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public static void main(String[] argvs) {
		core_update updater = new core_update();
		String work_space = new String("D:/tmp_work_space");
		updater.update(work_space);
		System.out.println(">>>update done");
		System.exit(exit_enum.NORMAL.get_index());
	}
}
