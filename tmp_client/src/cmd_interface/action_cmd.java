/*
 * File: public_data.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package cmd_interface;

import java.util.ArrayList;

public enum action_cmd {
	HELP(0, "Show all commands."),
	RCN(1, "Restart Client Now, Without waiting the running tasks."),
	RCL(2, "Restart Client Later, After the running tasks finished"),
	RHN(3, "Restart Host Machine Now, without waiting the running tasks."),
	RHL(4, "Restart Host Machine Later, After the running tasks finished."),	
	SCN(5, "Shutdown Client Now, without waiting the running tasks."),
	SCL(6, "Shutdown Client Later, After the running tasks finished."),
	SHN(7, "Shutdown Host Machine Now, without waiting the running tasks."),
	SHL(8, "Shutdown Host Machine Later, After the running tasks finished.");
	private int index;
	private String description;
	
	private action_cmd(int index, String description){
		this.index = index;
		this.description = description;
	}
	
	public int get_index(){
		return this.index;
	}
	
	public String get_description(){
		return this.description;
	}	
	
	public static ArrayList<String> get_value_list(){
		ArrayList<String> list = new ArrayList<String>();
		for (task_cmd cmd : task_cmd.values()){
			list.add(cmd.get_description());
		}
		return list;
	}

}