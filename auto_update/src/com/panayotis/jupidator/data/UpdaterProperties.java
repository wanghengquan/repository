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

import com.panayotis.jupidator.ApplicationInfo;
import com.panayotis.jupidator.UpdaterException;
import java.io.Serializable;
import java.util.Calendar;
import java.util.prefs.BackingStoreException;
import java.util.prefs.Preferences;

/**
 *
 * @author teras
 */
public class UpdaterProperties implements Serializable {

    private final static String TIMEIGNORE = "NextCheck";
    private final static String VERSIONIGNORE = "Ignore";
    private final Preferences prefs;

    public UpdaterProperties(ApplicationInfo appinfo) throws UpdaterException {
        if (appinfo == null)
            throw new UpdaterException("Application info could not be null");
        String path = appinfo.getApplicationHome();
        if (path.equals("/"))
            path = "ROOT";
        prefs = Preferences.userNodeForPackage(getClass()).node((appinfo.isSelfUpdate() ? "lib:" : "app:") + path);
        appinfo.updateIgnoreRelease(prefs.getInt(VERSIONIGNORE, 0));
    }

    public boolean isTooSoon() {
        long now = Calendar.getInstance().getTimeInMillis();
        try {
            long last = prefs.getLong(TIMEIGNORE, -1);
            long next = last + 1000 * 60 * 60 * 24;
            if (now < next)
                return true;
            // It's too soon - We don't need to check it, yet
        } catch (NumberFormatException e) { // if something went wrong, just check web version  
        }
        return false;
    }

    public void defer() {
        prefs.putLong(TIMEIGNORE, Calendar.getInstance().getTimeInMillis());
        try {
            prefs.flush();
        } catch (BackingStoreException ex) {
        }
    }

    public void ignore(int newrelease) {
        prefs.putInt(VERSIONIGNORE, newrelease);
        try {
            prefs.flush();
        } catch (BackingStoreException ex) {
        }
    }
}
