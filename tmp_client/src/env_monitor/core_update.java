package env_monitor;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.io.FileUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.client_data;
import data_center.public_data;
import top_runner.run_status.exit_enum;
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
	private String usr_cmd = new String(" --username=" + svn_user + " --password=" + svn_pwd + " --no-auth-cache");
	//private String line_separator = System.getProperty("line.separator");

	public core_update(){
		
	}
	
	public core_update(client_data client_info){
		this.client_info = client_info;
	}
	
	public Boolean update() {
		Boolean update_status = new Boolean(false);
		String work_space = client_info.get_client_preference_data().get("work_space");  
		//step 1: update core script
		try {
			update_status = update_core_script(work_space);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//step 2: update core script info
		update_core_script_info(work_space);
		//step 3: update check
		if(is_remote_local_version_same(work_space)){
			update_status = true;
		}
		return update_status;
	}
	
	private Boolean is_remote_local_version_same(String work_space){		
		//remote version
    	String remote_version = new String("NA");
        try {
            String remote_info = "svn info " + core_addr +  usr_cmd;
            ArrayList<String> remote_return = system_cmd.run(remote_info);
            remote_version = get_version_num(remote_return);
        }catch (Exception e){
            e.printStackTrace();
        }
        //local_version
    	String local_version = new String("AN");
        try {
            String local_info = "svn info " + core_name +  usr_cmd;
            ArrayList<String> local_return = system_cmd.run(local_info, work_space);
            local_version = get_version_num(local_return);
        }catch (Exception e){
            e.printStackTrace();
        }
        if (local_version.equalsIgnoreCase(remote_version)){
        	return true;
        } else {
        	return false;
        }
	}
	
	public Boolean update_core_script(
			String work_space) throws Exception {
		Boolean update_status = new Boolean(false);
		ArrayList<String> info_return = new ArrayList<String>();
		ArrayList<String> update_return = new ArrayList<String>();
		ArrayList<String> checkout_return = new ArrayList<String>();
		String url_addr = new String("NA");
		File core_fobj = new File(work_space + "/" + core_name);
		if (core_fobj.exists() && core_fobj.isDirectory()) {
			if(!core_fobj.canWrite()){
				CORE_LOGGER.warn("Core script Read only, skip core update for:" + work_space + "/" + core_name);
				return update_status;
			}
			info_return.addAll(system_cmd.run("svn info " + core_name + " " + usr_cmd, work_space));
			url_addr = get_url_addr(info_return);
			if (url_addr.equalsIgnoreCase(public_data.CORE_SCRIPT_ADDR)){
				update_return.addAll(system_cmd.run("svn update " + core_name + " " + usr_cmd, work_space));
				CORE_LOGGER.debug(update_return.toString());
			} else {
				//remove current core script
				FileUtils.deleteQuietly(core_fobj);
				Thread.sleep(1000);
				//checkout new one
				checkout_return.addAll(system_cmd.run("svn co " + core_addr + " " + usr_cmd, work_space));
				CORE_LOGGER.debug(checkout_return.toString());
			}
		} else {
			checkout_return.addAll(system_cmd.run("svn co " + core_addr + " " + usr_cmd, work_space));
			CORE_LOGGER.debug(checkout_return.toString());
		}
		update_status = true;
		return update_status;
	}
	
    private void update_core_script_info(String work_space){
		String version = new String("NA");
		String time = new String("NA");
		ArrayList<String> info_return = new ArrayList<String>();
        try {
            info_return.addAll(system_cmd.run("svn info " + core_name + " " + usr_cmd, work_space));
            version = get_version_num(info_return);
            time = get_update_time(info_return);
        }catch (IOException e){
            e.printStackTrace();
        }
        client_info.update_client_corescript_data("version", version);
        client_info.update_client_corescript_data("time", time);        
    }

    private String get_version_num(ArrayList<String> inputs){
    	String version = new String("NA");
    	if (inputs == null || inputs.isEmpty()) {
    		return version;
    	}  	
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
    	if (inputs == null || inputs.isEmpty()) {
    		return update_time;
    	}     	
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
    
    private String get_url_addr(ArrayList<String> inputs){
    	String url_addr = new String("NA");
    	if (inputs == null || inputs.isEmpty()) {
    		return url_addr;
    	}     	
    	String pattern = "URL.+?(http.+?DEV)";
        Pattern r = Pattern.compile(pattern);
        for (String line: inputs){
        	Matcher m = r.matcher(line);
        	if(m.find()){
        		url_addr = m.group(1); 
        	}
        }
        return url_addr;
    } 
    
	public static void main(String[] argvs) {
		core_update updater = new core_update();
		String work_space = new String("D:/tmp_work_space");
		try {
			updater.update_core_script(work_space);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(">>>update done");
		System.exit(exit_enum.NORMAL.get_index());
	}
}
