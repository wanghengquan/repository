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


public enum zip_enum {
	NO(0, "no"),
	//Format 7z
	SEVENZ(1, ".7z"),
	//Format BZIP2
	BZ2(2, ".bz2"),
	BZIP2(3, ".bzip2"),
	TBZ2(4, ".tbz2"),
	TBZ(5, ".tbz"),
	//Format GZIP
	GZ(6, ".gz"),
	GZIP(7, ".gzip"),
	TGZ(8, ".tgz"),
	//Format TAR
	TAR(9, ".tar"),
	//Format ZIP
	ZIP(10, ".zip"),
	//Format mixed
	TARGZ(11, ".tar.gz"),
	TARBZ(12, ".tar.bz"),
	TARBZ2(13, ".tar.bz2"),
	//Format unknown
	UNKNOWN(14, "unknown");
	private int index;
	private String description;
	
	private zip_enum(int index, String description){
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