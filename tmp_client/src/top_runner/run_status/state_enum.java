/*
 * File: public_data.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package top_runner.run_status;

public enum state_enum {
	initial(1, "Initializing"),
	work(2, "Working"),
	maintain(3, "Maintaining"),
	stop(4, "Stopped"),
	unknown(5, "Unknown");
	private int index;
	private String description;
	
	private state_enum(int index, String description){
		this.index = index;
		this.description = description;
	}
	
	public int get_index(){
		return this.index;
	}
	
	public String get_description(){
		return this.description;
	}
}

