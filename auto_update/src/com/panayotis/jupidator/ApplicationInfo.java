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

import com.panayotis.jupidator.data.TextUtils;
import com.panayotis.jupidator.elements.FileUtils;
import com.panayotis.jupidator.elements.security.PermissionManager;
import com.panayotis.jupidator.versioning.SystemVersion;
import java.io.File;
import java.io.Serializable;
import java.util.HashMap;

/**
 * This information is given to the library from the runtime environment
 *
 * @author teras
 */
public class ApplicationInfo implements Serializable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private HashMap<String, String> vars;
    /**
     * true: Some files can be ignored, if they are taken care by a distribution
     * false: All files should be updated
     */
    private boolean distributionBased = false;
    private boolean selfupdate;

    public ApplicationInfo() {
        this(null, 0, null, true);
    }

    public ApplicationInfo(String appHome) {
        this(appHome, 0, null, true);
    }

    public ApplicationInfo(int release, String version) {
        this(null, release, version, true);
    }

    public ApplicationInfo(String appHome, int release, String version) {
        this(appHome, release, version, true);
    }

    @Deprecated
    public ApplicationInfo(String appHome, String appSupportDir) {
        this(appHome, 0, null, true);
    }

    @Deprecated
    public ApplicationInfo(String appHome, String appSupportDir, String release, String version) {
        this(appHome, TextUtils.getInt(release, 0), version, true);
    }

    @Deprecated
    public ApplicationInfo(String appHome, String appSupportDir, int release, String version) {
        this(appHome, release, version, true);
    }

    static ApplicationInfo getSelfInfo(String appHome) {
        return new ApplicationInfo(appHome, SystemVersion.RELEASE, SystemVersion.VERSION, false);
    }

    private ApplicationInfo(String appHome, int release, String version, boolean useLocalStamp) {
        vars = new HashMap<String, String>();
        if (appHome == null)
            appHome = FileUtils.getClassHome(null);
        appHome = fixDir(appHome, "Application");
        vars.put("APPHOME", appHome);

        // Find versions
        if (useLocalStamp) {    // Skip this part if self-updating
            AppVersion v = AppVersion.construct(appHome);
            if (v != null && v.getRelease() > release) {
                release = v.getRelease();
                version = v.getVersion();
            }
        }
        vars.put("RELEASE", Integer.toString(release));
        if (version != null && (!version.equals("")))
            vars.put("VERSION", version);

        updateIgnoreRelease(0);

        vars.put("JAVABIN", FileUtils.JAVABIN);
        vars.put("WORKDIR", PermissionManager.manager.getWorkDir());
    }

    public void setProperty(String name, String value) {
        if (name == null || name.equals(""))
            throw new NullPointerException("Property name could not be null");
        if (value == null)
            value = "";
        vars.put(name, value);
    }

    public void setDistributionBased(boolean distributionBased) {
        this.distributionBased = distributionBased;
    }

    public boolean isDistributionBased() {
        return distributionBased;
    }

    public String getApplicationHome() {
        return vars.get("APPHOME");
    }

    /* This new release has to do with ignoring a specific version */
    public final void updateIgnoreRelease(int release) {
        vars.put("IGNORERELEASE", Integer.toString(release));
    }

    public int getRelease() {
        return Integer.parseInt(vars.get("RELEASE"));
    }

    public int getIgnoreRelease() {
        return Integer.parseInt(vars.get("IGNORERELEASE"));
    }

    public String getVersion() {
        return vars.get("VERSION");
    }

    public String applyVariables(String path) {
        return TextUtils.applyVariables(vars, path);
    }

    public boolean isSelfUpdate() {
        return selfupdate;
    }

    public void setSelfUpdate() {
        this.selfupdate = true;
    }

    private String fixDir(String dir, String title) {
        if (dir == null)
            throw new NullPointerException(title + "directory can not be null.");
        if (dir.equals("") || dir.equals("."))
            dir = TextUtils.getProperty("user.dir");
        dir = dir.replace("/./", "/");
        if (dir.length() > 1 && dir.endsWith(File.separator))
            dir = dir.substring(0, dir.length() - 1);
        if (!new File(dir).isDirectory())
            throw new IllegalArgumentException("Unable to find " + title + " directory " + dir);
        return dir;
    }
}
