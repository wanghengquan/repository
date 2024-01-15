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

import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.configuration2.ex.ConfigurationException;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.public_data;
import flow_control.task_enum;
import info_parser.ini_parser;
import info_parser.xls_parser;
import utility_funcs.data_check;
import utility_funcs.file_action;
import utility_funcs.time_info;

/*
 * This class used to instance rabbitMQ tube between server and center processor.
 * 1: Memory 
 */
public class local_tube {
	// public property
	public static String suite_file_error_msg = new String();
	public static String suite_path_error_msg = new String(">>>");
	public static String[] suite_index = {"project_id", "suite_name"};
	public static String[] suite_elements = {"CaseInfo", "Environment", "LaunchCommand", "Software", "System", "Machine"}; //"Preference" --optional
	public static String[] case_titles = { "Order", "NoUse", "Title", "Section", "design_name", "TestLevel", "TestScenarios", "Description",
			"Type", "Priority", "CaseInfo", "Environment", "LaunchCommand", "Software", "System", "Machine", "Sorting", "Flow"};
	// protected property
	// private property
	private final Logger LOCAL_TUBE_LOGGER = LogManager.getLogger(local_tube.class.getName());
	private task_data task_info;

	// public function
	public local_tube(task_data task_info) {
		this.task_info = task_info;
	}

	// protected function
	// private function
	public static Map<String, List<List<String>>> get_excel_data(
			String excel_file
			) {
		Map<String, List<List<String>>> ExcelData = new HashMap<String, List<List<String>>>();
		xls_parser excel_obj = new xls_parser();
		ExcelData = excel_obj.GetExcelData(excel_file);
		return ExcelData;
	}

	public static Boolean suite_files_sanity_check(String file_paths) {
		Boolean all_pass = Boolean.valueOf(true);
		for (String file:file_paths.split("\\s*,\\s*")){
			if (!suite_file_sanity_check(file)){
				all_pass = false;
			}
		}
		if (!all_pass){
			return false;
		} else {
			return true;
		}
	}
	
	public static Boolean suite_file_sanity_check(
			String file_path
			) {
		File xlsx_fobj = new File(file_path);
		if(!xlsx_fobj.exists()){
			suite_file_error_msg = "Error: Suite file not exists.";
			System.out.println(">>>Error: Suite file not exists.");
			return false;
		}
		//file extend check
		String file_name = new String(xlsx_fobj.getName());
		if (file_name.endsWith(".xls") || file_name.endsWith(".xlsx")) {
			;
		} else {
			suite_file_error_msg = "Error: Suite file expanded-name issue, should be '.xls' or '.xlsx'";
			System.out.println(">>>Error: Suite file expanded-name issue, should be '.xls' or '.xlsx'");
			return false;
		}
		Map<String, List<List<String>>> ExcelData = new HashMap<String, List<List<String>>>();
		ExcelData.putAll(get_excel_data(file_path));
		//check suite sheet
		Iterator<String> suite_it = ExcelData.keySet().iterator();
		Boolean get_suite = Boolean.valueOf(false);
		while(suite_it.hasNext()){
			String sheet_name = suite_it.next();
			if (sheet_name.contains(excel_enum.SUITE.get_description())){
				get_suite = true;
				break;
			}
		}
		if (!get_suite){
			suite_file_error_msg = "Error: Cannot find 'suite' or 'suite_*' sheet.";
			System.out.println(">>>Error: Cannot find 'suite' or 'suite_*' sheet.");
			return false;			
		}
		//check case sheet
		Iterator<String> case_it = ExcelData.keySet().iterator();
		Boolean get_case = Boolean.valueOf(false);
		while(case_it.hasNext()){
			String sheet_name = case_it.next();
			if (sheet_name.contains(excel_enum.CASE.get_description())){
				get_case = true;
				break;
			}
		}
		if (!get_case){
			suite_file_error_msg = "Error: Cannot find 'case' or 'case_*' sheet.";
			System.out.println(">>>Error: Cannot find 'case' or 'case_*' sheet.");
			return false;			
		}
		// suite sheets details check
		HashMap<String, HashMap<String, String>> suite_sheets_data = new HashMap<String, HashMap<String, String>>();
		suite_sheets_data.putAll(get_suite_data(ExcelData));
		ArrayList<String> suite_name_list = new ArrayList<String>();
		Iterator<String> suite_sheets_it = suite_sheets_data.keySet().iterator();
		while (suite_sheets_it.hasNext()) {
			String suite_sheet_name = new String(suite_sheets_it.next());
			HashMap<String, String> suite_data = new HashMap<String, String>();
			suite_data.putAll(suite_sheets_data.get(suite_sheet_name));
			//suite info check
			if (suite_data.size() > 8) {
				if (!suite_data.containsKey("ClientPreference") && !suite_data.containsKey("Preference")){
				suite_file_error_msg = "Error: Extra option found in suite sheet::suite info.";
				System.out.println(">>>Error: Extra option found in suite sheet::suite info.");
				System.out.println(suite_data.keySet().toString());
				return false;
				}
			}
			for (String x : (String []) ArrayUtils.addAll(suite_index, suite_elements)) {
				if (!suite_data.containsKey(x)) {
					suite_file_error_msg = "Error:" + suite_sheet_name + " sheet missing :" + x + ".";
					System.out.println(">>>Error: " + suite_sheet_name + " sheet missing :" + x + ".");
					return false;
				}
			}
			//suite project check
			String prj_id = suite_data.get("project_id");
			try {
				@SuppressWarnings("unused")
				int id = Integer.parseInt(prj_id);
			} catch (NumberFormatException id_e) {
				suite_file_error_msg = "Error: project_id value wrong, should be a number.";
				System.out.println(">>>Error: project_id value wrong, should be a number.");
				return false;
			}
			//suite name check
			String suite_name = suite_data.get("suite_name").trim();
			if (suite_name == null || suite_name.equals("")) {
				suite_file_error_msg = "Error: Suite name missing.";
				System.out.println(">>>Error: Suite name missing.");
				return false;
			}
			if (suite_name_list.contains(suite_name)) {
				suite_file_error_msg = "Error: Duplicate suite name found.";
				System.out.println(">>>Error: Duplicate suite name found.");
				return false;
			} else {
				suite_name_list.add(suite_name);
			}
			//suite macro check
			Map<String, List<List<String>>> macro_data = get_macro_data(ExcelData, suite_sheet_name);
			if (!macro_data.isEmpty()) {
				Iterator<String> macro_it = macro_data.keySet().iterator();
				while (macro_it.hasNext()) {
					String macro_name = macro_it.next();
					List<List<String>> macro_lines = macro_data.get(macro_name);
					for (int line_index = 0; line_index < macro_lines.size(); line_index++) {
						String item = macro_lines.get(line_index).get(0);
						String column = macro_lines.get(line_index).get(1);
						if (!item.equals("condition") && !item.equals("action")) {
							suite_file_error_msg = "Error: Wrong macro key found in suite sheet:" + macro_name + ".";
							System.out.println(">>>Error: Wrong macro key found in suite sheet:" + macro_name + ".");
							return false;
						}
						if (!Arrays.asList(case_titles).contains(column)) {
							suite_file_error_msg = "Error: " + suite_sheet_name + ":" + macro_name + ":"+ column + " is illegal.";
							System.out.println(">>>Error: " + suite_sheet_name + ":" + macro_name + ":"+ column + " is illegal.");
							return false;
						}
					}
				}
			}
		}
		// case sheet details check
		List<String> case_title = get_case_title(ExcelData);
		if (case_title == null) {
			suite_file_error_msg = "Error: Cannot find title line in case sheet.";
			System.out.println(">>>Error: Cannot find title line in case sheet.");
			return false;
		}
		for (String x : case_titles) {
			if (!case_title.contains(x)) {
				suite_file_error_msg = "Error: case sheet title missing :" + x + ".";
				System.out.println(">>>Error: case sheet title missing :" + x + ".");
				return false;
			}
		}
		return true;
	}

	public static HashMap<String, HashMap<String, String>> get_suite_data(
			Map<String, List<List<String>>> ExcelData
			) {
		HashMap<String, HashMap<String, String>> suite_data = new HashMap<String, HashMap<String, String>>();
		Iterator<String> sheet_it = ExcelData.keySet().iterator();
		while(sheet_it.hasNext()){
			String sheet_name = sheet_it.next();
			if (!sheet_name.startsWith(excel_enum.SUITE.get_description())) {
				continue;
			}
			List<List<String>> current_sheet = ExcelData.get(sheet_name);
			HashMap<String, String> current_data = new HashMap<String, String>();
			String suite_start = new String("[suite_info]");
			String pre_word = null;
			String pre_value = null;
			Boolean suite_area = Boolean.valueOf(false);
			for (int row = 0; row < current_sheet.size(); row++) {
				List<String> row_list = current_sheet.get(row);
				if (row_list.size() < 1) {
					continue;
				}
				String item = new String();
				String value = new String();
				item = row_list.get(0).trim();
				if (row_list.size() < 2) {
					value = "";
				} else {
					value = row_list.get(1).trim().replaceAll("\\\\;", public_data.INTERNAL_STRING_SEMICOLON);
				}
				if (item.contains(suite_start)) {
					suite_area = true;
					continue;
				}
				if (item.equals("") && value.equals("")) {
					suite_area = false;
				}
				if (item.equals("[macro]")) {
					suite_area = false;
				}
				if (item.equals("END")) {
					suite_area = false;
				}
				if (item == null || item.equals("")) {
					item = pre_word;
					value = pre_value + ";" + value;
				}
				if (suite_area) {
					current_data.put(item, value.replaceAll("\\\\", "/"));
				}
				pre_word = item;
				pre_value = value;
			}
			suite_data.put(sheet_name, current_data);
		}
		return suite_data;
	}

	public static Map<String, List<List<String>>> get_macro_data(
			Map<String, List<List<String>>> ExcelData,
			String suite_name
			) {
		// get macro data
		List<List<String>> suite_sheet = ExcelData.get(suite_name);
		Map<String, List<List<String>>> macro_data = new HashMap<String, List<List<String>>>();
		Map<String, List<List<String>>> return_data = new HashMap<String, List<List<String>>>();
		int macro_num = 0;
		String macro_start = new String("[macro]");
		Boolean macro_area = Boolean.valueOf(false);
		List<List<String>> area_list = null;
		String macro_name = null;
		for (int row = 0; row < suite_sheet.size(); row++) {
			List<String> row_list = suite_sheet.get(row);
			if (row_list.size() < 1) {
                if(macro_area) {
                    macro_area = false;
                    macro_data.put(macro_name, area_list);
                }
				continue;
			}
			String item = row_list.get(0).trim().toLowerCase();
			if (item.contains(macro_start)) {
				macro_area = true;
				macro_num += 1;
				macro_name = "macro" + String.valueOf(macro_num);
				area_list = new ArrayList<List<String>>();
				continue;
			}
			if (macro_area) {
				if (item == null || item.equals("") || item.equalsIgnoreCase("END")) {
					macro_area = false;
					macro_data.put(macro_name, area_list);
				} else {
					if(row_list.size() < 3) {
						System.out.println(">>>Warning: Wrong macro line skipped:" + row_list.toString());
						continue;
					}
					ArrayList<String> line_list = new ArrayList<String>();
					line_list.add(row_list.get(0));
					line_list.add(row_list.get(1));
					line_list.add(row_list.get(2).replaceAll("\\\\;", public_data.INTERNAL_STRING_SEMICOLON));
					area_list.add(line_list);
				}
			}
			if (item.equals("END")) {
				break;
			}
		}
		return_data.putAll(sort_macro_map(macro_data));
		return return_data;
	}

