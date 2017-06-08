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
import jupidator.launcher.XEChstatus;
import jupidator.launcher.XElement;

import static com.panayotis.jupidator.i18n.I18N._;

/**
 *
 * @author teras
 */
public abstract class ElementChstatus extends ElementNative {

    private final String attr;
    private final boolean recursive;

    public ElementChstatus(String command, String file, String attr, String recursive, UpdaterAppElements elements, ApplicationInfo info) {
        super(command, file, null, ExecutionTime.AFTER, elements, info);
        this.attr = attr == null ? "" : attr;
        this.recursive = TextUtils.isTrue(recursive);
    }

    @Override
    public String prepare(UpdatedApplication application) {
        return attr.equals("") ? _("Unable to provide empty attribute for file {0}", getFileName()) : null;
    }

    @Override
    public XElement getExecElement() {
        return new XEChstatus(command, getDestinationFile(), attr, recursive);
    }
}
