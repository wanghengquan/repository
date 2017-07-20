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
	NORMAL(0, "Normal software exit, all good."),
	TASK(1, "Normal software exit with some failed task/case."),
	USER(2, "User exit."),
	RUNENV(3, "Software runtime environment error."),
	DUMP(4, "Software core dump."),
	UPDATE(5, "Software self-update exit."),
	FLOW(6, "Software engine flow exit."),
	DATA(7, "Software engine data server exit."),
	TUBE(8, "Software tube exit."),
	GUI(9, "Software GUI exit."),
	OTHERS(10, "Others/Unknown.");
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