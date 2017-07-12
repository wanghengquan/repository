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

public abstract class client_state {
	protected tmp_manager client;

	public abstract void to_stop();

	void to_work() {
	}

	void to_maintain() {
	}

	public String get_current_status() {
		String current_status = getClass().getName();
		return current_status.substring(current_status.lastIndexOf('.') + 1);
	}

}

class work_state extends client_state {
	private tmp_manager manager;

	public work_state(tmp_manager manager) {
		this.manager = manager;
	}

	public void to_stop() {
		System.out.println("Go to stop");
	}

	public void to_work() {
		System.out.println("Go to work");
	}

	public void to_maintain() {
		System.out.println("Go to maintain");
	}
}

class maintain_state extends client_state {
	private tmp_manager manager;

	public maintain_state(tmp_manager manager) {
		this.manager = manager;
	}

	public void to_stop() {
		System.out.println("Go to stop");
	}

	public void to_work() {
		System.out.println("Go to work");
	}

	public void to_maintain() {
		System.out.println("Go to maintain");
	}
}

class initial_state extends client_state {
	private tmp_manager manager;

	public initial_state(tmp_manager manager) {
		this.manager = manager;
	}

	public void to_stop() {
		System.out.println("Go to stop");
	}

	public void to_work() {
		System.out.println("Go to work");
	}

	public void to_maintain() {
		System.out.println("Go to maintain");
	}
}