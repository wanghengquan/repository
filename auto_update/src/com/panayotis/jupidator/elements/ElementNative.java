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

/**
 *
 * @author teras
 */
public abstract class ElementNative extends JupidatorElement {

    protected final String command;
    protected final String input;

    public ElementNative(String command, String file, String input, ExecutionTime time, UpdaterAppElements elements, ApplicationInfo appinfo) {
        super(file, elements, appinfo, time);
        this.command = command == null ? "" : appinfo.applyVariables(command);
        this.input = input == null ? null : appinfo.applyVariables(input);
    }

    public String fetch(UpdatedApplication application, BufferListener blisten) {
        return null;
    }

    public void cancel(UpdatedApplication application) {
    }

    public String prepare(UpdatedApplication application) {
        return null;
    }

    @Override
    public String getHash() {
        return command + ":" + super.getHash();
    }
}
