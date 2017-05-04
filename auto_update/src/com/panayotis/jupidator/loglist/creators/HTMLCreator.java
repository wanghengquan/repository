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

import static com.panayotis.jupidator.i18n.I18N._;

/**
 *
 * @author teras
 */
public class HTMLCreator {

    public static String getList(LogList list, boolean onlyActive) {
        StringBuilder data = new StringBuilder();
        data.append("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\n");
        data.append("<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" lang=\"en\">\n");
        data.append("  <head>\n");
        data.append("    <title></title>\n");
        data.append("    <style type=\"text/css\">\n");
        data.append("      .jupreleaseinfo { margin: 0px 10px 16px 12px; }\n");
        data.append("      .jupversion { padding:4px 4px 4px 4px; margin: 5px 10px 5px 10px; background: #d2e6d2; font-weight: bold; }\n");
        data.append("      .jupinfo { margin: 0px 10px 16px 12px; }\n");
        data.append("    </style>\n");
        data.append("  </head>\n");
        data.append("  <body>\n");

        if (!list.getApplicationInfo().equals("")) {
            data.append("    <p class=\"jupreleaseinfo\">");
            data.append(list.getApplicationInfo());
            data.append("</p>\n");
        }

        for (LogItem item : list)
            if (!onlyActive || item.isActive) {
                data.append("    <div class=\"jupentry\">\n");
                data.append("      <p class=\"jupversion\">").append(_("Version")).append(": ").append(item.version).append("</p>\n");
                data.append("      <p class=\"jupinfo\">").append(item.info).append("</p>\n");
                data.append("    </div>\n");
            }

        data.append("  </body>\n</html>\n");
        return data.toString();
    }
}
