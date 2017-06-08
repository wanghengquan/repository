package connect_tube;

import java.util.Comparator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class taskid_compare implements Comparator<String> {
	@Override
	public int compare(String task_name1, String task_name2) {
		// case from local: mx_xx_flow
		int int_macro1 = 0, int_macro2 = 0;
		int int_id1 = 0, int_id2 = 0;
		Pattern p = Pattern.compile("^m(\\d+)_");
		Matcher m1 = p.matcher(task_name1);
		Matcher m2 = p.matcher(task_name1);
		if(m1.find() && m2.find()){
			int_macro1 = get_srting_int(task_name1, "^m(\\d+)_");
			int_macro2 = get_srting_int(task_name2, "^m(\\d+)_");
			int_id1 = get_srting_int(task_name1, "_(\\d+)_");
			int_id2 = get_srting_int(task_name2, "_(\\d+)_");
		} else {
			//case from remote Txxxxx
			return task_name1.compareTo(task_name2);
		}
		if (int_macro1 > int_macro2) {
			return 1;
		} else if (int_macro1 < int_macro2) {
			return -1;
		} else {
			if (int_id1 > int_id2) {
				return 1;
			} else if (int_id1 < int_id2) {
				return -1;
			} else {
				return task_name1.compareTo(task_name2);
			}
		}
	}

	private static int get_srting_int(String str, String patt) {
		int i = 0;
		try {
			Pattern p = Pattern.compile(patt);
			Matcher m = p.matcher(str);
			if (m.find()) {
				i = Integer.valueOf(m.group(1));
			}
		} catch (NumberFormatException e) {
			//e.printStackTrace();
			System.out.println(">>>INFO: Get string pattern failed.");
		}
		return i;
	}
}
