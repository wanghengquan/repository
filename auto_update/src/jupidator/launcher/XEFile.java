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

import java.io.File;

/**
 *
 * @author teras
 */
public class XEFile extends XFileModElement {

    private final String source;

    public XEFile(String source, String target) {
        super(target);
        this.source = source;
    }

    public void perform() {
        File input = new File(source);
        File output = new File(target);
        if (input.isDirectory()) {
            Visuals.info("Installing package " + target);
            for (File entry : input.listFiles())
                if (!safeMv(entry, output))
                    Visuals.error("Unable to install " + entry.getPath() + " to " + target);
            input.delete();
        } else {
            Visuals.info("Installing file " + target);
            if (!safeMv(input, output))
                Visuals.error("Unable to install " + source + " to " + target);
        }
    }
}
