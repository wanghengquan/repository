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

import info_parser.xls_parser;
import utility_funcs.time_info;

/*
 * This class used to instance rabbitMQ tube between server and center processor.
 * 1: Memory 
 */
public class local_tube {
	// public property
	// protected property
	// private property
	private final Logger LOCAL_LOGGER = LogManager.getLogger(local_tube.class.getName());
	private task_data task_info;
	// public function
	public local_tube(task_data task_info) {
		this.task_info = task_info;
	}

	// protected function
	// private function
	private Map<String, List<List<String>>> get_excel_data(String excel_file) {
		Map<String, List<List<String>>> ExcelData = new HashMap<String, List<List<String>>>();
		xls_parser excel_obj = new xls_parser();
		ExcelData = excel_obj.GetExcelData(excel_file);
		return ExcelData;
	}

	public Boolean sanity_check(Map<String, List<List<String>>> ExcelData) {
		if (!ExcelData.containsKey("suite")) {
			LOCAL_LOGGER.error(">>>Error: Cannot find 'suite' sheet ");
			return false;
		}
		if (!ExcelData.containsKey("case")) {
			LOCAL_LOGGER.error(">>>Error: Cannot find 'case' sheet ");
			return false;
		}
		// suite info check
		Map<String, String> suite_map = get_suite_data(ExcelData);
		if (suite_map.size() > 8) {
			LOCAL_LOGGER.error(">>>Error: extra option found in suite sheet::suite info.");
			System.out.println(suite_map.keySet().toString());
			return false;
		}
		String[] suite_keys = { "project_id", "suite_name", "CaseInfo", "Environment", "LaunchCommand", "Software",
				"System", "Machine" };
		for (String x : suite_keys) {
			if (!suite_map.containsKey(x)) {
				LOCAL_LOGGER.error(">>>Error: suite sheet missing :" + x);
				return false;
			}
		}
		String prj_id = suite_map.get("project_id");
		try {
			@SuppressWarnings("unused")
			int id = Integer.parseInt(prj_id);
		} catch (NumberFormatException id_e) {
			LOCAL_LOGGER.error(">>>Error: project_id value wrong, should be a number.");
			return false;
		}
		String suite_name = suite_map.get("suite_name");
		if (suite_name == null || suite_name == "") {
			LOCAL_LOGGER.error(">>>Error: suite name missing.");
			return false;
		}
		// case sheet title check
		List<String> case_title = get_case_title(ExcelData);
		if (case_title == null) {
			LOCAL_LOGGER.error(">>>Error: Cannot find title line in case sheet.");
			return false;
		}
		String[] must_keys = { "Order", "Title", "Section", "design_name", "TestLevel", "TestScenarios", "Description",
				"Type", "Priority", "CaseInfo", "Environment", "Software", "System", "Machine", "NoUse" };
		for (String x : must_keys) {
			if (!case_title.contains(x)) {
				LOCAL_LOGGER.error(">>>Error: case sheet title missing :" + x);
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
						LOCAL_LOGGER.error(">>>Error: wrong macro key found in suite sheet:" + item);
						return false;
					}
					if (!case_title.contains(column)) {
						LOCAL_LOGGER.error(">>>Error: suite sheet cannot find macro column in case sheet:" + column);
						return false;
					}
				}
			}
		}
		return true;
	}

	private Map<String, String> get_suite_data(Map<String, List<List<String>>> ExcelData) {
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
				value = row_list.get(1).trim();
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

	private Map<String, List<List<String>>> get_macro_data(Map<String, List<List<String>>> ExcelData) {
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
				continue;
			}
			String item = row_list.get(0).trim();
			if (item.contains(macro_start)) {
				macro_area = true;
				macro_num += 1;
				macro_name = "macro" + String.valueOf(macro_num);
				area_list = new ArrayList<List<String>>();
			}
			if (macro_area) {
				if (item.equals("") || item.equals("END") || item == null) {
					macro_area = false;
					macro_data.put(macro_name, area_list);
				}
			}
			if (item.equals("END")) {
				break;
			}
			if (macro_area) {
				if (item.equals(macro_start)) {
					continue;
				} else {
					area_list.add(row_list);
				}
			}
		}
		return_data = sort_macro_map(macro_data);
		return return_data;
	}

	public Map<String, List<List<String>>> sort_macro_map(Map<String, List<List<String>>> oriMap) {
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

	private List<String> get_case_title(Map<String, List<List<String>>> ExcelData) {
		List<List<String>> case_sheet = ExcelData.get("case");
		List<String> title_list = new ArrayList<String>();
		// title_list = suite_sheet.get(1);
		int title_row = -1;
		for (int row = 0; row < case_sheet.size(); row++) {
			List<String> row_list = case_sheet.get(row);
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
		title_list = case_sheet.get(title_row);
		return title_list;
	}

	private Map<String, Map<String, String>> get_raw_case_data(Map<String, List<List<String>>> ExcelData) {
		Map<String, Map<String, String>> case_data = new HashMap<String, Map<String, String>>();
		List<String> title_list = get_case_title(ExcelData);
		int order_index = title_list.indexOf("Order");
		int title_index = title_list.indexOf("Title");
		int flow_index = title_list.indexOf("Flow");
		List<List<String>> case_sheet = ExcelData.get("case");
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
			String column_order = "";
			String column_title = "";
			String column_flow = "";
			if (row_list.size() > order_index) {
				column_order = row_list.get(order_index).trim();
			}
			if (row_list.size() > title_index) {
				column_title = row_list.get(title_index).trim();
			}
			if (row_list.size() > flow_index) {
				column_flow = row_list.get(flow_index).trim();
			}
			if (column_order.equals("Order") && column_title.equals("Title")) {
				case_start = true;
				continue;
			}
			if (!case_start) {
				continue;
			}
			String case_order = "";
			String[] flow_array = column_flow.split(";");
			for (String flow_item : flow_array) {
				Map<String, String> row_data = new HashMap<String, String>();
				case_order = String.join("_", column_order, flow_item);
				for (String key : title_list) {
					int key_index = title_list.indexOf(key);
					String column_value = "";
					if (row_list.size() > key_index) {
						column_value = row_list.get(key_index).trim();
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
		return case_data;
	}

	private Map<String, Map<String, String>> get_merge_macro_case_data(Map<String, List<List<String>>> ExcelData) {
		Map<String, Map<String, String>> merge_macro_data = new HashMap<String, Map<String, String>>();
		// start
		Map<String, List<List<String>>> macro_data = get_macro_data(ExcelData);
		Map<String, Map<String, String>> raw_data = get_raw_case_data(ExcelData);
		if (raw_data == null || raw_data.size() < 1) {
			LOCAL_LOGGER.warn(">>>Warning: No test case found in suite file.");
			return merge_macro_data;
		}
		Set<String> data_set = raw_data.keySet();
		Iterator<String> data_it = data_set.iterator();
		while (data_it.hasNext()) {
			String case_order = data_it.next().trim();
			Integer macro_order = new Integer(0);
			String macro_case_order = new String();
			Map<String, String> case_data = raw_data.get(case_order);
			if (case_data.get("NoUse").equalsIgnoreCase("yes")) {
				continue;
			}
			if (macro_data == null) {
				macro_case_order = "m" + macro_order.toString() + "_" + case_order;
				case_data.put("Order", macro_case_order);
				merge_macro_data.put(macro_case_order, case_data);
				continue;
			}
			Boolean match_one = new Boolean(false);
			Set<String> macro_set = macro_data.keySet();
			Iterator<String> macro_it = macro_set.iterator();
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

	private Boolean case_macro_check(Map<String, String> raw_data, List<List<String>> macro_data) {
		List<List<String>> one_macro_data = macro_data;
		// condition check
		Boolean condition = true;
		for (List<String> line : one_macro_data) {
			if (line.size() < 3) {
				LOCAL_LOGGER.warn(">>>Warning: skip macro line:" + line.toString());
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

	private Map<String, String> update_case_data(Map<String, String> raw_data, List<List<String>> macro_data) {
		Map<String, String> return_data = new HashMap<String, String>();
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
				LOCAL_LOGGER.warn(">>>Warning: skip macro line:" + line.toString());
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
					LOCAL_LOGGER.warn(
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
			Map<String, String> suite_data, Map<String, Map<String, String>> case_data) {
		Map<String, HashMap<String, HashMap<String, String>>> cross_data = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		Map<String, HashMap<String, HashMap<String, String>>> sorted_data = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		Set<String> case_set = case_data.keySet();
		Iterator<String> case_iterator = case_set.iterator();
		while (case_iterator.hasNext()) {
			String case_id = case_iterator.next();
			Map<String, String> one_case_data = case_data.get(case_id);
			HashMap<String, HashMap<String, String>> merge_data = merge_suite_case_data(suite_data, one_case_data);
			cross_data.put(case_id, merge_data);
		}
		sorted_data = sortMapByKey(cross_data);
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

	private int getInt(String str, String patt) {
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
	// case data.
	public HashMap<String, HashMap<String, String>> merge_suite_case_data(Map<String, String> suite_data,
			Map<String, String> case_data) {
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
		merge_data.put("CaseInfo", case_map);
		// insert Environment data
		String suite_environ = suite_data.get("Environment").trim();
		String case_environ = case_data.get("Environment").trim();
		HashMap<String, String> environ_map = comm_suite_case_merge(suite_environ, case_environ);
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

	public static HashMap<String, String> comm_admin_task_merge(
			HashMap<String, String> globle_data,
			HashMap<String, String> local_data) {
		Set<String> local_set = local_data.keySet();
		Iterator<String> local_it = local_set.iterator();
		while (local_it.hasNext()) {
			String local_key = local_it.next();
			String local_value = local_data.get(local_key);
			if (local_key.equals("cmd") && !local_value.equals("")) {
				if (local_data.containsKey("override") && local_data.get("override").equals("local")){
					globle_data.put("cmd", local_value);
				} else if (local_data.containsKey("override") && local_data.get("override").equals("globle")){
					continue;
				} else if (globle_data.containsKey("override") && globle_data.get("override").equals("local")) {
					globle_data.put("cmd", local_value);
				} else if (globle_data.containsKey("override") && globle_data.get("override").equals("globle")){
					continue;
				} else {
					String local_cmd = local_data.get("cmd");
					String globle_cmd = globle_data.get("cmd");
					String overall_cmd = globle_cmd + " " + local_cmd;
					globle_data.put("cmd", overall_cmd);
				}
			} else {
				//non command key 1)globle have value, local must have value then overwrite
				if (globle_data.containsKey(local_key)){
					if (!local_value.equals("")){
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
			String queue_pre_fix,
			String current_terminal,
			HashMap<String, HashMap<String, String>> design_data) {
		// generate queue name
		String queue_name = new String();
		// admin queue priority check:0>1>2..>5(default)>...8>9
		String priority = new String();
		if (!design_data.containsKey("CaseInfo")) {
			priority = "5";
		} else if (!design_data.get("CaseInfo").containsKey("priority")) {
			priority = "5";
		} else {
			priority = design_data.get("CaseInfo").get("priority");
			Pattern p = Pattern.compile("^\\d$");
			Matcher m = p.matcher(priority);
			if (!m.find()) {
				priority = "5";
			}
		}
		// task belong to this client: 0, assign task > 1, match task
		String attribute = new String();
		String request_terminal = new String();
		String available_terminal = current_terminal;
		if (!design_data.containsKey("Machine")) {
			attribute = "1";
		} else if (!design_data.get("Machine").containsKey("terminal")) {
			attribute = "1";
		} else {
			request_terminal = design_data.get("Machine").get("terminal");
			if (request_terminal.contains(available_terminal)) {
				attribute = "0"; // assign task
			} else {
				attribute = "1"; // match task
			}
		}
		// receive time
		String time = time_info.get_date_time();
		// pack data
		// xx0@runxxx_suite_time :
		// priority:match/assign task:job_from_local@run_number
		// generate queue data
		queue_name = priority + attribute + "0" + "@" + "run_" + queue_pre_fix + "_" + admin_queue_base + "_" + time;
		return queue_name;
	}

	/*
	 * {queue_name: {ID : {prj : name,suite: name}, System: {os : name}}}
	 */
	@SuppressWarnings("unused")
	private TreeMap<String, HashMap<String, HashMap<String, String>>> get_one_queue_hash(
			String admin_queue_base,
			String queue_pre_fix, 
			String current_terminal,
			HashMap<String, HashMap<String, String>> design_data) {
		TreeMap<String, HashMap<String, HashMap<String, String>>> one_queue_hash = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		// generate queue name
		String queue_name = new String();
		HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
		queue_name = get_one_queue_name(admin_queue_base, queue_pre_fix, current_terminal, design_data);
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
	public void generate_local_admin_task_queues(String local_file, String current_terminal) {
		Map<String, List<List<String>>> ExcelData = new HashMap<String, List<List<String>>>();
		ExcelData.putAll(get_excel_data(local_file));
		Map<String, String> suite_data = get_suite_data(ExcelData);
		Map<String, Map<String, String>> case_data = get_merge_macro_case_data(ExcelData);
		Map<String, HashMap<String, HashMap<String, String>>> merge_data = get_merge_suite_case_data(suite_data,
				case_data);
		//TreeMap<String, HashMap<String, HashMap<String, String>>> current_admin_queue_treemap = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		//current_admin_queue_treemap.putAll(task_info.get_received_admin_queues_treemap());
		String admin_queue_base = new String();
		if (suite_data.containsKey("suite_name")) {
			admin_queue_base = suite_data.get("suite_name");
		} else {
			File xls_file = new File(local_file);
			admin_queue_base = xls_file.getName().split("\\.")[0];
		}
		Iterator<String> case_it = merge_data.keySet().iterator();
		while (case_it.hasNext()) {
			String case_name = case_it.next();
			TreeMap<String, HashMap<String, HashMap<String, String>>> current_received_admin_queues_treemap = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
			current_received_admin_queues_treemap.putAll(task_info.get_received_admin_queues_treemap());
			HashMap<String, HashMap<String, String>> design_data = new HashMap<String, HashMap<String, String>>();
			design_data.putAll(merge_data.get(case_name));
			// check current admin queue cover this requirements
			Boolean is_admin_queue_exists = new Boolean(false);
			String admin_queue_name = new String();
			Iterator<String> admin_queues_it = current_received_admin_queues_treemap.keySet().iterator();
			while (admin_queues_it.hasNext()) {
				admin_queue_name = admin_queues_it.next();
				HashMap<String, HashMap<String, String>> current_admin_queue_data = current_received_admin_queues_treemap.get(admin_queue_name);
				if (is_request_match(current_admin_queue_data, design_data)) {
					is_admin_queue_exists = true;
					break;
				}
			}
			// if admin queue note exists, create one
			// xxx@runxxx_suite_time
			if (!is_admin_queue_exists) {
				//get admin queue name
				//make the new admin queue name use total received admin queues number + 1
				String queue_pre_fix = String.valueOf(current_received_admin_queues_treemap.keySet().size() + 1);
				admin_queue_name = get_one_queue_name(admin_queue_base, queue_pre_fix, current_terminal, design_data);
				//get admin queue data
				HashMap<String, HashMap<String, String>> admin_queue_data = new HashMap<String, HashMap<String, String>>();
				admin_queue_data.putAll(design_data);
				HashMap<String, String> status_data = new HashMap<String, String>();
				status_data.put("admin_status", "processing");
				admin_queue_data.put("Status", status_data);
				task_info.add_queue_data_to_received_admin_queues_treemap(admin_queue_name, admin_queue_data);
			}
			// insert design into received task queue : admin_queue_name
			Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> received_task_queues_map = task_info.get_received_task_queues_map();
			TreeMap<String, HashMap<String, HashMap<String, String>>> task_queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
			if (received_task_queues_map.containsKey(admin_queue_name)) {
				task_queue_data.putAll(received_task_queues_map.get(admin_queue_name));
			}
			task_queue_data.put(case_name, design_data);
			task_info.update_received_task_queues_map(admin_queue_name, task_queue_data);
		}
	}

	public static void main(String[] argv) {
		task_data task_info = new task_data();
		local_tube sheet_parser = new local_tube(task_info);
		String current_terminal = "D27639";
		sheet_parser.generate_local_admin_task_queues("D:/java_dev/diamond_regression.xlsx", current_terminal);
		System.out.println(task_info.get_received_task_queues_map().toString());
		System.out.println(task_info.get_received_admin_queues_treemap().toString());
	}
}