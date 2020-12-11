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

public enum task_cmd {
	HELP(0, "Show all commands."),
	RECEIVED(1, "Show received task info."),
	CAPTURED(2, "Show captured task info."),
	REJECTED(3, "Show rejected task info."),
	PAUSED(4, "Show paused task info."),
	STOPPED(5, "Show stopped task info."),
	PROCESSING(6, "Show processing task info."),
	EXECUTING(7, "Show executing task info."),
	PENDING(8, "Show pending task info."),
	RUNNING(9, "Show running task info."),
	WAITING(10, "Show waiting task info."),
	EMPTIED(11, "Show emptied task info."),
	FINISHED(12, "Show finished task info.");
	private int index;
	private String description;
	
	private task_cmd(int index, String description){
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
			list.add(cmd.toString());
		}
		return list;
	}

}