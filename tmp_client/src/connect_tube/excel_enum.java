/*
 * File: excel_enum.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2023/01/29
 * Modifier:
 * Date:
 * Description:
 */
package connect_tube;

public enum excel_enum {
	SUITE(0, "suite"),
	CASE(1, "case"),
	DESCRIPTION(2, "description"),
	COMMENTS(3, "comments");
	private int index;
	private String description;
	
	private excel_enum(int index, String description){
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