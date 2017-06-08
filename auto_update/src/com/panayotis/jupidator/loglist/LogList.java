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

package com.panayotis.jupidator.loglist;

import java.util.ArrayList;

/**
 *
 * @author teras
 */
public class LogList extends ArrayList<LogItem> {

    private String application_info = "";

    /**
     * @return the release_info
     */
    public String getApplicationInfo() {
        return application_info;
    }

    /**
     * @param release_info the release_info to set
     */
    public void setApplicationInfo(String application_info) {
        if (application_info == null)
            application_info = "";
        this.application_info = application_info;
    }
}
