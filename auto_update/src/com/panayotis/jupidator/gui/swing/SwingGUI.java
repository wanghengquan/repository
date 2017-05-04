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

package com.panayotis.jupidator.gui.swing;

import com.panayotis.jupidator.ApplicationInfo;
import com.panayotis.jupidator.Updater;
import com.panayotis.jupidator.UpdaterException;
import com.panayotis.jupidator.data.TextUtils;
import com.panayotis.jupidator.data.UpdaterAppElements;
import com.panayotis.jupidator.elements.security.PermissionManager;
import com.panayotis.jupidator.gui.JupidatorGUI;
import com.panayotis.jupidator.loglist.creators.HTMLCreator;
import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.net.URL;
import javax.imageio.ImageIO;
import javax.swing.UIManager;

import static com.panayotis.jupidator.i18n.I18N._;

/**
 *
 * @author teras
 */
public class SwingGUI implements JupidatorGUI {

    private SwingDialog gui;
    private Updater callback;
    private String newver, versinfo, title, infopane;
    private BufferedImage icon;
    private boolean skipvisible, prevvisible, detailedvisible = false, infovisible = true, systemlook = true;

    public boolean isHeadless() {
        return false;
    }

    public void setInformation(Updater callback, UpdaterAppElements el, ApplicationInfo info) throws UpdaterException {
        this.callback = callback;
        newver = _("A new version of {0} is available!", el.getAppName());
        versinfo = _("{0} version {1} is now available", el.getAppName(), el.getNewestVersion())
                + (info.getVersion() == null ? "" : " - " + _("you have {0}", info.getVersion())) + ".";
        title = _("New version of {0} found!", el.getAppName());
        infopane = HTMLCreator.getList(el.getLogList(), true);
        try {
            String iconpath = el.getIconpath();
            if (iconpath != null && (!iconpath.equals("")))
                icon = ImageIO.read(new URL(iconpath));
        } catch (IOException ex) {
        }
        skipvisible = !info.isSelfUpdate();
        prevvisible = PermissionManager.manager.isRequiredPrivileges();
    }

    public void setProperty(String key, String value) {
        key = key.toLowerCase();
        if (key.equals(ABOUT))
            infovisible = TextUtils.isTrue(value);
        else if (key.equals(SYSTEMLOOK))
            systemlook = TextUtils.isTrue(value);
        else if (key.equals(LOGLIST))
            detailedvisible = TextUtils.isTrue(value);
    }

    public void startDialog() {
        if (gui != null)
            return;

        try {
            if (systemlook)
                UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception ex) {
        }
        gui = new SwingDialog();
        gui.callback = callback;
        gui.NewVerL.setText(newver);
        gui.VersInfoL.setText(versinfo);
        gui.setTitle(title);
        gui.InfoPane.setContentType("text/html");
        gui.InfoPane.setText(infopane);
        gui.icon = icon;
        gui.SkipB.setVisible(skipvisible);
        gui.PrevL.setVisible(prevvisible);
        gui.InfoB.setVisible(infovisible);
        gui.DetailedP.setVisible(detailedvisible);
        gui.pack();
        gui.setLocationRelativeTo(null);
        gui.setVisible(true);
    }

    public void endDialog() {
        gui.setVisible(false);
        gui.dispose();
    }

    public void setIndetermined() {
        gui.ActionB.setEnabled(false);
        gui.PBar.setIndeterminate(true);
        gui.PBar.setToolTipText(_("Processing update"));
        gui.PBar.setString("");
        gui.InfoL.setText(_("Deploying files..."));
    }

    public void errorOnCommit(String message) {
        setInfoArea(message);
        gui.InfoL.setForeground(Color.RED);
        gui.ProgressP.revalidate();
    }

    public void successOnCommit(boolean restartableApp) {
        setInfoArea(_("Successfully downloaded updates"));
        gui.ActionB.setText(restartableApp ? _("Restart application") : _("Finalize update"));
        gui.ActionB.setActionCommand("restart");
        gui.ProgressP.revalidate();
    }

    public void errorOnRestart(String message) {
        if (message == null)
            setInfoArea(_("Application cancelled restart"));
        else
            setInfoArea(message);
        gui.ActionB.setText(_("Cancel"));
        gui.ActionB.setActionCommand("cancel");
    }

    public void setDownloadRatio(String ratio, float percent) {
        gui.PBar.setValue(Math.round(percent * 100));
        gui.PBar.setToolTipText(_("Download speed: {0}", ratio));
        gui.PBar.setString(ratio);
    }

    private void setInfoArea(String message) {
        gui.ActionB.setEnabled(true);
        gui.BarPanel.remove(gui.PBar);
        gui.ProgressP.remove(gui.InfoL);
        gui.BarPanel.add(gui.InfoL);
        gui.InfoL.setText(message);
    }
}
