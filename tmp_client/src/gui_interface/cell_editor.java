/*
 * File: client_state.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package gui_interface;

import java.awt.Component;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;

import javax.swing.DefaultCellEditor;
import javax.swing.JCheckBox;
import javax.swing.JTable;

public interface cell_editor {
	
}


class checkbox_editor extends DefaultCellEditor implements ItemListener, cell_editor {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private JCheckBox check_box;

	public checkbox_editor(JCheckBox check_box) {
		super(check_box);
	}

	public Component getTableCellEditorComponent(
			JTable table, 
			Object value,
			boolean isSelected, 
			int row, 
			int column) {
		if (value == null)
			return null;
		check_box = (JCheckBox) value;
		check_box.addItemListener(this);
		return (Component) value;
	}

	public Object getCellEditorValue() {
		check_box.removeItemListener(this);
		return check_box;
	}

	public void itemStateChanged(ItemEvent e) {
		super.fireEditingStopped();
	}
}