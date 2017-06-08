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

package com.panayotis.jupidator.elements;

import com.panayotis.jupidator.ApplicationInfo;
import com.panayotis.jupidator.UpdatedApplication;
import com.panayotis.jupidator.data.UpdaterAppElements;
import com.panayotis.jupidator.elements.security.PermissionManager;
import com.panayotis.jupidator.gui.BufferListener;
import java.io.File;
import java.io.Serializable;
import jupidator.launcher.XElement;


/**
 *
 * @author teras
 */
public abstract class JupidatorElement implements Serializable {

    private final String filename;
    private final String destdir;
    private final long size;
    private final long release;
    private final ExecutionTime exectime;
    private final boolean requiresPrivileges;

    public JupidatorElement(String file, UpdaterAppElements elements, ApplicationInfo appinfo, ExecutionTime exectime) {
        this((file == null) ? null : new File(file).getName(), (file == null) ? null : new File(file).getParent(), elements, appinfo, exectime);
    }

    public JupidatorElement(String name, String dest, UpdaterAppElements elements, ApplicationInfo appinfo, ExecutionTime exectime) {
        this(name, dest, "0", elements, appinfo, exectime);
    }

    @SuppressWarnings("OverridableMethodCallInConstructor")
    public JupidatorElement(String name, String dest, String size, UpdaterAppElements elements, ApplicationInfo appinfo, ExecutionTime exectime) {
        if (appinfo == null)
            throw new NullPointerException("Application info not provided.");
        if (elements == null)
            throw new NullPointerException("UpdaterAppElements not provided.");

        this.filename = appinfo.applyVariables(name);
        this.destdir = appinfo.applyVariables(dest);
        this.release = elements.getLastRelease();

        long nsize = 0;
        try {
            nsize = Math.max(0, Long.parseLong(size));
        } catch (NumberFormatException ex) {
        }
        this.size = nsize;

        if (exectime == null)
            exectime = ExecutionTime.MID;
        this.exectime = exectime;
        requiresPrivileges = estimatePrivileges(elements);
    }

    protected boolean estimatePrivileges(UpdaterAppElements elements) {
        return PermissionManager.manager.estimatePrivileges(new File(getDestinationFile()));
    }

    public ExecutionTime getExectime() {
        return exectime;
    }

    public String getHash() {
        return getDestinationFile();
    }

    public final String getDestinationFile() {
        if (destdir.equals(""))
            return filename;
        return destdir + File.separator + filename;
    }

    public String getFileName() {
        return filename;
    }

    public JupidatorElement getNewestRelease(JupidatorElement fother) {
        if (release > fother.release)
            return this;
        else
            return fother;
    }

    public long getSize() {
        return size;
    }

    public boolean requiresPrivileges() {
        return requiresPrivileges;
    }

    /**
     * This method downloads files for this element.
     *
     * @return Error message, or null if everything is fine
     */
    public abstract String fetch(UpdatedApplication application, BufferListener blisten);

    /**
     * This method performs housekeeping work for this element (i.e. unzip
     * files).
     *
     * @return Error message, or null if everything is fine
     */
    public abstract String prepare(UpdatedApplication application);

    /**
     * This method cancels action and rolls back everything
     *
     * @param application
     */
    public abstract void cancel(UpdatedApplication application);

    /**
     * Use this method to provide the actual work to be done, when updating the
     * application
     *
     * @return the object which will perform this work. It should be under
     * package com.panayotis.jupidator.launcher
     */
    public abstract XElement getExecElement();
}
