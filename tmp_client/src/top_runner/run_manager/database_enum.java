/*
 * File: public_data.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package top_runner.run_manager;

public enum database_enum {
	switch_db(1, "switch_data"),
	client_db(2, "client_data"),
	task_db(3, "task_data"),
	view_db(4, "view_data"),
	pool_db(5, "pool_data"),
	post_db(6, "post_data");
	private int index;
	private String description;
	
	private database_enum(int index, String description){
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