	public static Map<String, List<List<String>>> sort_macro_map(
			Map<String, List<List<String>>> oriMap
			) {
		Map<String, List<List<String>>> sortedMap = new TreeMap<String, List<List<String>>>(new Comparator<String>() {
			public int compare(String mac1, String mac2) {
				int intmac1 = 0, intmac2 = 0;
				try {
					intmac1 = getInt(mac1, "\\D+(\\d+)");
					intmac2 = getInt(mac2, "\\D+(\\d+)");
				} catch (Exception e) {
					intmac1 = 0;
					intmac2 = 0;
				}
				return intmac1 - intmac2;
			}
		});
		if (oriMap == null || oriMap.isEmpty()) {
			return sortedMap;
		}		
		sortedMap.putAll(oriMap);
		return sortedMap;
	}

	public static List<String> get_case_title(Map<String, List<List<String>>> ExcelData) {
		//get case sheet
		String case_sheet = new String("");
		Iterator<String> sheet_it = ExcelData.keySet().iterator();
		while(sheet_it.hasNext()){
			String sheet_name = sheet_it.next();
			if (sheet_name.contains("case")){
				case_sheet = sheet_name;
				break;
			}
		}
		//get title data
		List<List<String>> case_data = ExcelData.get(case_sheet);
		List<String> title_list = new ArrayList<String>();
		// title_list = suite_sheet.get(1);
		int title_row = -1;
		for (int row = 0; row < case_data.size(); row++) {
			List<String> row_list = case_data.get(row);
			if (row_list.size() < 2) {
				continue;
			}
			String column_a = row_list.get(0).trim();
			// String column_b = row_list.get(1).trim();
			if (column_a.equals("Order")) {
				title_row = row;
				break;
			}
			if (row > 100) {
				break;
			}
		}
		if (title_row == -1) {
			return null;
		}
		title_list = case_data.get(title_row);
		return title_list;
	}

	private Map<String, Map<String, String>> get_raw_case_data(
			Map<String, List<List<String>>> ExcelData
			) {
		Map<String, Map<String, String>> case_data = new HashMap<String, Map<String, String>>();
		List<String> title_list = get_case_title(ExcelData);
		int order_index = title_list.indexOf("Order");
		int title_index = title_list.indexOf("Title");
		int flow_index = title_list.indexOf("Flow");
		Iterator<String> sheet_it = ExcelData.keySet().iterator();
		int case_sheet_num = 0;
		while(sheet_it.hasNext()){
			String sheet_name = sheet_it.next();
			if (!sheet_name.contains("case")){
				continue;
			}
			case_sheet_num += 1;
			List<List<String>> case_sheet = ExcelData.get(sheet_name);
			List<String> row_list = new ArrayList<String>();
			Boolean case_start = false;
			for (int row = 0; row < case_sheet.size(); row++) {
				row_list = case_sheet.get(row);
				if (row_list.size() < 2) {
					continue;
				}
				// skip lines do not have case order.
				if (row_list.get(0).trim() == null || row_list.get(0).trim().equals("")) {
					continue;
				}
				String column_order = new String("");
				String column_title = new String("");
				String column_flow = new String("");
				if (row_list.size() > order_index) {
					column_order = String.valueOf(case_sheet_num) + "_" + row_list.get(order_index).trim();
				}
				if (row_list.size() > title_index) {
					column_title = row_list.get(title_index).trim();
				}
				if (row_list.size() > flow_index) {
					column_flow = row_list.get(flow_index).trim();
				}
				if (column_order.contains("Order") && column_title.contains("Title")) {
					case_start = true;
					continue;
				}
				if (!case_start) {
					continue;
				}
				String case_order = new String("");
				String[] flow_array = column_flow.split("\\s*;\\s*");
				for (String flow_item : flow_array) {
					Map<String, String> row_data = new HashMap<String, String>();
					case_order = String.join("_", column_order, flow_item);
					for (String key : title_list) {
						int key_index = title_list.indexOf(key);
						String column_value = "";
						if (row_list.size() > key_index) {
							column_value = row_list.get(key_index).trim().replaceAll("\\\\;", public_data.INTERNAL_STRING_SEMICOLON);
						}
						if (key.equals("Order")) {
							row_data.put("Order", case_order);
						} else if (key.equals("Flow")) {
							row_data.put("Flow", flow_item);	
						} else {
							row_data.put(key, column_value.replaceAll("\\\\", "/"));
						}
					}
					case_data.put(case_order, row_data);
				}
			}
		}
		return case_data;
	}

	private Map<String, Map<String, String>> get_merge_macro_case_data(
			Map<String, List<List<String>>> ExcelData,
			String suite_sheet_name,
			Boolean multi_suites,
			String task_sort
			) {
		Map<String, Map<String, String>> merge_macro_data = new HashMap<String, Map<String, String>>();
		// start
		Map<String, List<List<String>>> macro_data = get_macro_data(ExcelData, suite_sheet_name);
		Map<String, Map<String, String>> raw_data = get_raw_case_data(ExcelData);
		if (raw_data == null || raw_data.isEmpty()) {
			LOCAL_TUBE_LOGGER.warn("No test case found in suite file.");
			return merge_macro_data;
		}
		Iterator<String> data_it = raw_data.keySet().iterator();
		while (data_it.hasNext()) {
			String case_order = data_it.next().trim();
			Integer macro_order = Integer.valueOf(0);
			String macro_case_order = new String();
			Map<String, String> case_data = new HashMap<String, String>();
			case_data.putAll(raw_data.get(case_order));
			if (case_data.containsKey("NoUse") && case_data.get("NoUse").equalsIgnoreCase("yes")) {
				LOCAL_TUBE_LOGGER.warn("Skipping NoUse case:" + case_data.get("Order"));
				continue;
			}
			if (case_data.containsKey("Automated") &&  case_data.get("Automated").equalsIgnoreCase("no")) {
				LOCAL_TUBE_LOGGER.warn("Skipping Non-Automated case:" + case_data.get("Order"));
				continue;
			}
			if (!case_data_match_task_sort(case_data, task_sort)){
				LOCAL_TUBE_LOGGER.warn("Skipping mismatched case:" + case_data.get("Order"));
				continue;				
			}
			if (macro_data == null || macro_data.isEmpty()) {
				macro_case_order = "m" + macro_order.toString() + "_" + case_order;
				case_data.put("Order", macro_case_order);
				merge_macro_data.put(macro_case_order, case_data);
				continue;
			}
			Boolean match_one = Boolean.valueOf(false);
			Iterator<String> macro_it = macro_data.keySet().iterator();
			while (macro_it.hasNext()) {
				macro_order = macro_order + 1;
				String macro_name = macro_it.next();
				String loop_macro_case_order = new String();
				List<List<String>> one_macro = macro_data.get(macro_name);
				Boolean macro_match = case_macro_check(case_data, one_macro);
				if (macro_match) {
					Map<String, String> update_data = new HashMap<String, String>();
					match_one = true;
					loop_macro_case_order = "m" + macro_order.toString() + "_" + case_order;
					update_data.putAll(update_case_data_with_macro_data(case_data, one_macro));
					update_data.put("Order", loop_macro_case_order);
					merge_macro_data.put(loop_macro_case_order, update_data);
				}
			}
			if (!match_one) {
				if(multi_suites){
					LOCAL_TUBE_LOGGER.warn("Multi-Suite mode:Skipping macro mismatched case:" + case_data.get("Order"));
				} else {
					macro_order = 0;
					macro_case_order = "m" + macro_order.toString() + "_" + case_order;
					case_data.put("Order", macro_case_order);
					merge_macro_data.put(macro_case_order, case_data);
				}
			}
		}
		return merge_macro_data;
	}

	private Boolean case_data_match_task_sort(
			Map<String, String> case_data, 
			String task_sort
			){
		Boolean case_match = Boolean.valueOf(true);
		if (task_sort == null || task_sort.trim().equals("")){
			return case_match;
		}
		Map<String, String> src_data = new HashMap<String, String>();
		Map<String, String> req_data = new HashMap<String, String>();
		req_data.putAll(get_sort_map_data(task_sort));
		Iterator<String> case_it = case_data.keySet().iterator();
		while(case_it.hasNext()){
			String title = case_it.next();
			String value = case_data.get(title);
			src_data.put(title.toLowerCase(), value.toLowerCase());
		}
		//start to check
		Iterator<String> req_it = req_data.keySet().iterator();
		while(req_it.hasNext()){
			String req_option = req_it.next();
			String req_value = req_data.get(req_option);
			// 1. request option do not exist
			if (!src_data.containsKey(req_option)){
				case_match = false;
				break;
			}
			// 2. source data do have data for requested option
			String src_value = src_data.get(req_option);
			if (src_value == null || src_value.trim().equals("")){
				case_match = false;
				break;
			}
			if (!req_value.contains(src_value)){
				case_match = false;
				break;
			}
		}
		return case_match;
	}
	
	private Map<String, String> get_sort_map_data(String sort_str){
		Map<String, String> return_data = new HashMap<String, String>();
		if (sort_str == null || sort_str.equals("")){
			return return_data;
		}
		for (String section : sort_str.split("\\s*;\\s*")){
			String option = new String("");
			String value = new String("");
			option = section.split("=")[0].trim().toLowerCase();
			value = section.split("=")[1].trim().toLowerCase();
			return_data.put(option, value);
		}
		return return_data;
	}
	
	private Boolean case_macro_check(
			Map<String, String> raw_data,
			List<List<String>> macro_data
			) {
		List<List<String>> one_macro_data = new ArrayList<List<String>>(); 
		one_macro_data.addAll(macro_data);
		// all condition check
		Boolean macro_match = Boolean.valueOf(true);
		for (List<String> line : one_macro_data) {
			if (line.size() < 3) {
				LOCAL_TUBE_LOGGER.warn("Skip macro line:" + line.toString());
				continue;
			}
			String behavior = line.get(0).trim();
			String column = line.get(1).trim();
			if (!behavior.equals("condition")) {
				continue;
			}
			//Start match check
			String condition_value = line.get(2).trim();
			List<String> raw_list = new ArrayList<String>();
			raw_list.addAll(Arrays.asList(raw_data.getOrDefault(column, "").split("\\s*,\\s*")));
			Boolean current_condition = Boolean.valueOf(false);
			if(data_check.str_regexp_check(condition_value, "^=")) {
				current_condition = false;
				List<String> condition_list = new ArrayList<String>();
				condition_list.addAll(Arrays.asList(condition_value.replaceAll("^=", "").split("\\s*,\\s*")));
				for (String condition : condition_list) {
					if(raw_list.contains(condition)) {
						current_condition = true;
						break;
					}
				}
			} else if (data_check.str_regexp_check(condition_value, "^!=")) {
				current_condition = true;
				List<String> condition_list = new ArrayList<String>();
				condition_list.addAll(Arrays.asList(condition_value.replaceAll("^!=", "").split("\\s*,\\s*")));
				for (String condition : condition_list) {
					if(raw_list.contains(condition)) {
						current_condition = false;
						break;
					}
				}
			} else if (data_check.str_regexp_check(condition_value, "^>=")) {
				current_condition = data_check.num_not_less_check(raw_list.get(0), condition_value.replaceAll("^>=", ""));
			} else if (data_check.str_regexp_check(condition_value, "^<=")) {
				current_condition = data_check.num_not_greater_check(raw_list.get(0), condition_value.replaceAll("^<=", ""));
			} else if (data_check.str_regexp_check(condition_value, "^>")) {
				current_condition = data_check.num_greater_check(raw_list.get(0), condition_value.replaceAll("^>", ""));
			} else if (data_check.str_regexp_check(condition_value, "^<")) {
				current_condition = data_check.num_less_check(raw_list.get(0), condition_value.replaceAll("^<", ""));
			} else {
				LOCAL_TUBE_LOGGER.warn("Unsupported macro condition, mismatch considered:" + line.toString());
			}
			//final check
			if(!current_condition) {
				macro_match = false;
				break;
			}
		}
		return macro_match;
	}

