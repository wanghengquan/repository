import os
import re
import sys
import time
import platform

#D:\project\lrf_prj\client_prj

ON_WIN = sys.platform.startswith("win")
work_dir = os.getcwd()
script_dir = os.path.split(os.path.realpath(__file__))[0]
psutil_dir = os.path.join(script_dir,'psutil')

kill_path = sys.argv[1]

def addsyspath(new_path):
    if not os.path.exists(new_path):
        return -1
    new_path = os.path.abspath(new_path)
    if sys.platform == 'win32':
        new_path = new_path.lower()
    for ori_path in sys.path:
        ori_path = os.path.abspath(ori_path)
        if sys.platform == 'win32':
            ori_path = ori_path.lower()
        if new_path in (ori_path, ori_path + os.sep):
            return 0
    sys.path.append(new_path)
    return 1

if ON_WIN:
    #addsyspath(psutil_dir)
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
    except ImportError:
        import getpass
        return getpass.getuser()

class HandleExceptionProcess:
    def __init__(self, debug=True):
        self.debug = debug

    def handle_process(self, kill_work_path):
        self.process_dict = self.create_process_dict()
        if self.debug:
            print ('')
            print ('/*' * 20)
            print ("DEBUG: Monitoring Processes: ")
            for key, value in self.process_dict.items():
                print (key, "==>", value)
            print ('/*' * 20)
            print ('')
        self.process_on_dict(kill_work_path)

    def create_process_dict(self):
        if ON_WIN:
            return self.create_win_process_dict()
        else:
            return self.create_lin_process_dict()

    def create_win_process_dict(self):
        process_dict = dict()
        pid_list = psutil.pids()
        for pid in pid_list:
            try:
                p = psutil.Process(pid)
                _cwd = p.cwd()
                _cmdline = p.cmdline()
            except Exception:
                continue
            _cmdline = " ".join(_cmdline)
            key = "%s" % pid
            process_dict[key] = [p, _cwd, _cmdline]
        return process_dict

    def create_lin_process_dict(self):
        process_dict = dict()
        user_name = get_current_user()
        ps_cmd = 'ps -eo user,pid,command | grep "%s "' % user_name
        sts, text = get_status_output(ps_cmd)
        if sts:
            print ("ERROR: Failed to run %s" % ps_cmd)
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
            key = "%s" % _pid
            process_dict[key] = [_pid, _cwd, _cmdline]
        return process_dict

    def process_on_dict(self, kill_work_path):
        for key, value in self.process_dict.items():
            process_work_path = value[1]
            if not (self.match_kill_path(kill_work_path,process_work_path)):
                continue
            # stop the process and remove it from the process_dict
            if ON_WIN:
                process_name = value[0]
                try:
                    process_name.terminate()
                    self.pop_and_record(key)
                except Exception:
                    pass
            else:
                kill_cmd = "kill -9 %s" % value[0]
                sts, text = get_status_output(kill_cmd)
                if sts:
                    if re.search("No\s+such", text[0]):
                        self.pop_and_record(key) # can pop it
                    else:
                        pass # can't kill the pid and do NOT pop it
                else:
                    self.pop_and_record(key)

    def pop_and_record(self, key):
        print ("Kill %s successfully" % key)
        self.process_dict.pop(key)
        
    def match_kill_path(self, kill_work_path, process_work_path):
        if ON_WIN:
            kill_work_path = kill_work_path.lower()
            process_work_path = process_work_path.lower()
            kill_work_path = kill_work_path.replace('\\', '/')
            process_work_path = process_work_path.replace('\\', '/')            
        if kill_work_path in process_work_path:
            return 1
        else:
            return 0 

if __name__ == "__main__":
    my_tst = HandleExceptionProcess(debug=False)
    my_tst.handle_process(kill_path)
    print ("Scan_finished")