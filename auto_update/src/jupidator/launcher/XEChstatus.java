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
public class XEChstatus extends XSimpleNativeElement {

    private final String command;
    private final String mode;
    private final boolean recursive;

    public XEChstatus(String command, String target, String mode, boolean recursive) {
        super(target, null);
        this.command = command;
        this.mode = mode;
        this.recursive = recursive;
    }

    @Override
    protected XNativeCommand getCommand() {
        ArrayList<String> args = new ArrayList<String>();
        if (recursive)
            args.add("-R");
        args.add(mode);
        args.add(target);
        return new XNativeCommand(command, args, input);
    }
}
