package env_monitor;

import java.io.*;
import java.util.Timer;
import java.util.TimerTask;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import data_center.exit_enum;
import data_center.public_data;
import data_center.switch_data;

/*
 * PlatUML graph
 * @startuml
 * :Hello world;
 * :This is on defined on
 * several **lines**;
 * @enduml
 */
public class kill_winpop extends TimerTask {
	// public property
	// protect property
	// private property
	private switch_data switch_info;
	private String run_file = new String();
	private static final Logger KILL_LOGGER = LogManager.getLogger(kill_winpop.class.getName());

	public kill_winpop(switch_data switch_info) {
		this.switch_info = switch_info;
		this.run_file = public_data.TOOLS_KILL_WINPOP;
	}

	public void run() {
		try {
			monitor_run();
		} catch (Exception run_exception) {
			run_exception.printStackTrace();
			switch_info.set_client_stop_exception(run_exception);
			switch_info.set_client_stop_request(exit_enum.DUMP);
		}
	}
	
	private void monitor_run() {
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

	public static void main(String[] args) {
		Timer my_timer = new Timer();
		my_timer.scheduleAtFixedRate(new kill_winpop(null), 1000, 1000);
	}
}