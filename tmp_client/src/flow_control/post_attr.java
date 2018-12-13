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

public enum post_attr {
	call_back(0, "call_back"),
	call_id(1, "call_id"),
	call_queue(2, "call_queue"),
	call_case(3, "call_case"),
	call_obj(4, "call_obj"),
	call_reqtime(5, "request_runtime"),
	call_gentime(6, "call_generate_time"),
	call_lautime(7, "call_launch_time"),	
	call_status(8, "call_status"),
	call_canceled(9, "call_canceled_YoN"),
	call_timeout(10, "call_timeout_YoN"),
	call_terminate(11, "call_terminate_YoN"),
	call_rptdir(12, "call_rptdir");
	
	private int index;
	private String description;
	
	private post_attr(int index, String description){
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