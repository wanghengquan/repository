package env_monitor;

import java.io.*;
import java.util.Date;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/*
 * PlatUML graph
 * @startuml
 * :Hello world;
 * :This is on defined on
 * several **lines**;
 * @enduml
 */
public class kill_winpop extends Thread {
	// public property
	// protect property
	// private property
	private String run_file = new String();
	private static final Logger KILL_LOGGER = LogManager.getLogger(kill_winpop.class.getName());

	public kill_winpop(String file_path) {
		this.run_file = file_path;
	}

	public void run() {
		while (true) {
			try {
				Thread.sleep(10 * 1000);
			} catch (InterruptedException e) {
				KILL_LOGGER.warn("InterruptedException error");
			}
			String run_cmd = "python " + run_file;
			Process process = null;
			try {
				process = Runtime.getRuntime().exec(run_cmd);
				InputStream fis = process.getInputStream();
				BufferedReader br = new BufferedReader(new InputStreamReader(fis));
				String line = null;
				StringBuffer cmdout = new StringBuffer();
				while ((line = br.readLine()) != null) {
					if (line.contains("sleep")) {
						continue;
					} else {
						cmdout.append(line);
					}
				}
				br.close();
				process.destroy();
				if (cmdout.length() > 1) {
					KILL_LOGGER.warn(cmdout.toString());
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				KILL_LOGGER.error("kill winpop run error");
			}
		}
	}

	public static void main(String[] args) {
		kill_winpop my_test = new kill_winpop("tools/kill_winpop.py");
		my_test.start();
	}
}