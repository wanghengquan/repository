/*
 * File: system_cmd.java
 * Description: run system command line
 * Author: Jason.Wang
 * Date:2018/08/21
 * Modifier:
 * Date:
 * Description:
 */
package utility_funcs;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;

import org.apache.commons.io.FileUtils;
import org.apache.commons.mail.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.public_data;

public class mail_action {
	// public property
	// protected property
	// private property
	private static final Logger MAIL_ACTION_LOGGER = LogManager.getLogger(mail_action.class.getName());
    private static String mail_server = public_data.MAIL_SERVER;
    private static String def_operator = public_data.BASE_OPERATOR_MAIL;
    private static String def_deveoper = public_data.BASE_DEVELOPER_MAIL;
    private static String line_separator = System.getProperty("line.separator");
    
    		
	public mail_action() {
		
	}
	
	public static void simple_dump_mail(
			String to_str,
			String cc_str,
			String message,
			String machine
			){
		StringBuilder send_massage = new StringBuilder("");
		String current_time = time_info.get_date_time();
		send_massage.append("Time:" + current_time);
		send_massage.append(line_separator);
		send_massage.append("User:" + System.getProperty("user.name"));
		send_massage.append(line_separator);
		send_massage.append("Machine:" + machine);
		send_massage.append(line_separator);
		send_massage.append("Dump info:");
		send_massage.append(line_separator);		
		send_massage.append(message);
		try {
			Email simple_mail = new SimpleEmail();
			simple_mail.setHostName(mail_server);
			simple_mail.setFrom(def_operator);
			simple_mail.setTo(prepare_send_list(to_str));			
			simple_mail.setSubject("TMP client dumped.");
			simple_mail.setCc(prepare_send_list(cc_str));
			simple_mail.addBcc(def_deveoper);			
			simple_mail.setMsg(send_massage.toString());
			simple_mail.send();
		} catch (EmailException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			MAIL_ACTION_LOGGER.error("Send client dump message error out.");
		}		
	}
	
	public static void simple_event_mail(
			String subject,
			String to_str,
			String message
			){
		String send_massage = new String(message);
		try {
			Email simple_mail = new SimpleEmail();
			simple_mail.setHostName(mail_server);
			simple_mail.setFrom(def_operator);
			simple_mail.setTo(prepare_send_list(to_str));			
			simple_mail.setSubject(subject);			
			simple_mail.setMsg(send_massage);
			simple_mail.send();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			MAIL_ACTION_LOGGER.error("Send client event message error out.");
		}
	}
	
	public static void multipart_attached_mail(
			String events,
			String to_str,
			String file_path,
			String work_space,
			String message
			){
		String send_url = new String(file_path);
		File attach_file = new File(file_path);
		if (!attach_file.exists()){
			MAIL_ACTION_LOGGER.error("Attached file path not exists: " + file_path);
			return;
		}
		if (attach_file.isDirectory()){
			send_url = get_zipped_file(file_path, work_space);
		}
		File url_fobj = new File(send_url);
		String attach_name = new String("NA");
		if (url_fobj.exists()){
			attach_name = url_fobj.getName();
		}
		EmailAttachment attachment = new EmailAttachment();
		attachment.setPath(send_url);
		attachment.setDisposition(EmailAttachment.ATTACHMENT);
		attachment.setDescription("Attachment");
		attachment.setName(attach_name);
		try {
			MultiPartEmail multipart_mail = new MultiPartEmail();
			multipart_mail.setHostName(mail_server);
			multipart_mail.setFrom(def_operator);
			multipart_mail.setTo(prepare_send_list(to_str));
			multipart_mail.setSubject("TMP client:" + events);
			multipart_mail.setMsg(message);
			multipart_mail.attach(attachment);
			multipart_mail.send();
		} catch (EmailException e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			MAIL_ACTION_LOGGER.error("Send client dump message error out.");
		}		
	}
	
	private static String get_zipped_file(
			String dir_path,
			String work_space
			){
		String zip_file = new String("");
		File dir_fobj = new File(dir_path);
		String base_name = dir_fobj.getName();
		String zip_path = work_space + "/" + public_data.WORKSPACE_TEMP_DIR;
		File zip_path_fobj = new File(zip_path);
		if (!zip_path_fobj.exists()) {
			try {
				FileUtils.forceMkdir(zip_path_fobj);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
				MAIL_ACTION_LOGGER.error("Create temp zip path failed, skip zip file.");
				return zip_file;
			}
		}
		zip_file = zip_path + "/" + base_name + ".zip";
		File zip_fobj = new File(zip_file);
		if (zip_fobj.exists()){
			FileUtils.deleteQuietly(zip_fobj);
		}
		file_action.zipFolder(dir_path.replaceAll("\\\\", "/"), zip_file);
		return zip_file;		
	}
	
	private static ArrayList<InternetAddress> prepare_send_list(String to_string){
		ArrayList<InternetAddress> mail_array = new ArrayList<InternetAddress>();
		Pattern mail_patt = Pattern.compile("(\\w)+(.\\w+)*@(\\w)+((.\\w+)+)", Pattern.CASE_INSENSITIVE);
		if (to_string == null) {
			return mail_array;
		}
		for (String mail_addr : to_string.split(",|;")) {
			Matcher mail_match = mail_patt.matcher(mail_addr.trim());
			if (mail_match.find()){
				try {
					mail_array.add(new InternetAddress(mail_addr.trim()));
				} catch (AddressException e) {
					// TODO Auto-generated catch block
					// e.printStackTrace();
					MAIL_ACTION_LOGGER.error("Wrong mail address parsed for: " + mail_addr);
				}
			}
		}
		if (mail_array.isEmpty()){
			try {
				mail_array.add(new InternetAddress(public_data.BASE_OPERATOR_MAIL));
			} catch (AddressException e) {
				// TODO Auto-generated catch block
				// e.printStackTrace();
				MAIL_ACTION_LOGGER.error("Add default mail address failed: " + public_data.BASE_OPERATOR_MAIL);
			}
		}
		return mail_array;
	}
	
	public static void main(String[] args) {
		System.out.println("Please start from:top_runner/top_launcher");
		mail_action.simple_event_mail("events", "jason.wang@latticesemi.com", "testing...");
	}
}