import os
import sys
import time
import inspect

__author__ = 'syan'

def get_this_file():
    this_file = inspect.getfile(inspect.currentframe())
    return os.path.abspath(this_file)

class ElapsedTime:
    def __init__(self):
        self.etime = 0
    def play(self):
        self.start_time = time.time()
    def stop(self):
        self.etime = time.time() - self.start_time
    def __str__(self):
        return "Elapsed Time: %3.f seconds" % self.etime

def append_file(a_file, lines, append=True):
    """
    append a file or create a new file if append=False
    """
    try_times = 1
    a_file = os.path.abspath(a_file)
    while True:
        try:
            if append:
                a_ob = open(a_file, "a")
            else:
                a_ob = open(a_file, "w")
            if type(lines) is str:
                print(lines, file=a_ob)
            else:
                for item in lines:
                    print(item, file=a_ob)
            a_ob.close()
            break
        except IOError:
            try_times += 1
            if try_times > 10:
                return "Warning: can not open %s to append/write" % a_file
            time.sleep(5)

def get_status_output(cmd):
    """
    Return (status, output) of executing cmd in a shell.
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

def run_command(cmd, log_file, time_file):
    """
    Launch the command line
    """
    etime = ElapsedTime()
    etime.play()
    sts, text = get_status_output(cmd)
    etime.stop()
    append_file(log_file, ["-" * 30, cmd, etime])
    append_file(log_file, text)
    append_file(time_file, [cmd, "rem %s" % etime])
    if sts:
        return "failed to run %s" % cmd


if __name__ == "__main__":
    sts, text = get_status_output("tasklist")
    print("status", sts)
    for item in text:
        print(item)
