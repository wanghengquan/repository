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
import com.panayotis.jupidator.elements.security.Digester;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author teras
 */
public class MirroredFile {

    private static final String FILEPATH = "FILEPATH";
    private static final String FILENAME = "FILENAME";
    private static final String FILECOMPR = "FILECOMPR";
    private static final String FILEBASE = "FILEBASE";
    private static final String FILEEXT = "FILEEXT";
    private long size;
    private final HashMap<String, String> elements = new HashMap<String, String>();
    private final ArrayList<Digester> digesters = new ArrayList<Digester>();

    public MirroredFile(String path, String file, ApplicationInfo info) {
        path = path == null ? "" : info.applyVariables(path);
        file = file == null ? "" : info.applyVariables(file);

        elements.put(FILEPATH, path);
        elements.put(FILENAME, file);
        int point = file.indexOf('.');
        if (point < 0) {
            elements.put(FILEBASE, file);
            elements.put(FILEEXT, "");
        } else {
            elements.put(FILEBASE, file.substring(0, point));
            elements.put(FILEEXT, file.substring(point));
        }
    }

    public void setExtension(String ext) {
        elements.put(FILECOMPR, ext == null ? "" : ext);
    }

    @Override
    public String toString() {
        return elements.get(FILEPATH) + "/" + getFile();
    }

    public Map<String, String> getElements() {
        return elements;
    }

    public String getFile() {
        return elements.get(FILENAME);
    }

    public void setSize(long size) {
        this.size = size;
    }

    public long getSize() {
        return size;
    }

    public void addDigester(Digester digester) {
        if (digester != null)
            digesters.add(digester);
    }

    public Iterable<Digester> getDigesters() {
        return digesters;
    }
}
