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

package com.panayotis.jupidator.elements;

import com.panayotis.jupidator.ApplicationInfo;
import com.panayotis.jupidator.UpdatedApplication;
import com.panayotis.jupidator.data.UpdaterAppElements;
import com.panayotis.jupidator.elements.compression.BZip2Compression;
import com.panayotis.jupidator.elements.compression.CompressionMethod;
import com.panayotis.jupidator.elements.compression.GZipCompression;
import com.panayotis.jupidator.elements.compression.InvalidCompression;
import com.panayotis.jupidator.elements.compression.NullCompression;
import com.panayotis.jupidator.elements.compression.TarBZCompression;
import com.panayotis.jupidator.elements.compression.TarCompression;
import com.panayotis.jupidator.elements.compression.TarGZCompression;
import com.panayotis.jupidator.elements.compression.ZipCompression;
import com.panayotis.jupidator.elements.mirror.MirrorList;
import com.panayotis.jupidator.elements.mirror.MirroredFile;
import com.panayotis.jupidator.elements.security.Digester;
import com.panayotis.jupidator.elements.security.PermissionManager;
import com.panayotis.jupidator.gui.BufferListener;
import java.io.File;
import jupidator.launcher.XEFile;
import jupidator.launcher.XElement;

import static com.panayotis.jupidator.i18n.I18N._;

/**
 *
 * @author teras
 */
public class ElementFile extends JupidatorElement {

    private static final String EXTENSION = ".jupidator";
    private final CompressionMethod compression;
    private final MirroredFile source_location;
    private final File download_location;
    private final File uncompress_location;
    private final MirrorList mirrors;

    public ElementFile(String name, String source, String dest, String size, String compress, UpdaterAppElements elements, ApplicationInfo info) {
        super(name, dest, size, elements, info, ExecutionTime.MID);

        if (compress == null || compress.equals(""))
            compress = "none";
        String lcompress = compress.toLowerCase();
        if (lcompress.equals("none"))
            compression = new NullCompression();
        else if (lcompress.equals("zip"))
            compression = new ZipCompression();
        else if (lcompress.equals("bzip2") || lcompress.equals("bz2") || lcompress.equals("bz"))
            compression = new BZip2Compression(compress);
        else if (lcompress.equals("gz") || lcompress.equals("gzip"))
            compression = new GZipCompression(compress);
        else if (lcompress.equals("tar"))
            compression = new TarCompression(compress);
        else if (lcompress.equals("tar.gz") || lcompress.equals("tar.gzip") || lcompress.equals("tgz"))
            compression = new TarGZCompression(compress);
        else if (lcompress.equals("tar.bz2") || lcompress.equals("tar.bz") || lcompress.equals("tar.bzip2") || lcompress.equals("tbz2") || lcompress.equals("tbz"))
            compression = new TarBZCompression(compress);
        else
            compression = new InvalidCompression(compress);

        // Calculate source location
        source_location = new MirroredFile(source, getFileName(), info);
        source_location.setExtension(compression.getFilenameExtension());
        source_location.setSize(getSize());
        mirrors = elements.getMirrors();

        // Find download location
        if (requiresPrivileges())
            download_location = new File(PermissionManager.manager.requestSlot(), getFileName() + compression.getFilenameExtension() + EXTENSION);
        else
            download_location = new File(getDestinationFile() + compression.getFilenameExtension() + EXTENSION);
        uncompress_location = new File(download_location.getParent(), getFileName() + EXTENSION);
    }

    public boolean exists() {
        return new File(getDestinationFile()).exists();
    }

    public void addDigester(Digester digester) {
        source_location.addDigester(digester);
    }

    @Override
    public String toString() {
        return "+" + source_location.toString() + ">" + getDestinationFile();
    }

    public String fetch(UpdatedApplication application, BufferListener watcher) {
        if (compression instanceof InvalidCompression)
            return _("Invalid compression type: {0}", compression.getFilenameExtension());

        if (download_location == null)
            return _("Can not initialize download file {0}", getFileName());

        /* Create destination directory, if it does not exist */
        if (!FileUtils.makeDirectory(download_location.getParentFile()))
            return _("Unable to create directory structure under {0}", download_location.getParentFile().getPath());

        /* Remove old download/uncompressed file, in case it exists */
        if (FileUtils.rmTree(download_location) != null)
            return _("Could not remove old download file {0}", download_location.getPath());
        if (FileUtils.rmTree(uncompress_location) != null)
            return _("Could not remove old temporary file {0}", uncompress_location.getPath());

        /* Download file */
        String error = mirrors.downloadFile(source_location, download_location, watcher, application);
        if (error != null)
            return error;
        /* Successfully downloaded file */
        application.receiveMessage(_("File {0} sucessfully downloaded", getFileName()));
        return null;
    }

    public String prepare(UpdatedApplication application) {
        String status = compression.decompress(download_location, uncompress_location);
        if (status == null) {
            if (!compression.getFilenameExtension().equals(""))
                if (FileUtils.rmTree(download_location) != null)
                    application.receiveMessage(_("Unable to delete downloaded file {0}", download_location.getPath()));
            return null;
        }
        application.receiveMessage(status);
        return status;
    }

    public void cancel(UpdatedApplication application) {
        String res = FileUtils.rmTree(download_location);
        if (res != null)
            application.receiveMessage(res);
        res = FileUtils.rmTree(uncompress_location);
        if (res != null)
            application.receiveMessage(res);
    }

    @Override
    public XElement getExecElement() {
        File destination = new File(getDestinationFile());
        if (compression.isPackageBased())
            destination = destination.getParentFile();
        return new XEFile(uncompress_location.getPath(), destination.getAbsolutePath());
    }
}
