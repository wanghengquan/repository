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
	I(2, "Show linked host client info."),
	INFO(3, "Show linked host client info."),
	T(4, "Show linked Client task info."),
	TASK(5, "Show linked Client task info."),
	A(6, "Show linked Client available actions."),
	ACTION(7, "Show linked Client available actions."),
	D(8, "Show linked Client database info."),
	DATABASE(9, "Show linked Client database info."),
	TH(10, "Show linked Client threads status."),
	THREAD(11, "Show linked Client threads status."),
	L(12, "Link to remote machine, default is localhost."),
	LINK(13, "Link to remote machine, default is localhost."),
	IT(14, "Insert data into client database."),
	INSERT(15, "Insert data into client database."),
	E(16, "Exit Client Inteactive Mode."),
	EXIT(17, "Exit Client Inteactive Mode.");
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