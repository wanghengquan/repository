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
	CRN(1, "Client Restart Now, Without waiting the running tasks."),
	CRL(2, "Client Restart Later, After the running tasks finished"),
	CSN(3, "Client Shutdown Now, without waiting the running tasks."),
	CSL(4, "Client Shutdown Later, After the running tasks finished."),	
	HRN(5, "Host Machine Restart Now, without waiting the running tasks."),
	HRL(6, "Host Machine Restart Later, After the running tasks finished."),	
	HSN(7, "Host Machine Shutdown Now, without waiting the running tasks."),
	HSL(8, "Host Machine Shutdown Later, After the running tasks finished.");
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
		for (action_cmd cmd : action_cmd.values()){
			list.add(cmd.toString());
		}
		return list;
	}

}