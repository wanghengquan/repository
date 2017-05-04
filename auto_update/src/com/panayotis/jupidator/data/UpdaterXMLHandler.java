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

package com.panayotis.jupidator.data;

import com.panayotis.jupidator.ApplicationInfo;
import com.panayotis.jupidator.elements.ElementChmod;
import com.panayotis.jupidator.elements.ElementChown;
import com.panayotis.jupidator.elements.ElementExec;
import com.panayotis.jupidator.elements.ElementFile;
import com.panayotis.jupidator.elements.ElementKill;
import com.panayotis.jupidator.elements.ElementRm;
import com.panayotis.jupidator.elements.ElementWait;
import com.panayotis.jupidator.elements.mirror.Mirror;
import com.panayotis.jupidator.elements.security.Digester;
import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

/**
 *
 * @author teras
 */
public class UpdaterXMLHandler extends DefaultHandler {

    private UpdaterAppElements elements; // Location to store various application elements, needed in GUI
    private Arch lastarch; // The last loaded arch - used to set additional parameters to this architecture
    private Version full; // The full aggregated list of the latest files, in order to upgrade
    private Version current_version;    // The list of files for the current reading "version" object
    private String current_versionname;    // The current version name as given to the version tag
    private boolean invalid_arch;    // The current arch: if it is null it means that it is not compatible with the current system. Used to attach elements to version.
    private StringBuilder descbuffer;    // Temporary buffer to store descriptions
    private String description;    // Description of current version, will be added only if at least one valid arch was found
    private ApplicationInfo appinfo;    // Remember information about the current running application
    private ElementExec lastSeenExecElement = null;    // Use this trick to store arguments in an exec element, instead of launcher. If it is null, they are stored in the launcher.
    private ElementFile lastFileElement = null;   // Remember last Add element, to add digesters later on

    public UpdaterXMLHandler(ApplicationInfo appinfo) { // We are interested only for version "current_version" onwards
        elements = new UpdaterAppElements();
        this.appinfo = appinfo;
        full = new Version();
    }

