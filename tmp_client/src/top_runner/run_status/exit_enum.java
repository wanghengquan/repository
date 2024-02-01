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
	TASK3(3, "Normal software exit, user timeout detected."),
	USER(4, "User GUI normal exit."),
	RUNENV(5, "Software runtime environment error."),
	DUMP(6, "Software core dump."),
	UPDATE(7, "Software self-update exit."),
	FLOW(8, "Software engine flow exit."),
	DATA(9, "Software engine data server exit."),
	TUBE(10, "Software tube exit."),
	GUI(11, "Software GUI exit."),
	CRN(12, "Client restart now exit."),
	CRL(13, "Client restart later exit."),
	CSN(14, "Client shutdown now exit."),
	CSL(15, "Client shutdown later exit."),
	HRN(16, "Host machine restart now exit."),
	HRL(17, "Host machine restart later exit."),
	HSN(18, "Host machine shutdown now exit."),
	HSL(19, "Host machine shutdown later exit."),
	OTHERS(20, "Others/Unknown.");
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