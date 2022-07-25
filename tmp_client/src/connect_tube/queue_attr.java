/*
 * File: public_data.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package connect_tube;

public enum queue_attr {
	GREED_MODE(0, "Run in greed mode or not"),
	MAX_THREAD(1, "Max thread number for this queue run"),
	HOST_RESTART(2, "Host restart for this queue run");
	private int index;
	private String description;
	
	private queue_attr(int index, String description){
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