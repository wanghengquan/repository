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
import java.net.UnknownHostException;
import java.util.HashMap;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import connect_tube.task_data;
import data_center.client_data;
import data_center.data_server;
import data_center.public_data;
import data_center.switch_data;
import flow_control.pool_data;
import info_parser.cmd_parser;
import info_parser.xml_parser;

public class link_client {
	// public property
	// protected property
	// private property
	// public function
	// protected function
	// private function
	private static final Logger LINK_CLIENT_LOGGER = LogManager.getLogger(link_client.class.getName());
	
	public link_client() {
	}

	private String client_data_request(
			String terminal,
			int port,
			String request_info) throws UnknownHostException, IOException{
		Socket socket= new Socket(terminal, port);
		BufferedWriter socket_out = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
		HashMap<String, HashMap<String, String>> xml_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, String> request_data = new HashMap<String, String>();
		request_data.put("request", request_info);
		xml_data.put("client", request_data);
		xml_parser xml_parser = new xml_parser();
		String output = xml_parser.create_common_document_string("slave_data", xml_data, socket.getInetAddress().getHostAddress(), terminal);
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
	
	private String task_data_request(
			String terminal,
			int port,			
			String request_info) throws UnknownHostException, IOException{
		Socket socket= new Socket(terminal, port);
		BufferedWriter socket_out = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
		HashMap<String, HashMap<String, String>> xml_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, String> request_data = new HashMap<String, String>();
		request_data.put("request", request_info);
		xml_data.put("task", request_data);
		xml_parser xml_parser = new xml_parser();
		String output = xml_parser.create_common_document_string("slave_data", xml_data, socket.getInetAddress().getHostAddress(), terminal);
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
	
	private String control_action_request(
			String terminal,
			int port,
			String request_info) throws UnknownHostException, IOException{
		Socket socket= new Socket(terminal, port);
		BufferedWriter socket_out = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
		HashMap<String, HashMap<String, String>> xml_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, String> request_data = new HashMap<String, String>();
		request_data.put("request", request_info);
		xml_data.put("control", request_data);
		xml_parser xml_parser = new xml_parser();
		String output = xml_parser.create_common_document_string("slave_data", xml_data, socket.getInetAddress().getHostAddress(), terminal);
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
	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		//
		cmd_parser cmd_run = new cmd_parser(args);
		HashMap<String, String> cmd_info = cmd_run.cmdline_parser();
		switch_data switch_info = new switch_data();
		task_data task_info = new task_data();
		client_data client_info = new client_data();
		pool_data pool_info = new pool_data(10);		
		data_server server_runner = new data_server(cmd_info, switch_info, task_info, client_info, pool_info);
		server_runner.start();
		try {
			Thread.sleep(10 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(">>>client data:" + client_info.get_client_data().toString());
		link_server my_server = new link_server(switch_info, client_info);
		my_server.start();
		try {
			Thread.sleep(2 * 1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
		link_client my_client = new link_client();
		String system_string = null;
		try {
			system_string = my_client.client_data_request(
					public_data.SOCKET_DEF_TERMINAL, 
					public_data.SOCKET_DEF_PORT, 
					"diamond");
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(system_string);
		my_server.soft_stop();
		server_runner.soft_stop();
	}
}