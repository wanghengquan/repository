/*
 * File: system_cmd.java
 * Description: run system command line
 * Author: Jason.Wang
 * Date:2017/02/15
 * Modifier:
 * Date:
 * Description:
 */
package utility_funcs;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;

public class time_info {
	public time_info() {

	}

	public static String get_year_date() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
		return formatter.format(new Date());
	}

	public static String get_date() {
		SimpleDateFormat formatter = new SimpleDateFormat("MMdd");
		return formatter.format(new Date());
	}

	public static String get_time() {
		SimpleDateFormat formatter = new SimpleDateFormat("HHmmss");
		return formatter.format(new Date());
	}

	public static String get_date_time() {
		SimpleDateFormat formatter = new SimpleDateFormat("MMddyy_HHmmss");
		return formatter.format(new Date());
	}
	
	public static String get_man_date_time() {
		SimpleDateFormat formatter = new SimpleDateFormat("HH:mm:ss MM/dd");
		return formatter.format(new Date());
	}
	
	public static String get_date_time(Date date) {
		SimpleDateFormat formatter = new SimpleDateFormat("MMddyy_HHmmss");
		return formatter.format(date);
	}

	public static Timestamp get_time_stamp() {
		return new Timestamp(new Date().getTime());
	}

	public static void main(String[] argv) {
		System.out.println(get_date_time());
		System.out.println(System.currentTimeMillis()); 
	}

}