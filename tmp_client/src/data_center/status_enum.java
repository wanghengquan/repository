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

public enum status_enum {
	IDLE(0, "Free"),
	BUSY(1, "Busy"),
	SUSPEND(2, "Suspend"),
	UNKNOWN(3, "Unknown");
	private int index;
	private String description;
	
	private status_enum(int index, String description){
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