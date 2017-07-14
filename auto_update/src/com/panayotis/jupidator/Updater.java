/*
 *
 * This file is part of Jupidator.
 *
 * Jupidator is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 2.
 *
 *
 * Jupidator is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Jupidator; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */

package com.panayotis.jupidator;

import com.panayotis.jupidator.data.SimpleApplication;
import com.panayotis.jupidator.data.TextUtils;
import com.panayotis.jupidator.data.Version;
import com.panayotis.jupidator.elements.FileUtils;
import com.panayotis.jupidator.elements.security.PermissionManager;
import com.panayotis.jupidator.gui.JupidatorGUI;
import com.panayotis.jupidator.gui.UpdateWatcher;
import com.panayotis.jupidator.gui.console.ConsoleGUI;
import com.panayotis.jupidator.gui.console_force.ForceConsole;
import com.panayotis.jupidator.gui.swing.SwingGUI;
import com.panayotis.jupidator.gui.swing_force.ForceGUI;
import com.panayotis.jupidator.loglist.creators.HTMLCreator;
import com.panayotis.jupidator.versioning.SystemVersion;
import java.awt.GraphicsEnvironment;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import jupidator.launcher.DeployerParameters;
import jupidator.launcher.XElement;

import static com.panayotis.jupidator.i18n.I18N._;

/**
 *
 * @author teras
 */
public class Updater {

    // The host information - the application that started the update
    private Version hostVersion;
    private ApplicationInfo hostInfo;
    // The current version - could be either the application that started the update or Jupidator itself
    private Version curVersion;
    private ApplicationInfo curInfo;
    private UpdatedApplication application;
    private Thread download;
    /* Lazy components */
    private JupidatorGUI gui;
    private UpdateWatcher watcher;
    private ProcessBuilder procbuilder;
    //jason added
    private Boolean unattended_mode = false;
    private Boolean console_mode = false;
    private Boolean update_skipped = false;

    public Updater(String xmlurl, String appHome, UpdatedApplication application) throws UpdaterException {
        this(xmlurl, new ApplicationInfo(appHome), application);
    }

    @Deprecated
    public Updater(String xmlurl, String appHome, String appSupportDir, UpdatedApplication application) throws UpdaterException {
        this(xmlurl, new ApplicationInfo(appHome), application);
    }

    @Deprecated
    public Updater(String xmlurl, String appHome, String appSupportDir, int release, String version, UpdatedApplication application) throws UpdaterException {
        this(xmlurl, new ApplicationInfo(appHome, release, version), application);
    }

    public Updater(String xmlurl, String appHome, int release, String version, UpdatedApplication application) throws UpdaterException {
        this(xmlurl, new ApplicationInfo(appHome, release, version), application);
    }

    public Updater(String xmlurl, String appHome, int release, String version, UpdatedApplication application, Boolean unattended_mode, Boolean console_mode) throws UpdaterException {
        this(xmlurl, new ApplicationInfo(appHome, release, version), application, unattended_mode, console_mode);
    }    
    
    @Deprecated
    public Updater(String xmlurl, String appHome, String appSupportDir, String release, String version, UpdatedApplication application) throws UpdaterException {
        this(xmlurl, new ApplicationInfo(appHome, TextUtils.getInt(release, 0), version), application);
    }

    public Updater(String xmlurl, ApplicationInfo appinfo, UpdatedApplication application) throws UpdaterException {
        curInfo = hostInfo = appinfo;
        hostVersion = curVersion = Version.loadVersion(xmlurl, appinfo);
        this.application = application == null ? new SimpleApplication() : application;
        if (curVersion.getAppElements().shouldUpdateLibrary()) {
            String oldname = curVersion.getAppElements().getAppName();
            ApplicationInfo selfappinfo = ApplicationInfo.getSelfInfo(FileUtils.getClassHome(Updater.class));
            selfappinfo.setSelfUpdate();

            Version selfvers = Version.loadVersion(SystemVersion.URL, selfappinfo);
            if (!selfvers.isEmpty()) {
                selfvers.replaceArch(curVersion.getArch());
                curInfo = selfappinfo;
                curVersion = selfvers;
                curVersion.getAppElements().setSelfUpdate(oldname);
                curVersion.getAppElements().setApplicationInfo(_("This update is required for the smooth updating of {0}", oldname));
            }
        }
    }

    public Updater(String xmlurl, ApplicationInfo appinfo, UpdatedApplication application, Boolean unattended_mode, Boolean console_mode) throws UpdaterException {
    	this.unattended_mode = unattended_mode;
    	this.console_mode = console_mode;
        curInfo = hostInfo = appinfo;
        hostVersion = curVersion = Version.loadVersion(xmlurl, appinfo);
        this.application = application == null ? new SimpleApplication() : application;
        if (curVersion.getAppElements().shouldUpdateLibrary()) {
            String oldname = curVersion.getAppElements().getAppName();
            ApplicationInfo selfappinfo = ApplicationInfo.getSelfInfo(FileUtils.getClassHome(Updater.class));
            selfappinfo.setSelfUpdate();

            Version selfvers = Version.loadVersion(SystemVersion.URL, selfappinfo);
            if (!selfvers.isEmpty()) {
                selfvers.replaceArch(curVersion.getArch());
                curInfo = selfappinfo;
                curVersion = selfvers;
                curVersion.getAppElements().setSelfUpdate(oldname);
                curVersion.getAppElements().setApplicationInfo(_("This update is required for the smooth updating of {0}", oldname));
            }
        }
    }
    
    public static Updater start(String xmlurl, String appHome, UpdatedApplication application) {
        return start(xmlurl, new ApplicationInfo(appHome), application, null);
    }

