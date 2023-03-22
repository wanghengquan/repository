/*
 * File: main_frame.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/03/11
 * Modifier:
 * Date:
 * Description:
 */
package gui_interface;


import java.awt.*;
import java.awt.event.*;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.swing.*;

import org.apache.commons.io.FileUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;
import utility_funcs.data_check;


public class upload_dialog extends JFrame{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private client_data client_info;
	private switch_data switch_info;
	private JLabel label_username = new JLabel("TMP Username:");
	private JLabel label_password = new JLabel("TMP Password:");
	private JLabel label_suitefile = new JLabel("Upload Suite File:");
	//private JLabel label_output = new JLabel("Upload console Outputs:");
	private JTextField field_username = new JTextField(public_data.TMP_DATABASE_USER, 20);
	private JPasswordField field_password = new JPasswordField(public_data.TMP_DATABASE_PWD, 20);
	private JTextField field_file = new JTextField("", 20);
	private JButton open_button = new JButton("Select");
	private JLabel jl_suite_sheet = new JLabel("Suite Sheets:");
	private JRadioButton jr_all_sheet = new JRadioButton("All");
	private JRadioButton jr_lst_sheet = new JRadioButton("List:");
	private JTextField jt_sheet_list = new JTextField("");
	private JLabel jl_match_case = new JLabel("Match Only:");
	private JRadioButton jr_match_auto = new JRadioButton("Auto");
	private JRadioButton jr_match_yes = new JRadioButton("Yes");
	private JRadioButton jr_match_no = new JRadioButton("No");
	private JButton cancel_button = new JButton("Cancel");
	private JButton upload_button = new JButton("Upload");
	private String line_separator = System.getProperty("line.separator");
	private JTextArea output_area = new JTextArea(">" + line_separator);
	private static final Logger UPLOAD_DIALOG_LOGGER = LogManager.getLogger(upload_dialog.class.getName());
	private Process run_processer;
	String work_path = new String();
	
