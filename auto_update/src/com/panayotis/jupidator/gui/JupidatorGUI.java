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

package com.panayotis.jupidator.gui;

import com.panayotis.jupidator.ApplicationInfo;
import com.panayotis.jupidator.Updater;
import com.panayotis.jupidator.UpdaterException;
import com.panayotis.jupidator.data.UpdaterAppElements;

/**
 *
 * @author teras
 */
public interface JupidatorGUI {

    public static final String ABOUT = "about";
    public static final String SYSTEMLOOK = "systemlook";
    public static final String LOGLIST = "loglist";

    public void setInformation(Updater callback, UpdaterAppElements appElements, ApplicationInfo appinfo) throws UpdaterException;

    public void startDialog();

    public void endDialog();

    public void errorOnCommit(String message);

    public void successOnCommit(boolean restartableApp);

    public void errorOnRestart(String message);

    public void setDownloadRatio(String ratio, float percent);

    public void setIndetermined();

    public void setProperty(String key, String value);

    public boolean isHeadless();
}
