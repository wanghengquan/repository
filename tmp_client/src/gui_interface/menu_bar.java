import javax.swing.JMenu;
import javax.swing.JMenuBar;

public class menu_bar extends JMenuBar{
	public menu_bar(){
		this.add(construct_file_menu());
		this.add(construct_run_menu());
		this.add(construct_tool_menu());
		this.add(construct_setting_menu());
		this.add(construct_help_menu());
	}
	
	public menu_bar get_menu_bar(){
		return this;
	}
	
	public JMenu construct_file_menu(){
		JMenu file = new JMenu("File");
		file.add("Import");
		file.addSeparator();	
		file.add("Exit");
		return file;
	}
	
	public JMenu construct_run_menu(){
		JMenu run = new JMenu("Run");
		run.add("Play");
		run.add("Pause");	
		run.add("Stop");
		run.add("Retest");
		return run;
	}
	
	public JMenu construct_tool_menu(){
		JMenu tools = new JMenu("Tools");
		tools.add("Up Load");
		tools.add("Key Gen");	
		return tools;
	}
	
	public JMenu construct_setting_menu(){
		JMenu setting = new JMenu("Setting");
		setting.add("Client");
		setting.add("Software");
		setting.add("Performance");
		return setting;
	}
	
	public JMenu construct_help_menu(){
		JMenu help = new JMenu("Help");
		help.add("Usage");
		help.addSeparator();
		help.add("About");
		return help;
	}
	
}