	public upload_dialog(
			switch_data switch_info,
			client_data client_info
			){
		//super(main_view, "Suite Upload", true);
		super();
		this.switch_info = switch_info;
		this.client_info = client_info;
		this.setTitle("Suite Upload");
		Image icon_image = Toolkit.getDefaultToolkit().getImage(public_data.ICON_FRAME_PNG);
		this.setIconImage(icon_image);
		Container my_container = this.getContentPane();
		my_container.setLayout(new GridLayout(2,1,10,10));
		//=================================first part 
		GridBagLayout part1_layout = new GridBagLayout();
		JPanel p1 = new JPanel(part1_layout);
		JLabel blank_line1 = new JLabel("");
		label_username.setToolTipText("TestRail User Name.");
		p1.add(label_username);
		p1.add(field_username);
		label_password.setToolTipText("TestRail Password.");
		p1.add(label_password);
		p1.add(field_password);
		label_suitefile.setToolTipText("TMP format suite file, maximum version:" + public_data.BASE_SUITEFILEVERSION);
		p1.add(label_suitefile);
		p1.add(field_file);
		p1.add(open_button);
		p1.add(jl_suite_sheet);
		p1.add(jr_all_sheet);
		p1.add(jr_lst_sheet);
		p1.add(jt_sheet_list);
		jl_suite_sheet.setToolTipText("Suite Sheet to upload.");
		jr_all_sheet.setToolTipText("All suite sheets will be upload.");
		jr_lst_sheet.setToolTipText("listed suite sheets will be upload.");
		jt_sheet_list.setToolTipText("List suite sheets, separate with ',' or ';'.");
		ButtonGroup suite_group = new ButtonGroup();
		suite_group.add(jr_all_sheet);
		suite_group.add(jr_lst_sheet);
		jr_all_sheet.setSelected(true);
		p1.add(jl_match_case);
		p1.add(jr_match_auto);
		p1.add(jr_match_yes);
		p1.add(jr_match_no);
		jl_match_case.setToolTipText("How upload script process those cases doesn't match any 'macro' condition.");
		jr_match_auto.setToolTipText("1. Suite file with one suite sheet, upload all case, 2. Suite file with mulitple suite sheets only matched case will be upload.");
		jr_match_yes.setToolTipText("Test case must match suite 'macro' before upload.");
		jr_match_no.setToolTipText("Test case doesn't match suite 'macro' will also be upload.");
		ButtonGroup match_group = new ButtonGroup();
		match_group.add(jr_match_auto);
		match_group.add(jr_match_yes);
		match_group.add(jr_match_no);
		jr_match_auto.setSelected(true);
		JPanel blank_cell1 = new JPanel();
		p1.add(blank_cell1);
		p1.add(blank_line1);
		p1.add(cancel_button);		
		JPanel blank_cell2 = new JPanel();
		p1.add(blank_cell2);
		p1.add(upload_button);
		JPanel jp_title = new JPanel(new GridLayout(1,1,5,5));
		jp_title.add(new JLabel("Upload Console Outputs:"));
		jp_title.setBackground(Color.LIGHT_GRAY);
		p1.add(jp_title);
		GridBagConstraints layout_s = new GridBagConstraints();
		layout_s.fill = GridBagConstraints.BOTH;
		//for label_username
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty = 0;
		part1_layout.setConstraints(label_username, layout_s);
		//for field_username
		layout_s.gridwidth=0;
		layout_s.weightx = 0;
		layout_s.weighty = 0;
		part1_layout.setConstraints(field_username, layout_s);
		//for label_password
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty = 0;
		part1_layout.setConstraints(label_password, layout_s);	
		//for field_password
		layout_s.gridwidth=0;
		layout_s.weightx = 0;
		layout_s.weighty = 0;
		part1_layout.setConstraints(field_password, layout_s);	
		//for label_suitefile
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(label_suitefile, layout_s);	
		//for field_file
		layout_s.gridwidth=4;
		layout_s.weightx = 1;
		layout_s.weighty=0;
		part1_layout.setConstraints(field_file, layout_s);
		//for open_button
		layout_s.gridwidth=0;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(open_button, layout_s);
		//for label_suitefile
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty = 0;
		part1_layout.setConstraints(jl_suite_sheet, layout_s);	
		//for jr_all_sheet
		layout_s.gridwidth=1;
		layout_s.weightx = 0.1;
		layout_s.weighty = 0;
		part1_layout.setConstraints(jr_all_sheet, layout_s);		
		//for jr_lst_sheet
		layout_s.gridwidth=1;
		layout_s.weightx = 0.1;
		layout_s.weighty = 0;
		part1_layout.setConstraints(jr_lst_sheet, layout_s);		
		//for jt_sheet_list
		layout_s.gridwidth=0;
		layout_s.weightx = 0.8;
		layout_s.weighty = 0;
		part1_layout.setConstraints(jt_sheet_list, layout_s);		
		//for jl_match_case
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0.1;
		part1_layout.setConstraints(jl_match_case, layout_s);	
		//for jr_match_auto
		layout_s.gridwidth=1;
		layout_s.weightx = 0.2;
		layout_s.weighty = 0;
		part1_layout.setConstraints(jr_match_auto, layout_s);		
		//for jr_match_yes
		layout_s.gridwidth=1;
		layout_s.weightx = 0.2;
		layout_s.weighty = 0;
		part1_layout.setConstraints(jr_match_yes, layout_s);		
		//for jr_match_no
		layout_s.gridwidth=1;
		layout_s.weightx = 0.2;
		layout_s.weighty = 0;
		part1_layout.setConstraints(jr_match_no, layout_s);		
		//for blank_cell1
		layout_s.gridwidth=0;
		layout_s.weightx = 0.4;
		layout_s.weighty = 0;
		part1_layout.setConstraints(blank_cell1, layout_s);
		//for blank_line1
		layout_s.gridwidth=0;
		layout_s.weightx = 0;
		layout_s.weighty=0.5;
		part1_layout.setConstraints(blank_line1, layout_s);		
		//for cancel_button
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0.1;
		part1_layout.setConstraints(cancel_button, layout_s);		
		//for blank_cell2
		layout_s.gridwidth=4;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(blank_cell2, layout_s);	
		//for upload_button
		layout_s.gridwidth=0;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(upload_button, layout_s);
		//for jp_title
		layout_s.gridwidth=0;
		layout_s.weightx = 0;
		layout_s.weighty=0.1;
		part1_layout.setConstraints(jp_title, layout_s);		
		//=================================second part 
		JPanel p2 = new JPanel(new BorderLayout());
		output_area.setLineWrap(true);
		JScrollPane sp = new JScrollPane(output_area);		
		p2.add(sp, BorderLayout.CENTER);
		my_container.add(p1);
		my_container.add(p2);
		open_button.addActionListener(new open_action());
		cancel_button.addActionListener(new cancel_action());
		upload_button.addActionListener(new upload_action());
		my_container.setBackground(Color.white);
		this.setSize(600, 500);
		//this.setLocationRelativeTo(null);
		//this.setLocation(600,600);
		if(client_info.get_client_data().containsKey("preference")){
			work_path = client_info.get_client_data().get("preference").get("work_space") + "/" +  public_data.WORKSPACE_UPLOAD_DIR;	
		} else {
			work_path = public_data.DEF_WORK_SPACE;
		}		
	}
	
