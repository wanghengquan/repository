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

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import info_parser.xls_parser;

/*
 * This class used to instance rabbitMQ tube between server and center processor.
 * 1: Memory 
 */
public class local_tube {
	// public property
	// protected property
	// private property
	private static final Logger LOCAL_LOGGER = LogManager.getLogger(local_tube.class.getName());
	private Map<String, List<List <String>>> ExcelData = new HashMap<String, List<List <String>>>();
	// public function
	public local_tube() {

	}

	public HashMap<String, HashMap<String, String>> get_admin_list(String local_file) {

	}

	public HashMap<String, HashMap<String, String>> get_task_list(String local_file) {

	}

	private void GetData(String excel_file) {
		xls_parser excel_obj = new xls_parser();
		ExcelData = excel_obj.GetExcelData(excel_file);
	}

	public Boolean SanityCheck() {
		if (!ExcelData.containsKey("suite")) {
			System.out.println(">>>Error: Cannot find 'suite' sheet ");
			return false;
		}
		if (!ExcelData.containsKey("case")) {
			System.out.println(">>>Error: Cannot find 'case' sheet ");
			return false;
		}
		// suite info check
		Map<String, String> suite_map = get_suite_data();
		if (suite_map.size() > 8) {
			System.out.println(">>>Error: extra option found in suite sheet::suite info.");
			System.out.println(suite_map.keySet().toString());
			return false;
		}
		String[] suite_keys = { "project_id", "suite_name", "CaseInfo", "Environment", "LaunchCommand", "Software",
				"System", "Machine" };
		for (String x : suite_keys) {
			if (!suite_map.containsKey(x)) {
				System.out.println(">>>Error: suite sheet missing :" + x);
				return false;
			}
		}
		String prj_id = suite_map.get("project_id");
		try {
			@SuppressWarnings("unused")
			int id = Integer.parseInt(prj_id);
		} catch (NumberFormatException id_e) {
			System.out.println(">>>Error: project_id value wrong, should be a number.");
			return false;
		}
		String suite_name = suite_map.get("suite_name");
		if (suite_name == null || suite_name == "") {
			System.out.println(">>>Error: suite name missing.");
			return false;
		}
		// case sheet title check
		List<String> case_title = get_case_title();
		if (case_title == null) {
			System.out.println(">>>Error: Cannot find title line in case sheet.");
			return false;
		}
		String[] must_keys = { "Order", "Title", "Section", "design_name", "TestLevel", "TestScenarios", "Description",
				"Type", "Priority", "CaseInfo", "Environment", "Software", "System", "Machine", "NoUse" };
		for (String x : must_keys) {
			if (!case_title.contains(x)) {
				System.out.println(">>>Error: case sheet title missing :" + x);
				return false;
			}
		}
		// macro info check
		Map<String, List<List<String>>> macro_data = get_macro_data();
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
						System.out.println(">>>Error: wrong macro key found in suite sheet:" + item);
						return false;
					}
					if (!case_title.contains(column)) {
						System.out.println(">>>Error: suite sheet cannot find macro column in case sheet:" + column);
						return false;
					}
				}
			}
		}
		return true;
	}

	public Map<String, String> get_suite_data() {
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
				suite_data.put(item, value);
			}
			pre_word = item;
			pre_value = value;
		}
		return suite_data;
	}

	private Map<String, List<List<String>>> get_macro_data() {
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

	private List<String> get_case_title() {
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
			//String column_b = row_list.get(1).trim();
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

	private Map<String, Map<String, String>> get_raw_case_data() {
		Map<String, Map<String, String>> case_data = new HashMap<String, Map<String, String>>();
		List<String> title_list = get_case_title();
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
						row_data.put(key, column_value);
					}
				}
				case_data.put(case_order, row_data);
			}
		}
		return case_data;
	}

	public Map<String, Map<String, String>> get_detail_case_data() {
		Map<String, Map<String, String>> final_data = new HashMap<String, Map<String, String>>();
		Map<String, Map<String, String>> sorted_data = new HashMap<String, Map<String, String>>();
		// start
		Map<String, List<List<String>>> macro_data = get_macro_data();
		Map<String, Map<String, String>> raw_data = get_raw_case_data();
		if (raw_data == null || raw_data.size() < 1) {
			System.out.println(">>>Warning: No test case found in suite file.");
			return sorted_data;
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
				final_data.put(macro_case_order, case_data);
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
					final_data.put(loop_macro_case_order, update_data);
				}
			}
			if (!match_one) {
				macro_order = 0;
				macro_case_order = "m" + macro_order.toString() + "_" + case_order;
				case_data.put("Order", macro_case_order);
				final_data.put(macro_case_order, case_data);
			}
		}
		sorted_data = sortMapByKey(final_data);
		return sorted_data;
	}

	public Map<String, Map<String, String>> sortMapByKey(Map<String, Map<String, String>> oriMap) {
		if (oriMap == null || oriMap.isEmpty()) {
			return null;
		}
		Map<String, Map<String, String>> sortedMap = new TreeMap<String, Map<String, String>>(new Comparator<String>() {
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

	private Boolean case_macro_check(Map<String, String> raw_data, List<List<String>> macro_data) {
		List<List<String>> one_macro_data = macro_data;
		// condition check
		Boolean condition = true;
		for (List<String> line : one_macro_data) {
			if (line.size() < 3) {
				System.out.println(">>>Warning: skip macro line:" + line.toString());
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
				System.out.println(">>>Warning: skip macro line:" + line.toString());
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
					System.out.println(
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

	public static void main(String[] argv) {
		local_tube sheet_parser = new local_tube();
		sheet_parser.GetData("suite_file/FE_15_Simulator.xlsx");
		sheet_parser.SanityCheck();
		sheet_parser.get_case_title();
		Map<String, Map<String, String>> final_data = sheet_parser.get_detail_case_data();
		if (final_data == null || final_data.size() < 1) {
			System.out.println(">>>Error: No test case found.");
			System.exit(1);
		}
		Set<String> keyset = final_data.keySet();
		Iterator<String> key_iterator = keyset.iterator();
		while (key_iterator.hasNext()) {
			System.out.println("####");
			String case_id = key_iterator.next();
			System.out.println(case_id);
			Map<String, String> case_data = final_data.get(case_id);
			System.out.println(case_data.toString());
			System.out.println("----");
		}
	}

}