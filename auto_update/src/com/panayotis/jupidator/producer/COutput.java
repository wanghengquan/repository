/*
 * Copyright (C) 2013 teras
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

package com.panayotis.jupidator.producer;

import com.panayotis.jupidator.elements.FileUtils;
import com.panayotis.jupidator.elements.security.PermissionManager;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;

/**
 *
 * @author teras
 */
public class COutput {

    private final File dir;
    private final String version;
    private final Writer writer;

    public COutput(File dir, String version, boolean shouldCleanUp) throws IOException {
        if (!FileUtils.makeDirectory(dir))
            throw new IOException("Unable to create folder " + dir.getPath());
        if (!PermissionManager.manager.canWrite(dir))
            throw new IOException("Unable to write in " + dir.getPath());
        this.dir = dir;
        this.version = version;
        if (shouldCleanUp) {
            FileUtils.rmTree(new File(dir, version));
            FileUtils.rmTree(new File(dir, "jupidator.xml"));
        }
        writer = new BufferedWriter(new FileWriter(new File(dir, "jupidator.xml")));
    }

    public Writer getWriter() {
        return writer;
    }

    public String getVersion() {
        return version;
    }

    public File getDir() {
        return dir;
    }

    public void close() throws IOException {
        writer.close();
    }
}
