package flow_control;

import java.util.Comparator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class cmdid_compare implements Comparator<String> {
	@Override
	public int compare(String cmd_name1, String cmd_name2) {
		// case from local: mx_xx_flow
		int int_id1 = 0, int_id2 = 0;
		Pattern p = Pattern.compile("_(\\d+)$");
		Matcher id1 = p.matcher(cmd_name1);
		Matcher id2 = p.matcher(cmd_name2);
		if(id1.find()) {
			int_id1 = get_srting_int(cmd_name1, "_(\\d+)$");
		}
		if(id2.find()) {
			int_id2 = get_srting_int(cmd_name2, "_(\\d+)$");
		}
		if (int_id1 > int_id2) {
			return 1;
		} else if (int_id1 < int_id2) {
			return -1;
		} else {
			return cmd_name1.compareTo(cmd_name2);
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
