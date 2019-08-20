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

public enum link_cmd {
	HELP(0, "Show all commands.");
	private int index;
	private String description;
	
	private link_cmd(int index, String description){
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