    @Deprecated
    public static Updater start(String xmlurl, String appHome, String appSupportDir, UpdatedApplication application) {
        return start(xmlurl, new ApplicationInfo(appHome), application, null);
    }

    public static Updater start(String xmlurl, String appHome, int release, String version, UpdatedApplication application) {
        return start(xmlurl, new ApplicationInfo(appHome, release, version), application, null);
    }

    @Deprecated
    public static Updater start(String xmlurl, String appHome, String appSupportDir, int release, String version, UpdatedApplication application) {
        return start(xmlurl, new ApplicationInfo(appHome, release, version), application, null);
    }

    public static Updater start(String xmlurl, ApplicationInfo appinfo, UpdatedApplication application, JupidatorGUI gui) {
        try {
            Updater up = new Updater(xmlurl, appinfo, application);
            if (gui != null)
                up.setGUI(gui);
            up.actionDisplay();
            return up;
        } catch (UpdaterException ex) {
            return null;
        }
    }

    /**
     * Return JupidatorGUI, and create it if it does not exist. This is the
     * official method to create the default GUI GUI is created lazily, when
     * needed
     */
    public JupidatorGUI getGUI() {
        if (gui == null){
        	if(unattended_mode){
        		if (console_mode)
        			gui = new ForceConsole();
        		else
        			gui = new ForceGUI();
        	} else {
        		if (console_mode)
        			gui = new ConsoleGUI();
        		else
        			gui = new SwingGUI();
        	}
        }
        return gui;
    }

    public void setGUI(JupidatorGUI gui) {
        if (gui != null)
            this.gui = gui;
    }

    public void actionDisplay() throws UpdaterException {
    	
        if (!curVersion.isEmpty()) {
            PermissionManager.manager.estimatePrivileges(new File(curInfo.getApplicationHome() + File.separator + AppVersion.FILETAG));
            getGUI();  /* GUI is created lazily, when needed (very important) */
            watcher = new UpdateWatcher(); /* Watcher is also created lazily, when needed */
            watcher.setCallBack(gui);
            gui.setInformation(this, curVersion.getAppElements(), curInfo);
            gui.startDialog();
        } else {
        	System.out.println(">>>Skip update.");
        	update_skipped = true;
        }
    }

    public void actionCommit() {
        long size = 0;
        for (String key : curVersion.keySet())
            size += curVersion.get(key).getSize();
        watcher.setAllBytes(size);
        download = new Thread() {
            @Override
            public void run() {
                /* Fetch */
                for (String key : curVersion.keySet()) {
                    String result = curVersion.get(key).fetch(application, watcher);
                    if (result != null) {
                        watcher.stopWatcher();
                        application.receiveMessage(result);
                        gui.errorOnCommit(result);
                        return;
                    }
                }
                /* Prepare */
                watcher.stopWatcher();
                gui.setIndetermined();
                for (String key : curVersion.keySet()) {
                    String result = curVersion.get(key).prepare(application);
                    if (result != null) {
                        application.receiveMessage(result);
                        gui.errorOnCommit(result);
                        return;
                    }
                }

                /* Construct launcher parameters */
                ArrayList<XElement> elements = new ArrayList<XElement>();
                for (String key : curVersion.keySet())
                    elements.add(curVersion.get(key).getExecElement());

                /* relaunch should be performed with original arguments, not jupidator update */
                ArrayList<String> relaunch = new ArrayList<String>();
                relaunch.addAll(hostVersion.getArch().getRelaunchCommand(hostInfo));

                DeployerParameters params = new DeployerParameters(curInfo.getApplicationHome());
                params.setElements(elements);
                if (!curInfo.isSelfUpdate())    // Add self  update information if we do not update jupidator
                    params.addElement(AppVersion.construct(curVersion.getAppElements()).getXElement(curInfo.getApplicationHome()));
                params.setHeadless(gui.isHeadless());
                params.setRelaunchCommand(relaunch);

                /* Construct launcher command */
                try {
                    procbuilder = PermissionManager.manager.getLaunchCommand(application, params);
                    if (procbuilder == null)
                        throw new IOException("Unable to create relauncer");
                } catch (IOException ex) {
                    String message = ex.getMessage();
                    application.receiveMessage(message);
                    gui.errorOnRestart(message);
                    return;
                }

                gui.successOnCommit(!relaunch.isEmpty());
            }
        };
        watcher.startWatcher();
        download.start();
    }

    public void actionCancel() {
        watcher.stopWatcher();
        download.interrupt();
        gui.endDialog();
        try {
            download.join();
        } catch (InterruptedException ex) {
        }
        for (String key : curVersion.keySet())
            curVersion.get(key).cancel(application);
        PermissionManager.manager.cleanUp();
    }

    /* Do nothing - wait for next cycle */
    public void actionDefer() {
        watcher.stopWatcher();
        gui.endDialog();
        curVersion.getUpdaterProperties().defer();
    }

    public void actionIgnore() {
        watcher.stopWatcher();
        gui.endDialog();
        curVersion.getUpdaterProperties().ignore(curVersion.getAppElements().getNewestRelease());
    }

    public void actionRestart() {
        /* Ask application if restart could be performed */
        watcher.stopWatcher();
        if (!application.requestRestart()) {
            gui.errorOnRestart(_("Application cancelled restart"));
            return;
        }
        try {
            procbuilder.start();
        } catch (IOException ex) {
        }
        gui.endDialog();
        System.exit(0);  // Restarting
    }

    public String getChangeLog() {
        return getChangeLog(false);
    }

    public String getChangeLog(boolean onlyActive) {
        return HTMLCreator.getList(curVersion.getAppElements().getLogList(), onlyActive);
    }
    
    public Boolean isUpdateSkip(){
    	return this.update_skipped;
    }
}
