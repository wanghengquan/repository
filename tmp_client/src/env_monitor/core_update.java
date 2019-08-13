package env_monitor;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.client_data;
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
	private client_data client_info;
	private String core_name = public_data.CORE_SCRIPT_NAME;
	private String core_addr = public_data.CORE_SCRIPT_ADDR;
	private String svn_user = public_data.SVN_USER;
	private String svn_pwd = public_data.SVN_PWD;
	private String line_separator = System.getProperty("line.separator");

	public core_update(){
		
	}
	
	public core_update(client_data client_info){
		this.client_info = client_info;
	}
	
	public Boolean update() {
		Boolean update_status = new Boolean(false);
		String work_space = client_info.get_client_preference_data().get("work_space");  
		update_core_script(work_space);
		update_core_script_info();
		if(is_remote_local_version_same()){
			update_status = true;
		}
		return update_status;
	}
	
	private Boolean is_remote_local_version_same(){
		String work_space = client_info.get_client_preference_data().get("work_space");
		String user_cmd = " --username=" + svn_user + " --password=" + svn_pwd + " --no-auth-cache"; 		
		//remote version
    	String remote_version = new String("NA");
        try {
            String remote_info = "svn info " + core_addr +  user_cmd;
            ArrayList<String> remote_return = system_cmd.run(remote_info);
            remote_version = get_version_num(remote_return);
        }catch (InterruptedException e) {
            e.printStackTrace();
        }catch (IOException e){
            e.printStackTrace();
        }
        //local_version
    	String local_version = new String("NA");
        try {
            String local_info = "svn info " + core_name +  user_cmd;
            ArrayList<String> local_return = system_cmd.run(local_info, work_space);
            local_version = get_version_num(local_return);
        }catch (IOException e){
            e.printStackTrace();
        }
        if (local_version.equalsIgnoreCase(remote_version)){
        	return true;
        } else {
        	return false;
        }
	}
	
	public void update_core_script(String work_space) {
		//String work_space = client_info.get_client_preference_data().get("work_space");
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
	
    private void update_core_script_info(){
		String work_space = client_info.get_client_preference_data().get("work_space");
		String user_cmd = " --username=" + svn_user + " --password=" + svn_pwd + " --no-auth-cache"; 
		String version = new String("NA");
		String time = new String("NA");
        try {
            String svn_info = "svn info " + core_name + " " + user_cmd;
            ArrayList<String> info_return = system_cmd.run(svn_info, work_space);
            version = get_version_num(info_return);
            time = get_update_time(info_return);
        }catch (IOException e){
            e.printStackTrace();
        }
        client_info.update_client_corescript_data("version", version);
        client_info.update_client_corescript_data("time", time);        
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

    private String get_version_num(ArrayList<String> inputs){
    	String version = new String("NA");
        String pattern = ".+?:\\s+(\\d+)$";
        Pattern r = Pattern.compile(pattern);
        for (String line: inputs){
        	Matcher m = r.matcher(line);
        	if(m.find()){
        		version = m.group(1); 
        	}
        }
        return version;
    }
    
    private String get_update_time(ArrayList<String> inputs){
    	String update_time = new String("NA");
    	String pattern = ".+?:\\s+(\\d\\d\\d\\d-\\d\\d-\\d\\d\\s+?\\d\\d:\\d\\d:\\d\\d)";
        Pattern r = Pattern.compile(pattern);
        for (String line: inputs){
        	Matcher m = r.matcher(line);
        	if(m.find()){
        		update_time = m.group(1); 
        	}
        }
        return update_time;
    }    
    
	public static void main(String[] argvs) {
		core_update updater = new core_update();
		String work_space = new String("D:/tmp_work_space");
		updater.update(work_space);
		System.out.println(">>>update done");
		System.exit(exit_enum.NORMAL.get_index());
	}
}
