package connect_tube;

import com.rabbitmq.client.*;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.concurrent.Callable;
import java.util.concurrent.TimeoutException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.io.FileUtils; 




//http://lsh-reg01:15672/#/queues
import xml_parse.XmlAction;
//windows support
//repository1 = lsh-comedy:/public/jason_test/temp/regression_suite   --pass
//repository2 = D25970:D:/test_dir pass_windows     --pass
//repository3 = http://linux12v/Platform/trunk/bqs_scripts/regression_suite --pass 
//repository4 = //d25970/D/test_dir pass_windows  --pass 
//repository5 = D:/temp/regression_suite
//linux support
//repository6 = http://linux12v/Platform/trunk/bqs_scripts/regression_suite  --pass
//repository7 = lsh-opera:/public/jason_test/temp/regression_suite   --pass
//repository8 = D27639:D:/temp not stable_linux
//repository9 = /public/jason_test/temp  --pass

public class rabbitMQ extends Thread{
	public final static String QUEUE_RESULT_NAME = "Result";
	public final static String QUEUE_INFO_NAME = "Info";
	public static final String TASK_QUEUE_NAME = "task_queue";
	public static final String ADMIN_QUEUE_NAME = "admin_queue";
	private static String HOST = publicData.RABBITMQ_HOST;
	private static String RABBITMQ_USER = publicData.RABBITMQ_USER;
	private static String RABBITMQ_PWD = publicData.RABBITMQ_PWD;
	public final static String [] init_key = {"diamond", "diamondng", "modelsim", "questasim", "riviera", "icecube","squish","radiant"};
	private final static String runningFileList="conf/running.txt";
	private final static String footerFileList="conf/runover.txt";
	private final static String defaultConfigure = "conf/clientConf.conf";
	public static int flag = 0;
	public static String content;
	public static String admin_content;
	public Threadpool pool_instance;
	private HashMap<String, ArrayList> hashmap;
	private volatile boolean stopRequested = false;
	private volatile boolean waitRequested = false;
	private volatile Thread runThread;
	public static List<String> launched_case_list = new ArrayList<String>();
	public static List<String> skiped_case_list = new ArrayList<String>();
	public static TreeMap<String, HashMap> queue_list = new TreeMap<String, HashMap>(new Comparator<String>() {
		public int compare(String queue_name1, String queue_name2) {
			//x_x_time#runxxx_time : priority_belong2me_time#run_number
			int intpri1 = 0, intpri2 = 0;
			int intclt1 = 0, intclt2 = 0;
			int intid1 = 0, intid2 = 0;
			try {
				intpri1 = getInt(queue_name1, "^(\\d)_");
				intpri2 = getInt(queue_name2, "^(\\d)_");
				intclt1 = getInt(queue_name1, "_(\\d)_");
				intclt2 = getInt(queue_name2, "_(\\d)_");				
				intid1 = getInt(queue_name1, "run_(\\d+)_");
				intid2 = getInt(queue_name2, "run_(\\d+)_");
			} catch (Exception e) {
				intpri1 = 0; 
				intpri2 = 0;				
				intclt1 = 0; 
				intclt2 = 0;
				intid1 = 0;
				intid2 = 0;				
			}
			if (intpri1 > intpri2) {
				return 1;
			} else if (intpri1 < intpri2){
				return -1;
			} else {
				if(intclt1 > intclt2){
					return 1;
				}else if (intclt1 < intclt2){
					return -1;
				}else{
					if (intid1 > intid2){
						return 1;
					} else if (intid1 < intid2){
						return -1;
					} else {
						return queue_name1.compareTo(queue_name2);
					}					
				}
			}
		}
	});

