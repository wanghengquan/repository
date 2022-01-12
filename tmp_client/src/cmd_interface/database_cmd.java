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

public enum database_cmd {
	HELP(0, "Show all commands."),
	SWITCH(1, "Show linked host Switch Database info."),
	CLIENT(2, "Show linked host Client Database info."),
	VIEW(3, "Show linked host View Database info."),
	TASK(4, "Show linked host Task Database info."),
	POOL(5, "Show linked host Pool Database info."),
	POST(6, "Show linked host Post Database info.");
	private int index;
	private String description;
	
	private database_cmd(int index, String description){
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
		for (database_cmd cmd : database_cmd.values()){
			list.add(cmd.toString());
		}
		return list;
	}
}