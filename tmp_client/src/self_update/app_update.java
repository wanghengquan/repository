/*
 * File: app_update.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/05/3
 * Modifier:
 * Date:
 * Description:
 */
package self_update;


import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.panayotis.jupidator.UpdatedApplication;
import com.panayotis.jupidator.Updater;
import com.panayotis.jupidator.UpdaterException;

import data_center.client_data;
import data_center.public_data;
import data_center.switch_data;


public class app_update implements UpdatedApplication  {
	// public property
	// protected property
	// private property
	//private static final Logger TMP_MANAGER_LOGGER = LogManager.getLogger(tmp_manager.class.getName());
	private static final Logger APP_UPDATE_LOGGER = LogManager.getLogger(app_update.class.getName()); 
	//private String line_separator = System.getProperty("line.separator");	
	private switch_data switch_info;
	private client_data client_info;	
	// public function
	// protected function
	// private function	
	
	public app_update (client_data client_info, switch_data switch_info){
		this.client_info = client_info;
		this.switch_info = switch_info;
	}
	
	public Boolean gui_manual_update(){
        try {
        	Updater app_update =  new Updater(
                    public_data.UPDATE_URL,
                    public_data.SW_HOME_PATH,
                    public_data.BASE_CURRENTVERSION_INT,
                    public_data.BASE_CURRENTVERSION,
                    this,
                    false,
                    false);
        	app_update.actionDisplay();
        	try {
				Thread.sleep(50);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        	if(app_update.isUpdateSkip()){
        		return false;
        	}
        } catch (UpdaterException ex) {
            ex.printStackTrace();
            APP_UPDATE_LOGGER.warn("TMP client self update failed.");
        }
        return true;
	}
	
	public void smart_update(){
		String user_interface = client_info.get_client_data().get("preference").get("cmd_gui");
		String unattended_mode = client_info.get_client_data().get("Machine").get("unattended");
		Boolean console_update = new Boolean(false); 
		if (user_interface.equalsIgnoreCase("cmd")){ 
			console_update = true; 
			switch_info.set_client_console_updating(true);
		} 
		Boolean unattended_update = new Boolean(false);
		if (unattended_mode.equalsIgnoreCase("1")){ 
			unattended_update = true; 
		} 		
        try {
        	Updater app_update =  new Updater(
                    public_data.UPDATE_URL,
                    public_data.SW_HOME_PATH,
                    public_data.BASE_CURRENTVERSION_INT,
                    public_data.BASE_CURRENTVERSION,
                    this,
                    unattended_update,
                    console_update);
        	app_update.actionDisplay();
        } catch (UpdaterException ex) {
            ex.printStackTrace();
            switch_info.set_client_console_updating(false);
            APP_UPDATE_LOGGER.warn("TMP client self update failed.");
        }
	}
	
	@Override
	public void receiveMessage(String message) {
		// TODO Auto-generated method stub
		APP_UPDATE_LOGGER.warn(message);
	}

	@Override
	public boolean requestRestart() {
		switch_info.set_client_console_updating(false);
		return true;
	}
	
	/*
	 * main entry for test
	 */
	public static void main(String[] args) {
		
	}
}