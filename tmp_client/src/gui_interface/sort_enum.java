/*
 * File: public_data.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package gui_interface;

public enum sort_enum {
	PRIORITY(0, "Sorting with Priority"),
	RUNID(1, "Sorting with RunID"),
	TIME(2, "Sorting with Time"),
	DEFAULT(3, "Default sorting");
	private int index;
	private String description;
	
	private sort_enum(int index, String description){
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