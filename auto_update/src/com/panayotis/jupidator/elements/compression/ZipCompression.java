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

import java.io.File;
import java.io.IOException;
import java.util.Enumeration;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

/**
 *
 * @author teras
 */
public class ZipCompression extends MultiFileCompression {

    public String getFilenameExtension() {
        return ".zip";
    }

    @Override
    protected CompressedFile getCompressedFile(File compressedfile) throws IOException {
        return new ZipCompressedFile(compressedfile);
    }

    protected class ZipCompressedFile implements CompressedFile {

        private final ZipFile zip;
        private final Enumeration<? extends ZipEntry> entries;
        private boolean hasMultiEntries = false;

        public ZipCompressedFile(File compressedfile) throws IOException {
            // Count file entries
            ZipFile testzip = null;
            try {
                testzip = new ZipFile(compressedfile);
                Enumeration<? extends ZipEntry> testentries = testzip.entries();
                hasMultiEntries = getNextFileEntry(testentries) != null && getNextFileEntry(testentries) != null;
            } catch (Exception ex) {
            } finally {
                if (testzip != null)
                    try {
                        testzip.close();
                    } catch (Exception ex2) {
                    }
            }

            zip = new ZipFile(compressedfile);
            entries = zip.entries();
        }

        public boolean hasMultiEntries() {
            return hasMultiEntries;
        }

        public Entry getNextEntry() throws IOException {
            if (!entries.hasMoreElements())
                return null;
            ZipEntry entry = getNextFileEntry(entries);
            return entry == null ? null : new Entry(zip.getInputStream(entry), entry.getName());
        }

        public void close() throws IOException {
            zip.close();
        }
    }

    @SuppressWarnings("empty-statement")
    private static ZipEntry getNextFileEntry(Enumeration<? extends ZipEntry> listOfEntries) {
        ZipEntry entry = null;
        while (listOfEntries.hasMoreElements() && (entry = listOfEntries.nextElement()) != null && entry.isDirectory());
        return entry;
    }
}
