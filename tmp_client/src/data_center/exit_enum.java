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

public enum exit_enum {
	NORMAL(0, "Normal software eixt, all good."),
	TASK(1, "Normal software exit with some failed task/case."),
	DUMP(2, "Software core dump."),
	UPDATE(3, "Software self-update exit."),
	FLOW(4, "Software engine flow exit."),
	DATA(5, "Software engine data server exit."),
	TUBE(6, "Connect tube exit."),
	GUI(7, "Software GUI exit."),
	OTHERS(8, "Others/Unknown.");
	private int index;
	private String description;
	
	private exit_enum(int index, String description){
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