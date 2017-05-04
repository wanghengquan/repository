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

package com.panayotis.jupidator.gui;

import java.util.Formatter;
import java.util.Timer;
import java.util.TimerTask;

/**
 *
 * @author teras
 */
public class UpdateWatcher extends TimerTask implements BufferListener {

    private Timer timer = new Timer(true);
    private long bytes;
    private long lastbytes;
    private long allbytes;
    private long freezedbytes;
    private JupidatorGUI callback;

    public void run() {
        long diffbytes = bytes - lastbytes;
        lastbytes = bytes;

        StringBuilder sb = new StringBuilder();
        Formatter formatter = new Formatter(sb);
        if (diffbytes < 1e3)
            formatter.format("%db/sec", diffbytes);
        else if (diffbytes < 1e6)
            formatter.format("%2.1fKb/sec", diffbytes / 1e3);
        else if (diffbytes < 1e9)
            formatter.format("%2.1fMb/sec", diffbytes / 1e6);
        else if (diffbytes < 1e12)
            formatter.format("%2.1fGb/sec", diffbytes / 1e9);
        callback.setDownloadRatio(sb.toString().trim(), ((float) lastbytes) / allbytes);
    }

    public void setCallBack(JupidatorGUI callback) {
        this.callback = callback;
    }

    public void startWatcher() {
        timer.schedule(this, 0, 1000);
    }

    public void stopWatcher() {
        timer.cancel();
    }

    public void addBytes(long bytes) {
        this.bytes += bytes;
    }

    public void setAllBytes(long bytes) {
        allbytes = bytes;
    }

    public void freezeSize() {
        freezedbytes = bytes;
    }

    public void rollbackSize() {
        bytes = freezedbytes;
    }
}
