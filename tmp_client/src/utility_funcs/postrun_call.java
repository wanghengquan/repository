/*
 * File: system_cmd.java
 * Description: run system command line
 * Author: Jason.Wang
 * Date:2018/12/11
 * Modifier:
 * Date:
 * Description:
 */
package utility_funcs;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.concurrent.Callable;

import org.apache.commons.io.FileUtils;

import connect_tube.task_data;
import data_center.public_data;
import flow_control.task_enum;
//import utility_funcs.system_cmd;

public class postrun_call implements Callable<Object> {
	private long start_time = 0;
	private String queue_name;
	private String case_path;
	private task_data task_info;
	private String report_path;
	private String save_space;
	private String work_space;
	private String save_suite;
	private String work_suite;
	private String save_path;
	private task_enum cmd_status;
	private String local_clean; //auto, keep, remove. cleanup the local folder
	private String result_keep; //auto, zipped, unzipped .how to copy case wi/wo zip
	private HashMap<String, String> tools_data;
	public ArrayList<String> run_msg = new ArrayList<String>();
	private String line_separator = System.getProperty("line.separator");

	public postrun_call(
			String queue_name,
			String case_path,
			task_data task_info,
			String report_path,
			String work_space,
			String work_suite,
			String save_space,
			String save_suite,
			String save_path,
			task_enum cmd_status,
			String local_clean,
			String result_keep,
			HashMap<String, String> tools_data
			) {
		this.queue_name = queue_name;
		this.case_path = case_path;
		this.task_info = task_info;
		this.report_path = report_path;
		this.save_space = save_space;
		this.work_space = work_space;
		this.work_suite = work_suite;
		this.save_suite = save_suite;
		this.save_path = save_path;
		this.cmd_status = cmd_status;
		this.local_clean = local_clean;
		this.result_keep = result_keep;
		this.tools_data = tools_data;
	}

	public Object call() throws Exception {
		Boolean run_status = Boolean.valueOf(true);
		start_time = System.currentTimeMillis() / 1000;
		//cleanup run processes
		if (!run_process_cleanup(case_path)){
			run_status = false;
		}
		//generate case space usage info
		if (!run_case_space_update(queue_name, case_path)) {
			run_status = false;
		}
		//generate local scan report
		if (!run_local_scan_report_generate(report_path, work_suite)){
			run_status = false;
		}
		//generate remote scan report
		if (!run_remote_scan_report_generate(report_path, save_space, work_space, save_suite)){
			run_status = false;
		}		
		//cleanup and copy run dir
		if (!run_disk_cleanup(report_path, save_space, work_space, save_suite, save_path, local_clean, result_keep)){
			run_status = false;
		}
		return run_status;
	}
	
	public long get_start_time(){
		return this.start_time;
	}
	
	public String get_report_path(){
		return this.report_path;
	}	
	
	private Boolean run_case_space_update(
			String queue_name,
			String case_path
			) {
		Boolean run_status = Boolean.valueOf(true);
        float used_space = public_data.TASK_DEF_ESTIMATE_SPACE;
		File file = new File(case_path);
		try {
			used_space = FileUtils.sizeOfDirectory(file) / (float)1024 / (float)1024 / (float)1024; ;
		} catch (Exception e) {
			run_msg.add("Case space check error.");
			//e.printStackTrace();
		} finally {
			;
		}
		task_info.update_client_run_case_summary_space_map(queue_name, used_space);
		return run_status;
	}
	
