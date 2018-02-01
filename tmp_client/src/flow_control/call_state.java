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

public enum call_state {
	INITIATE(0, "Initiate"),
	PROCESSIONG(1, "Processing"),
	DONE(2, "Done");
	private int index;
	private String description;
	
	private call_state(int index, String description){
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