    @Override
    public void startElement(String uri, String localName, String qName, Attributes attr) {
        if (qName.equals("architect")) {
            lastarch = Arch.getArch(attr.getValue("tag"), attr.getValue("os"), attr.getValue("arch"));
            if (lastarch != null)
                full.setArch(lastarch);
        } else if (qName.equals("launcher")) {
            if (lastarch != null)
                lastarch.setExec(attr.getValue("exec"), appinfo);
        } else if (qName.equals("argument"))
            if (lastSeenExecElement == null) {
                if (lastarch != null)
                    lastarch.addArgument(attr.getValue("value"), appinfo);
            } else
                lastSeenExecElement.addArgument(attr.getValue("value"), appinfo);
        else if (qName.equals("version")) {
            int release_last = TextUtils.getInt(attr.getValue("release"), 0);
            current_versionname = attr.getValue("version");
            if (current_versionname == null)
                current_versionname = "";
            elements.updateVersion(release_last, current_versionname);
            current_version = null;
            if (appinfo == null || release_last > appinfo.getRelease())
                current_version = new Version();
        } else if (qName.equals("description")) {
            description = "";
            descbuffer = current_version == null ? null : new StringBuilder();
        } else if (qName.equals("arch")) {
            if (current_version == null)
                return;
            invalid_arch = !full.getArch().isCompatibleWith(attr.getValue("name"));
            if (!invalid_arch)
                current_version.setGraphicalDeployer(TextUtils.isTrue(attr.getValue("gui")));
        } else if (qName.equals("file")) {
            if (shouldIgnore(attr.getValue("forceinstall")))
                return;
            lastFileElement = new ElementFile(attr.getValue("name"), attr.getValue("sourcedir"),
                    attr.getValue("destdir"), attr.getValue("size"),
                    attr.getValue("compress"), elements, appinfo);
            if (TextUtils.isTrue(attr.getValue("ifexists")) && (!lastFileElement.exists())) {
                lastFileElement = null;
                return;
            }
            current_version.put(lastFileElement);
        } else if (qName.equals("rm")) {
            if (shouldIgnore(attr.getValue("forceinstall")))
                return;
            current_version.put(new ElementRm(attr.getValue("file"), elements, appinfo));
        } else if (qName.equals("chmod")) {
            if (shouldIgnore(attr.getValue("forceinstall")))
                return;
            current_version.put(new ElementChmod(attr.getValue("file"), attr.getValue("attr"),
                    attr.getValue("recursive"), elements, appinfo));
        } else if (qName.equals("chown")) {
            if (shouldIgnore(attr.getValue("forceinstall")))
                return;
            current_version.put(new ElementChown(attr.getValue("file"), attr.getValue("attr"),
                    attr.getValue("recursive"), elements, appinfo));
        } else if (qName.equals("exec")) {
            if (shouldIgnore(attr.getValue("forceinstall")))
                return;
            lastSeenExecElement = new ElementExec(attr.getValue("executable"), attr.getValue("input"), attr.getValue("time"), elements, appinfo);
            current_version.put(lastSeenExecElement);
        } else if (qName.equals("wait")) {
            if (shouldIgnore(attr.getValue("forceinstall")))
                return;
            current_version.put(new ElementWait(attr.getValue("msecs"), attr.getValue("time"), elements, appinfo));
        } else if (qName.equals("kill")) {
            if (shouldIgnore(attr.getValue("forceinstall")))
                return;
            current_version.put(new ElementKill(attr.getValue("process"), attr.getValue("signal"), elements, appinfo));
        } else if (qName.equals("md5")) {
            if (lastFileElement == null)
                return;
            Digester d = Digester.getDigester("MD5");
            d.setHash(attr.getValue("value"));
            lastFileElement.addDigester(d);
        } else if (qName.equals("sha1")) {
            if (lastFileElement == null)
                return;
            Digester d = Digester.getDigester("SHA1");
            d.setHash(attr.getValue("value"));
            lastFileElement.addDigester(d);
        } else if (qName.equals("sha2")) {
            if (lastFileElement == null)
                return;
            String type = attr.getValue("type");
            if (type == null)
                type = "256";
            Digester d = Digester.getDigester("SHA-" + attr.getValue(type));
            d.setHash(attr.getValue("value"));
            lastFileElement.addDigester(d);
        } else if (qName.equals("mirror"))
            elements.getMirrors().addMirror(new Mirror(attr.getValue("constructor"), appinfo, attr.getValue("url")));
        else if (qName.equals("updatelist")) {
            String baseurl = attr.getValue("baseurl");
            elements.setBaseURL(baseurl);
            elements.getMirrors().addMirror(new Mirror(appinfo, baseurl));
            elements.setAppName(attr.getValue("application"));
            elements.setIconpath(attr.getValue("icon"));
            elements.setJupidatorVersion(attr.getValue("jupidator"));
        }
    }

    private boolean shouldIgnore(String force) {
        if (invalid_arch || current_version == null || appinfo == null)
            return true;
        if (!appinfo.isDistributionBased())
            return false;
        return !TextUtils.isTrue(force);
    }

    @Override
    public void endElement(String uri, String localName, String qName) {
        if (qName.equals("arch"))
            invalid_arch = true;
        else if (qName.equals("version")) {
            if (current_version != null) {
                boolean activeVersion = !current_version.isEmpty();
                if (activeVersion)
                    full.merge(current_version);
                elements.addLogItem(current_versionname, description, activeVersion);
            }
            current_version = null;
            current_versionname = null;
        } else if (qName.equals("description")) {
            description = descbuffer == null ? "" : descbuffer.toString();
            descbuffer = null;
        } else if (qName.equals("exec"))
            lastSeenExecElement = null;
        else if (qName.equals("file"))
            lastFileElement = null;
    }

    @Override
    public void characters(char[] ch, int start, int length) {
        if (descbuffer == null)
            return;
        String info = new String(ch, start, length).trim();
        if (info.equals(""))
            return;
        descbuffer.append(info);
    }

    UpdaterAppElements getAppElements() {
        return elements;
    }

    Version getVersion() {
        return full;
    }
}
