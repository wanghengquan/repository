/*
 * File: system_cmd.java
 * Description: run system command line
 * Author: Jason.Wang
 * Date:2017/02/15
 * Modifier:
 * Date:
 * Description:
 */
package utility_funcs;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class system_cmd {
	// public property
	// protected property
	// private property
	private static final Logger SYSTEM_CMD_LOGGER = LogManager.getLogger(system_cmd.class.getName());

	public system_cmd() {

	}

	// run0 command single string, export case, scripts
	public static ArrayList<String> run(
			String cmd) throws IOException, InterruptedException {
		/*
		 * a command line will be execute.
		 */
		SYSTEM_CMD_LOGGER.debug("Run CMD: " + cmd);
		ArrayList<String> string_list = new ArrayList<String>();
		string_list.add(cmd);
		String[] cmd_list = cmd.split("\\s+");
		ProcessBuilder proce_build = new ProcessBuilder(cmd_list);
		proce_build.redirectErrorStream(true);
		Process process = proce_build.start();
		InputStream out_str = process.getInputStream();
		StreamGobbler read_out = new StreamGobbler(out_str, "OUTPUT", false);
		read_out.start();
		process.waitFor((long) 5*60, TimeUnit.SECONDS);
		Thread.sleep(10);//wait for some time to make the output ready
		string_list.addAll(read_out.getOutputList());
		string_list.add("Exit Code:" + process.exitValue());
		Thread.sleep(1);
		read_out.stopGobbling();
		SYSTEM_CMD_LOGGER.debug("Exit Code:" + process.exitValue());
		SYSTEM_CMD_LOGGER.debug("Exit String:" + string_list);
		process.destroy();
		return string_list;
	}
	
	// run1 run command with in 60 seconds
	public static ArrayList<String> run(
			String cmd, 
			String work_path) throws IOException {
		/*
		 * a command line will be execute.
		 */
		ArrayList<String> string_list = new ArrayList<String>();
		SYSTEM_CMD_LOGGER.debug("Run CMD: " + cmd);
		string_list.add("Run CMD: " + cmd);
		String[] cmd_list = cmd.split("\\s+");
		ProcessBuilder proce_build = new ProcessBuilder(cmd_list);
		proce_build.redirectErrorStream(true);
		File run_dir = new File(work_path);
		if (!run_dir.exists()) {
			string_list.add("Run Dir not exists : " + work_path);
			return string_list;
		}
		proce_build.directory(run_dir);
		Process process = proce_build.start();
		InputStream fis = process.getInputStream();
		BufferedReader bri = new BufferedReader(new InputStreamReader(fis));
		String line = null;
		while ((line = bri.readLine()) != null) {
			string_list.add(line);
		}
		bri.close();
		try {
			process.waitFor((long) 1*60, TimeUnit.SECONDS);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			SYSTEM_CMD_LOGGER.error("Run cmd Interrupted: " + cmd);
		} catch (Exception e2) {
			SYSTEM_CMD_LOGGER.error("Run cmd failed: " + e2.toString());
		}
		SYSTEM_CMD_LOGGER.debug("Exit Code:" + process.exitValue());
		SYSTEM_CMD_LOGGER.debug("Exit String:" + string_list);
		process.destroy();
		return string_list;
	}	

	// run2 command with environment
	public static ArrayList<String> run(
			String[] cmds, 
			Map<String, String> envs) throws InterruptedException {
		/*
		 * This function used to run command in another way: ProcessBuilder
		 */
		ArrayList<String> string_list = new ArrayList<String>();
		string_list.add("run cmd:" + Arrays.toString(cmds).replaceAll("[\\[\\]\\s,]", " "));
		string_list.add("run env:" + envs.toString());
		ProcessBuilder pb = new ProcessBuilder(cmds);
		Map<String, String> env = pb.environment();
		env.putAll(envs);
		try {
			Process p = pb.start();
			InputStream fis = p.getInputStream();
			BufferedReader br = new BufferedReader(new InputStreamReader(fis));
			String line = null;
			String reason = new String("");
			string_list.add("run rst:");
			while ((line = br.readLine()) != null) {
				// System.out.println(line);
				string_list.add(line);
				if (line.trim().toLowerCase().startsWith("error"))
					reason = line;
			}
			br.close();
			int exit_value = p.waitFor();
			if (exit_value == 0) {
				string_list.add("<status>Passed</status>");
			} else if (exit_value == 1) {
				string_list.add("<status>Failed</status>");	
			} else if (exit_value == 2) {
				string_list.add("<status>TBD</status>");					
			} else if (exit_value == 200) {
				string_list.add("<status>Passed</status>");				
			} else if (exit_value == 201) {
				string_list.add("<status>Failed</status>");
			} else if (exit_value == 202) {
				string_list.add("<status>TBD</status>");
			} else if (exit_value == 203) {
				string_list.add("<status>Case_Issue</status>");
			} else if (exit_value == 204) {
				string_list.add("<status>SW_Issue</status>");
			} else {
				string_list.add("<status>Blocked</status>");
			}
			if (reason.length() > 1)
				string_list.add("<reason>" + reason.trim() + "</reason>");
		} catch (IOException e) {
			// e.printStackTrace();
			string_list.add("<status>Failed</status>");
			string_list.add("<reason>" + "Can not launch command" + "</reason>");
		}
		return string_list;
	}

	// run3 command with environment for a specific case
	public static ArrayList<String> run(
			String[] cmds, 
			Map<String, String> envs, 
			String directory, 
			int timeout) throws IOException, InterruptedException {
		/*
		 * This function used to run command in another way: ProcessBuilder
		 */
		ArrayList<String> string_list = new ArrayList<String>();
		string_list.add("Environments :" + envs.toString());
		string_list.add("LaunchCommand:" + String.join(" ", cmds));
		string_list.add("LaunchDir:" + directory);
		ProcessBuilder pb = new ProcessBuilder(cmds);
		pb.redirectErrorStream(true);
		File run_dir = new File(directory);
		if (run_dir.exists()) {
			pb.directory(run_dir);
		}
		Map<String, String> env = pb.environment();
		env.putAll(envs);
		Process p = pb.start();
		InputStream out_str = p.getInputStream();
		StreamGobbler read_out = new StreamGobbler(out_str, "OUTPUT", false);
		read_out.start();
		boolean exit_status = p.waitFor((long) timeout, TimeUnit.SECONDS);
		Thread.sleep(10);//wait for some time to make the output ready
		string_list.addAll(read_out.getOutputList());
		Thread.sleep(1);
		read_out.stopGobbling();
		if (exit_status) {
			int exit_value = p.exitValue();
			if (exit_value == 0) {
				string_list.add("<status>Passed</status>");
			} else if (exit_value == 1) {
				string_list.add("<status>Failed</status>");	
			} else if (exit_value == 2) {
				string_list.add("<status>TBD</status>");					
			} else if (exit_value == 200) {
				string_list.add("<status>Passed</status>");				
			} else if (exit_value == 201) {
				string_list.add("<status>Failed</status>");
			} else if (exit_value == 202) {
				string_list.add("<status>TBD</status>");
			} else if (exit_value == 203) {
				string_list.add("<status>Case_Issue</status>");
			} else if (exit_value == 204) {
				string_list.add("<status>SW_Issue</status>");
			} else {
				string_list.add("<status>Blocked</status>");
			}
		} else {
			SYSTEM_CMD_LOGGER.warn("Timeout task cleanup.");
			string_list.add("<status>Timeout</status>");
			string_list.add("<reason>Timeout</reason>");
			p.destroyForcibly();
		}
		// Start processing return string list
		Iterator<String> line_it = string_list.iterator();
		String reason = new String();
		Boolean TBD_flag = new Boolean(false);
		while (line_it.hasNext()) {
			String line = line_it.next();
			if (line.toLowerCase().startsWith("error"))
				reason = line;
			else if (line.indexOf("##CR_NOTE_BEGIN##") > 0)
				TBD_flag = true;
			else if (line.indexOf("#CR_NOTE_END#") > 0)
				TBD_flag = false;
			else if (TBD_flag)
				reason = line;
		}
		if (reason.length() > 1)
			string_list.add("<reason>" + reason.trim() + "</reason>");
		return string_list;
	}

	// run4 command with environment for a specific case
	public static ArrayList<String> run4(
			String[] cmds, 
			Map<String, String> envs, 
			String directory, 
			int timeout) throws InterruptedException {
		/*
		 * This function used to run command in another way: ProcessBuilder
		 */
		ArrayList<String> string_list = new ArrayList<String>();
		string_list.add(Arrays.toString(cmds).replaceAll("[\\[\\]\\s,]", " "));
		ProcessBuilder pb = new ProcessBuilder(cmds);
		pb.redirectErrorStream(true);
		try {
			pb.directory(new File(directory));
		} catch (Exception e) {
			string_list.add("Error:Can not find directory:" + directory + "\n");
		}
		Map<String, String> env = pb.environment();
		env.putAll(envs);
		Process p = null;
		try {
			p = pb.start();
			InputStream out_str = p.getInputStream();
			BufferedReader br1 = new BufferedReader(new InputStreamReader(out_str));
			// thread1 read output stream
			Thread read_log = new Thread() {
				public void run() {
					try {
						String line = null;
						while ((line = br1.readLine()) != null) {
							string_list.add(line);
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
			boolean exit_status = p.waitFor((long) timeout, TimeUnit.SECONDS);
			String reason = new String("");
			Boolean TBD_flag = false;
			Iterator<String> line_it = string_list.iterator();
			while (line_it.hasNext()) {
				String line = line_it.next();
				if (line.toLowerCase().startsWith("error"))
					reason = line;
				else if (line.indexOf("##CR_NOTE_BEGIN##") > 0)
					TBD_flag = true;
				else if (line.indexOf("#CR_NOTE_END#") > 0)
					TBD_flag = false;
				else if (TBD_flag)
					reason = line;
			}
			if (exit_status) {
				int exit_value = p.exitValue();
				if (exit_value == 0) {
					string_list.add("<status>Passed</status>");
				} else if (exit_value == 1) {
					string_list.add("<status>Failed</status>");	
				} else if (exit_value == 2) {
					string_list.add("<status>TBD</status>");					
				} else if (exit_value == 200) {
					string_list.add("<status>Passed</status>");				
				} else if (exit_value == 201) {
					string_list.add("<status>Failed</status>");
				} else if (exit_value == 202) {
					string_list.add("<status>TBD</status>");
				} else if (exit_value == 203) {
					string_list.add("<status>Case_Issue</status>");
				} else if (exit_value == 204) {
					string_list.add("<status>SW_Issue</status>");
				} else {
					string_list.add("<status>Blocked</status>");
				}
				if (reason.length() > 1)
					string_list.add("<reason>" + reason.trim() + "</reason>");
			} else {
				string_list.add("<status>Timeout</status>");
				string_list.add("<reason>Timeout</reason>");
				System.out.println(">>>Info: Clean up, timeout task cleanup.");
				p.destroyForcibly();
			}
		} catch (IOException e) {
			// e.printStackTrace();
			string_list.add("<status>Failed</status>");
			string_list.add("<reason>" + "Can not launch command" + "</reason>");
		} finally {
			if (p != null)
				p.destroyForcibly();
		}
		return string_list;
	}

	public static void main(String[] args) throws Exception {
		String cmd = "svn --version ";
		System.out.println(cmd);
		//HashMap<String, String> envs = new HashMap<String, String>();
		//envs.put("EXTERNAL_DIAMOND_PATH", "C:/lscc/diamond/3.9_x64");
		//envs.put("PYTHONUNBUFFERED", "1");
		ArrayList<String> list = run(cmd);
		System.out.println(list.toString());
	}
}

class StreamGobbler extends Thread {
	// static private Log log = LogFactory.getLog(StreamGobbler.class);
	private InputStream inputStream;
	private String streamType;
	private boolean displayStreamOutput;
	private final StringBuffer inputBuffer = new StringBuffer();
	private ArrayList<String> outputStringList = new ArrayList<String>();
	private boolean keepGobbling = true;

	/**
	 * Constructor.
	 * 
	 * @param inputStream
	 *            the InputStream to be consumed
	 * @param streamType
	 *            the stream type (should be OUTPUT or ERROR)
	 * @param displayStreamOutput
	 *            whether or not to display the output of the stream being
	 *            consumed
	 */
	StreamGobbler(final InputStream inputStream, final String streamType, final boolean displayStreamOutput) {
		this.inputStream = inputStream;
		this.streamType = streamType;
		this.displayStreamOutput = displayStreamOutput;
	}

	/**
	 * Returns the output stream of the
	 * 
	 * @return
	 */
	public String getInput() {
		return inputBuffer.toString();
	}

	/**
	 * Returns the output stream of the
	 * 
	 * @return
	 */
	public ArrayList<String> getOutputList() {
		return outputStringList;
	}

	/**
	 * Consumes the output from the input stream and displays the lines consumed
	 * if configured to do so.
	 */
	public void run() {
		InputStreamReader inputStreamReader = new InputStreamReader(inputStream);
		BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
		try {
			String line = null;
			while (keepGobbling && ((line = bufferedReader.readLine()) != null)) {
				inputBuffer.append(line);
				outputStringList.add(line);
				if (displayStreamOutput) {
					System.out.println(streamType + ">" + line);
					System.out.flush();
				}
			}
		} catch (IOException ex) {
			// log.error("Failed to successfully consume and display the input
			// stream of type " + streamType + ".", ex);
			ex.printStackTrace();
		} finally {
			try {
				bufferedReader.close();
				inputStreamReader.close();
			} catch (IOException e) {
				// swallow it
				e.printStackTrace();
			}
		}
	}

	public void stopGobbling() {
		keepGobbling = false;
	}
}
