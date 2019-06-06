/*
 * File: public_data.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package top_runner.run_status;

public enum maintain_enum {
	idle(1, "system_idel"),
	update(2, "core_update"),
	cpu(3, "cpu_overload"),
	mem(4, "mem_overload"),
	space(5, "no_space"),
	environ(6, "env_issue"),
	workspace(7, "work_space_update"),
	unknown(8, "unknown");
	private int index;
	private String description;
	
	private maintain_enum(int index, String description){
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