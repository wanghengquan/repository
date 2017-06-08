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

package com.panayotis.jupidator.loglist.creators;

import com.panayotis.jupidator.loglist.LogItem;
import com.panayotis.jupidator.loglist.LogList;

import static com.panayotis.jupidator.data.TextUtils.NL;
import static com.panayotis.jupidator.i18n.I18N._;

/**
 *
 * @author teras
 */
public class TextCreator {

    public static String getList(LogList list, boolean onlyActive) {
        StringBuilder data = new StringBuilder();
        data.append(list.getApplicationInfo()).append(NL);
        data.append(_("List of changes:")).append(NL);
        for (LogItem item : list)
            if (!onlyActive || item.isActive) {
                data.append(" * ");
                data.append(item.version);
                data.append(" * ").append(NL);
                data.append(item.info);
                data.append(NL);
            }
        return data.toString();
    }
}