	private static int getInt(String str, String patt) {
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
	
	public  rabbitMQ(Threadpool pOOL){
		this.pool_instance = pOOL;		
	}
	
	public static int client_publish_send(String content){
		String EXCHANGE_NAME = "logs";
		ConnectionFactory factory = new ConnectionFactory();
		factory.setHost(HOST);
	    factory.setUsername(RABBITMQ_USER);
	    factory.setPassword(RABBITMQ_PWD);
	    Connection connection;
	    try{
	        connection = factory.newConnection();
	        Channel channel = connection.createChannel();
	        channel.exchangeDeclare(EXCHANGE_NAME, "fanout");
	        channel.basicPublish(EXCHANGE_NAME, "", null, content.getBytes());
	        Date dt=new Date();
		    String localeString=dt.toString();
	        file_action.append_file("log/"+"out_detail_log.txt", "\n"+localeString+":\n"+content);
	        channel.close();
	        connection.close();
	        return 0;
	    } catch(IOException e) {
	    	e.printStackTrace();
			Date dt=new Date();
	 	    String localeString=dt.toString();
			file_action.print_out_to_file_to_gui("In Client Publish Send,\n"+localeString+"\nCan not send message(1) to server");
			return 1;
	    } catch (TimeoutException e) {
	    	e.printStackTrace();
			Date dt=new Date();
	 	    String localeString=dt.toString();
			file_action.print_out_to_file_to_gui("In Client Publish Send,\n"+localeString+"\nCan not send message(1) to server");
			return 1;
	    }
	}
	public static int client_send(String queue_name,String content)  {
		/*
		 * This function used to send the client string to the server.
		 * The Queue name for case result is:Result
		 * The Queue name for the client info is: Info
		 * if the content send smoothly, 0 will be return
		 * Or 1 will be return.
		 */
	    ConnectionFactory factory = new ConnectionFactory();
	    factory.setHost(HOST);
	    factory.setUsername(RABBITMQ_USER);
	    factory.setPassword(RABBITMQ_PWD);
	    Connection connection;
		try {
			connection = factory.newConnection();
		    Channel channel = connection.createChannel();
		    channel.queueDeclare(queue_name, false, false, false, null);
		    String message = content;
		    channel.basicPublish("", queue_name, null, message.getBytes("UTF-8"));
		    Date dt=new Date();
		    String localeString=dt.toString();
		    file_action.append_file("log/out_"+queue_name+".txt", "\n"+localeString+":\n"+message);
		    channel.close();
		    connection.close();
		    return 0;
		} catch (IOException e) {
			e.printStackTrace();
			Date dt=new Date();
	 	    String localeString=dt.toString();
			file_action.print_out_to_file_to_gui("In Client Send,\n"+localeString+"\nCan not send message(1) to server");
			return 1;
		} catch (TimeoutException e) {
			e.printStackTrace();
			Date dt=new Date();
	 	    String localeString=dt.toString();
			file_action.print_out_to_file_to_gui("In Client Send,\n"+localeString+"\nCan not send message(2) to server");
			return 1;
		}
	  }

	
	public static String read_task_server(String queue_name) throws Exception {
		//after this function is called, user need to read the "content"
		// the read string is stored in the content. 
		// At here, we need to sent ACK to the server.
		// when the client get one message from the server, it should stop the connect!
	    ConnectionFactory factory = new ConnectionFactory();
	    factory.setHost(HOST);
	    factory.setUsername(RABBITMQ_USER);
	    factory.setPassword(RABBITMQ_PWD);
	    String v_host;
	    try{
	    	queue_name = queue_name.split("#")[1];
	    	v_host = queue_name.split("_")[1];
	    	v_host = "vhost_"+v_host;
	    }catch(Exception e){
	    	v_host = "/";
	    }
	    if(queue_name.endsWith("queue_30_20_9")){ //this is used for test queue
	    	v_host = "/";
	    	queue_name = "queue_30_20_9";
	    	}
		factory.setVirtualHost(v_host);
	    final Connection connection = factory.newConnection();
	    final Channel channel = connection.createChannel();
	    channel.queueDeclare(queue_name, true, false, false, null);
	    channel.basicQos(1);
        content = "";
        
	    final Consumer consumer = new DefaultConsumer(channel) {
	      @Override
	      public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties, byte[] body) throws IOException {
	        String message = new String(body, "UTF-8");
	        flag = 1;
	        content = message;
	        Date dt=new Date();
	 	    String localeString=dt.toString();
	        file_action.append_file("log/in_task_receive.txt", localeString+":\n"+message);
	        channel.basicAck(envelope.getDeliveryTag(), false);
	        if (channel.isOpen())
				try {
					channel.close();
				} catch (TimeoutException e) {
					e.printStackTrace();
					dt=new Date();
			 	    localeString=dt.toString();
					file_action.print_out_to_file_to_gui("In read_task_server,\n"+localeString+"\nCan not close the channel(1)");
				}
		    if(connection.isOpen())
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
				Date dt=new Date();
		 	    String localeString=dt.toString();
				file_action.print_out_to_file_to_gui("In read_task_server,\n"+localeString+"\nCan not close the channel(2)");
			}
	    if(connection.isOpen())
	    	connection.close();
	    return content;
	  }
	
	public static synchronized String readWrite_adminContent(Boolean write_flag,String add_content){
		String return_string=null;
		if(write_flag){
			if(admin_content==null)
				admin_content =add_content;
			else
				admin_content += "\n"+add_content;
			return return_string;
		}
		else{
			return_string = admin_content;
			admin_content = null;
			return return_string;
		}
	}
	public static synchronized void updateAdmin_queueList(String content){
		/*
		 * This function used to update the admin queue list.
		 * and at here, the client will make check the message is usful or not.
		 */
		content = content.replaceAll("\\s", " ");
		Map<String, ?> requestMap_root = XmlAction.parse_admin_aueue(content);
		Set<String> request_key_root = ((HashMap) requestMap_root).keySet();	
		String queue_name = null;
		if(request_key_root.size() == 1){
			Iterator<String> queue_iter = request_key_root.iterator();
			queue_name = queue_iter.next();
		}
		if(queue_name == null)
			return;
		//client_task: task queue directly request this client do  the task otherwise belong to match task.
		Boolean client_task = false;
		Monitor monitor = new Monitor();
		String action = "";
		boolean match_requirement=true;
		HashMap<String, String> request_map = (HashMap) requestMap_root.get(queue_name);
		Set<String> request_key = ((HashMap) request_map).keySet();
		//check priority
		String priority = null;
		if (request_key.contains("CaseInfo") ){
			Object value = ((HashMap<String, String>) request_map).get("CaseInfo");
			if (value instanceof String) {
				//System.out.println(value);
				;
			}
			else if(value instanceof HashMap){
				priority = (String) ((HashMap) value).get("priority");
			}
			if (priority==null){
				priority = "2";
			}
			priority = priority.trim();
			Pattern pri_patt= Pattern.compile("^\\d$");
			Matcher m = pri_patt.matcher(priority);
			if(!m.find())
				priority = "2";			
		} else {
			return;
		}
		//machine matching
		String terminal = null;
		String group = null;		
		Boolean terminal_match = true; 
		Boolean group_match = true;
		if (request_key.contains("Machine") ){//get client and group from message
			Object value = ((HashMap<String, String>) request_map).get("Machine");
			if (value instanceof String) {
				//System.out.println(value);
				;
			}
			else if(value instanceof HashMap){
				//parseHash(value);
				terminal = (String) ((HashMap) value).get("terminal");
				group = (String) ((HashMap) value).get("group");				
			}
			// get client name and group name from client_conf
			String terminal_conf = null;
			String client_group = null;
			try {
				terminal_conf = ConfigurationFile.getProfileString(defaultConfigure, "machine", "terminal", null);
				} catch (IOException e) {
				e.printStackTrace();
				Date dt=new Date();
		 	    String localeString=dt.toString();
				file_action.print_out_to_file_to_gui("In updateAdmin_queueList,\n"+localeString+"\nCan not read configure file");
			}
			if (terminal_conf == null){
				//get the client_conf from monitor block
				terminal_conf = monitor.getHost_name();
			}
			client_group = monitor.getGroup_name();
			//start match client
			if(terminal != null){
				terminal = terminal.toLowerCase().trim();
				terminal_conf = terminal_conf.toLowerCase().trim();
				if (terminal.indexOf(terminal_conf) > -1){
					//System.out.println("Terminal:" +  "match_");
					client_task = true;
				}
				else{
					//System.out.println("Terminal:" +  "not match_");
					match_requirement = false;
					terminal_match = false;
				}
			}
			if(group!= null){
				group= group.toLowerCase().trim();
				client_group = client_group.toLowerCase().trim();
				//if(group.contains(client_group)){
				if(group.equalsIgnoreCase(client_group)){
					;
				}
				else{
					match_requirement = false;
					group_match = false;
				}
			}
		}
		Boolean os_match = true;             
		Boolean os_type_match = true;
		Boolean os_arch_match = true;
		Boolean machine_type_match = true;
		Boolean min_space_match = true;		
		if (request_key.contains("System") ){
			String os = null;
			String os_type = null;
			String os_arch = null;
			//String min_space = null;
			//String min_cpu = null;
			//String min_mem = null;
			Object value = ((HashMap<String, String>) request_map).get("System");
			if (value instanceof String) {
				//System.out.println(value);
				;
			} else if (value instanceof HashMap){
				//parseHash(value);
				os = (String) ((HashMap<?, ?>) value).get("os");
				os_type = (String)((HashMap<?, ?>) value).get("os_type");
				os_arch = (String)((HashMap<?, ?>) value).get("os_arch");				
				//min_space = (String) ((HashMap<?, ?>) value).get("min_space");
				//min_cpu = (String) ((HashMap<?, ?>) value).get("min_cpu");
				//min_mem = (String) ((HashMap<?, ?>) value).get("min_mem");
			}
			String monitor_os = monitor.os;	
			String monitor_os_type = monitor.getOsType();
			String monitor_os_arch = monitor.os_arch;			
			//String monitor_disk_left = monitor.getDisk_left();
			//String monitor_cpu_used = monitor.getCpu_used(); //just process number
			//String monitor_memory_left = monitor.getMemory_left();//just process number
			if (os != null){
				if(!os.equalsIgnoreCase(monitor_os))
					match_requirement = false;
				    os_match = false;
			}
			if(os_type != null){
				if(!os_type.equals(monitor_os_type)){
					match_requirement = false;
					os_type_match =false;
				}
			}
			if(os_arch != null){
				if(!os_arch.equals(monitor_os_arch)){
					match_requirement = false;
					os_arch_match =false;
				}
			}		
			/* At here,we will ingore the cpu and mem after discussion 11/26
			if(min_space != null){
				if(Float.parseFloat(min_space.replaceAll("[a-zA-Z]", "")) > Float.parseFloat(monitor_disk_left.replaceAll("[a-zA-Z]", "")))
					match_requirement = false;
				    min_space_match = false;
			}
			if(min_cpu != null){
				if(Float.parseFloat(min_cpu.replaceAll("[a-zA-Z]", "")) > Float.parseFloat(monitor_cpu_used.replaceAll("[a-zA-Z]", "")))
					match_requirement = false;
			}
			if(min_mem != null){
				if(Float.parseFloat(min_mem.replaceAll("[a-zA-]", "")) > Float.parseFloat(monitor_memory_left.replaceAll("[a-zA-]", "")) )
					match_requirement = false;
			}
			*/
		}
		Boolean software_match = true;		
		if (request_key.contains("Software") ){
			// get all the software version and compare.
			Object value = ((HashMap<String, String>) request_map).get("Software");
			Iterator<String> iterator_key = ((HashMap) value).keySet().iterator(); 
			//jason think this is a problem which make a poor performance
			//Monitor.SetScanDiamond();
			while (iterator_key.hasNext()) { 
				String key = iterator_key.next();
				String request_value = (String) ((HashMap<?, ?>) value).get(key);
				request_value = request_value.trim();
				if (request_value instanceof String) {
					String conf_value = " ";
					//if("diamond".equalsIgnoreCase(key.trim()))
					if(Arrays.asList(init_key).contains(key.trim())){					
							try {
								conf_value = ConfigurationFile.getProfileString(defaultConfigure, key.trim(), request_value, "default");
							} catch (IOException e1) {
								// TODO Auto-generated catch block
								e1.printStackTrace();
							}
					} else {
							try {
								conf_value = ConfigurationFile.getProfileString(defaultConfigure, "soft", request_value, "default");
							} catch (IOException e) {
								e.printStackTrace();
								Date dt=new Date();
						 	    String localeString=dt.toString();
								file_action.print_out_to_file_to_gui("In updateAdmin_queueList,\n"+localeString+"\nCan not read clientConf(2)");
							}
						}
					if(conf_value.equalsIgnoreCase("default") ) {
							match_requirement = false;
							software_match = false;
							break;
					}
				}
			}
		}
		if (request_key.contains("Status") ){
			Object value = ((HashMap<String, String>) request_map).get("Status");
			if (value instanceof String) {
				//System.out.println(value);
				;
			}else if(value instanceof HashMap){
				//parseHash(value);
				action = (String) ((HashMap<?, ?>) value).get("admin_status");
			}
		}
		if (match_requirement){
		    if(action.matches("pause")){
			    Iterator<String> iterator_temp = queue_list.keySet().iterator(); 
			    while (iterator_temp.hasNext()) { 
				    String key = iterator_temp.next();
				    if(key.endsWith("#"+queue_name)){
					    iterator_temp.remove();
					    break;
				    }
			    }
		    }else if(action.matches("stop")){
			    Iterator<String> iterator_key = queue_list.keySet().iterator(); 
			    while (iterator_key.hasNext()) { 
				    String key = iterator_key.next();
				    if(key.endsWith("#"+queue_name)){
					    iterator_key.remove();
					    break;
				    }
			    }
		    }else{
			    Set<String> task_queue_array =queue_list.keySet();
			    if (task_queue_array.toString().indexOf(queue_name) < 0){
			    	//step1put detail request
			    	request_map.put("action", "0");
			    	//step2generate internal queue name
			    	//step2-1: get machine private
			    	String client_private = new String();
					try {
						client_private = ConfigurationFile.getProfileString(defaultConfigure, "machine", "private", null);
					} catch (IOException e) {
						e.printStackTrace();
						Date dt=new Date();
						String localeString=dt.toString();
						file_action.print_out_to_file_to_gui("In updateAdmin_queueList,\n"+localeString+"\nCan not read client private value");
					}
					if (client_private == null){
						client_private = "1"; //by default client only run task assign to it.
					}
					client_private = client_private.trim();
					if(client_private.equals("0")){
						if (client_task){
							queue_name = priority+ "_0_"+System.currentTimeMillis() / 1000+"#"+queue_name; //higher priority
						}else{
							queue_name = priority+ "_1_"+System.currentTimeMillis() / 1000+"#"+queue_name; //higher priority
						}
					}else{
						if (client_task){
							queue_name = priority+ "_0_"+System.currentTimeMillis() / 1000+"#"+queue_name; //higher priority
						}else{
							System.out.println(">>>Info: Skip Queue:" + queue_name + "[private]");
							return;
						}
					}
					queue_list.put(queue_name, request_map);
			    }
		    }
		} else{
			List<String> report_list = new ArrayList<String>();
			if (!terminal_match){
				report_list.add("terminal");
			}
			if (!group_match){
				report_list.add("group");
			}
			if (!os_match){
				report_list.add("os");
			}	
			if (!os_type_match){
				report_list.add("os_type");
			}	
			if (!os_arch_match){
				report_list.add("os_arch");
			}	
			if (!machine_type_match){
				report_list.add("machine_type");
			}
			if (!min_space_match){
				report_list.add("min_space");
			}	
			if (!software_match){
				report_list.add("software");
			}
			String report_str = report_list.toString();
			System.out.println(">>>Info: Skip Queue:" + queue_name + ". Mismatch:" + report_str);
		}
	}
	
	
	public static void read_admin(String queue_name)throws Exception{
		/*
		 * This function used to read the admin queue and return the strings
		 * at here we use Publish/Subscribe in rabbitmq
		 */
		ConnectionFactory factory = new ConnectionFactory();
		factory.setHost(HOST);
	    factory.setUsername(RABBITMQ_USER);
	    factory.setPassword(RABBITMQ_PWD);
	    factory.setAutomaticRecoveryEnabled(true);
	    final Connection connection = factory.newConnection();
	    final Channel channel = connection.createChannel();
	    channel.exchangeDeclare(ADMIN_QUEUE_NAME, "fanout");
	    String queueName = channel.queueDeclare().getQueue();
	    channel.queueBind(queueName, ADMIN_QUEUE_NAME, "");
	    Consumer consumer = new DefaultConsumer(channel) {
	      @Override
	      public void handleDelivery(String consumerTag, Envelope envelope,
	                                 AMQP.BasicProperties properties, byte[] body) throws IOException {
	        String message = new String(body, "UTF-8");
	        //System.out.println(message);
	        //readWrite_adminContent(true,message);
	        updateAdmin_queueList(message);
	        //System.out.println("get one message over");
	        Date dt=new Date();
	 	    String localeString=dt.toString();
	        file_action.append_file("log/in_admin_receive.txt", localeString+"\n"+message);
		    }
	      };
	    channel.basicConsume(queueName, true, consumer);
	  }
	
	public HashMap<String, HashMap<String, String>> merge_local_case(Map<String,String> suite_data, Map<String, String> case_data){
		HashMap<String, HashMap<String, String>> task_data = new HashMap<String, HashMap<String, String>>();
		//insert id data
		String project_id = suite_data.get("project_id").trim();
		String suite_id = suite_data.get("suite_name").trim();
		String case_id = case_data.get("Order").trim();
		HashMap<String, String> id_map = new HashMap<String, String>();
		if (project_id.equals("") || project_id == null){
			id_map.put("project", "prj");
		}else{
			id_map.put("project", project_id);
		}
		if (suite_id.equals("") || suite_id == null){
			id_map.put("suite", "run");
			id_map.put("run", "run");
		}else{
			id_map.put("suite", suite_id);
			id_map.put("run", suite_id);
		}	
		if (case_id.equals("") || case_id == null){
			id_map.put("id", "case");
		}else{
			id_map.put("id", case_id);
		}
		task_data.put("ID", id_map);
		//insert CaseInfo data
		String suite_info = suite_data.get("CaseInfo").trim();
		String case_info = case_data.get("CaseInfo").trim();
		String design_info = case_data.get("design_name").trim();
		HashMap<String, String> case_map = merge_data(suite_info, case_info);
		if(!case_map.containsKey("design_name")){
			case_map.put("design_name", design_info);
		}
		task_data.put("CaseInfo", case_map);
		//insert Environment data
		String suite_environ = suite_data.get("Environment").trim();
		String case_environ = case_data.get("Environment").trim();
		HashMap<String, String> environ_map = merge_data(suite_environ, case_environ);
		task_data.put("Environment", environ_map);
		//insert LaunchCommand data
		String suite_cmd = suite_data.get("LaunchCommand").trim();
		String case_cmd = case_data.get("LaunchCommand").trim();
		HashMap<String, String> cmd_map = merge_data(suite_cmd, case_cmd);
		task_data.put("LaunchCommand", cmd_map);		
		//insert Software data
		String suite_software= suite_data.get("Software").trim();
		String case_software = case_data.get("Software").trim();
		HashMap<String, String> software_map = merge_data(suite_software, case_software);
		task_data.put("Software", software_map);			
		//insert System data
		String suite_system= suite_data.get("System").trim();
		String case_system = case_data.get("System").trim();
		HashMap<String, String> system_map = merge_data(suite_system, case_system);
		task_data.put("System", system_map);	
		//insert Machine data
		String suite_machine= suite_data.get("Machine").trim();
		String case_machine = case_data.get("Machine").trim();
		HashMap<String, String> machine_map = merge_data(suite_machine, case_machine);
		task_data.put("Machine", machine_map);	
		return task_data;
	}
	
	private HashMap<String, String> merge_data (String suite_info, String case_info){
		String globle_str = suite_info.replaceAll("^;", "");
		String local_str = case_info.replaceAll("^;", "");
		String [] globle_array = globle_str.split(";");
		String [] local_array = local_str.split(";");	
		HashMap<String, String> globle_data = new HashMap<String, String>();
		for(String globle_item : globle_array){
			if(!globle_item.contains("=")){
				//System.out.println(">>>Warning: skip suite item:" + globle_item + " .");
				continue;
			}
			String globle_key = globle_item.split("=", 2)  [0].trim();
			String globle_value = globle_item.split("=", 2)[1].trim();
			globle_data.put(globle_key, globle_value);
		}
		HashMap<String, String> local_data = new HashMap<String, String>();
		for(String local_item : local_array){
			if(!local_item.contains("=")){
				//System.out.println(">>>Warning: skip case item:" + local_item + " .");
				continue;
			}
			String local_key = local_item.split("=", 2)[0].trim();
			String local_value = local_item.split("=", 2)[1].trim();
			local_data.put(local_key, local_value);
		}		
		Set <String> local_set = local_data.keySet();
		Iterator <String> local_it = local_set.iterator();
		while(local_it.hasNext()){
			String local_key = local_it.next();
			String local_value = local_data.get(local_key);
			if (local_key.equals("cmd")){
				if(local_data.containsKey("override")){
					String local_override = local_data.get("override");
					if(local_override.equals("local")){
						globle_data.put("cmd", local_value);
					} 
				} else if (globle_data.containsKey("override")){
					String globle_override = globle_data.get("override");
					if(globle_override.equals("local")){
						globle_data.put("cmd", local_value);
					}
				} else {
					String local_cmd = local_data.get("cmd");
					String globle_cmd = globle_data.get("cmd");
					String overall_cmd = globle_cmd + " " + local_cmd;
					globle_data.put("cmd", overall_cmd);
				}
			} else {
				globle_data.put(local_key, local_value);
			}
		}
		return globle_data;
	}
	
	@SuppressWarnings({ "unchecked", "null" })
	public static HashMap<String, HashMap<String, String>> merge_link_case(HashMap<?, ?> admin_queue, Map<?, ?> task_info){
		/*
		 * At here, we need to merge the admin queue info and task info together
		 * 1. merge ID
		 * 2. merge CaseInfo
		 * 3. merge Environment
		 * 4. merge launch_command
		 */
		HashMap<String, HashMap<String, String>> return_info = new HashMap<String, HashMap<String, String>>();
		Set<?> admin_queue_keys = admin_queue.keySet();
		Set<?> task_queue_keys = task_info.keySet();
		HashMap<String, String> admin_temp = new HashMap<String, String>();
		HashMap<String, String> task_temp = new HashMap<String, String>();
		HashMap<String, String> result_temp = new HashMap<String, String>();
		HashMap<String, String> result_temp2 = new HashMap<String, String>();
		HashMap<String, String> result_temp3 = new HashMap<String, String>();
		HashMap<String, String> result_temp4 = new HashMap<String, String>();
		HashMap<String, String> result_temp5 = new HashMap<String, String>();
		boolean admin_flag = false;
		boolean task_flag = false;
		if (admin_queue_keys.contains("ID")){
			admin_temp = (HashMap<String, String>) admin_queue.get("ID");
		}
		if(task_queue_keys.contains("TestID")){
			task_temp = (HashMap<String, String>) task_info.get("TestID");
		}
		if(!admin_temp.isEmpty()){
			//System.out.println("+++"+admin_temp.toString());
			result_temp.putAll(admin_temp);
		}
		if(!task_temp.isEmpty()){
			result_temp.putAll(task_temp);
		}
		if (!result_temp.isEmpty())
		    return_info.put("ID", result_temp); // merge IDs over;
		
		if (admin_queue_keys.contains("CaseInfo")){
			admin_temp = (HashMap<String, String>) admin_queue.get("CaseInfo");
			admin_flag = true;
		}
		if(task_queue_keys.contains("CaseInfo")){
			task_temp = (HashMap<String, String>) task_info.get("CaseInfo");
			task_flag = true;
		}
		if(admin_flag){
			result_temp2.putAll(admin_temp);
		}
		if(task_flag){
			result_temp2.putAll(task_temp);
		}
		if (!result_temp2.isEmpty())
		    return_info.put("CaseInfo", result_temp2);
		
		// merge CaseInfo over;
		admin_flag = false;
		task_flag = false;
		if (admin_queue_keys.contains("Environment")){
			admin_temp = (HashMap<String, String>) admin_queue.get("Environment");
			admin_flag = true;
		}
		if(admin_flag){
			result_temp3.putAll(admin_temp);
			return_info.put("Environment", result_temp3); // merge Environment over
			admin_flag = false;
		}
		if (admin_queue_keys.contains("Software")){
			admin_temp = (HashMap<String, String>) admin_queue.get("Software");
			admin_flag = true;
		}
		if(admin_flag){
			result_temp4.putAll(admin_temp);
			return_info.put("Software", result_temp4); // merge Software over
			admin_flag = false;
		}
		//merge command lines in admin and task
		admin_flag = false;
		task_flag = false;		
		Boolean admin_unique_cmd = false;
		Boolean task_unique_cmd = false;
		String cmd_admin = " ";
		String cmd_task = " ";
		String cmd = null;		
		if (admin_queue_keys.contains("LaunchCommand")){
			admin_temp = (HashMap<String, String>) admin_queue.get("LaunchCommand");
			admin_flag = true;
		}
		if(task_queue_keys.contains("LaunchCommand")){
			task_temp = (HashMap<String, String>) task_info.get("LaunchCommand");
			task_flag = true;
		}
		if(admin_flag){
			//result_temp.putAll(admin_temp);
			if (admin_temp.containsKey("cmd")){
				cmd_admin = (String) admin_temp.get("cmd");
			}
			if (admin_temp.containsKey("override")){
				String admin_unique_status =(String) admin_temp.get("override").toLowerCase();
				if(admin_unique_status.equals("globle")){
					admin_unique_cmd = true;
				}
			}
		}
		if(task_flag){
			if(task_temp.containsKey("cmd")){
				cmd_task = (String) task_temp.get("cmd");
			}
			if(task_temp.containsKey("override")){
				String task_unique_status = (String) task_temp.get("override").toLowerCase();
				if(task_unique_status.equals("local")){
					task_unique_cmd = true;
				}
			}
		}
		if (admin_unique_cmd){
			cmd = cmd_admin;
		} else if (task_unique_cmd) {
			cmd = cmd_task;
		} else {
			cmd = cmd_admin + " " + cmd_task;
		}
		cmd = cmd.trim();
		if(cmd != null && !cmd.isEmpty()){
			result_temp5.put("cmd", cmd);
			return_info.put("LaunchCommand", result_temp5); // merge CaseInfo over;
		}
		//System.out.println("In rabbitMQ.merge_link_case the return_info is:"+return_info.toString());
		return return_info;
	}
	public static ArrayList<String> case_prepare(HashMap<String, HashMap<String, String>> case_info){
		/*
		 * 1: download case
		 * 2: download script
		 * 3: prepare environment
		 */
		String repository = null;
		String suite_directory = null;
		String case_name = null;
		String init_case_name = null;
		String script_address = null;
		String auth_key = "Yjt7LEio8/f0c3/eaa3otw=="; //guest_+_welcome
		String user_passwd = null;
		HashMap<?, ?> caseInfo = (HashMap<?, ?>) case_info.get("CaseInfo");
		HashMap<?, ?> IDs = (HashMap<?, ?>) case_info.get("ID");
		String testId = "";
		String caseId = "";
		String suiteId = "";
		String runId = "";
		String projectId = "";
		String design_name = "";
		String script_name = "";
		String trce_back_dir = "";
		testId = "T" + (String) IDs.get("id");
		ArrayList<String> return_list = new ArrayList<String>();
		String return_string = null;
		String case_dir = null;
		String change_to_casedir = null;
		String timeout = "3600";
		if (caseInfo != null){
			repository = (String) caseInfo.get("repository");
			suite_directory = (String) caseInfo.get("suite_path");
			case_name = (String) caseInfo.get("design_name");
			String public_key = decode.key;
			if ( (String) caseInfo.get("auth_key") != null){
				auth_key = (String) caseInfo.get("auth_key");
			}
			try{
			    user_passwd = decode.decrypt(auth_key, public_key);
			}
			catch (Exception e) {
				e.printStackTrace();
				return_string = "1";
				Date dt=new Date();
		 	    String localeString=dt.toString();
				file_action.print_out_to_file_to_gui("In case_prepare,\n"+localeString+"\nCan not run system command");				
			}
			String user_name = GetUserName(user_passwd); 
			String pass_word = GetPassWord(user_passwd);
			timeout = (String) caseInfo.get("timeout");
			if ( timeout == null || timeout == "null"){
				timeout = "3600";
			}
			Pattern p_timeout = Pattern.compile("\\D");
			Matcher m = p_timeout.matcher(timeout);
			if(m.find())
				timeout = "3600";
			if(timeout.equals("0")){
				timeout = "18000";
			}
			init_case_name = case_name;
			if ( repository != null && repository != "null"){
				String case_url = repository.trim()+"/"+suite_directory+"/"+case_name;
				File real_path = new File(case_name);
				design_name = real_path.getName();
				//case_dir = "result/"+IDs.get("project")+"/"+IDs.get("run")+"/"+suite_directory+"/"+case_name;  // at here, we  need trim like action
				case_dir = "result/prj"+IDs.get("project")+"/run"+IDs.get("run")+"/"+testId;
				change_to_casedir = case_dir;
				trce_back_dir = "../../../..";
				//make case_dir
				//String separate = System.getProperty("file.separator");
				//case_dir = "result" + separate + IDs.get("project") + separate + IDs.get("run") + separate + suite_directory + separate + case_name;
				//result\prj6\runmisc_diamond_regression\Tm0_2_
				File case_path = new File(case_dir);
				File design_path = new File(case_dir, design_name);
				String work_dir = design_path.getParent().replace("\\", "/"); 
				if (case_path.exists() && case_path.isDirectory()){
					if(FileUtils.deleteQuietly(case_path)){
						if(TopRun.dug_model){
							System.out.println(">>>Info: successed to delete path:" + case_path);	
						}
					} else {
						System.out.println(">>>Warning: failed to delete path:" + case_path);
					}
				}
				String host_name = System.getProperty("os.name").toLowerCase();
				try{
					if (host_name.startsWith("windows")){
						execute_system_cmd.run("conf\\mkdir -p " + work_dir);
					}
					else{
						execute_system_cmd.run("mkdir -p " + work_dir);
					}
				 } catch (IOException e) { 
						e.printStackTrace();
						return_string = "1";
						Date dt=new Date();
				 	    String localeString=dt.toString();
						file_action.print_out_to_file_to_gui("In case_prepare,\n"+localeString+"\nCan not run system command");					 
				 }
				//String cmd = "svn export "+case_url+" "+case_dir +" --username=public --password=lattice";
				String local_rpt_path = case_dir + "/" + publicData.case_rpt;
				file_action.delete_file(local_rpt_path);
				file_action.append_file(local_rpt_path, "[Export]"+publicData.line_separator);
				ArrayList<String> cmd_array = GetExportCMD(case_url, user_name, pass_word, design_path.getPath().replace("\\", "/"));
				try {
					ArrayList<String> svn_lines = new ArrayList<String>();
					ArrayList<String> svn_script = new ArrayList<String>();
					//export cases
					for(String run_cmd:cmd_array){
						try{
							for(String line: execute_system_cmd.run(run_cmd))
								svn_lines.add(line);
						} catch (IOException e) {
							e.printStackTrace();
							return_string = "1";
							Date dt=new Date();
					 	    String localeString=dt.toString();
							file_action.print_out_to_file_to_gui("In case_prepare,\n"+localeString+"\nCan not run system command");
							}
					}
					//yu's script ArrayList<?> svn_lines = execute_system_cmd.run(cmd); // at here, we need special process
					//export scripts
					script_address = (String ) caseInfo.get("script_address");
					if(script_address != null && script_address!= ""){
						script_address = script_address.trim(); 
						script_address = script_address.replaceAll("\\\\", "/");
						script_name = script_address.substring(script_address.lastIndexOf("/")+1); 
						svn_script = execute_system_cmd.run("svn export "+script_address + " "+case_dir+"/"+script_name + " --username=public --force --password=lattice --no-auth-cache");
						//file_action.append_file("log/debug.txt", "svn export "+script_address + " "+case_dir+"/"+script_name+" --username=public --force --password=lattice --no-auth-cache " +"\n");
					}
					else
						svn_script.add(">>>Info: Integrated script used, no more script export.");
					file_action.append_file(local_rpt_path, ">>>Case Export:"+publicData.line_separator);
					 for(String svn1:svn_lines)
						 file_action.append_file(local_rpt_path, svn1+publicData.line_separator);
					 file_action.append_file(local_rpt_path, ">>>Script Export:"+publicData.line_separator);
					 for(String svn2:svn_script)
						 file_action.append_file(local_rpt_path, svn2+publicData.line_separator);
				} catch (IOException e) {
					//e.printStackTrace();
					System.out.println("IOException");
					return_string = "1";
					Date dt=new Date();
			 	    String localeString=dt.toString();
					file_action.print_out_to_file_to_gui("In case_prepare,\n"+localeString+"\nCan not run system command");
					}
				}else{
					if(suite_directory != null && suite_directory!="")
						case_dir = suite_directory+"/"+case_name;
					else{
						case_dir = case_name;
					}
				}
		}
		if(return_string == null){
			 return_string = "";
		     HashMap<?, ?> software_request  = (HashMap<?, ?>) case_info.get("Software");
		     HashMap<?, ?> environment_request = (HashMap<?, ?>) case_info.get("Environment");
		     //String [] init_key = {"diamond", "modelsim", "questasim", "riviera", "icecube"};
		     if(software_request!= null && !software_request.isEmpty()){
		    	 //System.out.println(software_request.toString());
			     Iterator<?> request_key= software_request.keySet().iterator();
			     while(request_key.hasNext()){
			    	 String temp_key = (String) request_key.next();
			    	 String temp_key_value = (String) software_request.get(temp_key);
			    	 for(int i=0;i<init_key.length;i++){
			    		 if(temp_key.equals(init_key[i])){
			    			 try {
								temp_key_value = ConfigurationFile.getProfileString(defaultConfigure, temp_key,temp_key_value, "default");
								if(temp_key_value.equals("default"))
									temp_key_value = ConfigurationFile.getProfileString(defaultConfigure, "soft",temp_key_value, "default");
								if(temp_key_value.equals("default"))
									temp_key_value = " ";
			    			 } catch (IOException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
								temp_key_value = " ";
							}
			    			 temp_key = "EXTERNAL_" + temp_key.toUpperCase() + "_PATH";
			    		 }
			    	 }
			    	 return_string +=temp_key+"="+ temp_key_value+";";
			     } 
		     }
		     if(environment_request!= null && !environment_request.isEmpty()){
			     Iterator<?> environment_key= environment_request.keySet().iterator();
			     while(environment_key.hasNext()){
			    	 String temp_key = (String) environment_key.next();
			    	 return_string +=temp_key+"="+ environment_request.get(temp_key)+";";
			     } 
		     }
		}
		if( IDs != null){
			caseId = (String) IDs.get("id");
			suiteId = (String) IDs.get("suite");
			projectId = (String) IDs.get("project");
			runId = (String) IDs.get("run");
		}
		return_list.add(return_string);
		return_list.add(case_dir);
		return_list.add(suite_directory);
		return_list.add(caseId);
		return_list.add(suiteId);
		return_list.add(change_to_casedir);
		return_list.add(projectId);
		return_list.add(runId);
		return_list.add(init_case_name);
		return_list.add(timeout);
		return_list.add(design_name);
		return_list.add(script_name);
		return_list.add(trce_back_dir);
		return return_list;	
	}
	
	private static String GetUserName(String user_password){
		String [] str_list	= user_password.split("_\\+_");
		return str_list[0];
	}	
	
	private static String GetPassWord(String user_password){
		String [] str_list	= user_password.split("_\\+_");
		return str_list[1];
	}		
	
	private static ArrayList<String> GetExportCMD(String case_url, String user_name, String pass_word, String case_dir){
		/* Current we support the following address
		repository					+			suite_path			+			design_name
		http://linux12v/test_dir 	+			test_suite			+			test_case
		<host>:M:/test_dir			+			test_suite			+			test_case
		\\lsh-smb01\test_dir		+			test_suite			+			test_case
		/lsh/sw/test_test			+			test_suite			+			test_case			
		*/
		String host_run = System.getProperty("os.name").toLowerCase();
		String [] url_array = case_url.split(":", 2);
		String host_src = 	url_array[0];
		ArrayList<String> cmd_array = new ArrayList<String>();
		if (host_src.length() > 1 && url_array.length > 1){
			if (host_src.equalsIgnoreCase("http")){
				//svn path
				cmd_array.add("svn export " + case_url + " " + case_dir + " --username=" + user_name + " --password=" + pass_word + " --no-auth-cache" + " --force");
			}else{
				//client path
				if (host_run.startsWith("windows")){
					if (url_array[1].startsWith("/")){
						//1 windows run linux src, linux path always start with /
						//pscp -r -l jwang1 -pw lattice1 lsh-comedy:/public/jason_test/temp/src c:/users\jwang1\Desktop
						cmd_array.add("conf\\pscp -r -p -l " + user_name + " -pw " + pass_word + " " + case_url + " " + case_dir);								
					} else {
						//2 windows run windows src
						//              D25970:D:/test_dir
						//xcopy  \\D25970\D$\auto_install.bat c:/user\jwang1\Desktop
						String dest_path = url_array[1].replaceFirst(":", "\\$");
						cmd_array.add("xcopy  \\\\" + url_array[0] + "\\" + dest_path.replace("/", "\\") + " " + case_dir.replace("/", "\\\\") + "\\ /E /Y /A");						
					}
				}else{
					//1 linux run linux src
					//./conf/sshpass/sshpass -p "lattice1" scp -r -l jwang1 lsh-opera:/public/jason_test/temp/jdk.rpm ./
					//2 linux run windows src
					//./conf/sshpass/sshpass -p "lattice" scp -r -l jwang1 D27639:M:/test.txt ./					
					cmd_array.add("conf/sshpass/sshpass -p \"" + pass_word + "\" scp -r -p " + user_name + "@" + case_url + " " + case_dir);
				}
			}
		}else{
			//direct path
			//cp -r case_url case_dir
			if (host_run.startsWith("windows")){
				cmd_array.add("conf\\cp -r -p " + case_url + " " + case_dir);
			}
			else{
				cmd_array.add("cp -r -p " + case_url + " " + case_dir);
			}
		}
		return  cmd_array;
	}
	
	public void write_running_record(String runId, String CaseId,String DesignName,String Path){
		String add_line = runId+","+CaseId+","+DesignName+","+Path+"%\n";
		file_action.append_file(runningFileList, add_line);
	}
	
	public static String getJobDir(String cmd){
		//String cmd="python sadfsd.py --top-dir=adfsa --job-dir=sfeasfwfs --job-dir=222 d";
		String regEx = ".*--job-dir=(.*)(\\s|$)";
		Pattern pattern = Pattern.compile(regEx);
		Matcher matcher = pattern.matcher(cmd);
		if(!matcher.find()){
			//System.out.println("Can not find directory");
			File directory = new File("."); 
        	String parent_directory;
			try {
				parent_directory = directory.getCanonicalPath();
				return parent_directory;
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return " ";
			}
		    //return parent_directory;
		}
		return matcher.group(1);
	}

	public Boolean squish_task(HashMap<String, HashMap<String, String>> case_info){
		HashMap<?, ?> launchcmd = (HashMap<?, ?>) case_info.get("LaunchCommand");
		HashMap<?, ?> software = (HashMap<?, ?>) case_info.get("Software");
		Boolean cmd_find = false;
		Boolean sw_find = false;
		String cmd = "";
		if (launchcmd !=null && launchcmd.containsKey("cmd")){
			cmd = launchcmd.get("cmd").toString();
		}
		if (cmd.indexOf("squish") >= 0){
			cmd_find = true;
		}
		if (software !=null && software.containsKey("squish")){
			sw_find = true;
		}
		if (cmd_find || sw_find){
			return true;
		} else {
			return false;
		}
	}
	
	private Boolean local_case_sorting (HashMap<String,HashMap<String, String>> case_data){
		HashMap<String, String> id_map = new HashMap<String, String>();
		HashMap<String, String> software_map = new HashMap<String, String>();
		HashMap<String, String> system_map  = new HashMap<String, String>();
		HashMap<String, String> machine_map = new HashMap<String, String>();
		List<String> mismatch_list = new ArrayList<String>();
		//case info map
		id_map = case_data.get("ID");
		String case_id = id_map.get("id");
		String case_run = id_map.get("run");
		String case_prj = id_map.get("project");
		//software check
		//Monitor.SetScanDiamond();
		software_map = case_data.get("Software");
		Set<String> software_set = software_map.keySet();
		Iterator<String> software_it = software_set.iterator();
		while(software_it.hasNext()){
			String software_key = software_it.next();
			String software_value = software_map.get(software_key).trim();
			String client_software_path = new String();
			try {
				client_software_path = ConfigurationFile.getProfileString(defaultConfigure, software_key, software_value, "default");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//not find path for this software version will make an error out
			if(client_software_path.equalsIgnoreCase("default")){
				mismatch_list.add("Software");
				break;
			}
		}
		//System check
		Monitor monitor = new Monitor();
		system_map = case_data.get("System");
		Set<String> system_set = system_map.keySet();
		Iterator<String> system_it = system_set.iterator();		
		while(system_it.hasNext()){
			String system_key = system_it.next();
			String system_value = system_map.get(system_key).trim();
			String client_value = new String();
			switch(system_key){
			case "os":
				client_value = monitor.getOs();
				break;
			case "os_arch":
				client_value = monitor.getOsArch();
				break;				
			case "os_type":
				client_value = monitor.getOsType();
				break;
			default:
				client_value = "default";
			}
			if (!system_value.equalsIgnoreCase(client_value)){
				mismatch_list.add("System");
				break;
			}
		}
		//Machine check
		machine_map = case_data.get("Machine");
		Set<String> machine_set = machine_map.keySet();
		Iterator<String> machine_it = machine_set.iterator();
		while(machine_it.hasNext()){
			String machine_key = machine_it.next();
			String machine_value = machine_map.get(machine_key).trim();
			String client_machine_value = new String();
			switch(machine_key){
			case "terminal":
				client_machine_value = monitor.getHost_name();
				break;
			case "group":
				client_machine_value = monitor.getGroup_name();
				break;	
			default:
				client_machine_value = "default";				
			}
			if (!machine_value.equalsIgnoreCase(client_machine_value)){
				mismatch_list.add("Machine");
				break;
			}
		}
		if(mismatch_list.size() > 0){
			String rpt_string ="Skip case: Project:" + case_prj + " Run:" + case_run + " Case:" + case_id;
			System.out.println(">>>Warning: " + rpt_string + ". Mismatch:" + mismatch_list.toString());
			file_action.append_file(publicData.local_skip, rpt_string + ". Mismatch:" + mismatch_list.toString() + publicData.line_separator);
			return false;
		} else {
			return true;
		}
	}
	
	public void local_run_block(Map<String, String>suite_data, Map<String, Map<String,String>> all_case_data){
		if (all_case_data ==null){
			return;
		}
		Set<String> case_set = all_case_data.keySet();
		Iterator<String> case_iterator = case_set.iterator();
		while(case_iterator.hasNext()){
			String case_id = case_iterator.next();
			Map<String, String> case_data = all_case_data.get(case_id);
			HashMap<String,HashMap<String, String>> task_data = merge_local_case(suite_data, case_data);			
			//remove unmatch case (case doesn't match the local client requirements)
			if(skiped_case_list.contains(case_id)){
				continue;
			}
			Boolean match_local_env = local_case_sorting(task_data);
			if(!match_local_env){
				skiped_case_list.add(case_id);
				continue;
			}
			//remove launched cae
			if (launched_case_list.contains(case_id)){
				continue;
			}
			launched_case_list.add(case_id);
			run_task_case(task_data);
			break;
		}
	}	
	
	public void link_run_block(){
		/*
		 * at here, we need to:
		 * 1. read queue_list and get one item <done>
		 * 2. read the item queue and get one case <done>
		 * 3. parse case
		 * 4. merge caseinfo, adminqueue info,
		 * 5. prepare case(need to download? and so on)
		 * 6. run case
		 * 7. Update poolinstance
		 */
		String queue_name = new String();
		String task = new String();
		Iterator<String> iterator_queue = queue_list.keySet().iterator(); 
		while (iterator_queue.hasNext()) { 
			String key = iterator_queue.next();
			HashMap<String, String> map_value = queue_list.get(key);
			String action = map_value.get("action");
			if(action != "1")
				{	queue_name = key;
					break;
				}
			}
		if(!queue_name.isEmpty()){
			content="";
			try {
				task = read_task_server(queue_name);
			} catch (Exception e) {
				if (TopRun.dug_model){
					System.out.println(">>>Error: read error for task queue:"+ queue_name);
				    e.printStackTrace();
				    Date dt=new Date();
				    String localeString=dt.toString();
				    file_action.print_out_to_file_to_gui("In task_block,\n"+localeString+"\nCan not read_task_server");
				}
			} finally{
				if(task == null || task.isEmpty() || task == ""){
					System.out.println(">>>Warning: Empty/invalid Task Queue, Remove:" + queue_name);
					Iterator<String> iterator_temp = queue_list.keySet().iterator(); 
					while (iterator_temp.hasNext()) { 
						String key = iterator_temp.next();
						if(queue_name == key){
							iterator_temp.remove();
							break;
						}
					}
				}
			}
			if(task!=null && !task.isEmpty() && task!=""){
				Map<?, ?> task_info = XmlAction.parse_case(task);
				HashMap<String, HashMap<String, String>> merge_info = merge_link_case(queue_list.get(queue_name),task_info);
				run_task_case(merge_info);
		    }else{
			// can not get one case
			//System.out.println(">>>Info: Queue list empty");
			;
		    }
		}
	}
	
	public void run_task_case(HashMap<String, HashMap<String, String>> task_data){
		//jason add for squish test
		Boolean squish_task = squish_task(task_data);
		StringBuilder out_str = new StringBuilder(">>>Info: squish case is running, postpone this task");
		while(squish_task && this.pool_instance.used_squish >0){
			try {
				out_str.append(".");
				System.out.println(out_str);
				Thread.sleep(5*1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				//e.printStackTrace();
				System.out.println(">>>Error: background squish case waiting error, skip the wait task.");
				return;
			}
		}         
        //jason end
		ArrayList<String> prepare_list = case_prepare(task_data);
		String prepare_string = (String) prepare_list.get(0);
		String prepare_case_dir = (String) prepare_list.get(1);
		String prepare_suite_dir = (String) prepare_list.get(2);
        String case_id = (String) prepare_list.get(3);
        String suite_id = (String) prepare_list.get(4);
        String change_to_casedir = (String) prepare_list.get(5);
        String project_id = (String) prepare_list.get(6);
        String run_id = (String) prepare_list.get(7);
        String init_case_name = (String) prepare_list.get(8);
        //int timeout=3600;
        String timeout_string = (String) prepare_list.get(9);
        String design_name = (String) prepare_list.get(10);
        String script_name = (String) prepare_list.get(11);
        String trce_back_dir =  (String) prepare_list.get(12);
        int timeout = Integer.parseInt(timeout_string);
		if(prepare_string != "1"){
			HashMap<?, ?> cmd_map = new HashMap();
			cmd_map = (HashMap<?, ?>) task_data.get("LaunchCommand");
			if (cmd_map == null  || !cmd_map.containsKey("cmd")){
				System.out.println(">>>Warning: Prj" + project_id + "/Run" + run_id + "/T" + case_id + ": No Launch CMD, Skipped.");
				return;
			}
			String cmd_ori = (String) cmd_map.get("cmd");
			String cmd_run = new String();
			if (script_name.equals("")){
				Pattern patt = Pattern.compile("(?:^|\\s)(\\S*\\.(?:pl|py|rb|jar|class|bat|exe))", Pattern.CASE_INSENSITIVE);
				Matcher match = patt.matcher(cmd_ori);
				cmd_run = match.replaceFirst(" " + trce_back_dir + "/$1");
			} else {
				cmd_run = cmd_ori;
			}
			String [] cmd_list;
			//Callable<?> c = new run_case(cmd_run + " --design="+prepare_case_dir,prepare_string.split(";"));
			if(cmd_run.indexOf("run_lattice.py")!= -1)
				cmd_list = (cmd_run + " --design="+design_name).split(" ");					
			else if(cmd_run.indexOf("run_icecube.py")!= -1)
				cmd_list = (cmd_run + " --design="+design_name).split(" ");
			else if(cmd_run.indexOf("run_diamond.py")!= -1)
				cmd_list = (cmd_run + " --design="+design_name).split(" ");
			else if(cmd_run.indexOf("run_diamondng.py")!= -1)
				cmd_list = (cmd_run + " --design="+design_name).split(" ");	
			else if(cmd_run.indexOf("run_radiant.py")!= -1)
				cmd_list = (cmd_run + " --design="+design_name).split(" ");				
			else if(cmd_run.indexOf("run_classic.py")!= -1)
				cmd_list = (cmd_run + " --design="+design_name).split(" ");					
			else
				cmd_list = cmd_run.split(" ");
			
			Map<String,String> envs = new HashMap<String,String>() ;
		    for(String s1:prepare_string.split(";")){
		       String[] s2 = s1.split("=");
		       if(s2.length == 2)
		           envs.put(s2[0], s2[1]);
		    }
		    Pattern patt = Pattern.compile("python", Pattern.CASE_INSENSITIVE);
		    Matcher match = patt.matcher(cmd_ori);
		    if (match.find()){
		    	envs.put("PYTHONUNBUFFERED", "1");
		    }
		    Callable<?> c;
		    if(change_to_casedir!= null  && change_to_casedir.length() != 0)
		    	c = new run_case(cmd_list,envs,change_to_casedir, timeout);
		    else
		    	c = new run_case(cmd_list,envs);
		    String job_dir = getJobDir(cmd_run);
		    String case_run_full_directory = Paths.get(job_dir,prepare_case_dir).toString();
		    String case_style ="";
		    if (squish_task){
		    	case_style = "squish";
		    } else {
		    	case_style = "normal";
		    }
		    System.out.println(">>>Info: Test case launched:" + "Prj" +project_id + ",Run" +run_id + ",T" + case_id);
		    if(TopRun.dug_model){
		    	System.out.println(">>>Debug: Run command:" + cmd_run);
		    }
		    this.pool_instance.addTask(c,prepare_case_dir+":"+case_id+":"+suite_id+":"+run_id+":"+project_id+":"+job_dir,timeout, case_style, init_case_name, prepare_case_dir);
		    write_running_record(run_id,case_id,init_case_name,case_run_full_directory);
		}		
	}
	
	public void run(){
		try{
			monitor_run();
		} catch (Exception run_exception){
			run_exception.printStackTrace();
			System.out.println(">>>Error: exception here");
			file_action.append_file(publicData.inputdump, run_exception.toString());
			System.exit(1);
		}
	}
	
	public void monitor_run(){
		runThread = Thread.currentThread();
		Map<String,String> suite_data  = new HashMap<String,String>();
		Map<String, Map<String,String>> all_case_data = new HashMap<String, Map<String,String>>();
		if (TopRun.local_model){
			File suite_file = new File(TopRun.suite_file);
			if (!suite_file.exists()){
				System.out.println(">>>Error: suite file do not exists: " + TopRun.suite_file);
				System.exit(1);
			}
			LocalPar sheet_parser = new LocalPar(TopRun.suite_file);
			Boolean sanity_result = sheet_parser.SanityCheck();
			if (!sanity_result){
				System.out.println(">>>Error: suite file have wrong format: " + TopRun.suite_file);
				System.exit(1);
			}
			suite_data = sheet_parser.get_suite_data();
			all_case_data = sheet_parser.get_detail_case_data();			
		}else {
			try {
				read_admin(ADMIN_QUEUE_NAME);
			} catch (Exception e2) { 
				e2.printStackTrace();
				Date dt=new Date();
				String localeString=dt.toString();
				file_action.print_out_to_file_to_gui("In rabbitMQ.run,\n"+localeString+"\nCan not read_admin");
			}
		}
		while(!stopRequested){
			while(waitRequested){
				try {
					synchronized(this) {
					    this.wait();
					}
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			int max_process = 0;
			try{
				max_process = Integer.parseInt(ConfigurationFile.getProfileString(defaultConfigure, "machine", "max_procs", "0"));
			}catch(Exception e){
				max_process = 0;
			}
			System.out.println(">>>Info: Running Thread(s):"+this.pool_instance.usedSize() + "/" + max_process);
			int used_size = this.pool_instance.usedSize();
			if(used_size < max_process)
			{
				/*
				 * at here, we need to:
				 * 1. read queue_list and get one item
				 * 2. read the item queue and get one case
				 * 3. Update poolinstance
				 * 4. parse case
				 * 5. run case
				 */
				try{
					if(TopRun.local_model){
						local_run_block(suite_data, all_case_data);
					} else{
						link_run_block();
					}
				} catch(Exception e){
					e.printStackTrace();
					Date dt=new Date();
			 	    String localeString=dt.toString();
					file_action.print_out_to_file_to_gui("In rabbitMQ.run,\n"+localeString+"\nMeet error during task_block");
				}
				//System.out.println(">>>main loop, after task_block");
			   }
			if (!TopRun.local_model){
				System.out.println(">>>Info: Task Queue List:"+queue_list.keySet().toString());
			}
			try {
				Thread.sleep(10*1000);
			} catch (InterruptedException e) {
				//e.printStackTrace();
				Date dt=new Date();
		 	    String localeString=dt.toString();
				file_action.print_out_to_file_to_gui("In rabbitMQ.run,\n"+localeString+"\nCan not sleep");
			}
		}
	}
	
	public void stopRequest() {
		stopRequested = true;
        if ( runThread != null ) {
            runThread.interrupt();
        }		
	}
	
	public void waitRequest() {
		waitRequested = true;
	}
	
	public void wakeRequest() {
		waitRequested = false;
		synchronized(this) {
		    this.notify();
		}		
	}
	
	public static void main(String [] argv) throws Exception{
		read_admin(ADMIN_QUEUE_NAME);
	}

}