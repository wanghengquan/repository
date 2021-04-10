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

public enum pool_attr {
	call_back(0, "call_back"),
	call_queue(1, "call_queue_name"),
	call_case(2, "call_case_id"),
	call_laudir(3, "call_launch_directory"),
    call_casedir(4, "call_case_directory"),
    call_caseurl(5, "call_case_url"),
	call_gentime(6, "call_generate_time"),
	call_lautime(7, "call_launch_time"),
    call_reqtime(8, "request_runtime"),
    call_status(9, "call_status"),
	call_canceled(10, "call_canceled_YoN"),
	call_timeout(11, "call_timeout_YoN"),
	call_terminate(12, "call_terminate_YoN"),
    call_output(13, "call_output");
	private int index;
	private String description;
	
	private pool_attr(int index, String description){
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