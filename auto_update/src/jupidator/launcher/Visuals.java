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

/*
 * Visuals.java
 *
 * Created on 27 Ιαν 2011, 4:30:15 μμ
 */
package jupidator.launcher;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JProgressBar;
import javax.swing.UIManager;

/**
 *
 * @author teras
 */
public class Visuals extends javax.swing.JFrame {

    private static final int DWIDTH = 400;
    private static final int DHEIGHT = 300;
    //
    private static StringBuilder info = new StringBuilder();
    private static boolean headless = false;
    private static boolean foundErrors = false;
    private static JFrame frame;
    static File logfile;

    public static void info(String message) {
        if (frame == null)
            showWorking();
        info.append(message).append("\n");
    }

    public static void error(String message) {
        foundErrors = true;
        info("  *ERROR* " + message);
    }

    public static boolean finish() {
        storeLog();
        if (frame == null || (!foundErrors))
            return true;
        frame.setVisible(false);
        frame.dispose();
        frame = new Visuals(info.toString());
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
        return false;
    }

    public static void setHeadless(boolean headless) {
        Visuals.headless = headless;
    }

    private static void showWorking() {
        if (headless)
            return;

        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception ex) {
        }

        frame = new JFrame();
        JPanel jPanel1 = new javax.swing.JPanel();
        JLabel TextL = new javax.swing.JLabel();
        JProgressBar ProgressBar = new javax.swing.JProgressBar();

        jPanel1.setBorder(javax.swing.BorderFactory.createCompoundBorder(javax.swing.BorderFactory.createBevelBorder(javax.swing.border.BevelBorder.RAISED), javax.swing.BorderFactory.createEmptyBorder(8, 12, 8, 12)));
        jPanel1.setLayout(new java.awt.BorderLayout(12, 0));

        TextL.setText("Please wait while deploying files");
        jPanel1.add(TextL, java.awt.BorderLayout.WEST);

        ProgressBar.setIndeterminate(true);
        ProgressBar.putClientProperty("JProgressBar.style", "circular");
        ProgressBar.setPreferredSize(new java.awt.Dimension(20, 20));
        jPanel1.add(ProgressBar, java.awt.BorderLayout.CENTER);

        frame.setUndecorated(true);
        frame.getContentPane().add(jPanel1, java.awt.BorderLayout.CENTER);
        frame.pack();
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }

    /* 
     *  private code to store output to a file
     */
    private static void storeLog() {
        String home = System.getProperty("user.home") + File.separator;
        File logdir;
        if (OperatingSystem.isWindows)
            logdir = new File(System.getenv("APPDATA") + "\\jupidator");
        else if (OperatingSystem.isMac)
            logdir = new File(home + "Library/Logs/jupidator");
        else
            logdir = new File(home + ".local/share/jupidator");
        logdir.mkdirs();

        logfile = new File(logdir, new SimpleDateFormat("'jupidator-'yyyyMMdd.kkmmss.SSSS'.log'").format(new Date()));
        if (!logfile.getParentFile().isDirectory())
            return;
        FileWriter fout = null;
        try {
            fout = new FileWriter(logfile);
            fout.write(info.toString());
        } catch (IOException ex) {
        } finally {
            if (fout != null)
                try {
                    fout.close();
                } catch (IOException ex) {
                }
        }
    }

    /* 
     * Following code requires a non-headless display 
     */
    public Visuals(String error) {
        initComponents();
        ErrorP.setVisible(false);
        TextP.setText(error);
        pack();
        setSize(DWIDTH, getHeight());
    }

    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        ShowB = new javax.swing.JButton();
        AckB = new javax.swing.JButton();
        jLabel1 = new javax.swing.JLabel();
        ErrorP = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        TextP = new javax.swing.JTextArea();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setTitle("Jupidator Deployer");

        jPanel1.setLayout(new java.awt.BorderLayout());

        ShowB.setText("Show results");
        ShowB.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                ShowBActionPerformed(evt);
            }
        });
        jPanel1.add(ShowB, java.awt.BorderLayout.WEST);

        AckB.setText("Acknowledge");
        AckB.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                AckBActionPerformed(evt);
            }
        });
        jPanel1.add(AckB, java.awt.BorderLayout.EAST);

        getContentPane().add(jPanel1, java.awt.BorderLayout.SOUTH);

        jLabel1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/jupidator/launcher/error.png"))); // NOI18N
        jLabel1.setText("Errors while updating");
        jLabel1.setBorder(javax.swing.BorderFactory.createEmptyBorder(8, 16, 8, 16));
        getContentPane().add(jLabel1, java.awt.BorderLayout.NORTH);

        ErrorP.setBorder(javax.swing.BorderFactory.createEmptyBorder(4, 16, 4, 16));
        ErrorP.setLayout(new java.awt.BorderLayout());

        TextP.setColumns(20);
        TextP.setEditable(false);
        TextP.setRows(5);
        TextP.setWrapStyleWord(true);
        jScrollPane1.setViewportView(TextP);

        ErrorP.add(jScrollPane1, java.awt.BorderLayout.CENTER);

        getContentPane().add(ErrorP, java.awt.BorderLayout.CENTER);

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void ShowBActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ShowBActionPerformed
        ErrorP.setVisible(true);
        ShowB.setVisible(false);
        setSize(DWIDTH, DHEIGHT);
    }//GEN-LAST:event_ShowBActionPerformed

    private void AckBActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_AckBActionPerformed
        JupidatorDeployer.finishWithStatus(-1);
    }//GEN-LAST:event_AckBActionPerformed
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton AckB;
    private javax.swing.JPanel ErrorP;
    private javax.swing.JButton ShowB;
    private javax.swing.JTextArea TextP;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JScrollPane jScrollPane1;
    // End of variables declaration//GEN-END:variables
}
