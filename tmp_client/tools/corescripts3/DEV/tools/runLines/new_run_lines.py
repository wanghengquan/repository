import os
import re
import sys
import time
import optparse
import platform

__author__ = 'syan'

LK_UNLCK = 0 # unlock the file region
LK_LOCK  = 1 # lock the file region
LK_NBLCK = 2 # non-blocking lock
LK_RLCK  = 3 # lock for writing
LK_NBRLCK= 4 # non-blocking lock for writing

def run_safety(func, *args, **kwargs):
    sts = 0
    platform_in_short = sys.platform[:3]
    lock_ob = open("just_only_4_lock", "a")
    if platform_in_short == "win":
        import msvcrt
        while 1:
            try:
                msvcrt.locking(lock_ob.fileno(), LK_LOCK, 10)
                break
            except IOError:
                time.sleep(0.5)
        sts = func(args, kwargs)
        time.sleep(1)
        msvcrt.locking(lock_ob.fileno(), LK_UNLCK, 10)
    else:
        import fcntl
        while 1:
            fcntl.flock(lock_ob, fcntl.LOCK_EX)
            sts = func(args, kwargs)
            fcntl.flock(lock_ob,fcntl.LOCK_UN)
    return sts

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
        pipe.close()
        sts = 0
    except IOError:
        sts = 1
    if sts is None: sts = 0
    return sts, text

def get_batch_files(do_file, do_fext, run321):
    if do_file:
        batch_files = do_file[:]
    else:
        batch_files = list()
        do_fext = do_fext.lower()
        for foo in os.listdir("."):
            fname, fext = os.path.splitext(foo.lower())
            if fext == do_fext:
                batch_files.append(foo)
    if run321:
        batch_files.reverse()
    return batch_files

def get_file_lines(a_file):
    lines = list()
    if os.path.isfile(a_file):
        for line in open(a_file):
            line = line.strip()
            if not line: continue
            if re.search("^rem", line): continue # original batch file
            if re.search("^#", line): continue   # original batch file
            line = re.split("@", line) # done file
            lines.append(line[-1])
    return lines, set(lines)

def get_new_command_line(batch_files):
    for item in batch_files:
        if not os.path.isfile(item):
            continue



class RunLines:
    def __init__(self):
        self.on_win = re.search("win", sys.platform)
        self.elapsed_time_csv = "Elapsed_time.csv"
        self.host_name = platform.uname()[1]

    def run_it(self):
        self.parse_options()
        if self.get_batch_files():
            return 1
        if self.process > 1:
            self.run_multi_processes()
        else:
            self.run_single_process()

    def parse_options(self):
        parser = optparse.OptionParser()
        parser.add_option("--run321", action="store_true", help="run in reversed order")
        parser.add_option("-p", "--process", default=1, type="int", help="specify processes number")
        parser.add_option("--do-file", help="specify the batch files will be launched")
        parser.add_option("--do-fext", default=".lines", help="specify the batch file extension will be launched")
        parser.add_option("--core-trunk", help="specify the core trunk path")
        opts, args = parser.parse_args()

        self.run321 = opts.run321
        self.process = opts.process
        self.do_file = opts.do_file
        self.do_fext = opts.do_fext
        self.core_trunk = opts.core_trunk
        if self.process > 7:
            self.process = 7
        if self.do_file:
            self.do_file = re.split(",", self.do_file)

    def run_multi_processes(self):
        pass

    def run_single_process(self):
        while True:
            new_cmd_line = None
            # /////////////
            if os.path.isdir("stop"):
                print("Find stop mark and exit...")
                break
            batch_files = get_batch_files(self.do_file, self.do_fext, self.run321)





            # /////////////
            if not new_cmd_line:
                print("Message: All flow done.")
                break












