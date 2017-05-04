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

package com.panayotis.jupidator.producer;

import com.panayotis.jupidator.elements.FileUtils;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.Writer;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.zip.Deflater;
import java.util.zip.GZIPOutputStream;

public final class CFile extends CPath {

    private final long size;
    private final String md5;
    private final String sha256;
    //
    private File original;

    public CFile(File file, CDir parent) throws IOException {
        this(file.getName(), file.length(), getDigest(file, "MD5"), getDigest(file, "SHA-256"), parent);
        original = file;
    }

    public CFile(String pathname, long size, String md5, String sha256, CDir parent) {
        super(pathname, parent);
        this.size = size;
        this.md5 = md5;
        this.sha256 = sha256;
        this.original = null;
    }

    @Override
    protected void dump(Writer out, int depth) throws IOException {
        tabs(out, depth)
                .append("<file name=\"").append(getName())
                .append("\" size=\"").append(Long.toString(size))
                .append("\" md5=\"").append(md5)
                .append("\" sha256=\"").append(sha256)
                .append("\"/>\n");
    }

    private static String getDigest(File in, String algorithm) throws IOException {
        MessageDigest digest;
        FileInputStream fis = null;
        try {
            digest = MessageDigest.getInstance(algorithm);
            byte[] buffer = new byte[1024];
            digest.reset();
            int read;
            fis = new FileInputStream(in);
            while ((read = fis.read(buffer)) >= 0)
                digest.update(buffer, 0, read);

            byte[] outb = digest.digest();
            StringBuilder sbout = new StringBuilder();
            for (byte b : outb)
                sbout.append(String.format("%02x", b));
            return sbout.toString();
        } catch (NoSuchAlgorithmException ex) {
            throw new IOException("Algorithm error while digesting");
        } catch (IOException ex) {
            throw ex;
        } finally {
            if (fis != null)
                try {
                    fis.close();
                } catch (IOException ex) {
                }
        }
    }

    @Override
    protected void compare(CPath original, COutput out) throws IOException {
        if (original instanceof CFile) {
            if (!matchFile((CFile) original))
                store(out);
        } else {
            original.delete(out);
            store(out);
        }
    }

    @Override
    protected void store(COutput out) throws IOException {
        CDir parent = getParent();
        String srcdir = parent == null ? out.getVersion() : parent.getPath(out.getVersion());
        String destdir = parent == null ? DEFAULTROOT : parent.getPath(DEFAULTROOT);
        File compress = new File(out.getDir(), srcdir + PS + getName() + ".gz");

        compressFile(original, compress);

        tabs(out.getWriter(), 3)
                .append("<file name=\"").append(getName())
                .append("\" compress=\"gz\" sourcedir=\"").append(srcdir)
                .append("\" destdir=\"").append(destdir)
                .append("\" size=\"").append(Long.toString(new File(compress.getPath()).length())).append("\">") // we need this trick since file size might not be calculated correctly 
                .append(" <sha value=\"").append(getDigest(compress, "SHA-256")).append("\"/> ")
                .append("</file>\n");
    }

    private boolean matchFile(CFile other) {
        return size == other.size && md5.equals(other.md5) && sha256.equals(other.sha256);
    }

    private void compressFile(File original, File compressed) throws IOException {
        if (!FileUtils.makeDirectory(compressed.getParentFile()))
            throw new IOException("Unable to create destination directory " + compressed.getParent());

        BufferedInputStream in = null;
        BufferedOutputStream out = null;
        try {
            in = new BufferedInputStream(new FileInputStream(original));
            out = new BufferedOutputStream(new GZIPOutputStream(new FileOutputStream(compressed)) {
                {
                    def.setLevel(Deflater.BEST_COMPRESSION);
                }
            });
            byte[] buffer = new byte[1024];
            int found;
            while ((found = in.read(buffer)) >= 0)
                out.write(buffer, 0, found);
            out.flush();
        } catch (IOException ex) {
            throw ex;
        } finally {
            if (in != null)
                in.close();
            if (out != null)
                out.close();
        }
    }
}
