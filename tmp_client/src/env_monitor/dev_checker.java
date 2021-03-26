package env_monitor;

import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;
import top_runner.run_status.exit_enum;
import utility_funcs.system_cmd;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;
import java.util.regex.*;

public class dev_checker extends TimerTask {
    private switch_data switch_info;
    private client_data client_info;
    private String core_addr;
    private String core_UUID = new String("NA");
    //private String svn_cmd = public_data.DEF_SVN_PATH;
    private String svn_user = public_data.SVN_USER;
    private String svn_pwd = public_data.SVN_PWD;

    public dev_checker(
    		switch_data switch_info,
    		client_data client_info) {
        this.switch_info = switch_info;
        this.client_info = client_info;
        this.core_addr = public_data.CORE_SCRIPT_REMOTE_URL;
        this.core_UUID = get_local_corescript_version(client_info.get_client_preference_data().get("work_space"));
    }

	public void run() {
		try {
			monitor_run();
		} catch (Exception run_exception) {
			run_exception.printStackTrace();
			switch_info.set_client_stop_exception(run_exception);
			switch_info.set_client_stop_request(exit_enum.DUMP);
		}
	}
	
	private void monitor_run() {
		//task 1: get remote CoreScript info
		update_remote_corescript_info();
		//task 2: generate update request
		generate_update_request();
	}
	
    private void update_remote_corescript_info(){
    	String remote_version = new String("NA");
    	String remote_time = new String("NA");
    	if (!switch_info.get_remote_corescript_linked()) {
            client_info.update_client_corescript_data("remote_version", remote_version);
            client_info.update_client_corescript_data("remote_time", remote_time);
            client_info.update_client_corescript_data("connection", "0");
    		return;
    	}
    	String svn_cmd = new String(public_data.DEF_SVN_PATH);
    	svn_cmd = client_info.get_client_tools_data().getOrDefault("svn", public_data.DEF_SVN_PATH);
        try {
            String svn_info = svn_cmd + " info " + core_addr +  " --username="
                                + svn_user + " --password=" + svn_pwd + " --no-auth-cache";
            ArrayList<String> info_return = system_cmd.run(svn_info);
            remote_version = get_version_num(info_return);
            remote_time = get_update_time(info_return);
        }catch (InterruptedException e) {
            e.printStackTrace();
        }catch (IOException e){
            e.printStackTrace();
        }
        client_info.update_client_corescript_data("remote_version", remote_version);
        client_info.update_client_corescript_data("remote_time", remote_time);
        if (remote_version.equals("NA")){
        	client_info.update_client_corescript_data("connection", "0");
        } else {
        	client_info.update_client_corescript_data("connection", "1");
        }
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

    private void generate_update_request(){
    	if (!switch_info.get_system_python_version().startsWith("3")) {
    		client_info.update_client_corescript_data("status", "NA");
    		return;
    	}
    	if (!switch_info.get_remote_corescript_linked()) {
    		client_info.update_client_corescript_data("status", "NA");
    		return;
    	}
    	//if requested already return
    	if (switch_info.get_core_script_update_request()){
    		return;
    	}
    	//if client cannot connect to SVN, return
        String new_version = get_remote_corescript_version();
        if (new_version.equals("NA")){
        	client_info.update_client_corescript_data("status", "NA");
        	return;
        } 
        //generate a new request
        if (!core_UUID.equals(new_version)) {
            System.out.println("INFO : >>>current Core script version(DEV) is: " + core_UUID);
            System.out.println("INFO : >>>new Core script version(DEV) found: " + new_version);
            core_UUID = new_version;
            client_info.update_client_corescript_data("status", "updating");
            switch_info.set_core_script_update_request(true);
        } else {
        	client_info.update_client_corescript_data("status", "latest");
        }
    }

    private String get_remote_corescript_version(){
    	String svn_cmd = new String(public_data.DEF_SVN_PATH);
    	svn_cmd = client_info.get_client_tools_data().getOrDefault("svn", public_data.DEF_SVN_PATH);
    	String remote_version = new String("NA");
        try {
            String svn_info = svn_cmd + " info " + core_addr +  " --username="
                                + svn_user + " --password=" + svn_pwd + " --no-auth-cache";
            ArrayList<String> info_return = system_cmd.run(svn_info);
            remote_version = get_version_num(info_return);
        }catch (InterruptedException e) {
            e.printStackTrace();
        }catch (IOException e){
            e.printStackTrace();
        }
        return remote_version;
    }	
    
    private String get_local_corescript_version(String work_space){
    	String svn_cmd = new String(public_data.DEF_SVN_PATH);
    	svn_cmd = client_info.get_client_tools_data().getOrDefault("svn", public_data.DEF_SVN_PATH);
    	String local_version = new String("NA");
		File svn_fobj = new File(svn_cmd);
		if (!svn_fobj.exists()) {
			return local_version;
		}
        try {
            String svn_info = svn_cmd + " info " + public_data.CORE_SCRIPT_NAME +  " --username="
                                + svn_user + " --password=" + svn_pwd + " --no-auth-cache";
            ArrayList<String> info_return = system_cmd.run(svn_info, work_space);
            local_version = get_version_num(info_return);
        } catch (IOException e){
            e.printStackTrace();
        }
        return local_version;
    }  
    
    public static void main(String[] argvs){
		Timer my_timer = new Timer();
		my_timer.scheduleAtFixedRate(new dev_checker(null, null), 1000, 5000);
    }
}