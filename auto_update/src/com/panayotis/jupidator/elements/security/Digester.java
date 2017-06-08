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

package com.panayotis.jupidator.elements.security;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;

/**
 *
 * @author teras
 */
public class Digester {

    private MessageDigest digest;
    private byte[] hash;
    private final String algorithm;

    public static Digester getDigester(String algorithm) {
        if (algorithm == null)
            return null;
        try {
            return new Digester(algorithm);
        } catch (NoSuchAlgorithmException ex) {
            return null;
        }
    }

    private Digester(String algorithm) throws NoSuchAlgorithmException {
        digest = MessageDigest.getInstance(algorithm);
        this.algorithm = algorithm;
    }

    public void setHash(String hash) {
        if (hash.length() != (digest.getDigestLength() * 2)) {
            this.hash = null;
            return;
        }
        this.hash = new byte[digest.getDigestLength() < (hash.length() / 2) ? digest.getDigestLength() : (hash.length() / 2)];
        for (int i = 0; i < this.hash.length; i += 2)
            this.hash[i] = Byte.parseByte(hash.substring(i * 2, i * 2 + 2), 16);
    }

    public boolean checkFile(File file) {
        if (hash == null || file == null)
            return false;

        FileInputStream fis = null;
        try {
            byte[] buffer = new byte[1024];
            digest.reset();
            int read;
            fis = new FileInputStream(file);
            while ((read = fis.read(buffer)) >= 0)
                digest.update(buffer, 0, read);
            return Arrays.equals(digest.digest(), hash);
        } catch (Exception ex) {
        } finally {
            if (fis != null)
                try {
                    fis.close();
                } catch (IOException ex) {
                }
        }
        return false;
    }

    public String getAlgorithm() {
        return algorithm;
    }
}
