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
import java.net.Socket;
import java.util.HashMap;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import cmd_interface.top_cmd;
import connect_tube.task_data;
import data_center.client_data;
import data_center.data_server;
import data_center.public_data;
import data_center.switch_data;
import flow_control.pool_data;
import flow_control.post_data;
import gui_interface.view_data;
import info_parser.cmd_parser;
import info_parser.xml_parser;

public class link_client {
	// public property
	// protected property
	// private property
	// public function
	// protected function
	// private function
	public String linked_host = public_data.SOCKET_DEF_TERMINAL;
	private static final Logger LINK_CLIENT_LOGGER = LogManager.getLogger(link_client.class.getName());
	
	public link_client() {
	}

	private void set_linked_user_host(String host) {
		linked_host = host;
	}
	
	public String get_linked_user_host() {
		return linked_host;
	}
	
	//Channel CMD related tasks
	public Boolean channel_cmd_link_request(
			String host){
		Boolean link_status = Boolean.valueOf(true);
		Socket socket = null;
		HashMap<String, String> request_data = new HashMap<String, String>();
		StringBuilder return_data = new StringBuilder("");
		try {
			socket = new Socket(host, public_data.SOCKET_DEF_LINK_PORT);
			BufferedWriter socket_out = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
			HashMap<String, HashMap<String, String>> xml_data = new HashMap<String, HashMap<String, String>>();
			request_data.put("request", top_cmd.LINK.toString());
			xml_data.put(top_cmd.LINK.toString(), request_data);
			String output = xml_parser.create_common_xml_string("channel_cmd", xml_data, socket.getInetAddress().getHostAddress(), linked_host);
			socket_out.write(output);
			socket_out.flush();
			socket.shutdownOutput();
			//get the return
			BufferedReader socket_in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
			String line = null;
			while((line = socket_in.readLine()) != null){
				return_data.append(line);
			}
			socket.shutdownInput();
			socket.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			LINK_CLIENT_LOGGER.warn("link to host:" + host + ", Failed.");
			link_status = false;
		}
		Map<String, HashMap<String, HashMap<String, String>>> msg_hash = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		msg_hash.putAll(xml_parser.get_common_xml_data(return_data.toString()));
		if (!msg_hash.containsKey("channel_cmd")){
			link_status = false;
			return link_status;
		}
		if (!msg_hash.get("channel_cmd").containsKey("results")){
			link_status = false;
			return link_status;
		}
		if (!msg_hash.get("channel_cmd").get("results").containsKey("default")){
			link_status = false;
			return link_status;
		}	
		if (!msg_hash.get("channel_cmd").get("results").get("default").equalsIgnoreCase(public_data.SOCKET_LINK_ACKNOWLEDGE)){
			link_status = false;
			return link_status;
		}
		//successfully linked to host
		set_linked_user_host(host);
		LINK_CLIENT_LOGGER.warn("linked client: " + host);
		//return link status
		return link_status;
	}	
	
	public String channel_cmd_data_request(
			String category,
			String request_info) throws IOException{
		Socket socket = new Socket(linked_host, public_data.SOCKET_DEF_LINK_PORT);
		BufferedWriter socket_out = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
		HashMap<String, HashMap<String, String>> xml_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, String> request_data = new HashMap<String, String>();
		request_data.put("request", request_info);
		xml_data.put(category, request_data);
		String output = xml_parser.create_common_xml_string("channel_cmd", xml_data, socket.getInetAddress().getHostAddress(), linked_host);
		socket_out.write(output);
		socket_out.flush();
		socket.shutdownOutput();
		//get the return
		StringBuilder return_data = new StringBuilder("");
		BufferedReader socket_in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
		String line = null;
		while((line = socket_in.readLine()) != null){
			return_data.append(line);
		}
		socket.shutdownInput();
		socket.close();
		return return_data.toString();
	}
	
	public String channel_cmd_action_request(
			String category,
			String request_action) throws IOException{
		Socket socket = new Socket(linked_host, public_data.SOCKET_DEF_LINK_PORT);
		BufferedWriter socket_out = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
		HashMap<String, HashMap<String, String>> xml_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, String> request_data = new HashMap<String, String>();
		request_data.put("request", request_action);
		xml_data.put(category, request_data);
		String output = xml_parser.create_common_xml_string("channel_cmd", xml_data, socket.getInetAddress().getHostAddress(), linked_host);
		socket_out.write(output);
		socket_out.flush();
		socket.shutdownOutput();
		//get the return
		StringBuilder return_data = new StringBuilder("");
		BufferedReader socket_in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
		String line = null;
		while((line = socket_in.readLine()) != null){
			return_data.append(line);
		}
		socket.shutdownInput();
		socket.close();
		return return_data.toString();
	}	
	
