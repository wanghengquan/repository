package utility_funcs;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.concurrent.Callable;
import java.util.concurrent.TimeUnit;

public class syscmd_run {
	
	public static void main(String [] args) throws Exception{	
		String cmd = "conf/cp -r //lsh-prince/sw/SW_Validation/LSH_Results/GUI_Automation_Squish/regression3.9/Silicon/00_gui_silicon/D38_suite_device_feature/allviews/tst_cmos_to_dphy_dsi_rgb666_222 result/prj3/run366/T803147/tst_cmos_to_dphy_dsi_rgb666_222";
		//String cmd = "svn export http://lshlabd0001/diamond/trunk/FE_17_POJO2/pojo2_flow/ao4410 result/prj3/run368/T807387/ao4410 --username=guest --password=welcome --no-auth-cache --force";
		//String cmd = "svn export http://lshlabd0001/diamond/trunk/GUI_14_Device_Coverage/device_cover/LAE5UM-25F-6BG381E result/prj3/run367/T803283/LAE5UM-25F-6BG381E --username=guest --password=welcome --no-auth-cache --force";
		//String cmd = "svn export http://lshlabd0001/designpool/trunk/AE_suite/Harmonic_150_elwood result/prj3/run368/T807387/Harmonic_150_elwood      --username=guest      --password=welcome --no-auth-cache --force";
		//ArrayList<String> run4(String [] cmds, Map<String,String> envs, String directory, int timeout) throws InterruptedException
		String [] cmds = {"python","try_python.py"};
		HashMap <String,String> envs = new HashMap <String,String> ();
		envs.put("aa", "bb");
		//envs.put("PYTHONUNBUFFERED", "1");
		String dir = new String("D:/project/lrf_prj/client_prj");
		int timeout = 5;
		ArrayList<String> list = run(cmd);
		//ArrayList<String> list = run(cmd);
		System.out.println(list.toString());
	}
	
	//run1 command single string
	public static ArrayList<String> run(String cmd) throws IOException{
		/*
		 * At this function, the cmd will be execute. 
		 * But in this way, we can use os.system in python block
		 */
		if (TopRun.dug_model){
		    System.out.println(">>>Debug: Run CMD: " + cmd);
		}
		String [] cmd_list = cmd.split("\\s+");
		ProcessBuilder proce_build = new ProcessBuilder(cmd_list);
		proce_build.redirectErrorStream(true);
		Process process = proce_build.start();
		ArrayList<String> string_list =new ArrayList<String>(); 
	    InputStream fis = process.getInputStream();
	    BufferedReader bri = new BufferedReader(new InputStreamReader(fis));
	    string_list.add(cmd);
	    String line = null; 
	    while ((line = bri.readLine()) != null) {
	        string_list.add(line);
	    }
	    bri.close();	    
	    try {
	        process.waitFor();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e2) {
			e2.printStackTrace();
		}
	    if (TopRun.dug_model){
	        System.out.println(">>>Debug: Exit Code:" + process.exitValue());
	        System.out.println(">>>Debug: " + string_list);
	    }
	    process.destroy();
	    return string_list;
	}
	
	//run2 command with environment
	public static ArrayList<String> run (String [] cmds, Map<String,String> envs) throws InterruptedException{
		/*
		 * This function used to run command in another way: ProcessBuilder
		 */
		ArrayList<String> string_list = new ArrayList<String>();
		string_list.add("run cmd:" + Arrays.toString(cmds).replaceAll("[\\[\\]\\s,]", " "));
		string_list.add("run env:" + envs.toString());
		ProcessBuilder pb = new ProcessBuilder(cmds);
		Map<String,String> env = pb.environment();
		env.putAll(envs);
		try {
			 Process p = pb.start();
			 InputStream fis = p.getInputStream();
			 BufferedReader br = new BufferedReader(new InputStreamReader(fis));
			 String line = null;
			 String reason = new String("");
			 string_list.add("run rst:");
			 while ((line = br.readLine()) != null) {
			        //System.out.println(line);
			        string_list.add(line);
			        if(line.trim().toLowerCase().startsWith("error"))
			        	reason = line;			        
			    }
			br.close();
			int exit = p.waitFor();  
			if(exit == 0){
				 string_list.add("<status>Passed</status>"); 
			 }
			else if(exit == 1){
				 string_list.add("<status>Failed</status>"); 
			 }
			else{
				 string_list.add("<status>TBD</status>"); 
			 }
			if(reason.length()>1)
				string_list.add("<reason>"+reason.trim()+"</reason>"); 
		 } catch (IOException e) {
		    //e.printStackTrace();
		    string_list.add("<status>Failed</status>"); 
		    string_list.add("<reason>"+"Can not launch command"+"</reason>"); 
		 }
		return string_list;
	}

