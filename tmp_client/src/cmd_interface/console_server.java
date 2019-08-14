/*
 * File: view_server.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package cmd_interface;

import java.io.IOException;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.jline.reader.Completer;
import org.jline.reader.LineReader;
import org.jline.reader.LineReaderBuilder;
import org.jline.reader.impl.completer.AggregateCompleter;
import org.jline.reader.impl.completer.ArgumentCompleter;
import org.jline.reader.impl.completer.NullCompleter;
import org.jline.reader.impl.completer.StringsCompleter;
import org.jline.reader.impl.history.DefaultHistory;
import org.jline.terminal.Terminal;
import org.jline.terminal.TerminalBuilder;

import data_center.exit_enum;
import data_center.public_data;
import data_center.switch_data;

public class console_server extends Thread {
	// public property
	// protected property
	// private property
	// public function
	// protected function
	// private function
	private static final Logger CONSOLE_SERVER_LOGGER = LogManager.getLogger(console_server.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread console_thread;
	private switch_data switch_info;
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;	

	public console_server(switch_data switch_info) {
		this.switch_info = switch_info;
	}


	private Completer get_top_completer(){
		Completer help_completer = new ArgumentCompleter(
		        new StringsCompleter("help", "h"),
		        NullCompleter.INSTANCE
		);
		
		Completer client_completer = new ArgumentCompleter(
		        new StringsCompleter("info", "I"),
		        new StringsCompleter("help", "system" , "machine" , "preference"),
		        NullCompleter.INSTANCE
		);
		
		Completer task_completer = new ArgumentCompleter(
		        new StringsCompleter("task", "T"),
		        new StringsCompleter("help", "finished" , "running" , "received" , "rejected" , "captured"),
		        NullCompleter.INSTANCE
		);
		
		Completer action_completer = new ArgumentCompleter(
		        new StringsCompleter("action", "A"),
		        new StringsCompleter("help", "restart_now" , "restart_later" , "shutdown_now" , "shutdown_later" , "rn", "rl", "sn", "sl"),
		        NullCompleter.INSTANCE
		);
		
		Completer connect_completer = new ArgumentCompleter(
		        new StringsCompleter("connect", "C"),
		        new StringsCompleter("help"),
		        NullCompleter.INSTANCE
		);
		
		Completer top_completer = new AggregateCompleter(
				help_completer,
				client_completer,
				task_completer,
				action_completer,
				connect_completer
		);
		return top_completer;
	}
	
	public void run() {
		try {
			monitor_run();
		} catch (Exception run_exception) {
			run_exception.printStackTrace();
			switch_info.set_client_stop_exception(run_exception);
			switch_info.set_client_stop_request(exit_enum.DUMP);
		}
	}
	
	private void monitor_run() {
		console_thread = Thread.currentThread();
		// ============== All static job start from here ==============
		// initial 1 : prepare terminal
		Terminal terminal = null;
		try {
			terminal = TerminalBuilder.builder()
			        .system(true)
			        .build();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}		
		// initial 2 : prepare line reader
		LineReader lineReader = LineReaderBuilder.builder()
		        .terminal(terminal)
		        .completer(get_top_completer())
		        .history(new DefaultHistory())
		        .build();		
		switch_info.set_console_server_power_up();
		while (!stop_request) {
			if (wait_request) {
				try {
					synchronized (this) {
						this.wait();
					}
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} else {
				CONSOLE_SERVER_LOGGER.debug("Console Server running...");
			}
			// ============== All dynamic job start from here ==============
			// task 1: process the input
			String user_inputs = new String("");
			user_inputs = lineReader.readLine(public_data.TERMINAL_DEF_PROMPT);
			// task 2: print the answer
			System.out.println(user_inputs);
			try {
				Thread.sleep(base_interval * 1 * 1);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	public void soft_stop() {
		stop_request = true;
	}

	public void hard_stop() {
		stop_request = true;
		if (console_thread != null) {
			console_thread.interrupt();
		}
	}

	public void wait_request() {
		wait_request = true;
	}

	public void wake_request() {
		wait_request = false;
		synchronized (this) {
			this.notify();
		}
	}
	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		switch_data switch_info = new switch_data();
		console_server my_terminal = new console_server(switch_info);
		my_terminal.start();
	}
}
