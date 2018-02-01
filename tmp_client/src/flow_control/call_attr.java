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

public enum call_attr {
	call_back(0, "call_back"),
	queue_name(1, "queue_name"),
	case_id(2, "case_id"),
	launch_path(3, "launch_path"),
	start_time(4, "start_time"),
	time_out(5, "time_out"),
	call_canceled(6, "call_canceled"),
	call_timeout(7, "call_timeout"),
	call_terminate(8, "call_terminate");
	private int index;
	private String description;
	
	private call_attr(int index, String description){
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