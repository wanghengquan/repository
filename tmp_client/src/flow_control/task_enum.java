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

public enum task_enum {
	UNKNOWN(0, "Unknown"),
	WAITING(1, "Waiting"),
	PROCESSING(2, "Processing"),
	PASSED(3, "Passed"),
	FAILED(4, "Failed"),
	TBD(5, "TBD"),
	TIMEOUT(6, "Timeout"),
	HALTED(7, "Halted"),
	CASEISSUE(8, "Case_Issue"),
	SWISSUE(9, "SW_Issue"),
	BLOCKED(10,"Blocked"),
	OTHERS(11, "Others");
	private int index;
	private String description;
	
	private task_enum(int index, String description){
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