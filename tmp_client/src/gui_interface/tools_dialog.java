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

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.util.HashMap;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;
import utility_funcs.deep_clone;
import utility_funcs.version_info;

public class tools_dialog extends JDialog implements ActionListener {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private switch_data switch_info;
	private client_data client_info;
	private JLabel jl_python, jl_perl, jl_ruby, jl_svn, jl_git;
	private JTextField jt_python, jt_perl, jt_ruby, jt_svn, jt_git;
	private JButton jb_python, jb_perl, jb_ruby, jb_svn, jb_git;
	private JButton discard, apply, close;
	private String line_separator = System.getProperty("line.separator");
	private static final Logger TOOLS_DIALOG_LOGGER = LogManager.getLogger(tools_dialog.class.getName());

	public tools_dialog(
			main_frame main_view,
			switch_data switch_info,
			client_data client_info){
		super(main_view, "Tools Setting", true);
		this.switch_info = switch_info;
		this.client_info = client_info;
		this.setLayout(new BorderLayout());
		this.add(construct_top_panel(), BorderLayout.CENTER);
		this.add(construct_buttom_panel(), BorderLayout.SOUTH);
		//this.setLocation(800, 500);
		//this.setLocationRelativeTo(main_view);
		this.setSize(650, 350);
	}
	
