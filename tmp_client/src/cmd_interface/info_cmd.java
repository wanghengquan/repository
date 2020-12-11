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

public enum info_cmd {
	HELP(0, "Show all commands."),
	SYSTEM(1, "Show linked host System related info."),
	MACHINE(2, "Show linked host Machine related info."),
	PREFER(3, "Show linked host Preference related info."),
	SOFTWARE(4, "INFO SOFTWARE <sw_name>, Show linked host sw_name related info."),
	CORESCRIPT(5, "Show linked host Corescript related info."),
	STATUS(6, "Show linked host status info."),
	BUILD(7, "Show linked host build info.");
	private int index;
	private String description;
	
	private info_cmd(int index, String description){
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
		for (info_cmd cmd : info_cmd.values()){
			list.add(cmd.toString());
		}
		return list;
	}
}