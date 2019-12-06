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

public enum exit_enum {
	NORMAL(0, "Normal software exit, all good."),
	TASK1(1, "Normal software exit with some TBD task/case."),
	TASK2(2, "Normal software exit with some Fail task/case."),
	USER(3, "User GUI normal exit."),
	RUNENV(4, "Software runtime environment error."),
	DUMP(5, "Software core dump."),
	UPDATE(6, "Software self-update exit."),
	FLOW(7, "Software engine flow exit."),
	DATA(8, "Software engine data server exit."),
	TUBE(9, "Software tube exit."),
	GUI(10, "Software GUI exit."),
	CRN(11, "Client restart now exit."),
	CRL(12, "Client restart later exit."),
	CSN(13, "Client shotdown now exit."),
	CSL(14, "Client shotdown later exit."),
	HRN(15, "Host machine restart now exit."),
	HRL(16, "Host machine restart later exit."),
	HSN(17, "Host machine shotdown now exit."),
	HSL(18, "Host machine shotdown later exit."),
	OTHERS(19, "Others/Unknown.");
	private int index;
	private String description;
	
	private exit_enum(int index, String description){
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