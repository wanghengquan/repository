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

public enum thread_enum {
	top_runner(1, "client_manager"),
	view_runner(2, "view_server"),
	console_runner(3, "console_server"),
	data_runner(4, "data_server"),
	link_runner(5, "link_server"),
	hall_runner(6, "hall_manager"),
	tube_runner(7, "tube_server"),
	config_runner(8, "config_sync"),
	machine_runner(9, "machine_sync"),
	task_runner(10, "task_waiter"),
	result_runner(11, "result_waiter");
	private int index;
	private String description;
	
	private thread_enum(int index, String description){
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