package gui_interface;

import java.util.Comparator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class queue_compare implements Comparator<String> {
	@Override
	public int compare(String queue_name1, String queue_name2) {
		// priority:match/assign task:job_from@run_number
		int int_pri1 = 0, int_pri2 = 0;
		int int_date1 = 0, int_date2 = 0;
		int int_time1 = 0, int_time2 = 0;
		try {
			int_pri1 = get_srting_int(queue_name1, "^(\\d+)@");
			int_pri2 = get_srting_int(queue_name2, "^(\\d+)@");
			int_date1 = get_srting_int(queue_name1, "_(\\d+)_\\d+$");
			int_date2 = get_srting_int(queue_name2, "_(\\d+)_\\d+$");
			int_time1 = get_srting_int(queue_name1, "_(\\d+)$");
			int_time2 = get_srting_int(queue_name2, "_(\\d+)$");
		} catch (Exception e) {
			return queue_name1.compareTo(queue_name2);
		}
		if (int_pri1 > int_pri2) {
			return 1;
		} else if (int_pri1 < int_pri2) {
			return -1;
		} else {
			if (int_date1 < int_date2) {
				return 1;
			} else if (int_date1 > int_date2) {
				return -1;
			} else {
				if (int_time1 < int_time2){
					return 1;
				} else if (int_time1 > int_time2){
					return -1;
				} else {
					return queue_name1.compareTo(queue_name2);
				}
			}
		}
	}
	
	//sorting with run id
	public int compare_with_run(String queue_name1, String queue_name2) {
		// priority:match/assign task:job_from@run_number
		int int_pri1 = 0, int_pri2 = 0;
		int int_id1 = 0, int_id2 = 0;
		try {
			int_pri1 = get_srting_int(queue_name1, "^(\\d+)@");
			int_pri2 = get_srting_int(queue_name2, "^(\\d+)@");
			int_id1 = get_srting_int(queue_name1, "run_(\\d+)_");
			int_id2 = get_srting_int(queue_name2, "run_(\\d+)_");
		} catch (Exception e) {
			return queue_name1.compareTo(queue_name2);
		}
		if (int_pri1 > int_pri2) {
			return 1;
		} else if (int_pri1 < int_pri2) {
			return -1;
		} else {
			if (int_id1 < int_id2) {
				return 1;
			} else if (int_id1 > int_id2) {
				return -1;
			} else {
				return queue_name1.compareTo(queue_name2);
			}
		}
	}
	
	private static int get_srting_int(String str, String patt) throws NumberFormatException {
		int i = 0;
		Pattern p = Pattern.compile(patt);
		Matcher m = p.matcher(str);
		if (m.find()) {
			i = Integer.valueOf(m.group(1));
		}
		return i;
	}
}