	private JPanel construct_top_panel(){
		HashMap<String, String> tools_data = new HashMap<String, String>();
		tools_data.putAll(client_info.get_client_tools_data());
		GridBagLayout part1_layout = new GridBagLayout();
		JPanel tools_panel = new JPanel(part1_layout);
		//step 0 : Title line
		JPanel script_title = new JPanel(new GridLayout(1,1,5,5));
		script_title.add(new JLabel("Script Tools:"));
		script_title.setBackground(Color.LIGHT_GRAY);
		tools_panel.add(script_title);
		//step 1 :input python line
		jl_python  = new JLabel("Python:");
		jl_python.setToolTipText("Must item,Python path for Client to invoke when 'python' command encountered.Both Python2.x and 3.x supported");
		jt_python = new JTextField(tools_data.getOrDefault("python", public_data.DEF_PYTHON_PATH));
		jb_python = new JButton("Select");
		jb_python.addActionListener(this);
		tools_panel.add(jl_python);
		tools_panel.add(jt_python);
		tools_panel.add(jb_python);
		//step 2 :input perl line
		jl_perl  = new JLabel("Perl*:");
		jl_perl.setToolTipText("Optional, Perl path for Client to invoke when 'perl' command encountered.");
		jt_perl = new JTextField(tools_data.getOrDefault("perl", public_data.DEF_PERL_PATH));
		jb_perl = new JButton("Select");
		jb_perl.addActionListener(this);
		tools_panel.add(jl_perl);
		tools_panel.add(jt_perl);
		tools_panel.add(jb_perl);	
		//step 3 :input ruby line
		jl_ruby  = new JLabel("Ruby*:");
		jl_ruby.setToolTipText("Optional, Ruby path for Client to invoke when 'ruby' command encountered.");
		jt_ruby = new JTextField(tools_data.getOrDefault("ruby", public_data.DEF_RUBY_PATH));
		jb_ruby = new JButton("Select");
		jb_ruby.addActionListener(this);
		tools_panel.add(jl_ruby);
		tools_panel.add(jt_ruby);
		tools_panel.add(jb_ruby);		
		//step 4 : Title line
		JPanel sc_title = new JPanel(new GridLayout(1,1,5,5));
		sc_title.add(new JLabel("Source Control Tools:"));
		sc_title.setBackground(Color.LIGHT_GRAY);
		tools_panel.add(sc_title);
		//step 5 :input svn line
		jl_svn  = new JLabel("SVN*:");
		jl_svn.setToolTipText("Optional, Subversion path for Client to invoke when your case located in svn repository.");
		jt_svn = new JTextField(tools_data.getOrDefault("svn", public_data.DEF_SVN_PATH));
		jb_svn = new JButton("Select");
		jb_svn.addActionListener(this);
		tools_panel.add(jl_svn);
		tools_panel.add(jt_svn);
		tools_panel.add(jb_svn);		
		//step 6 :input git line
		jl_git  = new JLabel("GIT*:");
		jl_git.setToolTipText("Optional, GIT path for Client to invoke when your case located in git repository.");
		jt_git = new JTextField(tools_data.getOrDefault("git", public_data.DEF_GIT_PATH));
		jb_git = new JButton("Select");
		jb_git.addActionListener(this);
		tools_panel.add(jl_git);
		tools_panel.add(jt_git);
		tools_panel.add(jb_git);
		//step 7 : empty line
		JLabel empty_line = new JLabel("");
		tools_panel.add(empty_line);		
		//step 8 : note line
		JLabel note_line = new JLabel("*:Optional, If your case/script need to export/run with this tool.");
		tools_panel.add(note_line);		
		//================================================
		//constraint them
		GridBagConstraints layout_s = new GridBagConstraints();
		layout_s.fill = GridBagConstraints.BOTH;
		//for Title line
		layout_s.gridwidth=0;
		layout_s.weightx = 1;
		layout_s.weighty=0.2;
		part1_layout.setConstraints(script_title, layout_s);	
		//for jl_python
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(jl_python, layout_s);
		//for jt_python
		layout_s.gridwidth=2;
		layout_s.weightx = 1;
		layout_s.weighty=0;
		part1_layout.setConstraints(jt_python, layout_s);		
		//for jb_python
		layout_s.gridwidth=0;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(jb_python, layout_s);		
		//for jl_perl
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(jl_perl, layout_s);
		//for jt_perl
		layout_s.gridwidth=2;
		layout_s.weightx = 1;
		layout_s.weighty=0;
		part1_layout.setConstraints(jt_perl, layout_s);		
		//for jb_perl
		layout_s.gridwidth=0;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(jb_perl, layout_s);
		//for jl_ruby
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(jl_ruby, layout_s);
		//for jt_ruby
		layout_s.gridwidth=2;
		layout_s.weightx = 1;
		layout_s.weighty=0;
		part1_layout.setConstraints(jt_ruby, layout_s);		
		//for jb_ruby
		layout_s.gridwidth=0;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(jb_ruby, layout_s);
		//for Title line
		layout_s.gridwidth=0;
		layout_s.weightx = 1;
		layout_s.weighty=0.2;
		part1_layout.setConstraints(sc_title, layout_s);
		//for jl_svn
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(jl_svn, layout_s);
		//for jt_svn
		layout_s.gridwidth=2;
		layout_s.weightx = 1;
		layout_s.weighty=0;
		part1_layout.setConstraints(jt_svn, layout_s);		
		//for jb_svn
		layout_s.gridwidth=0;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(jb_svn, layout_s);
		//for jl_git
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(jl_git, layout_s);
		//for jt_git
		layout_s.gridwidth=2;
		layout_s.weightx = 1;
		layout_s.weighty=0;
		part1_layout.setConstraints(jt_git, layout_s);		
		//for jb_git
		layout_s.gridwidth=0;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(jb_git, layout_s);
		//for empty line
		layout_s.gridwidth=0;
		layout_s.weightx = 1;
		layout_s.weighty=0.6;
		part1_layout.setConstraints(empty_line, layout_s);
		//for empty line
		layout_s.gridwidth=0;
		layout_s.weightx = 1;
		layout_s.weighty=0;
		part1_layout.setConstraints(note_line, layout_s);		
		//final package
		return tools_panel;
	}

