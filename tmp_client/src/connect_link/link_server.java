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

import data_center.client_data;
import data_center.exit_enum;
import data_center.public_data;
import data_center.switch_data;
import info_parser.xml_parser;

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
	private ServerSocket server = null;
	private int base_interval = public_data.PERF_THREAD_BASE_INTERVAL;
	
	public link_server(switch_data switch_info, client_data client_info) {
		this.switch_info = switch_info;
		this.client_info = client_info;
	}

	private void process_socket_data() throws IOException{
		StringBuilder new_data = new StringBuilder("");
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
		msg_hash = xml_parser.get_socket_xml_data(new_data.toString());
		System.out.println(msg_hash.toString());
		String return_string = new String("");
		if (msg_hash.containsKey("slave_data")){
			if (msg_hash.get("slave_data").containsKey("task")){
				return_string = public_data.SOCKET_DEF_ACKNOWLEDGE;
			} else if (msg_hash.get("slave_data").containsKey("client")){
				return_string = client_info.get_client_data().get(msg_hash.get("slave_data").get("client").get("request")).toString();
			} else if (msg_hash.get("slave_data").containsKey("control")){
				return_string = public_data.SOCKET_DEF_ACKNOWLEDGE;
			} else {
				return_string = public_data.SOCKET_DEF_ACKNOWLEDGE;
			}
		} else {
			return_string = public_data.SOCKET_DEF_ACKNOWLEDGE;
		}
		socket_out.write(return_string);
        socket_out.flush();
        socket.shutdownOutput();
        socket.close();
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
		// initial 1 : start socket server
		try {
			server = new ServerSocket(public_data.SOCKET_DEF_PORT);
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		// initial 2 : Announce link server ready
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
				e1.printStackTrace();
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
			server.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void hard_stop() {
		stop_request = true;
		try {
			server.close();
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