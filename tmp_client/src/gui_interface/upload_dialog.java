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


public class upload_dialog extends JFrame{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@SuppressWarnings("unused")
	private client_data client_info;
	private JLabel label_username = new JLabel("TMP User Name:");
	private JLabel label_password = new JLabel("TMP Pass Word:");
	private JLabel label_suitefile = new JLabel("Upload Suite File:");
	//private JLabel label_output = new JLabel("Upload console Outputs:");
	private JTextField field_username = new JTextField("public@latticesemi.com", 20);
	private JPasswordField field_password = new JPasswordField("lattice", 20);
	private JTextField field_file = new JTextField("", 20);
	private JButton open_button = new JButton("Select");
	private JButton cancel_button = new JButton("Cancel");
	private JButton upload_button = new JButton("Upload");
	private String line_seprator = System.getProperty("line.separator");
	private JTextArea output_area = new JTextArea("Upload Console Outputs:" + line_seprator);
	private static final Logger UPLOAD_DIALOG_LOGGER = LogManager.getLogger(upload_dialog.class.getName());
	private Process run_processer;
	String work_path = new String();
	
	public upload_dialog(client_data client_info){
		//super(main_view, "Suite Upload", true);
		super();
		this.client_info = client_info;
		this.setTitle("Suite Upload");
		Image icon_image = Toolkit.getDefaultToolkit().getImage(public_data.ICON_FRAME_PNG);
		this.setIconImage(icon_image);
		Container my_container = this.getContentPane();
		my_container.setLayout(new GridLayout(2,1,10,10));
		JPanel p1 = new JPanel(new GridLayout(4,2,10,10));
		JPanel pf = new JPanel(new GridLayout(1,2,5,10));
		JPanel p2 = new JPanel(new BorderLayout());
		output_area.setLineWrap(true);
		JScrollPane sp = new JScrollPane(output_area);
		p1.add(label_username);
		p1.add(field_username);
		p1.add(label_password);
		p1.add(field_password);
		p1.add(label_suitefile);
		pf.add(field_file);
		pf.add(open_button);
		p1.add(pf);
		p1.add(cancel_button);
		p1.add(upload_button);
		p2.add(sp);
		my_container.add(p1);
		my_container.add(p2);
		open_button.addActionListener(new open_action());
		cancel_button.addActionListener(new cancel_action());
		upload_button.addActionListener(new upload_action());
		my_container.setBackground(Color.white);
		this.setSize(500, 400);
		this.setLocation(600,600);
		if(client_info.get_client_data().containsKey("preference")){
			work_path = client_info.get_client_data().get("preference").get("work_path") + "/" +  public_data.WORKSPACE_UPLOAD_DIR;	
		} else {
			work_path = public_data.DEF_WORK_PATH;
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
			
			String message = new String("No file selected");
			String title = new String("Upload File Error:");
			if (file.isEmpty()){
				JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
				return;
			}

			new Thread(new run_cmd(user, pswd, file, work_path)).start();
			upload_button.setEnabled(false);
		}
	}
	
	class run_cmd implements Runnable{
		private String user = new String();
		private String pswd = new String();
		private String file = new String();
		private String work_path = new String();
		
		public run_cmd(String user, String pswd, String file, String work_path){
			this.user = user;
			this.pswd = pswd;
			this.file = file;
			this.work_path = work_path;
		}

		@Override
		public void run() {
			// TODO Auto-generated method stub
			ArrayList<String> cmd_args = new ArrayList<String>();
			cmd_args.add("python");
			cmd_args.add(public_data.TOOLS_UPLOAD);
			cmd_args.add("-f");
			cmd_args.add(file);
			cmd_args.add("-u");
			cmd_args.add(user);
			cmd_args.add("-p");
			cmd_args.add(pswd);
			output_area.append(String.join(" ", cmd_args));
			output_area.append(line_seprator);
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
								output_area.append(line + line_seprator);
								output_area.setCaretPosition(output_area.getText().length()); 
							}
						} catch (IOException e) {
							e.printStackTrace();
						} finally {
							try {
								out_str.close();
							} catch (IOException e) {
								e.printStackTrace();
							}
						}
					}
				};
				read_log.start();
				run_processer.waitFor(7200, TimeUnit.SECONDS);
				run_processer.destroyForcibly();
			} catch (IOException e) {
				e.printStackTrace();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	public static void main(String[] args) {
		client_data client_info = new client_data();
		upload_dialog upload = new upload_dialog(client_info);
		upload.setVisible(true);
	}	
}

 