	private JPanel construct_buttom_panel(){
		GridBagLayout part1_layout = new GridBagLayout();
		JPanel p2 = new JPanel(part1_layout);
		JLabel blank_line1 = new JLabel("");
		discard = new JButton("Discard");
		discard.setToolTipText("Restore previous data.");
		discard.addActionListener(this);
		p2.add(discard);
		p2.add(blank_line1);
		close = new JButton("Close");
		close.setToolTipText("Close this window");
		close.addActionListener(this);
		p2.add(close);		
		apply = new JButton("Apply");
		apply.setToolTipText("Implements the imports");
		apply.addActionListener(this);
		p2.add(apply);		
		//layout it 
		GridBagConstraints layout_s = new GridBagConstraints();
		layout_s.fill = GridBagConstraints.BOTH;
		//for discard
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(discard, layout_s);	
		//for blank_line1
		layout_s.gridwidth=2;
		layout_s.weightx = 1;
		layout_s.weighty=0;
		part1_layout.setConstraints(blank_line1, layout_s);		
		//for close
		layout_s.gridwidth=1;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(close, layout_s);
		//for apply
		layout_s.gridwidth=0;
		layout_s.weightx = 0;
		layout_s.weighty=0;
		part1_layout.setConstraints(apply, layout_s);		
		return p2;
	}
	
