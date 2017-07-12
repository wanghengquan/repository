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

class stop_status extends abstract_status {
	
	public stop_status(client_status client) {
		super(client);
	}

	public void to_stop() {
		System.out.println("Go to stop");
		client.set_current_status(client.STOP);
	}

	public void to_work() {
		System.out.println("Go to work");
		client.set_current_status(client.WORK);
	}

	public void to_maintain() {
		System.out.println("Go to maintain");
		client.set_current_status(client.MAINTAIN);
	}
}