	private Boolean run_disk_cleanup(
			String report_path,
			String save_space,
			String work_space,
			String save_suite,
			String save_path,
			String local_clean,
			String result_keep
			){
		Boolean run_status = Boolean.valueOf(true);
		//task 1: copy run results
        String[] tmp_space = save_space.split("\\s*,\\s*");
        String[] tmp_suite = save_suite.split("\\s*,\\s*");
        String[] tmp_path = save_path.split("\\s*,\\s*");
        String os_type = System.getProperty("os.name").toLowerCase();
        for(int i=0; i<tmp_space.length; i++) {
            String save_space_index = tmp_space[i].trim();
            String save_suite_index = tmp_suite[i].trim();
            String save_path_index = tmp_path[i].trim();
            if (save_space_index.equalsIgnoreCase(work_space)) {
                continue;
            }
            if (save_space_index.trim().equals("")) {
                // no save path, skip copy
                continue;
            }
            //skip unreachable path
            if (os_type.contains("windows")) {
            	if (save_suite_index.startsWith("/")) {
            		run_msg.add("Windows clinet cannot access linux storage.");
            		continue;
            	}
            }
            if (os_type.contains("linux")) {
            	if (!save_suite_index.startsWith("/")) {
            		run_msg.add("Linux clinet cannot access Windows storage.");
            		continue;
            	}
            }
            //make suite level folder
    		File save_suite_fobj = new File(save_suite_index);
    		if (!save_suite_fobj.exists()) {
    			try {
    				FileUtils.forceMkdir(save_suite_fobj);
    				save_suite_fobj.setReadable(true, false);
    				save_suite_fobj.setWritable(true, false);
    			} catch (IOException e) {
    				// TODO Auto-generated catch block
    				// e.printStackTrace();
    				run_msg.add("Create top leve save suite folder failed.");
    				run_status = false;
    				continue;
    			}
    		}
    		//backup original results
    		backup_previous_results(report_path, save_path_index);
            //start detail case copy
            switch (result_keep.toLowerCase()) {
                case "zipped":
                    if(!copy_case_to_save_path(report_path, save_path_index, "archive")) run_status = false;
                    break;
                case "unzipped":
                    if(!copy_case_to_save_path(report_path, save_path_index, "source")) run_status = false;
                    break;
                default:// auto and any other inputs treated as auto
                	if (lsv_storage_identify(save_path_index)) {
                		if (cmd_status.equals(task_enum.PASSED)) {
                			run_msg.add("PASSED case result copy to LSV skipped.");
                		} else {
                			if(!copy_case_to_save_path(report_path, save_path_index, "archive")) run_status = false;
                		}
                	} else if (cmd_status.equals(task_enum.PASSED)) {
                        if(!copy_case_to_save_path(report_path, save_path_index, "archive")) run_status = false;
                    } else {
                        if(!copy_case_to_save_path(report_path, save_path_index, "source")) run_status = false;
                    }
                	break;
            }            
        }
        if (!run_status){
        	run_msg.add("Remote copy Failed.");
        	return run_status;
        } else {
        	run_msg.add("Remote copy Passed.");
        }
        //task 2: copy OK, start delete local copy
        File report_path_fobj = new File(report_path);
        switch (local_clean.toLowerCase()) {
        case "keep":
            break;
        case "remove":
        	FileUtils.deleteQuietly(report_path_fobj);
            break;
        default:// auto and any other inputs treated as auto
            if (run_status) {
            	FileUtils.deleteQuietly(report_path_fobj);;
            }
        }
        return run_status;
	}
	
	private Boolean lsv_storage_identify(
			String save_path) {
		Boolean lsv_storage = Boolean.valueOf(false);
		for (String key_str: public_data.DEF_LSV_STORAGE_ID) {
			if (save_path.contains(key_str)) {
				lsv_storage = true;
				break;
			}
		}
		return lsv_storage;
	}
	
