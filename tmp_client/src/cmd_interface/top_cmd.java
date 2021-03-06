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

public enum top_cmd {
	H(0, "Show all commands."),
	HELP(1, "Show all commands."),
	I(2, "Show linked host client data."),
	INFO(3, "Show linked host client data."),
	T(4, "Show linked host task data."),
	TASK(5, "Show linked host task data."),
	A(6, "Show linked host available actions."),
	ACTION(7, "Show linked host available actions."),
	L(8, "Link to a remote machine, default is localhost."),
	LINK(9, "Link to a remote machine, default is localhost.");
	private int index;
	private String description;
	
	private top_cmd(int index, String description){
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
		for (top_cmd cmd : top_cmd.values()){
			list.add(cmd.toString());
		}
		return list;
	}
}