	class open_action implements ActionListener{
		public void actionPerformed(ActionEvent e){
			JFileChooser import_file =  new JFileChooser(work_path); 
			import_file.setDialogTitle("Select Upload Suite file");
			int return_value = import_file.showOpenDialog(null);
			if (return_value == JFileChooser.APPROVE_OPTION){
				File open_suite_file = import_file.getSelectedFile();
				String path = open_suite_file.getAbsolutePath().replaceAll("\\\\", "/");
				field_file.setText(path);
				UPLOAD_DIALOG_LOGGER.debug("Upload suite file:" + path);
			}
		}
	}
	
	class cancel_action implements ActionListener{
		public void actionPerformed(ActionEvent e){
			run_processer.destroyForcibly();
			upload_button.setEnabled(true);
		}
	}

	class upload_action implements ActionListener{
		public void actionPerformed(ActionEvent e){
			String user = field_username.getText();
			String pswd = new String(field_password.getPassword());
			String file = field_file.getText();
			//suite file check
			String message = new String("No file selected");
			String title = new String("Upload File Error:");
			if (file.isEmpty()){
				JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
				return;
			}
			//suite sheet check
			String suite_sheets = jt_sheet_list.getText();
			if(jr_lst_sheet.isSelected() && suite_sheets.isEmpty()) {
				message = "No suite sheet name listed";
				title = "Upload File Error:";
				JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
				return;
			}
			//generate run thread
			String match_option = new String("");
			if(jr_match_auto.isSelected()) {
				match_option = "auto";
			} else if (jr_match_yes.isSelected()) {
				match_option = "yes";
			} else if (jr_match_no.isSelected()) {
				match_option = "no";
			} else {
				;
			}
			String sheet_option = new String("");
			if(jr_all_sheet.isSelected()) {
				;
			} else if (jr_lst_sheet.isSelected()) {
				sheet_option = suite_sheets.replaceAll("\\s*,\\s*", ",").replaceAll("\\s*;\\s*", ",").trim();
			} else {
				;
			}
			new Thread(new run_cmd(user, pswd, file, match_option, sheet_option, work_path)).start();
			upload_button.setEnabled(false);
		}
	}
	
	class run_cmd implements Runnable{
		private String user = new String();
		private String pswd = new String();
		private String file = new String();
		private String match_option = new String();
		private String sheet_option = new String();
		private String work_path = new String();
		
		public run_cmd(
				String user, 
				String pswd, 
				String file, 
				String match_option,
				String sheet_option,
				String work_path
				){
			this.user = user;
			this.pswd = pswd;
			this.file = file;
			this.match_option = match_option;
			this.sheet_option = sheet_option;
			this.work_path = work_path;
		}

