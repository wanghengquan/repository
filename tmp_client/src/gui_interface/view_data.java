/*
 * File: tube_data.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package gui_interface;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.Vector;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.swing.JTable;
import javax.swing.table.JTableHeader;

public class view_data {
	private ReadWriteLock rw_lock = new ReentrantReadWriteLock();
	private Boolean view_debug = new Boolean(false);
	private String watching_queue = new String();
	private String watching_queue_area = new String();//all, processing, passed, failed, TBD, timeout,
	private String retest_queue_area = new String();//all, selected, passed, failed, TBD, timeout,
	private String select_rejected_queue = new String();
	private String select_captured_queue = new String();
	private List<String> select_task_case = new ArrayList<String>();
	private String run_action_request = new String();//play, pause, stop
	//following data not used currently
	private Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> watching_task_queues_data_map = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
	TreeMap<String, String> watching_reject_treemap = new TreeMap<String, String>(new queue_comparator());
	TreeMap<String, String> watching_capture_treemap = new TreeMap<String, String>(new queue_comparator());
	
	public view_data() {

	}
	
	public Boolean get_view_debug() {
		rw_lock.readLock().lock();
		Boolean temp = new Boolean(false);
		try {
			temp = view_debug;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void set_view_debug(Boolean debug_value) {
		rw_lock.writeLock().lock();
		try {
			this.view_debug = debug_value;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public String get_watching_queue() {
		rw_lock.readLock().lock();
		String temp = new String();
		try {
			temp = watching_queue;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void set_watching_queue(String update_queue) {
		rw_lock.writeLock().lock();
		try {
			this.watching_queue = update_queue;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public String get_watching_queue_area() {
		rw_lock.readLock().lock();
		String temp = new String();
		try {
			temp = watching_queue_area;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_watching_queue_area(String queue_area) {
		rw_lock.writeLock().lock();
		try {
			this.watching_queue_area = queue_area;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public String get_retest_queue_area() {
		rw_lock.readLock().lock();
		String temp = new String();
		try {
			temp = retest_queue_area;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_retest_queue_area(String queue_area) {
		rw_lock.writeLock().lock();
		try {
			this.retest_queue_area = queue_area;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public String impl_retest_queue_area() {
		rw_lock.writeLock().lock();
		String impl_area = new String();
		try {
			impl_area = retest_queue_area;
			this.retest_queue_area = "";
		} finally {
			rw_lock.writeLock().unlock();
		}
		return impl_area;
	}	
	
	public String get_select_rejected_queue() {
		rw_lock.readLock().lock();
		String temp = new String();
		try {
			temp = select_rejected_queue;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_select_rejected_queue(String queue_name) {
		rw_lock.writeLock().lock();
		try {
			this.select_rejected_queue = queue_name;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public String get_select_captured_queue() {
		rw_lock.readLock().lock();
		String temp = new String();
		try {
			temp = select_captured_queue;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_select_captured_queue(String queue_name) {
		rw_lock.writeLock().lock();
		try {
			this.select_captured_queue = queue_name;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public List<String> get_select_task_case() {
		rw_lock.readLock().lock();
		List<String> temp = new ArrayList<String>();
		try {
			temp.addAll(this.select_task_case);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_select_task_case(List<String> case_list) {
		rw_lock.writeLock().lock();
		try {
			this.select_task_case.clear();
			this.select_task_case.addAll(case_list);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void set_run_action_request(String request_action) {
		rw_lock.writeLock().lock();
		try {
			this.run_action_request = request_action;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public String impl_run_action_request() {
		rw_lock.writeLock().lock();
		String impl_action = new String();
		try {
			impl_action = run_action_request;
			this.run_action_request = "";
		} finally {
			rw_lock.writeLock().unlock();
		}
		return impl_action;
	}
	
	/*
	public Vector<String> get_work_column() {
		rw_lock.readLock().lock();
		Vector<String> temp = new Vector<String>();
		try {
			temp.addAll(work_column);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	
	public Vector<String> get_reject_column() {
		rw_lock.readLock().lock();
		Vector<String> temp = new Vector<String>();
		try {
			temp.addAll(reject_column);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public Vector<String> get_capture_column() {
		rw_lock.readLock().lock();
		Vector<String> temp = new Vector<String>();
		try {
			temp.addAll(capture_column);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	
	public JTable get_work_table() {
		rw_lock.readLock().lock();
		JTable temp = new JTable();
		try {
			temp = work_table;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}	

	public JTable get_reject_table() {
		rw_lock.readLock().lock();
		JTable temp = new JTable();
		try {
			temp = reject_table;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public JTable get_capture_table() {
		rw_lock.readLock().lock();
		JTable temp = new JTable();
		try {
			temp = capture_table;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
		*/
	/*
	public Vector<Vector<String>> get_work_data() {
		rw_lock.readLock().lock();
		Vector<Vector<String>> temp = new Vector<Vector<String>>();
		try {
			temp.addAll(work_data);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_work_data(Vector<Vector<String>> update_data) {
		rw_lock.writeLock().lock();
		try {
			work_data.clear();
			work_data.addAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_work_data(Vector<String> update_line) {
		rw_lock.writeLock().lock();
		Vector<Vector<String>> new_data = new Vector<Vector<String>>();
		try {
			String update_id = update_line.get(0);
			for (Vector<String> line : work_data){
				String search_id = line.get(0);
				if (search_id.equals(update_id)){
					new_data.add(update_line);
				} else {
					new_data.add(line);
				}	
			}
			work_data.clear();
			work_data.addAll(new_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void add_work_data(Vector<String> add_list) {
		rw_lock.writeLock().lock();
		try {
			work_data.add(add_list);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}

	public void clear_work_data() {
		rw_lock.writeLock().lock();
		try {
			work_data.clear();;
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public Vector<Vector<String>> get_reject_data() {
		rw_lock.readLock().lock();
		Vector<Vector<String>> temp = new Vector<Vector<String>>();
		try {
			temp = reject_data;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_reject_data(Vector<Vector<String>> update_data) {
		rw_lock.writeLock().lock();
		try {
			reject_data.clear();
			reject_data.addAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void add_reject_data(Vector<String> add_list) {
		rw_lock.writeLock().lock();
		try {
			reject_data.add(add_list);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void clear_reject_data() {
		rw_lock.writeLock().lock();
		try {
			reject_data.clear();
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public Vector<Vector<String>> get_capture_data() {
		rw_lock.readLock().lock();
		Vector<Vector<String>> temp = new Vector<Vector<String>>();
		try {
			temp = capture_data;
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}

	public void set_capture_data(Vector<Vector<String>> update_data) {
		rw_lock.writeLock().lock();
		try {
			capture_data.clear();
			capture_data.addAll(update_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void add_capture_data(Vector<String> add_list) {
		rw_lock.writeLock().lock();
		try {
			capture_data.add(add_list);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void clear_capture_data() {
		rw_lock.writeLock().lock();
		try {
			capture_data.clear();
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	*/
	
	public Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> get_watching_task_queues_data_map() {
		rw_lock.readLock().lock();
		Map<String, TreeMap<String, HashMap<String, HashMap<String, String>>>> queues_data = new HashMap<String, TreeMap<String, HashMap<String, HashMap<String, String>>>>();
		try {
			queues_data.putAll(watching_task_queues_data_map);
		} finally {
			rw_lock.readLock().unlock();
		}
		return queues_data;
	}	
	
	public TreeMap<String, HashMap<String, HashMap<String, String>>> get_queue_from_watching_task_queues_data_map(String queue_name) {
		rw_lock.readLock().lock();
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			if (watching_task_queues_data_map.containsKey(queue_name)){
				queue_data.putAll(this.watching_task_queues_data_map.get(queue_name));
			}
		} finally {
			rw_lock.readLock().unlock();
		}
		return queue_data;
	}

	public void update_case_to_watching_task_queues_data_map(String queue_name, String case_id, HashMap<String, HashMap<String, String>> case_data) {
		rw_lock.writeLock().lock();
		TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			if (watching_task_queues_data_map.containsKey(queue_name)){
				queue_data.putAll(watching_task_queues_data_map.get(queue_name));
			}
			queue_data.put(case_id, case_data);
			watching_task_queues_data_map.put(queue_name, queue_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void update_queue_data_to_watching_task_queues_data_map(String queue_name, TreeMap<String, HashMap<String, HashMap<String, String>>> queue_data) {
		rw_lock.writeLock().lock();
		try {
			watching_task_queues_data_map.put(queue_name, queue_data);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public void clear_watching_task_queues_data_map() {
		rw_lock.writeLock().lock();
		try {
			watching_task_queues_data_map.clear();
		} finally {
			rw_lock.writeLock().unlock();
		}
	}	
	
	public Boolean remove_case_from_watching_task_queues_data_map(String queue_name, String case_id) {
		Boolean remove_result = new Boolean(false);
		rw_lock.writeLock().lock();
		try {
			if (watching_task_queues_data_map.containsKey(queue_name)){
				if(watching_task_queues_data_map.get(queue_name).containsKey(case_id)){
					watching_task_queues_data_map.get(queue_name).remove(case_id);
					remove_result = true;
				}
			} 
		} finally {
			rw_lock.writeLock().unlock();
		}
		return remove_result;
	}
	
	public HashMap<String, HashMap<String, String>> get_case_from_watching_task_queues_data_map(String queue_name, String case_id) {
		HashMap<String, HashMap<String, String>> case_data = new HashMap<String, HashMap<String, String>>();
		rw_lock.writeLock().lock();
		try {
			if (watching_task_queues_data_map.containsKey(queue_name)){
				if(watching_task_queues_data_map.get(queue_name).containsKey(case_id)){
					case_data.putAll(watching_task_queues_data_map.get(queue_name).get(case_id));
				}
			} 
		} finally {
			rw_lock.writeLock().unlock();
		}
		return case_data;
	}	
	
	public TreeMap<String, String> get_watching_reject_treemap(){
		rw_lock.readLock().lock();
		TreeMap<String, String> temp = new TreeMap<String, String>();
		try {
			temp.putAll(watching_reject_treemap);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void add_watching_reject_treemap(String queue_name, String reason){
		rw_lock.writeLock().lock();
		try {
			watching_reject_treemap.put(queue_name, reason);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
	
	public TreeMap<String, String> get_watching_capture_treemap(){
		rw_lock.readLock().lock();
		TreeMap<String, String> temp = new TreeMap<String, String>();
		try {
			temp.putAll(watching_capture_treemap);
		} finally {
			rw_lock.readLock().unlock();
		}
		return temp;
	}
	
	public void add_watching_capture_treemap(String queue_name, String status){
		rw_lock.writeLock().lock();
		try {
			watching_capture_treemap.put(queue_name, status);
		} finally {
			rw_lock.writeLock().unlock();
		}
	}
}

class panel_table extends JTable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public panel_table(Vector<Vector<String>>rowData, Vector<String> columnNames){
		super(rowData, columnNames);
		this.setRowHeight(20);
	}
	
	public JTableHeader getTableHeader(){
		JTableHeader table_header = super.getTableHeader();
		table_header.setReorderingAllowed(false);
		return table_header;
	}
	
	public boolean isCellEditable(int row, int column){
		return false;
	}
}

class info_table extends JTable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public info_table(Vector<Vector<String>>rowData, Vector<String> columnNames){
		super(rowData, columnNames);
		this.setRowHeight(24);
	}
	
	public JTableHeader getTableHeader(){
		JTableHeader table_header = super.getTableHeader();
		table_header.setReorderingAllowed(false);
		return table_header;
	}
	
	public boolean isCellEditable(int row, int column){
		return false;
	}
	
	public boolean rowSelectionAllowed(){
		return false;
	}
}

class setting_table extends JTable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public setting_table(Vector<Vector<String>>rowData, Vector<String> columnNames){
		super(rowData, columnNames);
		this.setRowHeight(24);
	}
	
	public JTableHeader getTableHeader(){
		JTableHeader table_header = super.getTableHeader();
		table_header.setReorderingAllowed(false);
		return table_header;
	}
}

class queue_comparator implements Comparator<String>{
	@Override
	public int compare(String queue_name1, String queue_name2) {
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
	
	private static int get_srting_int(String str, String patt) {
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
}


