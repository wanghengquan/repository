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

package com.panayotis.jupidator.elements.compression;

import com.panayotis.jupidator.elements.FileUtils;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

/**
 *
 * @author teras
 */
public abstract class SingleFileCompression implements CompressionMethod {

    public String decompress(File compressedfile, File outfile) {
        BufferedInputStream fin = null;
        BufferedOutputStream fout = null;
        try {
            fin = new BufferedInputStream(new FileInputStream(compressedfile));
            fout = new BufferedOutputStream(new FileOutputStream(outfile));
            return FileUtils.copyFile(getCompressedStream(fin), fout, null, false);
        } catch (IOException ex) {
            return ex.getMessage();
        } finally {
            if (fin != null)
                try {
                    fin.close();
                } catch (IOException ex) {
                }
            if (fout != null)
                try {
                    fout.close();
                } catch (IOException ex) {
                }
        }
    }

    public boolean isPackageBased() {
        return false;
    }

    protected abstract InputStream getCompressedStream(InputStream in) throws IOException;
}
