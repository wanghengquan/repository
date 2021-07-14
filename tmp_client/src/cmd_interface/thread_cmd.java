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

public enum thread_cmd {
	HELP(0, "Show all commands."),
	STATUS(1, "Show linked client background thread status."),
	PLAY(2, "Run specified thread, Thread name should be followed"),
	PAUSE(3, "Pause specified thread, Thread name should be followed"),
	STOP(4, "Stop specified thread, Thread name should be followed");
	private int index;
	private String description;
	
	private thread_cmd(int index, String description){
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
		for (thread_cmd cmd : thread_cmd.values()){
			list.add(cmd.toString());
		}
		return list;
	}
}