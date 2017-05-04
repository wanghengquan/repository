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
import com.panayotis.jupidator.data.UpdaterAppElements;
import com.panayotis.jupidator.elements.security.PermissionManager;
import jupidator.launcher.XEKill;
import jupidator.launcher.XElement;

/**
 *
 * @author teras
 */
public class ElementKill extends ElementNative {

    private final String signal;

    public ElementKill(String application, String signal, UpdaterAppElements elements, ApplicationInfo info) {
        super("kill", application, null, ExecutionTime.BEFORE, elements, info);
        this.signal = signal == null ? null : signal.toUpperCase();
    }

    @Override
    protected boolean estimatePrivileges(UpdaterAppElements elements) {
        return PermissionManager.manager.forcePrivileges();
    }

    @Override
    public XElement getExecElement() {
        return new XEKill(getDestinationFile(), signal);
    }
}
