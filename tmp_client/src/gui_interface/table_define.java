package gui_interface;

import java.awt.Font;
import java.util.Vector;

import javax.swing.JTable;
import javax.swing.table.JTableHeader;

import data_center.public_data;

public interface table_define {
	
}


class panel_table extends JTable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public panel_table(Vector<Vector<String>>rowData, Vector<String> columnNames){
		super(rowData, columnNames);
		this.setFont(new Font(public_data.DEF_SYSTEM_TABLE_FONT, Font.PLAIN, 18));
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
		this.setFont(new Font(null, Font.PLAIN, 18));
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
		this.setFont(new Font(null, Font.PLAIN, 18));
		this.setRowHeight(20);
	}
	
	public JTableHeader getTableHeader(){
		JTableHeader table_header = super.getTableHeader();
		table_header.setReorderingAllowed(false);
		return table_header;
	}
}


class report_table extends JTable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public report_table(Vector<Vector<Object>>rowData, Vector<String> columnNames){
		super(rowData, columnNames);
		this.setFont(new Font(null, Font.PLAIN, 18));
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
	
	public boolean rowSelectionAllowed(){
		return false;
	}
}