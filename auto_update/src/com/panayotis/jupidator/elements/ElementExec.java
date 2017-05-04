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
import java.util.ArrayList;
import jupidator.launcher.XEExec;
import jupidator.launcher.XElement;

/**
 *
 * @author teras
 */
public class ElementExec extends ElementNative {

    private ArrayList<String> arguments;

    public ElementExec(String command, String input, String exectime, UpdaterAppElements elements, ApplicationInfo info) {
        super(command, String.valueOf(Math.random()), input, // Random hash for this exec
                ExecutionTime.parse(exectime, ExecutionTime.AFTER), elements, info);
        arguments = new ArrayList<String>();
    }

    public void addArgument(String argument, ApplicationInfo appinfo) {
        if (appinfo != null && argument != null)
            arguments.add(appinfo.applyVariables(argument));
    }

    @Override
    public XElement getExecElement() {
        return new XEExec(command, input, arguments);
    }
}
