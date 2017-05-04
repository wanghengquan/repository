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

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import org.xeustechnologies.jtar.TarEntry;
import org.xeustechnologies.jtar.TarInputStream;

/**
 *
 * @author teras
 */
public class TarCompression extends MultiFileCompression {

    private final String extension;

    public TarCompression(String extension) {
        this.extension = "." + extension;
    }

    public String getFilenameExtension() {
        return extension;
    }

    @Override
    protected CompressedFile getCompressedFile(File compressedfile) throws IOException {
        return new TarCompressedFile(compressedfile);
    }

    protected class TarCompressedFile implements CompressedFile {

        private final TarInputStream tar;
        private final boolean hasMultipleEntries;

        protected TarCompressedFile(File compressedfile) throws IOException {
            TarInputStream testtar = new TarInputStream(getCompressedInputStream(new FileInputStream(compressedfile)));
            hasMultipleEntries = getNextFileEntry(testtar) != null && getNextFileEntry(testtar) != null;
            testtar.close();

            tar = new TarInputStream(getCompressedInputStream(new BufferedInputStream(new FileInputStream(compressedfile))));
        }

        public boolean hasMultiEntries() {
            return hasMultipleEntries;
        }

        public Entry getNextEntry() throws IOException {
            TarEntry entry = getNextFileEntry(tar);
            return entry == null ? null : new Entry(tar, entry.getName());
        }

        public void close() throws IOException {
            tar.close();
        }
    }

    protected InputStream getCompressedInputStream(InputStream in) throws IOException {
        return in;
    }

    @SuppressWarnings("empty-statement")
    private static TarEntry getNextFileEntry(TarInputStream stream) {
        TarEntry entry = null;
        try {
            while ((entry = stream.getNextEntry()) != null && entry.isDirectory());
        } catch (IOException ex) {
        }
        return entry;
    }
}
