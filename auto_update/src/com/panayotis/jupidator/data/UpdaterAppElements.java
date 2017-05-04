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

package com.panayotis.jupidator.data;

import com.panayotis.jupidator.elements.mirror.MirrorList;
import com.panayotis.jupidator.loglist.LogItem;
import com.panayotis.jupidator.loglist.LogList;
import com.panayotis.jupidator.versioning.SystemVersion;
import java.io.Serializable;

import static com.panayotis.jupidator.i18n.I18N._;

/**
 * This information is gathered for the library from the XML file
 *
 * @author teras
 */
public class UpdaterAppElements implements Serializable {

    private String AppName = "Unknown";
    private String baseURL = "";
    private MirrorList mirrors = new MirrorList();
    private String iconpath = "";
    private int newestrelease = -1;    // Newest release overall, read from XML
    private int lastrelease = -1;    // Last release, as currently read from XML
    private String newestversion = "0.0.0";    // Newest version overall, read from XML
    private LogList loglist = new LogList();
    private boolean needs_update = false;

    public String getAppName() {
        return AppName;
    }

    public void setSelfUpdate(String appname) {
        setAppName(_("Jupidator for {0}", appname));
    }

    void setAppName(String AppName) {
        if (AppName != null && (!AppName.equals("")))
            this.AppName = AppName;
    }

    public LogList getLogList() {
        return loglist;
    }

    public String getBaseURL() {
        return baseURL;
    }

    void setBaseURL(String base) {
        if (base == null)
            throw new IllegalArgumentException("Base URL should be defined in XML.");
        baseURL = base + "/";
    }

    public MirrorList getMirrors() {
        return mirrors;
    }

    void addLogItem(String version, String information, boolean isActive) {
        loglist.add(new LogItem(version, information, isActive));
    }

    public void setApplicationInfo(String release_info) {
        loglist.setApplicationInfo(release_info);
    }

    public String getIconpath() {
        return iconpath;
    }

    void setIconpath(String iconpath) {
        if (iconpath != null)
            this.iconpath = baseURL + iconpath;
    }

    void setJupidatorVersion(String jupidator_version) {
        needs_update = TextUtils.getInt(jupidator_version, 0) > SystemVersion.RELEASE;
    }

    void updateVersion(int release, String version) {
        if (release > newestrelease) {
            newestrelease = release;
            newestversion = version;
        }
        if (newestversion == null)
            newestversion = "0.0.0";
        lastrelease = release;
    }

    public String getNewestVersion() {
        return newestversion;
    }

    public int getNewestRelease() {
        return newestrelease;
    }

    public boolean shouldUpdateLibrary() {
        return needs_update;
    }

    public long getLastRelease() {
        return lastrelease;
    }
}
