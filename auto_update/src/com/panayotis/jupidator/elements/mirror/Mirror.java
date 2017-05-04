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

package com.panayotis.jupidator.elements.mirror;

import com.panayotis.jupidator.ApplicationInfo;
import com.panayotis.jupidator.data.TextUtils;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Map;

/**
 *
 * @author teras
 */
public class Mirror {

    private static final String COREURL = "URL";
    //
    private final String parser;
    private final ApplicationInfo appinfo;
    private final String url;

    public Mirror(ApplicationInfo appinfo, String URL) {
        this("${URL}/${FILEPATH}/${FILENAME}${FILECOMPR}", appinfo, URL);
    }

    public Mirror(String parser, ApplicationInfo appinfo, String URL) {
        this.parser = parser;
        this.appinfo = appinfo;
        this.url = URL;
    }

    public URL getURL(Map<String, String> elements) throws MalformedURLException {
        try {
            elements.put(COREURL, url);
            String request = appinfo.applyVariables(TextUtils.applyVariables(elements, parser));
            return new URL(request);
        } finally {
            elements.remove(COREURL);
        }
    }
}
