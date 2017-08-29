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
	WAITING(0, "Waiting"),
	PROCESSING(1, "Processing"),
	RUNNING(2, "Running"),	
	FINISHED(3, "Finished"),
	STOPPED(4, "Stopped"),
	PAUSED(5, "Paused"),
	REMOTEPROCESSIONG(6, "processing"),
	REMOTESTOPED(7, "stop"),
	REMOTEPAUSED(8, "pause"),
	UNKNOWN(9, "Unknown");
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