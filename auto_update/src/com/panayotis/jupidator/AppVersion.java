/*
 * Copyright (C) 2012 teras
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */

package com.panayotis.jupidator;

import com.panayotis.jupidator.data.TextUtils;
import com.panayotis.jupidator.data.UpdaterAppElements;
import com.panayotis.jupidator.elements.security.PermissionManager;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Properties;
import jupidator.launcher.XEFile;
import jupidator.launcher.XElement;

/**
 *
 * @author teras
 */
public class AppVersion {

    public static final String FILETAG = ".last_successful_update";
    private final String version;
    private final int release;

    private AppVersion(String version, int release) {
        this.version = version;
        this.release = release;
    }

    public static AppVersion construct(String appHome) {
        if (appHome == null)
            return null;
        Properties props = new Properties();
        try {
            props.load(new FileInputStream(appHome + File.separator + FILETAG));
        } catch (IOException ex) {
            return null;
        }
        return new AppVersion(props.getProperty("version", null), TextUtils.getInt(props.getProperty("release"), 0));
    }

    public static AppVersion construct(UpdaterAppElements elements) {
        if (elements == null)
            return null;
        return new AppVersion(elements.getNewestVersion(), elements.getNewestRelease());
    }

    public String getVersion() {
        return version;
    }

    public int getRelease() {
        return release;
    }

    private boolean store(File out) {
        Properties props = new Properties();
        if (release > 0) {
            props.put("release", String.valueOf(release));
            props.put("version", version == null ? "" : version);
        }
        try {
            props.store(new FileOutputStream(out), null);
            return true;
        } catch (IOException ex) {
            throw new RuntimeException(ex);
        }
    }

    public XElement getXElement(String appHome) {
        String outname = appHome + File.separator + FILETAG;
        File fromfile;
        if (PermissionManager.manager.estimatePrivileges(new File(outname)))
            fromfile = PermissionManager.manager.requestSlot();
        else
            fromfile = new File(outname + ".jupidator");
        fromfile.getParentFile().mkdirs();
        store(fromfile);
        return new XEFile(fromfile.getAbsolutePath(), outname);
    }
}
