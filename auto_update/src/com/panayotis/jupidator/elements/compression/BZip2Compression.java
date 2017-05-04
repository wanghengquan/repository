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

import java.io.IOException;
import java.io.InputStream;
import org.apache.tools.bzip2.CBZip2InputStream;

/**
 *
 * @author teras
 */
public class BZip2Compression extends SingleFileCompression {

    private final String extension;

    public BZip2Compression(String extension) {
        this.extension = "." + extension;
    }

    public String getFilenameExtension() {
        return extension;
    }

    @Override
    protected InputStream getCompressedStream(InputStream in) throws IOException {
        return getStream(in);
    }

    public static InputStream getStream(InputStream in) throws IOException {
        char b = (char) in.read();
        char z = (char) in.read();
        if (b != 'B' && z != 'Z')
            in.reset();
        return new CBZip2InputStream(in);
    }
}
