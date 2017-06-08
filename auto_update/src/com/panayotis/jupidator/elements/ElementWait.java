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
import com.panayotis.jupidator.data.TextUtils;
import com.panayotis.jupidator.data.UpdaterAppElements;
import com.panayotis.jupidator.gui.BufferListener;
import jupidator.launcher.XEWait;
import jupidator.launcher.XElement;

/**
 *
 * @author teras
 */
public class ElementWait extends JupidatorElement {

    private final int msecs;

    public ElementWait(String msecs, String exectime, UpdaterAppElements elements, ApplicationInfo appinfo) {
        super(String.valueOf(Math.random()), elements, appinfo, ExecutionTime.parse(exectime, ExecutionTime.BEFORE));
        this.msecs = TextUtils.getInt(msecs, 1000);
    }

    @Override
    protected boolean estimatePrivileges(UpdaterAppElements elements) {
        return false;
    }

    public String fetch(UpdatedApplication application, BufferListener blisten) {
        return null;
    }

    public String prepare(UpdatedApplication application) {
        return null;
    }

    public void cancel(UpdatedApplication application) {
    }

    @Override
    public XElement getExecElement() {
        return new XEWait(msecs);
    }
}
