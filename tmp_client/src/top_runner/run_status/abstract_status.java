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

	public String get_current_status() {
		String current_status = getClass().getName();
		return current_status.substring(current_status.lastIndexOf('.') + 1);
	}
}