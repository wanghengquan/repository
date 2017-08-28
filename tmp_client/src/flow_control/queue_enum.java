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

public enum queue_enum {
	PROCESSING(0, "Processing"),
	RUNNING(1, "Running"),	
	FINISHED(2, "Finished"),
	STOPPED(3, "Stopped"),
	PAUSED(4, "Paused");
	private int index;
	private String description;
	
	private queue_enum(int index, String description){
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