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

public enum url_enum {
	SVN(0, "svn"),
	HTTPS(1, "https"),
	HTTP(2, "http"),
	FTP(3, "ftp"),
	REMOTE(4, "remote"),
	LOCAL(5, "local");
	private int index;
	private String description;
	
	private url_enum(int index, String description){
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