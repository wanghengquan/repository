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
	TASK1(1, "Normal software exit with some TBD task/case."),
	TASK2(2, "Normal software exit with some Fail task/case."),
	USER(3, "User exit."),
	RUNENV(4, "Software runtime environment error."),
	DUMP(5, "Software core dump."),
	UPDATE(6, "Software self-update exit."),
	FLOW(7, "Software engine flow exit."),
	DATA(8, "Software engine data server exit."),
	TUBE(9, "Software tube exit."),
	GUI(10, "Software GUI exit."),
	OTHERS(11, "Others/Unknown.");
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