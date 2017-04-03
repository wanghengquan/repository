/*
 * File: client_state.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package top_control;

public interface client_state{
	void to_stop();
	
	void to_work();
	
	void to_maintain();
}

class work_state implements client_state{
	private tmp_manager manager;
	
	public work_state (tmp_manager manager){
		this.manager = manager;
	}
	
	public void to_stop(){
		System.out.println("Go to stop");
	}
	
	public void to_work(){
		System.out.println("Go to work");
	}	
	
	public void to_maintain(){
		System.out.println("Go to maintain");
	}
}

class maintain_state implements client_state{
	private tmp_manager manager;
	
	public maintain_state (tmp_manager manager){
		this.manager = manager;
	}
	
	public void to_stop(){
		System.out.println("Go to stop");
	}
	
	public void to_work(){
		System.out.println("Go to work");
	}	
	
	public void to_maintain(){
		System.out.println("Go to maintain");
	}
}

class initial_state implements client_state{
	private tmp_manager manager;
	
	public initial_state (tmp_manager manager){
		this.manager = manager;
	}
	
	public void to_stop(){
		System.out.println("Go to stop");
	}
	
	public void to_work(){
		System.out.println("Go to work");
	}	
	
	public void to_maintain(){
		System.out.println("Go to maintain");
	}
}