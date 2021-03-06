/*
 * File: public_data.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package connect_tube;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import com.rabbitmq.client.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.concurrent.TimeoutException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import data_center.client_data;
import data_center.public_data;
import flow_control.export_data;
import info_parser.xml_parser;
import utility_funcs.data_check;

/*
 * This class used to instance rabbitMQ tube between server and center processor.
 * 1: Memory 
 */
public class rmq_tube {
	// public property
	// {queue_name : {ID : {suite: suite_name}}}

	// protected property
	// private property
	private static final Logger RMQ_TUBE_LOGGER = LogManager.getLogger(rmq_tube.class.getName());
	private static String rmq_host = public_data.RMQ_HOST;
	private static String rmq_user = public_data.RMQ_USER;
	private static String rmq_pwd = public_data.RMQ_PWD;
	private static String task_msg = new String();
	private task_data task_info;
	private client_data client_info;
	private Connection admin_connection;
	private Channel admin_channel;
	private Connection stop_connection;
	private Channel stop_channel;
	private Boolean admin_work = Boolean.valueOf(false);
	private Boolean stop_queue_work = Boolean.valueOf(false);

	// public function
	public rmq_tube(
			task_data task_info, 
			client_data client_info) {
		this.task_info = task_info;
		this.client_info = client_info;
	}

	public rmq_tube() {
	}
	// protected function
	// private function

	public Boolean exchange_send(String exchange_name, String content) {
		// String EXCHANGE_NAME = "logs";
		Boolean send_status = Boolean.valueOf(true);
		String EXCHANGE_NAME = exchange_name;
		ConnectionFactory factory = new ConnectionFactory();
		factory.setHost(rmq_host);
		factory.setUsername(rmq_user);
		factory.setPassword(rmq_pwd);
		Connection connection;
		try {
			connection = factory.newConnection();
			Channel channel = connection.createChannel();
			channel.exchangeDeclare(EXCHANGE_NAME, "fanout");
			channel.basicPublish(EXCHANGE_NAME, "", null, content.getBytes());
			channel.close();
			connection.close();
		} catch (IOException e) {
			// e.printStackTrace();
			RMQ_TUBE_LOGGER.warn("exchange_send ioexception");
			send_status = false;
		} catch (TimeoutException e) {
			// e.printStackTrace();
			RMQ_TUBE_LOGGER.warn("exchange_send timeout exception");
			send_status = false;
		}
		return send_status;
	}

	/*
	 * This function used to send the client string to the server. The Queue
	 * name for case result is:Result The Queue name for the client info is:
	 * Info if the content send smoothly, 0 will be return Or 1 will be return.
	 */
	public Boolean basic_send(String queue_name, String content) {
		Boolean send_status = Boolean.valueOf(true);
		ConnectionFactory factory = new ConnectionFactory();
		factory.setHost(rmq_host);
		factory.setUsername(rmq_user);
		factory.setPassword(rmq_pwd);
		Connection connection;
		try {
			connection = factory.newConnection();
			Channel channel = connection.createChannel();
			channel.queueDeclare(queue_name, false, false, false, null);
			String message = content;
			channel.basicPublish("", queue_name, null, message.getBytes("UTF-8"));
			channel.close();
			connection.close();
		} catch (IOException e) {
			// e.printStackTrace();
			RMQ_TUBE_LOGGER.warn("basic_send ioexception");
			send_status = false;
		} catch (TimeoutException e) {
			// e.printStackTrace();
			RMQ_TUBE_LOGGER.warn("basic_send timeoutexception");
			send_status = false;
		}
		return send_status;
	}

