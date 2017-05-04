/*
 * JupidatorDeployer.java
 *
 * Created on September 29, 2008, 5:10 PM
 */

package jupidator.launcher;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.util.List;

/**
 *
 * @author teras
 */
public class JupidatorDeployer {

    private static DeployerParameters params;
    private static String workdir;

    /**
     * arg[0] = location of working directory, where streamed DeployerParameters
     * file exists
     *
     * @param args
     */
    public static void main(String[] args) {
        workdir = args[0];
        ObjectInputStream in = null;
        try {
            /* Recreate parameters */
            in = new ObjectInputStream(new FileInputStream(new File(workdir, "parameters")));
            params = (DeployerParameters) in.readObject();
            in.close();
            in = null;

            Visuals.setHeadless(params.isHeadless());
            Visuals.info("Start of Jupidator Deployer for location " + params.applocation);

            /* Run after visuals have been initialized */
            Thread worker = new Thread() {
                @Override
                public void run() {
                    try {
                        /* Execute installer commands */
                        for (XElement element : params.getElements())
                            element.perform();

                        /* Check if the installer should finish or not */
                        if (Visuals.finish()) {
                            /* Relaunch application if applicable */
                            List<String> command = params.getRelaunchCommand();
                            if (command.size() >= 1) {
                                ProcessBuilder procb = new ProcessBuilder(command);
                                procb.environment().put("JUPIDATOR_ERROR_FILE", Visuals.logfile == null ? "" : Visuals.logfile.getAbsolutePath());
                                procb.start();
                            } else
                                Visuals.info("No valid relaunch command found!");

                            /* Exit installer */
                            finishWithStatus(0);
                        }
                    } catch (Exception ex) {
                        errorWasFound(ex);
                    }
                }
            };
            worker.start();
        } catch (Exception ex) {
            if (in != null)
                try {
                    in.close();
                } catch (IOException ex1) {
                }
            errorWasFound(ex);
        }
    }

    private static void errorWasFound(Exception ex) {
        StringBuilder buf = new StringBuilder("Exception found: ");
        buf.append(ex.toString()).append("\n");
        for (StackTraceElement stack : ex.getStackTrace())
            buf.append("       at ").append(stack.toString()).append("\n");
        Visuals.error(buf.toString());
        Visuals.finish();
    }

    static void finishWithStatus(int status) {
        XFileModElement.safeDelete(new File(workdir));
        System.exit(status);
    }
}
