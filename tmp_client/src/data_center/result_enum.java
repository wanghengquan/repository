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

public enum result_enum {
	TOTAL(0, "Total"),
	PASS(1, "Passed"),
	FAIL(2, "Failed"),
	TBD(3, "TBD"),
	TIMEOUT(4, "Timeout"),
	OTHERS(5, "Others");
	private int index;
	private String description;
	
	private result_enum(int index, String description){
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