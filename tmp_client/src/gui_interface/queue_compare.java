package gui_interface;

import java.util.Comparator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class queue_compare implements Comparator<String> {
	private sort_enum sort_request;
	
	public queue_compare(sort_enum sort_request){
		this.sort_request = sort_request; 
	}
	
	public queue_compare(){
		this.sort_request = sort_enum.DEFAULT; 
	}	
	
	@Override
	public int compare(String queue_name1, String queue_name2) {
		// priority:match/assign task:job_from@run_number
		int int_pri1 = 0, int_pri2 = 0;
		int int_run1 = 0, int_run2 = 0;
		int int_year1 = 0, int_year2 = 0;
		int int_date1 = 0, int_date2 = 0;
		int int_time1 = 0, int_time2 = 0;
		try {
			int_pri1 = get_srting_int(queue_name1, "^(\\d+)@");
			int_pri2 = get_srting_int(queue_name2, "^(\\d+)@");
			int_run1 = get_srting_int(queue_name1, "@run_(\\d+)_?");
			int_run2 = get_srting_int(queue_name2, "@run_(\\d+)_?");
			int_year1 = get_srting_int(queue_name1, "_\\d+?(\\d\\d)_\\d+$");
			int_year2 = get_srting_int(queue_name2, "_\\d+?(\\d\\d)_\\d+$");			
			int_date1 = get_srting_int(queue_name1, "_(\\d+?)\\d\\d_\\d+$");
			int_date2 = get_srting_int(queue_name2, "_(\\d+?)\\d\\d_\\d+$");
			int_time1 = get_srting_int(queue_name1, "_(\\d+)$");
			int_time2 = get_srting_int(queue_name2, "_(\\d+)$");
		} catch (Exception e) {
			return queue_name1.compareTo(queue_name2);
		}
		int return_value = 0;
		switch (sort_request){
		case DEFAULT:
			return_value = sort_by_priority_time_run(int_pri1, int_run1, int_year1, int_date1, int_time1, int_pri2, int_run2, int_year2, int_date2, int_time2);
			break;
		case PRIORITY:
			return_value = sort_by_priority_time_run(int_pri1, int_run1, int_year1, int_date1, int_time1, int_pri2, int_run2, int_year2, int_date2, int_time2);;
			break;
		case TIME:
			return_value = sort_by_time_priority_run(int_pri1, int_run1, int_year1, int_date1, int_time1, int_pri2, int_run2, int_year2, int_date2, int_time2);;
			break;
		case RUNID:
			return_value = sort_by_run_priority_time(int_pri1, int_run1, int_year1, int_date1, int_time1, int_pri2, int_run2, int_year2, int_date2, int_time2);;
			break;			
		default:
			return_value = queue_name1.compareTo(queue_name2);
			break;
		}
		if (return_value == 0){
			return_value = queue_name1.compareTo(queue_name2);
		}
        return return_value;
	}
	
	private int sort_by_priority_time_run(
			int int_pri1,
			int int_run1,
			int int_year1,
			int int_date1,
			int int_time1,
			int int_pri2,
			int int_run2,
			int int_year2,
			int int_date2,
			int int_time2
			){
		if (int_pri1 > int_pri2) {
			return 1;
		} else if (int_pri1 < int_pri2) {
			return -1;
		} else {
			if (int_year1 < int_year2){
				return 1;
			} else if (int_year1 > int_year2) {
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
						return 0;
					}
				}				
			}
		}		
	}
	
	private int sort_by_time_priority_run(
			int int_pri1,
			int int_run1,
			int int_year1,
			int int_date1,
			int int_time1,
			int int_pri2,
			int int_run2,
			int int_year2,
			int int_date2,
			int int_time2
			){
		if (int_year1 < int_year2){
			return 1;
		} else if (int_year1 > int_year2) {
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
					if (int_pri1 > int_pri2) {
						return 1;
					} else if (int_pri1 < int_pri2) {
						return -1;
					} else {
						return 0;
					}
				}
			}				
		}		
	}
	
	private int sort_by_run_priority_time(
			int int_pri1,
			int int_run1,
			int int_year1,
			int int_date1,
			int int_time1,
			int int_pri2,
			int int_run2,
			int int_year2,
			int int_date2,
			int int_time2
			){
		if (int_run1 < int_run2){
			return 1;
		} else if (int_run1 > int_run2) {
			return -1;
		} else {
			if (int_pri1 > int_pri2) {
				return 1;
			} else if (int_pri1 < int_pri2) {
				return -1;
			} else {
				return 0;
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