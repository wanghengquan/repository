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

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;

/**
 *
 * @author teras
 */
public abstract class XNativeElement extends XTargetElement {

    protected final String input;

    public XNativeElement(String target, String input) {
        super(target);
        this.input = input;
    }

    protected static String exec(XNativeCommand command) {
        StringBuilder output = new StringBuilder();
        Visuals.info("Executing " + command.command);
        try {
            Process p = Runtime.getRuntime().exec(command.getArgs());
            if (command.input != null && command.input.length() > 0) {
                BufferedWriter w = new BufferedWriter(new OutputStreamWriter(p.getOutputStream()));
                w.write(command.input);
                w.close();
            }
            String line;
            BufferedReader r = new BufferedReader(new InputStreamReader(p.getInputStream()));
            while ((line = r.readLine()) != null)
                output.append(line).append('\n');
            p.waitFor();
            if (p.exitValue() == 0)
                return output.toString();
        } catch (Exception ex) {
            Visuals.error("Exception while executing " + command.command + ": " + ex.toString());
        }
        return output.toString();
    }
}
