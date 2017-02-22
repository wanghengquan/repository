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
import java.util.concurrent.TimeoutException;

import data_center.public_data;

/*
 * This class used to instance rabbitMQ tube between server and center processor.
 * 1: Memory 
 */
public class rmq_tube {
	// public property
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

}