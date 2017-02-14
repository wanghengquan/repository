package env_monitor;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Date;

import javax.swing.JOptionPane;

import utility_funcs.file_action;

public class killPop extends Thread {
	public void run_lab() {
		/*
		 * This function used for test
		 */
		while (true){
			JOptionPane.showMessageDialog(null, "A NI YA SHA O!");
			try {
				Thread.sleep(3*1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				System.out.println("Can not sleep");
			}
		}
	}
	public void run() {
		while (true){
			//JOptionPane.showMessageDialog(null, "A NI YA SHA O!");
			try {
				Thread.sleep(10*1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				//System.out.println("Can not sleep");
				Date dt=new Date();
		 	    String localeString=dt.toString();
				file_action.print_out_to_file_to_gui("In killPop\n"+localeString+"\nCan not to sleep");
			}
			//System.out.println("beign to try exec");
			String popString = "conf/kill_pop_window.py";
			Process process;
			try {
				process = Runtime.getRuntime().exec("python "+popString);
				InputStream fis = process.getInputStream();
			    BufferedReader br = new BufferedReader(new InputStreamReader(fis));
			    String line = null;
			    StringBuffer cmdout = new StringBuffer();
			    while ((line = br.readLine()) != null) {
			        cmdout.append(line).append(System.getProperty("line.separator"));
			    }
			    br.close();
			    process.destroy();
			    //System.out.print(cmdout.toString().trim());
			    //at here we need to save the output to the killpop file
			    file_action.append_file("log/client_kill_pop.txt", cmdout.toString());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				Date dt=new Date();
		 	    String localeString=dt.toString();
				file_action.print_out_to_file_to_gui("In killPop\n"+localeString+"\nWhen run python,can not to run");
				
			} // ִ��һ��ϵͳ����
		    
		}
		}
	
	public static void main(String[] args){
	    System.out.println("haha");
	}
	}