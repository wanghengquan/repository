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

import java.util.ArrayList;

/**
 *
 * @author teras
 */
public final class XNativeCommand {

    public final String command;
    public final ArrayList<String> arguments;
    public final String input;

    public XNativeCommand(String command, ArrayList<String> arguments, String input) {
        this.command = command;
        this.arguments = arguments == null && command != null ? new ArrayList<String>() : arguments;
        this.input = input;
    }

    public String[] getArgs() {
        if (command == null)
            return null;
        String[] res = new String[arguments.size() + 1];
        res[0] = command;
        System.arraycopy(arguments.toArray(), 0, res, 1, arguments.size());
        return res;
    }
}
