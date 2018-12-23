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
	RUNNING(1, "Running"),
	PROCESSING(2, "Processing"),
	FINISHED(8, "Finished"),
	STOPPED(6, "Stopped"),
	PAUSED(4, "Paused"),
	REMOTEPROCESSIONG(3, "processing"),
	REMOTESTOPED(7, "stop"),
	REMOTEPAUSED(5, "pause"),
	REMOTEDONE(9, "done"),
	UNKNOWN(10, "Unknown");
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