	//Channel JOB related tasks
	
	//unused
//	private String info_data_request(
//			String terminal,
//			int port,
//			String request_info) throws UnknownHostException, IOException{
//		Socket socket= new Socket(terminal, port);
//		BufferedWriter socket_out = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
//		HashMap<String, HashMap<String, String>> xml_data = new HashMap<String, HashMap<String, String>>();
//		HashMap<String, String> request_data = new HashMap<String, String>();
//		request_data.put("request", request_info);
//		xml_data.put("client", request_data);
//		String output = xml_parser.create_common_xml_string("slave_data", xml_data, socket.getInetAddress().getHostAddress(), terminal);
//		socket_out.write(output);
//		socket_out.flush();
//		socket.shutdownOutput();
//		//get the return
//		StringBuilder return_data = new StringBuilder("");
//		BufferedReader socket_in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
//		String line = null;
//		while((line = socket_in.readLine()) != null){
//			return_data.append(line);
//		}
//		socket.shutdownInput();
//		socket.close();
//		return return_data.toString();
//	}
//	
//	//unused
//	private String task_data_request(
//			String terminal,
//			int port,			
//			String request_info) throws UnknownHostException, IOException{
//		Socket socket= new Socket(terminal, port);
//		BufferedWriter socket_out = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
//		HashMap<String, HashMap<String, String>> xml_data = new HashMap<String, HashMap<String, String>>();
//		HashMap<String, String> request_data = new HashMap<String, String>();
//		request_data.put("request", request_info);
//		xml_data.put("task", request_data);
//		String output = xml_parser.create_common_xml_string("slave_data", xml_data, socket.getInetAddress().getHostAddress(), terminal);
//		socket_out.write(output);
//		socket_out.flush();
//		socket.shutdownOutput();
//		//get the return
//		StringBuilder return_data = new StringBuilder("");
//		BufferedReader socket_in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
//		String line = null;
//		while((line = socket_in.readLine()) != null){
//			return_data.append(line);
//		}
//		socket.shutdownInput();
//		socket.close();
//		return return_data.toString();
//	}
//	
//	//unused
//	private String control_action_request(
//			String terminal,
//			int port,
//			String request_info) throws UnknownHostException, IOException{
//		Socket socket= new Socket(terminal, port);
//		BufferedWriter socket_out = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
//		HashMap<String, HashMap<String, String>> xml_data = new HashMap<String, HashMap<String, String>>();
//		HashMap<String, String> request_data = new HashMap<String, String>();
//		request_data.put("request", request_info);
//		xml_data.put("control", request_data);
//		String output = xml_parser.create_common_xml_string("slave_data", xml_data, socket.getInetAddress().getHostAddress(), terminal);
//		socket_out.write(output);
//		socket_out.flush();
//		socket.shutdownOutput();
//		//get the return
//		StringBuilder return_data = new StringBuilder("");
//		BufferedReader socket_in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
//		String line = null;
//		while((line = socket_in.readLine()) != null){
//			return_data.append(line);
//		}
//		socket.shutdownInput();
//		socket.close();
//		return return_data.toString();
//	}
	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		//
		cmd_parser cmd_run = new cmd_parser(args);
		HashMap<String, String> cmd_info = cmd_run.cmdline_parser();
		switch_data switch_info = new switch_data();
		task_data task_info = new task_data();
		view_data view_info = new view_data();
		client_data client_info = new client_data();
		pool_data pool_info = new pool_data(10);	
		post_data post_info = new post_data();
		data_server data_runner = new data_server(cmd_info, switch_info, client_info);
		data_runner.start();
		try {
			Thread.sleep(10 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(">>>client data:" + client_info.get_client_data().toString());
		link_server my_server = new link_server(switch_info, client_info, view_info, task_info, pool_info, post_info);
		my_server.start();
		try {
			Thread.sleep(2 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		my_server.soft_stop();
		data_runner.soft_stop();
	}
}