	//run3 command with environment for a specific case
	public static ArrayList<String> run(String [] cmds, Map<String,String> envs, String directory, int timeout) 
		throws IOException, InterruptedException
		{
		/*
		 * This function used to run command in another way: ProcessBuilder
		 */
		ArrayList<String> string_list =new ArrayList<String>();
		string_list.add(Arrays.toString(cmds).replaceAll("[\\[\\]\\s,]", " "));
		ProcessBuilder pb = new ProcessBuilder(cmds);
		pb.redirectErrorStream(true);
		File run_dir = new File(directory);
		if (run_dir.exists()){
			pb.directory(run_dir);
		}
		Map<String,String> env = pb.environment();
		env.putAll(envs);
		Process p = pb.start();
		InputStream out_str = p.getInputStream();
		StreamGobbler read_out = new StreamGobbler(out_str, "OUTPUT", false);
		 read_out.start();
		 boolean  exit_status = p.waitFor((long)timeout, TimeUnit.SECONDS);
		 read_out.stopGobbling();
		 string_list.addAll(read_out.getOutputList()); 
		 if (exit_status){
			int exit_value = p.exitValue();
			if (exit_value == 0){
				string_list.add("<status>Passed</status>"); 
			} else if (exit_value == 1) {
				string_list.add("<status>Failed</status>");
			} else{
				string_list.add("<status>TBD</status>");
			}
		 } else{
			 System.out.println(">>>Info: Clean up, timeout task cleanup.");
			 string_list.add("<status>Timeout</status>"); 
			 string_list.add("<reason>Timeout</reason>"); 
			 p.destroyForcibly();
		 }
		 //Start processing return string list
		 Iterator<String> line_it = string_list.iterator();
		 String reason = new String();
		 Boolean TBD_flag = new Boolean(false);
		 while (line_it.hasNext()) {
		        String line = line_it.next();
		        if(line.toLowerCase().startsWith("error"))
		        	reason = line;
		        else if(line.indexOf("##CR_NOTE_BEGIN##")>0)
		        	TBD_flag = true;
		        else if(line.indexOf("#CR_NOTE_END#")>0)
		        	TBD_flag = false;
		        else if(TBD_flag)
		        	reason = line;			        
		}
		if(reason.length()>1)
			string_list.add("<reason>"+reason.trim()+"</reason>"); 		 
		return string_list;
	}
	
	//run4 command with environment for a specific case
	public static ArrayList<String> run4(String [] cmds, Map<String,String> envs, String directory, int timeout) throws InterruptedException{
		/*
		 * This function used to run command in another way: ProcessBuilder
		 */
		ArrayList<String> string_list =new ArrayList<String>();
		string_list.add(Arrays.toString(cmds).replaceAll("[\\[\\]\\s,]", " "));
		ProcessBuilder pb = new ProcessBuilder(cmds);
		pb.redirectErrorStream(true);
		try{
			pb.directory(new File(directory));
		}catch(Exception e){
			string_list.add("Error:Can not find directory:"+directory+"\n");
		}
		Map<String,String> env = pb.environment();
		env.putAll(envs);
		Process p = null;
		try {
			 p = pb.start();	 				 
			 InputStream out_str = p.getInputStream();
			 BufferedReader br1 = new BufferedReader(new InputStreamReader(out_str));
			 //thread1 read output stream
			 Thread read_log = new Thread() {  
				   public void run() {  
				       try {  
				           String line = null;  
				           while ((line = br1.readLine()) != null) {  
				        	   string_list.add(line); 
				             }  
				       } catch (IOException e) {
				            e.printStackTrace();  
				       }  
				       finally{ 
				            try {  
				            	out_str.close();  
				            } catch (IOException e) {  
				               e.printStackTrace();  
				           }  
				         }  
				       }  
				    };
			 read_log.start();
			 boolean  exit_status = p.waitFor((long)timeout, TimeUnit.SECONDS); 
			 String reason = new String("");
			 Boolean TBD_flag = false;
			 Iterator<String> line_it = string_list.iterator();
			 while (line_it.hasNext()) {
			        String line = line_it.next();
			        if(line.toLowerCase().startsWith("error"))
			        	reason = line;
			        else if(line.indexOf("##CR_NOTE_BEGIN##")>0)
			        	TBD_flag = true;
			        else if(line.indexOf("#CR_NOTE_END#")>0)
			        	TBD_flag = false;
			        else if(TBD_flag)
			        	reason = line;			        
			}
			if (exit_status){
				int exit_value = p.exitValue();
				if (exit_value == 0){
					string_list.add("<status>Passed</status>"); 
				} else if (exit_value == 1) {
					string_list.add("<status>Failed</status>");
				} else{
					string_list.add("<status>TBD</status>");
				}
				if(reason.length()>1)
					string_list.add("<reason>"+reason.trim()+"</reason>"); 
			} else{
				string_list.add("<status>Timeout</status>"); 
				string_list.add("<reason>Timeout</reason>"); 
				System.out.println(">>>Info: Clean up, timeout task cleanup.");
				p.destroyForcibly();
			}
		 } catch (IOException e) {
		    //e.printStackTrace();
		    string_list.add("<status>Failed</status>"); 
		    string_list.add("<reason>"+"Can not launch command"+"</reason>"); 
		 } finally {
			 if (p != null)
				 p.destroyForcibly();
		 }
		return string_list;
	}
	
}

