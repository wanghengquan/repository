import os
import re
import sys
import time
import random
import shutil
import optparse
import _thread
import platform
import glob

def get_file_lines(*args, **kwargs):
    a_file = args[0]
    lines = list()
    if os.path.isfile(a_file):
        for line in open(a_file):
            line = line.strip()
            if not line: continue
            if re.search("^rem", line): continue
            if re.search("^#", line): continue
            line = re.split("@", line)
            lines.append(line[-1])
    return lines, set(lines)

def my_append(*args, **kwargs):
    """
    append a file or create a new file if append=False
    """
    a_file, lines = args[0], args[1]
    append = True
    a_file = os.path.abspath(a_file)
    try_times = 0
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
            a_ob.flush()
            a_ob.close()
            break
        except IOError:
            try_times += 1
            if try_times > 10:
                print(("-- Warning: can not open %s" % a_file))
                return 1
            time.sleep(5)
            print(("-- Note: try to open %s %d times." % (a_file, try_times)))

LK_UNLCK = 0 # unlock the file region
LK_LOCK  = 1 # lock the file region
LK_NBLCK = 2 # non-blocking lock
LK_RLCK  = 3 # lock for writing
LK_NBRLCK= 4 # non-blocking lock for writing

def run_safety(func, *args, **kwargs):
    sts = ""
    platform_in_short = sys.platform[:3]
    lock_ob = open("just_only_4_lock", "a")
    if platform_in_short == "win":
        import msvcrt
        while 1:
            try:
                msvcrt.locking(lock_ob.fileno(), LK_LOCK, 10)
                break
            except IOError:
                time.sleep(0.1)
        sts = func(*args, **kwargs)
        time.sleep(0.5)
        msvcrt.locking(lock_ob.fileno(), LK_UNLCK, 10)
    else:
        import fcntl
        while 1:
            fcntl.flock(lock_ob, fcntl.LOCK_EX)
            sts = func(*args, **kwargs)
            fcntl.flock(lock_ob,fcntl.LOCK_UN)
    return sts

p_start = re.compile("Dump PAP Details")
p_stop = re.compile("Lattice TRACE Report")
p_fmax = re.compile("""^PAP=
                       [^\|]+\|
                       [^\|]+\|
                       \s+([\.\d]+)\s+MHz""", re.X)
def get_best_fmax(twr_file):
    start = 0
    fmax_list = list()
    for line in open(twr_file):
        if not start:
            start = p_start.search(line)
            continue
        if start:
            if p_stop.search(line):
                break
            m_fmax = p_fmax.search(line)
            if m_fmax:
                fmax_list.append(float(m_fmax.group(1)))
    if fmax_list:
        return min(fmax_list)
    else:
        return -1

def get_best_point(job_dir, design):
    design_dir = os.path.join(job_dir, design)
    if not os.path.isdir(design_dir):
        return 1, "Not found %s" % design_dir
    tag_dirs = glob.glob(os.path.join(design_dir, "_scratc*"))
    if not tag_dirs:
        return 1, "Not found any _scratch path in %s" % design_dir
    twr_files = list()
    for tag in tag_dirs:
        _twr_files = glob.glob(os.path.join(tag, "Target_fmax*", "*", "*.twr"))
        if _twr_files:
            twr_files += _twr_files[:]
    if not twr_files:
        log_file = os.path.join(tag_dirs[0], "runtime_console.log")
        return 1, log_file
    else:
        twr_fmax = [get_best_fmax(item) for item in twr_files]
        best_fmax = max(twr_fmax)
        for i, f in enumerate(twr_fmax):
            if f == best_fmax:
                return 0, twr_files[i]

def win2unix(a_path, use_abs=1):
    """
    transfer a path to unix format
    """
    if use_abs:
        a_path = os.path.abspath(a_path)
    return re.sub(r"\\", "/", a_path)

def wrap_md(a_path, comments):
    """
    return 1 if failed to make a new folder if it doesn't exist
    """
    if not a_path:
        print(("-- Error. No value specified for %s" % comments))
        return 1
    if not os.path.isdir(a_path):
        try:
            os.makedirs(a_path)
        except Exception as e:
            print(("-- Error. can not makedir %s <%s>" % (a_path, comments)))
            print(e)
            print("")
            return 1

def get_cmd_line(batch_files, host_name):
    for a_file in batch_files:
        if not os.path.isfile(a_file):
            continue
        a_done_file = a_file + ".done"
        batch_list, batch_set = get_file_lines(a_file)
        done_list, done_set = get_file_lines(a_done_file)
        if done_set >= batch_set:
            shutil.move(a_file, "%s.fine" % a_file)
            continue
        cmd_line = ""
        for line in batch_list:
            if line in done_list:
                continue
            cmd_line = line
            break
        done_line = "<%s>%s@%s" % (host_name, time.ctime(), cmd_line)
        my_append(a_done_file, done_line)
        return cmd_line
    return ""

