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
import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.TreeMap;
import java.util.concurrent.TimeoutException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.Comparator;

import data_center.public_data;

/*
 * This class used to instance rabbitMQ tube between server and center processor.
 * 1: Memory 
 */
public class rmq_tube {
	// public property
	public static TreeMap<String, HashMap<String, String>> admin_queue_receive = new TreeMap<String, HashMap<String, String>>(
			new Comparator<String>() {
				public int compare(String queue_name1, String queue_name2) {
					// x_x_time#runxxx_time :
					// priority_belong2this_client_time#run_number
					int int_pri1 = 0, int_pri2 = 0;
					int int_clt1 = 0, int_clt2 = 0;
					int int_id1 = 0, int_id2 = 0;
					try {
						int_pri1 = get_srting_int(queue_name1, "^(\\d)_");
						int_pri2 = get_srting_int(queue_name2, "^(\\d)_");
						int_clt1 = get_srting_int(queue_name1, "_(\\d)_");
						int_clt2 = get_srting_int(queue_name2, "_(\\d)_");
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
						if (int_clt1 > int_clt2) {
							return 1;
						} else if (int_clt1 < int_clt2) {
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
				}
			});
	// protected property
	// private property
	private static final Logger RMQ_LOGGER = LogManager.getLogger(rmq_tube.class.getName());
	private static String rmq_host = public_data.RMQ_HOST;
	private static String rmq_user = public_data.RMQ_USER;
	private static String rmq_pwd = public_data.RMQ_PWD;

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
			return 1;
		} catch (TimeoutException e) {
			e.printStackTrace();
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
	public static String read_task_server(String queue_name) throws Exception {
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
		content = "";
		final Consumer consumer = new DefaultConsumer(channel) {
			@Override
			public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties,
					byte[] body) throws IOException {
				String message = new String(body, "UTF-8");
				flag = 1;
				content = message;
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
		return content;
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
				update_admin_queue(message);
			}
		};
		channel.basicConsume(queueName, true, consumer);
	}
}