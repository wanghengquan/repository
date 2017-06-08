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

import com.panayotis.jupidator.Updater;
import com.panayotis.jupidator.data.TextUtils;
import com.panayotis.jupidator.elements.security.PermissionManager;
import com.panayotis.jupidator.gui.BufferListener;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.StringTokenizer;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import static com.panayotis.jupidator.i18n.I18N._;

/**
 *
 * @author teras
 */
public class FileUtils {

    public final static String JAVAHOME = TextUtils.getProperty("java.home");
    public final static String JAVABIN = getJavaExec();

    private static String getJavaExec() {
        String EXEC = TextUtils.getSystemName().contains("windows") ? "javaw.exe" : "java";
        String file;
        file = JAVAHOME + File.separator + "bin" + File.separator + EXEC;
        if (new File(file).isFile())
            return file;
        file = JAVAHOME + File.separator + "jre" + File.separator + "bin" + File.separator + EXEC;
        if (new File(file).isFile())
            return file;
        return null;
    }

    public static String copyFile(InputStream in, OutputStream out, BufferListener blisten, boolean closeStreams) {
        String message = null;
        byte[] buffer = new byte[1024];
        int count;

        try {
            while ((count = in.read(buffer)) != -1) {
                if (Thread.interrupted())
                    throw new IOException("User asked to cancel update");
                out.write(buffer, 0, count);
                if (blisten != null)
                    blisten.addBytes(count);
            }
        } catch (IOException ex) {
            message = ex.getMessage();
        } finally {
            if (closeStreams) {
                try {
                    if (in != null)
                        in.close();
                } catch (IOException ex) {
                    if (message != null)
                        message = ex.getMessage();
                }
                try {
                    if (out != null)
                        out.close();
                } catch (IOException ex) {
                    if (message != null)
                        message = ex.getMessage();
                }
            }
        }
        return message;
    }