	private Boolean run_local_scan_report_generate(
			String report_path,
			String work_suite){
		Boolean run_status = Boolean.valueOf(false);
		//task 1: local scan data
		String suite_scan_file = new String(work_suite + "/" + public_data.SUITE_DATA_REPORT_NAME);
		String suite_lock_file = new String(work_suite + "/" + public_data.SUITE_LOCK_FILE_NAME);
		File suite_scan_file_obj = new File(suite_scan_file);
		String task_name = new File(report_path).getName();
		String case_scan_file = new String(report_path + "/" + task_name + ".csv");
		File case_scan_file_obj = new File(case_scan_file);
		if (!case_scan_file_obj.exists()){
			return true;
		}
		Boolean get_suite_locked = file_action.gen_lock_file(suite_lock_file);
		if (!get_suite_locked){
			run_msg.add("Cannot generate local suite lock file, skip local scan report.");
			return run_status;
		}		
		if (!suite_scan_file_obj.exists()){
			file_action.copy_file(case_scan_file, suite_scan_file);
		} else {
			ArrayList<String> file_lines = new ArrayList<String>();
			file_lines.addAll(file_action.read_file_lines(case_scan_file));
			file_action.append_file(suite_scan_file, file_lines.get(file_lines.size() -1)  + line_separator);
		}
		file_action.del_lock_file(suite_lock_file);
		run_msg.add("Local scan report generated:" + suite_scan_file);
		run_status = true;
        return run_status;
	}
	
	private Boolean run_remote_scan_report_generate(
			String report_path,
			String save_space,
			String work_space,
			String save_suite){
		Boolean run_status = Boolean.valueOf(true);
		String task_name = new File(report_path).getName();
		String case_scan_file = new String(report_path + "/" + task_name + ".csv");
		File case_scan_file_obj = new File(case_scan_file);
		if (!case_scan_file_obj.exists()){
			return true;
		}
		//task 1: copy run results
        String[] tmp_space = save_space.split("\\s*,\\s*");
        String[] tmp_suite = save_suite.split("\\s*,\\s*");
        for(int i=0; i<tmp_space.length; i++) {
            String save_space_index = tmp_space[i].trim();
            String save_suite_index = tmp_suite[i].trim();
            if (save_space_index.equalsIgnoreCase(work_space)) {
            	run_msg.add("Ignore remote scan report: save space same as work space");
                continue;
            }
            if (save_space_index.trim().equals("")) {
                // no save path, skip copy
                continue;
            }
            File save_space_fobj = new File(save_space_index);
            if (!save_space_fobj.exists()) {
                // no save path, skip copy
            	run_msg.add("Ignore remote scan report: save space do not exists: " + save_space_index);
                continue;            	
            }
            //make suite level folder
    		File save_suite_fobj = new File(save_suite_index);
    		if (!save_suite_fobj.exists()) {
    			try {
    				FileUtils.forceMkdir(save_suite_fobj);
    				save_suite_fobj.setReadable(true, false);
    				save_suite_fobj.setWritable(true, false);
    			} catch (IOException e) {
    				// TODO Auto-generated catch block
    				// e.printStackTrace();
    				run_msg.add("Create top leve save suite folder failed.");
    				run_status = false;
    				continue;
    			}
    		}
    		//start generate scan data file
    		String suite_scan_file = new String(save_suite_index + "/" + public_data.SUITE_DATA_REPORT_NAME);
    		String suite_lock_file = new String(save_suite_index + "/" + public_data.SUITE_LOCK_FILE_NAME);
    		File suite_scan_file_obj = new File(suite_scan_file);
    		Boolean get_suite_locked = file_action.gen_lock_file(suite_lock_file);
    		if (!get_suite_locked){
    			run_msg.add("Cannot generate remote suite lock file, skip local scan report.");
    			run_status = false;
    			continue;
    		}
    		if (!suite_scan_file_obj.exists()){
    			file_action.copy_file(case_scan_file, suite_scan_file);
    		} else {
    			ArrayList<String> file_lines = new ArrayList<String>();
    			file_lines.addAll(file_action.read_file_lines(case_scan_file));
    			file_action.append_file(suite_scan_file, file_lines.get(file_lines.size() -1)  + line_separator);
    		}
    		file_action.del_lock_file(suite_lock_file); 
    		run_msg.add("Remote scan report generated:" + suite_scan_file);
        }
        return run_status;
	}
	
