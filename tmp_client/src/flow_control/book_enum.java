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

public enum book_enum {
	UNKNOWN(0, "Unknown"),
	REQ_CPU(1, "req_cpu"),
	REQ_MEM(2, "req_mem"),
	REQ_SPC(3, "req_space"),
	REQ_SQH(4, "req_squish"),
	SYS_SWS(5, "sys_software"),
	EST_MEM(6, "est_mem"),
	EST_SPC(7, "est_space"),
	EST_THD(8, "est_thread");
	private int index;
	private String description;
	
	private book_enum(int index, String description){
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