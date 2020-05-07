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

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class data_check {
	public data_check() {

	}
	
	public static Boolean num_scope_check(
			String input_data,
			int min_value,
			int max_value) {
		Boolean check_result = Boolean.valueOf(true);
		int input_int = 0;
		try {
			input_int = Integer.valueOf(input_data);
		} catch (NumberFormatException e){
			return false;
		}
		check_result = num_scope_check(input_int, min_value, max_value);
		return check_result;
	}
	
	public static Boolean num_scope_check(
			int input_data,
			int min_value,
			int max_value) {
		Boolean check_result = Boolean.valueOf(true);
		if (input_data < min_value || input_data > max_value){
			check_result = false;
		}
		return check_result;
	}	
	
	public static Boolean str_choice_check(
			String input_data,
			ArrayList<String> available_data){
		Boolean check_result = Boolean.valueOf(false);
		if (available_data.contains(input_data)){
			check_result = true;
		}
		return check_result;
	}
	
	public static Boolean str_choice_check(
			String input_data,
			String[] available_data){
		Boolean check_result = Boolean.valueOf(false);
		if (Arrays.asList(available_data).contains(input_data)){
			check_result = true;
		}
		return check_result;
	}	
	
	public static Boolean str_path_check(
			String input_data){
		Boolean check_result = Boolean.valueOf(false);
		File path_obj = new File(input_data.replaceAll("\\\\", "/"));
		if (path_obj.exists()){
			check_result = true;
		}
		return check_result;
	}
	
	public static Boolean str_regexp_check(
			String ori_str,
			String req_pat){
		Boolean check_result = Boolean.valueOf(false);
		Pattern p = Pattern.compile(req_pat);
		Matcher m = p.matcher(ori_str);
		if (m.find()) {
			check_result = true;
		}
		return check_result;
	}	
	
	public static Boolean str_sort_format_check(
			String input_data){
		Boolean check_result = Boolean.valueOf(true);
		String [] sort_sections = input_data.split(";");
		for (String section : sort_sections){
			Boolean section_ok = str_regexp_check(section, "\\w\\s*=\\s*\\w");
			if (!section_ok){
				check_result = false;
				break;
			}
		}
		return check_result;
	}
}