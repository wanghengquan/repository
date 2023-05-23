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

public enum insert_cmd {
	HELP(0, "Show all commands."),
	SWITCH(1, "Insert data to switch database"),
	CLIENT(2, "Insert data to client database"),
	VIEW(3, "Insert data to view database"),
	TASK(4, "Insert data to task database"),
	POOL(5, "Insert data to pool database"),
	POST(6, "Insert data to post database");
	private int index;
	private String description;
	
	private insert_cmd(int index, String description){
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
		for (insert_cmd cmd : insert_cmd.values()){
			list.add(cmd.toString());
		}
		return list;
	}

}