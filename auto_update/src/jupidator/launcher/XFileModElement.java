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

package jupidator.launcher;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 *
 * @author teras
 */
public abstract class XFileModElement extends XTargetElement {

    public XFileModElement(String target) {
        super(target);
    }

    protected static boolean safeDelete(File f) {
        if (!f.exists())
            return true;
        if (f.isDirectory()) {
            File dir[] = f.listFiles();
            for (int i = 0; i < dir.length; i++)
                if (!safeDelete(dir[i]))
                    return false;
        }
        return f.delete();
    }

    private static void shouldMakeHidden(File f) {
        if (OperatingSystem.isWindows && f.getName().startsWith("."))
            try {
                Runtime.getRuntime().exec(new String[]{"attrib", "+H", f.getAbsolutePath()});
            } catch (IOException ex) {
            }
    }

    protected static boolean safeMkDir(File dir) {
        boolean status = dir.exists() ? dir.isDirectory() : dir.mkdirs();
        if (status)
            shouldMakeHidden(dir);
        return status;
    }

    protected static boolean safeMv(File from, File to) {
        if (from.isDirectory()) {
            /* The target is a directory, copy it recursively */

            if (!safeMkDir(to)) // Make sure that the destination file is a directory and it exists
                return false;
            to = new File(to, from.getName()); // Define actual destination directory
            if (!safeMkDir(to)) // Fail if destination directory could not be created
                return false;

            for (File entry : from.listFiles())
                if (!safeMv(entry, to))
                    return false;
            return from.delete();
        } else {
            /* if it is not a directory, copy file */

            if (to.isDirectory())   // If we copy to a directory, copy this file inside the directory
                to = new File(to, from.getName());
            if (!safeMkDir(to.getParentFile())) // Fail if parent destination directory could not be created
                return false;

            boolean status = true;
            BufferedInputStream in = null;
            BufferedOutputStream out = null;
            byte[] buffer = new byte[4000];
            int hm;
            try {
                in = new BufferedInputStream(new FileInputStream(from));
                out = new BufferedOutputStream(new FileOutputStream(to));
                while ((hm = in.read(buffer)) > 0)
                    out.write(buffer, 0, hm);
                shouldMakeHidden(to);
            } catch (IOException ex) {
                status = false;
            } finally {
                try {
                    if (in != null)
                        in.close();
                } catch (IOException ex) {
                    status = false;
                }
                try {
                    if (out != null)
                        out.close();
                } catch (IOException ex) {
                    status = false;
                }
            }
            status &= from.delete();
            return status;
        }
    }
}