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
	private JButton cancel_button = new JButton("Cancel");
	private JButton upload_button = new JButton("Upload");
	private String line_separator = System.getProperty("line.separator");
	private JTextArea output_area = new JTextArea(">" + line_separator);
	private static final Logger UPLOAD_DIALOG_LOGGER = LogManager.getLogger(upload_dialog.class.getName());
	private Process run_processer;
	String work_space = new String();
	
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
		p1.add(label_username);
		p1.add(field_username);
		p1.add(label_password);
		p1.add(field_password);
		p1.add(label_suitefile);
		p1.add(field_file);
		p1.add(open_button);
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
		layout_s.weighty=0.1;
		part1_layout.setConstraints(label_username, layout_s);
		//for field_username
		layout_s.gridwidth=0;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(field_username, layout_s);
		//for label_password
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0.1;
		part1_layout.setConstraints(label_password, layout_s);	
		//for field_password
		layout_s.gridwidth=0;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(field_password, layout_s);	
		//for label_suitefile
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0.1;
		part1_layout.setConstraints(label_suitefile, layout_s);	
		//for field_file
		layout_s.gridwidth=2;
		layout_s.weightx = 1;
		layout_s.weighty=0;
		part1_layout.setConstraints(field_file, layout_s);
		//for open_button
		layout_s.gridwidth=0;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(open_button, layout_s);
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
		layout_s.gridwidth=2;
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
		this.setSize(500, 400);
		//this.setLocationRelativeTo(null);
		//this.setLocation(600,600);
		if(client_info.get_client_data().containsKey("preference")){
			work_space = client_info.get_client_data().get("preference").get("work_space") + "/" +  public_data.WORKSPACE_UPLOAD_DIR;	
		} else {
			work_space = public_data.DEF_WORK_SPACE;
		}		
	}
	
	class open_action implements ActionListener{
		public void actionPerformed(ActionEvent e){
			JFileChooser import_file =  new JFileChooser(work_space); 
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
			
			String message = new String("No file selected");
			String title = new String("Upload File Error:");
			if (file.isEmpty()){
				JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
				return;
			}

			new Thread(new run_cmd(user, pswd, file, work_space)).start();
			upload_button.setEnabled(false);
		}
	}
	
	class run_cmd implements Runnable{
		private String user = new String();
		private String pswd = new String();
		private String file = new String();
		private String work_space = new String();
		
		public run_cmd(String user, String pswd, String file, String work_space){
			this.user = user;
			this.pswd = pswd;
			this.file = file;
			this.work_space = work_space;
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
				cmd_args.add(public_data.TOOLS_UPLOAD3);
			} else {
				UPLOAD_DIALOG_LOGGER.warn("Error:Got unknown Python version:" + cur_ver + ", Upload stopped.");
				return;
			}
			cmd_args.add("-f");
			cmd_args.add(file);
			cmd_args.add("-u");
			cmd_args.add(user);
			cmd_args.add("-p");
			cmd_args.add(pswd);
			output_area.append(String.join(" ", cmd_args));
			output_area.append(line_separator);
			ProcessBuilder pb = new ProcessBuilder(cmd_args);
			pb.redirectErrorStream(true);
			File work_dobj = new File(work_space);
			if (!work_dobj.exists() || !work_dobj.isDirectory()){
				try {
					FileUtils.forceMkdir(work_dobj);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					UPLOAD_DIALOG_LOGGER.warn("Error:Can not create directory:" + work_space);
					return;
				}
			}
			try {
				pb.directory(work_dobj);
			} catch (Exception e) {
				UPLOAD_DIALOG_LOGGER.warn("Error:Can not find directory:" + work_space);
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

 