class RunLines:
    def __init__(self):
        self.on_win = re.search("win", sys.platform)
        self.p_run_synp = re.compile("\s+--run-")
        self.elapsed_time_csv = "Elapsed_time.csv"
        self.host_name = platform.uname()[1]

    def run_process(self):
        self.parse_options()
        if self.process:
            self.run_with_processes()
        else:
            self.run_single_process()

    def parse_options(self):
        parser = optparse.OptionParser()
        parser.add_option("--run321", action="store_true", help="run in inverted sequence")
        parser.add_option("--run-synp", action="store_true", help="run synthesis only")
        parser.add_option("--run-mpar", action="store_true", help="run mpar only")
        parser.add_option("-p", "--process", type="int", metavar="<process number>")
        parser.add_option("--do-file", metavar="<do_file>", help="specify the batch file")
        parser.add_option("--do-fext", metavar="<do_fext>", default=".lines", help="specify the file's extension")
        parser.add_option("--net-result", help="specify result network dir")
        parser.add_option("--build", help="specify build name")
        opts, args = parser.parse_args()

        self.run321 = opts.run321
        self.run_synp = opts.run_synp
        self.run_mpar = opts.run_mpar
        self.process = opts.process
        self.do_file = opts.do_file
        self.do_fext = opts.do_fext.lower()
        self.net_result = opts.net_result
        self.build = opts.build

    def run_with_processes(self):
        if self.do_file or (self.do_fext !='.lines'):
            print(" ** not support --do-file or --do-fext options when running with mult-processes")
            return
        one_by_one_cmd = "s_i_n_g_l_e_r_u_n.cmd"
        if self.run321:
            one_by_one_cmd = "321_" + one_by_one_cmd
        if not os.path.isfile(one_by_one_cmd):
            ob_one = open(one_by_one_cmd, "w")
            t_line = "%s %s " % (sys.executable, sys.argv[0])
            if self.net_result:
                t_line += r" --net-result=%s" % self.net_result
            if self.build:
                t_line  += " --build=%s" % self.build
            if self.run321:
                t_line += " --run321"
            print(t_line, file=ob_one)
            print("exit", file=ob_one)
            ob_one.close()
        else:
            time.sleep(5)

        if self.process > 6:
            self.process = 6
        for i in range(self.process):
            if self.on_win:
                os.system("start %s" % one_by_one_cmd)
            else:
                _thread.start_new_thread(os.system, ("xterm -e sh %s" % one_by_one_cmd,))
            time.sleep(5)

    def get_files(self):
        self.files = list()
        if self.do_file:
            self.files.append(self.do_file)
        else:
            for foo in os.listdir("."):
                file_name, file_ext = os.path.splitext(foo.lower())
                if file_ext == self.do_fext:
                    self.files.append(foo)

    def copy_error_one_point(self, line):
        p_job_dir = re.compile("\s+--job-dir=(\S+)")
        p_design = re.compile("\s+--design=(\S+)")
        net_build_result = os.path.join(self.net_result, self.build)
        if wrap_md(net_build_result, "net_bak_path"):
            return 1
        m_job_dir = p_job_dir.search(line)
        m_design = p_design.search(line)
        job_dir = m_job_dir.group(1)
        design = m_design.group(1)
        sts, twr_file = get_best_point(job_dir, design)
        if not sts:
            twr_file = win2unix(twr_file, 0)
            p_src_dir = re.compile("^(.+/%s/(_scratc[^/]+/Target_fmax[^/]+)/)" % design)
            m_src_dir = p_src_dir.search(twr_file)
            src_dir = m_src_dir.group(1)
            dst_dir = os.path.join(net_build_result, os.path.basename(job_dir), design, m_src_dir.group(2))
            dst_dir = win2unix(dst_dir, 0)
            if os.path.isdir(dst_dir):
                shutil.rmtree(dst_dir)
            shutil.copytree(src_dir, dst_dir)
        else: # failed
            new_log = os.path.join(net_build_result, "Failed.log")
            new_lines = list()
            new_lines.append("Design: %s" % design)
            new_lines.append("HOST: %s" % self.host_name)
            new_lines.append(r"Job-Dir: %s" % job_dir)
            if os.path.isfile(twr_file):
                for line in open(twr_file):
                    new_lines.append(line.rstrip())
            else:
                new_lines.append(twr_file)
            run_safety(my_append, new_log, new_lines)

    def run_single_process(self):
        while True:
            if os.path.isdir("stop"):
                break
            self.get_files()
            if not self.files:
                break
            self.files.sort()
            if self.run321:
                self.files.reverse()
            cmd_line = run_safety(get_cmd_line, self.files, self.host_name)
            if cmd_line:
                start_time = time.time()
                print((" ** Running <%s>" % cmd_line))
                os.system(cmd_line)
                print("")
                time_lens = time.time() - start_time
                csv_line = '%8.2f,"%s",' % (time_lens, cmd_line)
                run_safety(my_append, self.elapsed_time_csv, csv_line)
                self.copy_error_one_point(cmd_line)
                time.sleep(random.randint(300,1000)/100.0)
            else:
                print("All test flow done.")
                break

if __name__ == "__main__":
    my_run = RunLines()
    my_run.run_process()