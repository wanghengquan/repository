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
	WAITING(0, "Waiting"),
	PROCESSING(1, "Processing"),
	PASSED(2, "Passed"),
	FAILED(3, "Failed"),
	TBD(4, "TBD"),
	TIMEOUT(5, "Timeout"),
	CASEISSUE(6, "Case Issue"),
	SWISSUE(7, "SW Issue"),
	BLOCKED(8,"Blocked"),
	OTHERS(9, "Others"),
	UNKNOWN(10, "Unknown");
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