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

package com.panayotis.jupidator.helpers;

import com.panayotis.jupidator.ApplicationInfo;
import com.panayotis.jupidator.Updater;
import com.panayotis.jupidator.UpdaterException;
import com.panayotis.jupidator.producer.CPath;
import com.panayotis.jupidator.versioning.SystemVersion;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Date;
import jupidator.launcher.OperatingSystem;

/**
 *
 * @author teras
 */
public class Launcher {

    private final static String emphOn, emphOff;

    static {
        if (OperatingSystem.isWindows)
            emphOn = emphOff = "";
        else {
            emphOn = "\033[0m\033[1m";
            emphOff = "\033[0m";
        }
    }

    @SuppressWarnings("CallToThreadDumpStack")
    public static void main(String[] args) {
        if (args.length < 1)
            usage();
        if (args[0].equals("-l") || args[0].equals("--list"))
            list(args);
        else if (args[0].equals("-p") || args[0].equals("--produce"))
            compare(args);
        else if (args[0].equals("-c") || args[0].equals("--create"))
            create(args);
        else
            update(args);
    }

    private static void usage() {
        System.err.println(emphOn + "Jupidator version " + SystemVersion.VERSION + " release " + SystemVersion.RELEASE + emphOff);
        System.err.println("Usage:");
        System.err.println();
        System.err.println(emphOn + "java -jar jupidator.jar [-u|--update] URL [APPHOME [RELEASE [VERSION]]]" + emphOff);
        System.err.println("Start the update mechanism from the command line for a specific application. Valid options are:");
        System.err.println("     APPHOME defaults to .");
        System.err.println("     RELEASE defaults to 1");
        System.err.println("     VERSION defaults to null");
        System.err.println();
        System.err.println(emphOn + "java -jar jupidator.jar -l|--list [DIR]" + emphOff);
        System.err.println("Create a signature XML file to store current status of a specific directory, to be used later on with the --produce command. Valid options are:");
        System.err.println("     DIR defaults to .");
        System.err.println();
        System.err.println(emphOn + "java -jar jupidator.jar -p|--produce [NEWDIR [VERSION [OUTDIR [OLDSTRUCT]]]]" + emphOff);
        System.err.println("Find differences between a given directory and XML status information as produced by --list command, and output this information to disk. Valid options are:");
        System.err.println("     NEWDIR defaults to .");
        System.err.println("     VERSION defaults to 0.1");
        System.err.println("     OUTDIR defaults to output_DATE");
        System.err.println("     OLDSTRUCT defaults to stdin");
        System.err.println();
        System.err.println(emphOn + "java -jar jupidator.jar -c|--create URL [OUTPUT]" + emphOff);
        System.err.println("Create a styled changelog file. Valid options are:");
        System.err.println("     URL the location of the changelog");
        System.err.println("     OUTPUT the output file");
        System.err.println();
        System.exit(-1);
    }

    private static void compare(String[] args) {
        try {
            String version = args.length < 3 ? "0.1" : args[2];
            if (version.isEmpty())
                throw new IOException("VERSION should not be empty");
            if (version.contains("/") || version.contains("\\"))
                throw new IOException("VERSION should not contain the '/' or '\\' caracter");

            CPath current = CPath.construct(new File(args.length < 2 ? "." : args[1]));
            CPath old = CPath.construct(new InputStreamReader(args.length < 5 ? System.in : new FileInputStream(args[4]), "UTF-8"));
            String filename = args.length < 4 ? "output_" + new SimpleDateFormat("yMMdd_HHmmss").format(new Date()) : args[3];
            current.findDiff(old, new File(filename), version);
        } catch (IOException ex) {
            displayError(ex);
        }
    }

    private static void list(String[] args) {
        try {
            CPath path = CPath.construct(new File(args.length < 2 ? "." : args[1]));
            path.dump(new OutputStreamWriter(System.out, "UTF-8"));
        } catch (Exception ex) {
            displayError(ex);
        }
    }

    private static void create(String[] args) {
        if (args.length < 2)
            throw new NullPointerException("The changelog input URL is required.");
        BufferedWriter out = null;
        try {
            String cl = new Updater(args[1], ".", null).getChangeLog();
            out = new BufferedWriter(new OutputStreamWriter(args.length > 2 ? new FileOutputStream(args[2]) : System.out, "UTF-8"));
            out.write(cl);
            out.close();
        } catch (Exception ex) {
            ex.printStackTrace(System.out);
        } finally {
            try {
                if (out != null)
                    out.close();
            } catch (IOException ex) {
            }
        }
    }

    private static void update(String[] args) {
        String URL;
        String APPHOME = ".";
        int RELEASE = 1;
        String VERSION = null;
        String FORCE_CONSOLE = "false";

        /* 
         * Ignore -u/--update parameter. 
         * This is useful when the pathname is indeed one of the option shortcuts, like "-c" or "--update"
         */
        if (args[0].equals("-u") || args[0].equals("--update")) {
            String[] nargs = new String[args.length - 1];
            System.arraycopy(args, 1, nargs, 0, nargs.length);
            args = nargs;
        }

        URL = args[0];
        if (args.length > 1)
            APPHOME = args[1];
        if (args.length > 2)
            try {
                RELEASE = Integer.parseInt(args[2]);
            } catch (NumberFormatException ex) {
            }
        if (args.length > 3)
            VERSION = args[3];
        if (args.length > 4)
        	FORCE_CONSOLE = args[4];

        ApplicationInfo ap = new ApplicationInfo(APPHOME, RELEASE, VERSION);

        try {
        	Updater upd = null;
        	if (FORCE_CONSOLE.equalsIgnoreCase("true"))
        		upd = new Updater(URL, ap, null, true);
        	else
        		upd = new Updater(URL, ap, null, false);
            upd.actionDisplay();
        } catch (UpdaterException ex) {
            displayError(ex);
        }
    }

    private static void displayError(Exception ex) {
        try {
            ex.printStackTrace(new PrintWriter(new OutputStreamWriter(System.err, "UTF-8"), true));
        } catch (UnsupportedEncodingException ex1) {
        }
        System.err.println();
        usage();
    }
}
