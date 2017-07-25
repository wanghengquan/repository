package gui_interface;

import java.util.Comparator;

public class build_compare implements Comparator<String> {
	@Override
	public int compare(String build_name1, String build_name2) {
		// case from local: mx_xx_flow
		int prefix1 = 0, prefix2 = 0;
		if(build_name1.startsWith("sd_")){
			prefix1 = 1;
		} else if (build_name1.startsWith("sc_")){
			prefix1 = 2;
		} else {
			prefix1 = 0;
		}
		if(build_name2.startsWith("sd_")){
			prefix2 = 1;
		} else if (build_name2.startsWith("sc_")){
			prefix2 = 2;
		} else {
			prefix2 = 0;
		}
		if (prefix1 > prefix2) {
			return 1;
		} else if (prefix1 < prefix2) {
			return -1;
		} else {
			return build_name1.compareTo(build_name2);
		}
	}
}