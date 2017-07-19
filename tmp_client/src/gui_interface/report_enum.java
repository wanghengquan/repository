/*
 * File: public_data.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package gui_interface;

public enum report_enum {
	SUITE(0, "Suite setting"),
	TITLE(1, "Title setting"),
	PREVIEW(2, "Report preview"),
	GENERATE(3, "Generate a report");
	private int index;
	private String description;
	
	private report_enum(int index, String description){
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