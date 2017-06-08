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
import java.util.StringTokenizer;

/**
 *
 * @author teras
 */
public class XEKill extends XNativeElement {

    private static final XNativeCommand PS_CMD;
    private static final int PS_COLUMN;

    static {
        if (OperatingSystem.isWindows) {
            ArrayList<String> args = new ArrayList<String>();
            args.add("/FO");
            args.add("CSV");
            PS_CMD = new XNativeCommand("tasklist.exe", args, null);
            PS_COLUMN = 3;
        } else {
            ArrayList<String> args = new ArrayList<String>();
            args.add("aux");
            PS_CMD = new XNativeCommand("ps", args, null);
            PS_COLUMN = 2;
        }

    }
    private final String signal;

    public XEKill(String target, String signal) {
        super(target, null);
        this.signal = signal;
    }

    @Override
    public void perform() {
        Visuals.info("Killing process with pattern " + target);
        ArrayList<String> proclist = new ArrayList<String>();
        StringTokenizer tok = new StringTokenizer(exec(PS_CMD), "\n\r");
        while (tok.hasMoreTokens()) {
            String line = tok.nextToken();
            if (line.indexOf(target) >= 0 && line.indexOf(JupidatorDeployer.class.getName()) < 0) {
                Visuals.info("Killing " + line);
                StringTokenizer col = new StringTokenizer(line, OperatingSystem.isWindows ? "\"" : " ");
                for (int i = 0; i < PS_COLUMN - 1; i++)
                    col.nextToken();
                String next_pid = col.nextToken();
                if (next_pid.startsWith("\""))
                    next_pid = next_pid.substring(1, next_pid.length() - 1);
                proclist.add(next_pid);
            }
        }
        for (String id : proclist)
            exec(getKillCmd(id));
    }

    private XNativeCommand getKillCmd(String proc) {
        XNativeCommand kill;
        if (OperatingSystem.isWindows) {
            ArrayList<String> args = new ArrayList<String>();
            args.add("/PID");
            args.add(proc);
            args.add(target);
            if (!signal.equals(""))
                args.add(signal);
            kill = new XNativeCommand("taskkill.exe", args, null);
        } else {
            ArrayList<String> args = new ArrayList<String>();
            if (!signal.equals(""))
                args.add("-" + signal);
            args.add(proc);
            kill = new XNativeCommand("kill", args, null);
        }
        return kill;
    }
}
