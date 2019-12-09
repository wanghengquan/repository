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
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.public_data;
import flow_control.task_enum;
import info_parser.xls_parser;
import utility_funcs.deep_clone;
import utility_funcs.file_action;
import utility_funcs.time_info;

/*
 * This class used to instance rabbitMQ tube between server and center processor.
 * 1: Memory 
 */
public class local_tube {
	// public property
	public static String suite_file_error_msg = new String();
	public static String suite_path_error_msg = new String();
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
	public static Map<String, List<List<String>>> get_excel_data(String excel_file) {
		Map<String, List<List<String>>> ExcelData = new HashMap<String, List<List<String>>>();
		xls_parser excel_obj = new xls_parser();
		ExcelData = excel_obj.GetExcelData(excel_file);
		return ExcelData;
	}

	public static Boolean suite_files_sanity_check(String file_paths) {
		Boolean all_pass = new Boolean(true);
		for (String file:file_paths.split(",")){
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
	
	public static Boolean suite_file_sanity_check(String file_path) {
		File xlsx_fobj = new File(file_path);
		if(!xlsx_fobj.exists()){
			suite_file_error_msg = "Error: Suite file not exists.";
			System.out.println(">>>Error: Suite file not exists.");
			return false;
		}
		Map<String, List<List<String>>> ExcelData = new HashMap<String, List<List<String>>>();
		ExcelData.putAll(get_excel_data(file_path));
		//check suite sheet
		if (!ExcelData.containsKey("suite")) {
			suite_file_error_msg = "Error: Cannot find 'suite' sheet.";
			System.out.println(">>>Error: Cannot find 'suite' sheet.");
			return false;
		}
		//check case sheet
		Iterator<String> sheet_it = ExcelData.keySet().iterator();
		Boolean get_sheet = new Boolean(false);
		while(sheet_it.hasNext()){
			String sheet_name = sheet_it.next();
			if (sheet_name.contains("case")){
				get_sheet = true;
				break;
			}
		}
		if (!get_sheet){
			suite_file_error_msg = "Error: Cannot find 'case' sheet.";
			System.out.println(">>>Error: Cannot find 'case' sheet.");
			return false;			
		}
		// suite info check
		Map<String, String> suite_map = get_suite_data(ExcelData);
		if ((suite_map.size() > 8) && (!suite_map.containsKey("ClientPreference"))){
			suite_file_error_msg = "Error: Extra option found in suite sheet::suite info.";
			System.out.println(">>>Error: Extra option found in suite sheet::suite info.");
			System.out.println(suite_map.keySet().toString());
			return false;
		}
		String[] suite_keys = { "project_id", "suite_name", "CaseInfo", "Environment", "LaunchCommand", "Software",
				"System", "Machine" };
		for (String x : suite_keys) {
			if (!suite_map.containsKey(x)) {
				suite_file_error_msg = "Error: Suite sheet missing :" + x + ".";
				System.out.println(">>>Error: Suite sheet missing :" + x + ".");
				return false;
			}
		}
		String prj_id = suite_map.get("project_id");
		try {
			@SuppressWarnings("unused")
			int id = Integer.parseInt(prj_id);
		} catch (NumberFormatException id_e) {
			suite_file_error_msg = "Error: project_id value wrong, should be a number.";
			System.out.println(">>>Error: project_id value wrong, should be a number.");
			return false;
		}
		String suite_name = suite_map.get("suite_name");
		if (suite_name == null || suite_name == "") {
			suite_file_error_msg = "Error: Suite name missing.";
			System.out.println(">>>Error: Suite name missing.");
			return false;
		}
		// case sheet title check
		List<String> case_title = get_case_title(ExcelData);
		if (case_title == null) {
			suite_file_error_msg = "Error: Cannot find title line in case sheet.";
			System.out.println(">>>Error: Cannot find title line in case sheet.");
			return false;
		}
		String[] must_keys = { "Order", "Title", "Section", "design_name", "TestLevel", "TestScenarios", "Description",
				"Type", "Priority", "CaseInfo", "Environment", "Software", "System", "Machine", "NoUse" };
		//for previously version support do not list 'Automated' in must_keys
		for (String x : must_keys) {
			if (!case_title.contains(x)) {
				suite_file_error_msg = "Error: case sheet title missing :" + x + ".";
				System.out.println(">>>Error: case sheet title missing :" + x + ".");
				return false;
			}
		}
		// macro info check
		Map<String, List<List<String>>> macro_data = get_macro_data(ExcelData);
		if (macro_data != null) {
			Set<String> keyset = macro_data.keySet();
			Iterator<String> it = keyset.iterator();
			while (it.hasNext()) {
				String macro_name = it.next();
				List<List<String>> macro_lines = macro_data.get(macro_name);
				for (int line_index = 0; line_index < macro_lines.size(); line_index++) {
					String item = macro_lines.get(line_index).get(0);
					String column = macro_lines.get(line_index).get(1);
					if (!item.equals("condition") && !item.equals("action")) {
						suite_file_error_msg = "Error: Wrong macro key found in suite sheet:" + item + ".";
						System.out.println(">>>Error: Wrong macro key found in suite sheet:" + item + ".");
						return false;
					}
					if (!case_title.contains(column)) {
						suite_file_error_msg = "Error: suite sheet cannot find macro column in case sheet:" + column + ".";
						System.out.println(">>>Error: suite sheet cannot find macro column in case sheet:" + column + ".");
						return false;
					}
				}
			}
		}
		return true;
	}

	public static Map<String, String> get_suite_data(Map<String, List<List<String>>> ExcelData) {
		// key word verify
		List<List<String>> suite_sheet = ExcelData.get("suite");
		Map<String, String> suite_data = new HashMap<String, String>();
		// get suite data
		String suite_start = new String("[suite_info]");
		String pre_word = null;
		String pre_value = null;
		Boolean suite_area = new Boolean(false);
		for (int row = 0; row < suite_sheet.size(); row++) {
			List<String> row_list = suite_sheet.get(row);
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
				suite_data.put(item, value.replaceAll("\\\\", "/"));
			}
			pre_word = item;
			pre_value = value;
		}
		return suite_data;
	}

	public static Map<String, List<List<String>>> get_macro_data(Map<String, List<List<String>>> ExcelData) {
		// get macro data
		List<List<String>> suite_sheet = ExcelData.get("suite");
		Map<String, List<List<String>>> macro_data = new HashMap<String, List<List<String>>>();
		Map<String, List<List<String>>> return_data = new HashMap<String, List<List<String>>>();
		int macro_num = 0;
		String macro_start = new String("[macro]");
		Boolean macro_area = new Boolean(false);
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
				if (item == null || item.equals("") || item.equals("END")) {
					macro_area = false;
					macro_data.put(macro_name, area_list);
				} else {
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
		return_data = sort_macro_map(macro_data);
		return return_data;
	}

	public static Map<String, List<List<String>>> sort_macro_map(Map<String, List<List<String>>> oriMap) {
		if (oriMap == null || oriMap.isEmpty()) {
			return null;
		}
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

	private Map<String, Map<String, String>> get_raw_case_data(Map<String, List<List<String>>> ExcelData) {
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
				String[] flow_array = column_flow.split(";");
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
			String task_sort) {
		Map<String, Map<String, String>> merge_macro_data = new HashMap<String, Map<String, String>>();
		// start
		Map<String, List<List<String>>> macro_data = get_macro_data(ExcelData);
		Map<String, Map<String, String>> raw_data = get_raw_case_data(ExcelData);
		if (raw_data == null || raw_data.isEmpty()) {
			LOCAL_TUBE_LOGGER.warn(">>>Warning: No test case found in suite file.");
			return merge_macro_data;
		}
		Iterator<String> data_it = raw_data.keySet().iterator();
		while (data_it.hasNext()) {
			String case_order = data_it.next().trim();
			Integer macro_order = new Integer(0);
			String macro_case_order = new String();
			Map<String, String> case_data = new HashMap<String, String>();
			case_data.putAll(raw_data.get(case_order));
			if (case_data.containsKey("NoUse") && case_data.get("NoUse").equalsIgnoreCase("yes")) {
				LOCAL_TUBE_LOGGER.warn(">>>Warning: Skipping NoUse case:" + case_data.get("Order"));
				continue;
			}
			if (case_data.containsKey("Automated") &&  case_data.get("Automated").equalsIgnoreCase("no")) {
				LOCAL_TUBE_LOGGER.warn(">>>Warning: Skipping Non-Automated case:" + case_data.get("Order"));
				continue;
			}
			if (!case_data_match_task_sort(case_data, task_sort)){
				LOCAL_TUBE_LOGGER.warn(">>>Warning: Skipping mismatched case:" + case_data.get("Order"));
				continue;				
			}
			if (macro_data == null || macro_data.isEmpty()) {
				macro_case_order = "m" + macro_order.toString() + "_" + case_order;
				case_data.put("Order", macro_case_order);
				merge_macro_data.put(macro_case_order, case_data);
				continue;
			}
			Boolean match_one = new Boolean(false);
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
					update_data = update_case_data(case_data, one_macro);
					update_data.put("Order", loop_macro_case_order);
					merge_macro_data.put(loop_macro_case_order, update_data);
				}
			}
			if (!match_one) {
				macro_order = 0;
				macro_case_order = "m" + macro_order.toString() + "_" + case_order;
				case_data.put("Order", macro_case_order);
				merge_macro_data.put(macro_case_order, case_data);
			}
		}
		return merge_macro_data;
	}

	private Boolean case_data_match_task_sort(
			Map<String, String> case_data, 
			String task_sort){
		Boolean case_match = new Boolean(true);
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
		for (String section : sort_str.split(";")){
			String option = new String("");
			String value = new String("");
			option = section.split("=")[0].trim().toLowerCase();
			value = section.split("=")[1].trim().toLowerCase();
			return_data.put(option, value);
		}
		return return_data;
	}
	
	private Boolean case_macro_check(Map<String, String> raw_data, List<List<String>> macro_data) {
		List<List<String>> one_macro_data = new ArrayList<List<String>>(); 
		one_macro_data.addAll(macro_data);
		// condition check
		Boolean condition = true;
		for (List<String> line : one_macro_data) {
			if (line.size() < 3) {
				LOCAL_TUBE_LOGGER.warn(">>>Warning: skip macro line:" + line.toString());
				continue;
			}
			String behavior = line.get(0).trim();
			String column = line.get(1).trim();
			String value = line.get(2).trim().replaceAll("=", "");
			if (!behavior.equals("condition")) {
				continue;
			}
			String raw_value = raw_data.get(column);
			if (!raw_value.equals(value)) {
				condition = false;
				break;
			}
		}
		return condition;
	}

	private Map<String, String> update_case_data(Map<String, String> case_data, List<List<String>> macro_data) {
		Map<String, String> return_data = new HashMap<String, String>();
		Map<String, String> raw_data = new HashMap<String, String>();
		raw_data.putAll(case_data);
		List<List<String>> one_macro_data = macro_data;
		List<String> column_list = new ArrayList<String>();
		column_list.add("CaseInfo");
		column_list.add("Environment");
		column_list.add("LaunchCommand");
		column_list.add("Software");
		column_list.add("System");
		column_list.add("Machine");
		// update case data
		for (List<String> line : one_macro_data) {
			if (line.size() < 3) {
				LOCAL_TUBE_LOGGER.warn(">>>Warning: skip macro line:" + line.toString());
				continue;
			}
			String behavior = line.get(0).trim();
			String column = line.get(1).trim();
			String value = line.get(2).trim();
			if (!behavior.equals("action")) {
				continue;
			}
			String ori_value = raw_data.get(column).trim();
			String out_value = new String();
			// update ori_value now
			// case have higher priority for: CaseInfo Environment LaunchCommand
			// Software System Machine
			if (column_list.contains(column)) {
				Boolean update_done = new Boolean(false);
				if (!value.contains("=")) {
					LOCAL_TUBE_LOGGER.warn(
							">>>Warning: Skip macro action non key=value input for columns" + column_list.toString());
					continue;
				}
				String[] ori_value_list = ori_value.split(";");
				List<String> final_value_list = new ArrayList<String>();
				for (String item : ori_value_list) {
					if (item.contains("=")) {
						//// new value in macro
						String new_option = value.split("=", 2)[0].trim();
						String new_value = value.split("=", 2)[1].trim();
						// ori value in case
						String item_option = item.split("=", 2)[0].trim();
						String item_value = item.split("=", 2)[1].trim();
						if (item_option.equals(new_option)) {
							if (item_option.equals("cmd")) {
								item_value = item_value + " " + new_value;
								final_value_list.add(item_option + "=" + item_value);
								update_done = true;
							} else {
								final_value_list.add(item);
								update_done = true;
							}
						} else {
							final_value_list.add(item);
						}
					} else {
						final_value_list.add(item);
					}
				}
				if (!update_done) {
					final_value_list.add(value);
				}
				String final_value = String.join(";", final_value_list).trim();
				out_value = final_value.replaceAll("^;", "");
			} else {
				out_value = value;
			}
			raw_data.put(column, out_value);
		}
		return_data.putAll(raw_data);
		return return_data;
	}
	
	private Map<String, HashMap<String, HashMap<String, String>>> get_merge_suite_case_data(
			Map<String, String> suite_data, 
			Map<String, Map<String, String>> case_data,
			String extra_env,
			String xlsx_dest) {
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
		if (project_id.equals("") || project_id == null) {
			id_map.put("project", "0");
		} else {
			id_map.put("project", project_id);
		}
		if (suite_id.equals("") || suite_id == null) {
			id_map.put("suite", "suite000");
			id_map.put("run", "run000");
		} else {
			id_map.put("suite", suite_id);
			id_map.put("run", suite_id);
		}
		if (case_id.equals("") || case_id == null) {
			id_map.put("id", "case");
		} else {
			id_map.put("id", case_id);
		}
		merge_data.put("ID", id_map);
		// insert CaseInfo data
		String suite_info = suite_data.get("CaseInfo").trim();
		String case_info = case_data.get("CaseInfo").trim();
		String design_info = case_data.get("design_name").trim();
		HashMap<String, String> case_map = comm_suite_case_merge(suite_info, case_info);
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
				env_list.addAll(Arrays.asList(extra_env.split(",")));
			} else if (extra_env.contains(";")){
				env_list.addAll(Arrays.asList(extra_env.split(";")));
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
		environ_map.putAll(comm_suite_case_merge(suite_environ, case_environ));
		environ_map.putAll(extra_map);//user import environ have higher priority
		merge_data.put("Environment", environ_map);
		// insert LaunchCommand data
		String suite_cmd = suite_data.get("LaunchCommand").trim();
		String case_cmd = case_data.get("LaunchCommand").trim();
		HashMap<String, String> cmd_map = comm_suite_case_merge(suite_cmd, case_cmd);
		merge_data.put("LaunchCommand", cmd_map);
		// insert Software data
		String suite_software = suite_data.get("Software").trim();
		String case_software = case_data.get("Software").trim();
		HashMap<String, String> software_map = comm_suite_case_merge(suite_software, case_software);
		merge_data.put("Software", software_map);
		// insert System data
		String suite_system = suite_data.get("System").trim();
		String case_system = case_data.get("System").trim();
		HashMap<String, String> system_map = comm_suite_case_merge(suite_system, case_system);
		merge_data.put("System", system_map);
		// insert Machine data
		String suite_machine = suite_data.get("Machine").trim();
		String case_machine = case_data.get("Machine").trim();
		HashMap<String, String> machine_map = comm_suite_case_merge(suite_machine, case_machine);
		merge_data.put("Machine", machine_map);
		// insert ClientPreference data
        String suite_client_preference = "";
        String case_client_preference = "";
        if(suite_data.containsKey("ClientPreference")){
            suite_client_preference = suite_data.get("ClientPreference").trim();
        }
        HashMap<String, String> client_preference = comm_suite_case_merge(suite_client_preference, case_client_preference);
        merge_data.put("ClientPreference", client_preference);
		return merge_data;
	}

	private HashMap<String, String> comm_suite_case_merge(String suite_info, String case_info) {
		String globle_str = suite_info.replaceAll("^;", "");
		String local_str = case_info.replaceAll("^;", "");
		String[] globle_array = globle_str.split(";");
		String[] local_array = local_str.split(";");
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
		merged_data = comm_admin_task_merge(globle_data, local_data);
		return merged_data;
	}

	public static HashMap<String, String> comm_admin_task_merge(HashMap<String, String> globle_data,
			HashMap<String, String> local_data) {
		Set<String> local_set = local_data.keySet();
		Iterator<String> local_it = local_set.iterator();
		while (local_it.hasNext()) {
			String local_key = local_it.next();
			String local_value = local_data.get(local_key);
			if (local_key.equals("cmd") && !local_value.equals("")) {
				if (local_data.containsKey("override") && local_data.get("override").equals("local")) {
					globle_data.put("cmd", local_value);
				} else if (local_data.containsKey("override") && local_data.get("override").equals("globle")) {
					continue;
				} else if (globle_data.containsKey("override") && globle_data.get("override").equals("local")) {
					globle_data.put("cmd", local_value);
				} else if (globle_data.containsKey("override") && globle_data.get("override").equals("globle")) {
					continue;
				} else {
					String local_cmd = local_data.get("cmd");
					String globle_cmd = globle_data.get("cmd");
					String overall_cmd = globle_cmd + " " + local_cmd;
					globle_data.put("cmd", overall_cmd);
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

	private Boolean is_request_match(HashMap<String, HashMap<String, String>> queue_data,
			HashMap<String, HashMap<String, String>> design_data) {
		// compare sub map data Software, System, Machine
		Boolean is_match = new Boolean(true);
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
		// generate queue name
		String queue_name = new String();
		// admin queue priority check:0>1>2..>5(default)>...8>9
		String priority;
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
			}
		}
		// task belong to this client: 0, assign task(0) > match task(1)
		String attribute = new String();
		String request_terminal = new String();
		String available_terminal = current_terminal.toLowerCase();
		if (!design_data.containsKey("Machine")) {
			attribute = "1";
		} else if (!design_data.get("Machine").containsKey("terminal")) {
			attribute = "1";
		} else {
			request_terminal = design_data.get("Machine").get("terminal").toLowerCase();
			if (request_terminal.contains(available_terminal)) {
				attribute = "0"; // assign task
			} else {
				attribute = "1"; // match task
			}
		}
		// receive time
		String mark_time = time_info.get_time_hhmm();
		// pack data
		// xx0@run_xxx_suite_time :
		// priority:match/assign task:job_from_local@run_number
		queue_name = priority + attribute + "0" + "@" 
				+ "run_" + mark_time + "_" + sub_task_number + "_" + admin_queue_base + "_" + create_time;
		return queue_name;
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
			String local_file,
			String extra_env,
			String task_sort,
			String current_terminal) {
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
		Map<String, String> suite_sheet_data = get_suite_data(ExcelData);
		Map<String, Map<String, String>> case_sheet_data = get_merge_macro_case_data(ExcelData, task_sort);
		Map<String, HashMap<String, HashMap<String, String>>> merge_data = get_merge_suite_case_data(suite_sheet_data, case_sheet_data, extra_env, xlsx_dest);
		if (merge_data == null){
			LOCAL_TUBE_LOGGER.warn("Suite file no case found:" + local_file);
			return;
		}
		//base queue name generate
		String admin_queue_base = new String();
		if (suite_sheet_data.containsKey("suite_name")) {
			admin_queue_base = suite_sheet_data.get("suite_name");
		} else {
			admin_queue_base = xlsx_fobj.getName().split("\\.")[0];
		}
		Iterator<String> case_it = merge_data.keySet().iterator();
		while (case_it.hasNext()) {
			// check current admin queue cover this requirements
			String case_name = case_it.next();
			HashMap<String, HashMap<String, String>> case_data = new HashMap<String, HashMap<String, String>>();
			case_data.putAll(merge_data.get(case_name));
			Boolean admin_queue_exists = new Boolean(false);
			String queue_name = new String();
			Iterator<String> queues_it = xlsx_received_admin_queues_treemap.keySet().iterator();
			while (queues_it.hasNext()) {
				queue_name = queues_it.next();
				HashMap<String, HashMap<String, String>> admin_queue_data = xlsx_received_admin_queues_treemap
						.get(queue_name);
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
				String detail_time = time_info.get_date_time();//time for create queue
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

	//===========================================================================
	//===========================================================================
	//for suite path support
	public static Boolean suite_paths_sanity_check(String suite_paths, String suite_key) {
		for (String suite_path : suite_paths.split(",")){
			File xlsx_fobj = new File(suite_path);
			if(!xlsx_fobj.exists()){
				suite_path_error_msg = "Error: Suite path not exists.";
				System.out.println(">>>Error: Suite path not exists.");
				return false;
			}
			if(file_action.get_key_file_list(suite_path, suite_key).size() < 1){
				suite_path_error_msg = "Error: Suite path no key file found.";
				System.out.println(">>>Error: Suite path no key file found.");
				return false;			
			}
		}
		return true;
	}
	
	public void generate_suite_path_local_admin_task_queues(
			String imported_path,
			HashMap<String, String> imported_data){
		//step 0: start time
		String generate_time = time_info.get_date_time();
		//step 1: generate queue_name
		String queue_name = get_queue_name(imported_path, imported_data, generate_time);
		//step 2: generate admin_data
		HashMap<String, HashMap<String, String>> admin_queue_data = new HashMap<String, HashMap<String, String>>();
		admin_queue_data.putAll(get_admin_queue_data(imported_path, imported_data, generate_time));
		//step 1: generate task_data
		TreeMap<String, HashMap<String, HashMap<String, String>>> task_queue_data =  new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		task_queue_data.putAll(get_task_queue_data(imported_path, imported_data, admin_queue_data));
		task_info.update_queue_to_received_admin_queues_treemap(queue_name, admin_queue_data);
		task_info.update_queue_to_received_task_queues_map(queue_name, task_queue_data);
	}
	
	private String get_queue_name(
			String imported_path,
			HashMap<String, String> imported_data,
			String generate_time) {
		// generate queue name
		String queue_name = new String();
		// admin queue priority check:0>1>2..>5(default)>...8>9
		String priority = public_data.TASK_PRI_LOCALLY;
		// task belong to this client: 0, assign task(0) > match task(1)
		String attribute = new String("0");
		// receive time
		String mark_time = time_info.get_time_hhmm();
		// queue base name
		String admin_queue_base = new String("");
		File path_obj = new File(imported_path);
		String suite_name = path_obj.getName();
		if (suite_name.length() < 1){
			admin_queue_base = "local_suite";
		} else {
			admin_queue_base = suite_name;
		}
		// pack data
		// xx0@run_xxx_suite_time :
		// priority:match/assign task:job_from_local@run_number
		queue_name = priority + attribute + "0" + "@" 
				+ "run_" + mark_time + "_" + admin_queue_base + "_" + generate_time;
		return queue_name;
	}
	
	private HashMap<String, HashMap<String, String>> get_admin_queue_data(
			String import_path,
			HashMap<String, String> imported_data,
			String generate_time){
		HashMap<String, HashMap<String, String>> admin_queue_data = new HashMap<String, HashMap<String, String>>();
		//id_data create
		HashMap<String, String> id_data = new HashMap<String, String>();
		String suite_path = import_path;
		File path_obj = new File(suite_path);
		String suite_name = path_obj.getName();
		if (suite_name.length() < 1){
			suite_name = "local_suite";	
		}
		id_data.put("project", "x");
		id_data.put("run", suite_name + "_" + generate_time);
		id_data.put("suite", suite_name);
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
		if (!exe_frh.exists() && !exe_file.contains("$work_path") && !exe_file.contains("$tool_path")){
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
				env_list.addAll(Arrays.asList(extra_env.split(",")));
			} else if (extra_env.contains(";")){
				env_list.addAll(Arrays.asList(extra_env.split(";")));
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
	
	private List<String> get_design_name_list(String suite_path, String key_file){
		List<String> design_list = new ArrayList<String>();
		List<String> key_paths = new ArrayList<String>();
		key_paths.addAll(file_action.get_key_path_list(suite_path, key_file));
		for (String key_path:key_paths){
			key_path = key_path.replaceAll(suite_path, "");
			key_path = key_path.replaceAll("^/", "");
			design_list.add(key_path);
		}
		return design_list;
	}
	
	private Boolean case_match_required_info(
			String suite_path,
			String case_path,
			String dat_file,
			String task_sort){
		Boolean match_status = new Boolean(false);
		if (task_sort == null || task_sort.trim().equals("")){
			match_status = true;
			return match_status;
		}
		String dat_path = new String(suite_path + "/" + case_path + "/" +  dat_file);
		File dat_fobj = new File(dat_path);
		if (!dat_fobj.exists()){
			return match_status;
		}
		Map<String, Object> src_data_object = new HashMap<String, Object>();
		src_data_object.putAll(file_action.get_json_map_data(dat_path));
		if (src_data_object.isEmpty()){
			return match_status;
		}
		Map<String, String> src_data = new HashMap<String, String>();
		Iterator<String> src_it = src_data_object.keySet().iterator();
		while(src_it.hasNext()){
			String src_key = src_it.next();
			Object src_obj = src_data_object.get(src_key);
			src_data.put(src_key, src_obj.toString());
		}
		if (case_data_match_task_sort(src_data, task_sort)){
			match_status = true;
		} else {
			match_status = false;
		}
		return match_status;
	}
	
	private TreeMap<String, HashMap<String, HashMap<String, String>>> get_task_queue_data(
			String imported_path,
			HashMap<String, String> imported_data,
			HashMap<String, HashMap<String, String>> admin_data){
		TreeMap<String, HashMap<String, HashMap<String, String>>> task_queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		//get case list
		String suite_path = imported_path;
		String key_file = imported_data.get("key");
		String dat_file = imported_data.get("dat");
		String task_sort = imported_data.get("sort");
		String list_path = suite_path + "/" + public_data.SUITE_LIST_FILE_NAME;
		File list_fobj = new File(list_path);
		List<String> case_list = new ArrayList<String>();
		if (list_fobj.exists()){
			List<String> line_list = new ArrayList<String>();
			line_list.addAll(file_action.read_file_lines(list_path));
			for (String line : line_list){
				if(line.startsWith(";")){
					continue;
				}
				if(line.startsWith("#")){
					continue;
				}
				File path_obj = new File(suite_path + "/" + line);
				if(path_obj.exists()){
					case_list.add(line.replaceAll("\\\\", "/"));
				}
			}
		} else {
			case_list.addAll(get_design_name_list(suite_path, key_file));
		}
		//sort required test case list
		if(case_list.size() < 1){
			return task_queue_data;
		}
		List<String> matched_case_list = new ArrayList<String>();
		for(String case_path: case_list){
			if(case_match_required_info(suite_path, case_path, dat_file, task_sort)){
				matched_case_list.add(case_path);
			}
		}
		//generate case data
		int case_counter = 0;
		for(String case_path: matched_case_list){
			HashMap<String, HashMap<String, String>> case_data = new HashMap<String, HashMap<String, String>>();
			case_data.putAll(deep_clone.clone(admin_data));
			//generate case name
			String case_name = String.valueOf(case_counter);
			//generate TestID
			HashMap<String, String> id_data = new HashMap<String, String>();
			id_data.put("id", case_name);
			if(case_data.containsKey("TestID")){
				HashMap<String, String> link_data = case_data.get("TestID");
				link_data.putAll(id_data);
			} else {
				case_data.put("TestID", id_data);
			}
			//generate CaseInfo
			HashMap<String, String> info_data = new HashMap<String, String>();
			info_data.put("design_name", case_path);
			if(case_data.containsKey("CaseInfo")){
				HashMap<String, String> link_data = case_data.get("CaseInfo");
				link_data.putAll(info_data);
			} else {
				case_data.put("CaseInfo", info_data);
			}			
			//Status
			HashMap<String, String> status_data = new HashMap<String, String>();
			status_data.put("cmd_status", task_enum.WAITING.get_description());
			if(case_data.containsKey("Status")){
				HashMap<String, String> link_data = case_data.get("Status");
				link_data.putAll(status_data);
			} else {
				case_data.put("Status", status_data);
			}			
			//return
			task_queue_data.put(case_name, case_data);
			case_counter++;
		}
		return task_queue_data;
	}
	
	//===========================================================================
	//===========================================================================
	//main	
	public static void main(String[] argv) {
		task_data task_info = new task_data();
		local_tube sheet_parser = new local_tube(task_info);
		String current_terminal = "SHITL0012";
		sheet_parser.generate_suite_file_local_admin_task_queues("C:/Users/jwang1/Desktop/test/radiant_suite/radiant_regression.xlsx", "", "", current_terminal);
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