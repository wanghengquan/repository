/*
 * File: client_state.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package top_runner.run_status;

public abstract class abstract_status {
	protected client_status client;

	public abstract_status(client_status client) {
		this.client = client;
	}

	public abstract void to_stop();

	void to_work() {
	}

	void to_maintain() {
	}

	void do_state_things(){
		
	}
	
	public state_enum get_current_status() {
		String class_name = new String("");
		String current_status = new String("");
		class_name = getClass().getName();
		current_status = class_name.substring(class_name.lastIndexOf('.') + 1);
		String state = new String("");
		state = current_status.split("_")[0];
		return state_enum.valueOf(state);
	}
	
}