	@Override
	public void actionPerformed(ActionEvent arg0) {		
		// TODO Auto-generated method stub
		HashMap<String, String> tools_data = new HashMap<String, String>();
		tools_data.putAll(deep_clone.clone(client_info.get_client_tools_data()));
		//jb_python, jb_perl, jb_ruby, jb_svn, jb_git
		if(arg0.getSource().equals(jb_python)) {
			JFileChooser import_file = new JFileChooser();
			import_file.setDialogTitle("Select Tool Bin File");
			int return_value = import_file.showOpenDialog(this);
			if (return_value == JFileChooser.APPROVE_OPTION) {
				jt_python.setText(import_file.getSelectedFile().getAbsolutePath().replaceAll("\\\\", "/"));
			}
		}
		if(arg0.getSource().equals(jb_perl)) {
			JFileChooser import_file = new JFileChooser();
			import_file.setDialogTitle("Select Tool Bin File");
			int return_value = import_file.showOpenDialog(this);
			if (return_value == JFileChooser.APPROVE_OPTION) {
				jt_perl.setText(import_file.getSelectedFile().getAbsolutePath().replaceAll("\\\\", "/"));
			}
		}
		if(arg0.getSource().equals(jb_ruby)) {
			JFileChooser import_file = new JFileChooser();
			import_file.setDialogTitle("Select Tool Bin File");
			int return_value = import_file.showOpenDialog(this);
			if (return_value == JFileChooser.APPROVE_OPTION) {
				jt_ruby.setText(import_file.getSelectedFile().getAbsolutePath().replaceAll("\\\\", "/"));
			}
		}
		if(arg0.getSource().equals(jb_svn)) {
			JFileChooser import_file = new JFileChooser();
			import_file.setDialogTitle("Select Tool Bin File");
			int return_value = import_file.showOpenDialog(this);
			if (return_value == JFileChooser.APPROVE_OPTION) {
				jt_svn.setText(import_file.getSelectedFile().getAbsolutePath().replaceAll("\\\\", "/"));
			}
		}
		if(arg0.getSource().equals(jb_git)) {
			JFileChooser import_file = new JFileChooser();
			import_file.setDialogTitle("Select Tool Bin File");
			int return_value = import_file.showOpenDialog(this);
			if (return_value == JFileChooser.APPROVE_OPTION) {
				jt_git.setText(import_file.getSelectedFile().getAbsolutePath().replaceAll("\\\\", "/"));
			}
		}
		if(arg0.getSource().equals(discard)) {
			jt_python.setText(tools_data.getOrDefault("python", public_data.DEF_PYTHON_PATH));
			jt_perl.setText(tools_data.getOrDefault("perl", public_data.DEF_PERL_PATH));
			jt_ruby.setText(tools_data.getOrDefault("ruby", public_data.DEF_RUBY_PATH));
			jt_svn.setText(tools_data.getOrDefault("svn", public_data.DEF_SVN_PATH));
			jt_git.setText(tools_data.getOrDefault("git", public_data.DEF_GIT_PATH));
		}
		if (arg0.getSource().equals(close)) {
			this.dispose();		
		}
		if(arg0.getSource().equals(apply)) {
			String [] tools = new String [] {"python", "perl", "ruby", "svn", "git"};
			Boolean update_ok = Boolean.valueOf(true);
			for (String tool_name : tools) {
				String new_path = new String("NA");
				String ori_path = new String("NA");
				switch (tool_name) {
				case "python":
					new_path = jt_python.getText().trim().replaceAll("\\\\", "/");
					ori_path = tools_data.getOrDefault(tool_name, public_data.DEF_PYTHON_PATH);
					break;
				case "perl":
					new_path = jt_perl.getText().trim().replaceAll("\\\\", "/");
					ori_path = tools_data.getOrDefault(tool_name, public_data.DEF_PERL_PATH);
					break;
				case "ruby":
					new_path = jt_ruby.getText().trim().replaceAll("\\\\", "/");
					ori_path = tools_data.getOrDefault(tool_name, public_data.DEF_RUBY_PATH);
					break;
				case "svn":
					new_path = jt_svn.getText().trim().replaceAll("\\\\", "/");
					ori_path = tools_data.getOrDefault(tool_name, public_data.DEF_SVN_PATH);
					break;
				case "git":
					new_path = jt_git.getText().trim().replaceAll("\\\\", "/");
					ori_path = tools_data.getOrDefault(tool_name, public_data.DEF_GIT_PATH);
					break;
				default:
					break;
				}
				if(new_path.equals("")){
					if (tool_name.equalsIgnoreCase("python")) {
						String message = new String("Empty Tool Path Found for:" + tool_name + ". It's a must item.");
						JOptionPane.showMessageDialog(this, message, "Wrong import value:", JOptionPane.INFORMATION_MESSAGE);
						update_ok = false;
					} else {
						tools_data.put(tool_name, new_path);
					}		
				} else if(new_path.equalsIgnoreCase(tool_name)){
					continue;
				} else if(new_path.equalsIgnoreCase(ori_path)){
					continue;					
				} else {
					File file_dobj = new File(new_path);
					if(file_dobj.exists()){
						tools_data.put(tool_name, new_path);
						if (tool_name.equalsIgnoreCase("python")) {
							//GUI report
							String python_version = new String(version_info.get_python_version(new_path));
							String work_space = new String(client_info.get_client_preference_data().get("work_space"));
							StringBuilder message = new StringBuilder("");
							message.append("New Python: " + new_path);
							message.append(line_separator);
							message.append("Version: " + python_version);
							message.append(line_separator);
							message.append(line_separator);
							String corescript_path = new String("");
							if (python_version.startsWith("2")) {
								corescript_path = public_data.LOCAL_CORE_SCRIPT_DIR2;
							} else if (python_version.startsWith("3")) {
								if(switch_info.get_remote_corescript_linked()) {
									corescript_path = public_data.REMOTE_CORE_SCRIPT_DIR.replaceAll("\\$work_path", " " + work_space);
								} else {
									corescript_path = public_data.LOCAL_CORE_SCRIPT_DIR3;
								}
							} else {
								corescript_path = public_data.LOCAL_CORE_SCRIPT_DIR3;
							}
							message.append("CoreScript linked: " + corescript_path);
							String title = new String("New Python Confirm:");
							JOptionPane.showMessageDialog(this, message.toString(), title, JOptionPane.INFORMATION_MESSAGE);
							//Console report
							TOOLS_DIALOG_LOGGER.warn("New Python: " + new_path);
							TOOLS_DIALOG_LOGGER.warn("Version: " + python_version);
							TOOLS_DIALOG_LOGGER.warn("CoreScript linked: " + corescript_path);
						}
					} else {
						String message = new String("Path Not Exists:" + tool_name);
						JOptionPane.showMessageDialog(this, message, "Wrong import value:", JOptionPane.INFORMATION_MESSAGE);
						update_ok = false;
						TOOLS_DIALOG_LOGGER.warn("Path Not Exists:" + tool_name);
					}
				}
			}
			if (update_ok) {
				client_info.set_client_tools_data(tools_data);
				switch_info.set_client_updated();
			}
		}
	}
	
	public static void main(String[] args) {
		switch_data switch_info = new switch_data();
		client_data client_info = new client_data();
		tools_dialog tools_view = new tools_dialog(null, switch_info, client_info);
		tools_view.setVisible(true);
	}
}