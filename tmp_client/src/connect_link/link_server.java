/*
 * File: view_server.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package connect_link;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.HashMap;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import cmd_interface.action_cmd;
import cmd_interface.info_cmd;
import cmd_interface.task_cmd;
import cmd_interface.top_cmd;
import connect_tube.task_data;
import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;
import flow_control.pool_data;
import flow_control.post_data;
import info_parser.xml_parser;
import top_runner.run_status.exit_enum;

public class link_server extends Thread {
	// public property
	// protected property
	// private property
	// public function
	// protected function
	// private function
	private static final Logger LINK_SERVER_LOGGER = LogManager.getLogger(link_server.class.getName());
	private boolean stop_request = false;
	private boolean wait_request = false;
	private Thread link_thread;
	private switch_data switch_info;
	private client_data client_info;
	private task_data task_info;
	private pool_data pool_info;
	private post_data post_info;
	private ServerSocket server = null;
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;
	
	public link_server(
			switch_data switch_info, 
			client_data client_info,
			task_data task_info,
			pool_data pool_info,
			post_data post_info,
			int link_port) {
		this.switch_info = switch_info;
		this.client_info = client_info;
		this.task_info = task_info;
		this.pool_info = pool_info;
		this.post_info = post_info;
		try {
			server = new ServerSocket(link_port);
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			// e1.printStackTrace();
			LINK_SERVER_LOGGER.info("Create link server error out, Could be port occupied.");			
		}
	}

	private void process_socket_data() throws IOException{
		StringBuilder new_data = new StringBuilder("");
		if (server == null){
			LINK_SERVER_LOGGER.warn("Link server didn't initialized.");
			stop_request = true;
			return;
		}
		String ip = new String(server.getInetAddress().getHostAddress());
		String machine = new String(server.getInetAddress().getHostName());
		Socket socket = server.accept();
		BufferedReader socket_in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
		String line = null;
		//while((line = socket_in.readLine()) != null){
		while((line = socket_in.readLine()) != null){
			new_data.append(line);
		}
		socket.shutdownInput();
        BufferedWriter socket_out = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
		Map<String, HashMap<String, HashMap<String, String>>> msg_hash = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		msg_hash.putAll(xml_parser.get_common_xml_data(new_data.toString()));
		String return_string = new String("");
		if (msg_hash.containsKey("slave_data")){
			HashMap<String, HashMap<String, String>> slave_data = new HashMap<String, HashMap<String, String>>();
			slave_data.putAll(msg_hash.get("slave_data"));
			if (slave_data.containsKey(top_cmd.TASK.toString())){
				return_string = get_task_return_data(ip, machine, slave_data.get(top_cmd.TASK.toString()).get("request"));
			} else if (slave_data.containsKey(top_cmd.INFO.toString())){
				return_string = get_info_return_data(ip, machine, slave_data.get(top_cmd.INFO.toString()).get("request"));
			} else if (slave_data.containsKey(top_cmd.ACTION.toString())){
				return_string = get_action_return_data(ip, machine, slave_data.get(top_cmd.ACTION.toString()).get("request"));
			} else if (slave_data.containsKey(top_cmd.LINK.toString())){
				return_string = get_link_return_data(ip, machine);
			}else {
				return_string = get_default_return_data(ip, machine);
			}
		}
		if (msg_hash.containsKey("slave_task")){
			HashMap<String, HashMap<String, String>> slave_task = new HashMap<String, HashMap<String, String>>();
			slave_task.putAll(msg_hash.get("slave_task"));
			return_string = get_default_return_data(ip, machine);
		}
		socket_out.write(return_string);
        socket_out.flush();
        socket.shutdownOutput();
        socket.close();
	}
	
	private String get_default_return_data(
			String ip,
			String machine){
		HashMap<String, HashMap<String, String>> xml_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, String> detail_data = new HashMap<String, String>();
		detail_data.put("default", public_data.SOCKET_DEF_ACKNOWLEDGE);
		xml_data.put("results", detail_data);
		String return_str = xml_parser.create_common_xml_string("master_data", xml_data, ip, machine);
		return return_str;
	}
	
	private String get_link_return_data(
			String ip,
			String machine){
		HashMap<String, HashMap<String, String>> xml_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, String> detail_data = new HashMap<String, String>();
		detail_data.put("default", public_data.SOCKET_LINK_ACKNOWLEDGE);
		xml_data.put("results", detail_data);
		String return_str = xml_parser.create_common_xml_string("master_data", xml_data, ip, machine);
		return return_str;
	}	
	
	private String get_action_return_data(
			String ip,
			String machine,
			String req_action){
		HashMap<String, HashMap<String, String>> xml_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, String> detail_data = new HashMap<String, String>();
		switch(action_cmd.valueOf(req_action)){
		case CRN:
			switch_info.set_client_stop_request(exit_enum.CRN);
			switch_info.set_client_soft_stop_request(false);
			detail_data.put(action_cmd.CRN.toString(), public_data.SOCKET_DEF_ACKNOWLEDGE);
			break;
		case CRL:
			switch_info.set_client_stop_request(exit_enum.CRL);
			switch_info.set_client_soft_stop_request(true);			
			detail_data.put(action_cmd.CRL.toString(), public_data.SOCKET_DEF_ACKNOWLEDGE);
			break;
		case CSN:
			switch_info.set_client_stop_request(exit_enum.CSN);
			switch_info.set_client_soft_stop_request(false);			
			detail_data.put(action_cmd.CSN.toString(), public_data.SOCKET_DEF_ACKNOWLEDGE);
			break;
		case CSL:
			switch_info.set_client_stop_request(exit_enum.CSL);
			switch_info.set_client_soft_stop_request(true);			
			detail_data.put(action_cmd.CSL.toString(), public_data.SOCKET_DEF_ACKNOWLEDGE);
			break;
		case HRN:
			switch_info.set_client_stop_request(exit_enum.HRN);
			switch_info.set_client_soft_stop_request(false);			
			detail_data.put(action_cmd.HRN.toString(), public_data.SOCKET_DEF_ACKNOWLEDGE);
			break;
		case HRL:
			switch_info.set_client_stop_request(exit_enum.HRL);
			switch_info.set_client_soft_stop_request(true);			
			detail_data.put(action_cmd.HRL.toString(), public_data.SOCKET_DEF_ACKNOWLEDGE);
			break;
		case HSN:
			switch_info.set_client_stop_request(exit_enum.HSN);
			switch_info.set_client_soft_stop_request(false);			
			detail_data.put(action_cmd.HSN.toString(), public_data.SOCKET_DEF_ACKNOWLEDGE);
			break;
		case HSL:
			switch_info.set_client_stop_request(exit_enum.HSL);
			switch_info.set_client_soft_stop_request(true);			
			detail_data.put(action_cmd.HSL.toString(), public_data.SOCKET_DEF_ACKNOWLEDGE);
			break;
		default:
			detail_data.put("default", "NA");
			break;
		}
		xml_data.put("results", detail_data);
		String return_str = xml_parser.create_common_xml_string("master_data", xml_data, ip, machine);
		return return_str;		
	}	
	
	private String get_info_return_data(
			String ip,
			String machine,
			String req_area){
		String req_section = new String("");
		String req_option = new String("");
		if (req_area.contains(".")){
			req_section = req_area.split("\\.")[0];
			req_option = req_area.split("\\.")[1];
		} else {
			req_section = req_area;
		}
		HashMap<String, HashMap<String, String>> xml_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, String> detail_data = new HashMap<String, String>();
		switch(info_cmd.valueOf(req_section)){
		case SYSTEM:
			detail_data.putAll(client_info.get_client_system_data());
			break;
		case MACHINE:
			detail_data.putAll(client_info.get_client_machine_data());
			break;
		case PREFER:
			detail_data.putAll(client_info.get_client_preference_data());
			break;
		case CORESCRIPT:
			detail_data.putAll(client_info.get_client_corescript_data());
			break;			
		case SOFTWARE:
			if (req_option == null || req_option.equals("")){
				detail_data.putAll(client_info.get_client_software_data());
			} else {
				detail_data.putAll(client_info.get_client_software_data(req_option));
			}
			break;
		case STATUS:
			String pool_status = new String("Threads");
			String post_status = new String("Remote Copy");
			int max_thread = pool_info.get_pool_current_size();
			int use_thread = pool_info.get_pool_used_threads();
			int remote_num = post_info.get_postrun_call_size();
			String show_info = String.valueOf(use_thread) + "/" + String.valueOf(max_thread);
			detail_data.put(pool_status, show_info);
			detail_data.put(post_status, String.valueOf(remote_num));
			break;
		case BUILD:
			detail_data.put("Version", public_data.BASE_CURRENTVERSION);
			detail_data.put("Date", public_data.BASE_BUILDDATE);
			break;
		default:
			detail_data.put("default", "NA");
			break;
		}
		xml_data.put("results", detail_data);
		String return_str = xml_parser.create_common_xml_string("master_data", xml_data, ip, machine);
		return return_str;		
	}
	
	private String get_task_return_data(
			String ip,
			String machine,
			String req_area){
		HashMap<String, HashMap<String, String>> xml_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, String> detail_data = new HashMap<String, String>();
		switch(task_cmd.valueOf(req_area)){
		case RECEIVED:
			detail_data.put(task_cmd.RECEIVED.toString(), task_info.get_received_admin_queues_treemap().toString());
			break;
		case CAPTURED:
			detail_data.put(task_cmd.CAPTURED.toString(), task_info.get_captured_admin_queues_treemap().toString());
			break;
		case REJECTED:
			detail_data.put(task_cmd.REJECTED.toString(), task_info.get_rejected_admin_reason_treemap().toString());
			break;
		case PAUSED:
			detail_data.put(task_cmd.PAUSED.toString(), task_info.get_paused_admin_queue_list().toString());
			break;
		case STOPPED:
			detail_data.put(task_cmd.STOPPED.toString(), task_info.get_stopped_admin_queue_list().toString());
			break;
		case PROCESSING:
			detail_data.put(task_cmd.PROCESSING.toString(), task_info.get_processing_admin_queue_list().toString());
			break;
		case EXECUTING:
			detail_data.put(task_cmd.EXECUTING.toString(), task_info.get_executing_admin_queue_list().toString());
			break;
		case PENDING:
			detail_data.put(task_cmd.PENDING.toString(), task_info.get_pending_admin_queue_list().toString());
			break;				
		case RUNNING:
			detail_data.put(task_cmd.RUNNING.toString(), task_info.get_running_admin_queue_list().toString());
			break;
		case WAITING:
			detail_data.put(task_cmd.WAITING.toString(), task_info.get_waiting_admin_queue_list().toString());
			break;			
		case EMPTIED:
			detail_data.put(task_cmd.EMPTIED.toString(), task_info.get_emptied_admin_queue_list().toString());
			break;
		case FINISHED:
			detail_data.put(task_cmd.FINISHED.toString(), task_info.get_finished_admin_queue_list().toString());
			break;			
		default:
			detail_data.put("default", "NA");
			break;
		}
		xml_data.put("results", detail_data);
		String return_str = xml_parser.create_common_xml_string("master_data", xml_data, ip, machine);
		return return_str;		
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
		link_thread = Thread.currentThread();
		// ============== All static job start from here ==============
		// initial 1 : Announce link server ready
		switch_info.set_link_server_power_up();
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
				LINK_SERVER_LOGGER.debug("Link Server running...");
			}
			// ============== All dynamic job start from here ==============
			// task 1: process the input
			try {
				process_socket_data();
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				// e1.printStackTrace();
				LINK_SERVER_LOGGER.info("link server run error/closed.");
			}
			// task 2: xxx
			try {
				Thread.sleep(base_interval * 1 * 100);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public void soft_stop() {
		stop_request = true;
		try {
			if (server!=null){
				server.close();
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void hard_stop() {
		stop_request = true;
		try {
			if (server!=null){
				server.close();
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if (link_thread != null) {
			link_thread.interrupt();
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
		//
	}
}