/*
 * File: cmd_parser.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package top_control;

public interface work_state{
	void to_stop();
	
	void to_work();
	
	void to_maintain();
}

class working implements work_state{
	private tmp_manager manager;
	
	public working (tmp_manager manager){
		this.manager = manager;
	}
	
	public void to_stop(){
		System.out.println("Go to stop");
	}
	
	public void to_work(){
		System.out.println("Go to stop");
	}	
	
	public void to_maintain(){
		System.out.println("Go to stop");
	}
}


class initial implements work_state{
	private tmp_manager manager;
	
	public initial (tmp_manager manager){
		this.manager = manager;
	}
	
	public void to_stop(){
		System.out.println("Go to stop");
	}
	
	public void to_work(){
		System.out.println("Go to stop");
	}	
	
	public void to_maintain(){
		System.out.println("Go to stop");
	}
}