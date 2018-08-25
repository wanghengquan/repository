package env_monitor;

import data_center.public_data;
import data_center.switch_data;
import utility_funcs.system_cmd;

import java.io.IOException;
import java.util.ArrayList;
import java.util.regex.*;

public class dev_check extends Thread {
    private switch_data switch_info;
    private String core_addr;
    private String core_UUID = new String("");
    private String svn_user = public_data.SVN_USER;
    private String svn_pwd = public_data.SVN_PWD;

    public dev_check(switch_data switch_info) {
        this.switch_info = switch_info;
        this.core_addr = public_data.CORE_SCRIPT_ADDR;
        this.core_UUID = getCore_UUID();
    }

    public void run() {
        while (true) {
            try {
                Thread.sleep(5 * 1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            check_dev_need_update(switch_info);
        }
    }

    private String getCore_UUID()
    {
        try {
            String svn_info = "svn info " + core_addr +  " --username="
                                + svn_user + " --password=" + svn_pwd + " --no-auth-cache";
            ArrayList<String> info_return = system_cmd.run(svn_info);
            for(String revision:info_return) {
                String uuid = get_revision(revision);
                if (!uuid.equals("not found")) {
                    return uuid;
                }
            }
        }catch (InterruptedException e) {
            e.printStackTrace();
        }catch (IOException e){
            e.printStackTrace();
        }
        return core_UUID;
    }

    private String get_revision(String revision)
    {
        String pattern = ".+?:\\s+(\\d+)$";
        Pattern r = Pattern.compile(pattern);
        Matcher m = r.matcher(revision);
        if(m.find())
        {
            return m.group(1);
        }
        else{
            return "not found";
        }
    }

    private void check_dev_need_update(switch_data switch_info)
    {
        String new_version = getCore_UUID();
        if (!core_UUID.equals(new_version)) {
            System.out.println("INFO : >>>current Core script version(DEV) is: " + core_UUID);
            System.out.println("INFO : >>>new Core script version(DEV) found: " + new_version);
            core_UUID = new_version;
            switch_info.set_dev_need_update();
            while(!switch_info.dev_update_done());
            System.out.println("INFO : >>>Update DEV completed!");
        }
    }

    public static void main(String[] argvs)
    {
        dev_check dc = new dev_check(null);
        System.out.println(dc.core_UUID);
    }
}

