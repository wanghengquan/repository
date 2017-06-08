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
import com.panayotis.jupidator.gui.BufferListener;
import jupidator.launcher.XERm;
import jupidator.launcher.XElement;

import static com.panayotis.jupidator.i18n.I18N._;

/**
 *
 * @author teras
 */
public class ElementRm extends JupidatorElement {

    public ElementRm(String file, UpdaterAppElements elements, ApplicationInfo info) {
        super(file, elements, info, ExecutionTime.MID);
    }

    @Override
    public String toString() {
        return "-" + getDestinationFile();
    }

    /* Nothig to download */
    public String fetch(UpdatedApplication application, BufferListener blisten) {
        return null;
    }

    /* Nothing to deploy */
    public String prepare(UpdatedApplication application) {
        application.receiveMessage(_("File {0} will be deleted, if exists.", getDestinationFile()));
        return null;
    }

    public void cancel(UpdatedApplication application) {
    }

    @Override
    public XElement getExecElement() {
        return new XERm(getDestinationFile());
    }
}
