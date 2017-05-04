/*
 * Copyright (C) 2012 teras
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

package com.panayotis.jupidator.elements.compression;

import com.panayotis.jupidator.elements.FileUtils;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import static com.panayotis.jupidator.i18n.I18N._;

/**
 *
 * @author teras
 */
public abstract class MultiFileCompression implements CompressionMethod {

    private boolean packageBased = false;

    @SuppressWarnings("unchecked")
    public String decompress(File compressedfile, File outfile) {
        CompressedFile file = null;
        try {
            file = getCompressedFile(compressedfile);
            packageBased = file.hasMultiEntries();

            /* 
             * If this package file has only a single file, we treat it as
             * a regular compressed file.
             * 
             * When we have more than one files, we  have a package.
             * Since we are using a lazy installation
             * scheme, uncompress all files in a temporary folder one level deep
             * than the actual required folder. Thus, if the output file is
             * a regular file, just perform a rename. If it is a directory
             * (thus we have a package), move all files one directory up.
             * With this trick, it is possible to refrain the actual file
             * manipulation in a latter time.
             */
            Entry entry;
            BufferedOutputStream out = null;
            while ((entry = file.getNextEntry()) != null)
                try {
                    File coutfile;
                    if (packageBased) {
                        coutfile = new File(outfile, entry.name.replace("/", File.separator));
                        if (!FileUtils.makeDirectory(coutfile.getParentFile()))
                            return _("Unable to unpack under {0}", coutfile.getParentFile().getPath());
                    } else
                        coutfile = outfile;
                    out = new BufferedOutputStream(new FileOutputStream(coutfile));

                    String status = FileUtils.copyFile(entry.stream, out, null, false);
                    if (status != null)
                        return status;
                    out.close();
                    out = null;
                } catch (IOException ex) {
                    return ex.getMessage();
                } finally {
                    if (out != null)
                        try {
                            out.close();
                        } catch (Exception ex) {
                        }
                }
            return null;
        } catch (IOException ex) {
            return ex.getClass() + ": " + ex.getMessage();
        } finally {
            if (file != null)
                try {
                    file.close();
                } catch (IOException ex) {
                }
        }
    }

    public boolean isPackageBased() {
        return packageBased;
    }

    protected abstract CompressedFile getCompressedFile(File compressedfile) throws IOException;

    protected static class Entry {

        private final InputStream stream;
        private final String name;

        protected Entry(InputStream stream, String name) {
            this.stream = stream;
            this.name = name;
        }
    }

    protected static interface CompressedFile {

        public boolean hasMultiEntries();

        public Entry getNextEntry() throws IOException;

        public void close() throws IOException;
    }
}