    public static String copyJavaPackage(String PACKAGENAME, String FILEHOME) {
        String PACKAGEZIP = PACKAGENAME.replace('.', '/') + '/';
        String PACKAGEDIR = PACKAGEZIP.replace('/', File.separatorChar);
        File depdir = new File(FILEHOME + File.separator + PACKAGEDIR.replace("/", File.separator));
        makeDirectory(depdir);
        if ((!depdir.isDirectory()) || (!PermissionManager.manager.canWrite(depdir)))
            return _("Path {0} is not writable.", depdir.getPath());

        for (File cp : getClassPaths())
            if (cp.isFile()) {
                ZipFile zip = null;
                try {
                    zip = new ZipFile(cp);
                    for (Enumeration<? extends ZipEntry> e = (Enumeration<? extends ZipEntry>) zip.entries(); e.hasMoreElements();) {
                        ZipEntry entry = e.nextElement();
                        String name = entry.getName();
                        if (name.startsWith(PACKAGEZIP) && (!name.endsWith("/"))) {
                            String FILEOUT = FILEHOME + File.separator + entry.getName().replace("/", File.separator);
                            if (!FILEOUT.endsWith(File.separator)) {
                                FileOutputStream fout = null;
                                try {
                                    fout = new FileOutputStream(FILEOUT);
                                    String status = copyFile(zip.getInputStream(entry), fout, null, true);
                                    if (status != null)
                                        return status;
                                } catch (IOException ex) {
                                    return ex.getMessage();
                                } finally {
                                    if (fout != null)
                                        fout.close();
                                }
                            }
                        }
                    }
                } catch (IOException ex) {
                } finally {
                    if (zip != null)
                        try {
                            zip.close();
                        } catch (IOException ex) {
                        }
                }
            } else {
                //    listener.receiveMessage(_("Checking directory {0} for classes.", path));
                File[] entries = new File(cp, PACKAGEDIR).listFiles();
                if (entries != null)
                    for (int i = 0; i < entries.length; i++) {
                        String status;
                        try {
                            String FILEOUTS = depdir.getPath() + File.separator + entries[i].getName();
                            status = copyFile(new FileInputStream(entries[i]), new FileOutputStream(FILEOUTS), null, true);
                            if (status != null)
                                return status;
                        } catch (FileNotFoundException ex) {
                            Logger.getLogger(FileUtils.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
            }
        return null;
    }

    public static String getClassHome(Class clazz) {
        File path = getClassPath(clazz);
        if (path != null) {
            if (path.isFile())
                path = path.getParentFile();
            return path.getAbsolutePath();
        }
        return ".";
    }

    private static File getClassPath(Class clazz) {
        List<File> paths = getClassPaths();
        if (clazz == null) {
            String blacklist = Updater.class.getPackage().getName();
            StackTraceElement[] el = Thread.currentThread().getStackTrace();
            for (int i = 1; i < el.length; i++)
                if (!el[i].getClassName().startsWith(blacklist))
                    try {
                        clazz = Class.forName(el[i].getClassName());
                    } catch (ClassNotFoundException ex) {
                    }
        }
        String classfile = clazz.getName().replace(".", "/") + ".class";
        for (File cp : paths)
            if (classFileExists(cp, classfile))
                return cp;
        return null;
    }

    private static boolean classFileExists(File cp, String classfile) {
        if (cp.isDirectory())
            return new File(cp, classfile).isFile();
        else if (cp.isFile()) {
            ZipFile file = null;
            try {
                file = new ZipFile(cp);
                return file.getEntry(classfile) != null;
            } catch (IOException ex) {
                return false;
            } finally {
                if (file != null)
                    try {
                        file.close();
                    } catch (IOException ex) {
                    }
            }
        } else
            return false;
    }

    private static List<File> getClassPaths() {
        /* Create initial classpath list - will be expanded in classpath inside manifest of JAR files */
        List<String> classpaths = new ArrayList<String>();
        List<File> paths = new ArrayList<File>();
        StringTokenizer tok = new StringTokenizer(TextUtils.getProperty("java.class.path"), File.pathSeparator);
        while (tok.hasMoreElements())
            classpaths.add(tok.nextToken());

        String path;
        while (classpaths.size() > 0) {     // List is being manipulated inside this loop in getClassPathFromManifest
            path = classpaths.get(0);
            classpaths.remove(0);
            File cp = new File(path);
            if (cp.isDirectory())
                paths.add(cp);
            else if (cp.isFile()) {
                ZipFile zip = null;
                try {
                    zip = new ZipFile(cp);
                    if (zip.size() > 0) {       /* Make sure it is a zip file */
                        paths.add(cp);
                        getClassPathFromManifest(zip, classpaths, new File(path).getParent());
                    }
                } catch (IOException ex) {
                } finally {
                    if (zip != null)
                        try {
                            zip.close();
                        } catch (IOException ex) {
                        }
                }
            }
        }
        return paths;
    }

    /**
     * Make sure that in this zip entry there is no classpath definition
     */
    private static void getClassPathFromManifest(ZipFile zip, List<String> classpaths, String parent) {
        if (parent == null)
            parent = "";
        else
            parent = parent + File.separator;

        ZipEntry manifest = zip.getEntry("META-INF/MANIFEST.MF");
        if (manifest != null) {
            BufferedReader cpin = null;
            try {
                String line;
                cpin = new BufferedReader(new InputStreamReader(zip.getInputStream(manifest)));
                while ((line = cpin.readLine()) != null)
                    if (line.toLowerCase().startsWith("class-path:")) {
                        String nextline;
                        while ((nextline = cpin.readLine()) != null && nextline.startsWith(" "))
                            line = line + nextline.substring(1);
                        StringTokenizer tok = new StringTokenizer(line.substring(11).replace("/", File.separator));
                        while (tok.hasMoreElements())
                            classpaths.add(parent + tok.nextToken());
                        return;
                    }
            } catch (IOException ex) {
            } finally {
                try {
                    if (cpin != null)
                        cpin.close();
                } catch (IOException ex) {
                }
            }
        }
    }

    public static boolean makeDirectory(File dirname) {
        if (dirname.exists())
            return dirname.isDirectory();
        return dirname.mkdirs();
    }

    public static String rmTree(File req) {
        if (req == null || !req.exists())
            return null;
        if (req.isDirectory()) {
            File[] list = req.listFiles();
            if (list != null)
                for (File file : list) {
                    String res = rmTree(file);
                    if (res != null)
                        return res;
                }
        }
        if (req.delete())
            return null;
        return _("Unable to delete file {0}", req.getPath());
    }

    public static boolean setExecute(String path) {
        try {
            Process proc = Runtime.getRuntime().exec(new String[]{"chmod", "a+x", path});
            proc.waitFor();
            return true;
        } catch (InterruptedException ex) {
        } catch (IOException ex) {
        }
        return false;
    }
}
