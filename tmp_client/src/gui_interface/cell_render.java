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

import javax.swing.JButton;
import javax.swing.JTable;
import javax.swing.table.TableCellRenderer;

public interface cell_render {
	
}


class button_render extends JButton implements TableCellRenderer, cell_render{  
	  
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public button_render() {  
        setOpaque(true);  
    }  
    
    @Override
    public Component getTableCellRendererComponent(
    		JTable table, 
    		Object value, 
    		boolean isSelected,
    		boolean hasFocus, 
    		int row,
			int column) { 
        if (isSelected()) {  
            setForeground(table.getSelectionForeground());  
            setBackground(table.getSelectionBackground());  
        } else {  
            setForeground(table.getForeground());  
            setBackground(table.getBackground());  
        }  
        setText((value == null) ? "" : value.toString());  
        return this;  
    } 
}


class checkbox_render implements TableCellRenderer, cell_render{    
    
    @Override
	public Component getTableCellRendererComponent(JTable table, Object value,
			boolean isSelected, boolean hasFocus, int row, int column) {
		if (value == null)
			return null;
		return (Component) value;
	} 
}
