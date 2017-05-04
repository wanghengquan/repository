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
import java.io.Serializable;

/**
 *
 * @author teras
 */
public interface CompressionMethod extends Serializable {

    /**
     *
     * @param f
     * @return error message
     */
    public String decompress(File compressedfile, File outfile);

    /**
     *
     * @return source filename extension
     */
    public String getFilenameExtension();

    /**
     * Check if the specified compression method is actually a package
     * (currently only with Zip). <b>WARNING</b>: This method is practically
     * useful ONLY after decompress has been performed and evaluated.
     *
     * @return
     */
    public boolean isPackageBased();
}
