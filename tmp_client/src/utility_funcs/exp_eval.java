/*
 * File: data_check.java
 * Description: run system command line
 * Author: Jason.Wang
 * Date:2018/12/24
 * Modifier:
 * Date:
 * Description:
 */
package utility_funcs;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import data_center.public_data;

public class exp_eval {
	public exp_eval() {

	}
	
	public static int python_eval_int(
			String pyton,
			String eval_str
			) {
		String cmd = pyton + " " + public_data.TOOLS_EXP_CHECK + " " + eval_str;
		ArrayList<String> excute_retruns = new ArrayList<String>();
		try {
			excute_retruns = system_cmd.run(cmd);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			return -1;
		}
		System.out.println(excute_retruns.toString());
		Pattern num_patt = Pattern.compile("^\\d+$", Pattern.CASE_INSENSITIVE);
		for (String line : excute_retruns){
            if(line == null || line == "")
                continue;
            Matcher num_match = num_patt.matcher(line);
            if (num_match.find()) {
            	Integer num = Integer.valueOf(line);
            	return num.intValue();
            }
		}
		return -1;
	}
	
	public static Boolean python_eval_bol(
			String pyton,
			String eval_str
			) {
		String cmd = pyton + " " + public_data.TOOLS_EXP_CHECK + " " + eval_str;
		ArrayList<String> excute_retruns = new ArrayList<String>();
		try {
			excute_retruns = system_cmd.run(cmd);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			return false;
		}
		Pattern num_patt = Pattern.compile("^\\d+$", Pattern.CASE_INSENSITIVE);
		Pattern true_patt = Pattern.compile("^true$", Pattern.CASE_INSENSITIVE);
		Pattern false_patt = Pattern.compile("^false$", Pattern.CASE_INSENSITIVE);
		for (String line : excute_retruns){
            if(line == null || line == "")
                continue;
            Matcher num_match = num_patt.matcher(line);
            Matcher true_match = true_patt.matcher(line);
            Matcher false_match = false_patt.matcher(line);
            if (num_match.find()) {
            	Integer num = Integer.valueOf(line);
            	if (num.intValue() > 0) {
            		return true;
            	} else {
            		return false;
            	}
            }
            if (true_match.find()) {
            	return true;
            }
            if (false_match.find()) {
            	return false;
            }
		}
		return false;
	}
	
	public static String python_eval(
			String pyton,
			String eval_str
			) {
		String cmd = pyton + " " + public_data.TOOLS_EXP_CHECK + " " + eval_str;
		ArrayList<String> excute_retruns = new ArrayList<String>();
		try {
			excute_retruns = system_cmd.run(cmd);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			return "NA";
		}
		for (String line : excute_retruns){
            if(line == null || line == "")
                continue;
            if(line.contains("python"))
                continue;
            if(line.contains("Exit"))
                continue;
            return line;
		}
		return "NA";
	}
	
	public static void main(String[] argv) {
		System.out.println(python_eval("python", "not 2 and 1"));
	}
}