class StreamGobbler
extends Thread
{
//static private Log log = LogFactory.getLog(StreamGobbler.class);
private InputStream inputStream;
private String streamType;
private boolean displayStreamOutput;
private final StringBuffer inputBuffer = new StringBuffer();
private ArrayList<String> outputStringList =new ArrayList<String>();
private boolean keepGobbling = true;

/**
 * Constructor.
 * 
 * @param inputStream the InputStream to be consumed
 * @param streamType the stream type (should be OUTPUT or ERROR)
 * @param displayStreamOutput whether or not to display the output of the stream being consumed
 */
StreamGobbler(final InputStream inputStream,
              			final String streamType,
              			final boolean displayStreamOutput)
{
    this.inputStream = inputStream;
    this.streamType = streamType;
    this.displayStreamOutput = displayStreamOutput;
}

/**
 * Returns the output stream of the
 * 
 * @return
 */
public String getInput()
{
    return inputBuffer.toString();
}

/**
 * Returns the output stream of the
 * 
 * @return
 */
public ArrayList<String> getOutputList()
{
    return outputStringList;
}

/**
 * Consumes the output from the input stream and displays the lines consumed if configured to do so.
 */
public void run()
{
    InputStreamReader inputStreamReader = new InputStreamReader(inputStream);
    BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
    try
    {
        String line = null;
        while (keepGobbling && ((line = bufferedReader.readLine()) != null))
        {
            inputBuffer.append(line);
            outputStringList.add(line);
            if (displayStreamOutput)
            {
                System.out.println(streamType + ">" + line);
                System.out.flush(); 
            }
        }
    }
    catch (IOException ex)
    {
        //log.error("Failed to successfully consume and display the input stream of type " + streamType + ".", ex);
        ex.printStackTrace();
    }
    finally
    {
        try
        {
            bufferedReader.close();
            inputStreamReader.close();
        }
        catch (IOException e)
        {
            // swallow it
        }
    }
}

public void stopGobbling()
{
    keepGobbling = false;
}
}

class run_case implements Callable<Object> {
	private String case_dir;
	private String [] cmds;
	private Map<String, String> envs;
	private int timeout = 0;
	
	run_case(String[] cmds, Map<String, String> envs){
	    this.cmds = cmds;
	    this.envs = envs;
	}
	run_case(String[] cmds, Map<String, String> envs,String case_dir, int timeout){
	    this.cmds = cmds;
	    this.envs = envs;
	    this.case_dir = case_dir;
	    this.timeout = timeout;
	}
	
	public Object call() throws Exception {
		    ArrayList<String> string_list = new ArrayList<>();
            if(this.case_dir!= null && !this.case_dir.isEmpty())
			    string_list = execute_system_cmd.run(cmds,envs,case_dir, timeout);
		    else
			    string_list = execute_system_cmd.run(cmds,envs);
            if (case_dir == null){
            	file_action.append_file("log/run.log",string_list.toString());
            } else {
            	String local_rpt_path = case_dir + "/" + publicData.case_rpt;
            	file_action.append_file(local_rpt_path, publicData.line_separator);
            	file_action.append_file(local_rpt_path, "[Run]" + publicData.line_separator);
            	file_action.append_file(local_rpt_path, ">>>Eev set:" + publicData.line_separator);
            	Set<String> env_set =  envs.keySet();
            	Iterator <String> env_it = env_set.iterator();
            	while(env_it.hasNext()){
            		String env_key = env_it.next();
            		String env_value = envs.get(env_key);
            		file_action.append_file(local_rpt_path, "Eev variable: " + env_key + " = " + env_value+ " " + publicData.line_separator);
            	}
            	file_action.append_file(local_rpt_path, ">>>Case run:" + publicData.line_separator);
            	for(String line: string_list)
            		file_action.append_file(local_rpt_path, line + publicData.line_separator);
            }
		    return string_list;
		}
}