	private HashMap<String, String> get_case_element_value_map(
			String elements_str
			){
		HashMap<String, String> element_map = new HashMap<String, String>();
		if (elements_str == null || elements_str.equals("")) {
			return element_map;
		}
		for (String item : elements_str.split("\\s*;\\s*")) {
			if (!item.contains("=")) {
				element_map.put(item, "");
				continue;
			}
			String item_option = item.split("=", 2)[0].trim();
			String item_value = item.split("=", 2)[1].trim();
			element_map.put(item_option, item_value);
		}
		return element_map;
	}
	
	private Map<String, String> update_case_data_with_macro_data(
			Map<String, String> case_data, 
			List<List<String>> macro_data
			) {
		Map<String, String> return_data = new HashMap<String, String>();
		return_data.putAll(case_data);
		List<String> column_list = new ArrayList<String>();
		column_list.add("CaseInfo");
		column_list.add("Environment");
		column_list.add("LaunchCommand");
		column_list.add("Software");
		column_list.add("System");
		column_list.add("Machine");
		// update case data
		for (List<String> line : macro_data) {
			if (line.size() < 3) {
				LOCAL_TUBE_LOGGER.warn("Skip macro line:" + line.toString());
				continue;
			}
			String macro_behavior = line.get(0).trim();
			String macro_column = line.get(1).trim();
			String macro_value = line.get(2).trim();
			if (!macro_behavior.equals("action")) {
				continue;
			}
			String case_value = case_data.getOrDefault(macro_column, "").trim();
			String merge_value = new String("");
			HashMap<String, String> case_value_map = new HashMap<String, String>();
			case_value_map.putAll(get_case_element_value_map(case_value));
			if (column_list.contains(macro_column)) {
				if (!macro_value.contains("=")) {
					LOCAL_TUBE_LOGGER.warn("Skip macro action non key=value input for columns" + column_list.toString());
					continue;
				}
				for(String macro_item : macro_value.split("\\s*;\\s*")) {
					String option = macro_item.split("=", 2)[0].trim();
					String value = macro_item.split("=", 2)[1].trim();
					String new_value = new String("");
					if (case_value_map.containsKey(option)) {
						if(case_value_map.containsKey("override") && case_value_map.getOrDefault("override", "").equals("local")) {
							continue;
						} else if (case_value_map.containsKey("override") && case_value_map.getOrDefault("override", "").equals("globle")) {
							case_value_map.put(option, value);
						} else {
							if (option.startsWith("cmd")) {
								new_value = value + " " + case_value_map.get(option);
								case_value_map.put(option, new_value);
							} else {
								case_value_map.put(option, value);
							}
						}
					} else {
						case_value_map.put(option, value);	
					}
				}
				List<String> value_list = new ArrayList<String>();
		        for (String key: case_value_map.keySet()) {
		        	String value = case_value_map.get(key);
		        	if(value == null || value.equals("")) {
		        		value_list.add(key);
		        	} else {
		        		value_list.add(key + "=" + value);
		        	}
		        }
		        merge_value = String.join(";", value_list).trim();
				merge_value = merge_value.replaceAll("^;", "");
			} else {
				merge_value = macro_value;
			}
			return_data.put(macro_column, merge_value);
		}
		return return_data;
	}
	
	private Map<String, HashMap<String, HashMap<String, String>>> get_merge_suite_case_data(
			Map<String, String> suite_data, 
			Map<String, Map<String, String>> case_data,
			String extra_env,
			String xlsx_dest
			) {
		Map<String, HashMap<String, HashMap<String, String>>> cross_data = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		Map<String, HashMap<String, HashMap<String, String>>> sorted_data = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		Iterator<String> case_iterator = case_data.keySet().iterator();
		while (case_iterator.hasNext()) {
			String case_id = case_iterator.next();
			Map<String, String> one_case_data = case_data.get(case_id);
			HashMap<String, HashMap<String, String>> merge_data = new HashMap<String, HashMap<String, String>>();
			merge_data.putAll(merge_suite_case_data(suite_data, one_case_data, extra_env, xlsx_dest));
			//return internal string to user string
			cross_data.put(case_id, merge_data);
		}
		sorted_data = sortMapByKey(cross_data);
		//return null if empty data found
		return sorted_data;
	}

	public Map<String, HashMap<String, HashMap<String, String>>> sortMapByKey(
			Map<String, HashMap<String, HashMap<String, String>>> oriMap) {
		if (oriMap == null || oriMap.isEmpty()) {
			return null;
		}
		Map<String, HashMap<String, HashMap<String, String>>> sortedMap = new TreeMap<String, HashMap<String, HashMap<String, String>>>(
				new Comparator<String>() {
					public int compare(String key1, String key2) {
						int intid1 = 0, intid2 = 0;
						int intmac1 = 0, intmac2 = 0;
						try {
							intid1 = getInt(key1, "_(\\d+)_");
							intid2 = getInt(key2, "_(\\d+)_");
							intmac1 = getInt(key1, "m(\\d+)_");
							intmac2 = getInt(key2, "m(\\d+)_");
						} catch (Exception e) {
							intid1 = 0;
							intid2 = 0;
							intmac1 = 0;
							intmac2 = 0;
						}
						if (intid1 > intid2) {
							return 1;
						} else if (intid1 < intid2) {
							return -1;
						} else {
							if (intmac1 > intmac2) {
								return 1;
							} else if (intmac1 < intmac2) {
								return -1;
							} else {
								return key1.compareTo(key2);
							}
						}
					}
				});
		sortedMap.putAll(oriMap);
		return sortedMap;
	}

