/*
 * File: public_data.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package data_center;

public enum state_enum {
	initialize(1, "initialize"),
	working(2, "working"),
	maintaining(3, "maintaining"),
	stopped(4, "stopped");
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

