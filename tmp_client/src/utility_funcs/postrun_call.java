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
import java.util.concurrent.Callable;

import org.apache.commons.io.FileUtils;

import data_center.public_data;
import flow_control.task_enum;
import utility_funcs.system_cmd;

public class postrun_call implements Callable<Object> {
	private long start_time = 0;
	private String case_path;
	private String report_path;
	private String save_space;
	private String work_space;
	private String save_suite;
	private String save_path;
	private task_enum cmd_status;
	private String local_clean; //auto, keep, remove. cleanup the local folder
	private String result_keep; //auto, zipped, unzipped .how to copy case wi/wo zip
	private ArrayList<String> error_msg = new ArrayList<String>();
	//private String line_separator = System.getProperty("line.separator");

	public postrun_call(
			String case_path,
			String report_path,
			String work_space,
			String save_space,
			String save_suite,
			String save_path,
			task_enum cmd_status,
			String local_clean,
			String result_keep) {
		this.case_path = case_path;
		this.report_path = report_path;
		this.save_space = save_space;
		this.work_space = work_space;
		this.save_suite = save_suite;
		this.save_path = save_path;
		this.cmd_status = cmd_status;
		this.local_clean = local_clean;
		this.result_keep = result_keep;
	}

	public Object call() throws Exception {
		Boolean run_status = new Boolean(true);
		start_time = System.currentTimeMillis() / 1000;
		//cleanup run processes
		if (!run_process_cleanup(case_path)){
			run_status = false;
		}
		//cleanup run dir
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
	
	private Boolean run_disk_cleanup(
			String report_path,
			String save_space,
			String work_space,
			String save_suite,
			String save_path,
			String local_clean,
			String result_keep){
		Boolean run_status = new Boolean(true);
		//task 1: copy run results
        String[] tmp_space = save_space.split(",");
        String[] tmp_suite = save_suite.split(",");
        String[] tmp_path = save_path.split(",");
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
    				error_msg.add("Create top leve save suite folder failed.");
    				run_status = false;
    				continue;
    			}
    		}          
            //start detail case copy
            switch (result_keep.toLowerCase()) {
                case "zipped":
                    if(!copy_case_to_save_path(report_path, save_path_index, "archive")) run_status = false;
                    break;
                case "unzipped":
                    if(!copy_case_to_save_path(report_path, save_path_index, "source")) run_status = false;
                    break;
                default:// auto and any other inputs treated as auto
                    if (cmd_status.equals(task_enum.PASSED)) {
                        if(!copy_case_to_save_path(report_path, save_path_index, "archive")) run_status = false;
                    } else {
                        if(!copy_case_to_save_path(report_path, save_path_index, "source")) run_status = false;
                    }
            }            
        }
        if (!run_status){
        	return run_status;
        }
        //task 2: copy ok, start delete local copy
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
	
	private Boolean run_process_cleanup(String clean_work_path) {
		String cmd = "python " + public_data.TOOLS_KILL_PROCESS + " " + clean_work_path;
		ArrayList<String> excute_retruns = new ArrayList<String>();
		try {
			excute_retruns = system_cmd.run(cmd);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			error_msg.add("Run process cleanup failed: " + cmd);
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
			return false;
		}
	}	
	
	public Boolean copy_case_to_save_path(
			String case_path, 
			String save_path, 
			String copy_type) {
		//save_suite: top path for all save cases
		Boolean copy_status = new Boolean(true);
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
				error_msg.add("Case remote save path create failed, Skip case copy");
				copy_status = false;
				return copy_status;
			}
		}
		if (!save_path_fobj.canWrite()) {
			error_msg.add("Case remote save path not writeable, Skip case copy");
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
			} catch (IOException e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
				error_msg.add("Copy source case failed, Skip this case");
				copy_status = false;
			}
		} else if (copy_type.equals("archive")) {
			file_action.zipFolder(case_path_obj.getAbsolutePath().toString().replaceAll("\\\\", "/"),
					save_dest_file.toString());
			save_dest_file.setReadable(true, false);
			save_dest_file.setWritable(true, false);
		} else {
			error_msg.add("Wrong copy type given, skip");
			copy_status = false;
		}
		return copy_status;
	}
	
}
