/*
 * File: public_data.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package flow_control;

public enum cmd_attr {
	command(0, "Command line string"),
	environ(1, "Command run environment"),
    exectrl(2, "Command run condision"),
    deptool(3, "Command run tool depends");
	private int index;
	private String description;
	
	private cmd_attr(int index, String description){
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