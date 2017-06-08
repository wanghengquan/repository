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

package com.panayotis.jupidator.data;

import com.panayotis.jupidator.ApplicationInfo;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author teras
 */
public class Arch implements Serializable {

    private final String tag;
    private String exec;
    private List<String> arguments;

    /* Default arch "any" */
    public static Arch defaultArch() {
        return new Arch("any");
    }

    public static Arch getArch(String tag, String os, String arch) {
        tag = tag.toLowerCase();
        os = os.toLowerCase();
        arch = arch.toLowerCase();
        if (TextUtils.getSystemName().startsWith(os) && TextUtils.getSystemArch().startsWith(arch))
            return new Arch(tag);
        else
            return null;
    }

    private Arch(String tag) {
        this.tag = tag;
        arguments = new ArrayList<String>();
    }

    boolean isCompatibleWith(String tag) {
        if (tag == null)
            tag = "any";
        tag = tag.toLowerCase().trim();
        return tag.equals(this.tag) || tag.equals("any") || tag.equals("all");
    }

    void setExec(String exec, ApplicationInfo appinfo) {
        this.exec = exec != null && exec.isEmpty() ? null : appinfo.applyVariables(exec);
    }

    void addArgument(String argument, ApplicationInfo appinfo) {
        if (appinfo != null && argument != null)
            arguments.add(appinfo.applyVariables(argument));
    }

    public List<String> getRelaunchCommand(ApplicationInfo appinfo) {
        List<String> comm = new ArrayList<String>();
        if (exec != null)
            comm.add(exec);
        comm.addAll(arguments);
        return comm;
    }
}
