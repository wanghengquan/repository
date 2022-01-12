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

public enum cmd_enum {
	UNKNOWN(0, "Unknown"),
	PASSED(1, "Passed"),
	FAILED(2, "Failed"),
	TBD(3, "TBD"),
	TIMEOUT(4, "Timeout"),
	SWISSUE(5, "SW_Issue"),
	CASEISSUE(6, "Case_Issue"),
	BLOCKED(7,"Blocked");
	private int index;
	private String description;
	
	private cmd_enum(int index, String description){
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