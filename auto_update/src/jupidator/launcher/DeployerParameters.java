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

package jupidator.launcher;

import com.panayotis.jupidator.elements.FileUtils;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author teras
 */
public class DeployerParameters implements Serializable {

    private List<XElement> elements = new ArrayList<XElement>();
    private List<String> relaunch = new ArrayList<String>();
    private boolean headless = true;
    public final String applocation;

    public DeployerParameters(String applocation) {
        this.applocation = applocation;
    }

    public void setElements(List<XElement> elements) {
        if (elements == null)
            elements = new ArrayList<XElement>();
        this.elements = elements;
    }

    public void addElement(XElement element) {
        elements.add(element);
    }

    public void setHeadless(boolean headless) {
        this.headless = headless;
    }

    public void setRelaunchCommand(List<String> relaunch) {
        if (relaunch == null)
            relaunch = new ArrayList<String>();
        this.relaunch = relaunch;
    }

    public List<XElement> getElements() {
        /* Do all this, because windows demands a 3 second delay before starting updating */
        ArrayList<XElement> oselements = new ArrayList<XElement>();
        if (OperatingSystem.isWindows)
            oselements.add(new XEWait(3000));
        oselements.addAll(elements);
        return oselements;
    }

    public boolean isHeadless() {
        return headless;
    }

    public List<String> getRelaunchCommand() {
        return relaunch;
    }

    public boolean storeParameters(File out) {
        if (out == null)
            return false;
        FileUtils.makeDirectory(out.getParentFile());
        ObjectOutputStream output = null;
        boolean status = false;
        try {
            output = new ObjectOutputStream(new FileOutputStream(out));
            output.writeObject(this);
            status = true;
        } catch (IOException ex) {
        } finally {
            if (output != null)
                try {
                    output.close();
                } catch (IOException ex) {
                    status = false;
                }
        }
        return status;
    }
}
