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

package com.panayotis.jupidator.elements.security;

import com.panayotis.jupidator.UpdatedApplication;
import com.panayotis.jupidator.elements.FileUtils;
import java.io.File;
import java.io.IOException;
import java.io.Serializable;
import java.util.ArrayList;
import jupidator.launcher.DeployerParameters;
import jupidator.launcher.JSudo;
import jupidator.launcher.JupidatorDeployer;
import jupidator.launcher.OperatingSystem;

import static com.panayotis.jupidator.i18n.I18N._;

/**
 *
 * @author teras
 */
public class PermissionManager implements Serializable {

    public static final PermissionManager manager = new PermissionManager();
    private boolean reqprev = false;
    private int slots = 0;
    private final File workdir;

    public PermissionManager() {
        File wd = null;
        try {
            wd = File.createTempFile("jupidator_download_", "");
            wd.delete();
        } catch (IOException ex) {
        }
        workdir = wd;
    }

    public boolean isRequiredPrivileges() {
        return reqprev;
    }

    public boolean estimatePrivileges(File file) {
        boolean estimation = !isWritable(file);
        reqprev |= estimation;
        return estimation;
    }

    public boolean forcePrivileges() {
        reqprev = true;
        return true;
    }

    public File requestSlot() {
        return new File(workdir, "slot" + (++slots));
    }

    public void cleanUp() {
        FileUtils.rmTree(workdir);
    }

    public String getWorkDir() {
        return workdir.getAbsolutePath();
    }

    public ProcessBuilder getLaunchCommand(UpdatedApplication application, DeployerParameters params) throws IOException {
        /* Copy Jupidator classes */
        String message = FileUtils.copyJavaPackage(JupidatorDeployer.class.getPackage().getName(), workdir.getPath());
        if (message != null)
            throw new IOException(message);
        /* Store requested working elements */
        File paramfile = new File(workdir, "parameters");
        if (!params.storeParameters(paramfile))
            throw new IOException(_("Unable to initialize restart"));

        /* Construct command */
        ArrayList<String> command = new ArrayList<String>();
        String bindir = workdir.getPath() + File.separator + "jupidator" + File.separator + "launcher" + File.separator;
        if (reqprev)
            if (OperatingSystem.isWindows) {
                command.add("wscript");
                command.add(bindir + "JupidatorUpdate.js");
            } else if (OperatingSystem.isMac) {
                command.add(bindir + "JupidatorUpdate");
                FileUtils.setExecute(bindir + "JupidatorUpdate");
            } else {
                command.add(FileUtils.JAVABIN);
                command.add("-cp");
                command.add(workdir.getAbsolutePath());
                command.add(JSudo.class.getName());
            }
        command.add(FileUtils.JAVABIN);
        command.add("-cp");
        command.add(workdir.getAbsolutePath());
        command.add(JupidatorDeployer.class.getName());
        command.add(workdir.getAbsolutePath());

        /* Debug launch command */
        StringBuilder debug = new StringBuilder("Relaunch command: ");
        for (String cmd : command)
            debug.append(cmd).append(" ");
        application.receiveMessage(debug.toString());

        return new ProcessBuilder(command);
    }

    private boolean isWritable(File f) {
        if (f == null)
            throw new NullPointerException("Updated file could not be null.");
        if (!isParentWritable(f))
            return false;
        if (!f.exists())
            return true;
        return isWritableLoop(f);
    }

    private boolean isWritableLoop(File f) {
        if (f.isDirectory()) {
            File dir[] = f.listFiles();
            for (int i = 0; i < dir.length; i++)
                if (!isWritable(dir[i]))
                    return false;
            return true;
        } else
            return canWrite(f);
    }

    private boolean isParentWritable(File f) {
        File p = f.getParentFile();
        if (p == null)  // No parent file - can't work on root files
            return false;
        if (f.exists())
            /* we are sure that a parent exists for this file */
            return canWrite(p);
        else if (p.exists()) {
            /* Check if parent file is directory AND can write in it */
            if (p.isDirectory() && canWrite(p))
                return true;
            return false;
        } else
            /* directories created (?) */
            return FileUtils.makeDirectory(p);
    }

    public boolean canWrite(File f) {
        if (OperatingSystem.isWindows) {
            if (!f.isDirectory())
                f = f.getParentFile();
            f = new File(f, String.valueOf(Math.random()));
            boolean result = f.mkdir();
            f.delete();
            return result;
        }
        return f.canWrite();
    }
}
