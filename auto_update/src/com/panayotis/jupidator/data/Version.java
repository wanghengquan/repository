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
import com.panayotis.jupidator.UpdaterException;
import com.panayotis.jupidator.elements.ExecutionTime;
import com.panayotis.jupidator.elements.JupidatorElement;
import java.io.IOException;
import java.io.Serializable;
import java.util.LinkedHashMap;
import java.util.Set;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.xml.sax.SAXException;

/**
 *
 * @author teras
 */
public class Version implements Serializable {

    private LinkedHashMap<String, JupidatorElement> elements = new LinkedHashMap<String, JupidatorElement>();
    private UpdaterAppElements appel;
    private UpdaterProperties appprop;
    private Arch arch = Arch.defaultArch();
    private boolean graphical_gui;

    public static Version loadVersion(String xml, ApplicationInfo appinfo) throws UpdaterException {
        try {
            UpdaterProperties prop = new UpdaterProperties(appinfo);
            if (prop.isTooSoon()) {
                Version v = new Version();
                v.appel = new UpdaterAppElements();
                return v;
            }
            SAXParser parser = SAXParserFactory.newInstance().newSAXParser();
            UpdaterXMLHandler handler = new UpdaterXMLHandler(appinfo);
            parser.parse(xml, handler);
            Version v = handler.getVersion();
            v.appel = handler.getAppElements();
            v.appprop = prop;
            v.sort();
            return v;
        } catch (SAXException ex) {
            throw new UpdaterException(ex.getMessage());
        } catch (IOException ex) {
            throw new UpdaterException(ex.getClass().getName() + ": " + ex.getMessage());
        } catch (ParserConfigurationException ex) {
            throw new UpdaterException(ex.getMessage());
        }
    }

    public void replaceArch(Arch arch) {
        if (arch != null)
            this.arch = arch;
    }

    @Override
    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append("[Version").append('\n');
        for (String tag : elements.keySet()) {
            b.append("  ");
            b.append(elements.get(tag).toString());
            b.append('\n');
        }
        b.append("]");
        return b.toString();
    }

    public UpdaterAppElements getAppElements() {
        return appel;
    }

    public UpdaterProperties getUpdaterProperties() {
        return appprop;
    }

    void merge(Version other) {
        if (other == null)
            return;

        JupidatorElement fother, fthis, fnew;
        for (String tag : other.elements.keySet()) {
            fother = other.elements.get(tag);
            fthis = elements.get(tag);
            if (fthis == null)
                elements.put(tag, fother);
            else {
                fnew = fthis.getNewestRelease(fother);
                elements.put(tag, fnew);
            }
        }
        graphical_gui |= other.graphical_gui;
    }

    public Arch getArch() {
        return arch;
    }

    public void setArch(Arch arch) {
        this.arch = arch;
    }

    void setGraphicalDeployer(boolean graphical_gui) {
        this.graphical_gui = graphical_gui;
    }

    public boolean isGraphicalDeployer() {
        return graphical_gui;
    }

    private void sort() {
        JupidatorElement element;
        ExecutionTime time;
        LinkedHashMap<String, JupidatorElement> before = new LinkedHashMap<String, JupidatorElement>();
        LinkedHashMap<String, JupidatorElement> mid = new LinkedHashMap<String, JupidatorElement>();
        LinkedHashMap<String, JupidatorElement> after = new LinkedHashMap<String, JupidatorElement>();
        for (String key : elements.keySet()) {
            element = elements.get(key);
            time = element.getExectime();
            if (time.equals(ExecutionTime.BEFORE))
                before.put(key, element);
            else if (time.equals(ExecutionTime.AFTER))
                after.put(key, element);
            else
                mid.put(key, element);
        }
        elements = new LinkedHashMap<String, JupidatorElement>();
        elements.putAll(before);
        elements.putAll(mid);
        elements.putAll(after);
    }

    public int size() {
        return elements.size();
    }

    public Set<String> keySet() {
        return elements.keySet();
    }

    public JupidatorElement get(String key) {
        return elements.get(key);
    }

    public void put(JupidatorElement element) {
        elements.put(element.getHash(), element);
    }

    public boolean isEmpty() {
        return elements.isEmpty();
    }
}
