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
	public Boolean update_skipped = new Boolean(false);
	// public function
	// protected function
	// private function	
	
	public app_update (client_data client_info, switch_data switch_info){
		this.client_info = client_info;
		this.switch_info = switch_info;
	}
	
	public void gui_manual_update(){
		String stable_version = new String(public_data.DEF_STABLE_VERSION);
		if(client_info.get_client_preference_data() != null){
			stable_version = client_info.get_client_preference_data().getOrDefault("stable_version", public_data.DEF_STABLE_VERSION);
		}
		String update_path = new String(public_data.UPDATE_URL);
		if(stable_version.equals("0")){
			update_path = public_data.UPDATE_URL_DEV;
		}
        try {
        	Updater app_update =  new Updater(
        			update_path,
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
        	update_skipped = app_update.isUpdateSkip();
        	if(update_skipped){
        		switch_info.set_client_console_updating(false);
        	}        	
        } catch (UpdaterException ex) {
            //ex.printStackTrace();
            APP_UPDATE_LOGGER.warn("TMP client self update failed from : " + update_path);
        }
	}
	
	public void smart_update(){
		//stable version
		String stable_version = new String(public_data.DEF_STABLE_VERSION);
		if(client_info.get_client_preference_data() != null){
			stable_version = client_info.get_client_preference_data().getOrDefault("stable_version", public_data.DEF_STABLE_VERSION);
		}
		String update_path = new String(public_data.UPDATE_URL);
		if(stable_version.equals("0")){
			update_path = public_data.UPDATE_URL_DEV;
		}		
		// user_interface gui or cmd and attended or unattended
		String user_interface = client_info.get_client_preference_data().get("cmd_gui");
		String unattended_mode = client_info.get_client_machine_data().get("unattended");		
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
        			update_path,
                    public_data.SW_HOME_PATH,
                    public_data.BASE_CURRENTVERSION_INT,
                    public_data.BASE_CURRENTVERSION,
                    this,
                    unattended_update,
                    console_update);
        	app_update.actionDisplay();
        	try {
				Thread.sleep(50);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}        	
        	update_skipped = app_update.isUpdateSkip();
        	if(update_skipped){
        		switch_info.set_client_console_updating(false);
        	}
        } catch (Exception ex) {
            //ex.printStackTrace();
            switch_info.set_client_console_updating(false);
            APP_UPDATE_LOGGER.warn("TMP client self update failed from : " + update_path);
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