		@Override
		public void run() {
			// TODO Auto-generated method stub
			//step 1: Python command identify
			ArrayList<String> cmd_args = new ArrayList<String>();
			String python_cmd = new String(public_data.DEF_PYTHON_PATH);
			if(client_info.get_client_data().containsKey("tools")){
				python_cmd = client_info.get_client_tools_data().getOrDefault("python", public_data.DEF_PYTHON_PATH);	
			}
			//step 2: Python version identify
			String cur_ver = new String(switch_info.get_system_python_version());
			//step 3: Command generate
			cmd_args.add(python_cmd);
			if (cur_ver.startsWith("2.")) {
				cmd_args.add(public_data.TOOLS_UPLOAD2);
			} else if (cur_ver.startsWith("3.")) {
				String work_space = new String("");
				if(client_info.get_client_data().containsKey("preference")){
					work_space = client_info.get_client_data().get("preference").get("work_space");	
				} else {
					work_space = public_data.DEF_WORK_SPACE;
				}	
				String dynamic_path = new String("");
				dynamic_path = public_data.TOOLS_UPLOAD3_DYNAMIC.replaceAll("\\$work_path", work_space);
				if(data_check.str_path_check(dynamic_path)) {
					cmd_args.add(dynamic_path);
				} else {
					cmd_args.add(public_data.TOOLS_UPLOAD3);
				}
			} else {
				UPLOAD_DIALOG_LOGGER.warn("Error:Got unknown Python version:" + cur_ver + ", Upload stopped.");
				return;
			}
			cmd_args.add("upload");
			cmd_args.add("-f");
			cmd_args.add(file);
			cmd_args.add("-m");
			cmd_args.add(match_option);
			if(!sheet_option.isEmpty()) {
				cmd_args.add("-s");
				cmd_args.add(sheet_option);
			}
			cmd_args.add("-c");
			cmd_args.add("-u");
			cmd_args.add(user);
			cmd_args.add("-p");
			cmd_args.add(pswd);
			//System.out.println(cmd_args.toString());
			output_area.append(String.join(" ", cmd_args).replaceAll(" " + public_data.TMP_DATABASE_PWD, " ******"));
			output_area.append(line_separator);
			ProcessBuilder pb = new ProcessBuilder(cmd_args);
			pb.redirectErrorStream(true);
			File work_dobj = new File(work_path);
			if (!work_dobj.exists() || !work_dobj.isDirectory()){
				try {
					FileUtils.forceMkdir(work_dobj);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					UPLOAD_DIALOG_LOGGER.warn("Error:Can not create directory:" + work_path);
					return;
				}
			}
			try {
				pb.directory(work_dobj);
			} catch (Exception e) {
				UPLOAD_DIALOG_LOGGER.warn("Error:Can not find directory:" + work_path);
				return;
			}
			Map<String, String> env = pb.environment();
			env.put("PYTHONUNBUFFERED", "1");
			try {
				run_processer = pb.start();
				InputStream out_str = run_processer.getInputStream();
				BufferedReader br1 = new BufferedReader(new InputStreamReader(out_str));
				// thread1 read output stream
				Thread read_log = new Thread() {
					public void run() {
						try {
							String line = null;
							while ((line = br1.readLine()) != null) {
								output_area.append(line + line_separator);
								output_area.setCaretPosition(output_area.getText().length()); 
							}
						} catch (IOException e) {
							e.printStackTrace();
						} finally {
							try {
								br1.close();
								out_str.close();
							} catch (IOException e) {
								e.printStackTrace();
							}
						}
					}
				};
				read_log.start();
				run_processer.waitFor(36000, TimeUnit.SECONDS);
				run_processer.destroyForcibly();
			} catch (IOException e) {
				e.printStackTrace();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			upload_button.setEnabled(true);
		}
	}
	
	public static void main(String[] args) {
		switch_data switch_info = new switch_data();
		client_data client_info = new client_data();
		upload_dialog upload = new upload_dialog(switch_info, client_info);
		upload.setVisible(true);
	}	
}

 



