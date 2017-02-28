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
import java.util.Comparator;

import data_center.data_server;
import data_center.public_data;
import info_parser.xml_parser;

/*
 * This class used to instance rabbitMQ tube between server and center processor.
 * 1: Memory 
 */
public class rmq_tube {
	// public property
	//{queue_name : {ID : {suite: suite_name}}}
	public static TreeMap<String, HashMap<String, HashMap<String, String>>> remote_admin_queue_receive = new TreeMap<String, HashMap<String, HashMap<String, String>>>(
			new Comparator<String>() {
				public int compare(String queue_name1, String queue_name2) {
					// priority:match/assign task:job_from@run_number
					int int_pri1 = 0, int_pri2 = 0;
					int int_id1 = 0, int_id2 = 0;
					try {
						int_pri1 = get_srting_int(queue_name1, "^(\\d+)@");
						int_pri2 = get_srting_int(queue_name2, "^(\\d+)@");
						int_id1 = get_srting_int(queue_name1, "run_(\\d+)_");
						int_id2 = get_srting_int(queue_name2, "run_(\\d+)_");
					} catch (Exception e) {
						return queue_name1.compareTo(queue_name2);
					}
					if (int_pri1 > int_pri2) {
						return 1;
					} else if (int_pri1 < int_pri2) {
						return -1;
					} else {
						if (int_id1 > int_id2) {
							return 1;
						} else if (int_id1 < int_id2) {
							return -1;
						} else {
							return queue_name1.compareTo(queue_name2);
						}
					}
				}
			});
	// protected property
	// private property
	private static final Logger RMQ_LOGGER = LogManager.getLogger(rmq_tube.class.getName());
	private static String rmq_host = public_data.RMQ_HOST;
	private static String rmq_user = public_data.RMQ_USER;
	private static String rmq_pwd = public_data.RMQ_PWD;
	private static String task_msg = new String();

	// public function
	public rmq_tube() {

	}

	// protected function
	// private function
	private static int get_srting_int(String str, String patt) {
		int i = 0;
		try {
			Pattern p = Pattern.compile(patt);
			Matcher m = p.matcher(str);
			if (m.find()) {
				i = Integer.valueOf(m.group(1));
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}
		return i;
	}

	public static int exchange_send(String exchange_name, String content) {
		// String EXCHANGE_NAME = "logs";
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
			return 0;
		} catch (IOException e) {
			e.printStackTrace();
			RMQ_LOGGER.warn("exchange_send ioexception");
			return 1;
		} catch (TimeoutException e) {
			e.printStackTrace();
			RMQ_LOGGER.warn("exchange_send timeout exception");
			return 1;
		}
	}

	/*
	 * This function used to send the client string to the server. The Queue
	 * name for case result is:Result The Queue name for the client info is:
	 * Info if the content send smoothly, 0 will be return Or 1 will be return.
	 */
	public static int basic_send(String queue_name, String content) {
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
			return 0;
		} catch (IOException e) {
			e.printStackTrace();
			return 1;
		} catch (TimeoutException e) {
			e.printStackTrace();
			return 1;
		}
	}

	/*
	 * after this function is called, user need to read the "content" the read
	 * string is stored in the content. At here, we need to sent ACK to the
	 * server. when the client get one message from the server, it should stop
	 * the connect!
	 */
	public static Map<String, HashMap<String, HashMap<String, String>>> read_task_server(String queue_name) throws Exception {
		ConnectionFactory factory = new ConnectionFactory();
		factory.setHost(rmq_host);
		factory.setUsername(rmq_user);
		factory.setPassword(rmq_pwd);
		String v_host;
		try {
			queue_name = queue_name.split("#")[1];
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
						e.printStackTrace();
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
		Map<String, HashMap<String, HashMap<String, String>>> msg_hash = xml_parser.parser_xml_string(task_msg);
		return msg_hash;
	}

	public static void read_admin_server(String queue_name) throws Exception {
		/*
		 * This function used to read the admin queue and return the strings at
		 * here we use Publish/Subscribe in rabbitmq
		 */
		ConnectionFactory factory = new ConnectionFactory();
		factory.setHost(rmq_host);
		factory.setUsername(rmq_user);
		factory.setPassword(rmq_pwd);
		factory.setAutomaticRecoveryEnabled(true);
		final Connection connection = factory.newConnection();
		final Channel channel = connection.createChannel();
		channel.exchangeDeclare(public_data.RMQ_ADMIN_NAME, "fanout");
		String queueName = channel.queueDeclare().getQueue();
		channel.queueBind(queueName, public_data.RMQ_ADMIN_NAME, "");
		Consumer consumer = new DefaultConsumer(channel) {
			@Override
			public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties,
					byte[] body) throws IOException {
				String message = new String(body, "UTF-8");
				remote_admin_queue_receive.putAll(update_admin_queue(message));
			}
		};
		channel.basicConsume(queueName, true, consumer);
	}
	
	private static Map<String, HashMap<String, HashMap<String, String>>> update_admin_queue(String message){
		Map<String, HashMap<String, HashMap<String, String>>> admin_hash = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		Map<String, HashMap<String, HashMap<String, String>>> msg_hash = xml_parser.parser_xml_string(message);
		Set<String> msg_key_set = msg_hash.keySet();
		if (msg_key_set.isEmpty()){
			return admin_hash;
		}
		String msg_key = (String) msg_key_set.toArray()[0];
		HashMap<String, HashMap<String, String>> msg_data = msg_hash.get(msg_key);
		//admin queue priority check:0>1>2..>5(default)>...8>9
		String priority = new String();
		if (!msg_data.containsKey("CaseInfo")){
			priority = "5";
		} else if (!msg_data.get("CaseInfo").containsKey("priority")){
			priority = "5";
		} else {
			priority = msg_data.get("CaseInfo").get("priority");
			Pattern p = Pattern.compile("^\\d$");
			Matcher m = p.matcher(priority);
			if (!m.find()){
				priority = "5";
			}
		}
		// task belong to this client(job_attribute): (0, assign task) > (1, match task)
		String attribute = new String();
		String request_terminal = new String();
		String available_terminal = data_server.client_hash.get("Machine").get("terminal");
		if (!msg_data.containsKey("Machine")){
			attribute = "1";
		} else if (!msg_data.get("Machine").containsKey("terminal")){
			attribute = "1";
		} else {
			request_terminal = msg_data.get("Machine").get("terminal");
			if (request_terminal.contains(available_terminal)){
				attribute = "0"; // assign task 
			} else {
				attribute = "1"; // match task
			}
		}
		// receive time
		//String time = time_info.get_date_time();
		//pack data
		// xxx@runxxx_time :     job_from: 1, from remote; 0, from local
		// priority:match/assign task:job_from@run_number		
		String new_title = priority +  attribute + "1" + "@" + msg_key;
		admin_hash.put(new_title, msg_data);
		return admin_hash;
	}
}