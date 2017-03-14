package flow_control;
import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import java.util.Date;
import java.util.List;
import java.util.Vector;

import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.AbstractTableModel;

public class thread_temp extends JFrame {
	private JTable jg_table;

	public Vector<List<String>> getVect() {
		return vect;
	}

	private JScrollPane jsp;
	Vector<List<String>> vect;// ����һ����������

	public JTable getJg_table() {
		return jg_table;
	}

	public static void main(String[] args) {

		try {
			thread_temp frame = new thread_temp();
			frame.pack();
			frame.setVisible(true);
			while (true) {
				Vector<String> list = new Vector<String>();
				list.add(new Date().toGMTString());
				list.add(new Date().toLocaleString());
				list.add(new Date().toString());
				list.add(new Integer(new Date().getMinutes()).toString());
				list.add(new Integer(new Date().getSeconds()).toString());

				Thread.sleep(1000);
				frame.getVect().add(list);
				// ((AbstractTableModel)frame.getJg_table().getModel()).fireTableDataChanged();
				frame.getJg_table().updateUI();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public thread_temp() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 100, 100);
		getContentPane().setLayout(new BorderLayout(0, 0));

		AbstractTableModel tm;

		final String title[] = { "ְ����", "ְ����", "�Ա�", "��������", "����" }; // ��ά������
		vect = new Vector<List<String>>();// ʵ��������
		tm = new AbstractTableModel() {
			public int getColumnCount() {
				return title.length;
			}// ȡ�ñ������

			public int getRowCount() {
				return vect.size();
			}// ȡ�ñ������

			public Object getValueAt(int row, int column) {
				if (!vect.isEmpty())
					return ((Vector<String>) vect.elementAt(row))
							.elementAt(column);
				else
					return null;
			}// ȡ�õ�Ԫ���е�����ֵ

		};

		//vect.removeAllElements();// ��ʼ����������
		//tm.fireTableStructureChanged();// ���±������

		Vector<String> list = new Vector<String>();

		list.add("fda");
		list.add("aaa");
		list.add("ssa");
		list.add("dda");
		list.add("mma");

		//vect.addElement(list);
		//vect.addElement(list);
		//vect.addElement(list);

		tm.fireTableStructureChanged();

		// ���Ʊ��
		jg_table = new JTable(tm);// �����Լ�������ģ��

		jg_table.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
		// ���ñ������ߴ�ģʽ
		jg_table.setCellSelectionEnabled(false);
		// ���õ�Ԫ��ѡ��ʽ
		jg_table.setShowVerticalLines(true);//
		// �����Ƿ���ʾ��Ԫ���ķָ���
		jg_table.setShowHorizontalLines(true);

		jsp = new JScrollPane(jg_table);// �������Ϲ�����

		jsp.addComponentListener(new ComponentAdapter() {
			@Override
			public void componentResized(ComponentEvent e) {
				resizeTable(true);
			}
		});
		getContentPane().add(jsp, BorderLayout.CENTER);
	}
	public void resizeTable(boolean bool) {
		Dimension containerwidth = null;
		if (!bool) {
			// ��ʼ��ʱ����������СΪ��ѡ��С��ʵ�ʴ�СΪ0
			containerwidth = jsp.getPreferredSize();
		} else {
			// ������ʾ�������������С�ı䣬ʹ��ʵ�ʴ�С��������ѡ��С
			containerwidth = jsp.getSize();
		}
		// ������������ getTable().
		int allwidth = jg_table.getIntercellSpacing().width;
		for (int j = 0; j < jg_table.getColumnCount(); j++) {
			// �����������Ŀ��
			int max = 0;
			for (int i = 0; i < jg_table.getRowCount(); i++) {
				int width = jg_table
						.getCellRenderer(i, j)
						.getTableCellRendererComponent(jg_table,
								jg_table.getValueAt(i, j), false, false, i, j)
						.getPreferredSize().width;
				if (width > max) {
					max = width;
				}
			}
			// �����ͷ�Ŀ��
			int headerwidth = jg_table
					.getTableHeader()
					.getDefaultRenderer()
					.getTableCellRendererComponent(
							jg_table,
							jg_table.getColumnModel().getColumn(j)
									.getIdentifier(), false, false, -1, j)
					.getPreferredSize().width;
			// �п�����ӦΪ��ͷ���
			max += headerwidth;
			// �����п�
			jg_table.getColumnModel().getColumn(j).setPreferredWidth(max);
			// �����������ȸ�ֵ���ǵ�Ҫ���ϵ�Ԫ��֮����������1������
			allwidth += max + jg_table.getIntercellSpacing().width;
		}
		allwidth += jg_table.getIntercellSpacing().width;
		// ������ʵ�ʿ�ȴ�С�������Ŀ�ȣ�����Ҫ�����ֶ���Ӧ�������ñ������Ӧ
		if (allwidth > containerwidth.width) {
			jg_table.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
		} else {
			jg_table.setAutoResizeMode(JTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);
		}
	}

}
