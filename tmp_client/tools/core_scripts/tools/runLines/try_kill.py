import os
import re
import sys
import time

ON_WIN = sys.platform.startswith("win")

if ON_WIN:
    import psutil

def get_status_output(cmd):
    """
    return (status, output) of executing cmd in a shell.
    source from commands.py <def getstatusoutput(cmd)>.
    """
    if sys.platform[:3] != "win":
        cmd = "{ " + cmd + "; }"
    pipe = os.popen(cmd + " 2>&1", "r")
    text = list()
    for item in pipe:
        text.append(item.rstrip())
    try:
        sts = pipe.close()
    except IOError:
        sts = 1
    if sts is None: sts = 0
    return sts, text

def get_lin_cwd(pid):
    p = re.compile("cwd\s+->\s+(.+)")
    ls_cwd = "ls -l /proc/%s/cwd" % pid
    sts, text = get_status_output(ls_cwd)
    if sts:
        return
    for item in text:
        m = p.search(item)
        if m:
            return m.group(1)

def get_current_user():
    try:
        import pwd
        # pwd is unix only
        return pwd.getpwuid(os.getuid())[0]
    except ImportError, e:
        import getpass
        return getpass.getuser()


class HandleExceptionProcess:
    def __init__(self, wait_times=24, wait_step=1800, debug=True):
        self.wait_times = wait_times
        self.wait_step = wait_step
        self.debug = debug

    def handle_process(self):
        self.process_dict = dict()
        while True:
            if self.find_stop_tags():
                break
            self.create_process_dict()
            if self.debug:
                print
                print '/*' * 20
                print "DEBUG: Monitoring Processes: "
                for key, value in self.process_dict.items():
                    print key, value
                print '/*' * 20
                print
            self.process_on_dict()
            time.sleep(self.wait_step)

    def find_stop_tags(self):
        """
        will stop the scripts in wait_step seconds.
        """
        # TODO: leave it empty or make a stop folder in the execute directory.
        return

    def create_process_dict(self):
        if ON_WIN:
            cur = self.create_win_process_dict()
        else:
            cur = self.create_lin_process_dict()

        tmp_dict = dict()
        for key, value in cur.items():
            ori_value = self.process_dict.get(key)
            if ori_value:
                tmp_dict[key] = [ori_value[0]+1, ori_value[1]]
            else:
                tmp_dict[key] = value
        self.process_dict = tmp_dict


    def create_win_process_dict(self):
        process_dict = dict()
        pid_list = psutil.get_pid_list()
        for pid in pid_list:
            try:
                p = psutil.Process(pid)
                _cwd = p.cwd()
                _cmdline = p.cmdline()
            except Exception:
                continue
            _cmdline = " ".join(_cmdline)
            if self.skip_yes(_cwd, _cmdline):
                continue
            key = "%s::%s::%s" % (pid, _cwd, _cmdline)
            process_dict[key] = [1, p]
        return process_dict

    def create_lin_process_dict(self):
        process_dict = dict()
        user_name = get_current_user()
        ps_cmd = 'ps -eo user,pid,command | grep "%s "' % user_name
        sts, text = get_status_output(ps_cmd)
        if sts:
            print "ERROR: Failed to run %s" % ps_cmd
            return process_dict
        for item in text:
            item_list = re.split("\s+", item)
            _user = item_list[0]
            if _user != user_name:  # sometimes the user_name is only the partial of the _user
                continue
            _pid = item_list[1]
            _cmdline = " ".join(item_list[2:])
            _cwd = get_lin_cwd(_pid)
            if not _cwd:
                continue # maybe the process finished
            if self.skip_yes(_cwd, _cmdline):
                continue
            key = "%s::%s::%s" % (_pid, _cwd, _cmdline)
            process_dict[key] = [1, _pid]
        return process_dict

    def skip_yes(self, _cwd, _cmdline):
        if re.search("python", _cmdline):
            return 1
        if re.search("_scratch", _cwd):
            if self.debug:
                print "DEBUG: Monitoring %s::%s" % (_cwd, _cmdline)
            return
        return 1

    def process_on_dict(self):
        for key, value in self.process_dict.items():
            elapsed_number = value[0]
            if elapsed_number < self.wait_times:
                continue
            # stop the process and remove it from the process_dict
            if ON_WIN:
                process_name = value[1]
                try:
                    process_name.terminate()
                    self.pop_and_record(key)
                except Exception:
                    pass
            else:
                kill_cmd = "kill -9 %s" % value[1]
                sts, text = get_status_output(kill_cmd)
                if sts:
                    if re.search("No\s+such", text[0]):
                        self.pop_and_record(key) # can pop it
                    else:
                        pass # can't kill the pid and do NOT pop it
                else:
                    self.pop_and_record(key)

    def pop_and_record(self, key):
        print "Kill %s successfully" % key
        self.process_dict.pop(key)



if __name__ == "__main__":
    my_tst = HandleExceptionProcess(wait_times=18, wait_step=600, debug=True)
    my_tst.handle_process()

