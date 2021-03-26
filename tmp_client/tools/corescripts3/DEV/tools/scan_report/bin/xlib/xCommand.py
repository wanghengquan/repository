import os
import re
import time
from .xLog import wrap_quiet, print_error
import threading

class RunCommand:
    def __init__(self, cmd, log_file, dry_run):
        self.cmd = cmd
        self.log_file = log_file
        self.dry_run = dry_run
        ##-----------
        timeout = os.getenv("CMDTIMEOUT", "NoTimeOutNumber")
        try:
            self.timeout = abs(int(timeout))
        except ValueError:
            print_error("unknown timeout value: %s" % timeout)
            self.timeout = 0
        
    def run_cmd(self):
        """ Run OS command with exit code.
        """
        q_line = "%s [%s]" % (self.cmd, time.strftime('%X-%m-%d-%Y'))
        wrap_quiet(q_line)
        cur_log_file = self.get_cur_log_file(q_line)
        if cur_log_file:
            new_cmd = "%s >> %s 2>&1" % (self.cmd, cur_log_file)
        else:
            new_cmd = self.cmd
        start_time = time.time()
        if self.dry_run:
            status = 0
        else:
            status = self.run_my_cmd(new_cmd)
        time_lens = "%.2f" % (time.time() - start_time)
        self.record_run_time(time_lens)
        wrap_quiet("Elapsed Time: %s seconds" % time_lens)
        if status:
            print_error("Failed when running: %s in <%s>" % (self.cmd, os.getcwd()))
        wrap_quiet("")
        return status
        
    def _run_it(self, my_cmd):
        self.cmd_status = 1
        status = os.system(my_cmd)
        self.cmd_status = status
    p_daemon_status = re.compile("started daemon")
    def run_my_cmd(self, my_cmd):
        cmd_thread = threading.Thread(target=self._run_it, args=[my_cmd])
        cmd_thread.setDaemon(True)
        cmd_thread.start()
        if not self.timeout:
            cmd_thread.join()
        else:
            cmd_thread.join(timeout=self.timeout)
            
        exit_by_force = self.p_daemon_status.search(str(cmd_thread))
        if exit_by_force:
            print_error("!TIMEOUT! Exit for running %s" % self.cmd, add_ERROR=False)
            return 1
        return self.cmd_status
        

    def get_cur_log_file(self, cmd_line):
        """ if log_file's size is too big( > 100 MB ), will change file name with "ctd_"
                and check whether the last command was done or not. if not, will wait for
                10 seconds and try again.
        """
        log_file = self.log_file
        if log_file:
            if os.path.isfile(log_file):
                if os.path.getsize(log_file) > 100000000:
                    dir_name, base_name = os.path.split(log_file)
                    log_file = os.path.join(dir_name, "ctd_" + base_name)
            while True:
                try:
                    log = open(log_file, "a")
                    log.close()
                    break
                except IOError:
                    time.sleep(10)
            log = open(log_file, "a")
            print("", file=log)
            print("-*- " * 10, file=log)
            print(cmd_line, file=log)
            log.close()
        return log_file

    def record_run_time(self, time_lens):
        """ Record command run time.
        """
        if self.log_file:
            time_file = re.sub("\.log$", ".time", self.log_file)
        else:
            time_file = "Flow.time"
        time_ob = open(time_file, "a")
        print("%-15s , %s" % (time_lens, self.cmd), file=time_ob)
        time_ob.close()

def run_cmd(cmd, log_file, dry_run, on_win=False):
    if on_win:
        cmd = re.sub("/", r"\\", cmd)
    my_run = RunCommand(cmd, log_file, dry_run)
    return my_run.run_cmd()

def run_raw_cmd(bin_exe, raw_cmd, cmd_dict, log_file, dry_run, on_win=False):
    raw_cmd = raw_cmd.split()  # remove \n
    raw_cmd = " ".join(raw_cmd)
    raw_cmd = re.sub("@", "%", raw_cmd)
    cmd = raw_cmd % cmd_dict
    cmd = os.path.join(bin_exe, cmd)
    return run_cmd(cmd, log_file, dry_run, on_win)