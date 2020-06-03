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

	public static String get_date_year() {
		SimpleDateFormat formatter = new SimpleDateFormat("MMddyy");
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

	public static String get_time_hhmm() {
		SimpleDateFormat formatter = new SimpleDateFormat("HHmm");
		return formatter.format(new Date());
	}
	
	public static String get_date_time() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyMMdd_HHmmss");
		return formatter.format(new Date());
	}
	
	public static String get_man_date_time() {
		SimpleDateFormat formatter = new SimpleDateFormat("HH:mm:ss MM/dd");
		return formatter.format(new Date());
	}
	
	public static String get_date_time(Date date) {
		SimpleDateFormat formatter = new SimpleDateFormat("yyMMdd_HHmmss");
		return formatter.format(date);
	}
	
	public static String get_date_hhmm(Date date) {
		SimpleDateFormat formatter = new SimpleDateFormat("yyMMdd_HHmm");
		return formatter.format(date);
	}
	
	public static String get_week_day_name() {
		SimpleDateFormat formatter=new SimpleDateFormat("E");
		return formatter.format(new Date());
	}
	
	public static String get_week_day_num() {
		SimpleDateFormat formatter=new SimpleDateFormat("u");
		return formatter.format(new Date());
	}	
	
	public static Timestamp get_time_stamp() {
		return new Timestamp(new Date().getTime());
	}

	public static String get_runtime_string_dhms(String from_time_secs, String to_time_secs){
		StringBuilder runtime_string = new StringBuilder();
		long begin_time = Long.valueOf(from_time_secs).longValue();
		long end_time = Long.valueOf(to_time_secs).longValue();
		long runtime = end_time - begin_time;
		long days_number = runtime / (3600 * 24);
		long hours_number = runtime % (3600 * 24) / 3600;
		long minutes_munber = runtime % (3600 * 24) % 3600 / 60;
		long seconds_munber = runtime % (3600 * 24) % 3600 % 60;
		runtime_string.append(String.valueOf(days_number) + "d ");
		runtime_string.append(String.valueOf(hours_number) + "h ");
		runtime_string.append(String.valueOf(minutes_munber) + "m ");
		runtime_string.append(String.valueOf(seconds_munber) + "s");
		return runtime_string.toString();
	}
	
	public static String get_runtime_string_dhms(long from_time_secs, long to_time_secs){
		StringBuilder runtime_string = new StringBuilder();
		long runtime = to_time_secs - from_time_secs;
		long days_number = runtime / (3600 * 24);
		long hours_number = runtime % (3600 * 24) / 3600;
		long minutes_munber = runtime % (3600 * 24) % 3600 / 60;
		long seconds_munber = runtime % (3600 * 24) % 3600 % 60;
		runtime_string.append(String.valueOf(days_number) + "d ");
		runtime_string.append(String.valueOf(hours_number) + "h ");
		runtime_string.append(String.valueOf(minutes_munber) + "m ");
		runtime_string.append(String.valueOf(seconds_munber) + "s");
		return runtime_string.toString();
	}
	
	public static String get_runtime_string_hms(long from_time_secs, long to_time_secs){
		StringBuilder runtime_string = new StringBuilder();
		long runtime = to_time_secs - from_time_secs;
		long hours_number = runtime / 3600;
		long minutes_munber = runtime % 3600 / 60;
		long seconds_munber = runtime % 3600 % 60;
		runtime_string.append(String.valueOf(hours_number) + "h ");
		runtime_string.append(String.valueOf(minutes_munber) + "m ");
		runtime_string.append(String.valueOf(seconds_munber) + "s");
		return runtime_string.toString();
	}
	
	public static void main(String[] argv) {
		System.out.println(get_time_hhmm());
		System.out.println(System.currentTimeMillis() / 1000); 
		System.out.println(get_time_stamp().toString());
		System.out.println(get_date_time());
	}

}