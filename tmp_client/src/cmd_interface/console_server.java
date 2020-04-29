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
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

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

import connect_link.link_client;
import connect_link.link_server;
import connect_tube.task_data;
import data_center.client_data;
import data_center.data_server;
import data_center.public_data;
import data_center.switch_data;
import flow_control.pool_data;
import flow_control.post_data;
import info_parser.cmd_parser;
import info_parser.xml_parser;
import top_runner.run_status.exit_enum;

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
	private link_client linked_client = new link_client();
	private String line_separator = System.getProperty("line.separator");
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;

	public console_server(switch_data switch_info) {
		this.switch_info = switch_info;
	}


	private Completer get_top_completer(){
		Completer help_completer = new ArgumentCompleter(
		        new StringsCompleter(top_cmd.get_value_list()),
		        NullCompleter.INSTANCE
		);
		Completer client_completer = new ArgumentCompleter(
		        new StringsCompleter(top_cmd.get_value_list()),
		        new StringsCompleter(info_cmd.get_value_list()),
		        NullCompleter.INSTANCE
		);
		
		Completer task_completer = new ArgumentCompleter(
		        new StringsCompleter(top_cmd.get_value_list()),
		        new StringsCompleter(task_cmd.get_value_list()),
		        NullCompleter.INSTANCE
		);
		
		Completer action_completer = new ArgumentCompleter(
		        new StringsCompleter(top_cmd.get_value_list()),
		        new StringsCompleter(action_cmd.get_value_list()),
		        NullCompleter.INSTANCE
		);
		
		Completer connect_completer = new ArgumentCompleter(
		        new StringsCompleter(top_cmd.get_value_list()),
		        new StringsCompleter(link_cmd.get_value_list()),
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
	
	private Boolean check_user_inputs(String user_inputs){
		Boolean input_ok = new Boolean(true);
		String [] input_list = user_inputs.split("\\s+");
		if (input_list.length < 1){
			input_ok = false;
			return input_ok;
		}
		String first_word = input_list[0].toUpperCase();
		if (!top_cmd.get_value_list().contains(first_word)){
			input_ok = false;
			return input_ok;
		}
		if (input_list.length == 1){
			if (!first_word.equalsIgnoreCase("HELP") && !first_word.equalsIgnoreCase("H")){
				input_ok = false;
				return input_ok;
			}
		}
		if (input_list.length > 1){
			String second_word = input_list[1].toUpperCase();
			switch(top_cmd.valueOf(first_word)){
			case H:
				input_ok = false;
				break;
			case HELP:
				input_ok = false;
				break;
			case I:
				if (!info_cmd.get_value_list().contains(second_word)){
					input_ok = false;
				}
				break;
			case INFO:
				if (!info_cmd.get_value_list().contains(second_word)){
					input_ok = false;
				}
				break;
			case T:
				if (!task_cmd.get_value_list().contains(second_word)){
					input_ok = false;
				}
				break;
			case TASK:
				if (!task_cmd.get_value_list().contains(second_word)){
					input_ok = false;
				}
				break;
			case A:
				if (!action_cmd.get_value_list().contains(second_word)){
					input_ok = false;
				}
				break;	
			case ACTION:
				if (!action_cmd.get_value_list().contains(second_word)){
					input_ok = false;
				}
				break;	
			default:
			    break;		
			}
		}
		return input_ok;
	}
	
	private Boolean answer_user_inputs(
			String user_inputs){
		Boolean run_ok = new Boolean(true);
		String [] input_list = user_inputs.split("\\s+");		
		switch(top_cmd.valueOf(input_list[0].toUpperCase())){
		case H:
			help_command_answer();
			break;
		case HELP:
			help_command_answer();
			break;
		case I:
			info_command_answer(input_list);
			break;
		case INFO:
			info_command_answer(input_list);
			break;
		case T:
			task_command_answer(input_list);
			break;
		case TASK:
			task_command_answer(input_list);
			break;
		case A:
			action_command_answer(input_list);
			break;
		case ACTION:
			action_command_answer(input_list);			
			break;
		case L:
			link_command_answer(input_list);
			break;
		case LINK:
			link_command_answer(input_list);			
			break;			
		default:
			help_command_answer();
			break;
		}
		return run_ok;
	}	
	
	private void help_command_answer(){
		System.out.println("Welcome to TMP client console mode");
		System.out.println("TMP commends:");
		for (top_cmd cmd: top_cmd.values()){
			System.out.format("  %8s  --  %s" + line_separator, cmd.toString(), cmd.get_description());
		}
		System.out.println("You may type: '<command> help' for more info");
	}
	
	private Boolean link_command_answer(String [] cmd_list){
		Boolean link_ok = new Boolean(false);
		if(cmd_list[1].equalsIgnoreCase(link_cmd.HELP.toString())){
			link_help_command_output();
		} else {
			link_ok = linked_client.link_request(cmd_list[1]);
			if (link_ok){
				System.out.println("Client linked to:" + cmd_list[1]);
			} else {
				System.out.println("Client link to <" + cmd_list[1] + "> Failed");
				System.out.println("Client still linked to <" + linked_client.linked_host + ">");
			}
		}
		return link_ok;
	}
	
	private Boolean info_command_answer(String [] cmd_list){
		Boolean info_ok = new Boolean(false);
		switch(info_cmd.valueOf(cmd_list[1].toUpperCase())){
		case HELP:
			info_help_command_output();
			break;
		case SYSTEM:
			info_other_command_output(info_cmd.SYSTEM.toString());
			break;
		case MACHINE:
			info_other_command_output(info_cmd.MACHINE.toString());
			break;
		case PREFER:
			info_other_command_output(info_cmd.PREFER.toString());
			break;
		case CORESCRIPT:
			info_other_command_output(info_cmd.CORESCRIPT.toString());
			break;	
		case STATUS:
			info_other_command_output(info_cmd.STATUS.toString());
			break;				
		case SOFTWARE:
			if(cmd_list.length > 2){
				info_software_command_output(info_cmd.SOFTWARE.toString(), cmd_list[2]);
			} else {
				info_software_command_output(info_cmd.SOFTWARE.toString(), "");
			}
			break;
		case BUILD:
			info_other_command_output(info_cmd.BUILD.toString());
			break;			
		default:
			info_help_command_output();
			break;
		}
		return info_ok;
	}	
		
	private void link_help_command_output(){
		System.out.println("LINK commends:");
		for (link_cmd cmd: link_cmd.values()){
			System.out.format("  %8s  --  %s" + line_separator, cmd.toString(), cmd.get_description());
		}
		System.out.println("You may type: 'LINK <host_name>' to establish the connection.");		
	}
	
	private void info_help_command_output(){
		System.out.println("INFO commends:");
		for (info_cmd cmd: info_cmd.values()){
			System.out.format("  %8s  --  %s" + line_separator, cmd.toString(), cmd.get_description());
		}
		System.out.println("You may type: 'INFO <command>' Get the detail client info");		
	}	
	
	private void task_help_command_output(){
		System.out.println("TASK commends:");
		for (task_cmd cmd: task_cmd.values()){
			System.out.format("  %8s  --  %s" + line_separator, cmd.toString(), cmd.get_description());
		}
		System.out.println("You may type: 'TASK <command>' Get the detail tasks info");		
	}
	
	private void action_help_command_output(){
		System.out.println("ACTION commends:");
		for (action_cmd cmd: action_cmd.values()){
			System.out.format("  %8s  --  %s" + line_separator, cmd.toString(), cmd.get_description());
		}
		System.out.println("You may type: 'ACTION <command>' ro run actions on linked host");		
	}	
	
	private void info_other_command_output(String request_info){
		String outputs = new String("");
		try {
			outputs = linked_client.data_request(top_cmd.INFO.toString(), request_info);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			CONSOLE_SERVER_LOGGER.warn("Run command error:" + request_info);
		}
		Map<String, HashMap<String, HashMap<String, String>>> msg_hash = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		msg_hash.putAll(xml_parser.get_common_xml_data(outputs));
		common_hash_data_print(msg_hash);
	}
	
	private void info_software_command_output(
			String request_info,
			String request_detail){
		String outputs = new String("");
		String request = new String("");
		if (request_detail.equals("")){
			request = request_info;
		} else {
			request = request_info + "." + request_detail;
		}
		try {
			outputs = linked_client.data_request(top_cmd.INFO.toString(), request);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			CONSOLE_SERVER_LOGGER.warn("Run command error:" + request_info);
		}
		Map<String, HashMap<String, HashMap<String, String>>> msg_hash = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		msg_hash.putAll(xml_parser.get_common_xml_data(outputs));
		common_hash_data_print(msg_hash);
	}	
	
	private Boolean task_command_answer(String [] cmd_list){
		Boolean task_ok = new Boolean(false);
		switch(task_cmd.valueOf(cmd_list[1].toUpperCase())){
		case HELP:
			task_help_command_output();
			break;
		case RECEIVED:
			task_other_command_output(task_cmd.RECEIVED.toString());
			break;
		case CAPTURED:
			task_other_command_output(task_cmd.CAPTURED.toString());
			break;
		case REJECTED:
			task_other_command_output(task_cmd.REJECTED.toString());
			break;
		case PAUSED:
			task_other_command_output(task_cmd.PAUSED.toString());
			break;
		case STOPPED:
			task_other_command_output(task_cmd.STOPPED.toString());
			break;
		case PROCESSING:
			task_other_command_output(task_cmd.PROCESSING.toString());
			break;
		case RUNNING:
			task_other_command_output(task_cmd.RUNNING.toString());
			break;
		case FINISHED:
			task_other_command_output(task_cmd.FINISHED.toString());
			break;			
		default:
			task_help_command_output();
			break;
		}
		return task_ok;
	}	
	
	private void task_other_command_output(String request_info){
		String outputs = new String("");
		try {
			outputs = linked_client.data_request(top_cmd.TASK.toString(), request_info);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			CONSOLE_SERVER_LOGGER.warn("Run command error:" + request_info);
		}
		Map<String, HashMap<String, HashMap<String, String>>> msg_hash = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		msg_hash.putAll(xml_parser.get_common_xml_data(outputs));
		common_hash_data_print(msg_hash);
	}
	
	private Boolean action_command_answer(String [] cmd_list){
		Boolean action_ok = new Boolean(false);
		switch(action_cmd.valueOf(cmd_list[1].toUpperCase())){
		case HELP:
			action_help_command_output();
			break;
		case CRN:
			action_other_command_output(action_cmd.CRN.toString());
			break;
		case CRL:
			action_other_command_output(action_cmd.CRL.toString());
			break;
		case CSN:
			action_other_command_output(action_cmd.CSN.toString());
			break;
		case CSL:
			action_other_command_output(action_cmd.CSL.toString());
			break;
		case HRN:
			action_other_command_output(action_cmd.HRN.toString());
			break;
		case HRL:
			action_other_command_output(action_cmd.HRL.toString());
			break;
		case HSN:
			action_other_command_output(action_cmd.HSN.toString());
			break;
		case HSL:
			action_other_command_output(action_cmd.HSL.toString());
			break;			
		default:
			break;
		}
		return action_ok;
	}
	
	private void action_other_command_output(String request_info){
		String outputs = new String("");
		try {
			outputs = linked_client.action_request(top_cmd.ACTION.toString(), request_info);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			CONSOLE_SERVER_LOGGER.warn("Run command error:" + request_info);
		}
		Map<String, HashMap<String, HashMap<String, String>>> msg_hash = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		msg_hash.putAll(xml_parser.get_common_xml_data(outputs));
		common_hash_data_print(msg_hash);
	}
	
	private void common_hash_data_print(
			Map<String, HashMap<String, HashMap<String, String>>> hash_data
			){
		Iterator<String> level1_it = hash_data.keySet().iterator();
		while(level1_it.hasNext()){
			String level1_item = level1_it.next();
			System.out.format("%s" + line_separator,level1_item);
			HashMap<String, HashMap<String, String>> level2_data = hash_data.get(level1_item);
			Iterator<String> level2_it = level2_data.keySet().iterator();
			while(level2_it.hasNext()){
				String level2_item = level2_it.next();
				System.out.format("  %10s" + line_separator,level2_item);
				HashMap<String, String> level3_data = level2_data.get(level2_item);
				Iterator<String> level3_it = level3_data.keySet().iterator();
				while(level3_it.hasNext()){
					String level3_item = level3_it.next();
					System.out.format("  %20s  -->  %s" + line_separator,level3_item, level3_data.get(level3_item));
				}
			}
		}
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
			if (user_inputs ==null || user_inputs.equals("")){
				continue;
			}
			// task 2: check the inputs
			Boolean input_ok = check_user_inputs(user_inputs);
			// task 3: print the answer
			if (input_ok){
				answer_user_inputs(user_inputs);
			} else {
				System.out.println("Wrong input command:" + user_inputs);
				help_command_answer();
			}
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
		cmd_parser cmd_run = new cmd_parser(args);
		HashMap<String, String> cmd_info = cmd_run.cmdline_parser();
		switch_data switch_info = new switch_data();
		task_data task_info = new task_data();
		client_data client_info = new client_data();
		pool_data pool_info = new pool_data(10);
		post_data post_info = new post_data();
		data_server server_runner = new data_server(cmd_info, switch_info, client_info, pool_info);
		server_runner.start();		
		link_server my_server = new link_server(switch_info, client_info, task_info, pool_info, post_info, public_data.SOCKET_DEF_CMD_PORT);
		my_server.start();
		console_server my_terminal = new console_server(switch_info);
		my_terminal.start();
	}
}
