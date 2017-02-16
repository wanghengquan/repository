package data_structure;

import java.io.IOException;

public class public_data {
	public static String CurrentVersion = "2.04.01"; //External.Internal.DEV
	public static String BuildDate = "2017/1/4";
	public static String SuiteFileVersion = "1.05";
	public static float JavaBaseVersion =1.8f;
	public static float PythonBaseVersion =2.7f;
	public static float SvnBaseVersion =1.4f;	
	public static String ResultSavePath = "";
	
	public static String line_separator = System.getProperty("line.separator");
	
	public static String client_conf = "conf/clientConf.conf";
	public static String local_skip = "log/local_skip.txt";
	protected final static String inputdump ="log/input.dump";
	protected final static String monitordump ="log/monitor.dump";
	protected final static String outputdump ="log/output.dump";
	public static String diamond_script = "trunk";
	public static String case_rpt = "case_report.txt";
	public static String local_rpt = "local_report.csv";
	 
	//link to RabbitMQ   configuration file has a higher priority then internal setting here
	public static String RABBITMQ_HOST = "lsh-reg01";
	public static String RABBITMQ_USER = "root";
	public static String RABBITMQ_PWD = "root";
	//min system requirements:
	public static Long DiskLeft = 2L;   //G
}	