	/*
	 * after this function is called, user need to read the "content" the read
	 * string is stored in the content. At here, we need to sent ACK to the
	 * server. when the client get one message from the server, it should stop
	 * the connect!
	 */
	public static synchronized Map<String, HashMap<String, HashMap<String, String>>> read_task_server(
			String queue_name,
			client_data client_info)
			throws Exception {
		ConnectionFactory factory = new ConnectionFactory();
		factory.setHost(rmq_host);
		factory.setUsername(rmq_user);
		factory.setPassword(rmq_pwd);
		String v_host;
		try {
			//queue_name = queue_name.split("@")[1];
			queue_name = queue_name.split("@.+?_")[1];
			v_host = queue_name.split("_")[1];
			v_host = "vhost_" + v_host;
		} catch (Exception e) {
			v_host = "/";
		}
		factory.setVirtualHost(v_host);
		final Connection connection = factory.newConnection();
		final Channel channel = connection.createChannel();
		channel.queueDeclare(queue_name, true, false, false, null);
		channel.basicQos(1);
		task_msg = "";
		final Consumer consumer = new DefaultConsumer(channel) {
			@Override
			public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties,
					byte[] body) throws IOException {
				String message = new String(body, "UTF-8");
				task_msg = message;
				channel.basicAck(envelope.getDeliveryTag(), false);
				if (channel.isOpen())
					try {
						channel.close();
					} catch (TimeoutException e) {
						//e.printStackTrace();
						RMQ_TUBE_LOGGER.warn("close channel TimeoutException");
					}
				if (connection.isOpen())
					connection.close();
			}
		};
		channel.basicConsume(queue_name, false, consumer);
		Thread.sleep(2000);
		if (channel.isOpen())
			try {
				channel.close();
			} catch (TimeoutException e) {
				e.printStackTrace();
			}
		if (connection.isOpen())
			connection.close();
		Map<String, HashMap<String, HashMap<String, String>>> msg_hash = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		msg_hash = xml_parser.get_rmq_xml_data(task_msg);
		export_data.debug_disk_client_in_task(queue_name + ".xml", task_msg, client_info);
		return msg_hash;
	}

	public synchronized void start_admin_tube(String current_terminal) throws Exception {
		/*
		 * This function used to read the admin queue and return the strings at
		 * here we use Publish/Subscribe in rabbitmq
		 */
		if (admin_work){
			return;
		}
		admin_work = true;
		ConnectionFactory factory = new ConnectionFactory();
		factory.setHost(rmq_host);
		factory.setUsername(rmq_user);
		factory.setPassword(rmq_pwd);
		factory.setAutomaticRecoveryEnabled(true);
		admin_connection = factory.newConnection();
		admin_channel = admin_connection.createChannel();
		admin_channel.exchangeDeclare(public_data.RMQ_ADMIN_QUEUE, "fanout");
		String queueName = admin_channel.queueDeclare().getQueue();
		admin_channel.queueBind(queueName, public_data.RMQ_ADMIN_QUEUE, "");
		Consumer consumer = new DefaultConsumer(admin_channel) {
			@Override
			public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties,
					byte[] body) throws IOException {
				String message = new String(body, "UTF-8");
				update_admin_queue(message, current_terminal);
				//channel.basicAck(envelope.getDeliveryTag(), false);
			}
		};
		admin_channel.basicConsume(queueName, true, consumer);
	}


	public synchronized void stop_admin_tube() throws Exception {
		if (!admin_work){
			return;
		}
		admin_work = false;
		if (admin_channel.isOpen())
			try {
				admin_channel.close();
			} catch (TimeoutException e) {
				//e.printStackTrace();
				RMQ_TUBE_LOGGER.warn("close channel TimeoutException");
			}
		if (admin_connection.isOpen())
			admin_connection.close();		
	}
	
	private Boolean update_admin_queue(String message, String current_terminal) {
		Boolean update_status = Boolean.valueOf(false);
		TreeMap<String, HashMap<String, HashMap<String, String>>> admin_hash = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		Map<String, HashMap<String, HashMap<String, String>>> msg_hash = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		msg_hash.putAll(xml_parser.get_rmq_xml_data(message));
		Set<String> msg_key_set = msg_hash.keySet();
		if (msg_key_set.isEmpty()) {
			return update_status;
		}
		String msg_key = (String) msg_key_set.toArray()[0];
		HashMap<String, HashMap<String, String>> msg_data = msg_hash.get(msg_key);
		// admin queue priority check:0>1>2..>5(default)>...8>9
		String priority = public_data.TASK_DEF_PRIORITY;
		if (!msg_data.containsKey("CaseInfo")) {
			priority = public_data.TASK_DEF_PRIORITY;
		} else if (!msg_data.get("CaseInfo").containsKey("priority")) {
			priority = public_data.TASK_DEF_PRIORITY;
		} else {
			priority = msg_data.get("CaseInfo").get("priority");
			Pattern p = Pattern.compile("^\\d$");
			Matcher m = p.matcher(priority);
			if (!m.find()) {
				priority = public_data.TASK_DEF_PRIORITY;
				RMQ_TUBE_LOGGER.warn(msg_key + ":has wrong CaseInfo->priority, default value " + public_data.TASK_DEF_PRIORITY + " used.");
			}
		}
		// task belong to this client(job_attribute): (0, assign task) > (1, match task)
		String assignment = new String();
		String request_terminal = new String();
		String available_terminal = current_terminal;
		if (!msg_data.containsKey("Machine")) {
			assignment = "1";
		} else if (!msg_data.get("Machine").containsKey("terminal")) {
			assignment = "1";
		} else {
			request_terminal = msg_data.get("Machine").get("terminal");
			if (request_terminal.contains(available_terminal)) {
				assignment = "0"; // assign task
			} else {
				assignment = "1"; // match task
			}
		}
		// Max threads requirements
		String threads = new String(public_data.TASK_DEF_MAX_THREADS);
		if (!msg_data.containsKey("Preference")) {
			threads = public_data.TASK_DEF_MAX_THREADS;
		} else if (!msg_data.get("Preference").containsKey("max_threads")) {
			threads = public_data.TASK_DEF_MAX_THREADS;
		} else {
			threads = msg_data.get("Preference").get("max_threads");
			Pattern p = Pattern.compile("^\\d$");
			Matcher m = p.matcher(threads);
			if (!m.find()) {
				threads = public_data.TASK_DEF_MAX_THREADS;
				RMQ_TUBE_LOGGER.warn(msg_key + ":has wrong Preference->max_threads, default value " + public_data.TASK_DEF_MAX_THREADS + " used.");
			}
		}
		// host restart requirements
		String restart_boolean = new String(public_data.TASK_DEF_HOST_RESTART);
		if (!msg_data.containsKey("Preference")) {
			restart_boolean = public_data.TASK_DEF_HOST_RESTART;
		} else if (!msg_data.get("Preference").containsKey("host_restart")) {
			restart_boolean = public_data.TASK_DEF_HOST_RESTART;
		} else {
			String request_value = new String(msg_data.get("Preference").get("host_restart").trim());
			if (!data_check.str_choice_check(request_value, new String [] {"false", "true"} )){
				RMQ_TUBE_LOGGER.warn(msg_key + ":has wrong Preference->host_restart, default value " + public_data.TASK_DEF_HOST_RESTART + " used.");
			} else {
				restart_boolean = request_value;
			}
		}
		String restart = new String("0");
		if (restart_boolean.equalsIgnoreCase("true")) {
			restart = "1";
		} else {
			restart = "0";
		}
		//String new_title = priority + assignment + "1@t" + threads+ "r" + restart + "_" + msg_key;
		StringBuilder queue_name = new StringBuilder("");
		queue_name.append(priority);
		queue_name.append(assignment);
		queue_name.append("1");//1, from remote; 0, from local
		queue_name.append("@");
		queue_name.append("t" + threads);
		queue_name.append("r" + restart);
		queue_name.append("_" + msg_key);
		admin_hash.put(queue_name.toString(), msg_data);
		task_info.update_received_admin_queues_treemap(admin_hash);
		export_data.debug_disk_client_in_admin(msg_key + ".xml", message, client_info);
		update_status = true;
		return update_status;
	}
	
	public synchronized void start_stop_tube() throws Exception {
		/*
		 * This function used to read the admin queue and return the strings at
		 * here we use Publish/Subscribe in rabbitmq
		 */
		if (stop_queue_work){
			return;
		}
		stop_queue_work = true;
		ConnectionFactory factory = new ConnectionFactory();
		factory.setHost(rmq_host);
		factory.setUsername(rmq_user);
		factory.setPassword(rmq_pwd);
		factory.setAutomaticRecoveryEnabled(true);
		stop_connection = factory.newConnection();
		stop_channel = stop_connection.createChannel();
		stop_channel.exchangeDeclare(public_data.RMQ_STOP_QUEUE, "fanout");
		String queueName = stop_channel.queueDeclare().getQueue();
		stop_channel.queueBind(queueName, public_data.RMQ_STOP_QUEUE, "");
		Consumer consumer = new DefaultConsumer(stop_channel) {
			@Override
			public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties,
					byte[] body) throws IOException {
				String message = new String(body, "UTF-8");
				update_stop_queue(message);
				//channel.basicAck(envelope.getDeliveryTag(), false);
			}
		};
		stop_channel.basicConsume(queueName, true, consumer);
	}


	public synchronized void stop_stop_tube() throws Exception {
		if (!stop_queue_work){
			return;
		}
		stop_queue_work = false;
		if (stop_channel.isOpen())
			try {
				stop_channel.close();
			} catch (TimeoutException e) {
				//e.printStackTrace();
				RMQ_TUBE_LOGGER.warn("close channel TimeoutException");
			}
		if (stop_connection.isOpen())
			stop_connection.close();		
	}
	
	private Boolean update_stop_queue(String message) {
		Boolean update_status = Boolean.valueOf(false);
		HashMap<String, HashMap<String, String>> msg_hash = new HashMap<String, HashMap<String, String>>();
		msg_hash.putAll(xml_parser.get_rmq_xml_data2(message));
		task_info.update_received_stop_queues_map(msg_hash);
		export_data.debug_disk_client_in_stop("stop_queue.xml", message, client_info);
		return update_status;
	}
}