	private Boolean run_process_cleanup(String clean_work_path) {
		String python_cmd = new String(tools_data.getOrDefault("python", public_data.DEF_PYTHON_PATH));
		String cmd = python_cmd + " " + public_data.TOOLS_KILL_PROCESS + " " + clean_work_path;
		run_msg.add("Process cleanup cmd: " + cmd);
		ArrayList<String> excute_retruns = new ArrayList<String>();
		try {
			excute_retruns = system_cmd.run(cmd);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			run_msg.add("Run process cleanup failed: " + cmd);
			return false;
		}
		Boolean finish_clean = false;
		for (String line : excute_retruns) {
			if (line.equalsIgnoreCase("Scan_finished")) {
				finish_clean = true;
				break;
			}
		}
		if (finish_clean) {
			return true;
		} else {
			run_msg.add("Kill process got issue, Process could be still running...");
			return false;
		}
	}
	
	public Boolean copy_case_to_save_path(
			String case_path, 
			String save_path, 
			String copy_type) {
		//save_suite: top path for all save cases
		Boolean copy_status = Boolean.valueOf(true);
		if (case_path.equalsIgnoreCase(save_path)){
			return copy_status;
		}
		File save_path_fobj = new File(save_path);
		if (!save_path_fobj.exists()) {
			try {
				FileUtils.forceMkdir(save_path_fobj);
				save_path_fobj.setReadable(true, false);
				save_path_fobj.setWritable(true, false);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
				run_msg.add("Case remote save path create failed, Skip case copy");
				copy_status = false;
				return copy_status;
			}
		}
		if (!save_path_fobj.canWrite()) {
			run_msg.add("Case remote save path not writeable, Skip case copy");
			copy_status = false;
			return copy_status;
		}
		File case_path_obj = new File(case_path);
		String case_folder_name = case_path_obj.getName();
		File save_dest_folder = new File(save_path, case_folder_name);
		File save_dest_file = new File(save_path, case_folder_name + ".zip");
		if (save_dest_folder.exists()) {
			FileUtils.deleteQuietly(save_dest_folder);
		}
		if (save_dest_file.exists()) {
			FileUtils.deleteQuietly(save_dest_file);
		}
		if (copy_type.equals("source")) {
			try {
				FileUtils.copyDirectory(case_path_obj, save_dest_folder);
				save_dest_folder.setReadable(true, false);
				save_dest_folder.setWritable(true, false);
				//for Linux copy extra run needed
				String host_run = System.getProperty("os.name").toLowerCase();
				if (host_run.startsWith("linux")) {
					system_cmd.run("chmod -R 777 " + save_dest_folder);
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
				run_msg.add("Copy source case failed, Skip this case");
				copy_status = false;
			}
		} else if (copy_type.equals("archive")) {
			file_action.zipFolder(case_path_obj.getAbsolutePath().toString().replaceAll("\\\\", "/"),
					save_dest_file.toString());
			save_dest_file.setReadable(true, false);
			save_dest_file.setWritable(true, false);
			save_dest_file.setExecutable(true, false);
		} else {
			run_msg.add("Wrong copy type given, skip");
			copy_status = false;
		}
		return copy_status;
	}
	
	private Boolean backup_previous_results(
			String case_path, 
			String save_path) {
		Boolean bak_status = Boolean.valueOf(true);
		if (case_path.equalsIgnoreCase(save_path)){
			return bak_status;
		}
		File case_path_obj = new File(case_path);
		String case_folder_name = case_path_obj.getName();
		File save_dest_folder = new File(save_path, case_folder_name);
		File save_dest_file = new File(save_path, case_folder_name + ".zip");
		String m_time = new String("");
		try {
			if (save_dest_folder.exists()) {
				m_time = time_info.get_date_time(save_dest_folder.lastModified());
				save_dest_folder.renameTo(new File(save_path, case_folder_name + "_" + m_time));
			}
			if (save_dest_file.exists()) {
				m_time = time_info.get_date_time(save_dest_file.lastModified());
				save_dest_file.renameTo(new File(save_path, case_folder_name + "_" + m_time + ".zip"));
			}
		} catch (Exception e) {
			run_msg.add("Result back up error:" + case_folder_name);
			bak_status = false;
		}
		return bak_status;
	}
	
}