	public static int getInt(String str, String patt) {
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

	// merge suite data and case data(already merged with macro) to an final
	// case data. don't forget get the replaced string back
	public HashMap<String, HashMap<String, String>> merge_suite_case_data(
			Map<String, String> suite_data,
			Map<String, String> case_data,
			String extra_env,
			String xlsx_dest) {
		HashMap<String, HashMap<String, String>> merge_data = new HashMap<String, HashMap<String, String>>();
		// insert id data
		String project_id = suite_data.get("project_id").trim();
		String suite_id = suite_data.get("suite_name").trim();
		String case_id = case_data.get("Order").trim();
		HashMap<String, String> id_map = new HashMap<String, String>();
		if (project_id == null || project_id.equals("")) {
			id_map.put("project", "0");
		} else {
			id_map.put("project", project_id);
		}
		if (suite_id == null || suite_id.equals("")) {
			id_map.put("suite", "suite000");
			id_map.put("run", "run000");
		} else {
			id_map.put("suite", suite_id);
			id_map.put("run", suite_id);
		}
		if (case_id == null || case_id.equals("")) {
			id_map.put("id", "case");
		} else {
			id_map.put("id", case_id);
		}
		id_map.put("epoch_time", String.valueOf(System.currentTimeMillis() / 1000));
		merge_data.put("ID", id_map);
		// insert CaseInfo data
		String suite_info = suite_data.get("CaseInfo").trim();
		String case_info = case_data.get("CaseInfo").trim();
		String design_info = case_data.get("design_name").trim();
		HashMap<String, String> case_map = comm_suite_case_merge(suite_info, case_info, "CaseInfo");
		if (!case_map.containsKey("design_name")) {
			case_map.put("design_name", design_info);
		}
		//xlsx_dest is for local suite only
		case_map.put("xlsx_dest", xlsx_dest);
		merge_data.put("CaseInfo", case_map);
		// insert Environment data
		HashMap<String, String> environ_map = new HashMap<String, String>();
		HashMap<String, String> extra_map = new HashMap<String, String>();
		List<String> env_list = new ArrayList<String>();
		if (extra_env.length() > 0){
			if (extra_env.contains(",")){
				env_list.addAll(Arrays.asList(extra_env.split("\\s*,\\s*")));
			} else if (extra_env.contains(";")){
				env_list.addAll(Arrays.asList(extra_env.split("\\s*;\\s*")));
			} else{
				env_list.add(extra_env);
			}
		}
		if(env_list.size() > 0){
			for (String env_line: env_list){
				if (!env_line.contains("=")){
					LOCAL_TUBE_LOGGER.warn("ignore environ setting since no = found in:" + env_line);
					continue;
				}
				String key = env_line.split("=", 2)[0].trim();
				String value = env_line.split("=", 2)[1].trim();
				extra_map.put(key, value);
			}
		}
		String suite_environ = suite_data.get("Environment").trim();
		String case_environ = case_data.get("Environment").trim();
		environ_map.putAll(comm_suite_case_merge(suite_environ, case_environ, "Environment"));
		environ_map.putAll(extra_map);//user import environ have higher priority
		merge_data.put("Environment", environ_map);
		// insert LaunchCommand data
		String suite_cmd = suite_data.get("LaunchCommand").trim();
		String case_cmd = case_data.get("LaunchCommand").trim();
		HashMap<String, String> cmd_map = comm_suite_case_merge(suite_cmd, case_cmd, "LaunchCommand");
		merge_data.put("LaunchCommand", cmd_map);
		// insert Software data
		String suite_software = suite_data.get("Software").trim();
		String case_software = case_data.get("Software").trim();
		HashMap<String, String> software_map = comm_suite_case_merge(suite_software, case_software, "Software");
		merge_data.put("Software", software_map);
		// insert System data
		String suite_system = suite_data.get("System").trim();
		String case_system = case_data.get("System").trim();
		HashMap<String, String> system_map = comm_suite_case_merge(suite_system, case_system, "System");
		merge_data.put("System", system_map);
		// insert Machine data
		String suite_machine = suite_data.get("Machine").trim();
		String case_machine = case_data.get("Machine").trim();
		HashMap<String, String> machine_map = comm_suite_case_merge(suite_machine, case_machine, "Machine");
		merge_data.put("Machine", machine_map);
		// insert ClientPreference data
        String suite_client_preference = "";
        String case_client_preference = "";
        if(suite_data.containsKey("ClientPreference")){ //deprecated, remove it later
            suite_client_preference = suite_data.get("ClientPreference").trim();
        }
        if(suite_data.containsKey("Preference")){
            suite_client_preference = suite_data.get("Preference").trim();
        }        
        HashMap<String, String> client_preference = comm_suite_case_merge(suite_client_preference, case_client_preference, "Preference");
        merge_data.put("Preference", client_preference);
		return merge_data;
	}

	private HashMap<String, String> comm_suite_case_merge(
			String suite_info, 
			String case_info,
			String section
			) {
		String globle_str = suite_info.replaceAll("^;", "");
		String local_str = case_info.replaceAll("^;", "");
		String[] globle_array = globle_str.split("\\s*;\\s*");
		String[] local_array = local_str.split("\\s*;\\s*");
		HashMap<String, String> globle_data = new HashMap<String, String>();
		for (String globle_item : globle_array) {
			if (!globle_item.contains("=")) {
				// System.out.println(">>>Warning: skip suite item:" +
				// globle_item + " .");
				continue;
			}
			String globle_key = globle_item.split("=", 2)[0].trim();
			String globle_value = globle_item.split("=", 2)[1].trim();
			globle_data.put(globle_key, globle_value);
		}
		HashMap<String, String> local_data = new HashMap<String, String>();
		for (String local_item : local_array) {
			if (!local_item.contains("=")) {
				// System.out.println(">>>Warning: skip case item:" + local_item
				// + " .");
				continue;
			}
			String local_key = local_item.split("=", 2)[0].trim();
			String local_value = local_item.split("=", 2)[1].trim();
			local_data.put(local_key, local_value);
		}
		HashMap<String, String> merged_data = new HashMap<String, String>();
		merged_data = comm_admin_task_merge(globle_data, local_data, section);
		return merged_data;
	}

	public static HashMap<String, String> comm_admin_task_merge(
			HashMap<String, String> globle_data,
			HashMap<String, String> local_data,
			String section
			) {
		HashMap<String, String> merge_data = new HashMap<String, String>();
		switch(section) {
		case "LaunchCommand":
			merge_data.putAll(get_command_merge_data(globle_data, local_data));
			break;
		case "Environment":
			merge_data.putAll(get_environ_merge_data(globle_data, local_data));
			break;
		default:
			merge_data.putAll(get_typical_merge_data(globle_data, local_data));
			break;
		}
		return merge_data;
	}

	public static HashMap<String, String> get_typical_merge_data(
			HashMap<String, String> globle_data,
			HashMap<String, String> local_data
			) {
		Iterator<String> local_it = local_data.keySet().iterator();
		while (local_it.hasNext()) {
			String local_key = local_it.next();
			String local_value = local_data.get(local_key);
			if (globle_data.containsKey(local_key)) {
				if (!(local_value == null) && !local_value.equals("")) {
					globle_data.put(local_key, local_value);
				}
			} else {
				globle_data.put(local_key, local_value);
			}
		}
		return globle_data;
	}
	
	public static HashMap<String, String> get_environ_merge_data(
			HashMap<String, String> globle_data,
			HashMap<String, String> local_data
			) {
		Iterator<String> local_it = local_data.keySet().iterator();
		while (local_it.hasNext()) {
			String local_key = local_it.next();
			String local_value = local_data.get(local_key);
			if (local_data.containsKey("override") && local_data.get("override").equals("local")) {
				globle_data.put(local_key, local_value);
			} else if (local_data.containsKey("override") && local_data.get("override").equals("globle")) {
				if(!globle_data.containsKey(local_key)) {
					globle_data.put(local_key, local_value);
				}
			} else if (globle_data.containsKey("override") && globle_data.get("override").equals("local")) {
				globle_data.put(local_key, local_value);
			} else if (globle_data.containsKey("override") && globle_data.get("override").equals("globle")) {
				if(!globle_data.containsKey(local_key)) {
					globle_data.put(local_key, local_value);
				}
			} else {
				if (globle_data.containsKey(local_key)) {
					if (!(local_value == null) && !local_value.equals("")) {
						globle_data.put(local_key, local_value);
					}
				} else {
					globle_data.put(local_key, local_value);
				}
			}
		}
		return globle_data;
	}
	
	public static HashMap<String, String> get_command_merge_data(
			HashMap<String, String> globle_data,
			HashMap<String, String> local_data
			) {
		HashMap<String, String> merge_data = new HashMap<String, String>();
		merge_data.putAll(globle_data);
		Pattern cmd_patt = Pattern.compile("(cmd|cmd_\\d+)$");
		Iterator<String> local_it = local_data.keySet().iterator();
		while (local_it.hasNext()) {
			String local_key = local_it.next();
			String local_value = local_data.get(local_key);
			Matcher cmd_match = cmd_patt.matcher(local_key);
			if (cmd_match.find() && !local_value.equals("")) {
				if (local_data.containsKey("override") && local_data.get("override").equals("local")) {
					merge_data.put(local_key, local_value);
				} else if (local_data.containsKey("override") && local_data.get("override").equals("globle")) {
					if(!globle_data.containsKey(local_key)) {
						merge_data.put(local_key, local_value);
					}
				} else if (globle_data.containsKey("override") && globle_data.get("override").equals("local")) {
					merge_data.put(local_key, local_value);
				} else if (globle_data.containsKey("override") && globle_data.get("override").equals("globle")) {
					if(!globle_data.containsKey(local_key)) {
						merge_data.put(local_key, local_value);
					}
				} else {
					String local_cmd = local_data.get(local_key);
					String globle_cmd = globle_data.getOrDefault(local_key, "");
					String overall_cmd = globle_cmd + " " + local_cmd;
					merge_data.put(local_key, overall_cmd.trim());
				}
			} else {
				// non command key 1)global have value, local must have value
				// then overwrite
				if (globle_data.containsKey(local_key)) {
					if (!(local_value == null) && !local_value.equals("")) {
						merge_data.put(local_key, local_value);
					}
				} else {
					merge_data.put(local_key, local_value);
				}
			}
		}
		return merge_data;
	}
	
	//not used
	public static HashMap<String, String> comm_admin_task_merge_old(
			HashMap<String, String> globle_data,
			HashMap<String, String> local_data
			) {
		Pattern cmd_patt = Pattern.compile("(cmd|cmd_\\d+)$");
		Iterator<String> local_it = local_data.keySet().iterator();
		while (local_it.hasNext()) {
			String local_key = local_it.next();
			String local_value = local_data.get(local_key);
			Matcher cmd_match = cmd_patt.matcher(local_key);
			if (local_key.equalsIgnoreCase("cmd_all")) {
				Iterator<String> globle_it = globle_data.keySet().iterator();
				while (globle_it.hasNext()) {
					String globle_key = globle_it.next();
					String globle_value = globle_data.get(globle_key);
					if(!globle_key.startsWith("cmd")) {
						continue;
					}
					if (local_data.containsKey("override") && local_data.get("override").equals("local")) {
						globle_data.put(globle_key, local_value);
					} else if (local_data.containsKey("override") && local_data.get("override").equals("globle")) {
						continue;
					} else if (globle_data.containsKey("override") && globle_data.get("override").equals("local")) {
						globle_data.put(globle_key, local_value);
					} else if (globle_data.containsKey("override") && globle_data.get("override").equals("globle")) {
						continue;
					} else {
						String overall_cmd = globle_value + " " + local_value;
						globle_data.put(globle_key, overall_cmd.trim());
					}
				}
			} else if (cmd_match.find() && !local_value.equals("")) {
				if (local_data.containsKey("override") && local_data.get("override").equals("local")) {
					globle_data.put(local_key, local_value);
				} else if (local_data.containsKey("override") && local_data.get("override").equals("globle")) {
					continue;
				} else if (globle_data.containsKey("override") && globle_data.get("override").equals("local")) {
					globle_data.put(local_key, local_value);
				} else if (globle_data.containsKey("override") && globle_data.get("override").equals("globle")) {
					continue;
				} else {
					String local_cmd = local_data.get(local_key);
					String globle_cmd = globle_data.getOrDefault(local_key, "");
					String overall_cmd = globle_cmd + " " + local_cmd;
					globle_data.put(local_key, overall_cmd.trim());
				}
			} else {
				// non command key 1)global have value, local must have value
				// then overwrite
				if (globle_data.containsKey(local_key)) {
					if (!(local_value == null) && !local_value.equals("")) {
						globle_data.put(local_key, local_value);
					}
				} else {
					globle_data.put(local_key, local_value);
				}
			}
		}
		return globle_data;
	}

	private Boolean is_request_match(
			HashMap<String, HashMap<String, String>> queue_data,
			HashMap<String, HashMap<String, String>> design_data
			) {
		// compare sub map data Software, System, Machine
		Boolean is_match = Boolean.valueOf(true);
		List<String> check_items = new ArrayList<String>();
		check_items.add("Software");
		check_items.add("System");
		check_items.add("Machine");
		Iterator<String> item_it = check_items.iterator();
		while (item_it.hasNext()) {
			String item_name = item_it.next();
			HashMap<String, String> design_map = design_data.get(item_name);
			HashMap<String, String> queue_map = queue_data.get(item_name);
			Boolean request_match = design_map.equals(queue_map);
			if (!request_match) {
				is_match = false;
				break;
			}
		}
		return is_match;
	}

	private String get_one_queue_name(
			String admin_queue_base, 
			String create_time,
			String sub_task_number,
			String current_terminal,
			HashMap<String, HashMap<String, String>> design_data) {
		// admin queue priority check:0>1>2..>5(default)>...8>9
		String priority = public_data.TASK_DEF_PRIORITY;
		if (!design_data.containsKey("CaseInfo")) {
			priority = public_data.TASK_PRI_LOCALLY;
		} else if (!design_data.get("CaseInfo").containsKey("priority")) {
			priority = public_data.TASK_PRI_LOCALLY;
		} else {
			priority = design_data.get("CaseInfo").get("priority");
			Pattern p = Pattern.compile("^\\d$");
			Matcher m = p.matcher(priority);
			if (!m.find()) {
				priority = public_data.TASK_PRI_LOCALLY;
				LOCAL_TUBE_LOGGER.warn(admin_queue_base + ":has wrong CaseInfo->priority, default value" + public_data.TASK_PRI_LOCALLY + "used.");
			}
		}
		// task belong to this client: 0, assign task(0) > match task(1)
		String assignment = new String();
		String request_terminal = new String();
		String available_terminal = current_terminal.toLowerCase();
		if (!design_data.containsKey("Machine")) {
			assignment = "1";
		} else if (!design_data.get("Machine").containsKey("terminal")) {
			assignment = "1";
		} else {
			request_terminal = design_data.get("Machine").get("terminal").toLowerCase();
			if (request_terminal.contains(available_terminal)) {
				assignment = "0"; // assign task
			} else {
				assignment = "1"; // match task
			}
		}
		// Max threads requirements
		String threads = new String(public_data.TASK_DEF_MAX_THREADS);
		if (!design_data.containsKey("Preference")) {
			threads = public_data.TASK_DEF_MAX_THREADS;
		} else if (!design_data.get("Preference").containsKey("max_threads")) {
			threads = public_data.TASK_DEF_MAX_THREADS;
		} else {
			threads = design_data.get("Preference").get("max_threads");
			Pattern p = Pattern.compile("^\\d$");
			Matcher m = p.matcher(threads);
			if (!m.find()) {
				threads = public_data.TASK_DEF_MAX_THREADS;
				LOCAL_TUBE_LOGGER.warn(admin_queue_base + ":has wrong Preference->max_threads, default value " + public_data.TASK_DEF_MAX_THREADS + " used.");
			}
		}		
		// host restart requirements--for local jobs always be 0		
		String restart_boolean = new String(public_data.TASK_DEF_HOST_RESTART);
		if (!design_data.containsKey("Preference")) {
			restart_boolean = public_data.TASK_DEF_HOST_RESTART;
		} else if (!design_data.get("Preference").containsKey("host_restart")) {
			restart_boolean = public_data.TASK_DEF_HOST_RESTART;
		} else {
			String request_value = new String(design_data.get("Preference").get("host_restart").trim());
			if (!data_check.str_choice_check(request_value, new String [] {"false", "true"} )){
				LOCAL_TUBE_LOGGER.warn(admin_queue_base + ":has wrong Preference->host_restart, default value " + public_data.TASK_DEF_HOST_RESTART + " used.");
			} else {
				restart_boolean = request_value;
			}
		}
		String restart = new String("0");
		if (restart_boolean.equalsIgnoreCase("true")) {
			restart = "1";
		} else {
			restart = "0";
		}
		// receive time
		String mark_time = time_info.get_time_hhmm();
		StringBuilder queue_name = new StringBuilder("");
		queue_name.append(priority);
		queue_name.append(assignment);
		queue_name.append("0");//1, from remote; 0, from local
		queue_name.append("@");
		queue_name.append("t" + threads);
		queue_name.append("r" + restart);
		queue_name.append("_");
		queue_name.append("run_" + mark_time + "_" + sub_task_number + "_" + admin_queue_base + "_" + create_time);
		return queue_name.toString();
	}

	/*
	 * {queue_name: {ID : {prj : name,suite: name}, System: {os : name}}}
	 */
	@SuppressWarnings("unused")
	private TreeMap<String, HashMap<String, HashMap<String, String>>> get_one_queue_hash(String admin_queue_base,
			String queue_pre_fix, String current_terminal, HashMap<String, HashMap<String, String>> design_data) {
		TreeMap<String, HashMap<String, HashMap<String, String>>> one_queue_hash = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		// generate queue name
		String queue_name = new String();
		String detail_time = time_info.get_date_time();//time for create queue
		HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
		queue_name = get_one_queue_name(admin_queue_base, detail_time, queue_pre_fix, current_terminal, design_data);
		queue_data.put("ID", design_data.get("ID"));
		queue_data.put("CaseInfo", design_data.get("CaseInfo"));
		queue_data.put("Environment", design_data.get("Environment"));
		queue_data.put("Software", design_data.get("Software"));
		queue_data.put("System", design_data.get("System"));
		queue_data.put("Machine", design_data.get("Machine"));
		HashMap<String, String> queue_status = new HashMap<String, String>();
		queue_status.put("admin_status", "processing");
		queue_data.put("Status", queue_status);
		one_queue_hash.put(queue_name, queue_data);
		return one_queue_hash;
	}

	// generate different admin and task queue hash
	public void generate_suite_file_local_admin_task_queues(
			String generate_time,
			String local_file,
			HashMap<String, String> imported_data,
			String current_terminal
			) {
		String task_env = imported_data.get("env");
		String task_sort = imported_data.get("sort");
		TreeMap<String, HashMap<String, HashMap<String, String>>> xlsx_received_admin_queues_treemap = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> xlsx_received_task_queues_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>(); 
		local_file = local_file.replaceAll("\\$unit_path", public_data.DOC_EIT_PATH);
		//excel file sanity check
		if(!suite_file_sanity_check(local_file)){
			LOCAL_TUBE_LOGGER.warn("Suite file not exists or wrong format:" + local_file);
			return;	
		}
		//get excel file destination
		File xlsx_fobj = new File(local_file);
		String xlsx_dest = xlsx_fobj.getAbsoluteFile().getParent().replaceAll("\\\\", "/");
		//get excel data
		Map<String, List<List<String>>> ExcelData = new HashMap<String, List<List<String>>>();
		ExcelData.putAll(get_excel_data(local_file));
		HashMap<String, HashMap<String, String>> suite_sheets_data = get_suite_data(ExcelData);
		//generate every suite data for all suite sheets
		Boolean multi_suites = Boolean.valueOf(false);
		if (suite_sheets_data.size() > 1) {
			multi_suites = true;
			LOCAL_TUBE_LOGGER.info("Multi-Suite mode identified, will generate Admin/Task queues for every suite sheet...");
		}
		Iterator<String> suite_sheets_it = suite_sheets_data.keySet().iterator();
		while(suite_sheets_it.hasNext()) {
			String suite_sheet_name = new String(suite_sheets_it.next());
			Map<String, Map<String, String>> case_sheets_data = get_merge_macro_case_data(ExcelData, suite_sheet_name, multi_suites, task_sort);
			Map<String, HashMap<String, HashMap<String, String>>> merge_data = get_merge_suite_case_data(suite_sheets_data.get(suite_sheet_name), case_sheets_data, task_env, xlsx_dest);
			if (merge_data == null){
				LOCAL_TUBE_LOGGER.warn("Suite sheet no case found:" + local_file + ":" + suite_sheet_name);
				return;
			}
			//base queue name generate
			String admin_queue_base = new String();
			if (suite_sheets_data.get(suite_sheet_name).containsKey("suite_name")) {
				admin_queue_base = suite_sheets_data.get(suite_sheet_name).get("suite_name");
			} else {
				admin_queue_base = xlsx_fobj.getName().split("\\.")[0];
			}
			Iterator<String> case_it = merge_data.keySet().iterator();
			while (case_it.hasNext()) {
				// check current admin queue cover this requirements
				String case_name = case_it.next();
				HashMap<String, HashMap<String, String>> case_data = new HashMap<String, HashMap<String, String>>();
				case_data.putAll(merge_data.get(case_name));
				Boolean admin_queue_exists = Boolean.valueOf(false);
				String queue_name = new String();
				Iterator<String> queues_it = xlsx_received_admin_queues_treemap.keySet().iterator();
				while (queues_it.hasNext()) {
					queue_name = queues_it.next();
					HashMap<String, HashMap<String, String>> admin_queue_data = xlsx_received_admin_queues_treemap.get(queue_name);
					if (is_request_match(admin_queue_data, case_data)) {
						admin_queue_exists = true;
						break;
					}
				}
				// if admin queue note exists, create one xxx@runxxx_suite_time
				if (!admin_queue_exists) {
					// get admin queue name
					// make the new admin queue name use total received admin queues
					// number + 1
					String detail_time = generate_time;//time for create queue
					String sub_task_number = String.valueOf(xlsx_received_admin_queues_treemap.keySet().size() + 1);
					queue_name = get_one_queue_name(admin_queue_base, detail_time, sub_task_number, current_terminal, case_data);
					// get admin queue data
					HashMap<String, HashMap<String, String>> admin_queue_data = new HashMap<String, HashMap<String, String>>();
					admin_queue_data.putAll(case_data);
					HashMap<String, String> admin_id_data = admin_queue_data.get("ID");
					admin_id_data.put("run", admin_queue_base + "_" + detail_time);
					HashMap<String, String> admin_status_data = new HashMap<String, String>();
					admin_status_data.put("admin_status", "processing");
					admin_queue_data.put("Status", admin_status_data);
					xlsx_received_admin_queues_treemap.put(queue_name, admin_queue_data);
				}
				// insert design into xlsx received task queue : admin_queue_name
				//Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> received_task_queues_map = task_info
						//.get_received_task_queues_map();
				TreeMap<String, HashMap<String, HashMap<String, String>>> task_queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
				if (xlsx_received_task_queues_map.containsKey(queue_name)) {
					task_queue_data.putAll(xlsx_received_task_queues_map.get(queue_name));
				}
				HashMap<String, String> case_status_data = new HashMap<String, String>();
				case_status_data.put("cmd_status", task_enum.WAITING.get_description());
				case_data.put("Status", case_status_data);
				task_queue_data.put(case_name, case_data);
				xlsx_received_task_queues_map.put(queue_name, task_queue_data);
			}
			//return data to task data
			task_info.update_received_task_queues_map(xlsx_received_task_queues_map);
			task_info.update_received_admin_queues_treemap(xlsx_received_admin_queues_treemap);
		}
	}

	//===========================================================================
	//===========================================================================
	//for suite path support
	public static Boolean suite_paths_sanity_check(
			String suite_paths, 
			String suite_key) {
		for (String suite_path : suite_paths.split("\\s*,\\s*")){
			File path_fobj = new File(suite_path);
			if(!path_fobj.exists()){
				suite_path_error_msg = "Error: Suite path not exists:" + suite_paths;
				System.out.println(">>>Error: Suite path not exists:" + suite_paths);
				return false;
			}
			if(file_action.get_key_file_list(suite_path, suite_key).size() < 1){
				suite_path_error_msg = "Error: Suite path no key file found with search key:" + suite_key;
				System.out.println(">>>Error: Suite path no key file found with search key:" + suite_key);
				return false;			
			}
		}
		return true;
	}
	
	public void generate_suite_path_local_admin_task_queues(
			String generate_time,
			String suite_path,
			String work_space,
			HashMap<String, String> imported_data
			){
		//step 1:generate original case list
		List<String> case_list = new ArrayList<String>();
		case_list.addAll(get_case_list(suite_path, work_space, imported_data));
		//step 2:get case type
		case_enum case_type = get_case_type(suite_path, case_list);
		//step 3:generate overall case data
		TreeMap<String, HashMap<String, HashMap<String, String>>> all_case_data =  new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		all_case_data.putAll(get_local_case_data(suite_path, case_list, imported_data, case_type));
		//step 4:generate valid case data, case sorting
		TreeMap<String, HashMap<String, HashMap<String, String>>> valid_case_data =  new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		valid_case_data.putAll(get_valid_case_data(all_case_data, imported_data));
		//step 5:generate admin queue data
		TreeMap<String, HashMap<String, HashMap<String, String>>> admin_queues_map = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		admin_queues_map.putAll(get_local_admin_queues_data(generate_time, suite_path, case_type, imported_data, valid_case_data));
		task_info.update_received_admin_queues_treemap(admin_queues_map);
		//step 6:generate task queue data
		Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> task_queues_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
		task_queues_map.putAll(get_local_task_queues_data(case_type, admin_queues_map, valid_case_data));
		task_info.update_received_task_queues_map(task_queues_map);
		//System.out.println("Admin:" + admin_queues_map);
		//System.out.println("Task:" + task_queues_map);
	}
	
	private Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> get_local_task_queues_data(
			case_enum case_style,
			TreeMap<String, HashMap<String, HashMap<String, String>>> admin_queues_map,
			TreeMap<String, HashMap<String, HashMap<String, String>>> valid_case_data
			){
		Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> task_queues_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
		switch (case_style) {
		case FREESTYLE:
			task_queues_map.putAll(get_freestyle_task_queues_data(admin_queues_map, valid_case_data));
			break;
		case STANDARD:
			task_queues_map.putAll(get_standard_task_queues_data(admin_queues_map, valid_case_data));
			break;
		default:
			break;
		}
		return task_queues_map;
	}
	
	private Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> get_freestyle_task_queues_data(
			TreeMap<String, HashMap<String, HashMap<String, String>>> admin_queues_map,
			TreeMap<String, HashMap<String, HashMap<String, String>>> all_case_data
			){
		Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> task_queues_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
		Iterator<String> admin_queues_it = admin_queues_map.keySet().iterator();
		while(admin_queues_it.hasNext()){
			String queue_name = admin_queues_it.next();
			HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
			admin_data.putAll(admin_queues_map.get(queue_name));
			TreeMap<String, HashMap<String, HashMap<String, String>>> current_queue_case_map = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
			Iterator<String> all_case_data_it = all_case_data.keySet().iterator();
			while(all_case_data_it.hasNext()){
				String case_id = all_case_data_it.next();
				HashMap<String, HashMap<String, String>> case_data = new HashMap<String, HashMap<String, String>>(); 
				case_data.putAll(all_case_data.get(case_id));
				current_queue_case_map.put(case_id, merge_admin_task_data(admin_data, case_data));
			}
			task_queues_map.put(queue_name, current_queue_case_map);
		}
		return task_queues_map;
	}
	
	private Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> get_standard_task_queues_data(
			TreeMap<String, HashMap<String, HashMap<String, String>>> admin_queues_map,
			TreeMap<String, HashMap<String, HashMap<String, String>>> all_case_data
			){
		Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> task_queues_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
		Iterator<String> admin_queues_it = admin_queues_map.keySet().iterator();
		while(admin_queues_it.hasNext()){
			String queue_name = admin_queues_it.next();
			HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
			admin_data.putAll(admin_queues_map.get(queue_name));
			TreeMap<String, HashMap<String, HashMap<String, String>>> current_queue_case_map = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
			Iterator<String> all_case_data_it = all_case_data.keySet().iterator();
			while(all_case_data_it.hasNext()){
				String case_id = all_case_data_it.next();
				HashMap<String, HashMap<String, String>> case_data = new HashMap<String, HashMap<String, String>>();
				case_data.putAll(all_case_data.get(case_id));
				HashMap<String, String> valid_admin_data = new HashMap<String, String>();
				valid_admin_data.putAll(get_valid_request_data(admin_data));
				HashMap<String, String> valid_case_data = new HashMap<String, String>();
				valid_case_data.putAll(get_valid_request_data(case_data));
				if (admin_case_request_same(valid_admin_data, valid_case_data)) {
					current_queue_case_map.put(case_id, merge_admin_task_data(admin_data, case_data));
				}
			}
			task_queues_map.put(queue_name, current_queue_case_map);
		}
		return task_queues_map;
	}
	
	private HashMap<String, HashMap<String, String>> merge_admin_task_data(
			HashMap<String, HashMap<String, String>> admin_data,
			HashMap<String, HashMap<String, String>> task_data
			){
		HashMap<String, HashMap<String, String>> merge_data = new HashMap<String, HashMap<String, String>>();
		Iterator<String> task_data_it = task_data.keySet().iterator();
		while(task_data_it.hasNext()){
			String section_name = task_data_it.next();
			HashMap<String, String> task_section_data = new HashMap<String, String>();
			task_section_data.putAll(task_data.get(section_name));
			if (!admin_data.containsKey(section_name)) {
				merge_data.put(section_name, task_section_data);
				continue;
			}
			HashMap<String, String> admin_section_data = new HashMap<String, String>();
			admin_section_data.putAll(admin_data.get(section_name));
			merge_data.put(section_name, comm_admin_task_merge(admin_section_data, task_section_data, section_name));
		}
		return merge_data;
	}
	
	private TreeMap<String, HashMap<String, HashMap<String, String>>> get_local_admin_queues_data(
			String generate_time,
			String suite_path,
			case_enum case_style,
			HashMap<String, String> imported_data,
			TreeMap<String, HashMap<String, HashMap<String, String>>> valid_case_data
			){
		TreeMap<String, HashMap<String, HashMap<String, String>>> admin_queues_map = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		switch (case_style) {
		case FREESTYLE:
			admin_queues_map.putAll(get_freestyle_admin_queues_data(generate_time, suite_path, imported_data));
			break;
		case STANDARD:
			admin_queues_map.putAll(get_standard_admin_queues_data(generate_time, suite_path, valid_case_data, imported_data));
			break;
		default:
			break;
		}
		return admin_queues_map;
	}
	
	private HashMap<String, HashMap<String, HashMap<String, String>>> get_standard_admin_queues_data(
			String generate_time,
			String suite_path,
			TreeMap<String, HashMap<String, HashMap<String, String>>> all_case_data,
			HashMap<String, String> imported_data
			){
		HashMap<String, HashMap<String, HashMap<String, String>>> admin_queues_map = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		int queue_num = 0;
		Iterator<String> all_case_it = all_case_data.keySet().iterator();
		while(all_case_it.hasNext()){
			String case_id = all_case_it.next();
			HashMap<String, HashMap<String, String>> one_case_data = new HashMap<String, HashMap<String, String>>();
			one_case_data.putAll(all_case_data.get(case_id));
			//check case belonging
			String queue_name = new String("");
			queue_name = get_matching_admin_queue(admin_queues_map, one_case_data);
			if (queue_name == null || queue_name.equals("")) {
				queue_name = get_standard_admin_queue_name(String.valueOf(queue_num), generate_time, suite_path, one_case_data);
				HashMap<String, HashMap<String, String>> admin_data = new HashMap<String, HashMap<String, String>>();
				admin_data.putAll(get_standard_admin_queue_data(generate_time, suite_path, one_case_data, imported_data));
				admin_queues_map.put(queue_name, admin_data);
				queue_num++;
			}
		}
		return admin_queues_map;
	}
	
	private HashMap<String, HashMap<String, String>> get_standard_admin_queue_data(
			String generate_time,
			String suite_path,			
			HashMap<String, HashMap<String, String>> case_data,
			HashMap<String, String> imported_data
			) {
		HashMap<String, HashMap<String, String>> admin_queue_data = new HashMap<String, HashMap<String, String>>();
		//id_data create
		HashMap<String, String> id_data = new HashMap<String, String>();
		File path_obj = new File(suite_path);
		String suite_name = path_obj.getName();
		if (suite_name.length() < 1){
			suite_name = "local_suite";	
		}
		id_data.put("project", "y");
		id_data.put("run", suite_name + "_" + generate_time);
		id_data.put("suite", suite_name);
		id_data.put("epoch_time", String.valueOf(System.currentTimeMillis() / 1000));
		admin_queue_data.put("ID", id_data);
		//CaseInfo create
		HashMap<String, String> caseinfo_data = new HashMap<String, String>();
		caseinfo_data.put("suite_path", ".");
		caseinfo_data.put("repository", suite_path);
		admin_queue_data.put("CaseInfo", caseinfo_data);
		//LaunchCommand
		HashMap<String, String> cmd_data = new HashMap<String, String>();
		admin_queue_data.put("LaunchCommand", cmd_data);
		//Environment
		HashMap<String, String> env_data = new HashMap<String, String>();
		String extra_env = imported_data.get("env");
		List<String> env_list = new ArrayList<String>();
		if (extra_env.length() > 0){
			if (extra_env.contains(",")){
				env_list.addAll(Arrays.asList(extra_env.split("\\s*,\\s*")));
			} else if (extra_env.contains(";")){
				env_list.addAll(Arrays.asList(extra_env.split("\\s*;\\s*")));
			} else{
				env_list.add(extra_env);
			}
		}		
		if(env_list.size() > 0){
			for (String env_line: env_list){
				if (!env_line.contains("=")){
					LOCAL_TUBE_LOGGER.warn("Ignore environ setting since no = found in:" + env_line);
					continue;
				}
				String key = env_line.split("=", 2)[0].trim();
				String value = env_line.split("=", 2)[1].trim();
				env_data.put(key, value);
			}
		}		
		admin_queue_data.put("Environment", env_data);
		//Machine
		admin_queue_data.put("Machine", case_data.get("Machine"));		
		//System
		admin_queue_data.put("System", case_data.get("System"));
		//Software
		admin_queue_data.put("Software", case_data.get("Software"));
		//Software
		admin_queue_data.put("Preference", case_data.get("Preference"));
		//Status
		HashMap<String, String> status_data = new HashMap<String, String>();
		status_data.put("admin_status", "processing");
		admin_queue_data.put("Status", status_data);
		return admin_queue_data;
	}
	
	private String get_standard_admin_queue_name(
			String sub_id,
			String generate_time,
			String suite_path,
			HashMap<String, HashMap<String, String>> case_data
			) {
		// admin queue priority check:0>1>2..>5(default)>...8>9
		String priority = new String(public_data.TASK_PRI_LOCALLY);
		if (case_data.get("CaseInfo").containsKey("priority")) {
			priority = case_data.get("CaseInfo").get("priority");
		}
		// task belong to this client: 0, assign task(0) > match task(1)
		String assignment = new String("0");
		// receive time
		String mark_time = time_info.get_time_hhmm();
		// queue base name
		String admin_queue_base = new String("");
		File path_obj = new File(suite_path);
		String suite_name = path_obj.getName();
		if (suite_name.length() < 1){
			admin_queue_base = "local_suite";
		} else {
			admin_queue_base = suite_name;
		}
		// Max threads requirements
		String threads = new String(public_data.TASK_DEF_MAX_THREADS);
		if (!case_data.containsKey("Preference")) {
			threads = public_data.TASK_DEF_MAX_THREADS;
		} else if (!case_data.get("Preference").containsKey("max_threads")) {
			threads = public_data.TASK_DEF_MAX_THREADS;
		} else {
			threads = case_data.get("Preference").get("max_threads");
			Pattern p = Pattern.compile("^\\d$");
			Matcher m = p.matcher(threads);
			if (!m.find()) {
				threads = public_data.TASK_DEF_MAX_THREADS;
				LOCAL_TUBE_LOGGER.warn(admin_queue_base + ":has wrong Preference->max_threads, default value " + public_data.TASK_DEF_MAX_THREADS + " used.");
			}
		}		
		// host restart requirements--for local jobs always be 0		
		String restart_boolean = new String(public_data.TASK_DEF_HOST_RESTART);
		if (!case_data.containsKey("Preference")) {
			restart_boolean = public_data.TASK_DEF_HOST_RESTART;
		} else if (!case_data.get("Preference").containsKey("host_restart")) {
			restart_boolean = public_data.TASK_DEF_HOST_RESTART;
		} else {
			String request_value = new String(case_data.get("Preference").get("host_restart").trim());
			if (!data_check.str_choice_check(request_value, new String [] {"false", "true"} )){
				LOCAL_TUBE_LOGGER.warn(admin_queue_base + ":has wrong Preference->host_restart, default value " + public_data.TASK_DEF_HOST_RESTART + " used.");
			} else {
				restart_boolean = request_value;
			}
		}
		String restart = new String("0");
		if (restart_boolean.equalsIgnoreCase("true")) {
			restart = "1";
		} else {
			restart = "0";
		}
		// queue name generate
		StringBuilder queue_name = new StringBuilder("");
		queue_name.append(priority);
		queue_name.append(assignment);
		queue_name.append("0");//1, from remote; 0, from local
		queue_name.append("@");
		queue_name.append("t" + threads);
		queue_name.append("r" + restart);
		queue_name.append("_");
		queue_name.append("run_" + mark_time + "_" + sub_id + "_" + admin_queue_base + "_" + generate_time);
		return queue_name.toString();
	}
	
	private String get_matching_admin_queue(
			HashMap<String, HashMap<String, HashMap<String, String>>> admin_queues_map,
			HashMap<String, HashMap<String, String>> case_data
			) {
		String queue_name = new String("");
		Iterator<String> all_queues_it = admin_queues_map.keySet().iterator();
		while(all_queues_it.hasNext()){
			String current_queue = all_queues_it.next();
			HashMap<String, String> valid_admin_data = new HashMap<String, String>();
			valid_admin_data.putAll(get_valid_request_data(admin_queues_map.get(current_queue)));
			HashMap<String, String> valid_case_data = new HashMap<String, String>();
			valid_case_data.putAll(get_valid_request_data(case_data));
			if (admin_case_request_same(valid_admin_data, valid_case_data)) {
				queue_name = current_queue;
				break;
			}
		}
		return queue_name;
	}
	
	private Boolean admin_case_request_same(
			HashMap<String, String> admin_request_data,
			HashMap<String, String> case_request_data
			) {
		Boolean status = Boolean.valueOf(true);
		if (admin_request_data.size() != case_request_data.size()) {
			return false;
		}
		Iterator<String> admin_it = admin_request_data.keySet().iterator();
		while(admin_it.hasNext()){
			String admin_option_name = admin_it.next();
			String admin_option_value = admin_request_data.get(admin_option_name);
			if (!case_request_data.containsKey(admin_option_name)) {
				status = false;
				break;
			}
			String case_option_value = case_request_data.get(admin_option_name);
			if (!admin_option_value.equalsIgnoreCase(case_option_value)) {
				status = false;
				break;
			}
		}
		return status;
	}
	
	private HashMap<String, String> get_valid_request_data(
			HashMap<String, HashMap<String, String>> case_data
			) {
		HashMap<String, String> merge_data = new HashMap<String, String>();
		HashMap<String, String> valid_data = new HashMap<String, String>();
		if (case_data.containsKey("Software")) {
			merge_data.putAll(case_data.get("Software"));
		}
		if (case_data.containsKey("System")) {
			merge_data.putAll(case_data.get("System"));
		}
		if (case_data.containsKey("Machine")) {
			merge_data.putAll(case_data.get("Machine"));
		}
		if (case_data.containsKey("Preference")) {
			merge_data.putAll(case_data.get("Preference"));
		}
		Iterator<String> merge_data_it = merge_data.keySet().iterator();
		while(merge_data_it.hasNext()){
			String option_name = merge_data_it.next();
			String option_value = merge_data.get(option_name);
			if (option_value == null || option_value.equalsIgnoreCase("")) {
				continue;
			}
			valid_data.put(option_name, option_value);
		}
		return valid_data;
	}
	
	private HashMap<String, HashMap<String, HashMap<String, String>>> get_freestyle_admin_queues_data(
			String generate_time,
			String suite_path,
			HashMap<String, String> imported_data
			){
		HashMap<String, HashMap<String, HashMap<String, String>>> admin_queues_map = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		String queue_name = new String();
		queue_name = get_freestyle_admin_queue_name(generate_time, suite_path);
		HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
		queue_data.putAll(get_freestyle_admin_queue_data(generate_time, suite_path, imported_data));
		admin_queues_map.put(queue_name, queue_data);
		return admin_queues_map;
	}
	
	private String get_freestyle_admin_queue_name(
			String generate_time,
			String suite_path
			) {
		// admin queue priority check:0>1>2..>5(default)>...8>9
		String priority = new String(public_data.TASK_PRI_LOCALLY);
		// task belong to this client: 0, assign task(0) > match task(1)
		String assignment = new String("0");
		// receive time
		String mark_time = time_info.get_time_hhmm();
		// queue base name
		String admin_queue_base = new String("");
		File path_obj = new File(suite_path);
		String suite_name = path_obj.getName();
		if (suite_name.length() < 1){
			admin_queue_base = "local_suite";
		} else {
			admin_queue_base = suite_name;
		}
		// queue name generate
		StringBuilder queue_name = new StringBuilder("");
		queue_name.append(priority);
		queue_name.append(assignment);
		queue_name.append("0");//1, from remote; 0, from local
		queue_name.append("@");
		queue_name.append("t" + public_data.TASK_DEF_MAX_THREADS);
		queue_name.append("r0");
		queue_name.append("_");
		queue_name.append("run_" + mark_time + "_" + admin_queue_base + "_" + generate_time);
		return queue_name.toString();
	}
	
	private HashMap<String, HashMap<String, String>> get_freestyle_admin_queue_data(
			String generate_time,
			String suite_path,
			HashMap<String, String> imported_data
			){
		HashMap<String, HashMap<String, String>> admin_queue_data = new HashMap<String, HashMap<String, String>>();
		//id_data create
		HashMap<String, String> id_data = new HashMap<String, String>();
		File path_obj = new File(suite_path);
		String suite_name = path_obj.getName();
		if (suite_name.length() < 1){
			suite_name = "local_suite";	
		}
		id_data.put("project", "x");
		id_data.put("run", suite_name + "_" + generate_time);
		id_data.put("suite", suite_name);
		id_data.put("epoch_time", String.valueOf(System.currentTimeMillis() / 1000));
		admin_queue_data.put("ID", id_data);
		//CaseInfo create
		HashMap<String, String> caseinfo_data = new HashMap<String, String>();
		caseinfo_data.put("suite_path", ".");
		caseinfo_data.put("repository", suite_path);
		admin_queue_data.put("CaseInfo", caseinfo_data);
		//Machine
		HashMap<String, String> machine_data = new HashMap<String, String>();
		admin_queue_data.put("Machine", machine_data);
		//LaunchCommand
		HashMap<String, String> cmd_data = new HashMap<String, String>();
		String exe_file = imported_data.get("exe");
		String arg_file = imported_data.get("arg");
		File exe_frh = new File(exe_file);
		//if (!exe_frh.exists() && !exe_file.contains("$work_path") && !exe_file.contains("$tool_path")){
		//	exe_file = "$case_path/" + exe_file;
		//}
		if (exe_file.contains("$work_path")) {
			LOCAL_TUBE_LOGGER.debug("$work_path will be replaced with runtime work space.");
		} else if (exe_file.contains("$tool_path")) {
			LOCAL_TUBE_LOGGER.debug("$tool_path will be replaced with runtime tool path.");
		} else if (exe_file.startsWith(public_data.CORE_SCRIPT_NAME)) {
			LOCAL_TUBE_LOGGER.debug("Corescript identified, will be updated to absolute path later.");
		} else if (exe_frh.exists()) {
			LOCAL_TUBE_LOGGER.debug("User absolute path for execute file found.");
		} else {
			LOCAL_TUBE_LOGGER.warn("Unknown execute file found, assuming it located in Case Path...");
			exe_file = "$case_path/" + exe_file;
		}		
		if (arg_file.length() > 0){
			exe_file = exe_file + " " + arg_file;
		}
		if(exe_file.contains(".py")){
			cmd_data.put("cmd", "python " + exe_file);
		} else if (exe_file.contains(".pl")){
			cmd_data.put("cmd", "perl " + exe_file);
		} else if (exe_file.contains(".sh")){
			cmd_data.put("cmd", "sh " + exe_file);
		} else {
			cmd_data.put("cmd", exe_file);
		}
		cmd_data.put("dir", "$case_path");
		admin_queue_data.put("LaunchCommand", cmd_data);
		//Environment
		HashMap<String, String> env_data = new HashMap<String, String>();
		String extra_env = imported_data.get("env");
		List<String> env_list = new ArrayList<String>();
		if (extra_env.length() > 0){
			if (extra_env.contains(",")){
				env_list.addAll(Arrays.asList(extra_env.split("\\s*,\\s*")));
			} else if (extra_env.contains(";")){
				env_list.addAll(Arrays.asList(extra_env.split("\\s*;\\s*")));
			} else{
				env_list.add(extra_env);
			}
		}		
		if(env_list.size() > 0){
			for (String env_line: env_list){
				if (!env_line.contains("=")){
					LOCAL_TUBE_LOGGER.warn("Ignore environ setting since no = found in:" + env_line);
					continue;
				}
				String key = env_line.split("=", 2)[0].trim();
				String value = env_line.split("=", 2)[1].trim();
				env_data.put(key, value);
			}
		}		
		admin_queue_data.put("Environment", env_data);
		//System
		HashMap<String, String> system_data = new HashMap<String, String>();
		admin_queue_data.put("System", system_data);		
		//Software
		HashMap<String, String> software_data = new HashMap<String, String>();
		admin_queue_data.put("Software", software_data);
		//Status
		HashMap<String, String> status_data = new HashMap<String, String>();
		status_data.put("admin_status", "processing");
		admin_queue_data.put("Status", status_data);
		return admin_queue_data;
	}
	
	private List<String> get_design_name_list(
			String suite_path, 
			String key_pattern
			){
		List<String> design_list = new ArrayList<String>();
		List<String> key_paths = new ArrayList<String>();
		key_paths.addAll(file_action.get_key_path_list(suite_path, key_pattern));
		for (String key_path:key_paths){
			if (key_path.equalsIgnoreCase(suite_path)) {
				design_list.add(".");
			} else {
				key_path = key_path.replaceAll(suite_path, "");
				key_path = key_path.replaceAll("^/", "");
				design_list.add(key_path);
			}
		}
		return design_list;
	}
	
	private case_enum get_case_type(
			String suite_path,
			List<String> case_list
			) {
		case_enum case_type = case_enum.FREESTYLE;
		int standard_num = 0;
		for (String case_name:case_list) {
			String run_info = new String(suite_path + "/" + case_name + "/" + public_data.CASE_RUN_FILE);
			File info_fobj = new File(run_info);
			if(info_fobj.exists()) {
				standard_num ++;
			}
		}
		if (standard_num > case_list.size() / 2 ) {
			case_type = case_enum.STANDARD;
		} else {
			case_type = case_enum.FREESTYLE;
		}
		LOCAL_TUBE_LOGGER.warn("Suite path:" + suite_path);
		LOCAL_TUBE_LOGGER.warn("Case type:" + case_type.get_description());
		return case_type;
	}
	
	private List<String> get_case_list(
			String suite_path,
			String work_space,
			HashMap<String, String> imported_data
			){
		String key_pattern = imported_data.get("key");
		String list_path = suite_path + "/" + public_data.SUITE_LIST_FILE_NAME;	
		File list_fobj = new File(list_path);
		List<String> case_list = new ArrayList<String>();
		if (list_fobj.exists()){
			List<String> line_list = new ArrayList<String>();
			line_list.addAll(file_action.read_file_lines(list_path));
			for (String line : line_list){
				if(line.startsWith(";") || line.startsWith("#")){
					continue;
				}
				File path_obj = new File(suite_path + "/" + line);
				if(path_obj.exists()){
					case_list.add(line.replaceAll("\\\\", "/"));
				}
			}
		} else {
			case_list.addAll(get_design_name_list(suite_path, key_pattern));
		}
		//remove abnormal test case like DEV, results, log... folders
		Boolean same_path = Boolean.valueOf(false);
		List<String> valid_case_list = new ArrayList<String>();
		List<String> invalid_case_list = new ArrayList<String>();
		try {
			same_path = file_action.is_path_same(suite_path, work_space);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			LOCAL_TUBE_LOGGER.warn("Path compare failed:" + suite_path + "<=>" + work_space);
		}
		if (same_path) {
			for (String case_path: case_list) {
				Boolean is_reserved = Boolean.valueOf(false);
				for(String reserved_name:public_data.WORKSPACE_RESERVED_DIR){
					if (case_path.equals(reserved_name) || case_path.startsWith(reserved_name + "/")) {
						LOCAL_TUBE_LOGGER.warn("Reserved dir name removed:" + case_path);
						is_reserved = true;
						break;
					}
				}
				if (is_reserved) {
					invalid_case_list.add(case_path);
				} else {
					valid_case_list.add(case_path);
				}
			}
		} else {
			valid_case_list.addAll(case_list);
			LOCAL_TUBE_LOGGER.info("Following case caught:");
			LOCAL_TUBE_LOGGER.info(valid_case_list.toString());
		}
		if (!invalid_case_list.isEmpty()) {
			LOCAL_TUBE_LOGGER.warn("Following case removed due to System reserved name impacting:");
			LOCAL_TUBE_LOGGER.warn(invalid_case_list.toString());
			LOCAL_TUBE_LOGGER.warn("Reserved names:" +  String.join(",", public_data.WORKSPACE_RESERVED_DIR));
		}
		return valid_case_list;
	}
	
	private TreeMap<String, HashMap<String, HashMap<String, String>>> get_valid_case_data(
			TreeMap<String, HashMap<String, HashMap<String, String>>> all_case_data,
			HashMap<String, String> imported_data
			){
		TreeMap<String, HashMap<String, HashMap<String, String>>> valid_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		String sort_str = imported_data.get("sort");
		HashMap<String, String> request_data = new HashMap<String, String>();
		request_data.putAll(get_sort_map_data(sort_str));
		Iterator<String> all_case_it = all_case_data.keySet().iterator();
		while(all_case_it.hasNext()){
			String case_id = all_case_it.next();
			HashMap<String, HashMap<String, String>> case_data = new HashMap<String, HashMap<String, String>>();
			case_data.putAll(all_case_data.get(case_id));
			String design_name = case_data.get("CaseInfo").get("design_name");
			Boolean valid_case = Boolean.valueOf(true);
			Iterator<String> request_it = request_data.keySet().iterator();
			while(request_it.hasNext()) {
				String request_option = request_it.next();
				String request_value = request_data.get(request_option);
				HashMap<String, String> check_data = new HashMap<String, String>();
				Iterator<String> section_it = case_data.keySet().iterator();
				while(section_it.hasNext()) {
					String section_name = section_it.next();
					if(section_name.equalsIgnoreCase("CaseInfo")) {
						continue;
					}
					if(section_name.equalsIgnoreCase("LaunchCommand")) {
						continue;
					}
					if(section_name.equalsIgnoreCase("Environment")) {
						continue;
					}
					if(section_name.equalsIgnoreCase("Preference")) {
						continue;
					}
					check_data.putAll(case_data.get(section_name));
				}
				if (!check_data.containsKey(request_option)) {
					valid_case = false;
					break;
				}
				String case_value = new String(check_data.get(request_option).toLowerCase());
				//if (!check_data.get(request_option).equalsIgnoreCase(request_value)) {
				if (!Arrays.asList(request_value.split("\\s*,\\s*")).contains(case_value)) {
					valid_case = false;
					break;
				}
			}
			if (valid_case) {
				valid_data.put(case_id, case_data);
			} else {
				LOCAL_TUBE_LOGGER.warn(design_name + ": Ignored, doesn't match:" + sort_str);
			}
		}
		return valid_data;		
	}
	
	private TreeMap<String, HashMap<String, HashMap<String, String>>> get_local_case_data(
			String suite_path,
			List<String> case_list,
			HashMap<String, String> imported_data,
			case_enum case_style
			){
		TreeMap<String, HashMap<String, HashMap<String, String>>> case_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		switch (case_style) {
		case FREESTYLE:
			case_data.putAll(get_freestyle_case_data(suite_path, case_list, imported_data));
			break;
		case STANDARD:
			case_data.putAll(get_standard_case_data(suite_path, case_list));
			break;
		default:
			break;
		}
		return case_data;
	}
	
	private HashMap<String, String> get_json_file_data(
			String file_path
			){
		HashMap<String, String> json_data = new HashMap<String, String>();
		File data_fobj = new File(file_path);
		if (!data_fobj.exists()){
			return json_data;
		}
		Map<String, Object> json_data_object = new HashMap<String, Object>();
		json_data_object.putAll(file_action.get_json_map_data(file_path));
		if (json_data_object.isEmpty()){
			return json_data;
		}			
		Iterator<String> src_it = json_data_object.keySet().iterator();
		while(src_it.hasNext()){
			String json_key = src_it.next();
			Object json_obj = json_data_object.get(json_key);
			json_data.put(json_key, json_obj.toString());
		}
		return json_data;
	}
	
	private TreeMap<String, HashMap<String, HashMap<String, String>>> get_freestyle_case_data(
			String suite_path,
			List<String> case_list,
			HashMap<String, String> imported_data
			){
		TreeMap<String, HashMap<String, HashMap<String, String>>> all_case_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		//generate case data
		int case_counter = 0;
		String data_file = imported_data.get("dat");
		for(String design_name: case_list){
			HashMap<String, HashMap<String, String>> one_case_data = new HashMap<String, HashMap<String, String>>();
			//generate case name
			String case_id = String.valueOf(case_counter);
			//generate TestID
			HashMap<String, String> testid_data = new HashMap<String, String>();
			testid_data.put("id", case_id);
			one_case_data.put("TestID", testid_data);
			//generate ID
			HashMap<String, String> id_data = new HashMap<String, String>();
			id_data.put("id", case_id);
			one_case_data.put("ID", id_data);			
			//generate CaseInfo
			HashMap<String, String> info_data = new HashMap<String, String>();
			info_data.put("design_name", design_name);
			one_case_data.put("CaseInfo", info_data);
			//generate Environment
			HashMap<String, String> environment = new HashMap<String, String>();
			one_case_data.put("Environment", environment);
			//generate LaunchCommand
			HashMap<String, String> launchcommand = new HashMap<String, String>();
			one_case_data.put("LaunchCommand", launchcommand);			
			//generate Machine
			HashMap<String, String> machine_data = new HashMap<String, String>();
			one_case_data.put("Machine", machine_data);
			//generate System
			HashMap<String, String> system_data = new HashMap<String, String>();
			one_case_data.put("System", system_data);
			//generate Software
			HashMap<String, String> software_data = new HashMap<String, String>();
			one_case_data.put("Software", software_data);
			//generate Preference
			HashMap<String, String> preference_data = new HashMap<String, String>();
			one_case_data.put("Preference", preference_data);			
			//generate Status
			HashMap<String, String> status_data = new HashMap<String, String>();
			status_data.put("cmd_status", task_enum.WAITING.get_description());
			one_case_data.put("Status", status_data);
			//generate general
			HashMap<String, String> general_data = new HashMap<String, String>();
			String data_path = new String(suite_path + "/" + design_name + "/" +  data_file);
			general_data.putAll(get_json_file_data(data_path));
			one_case_data.put("General", general_data);
			//return
			all_case_data.put(case_id, one_case_data);
			case_counter++;
		}
		return all_case_data;
	}
	
	private TreeMap<String, HashMap<String, HashMap<String, String>>> get_standard_case_data(
			String suite_path,
			List<String> case_list
			){
		TreeMap<String, HashMap<String, HashMap<String, String>>> all_case_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		int case_counter = 0;
		for(String design_name: case_list){
			HashMap<String, HashMap<String, String>> one_case_data = new HashMap<String, HashMap<String, String>>();
			//generate case name
			String case_id = String.valueOf(case_counter);
			//generate TestID
			HashMap<String, String> testid_data = new HashMap<String, String>();
			testid_data.put("id", case_id);
			one_case_data.put("TestID", testid_data);
			//generate ID
			HashMap<String, String> id_data = new HashMap<String, String>();
			id_data.put("id", case_id);
			one_case_data.put("ID", id_data);			
			//generate CaseInfo
			HashMap<String, String> info_data = new HashMap<String, String>();
			info_data.put("design_name", design_name);//default design name, will be override later
			one_case_data.put("CaseInfo", info_data);
			//generate Status
			HashMap<String, String> status_data = new HashMap<String, String>();
			status_data.put("cmd_status", task_enum.WAITING.get_description());
			one_case_data.put("Status", status_data);
			//generate Environment
			HashMap<String, String> environment = new HashMap<String, String>();
			one_case_data.put("Environment", environment);
			//generate LaunchCommand
			HashMap<String, String> launchcommand = new HashMap<String, String>();
			one_case_data.put("LaunchCommand", launchcommand);			
			//generate Machine
			HashMap<String, String> machine_data = new HashMap<String, String>();
			one_case_data.put("Machine", machine_data);
			//generate System
			HashMap<String, String> system_data = new HashMap<String, String>();
			one_case_data.put("System", system_data);
			//generate Software
			HashMap<String, String> software_data = new HashMap<String, String>();
			one_case_data.put("Software", software_data);
			//generate Preference
			HashMap<String, String> preference_data = new HashMap<String, String>();
			one_case_data.put("Preference", preference_data);			
			//get ini file data, override previously
			String info_file = new String(suite_path + "/" + design_name + "/" +  public_data.CASE_RUN_FILE);
			ini_parser ini_runner = new ini_parser(info_file);
			HashMap<String, HashMap<String, String>> raw_ini_data = new HashMap<String, HashMap<String, String>>();
			try {
				raw_ini_data.putAll(ini_runner.read_ini_data());
			} catch (ConfigurationException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				LOCAL_TUBE_LOGGER.warn("Parser case info file failed:" + info_file);
			}
			//override case data with valid ini data
			HashMap<String, HashMap<String, String>> valid_ini_data = new HashMap<String, HashMap<String, String>>();
			valid_ini_data.putAll(get_valid_ini_data(raw_ini_data));
			Iterator<String> valid_ini_data_it = valid_ini_data.keySet().iterator();
			while(valid_ini_data_it.hasNext()){
				String section_name = valid_ini_data_it.next();
				HashMap<String, String> ini_data = valid_ini_data.get(section_name);
				if (!one_case_data.containsKey(section_name)) {
					one_case_data.put(section_name, ini_data);
				} else {
					HashMap<String, String> case_data = one_case_data.get(section_name);
					case_data.putAll(ini_data);
				}
			}
			if (one_case_data.containsKey("General")) {
				if (one_case_data.get("General").containsKey("nouse")) {
					if (one_case_data.get("General").get("nouse").equalsIgnoreCase("yes")) {
						LOCAL_TUBE_LOGGER.warn(design_name + " 'nouse' asserted, skip this case.");
						continue;
					}
				}
			}
			//skip ignore case
			//include case
			all_case_data.put(case_id, one_case_data);
			case_counter++;
		}
		return all_case_data;
	}
	
	private HashMap<String, HashMap<String, String>> get_valid_ini_data(
			HashMap<String, HashMap<String, String>> raw_data
			) {
		HashMap<String, HashMap<String, String>> valid_data = new HashMap<String, HashMap<String, String>>();
		Iterator<String> raw_data_it = raw_data.keySet().iterator();
		while(raw_data_it.hasNext()){
			String section_name = raw_data_it.next();
			HashMap<String, String> raw_section_data = new HashMap<String, String> ();
			raw_section_data.putAll(raw_data.get(section_name));
			HashMap<String, String> valid_section_data = new HashMap<String, String> ();
			Iterator<String> raw_section_it = raw_section_data.keySet().iterator();
			while(raw_section_it.hasNext()) {
				String option_name = raw_section_it.next();
				String option_value = raw_section_data.get(option_name).trim();
				if (option_value == null || option_value.equals("")) {
					continue;
				}
				valid_section_data.put(option_name, option_value);
			}
			valid_data.put(section_name, valid_section_data);
		}
		return valid_data;
	}
		//generate case data	
	//===========================================================================
	//===========================================================================
	//main	
	public static void main(String[] argv) {
		task_data task_info = new task_data();
		local_tube sheet_parser = new local_tube(task_info);
		String current_terminal = "LSHITD0097";
		HashMap<String, String> imported_data = new HashMap<String, String>();
		imported_data.put("env", "a=b");
		imported_data.put("sort", "");
		imported_data.put("key", public_data.CASE_USER_PATTERN + "|" + public_data.CASE_STANDARD_PATTERN);
		sheet_parser.generate_suite_file_local_admin_task_queues(time_info.get_date_time(), "C:\\Users\\jwang1\\Desktop\\radiant_regression.xlsx", imported_data, current_terminal);
		System.out.println(task_info.get_received_task_queues_map().toString());
		System.out.println(task_info.get_received_admin_queues_treemap().toString()); 
		//sheet_parser.generate_suite_path_local_admin_task_queues(time_info.get_date_time(), "C:/Users/jwang1/Desktop/cmdall_tt", "D:/tmp_work", imported_data);
		//sheet_parser.generate_suite_path_local_admin_task_queues(time_info.get_date_time(), "D:/work_space/tcl_suite/aa/pn_00_tcl_plus/msg/msg_suppress", "D:/tmp_work", imported_data);
		//System.out.println(task_info.get_received_task_queues_map().toString());
		//System.out.println(task_info.get_received_admin_queues_treemap().toString());
		/*
		xml_parser xml_parser2 = new xml_parser();
		Iterator<String> dump_queue_it = task_info.get_received_admin_queues_treemap().keySet().iterator();
		String queue_name = dump_queue_it.next();
		HashMap<String, HashMap<String, String>> admin_queue_data = task_info
				.get_queue_data_from_received_admin_queues_treemap(queue_name);
		System.out.println(queue_name);
		System.out.println(admin_queue_data);
		try {
			xml_parser2.dump_admin_data(admin_queue_data, queue_name,
					"D:/tmp_work_space/logs/finished/admin/test.xml");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		TreeMap<String, HashMap<String, HashMap<String, String>>> task_queue_data = task_info
				.get_received_task_queues_map().get(queue_name);
		System.out.println(task_queue_data);
		try {
			xml_parser2.dump_task_data(task_queue_data, queue_name,
					"D:/tmp_work_space/logs/finished/task/test.xml");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		*/
	}
}