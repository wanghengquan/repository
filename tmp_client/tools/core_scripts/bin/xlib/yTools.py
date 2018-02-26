import os
import re
import sys
import time
import shlex
import shutil
import ConfigParser

__author__ = 'syan'

def say_it(an_object, comments="", show=1):
    """
    wrapper of print
    """

    if not show:
        return
    # ---------------------
    log = ""
    bqs_l_o_g = os.getenv("BQS_L_O_G")
    if bqs_l_o_g:
        try:
            log = open(bqs_l_o_g, "a")
            if comments:
                print >> log, comments
        except Exception:
            log = ""
            pass
    # ---------------------

    if comments:
        say_it(comments)

    obj_type = type(an_object)
    if obj_type is str:
        print(an_object)
        if log: print >> log, an_object
    elif obj_type is list or obj_type is tuple:
        for item in an_object:
            print("- %s" % item)
            if log: print >> log, "- %s" % item
    elif obj_type is dict:
        keys = an_object.keys()
        try:
            keys.sort(key=str.lower)  # in case of non-string key
        except Exception:
            pass
        for key in keys:
            _val = an_object.get(key)
            print("- %-20s: %s" % (key, _val))
            if log: print >> log, "- %-20s: %s" % (key, _val)
    else:
        print(an_object)
        if log: print >> log, an_object
    if log:
        log.close()

class ChangeDir:
    """
    Change the current working directory to a new path.
    and can come back to the original current working directory
    """
    def __init__(self, new_path):
        self.cur_dir = os.getcwd()
        os.chdir(new_path)
    def comeback(self):
        os.chdir(self.cur_dir)

class ElapsedTime:
    """
    get elapsed time and timestamp
    """
    def __init__(self):
        self.etime = 0
    def get_play_time(self): return self.play_time
    def get_stop_time(self): return self.stop_time
    def play(self):
        self.play_time = time.ctime()
        self.start_time = time.time()
    def stop(self):
        self.stop_time = time.ctime()
        self.etime = time.time() - self.start_time
    def __str__(self):
        return "Elapsed Time: %.2f seconds" % self.etime

class AppConfig(ConfigParser.ConfigParser):
    def __init__(self):
        ConfigParser.ConfigParser.__init__(self)

    def optionxform(self, optionstr):
        """
        re-define optionxform, in the release version, return optionstr.lower()
        """
        return optionstr

def get_conf_options(conf_files, key_lower=True):
    """
    get configuration from conf_files, conf_files can be a file or a file list
    all option will not change the case when key_lower is False
    """
    # use <xx> <yy> ... to specify a list string for an option.
    p_multi = re.compile("<([^>]+)>")
    conf_options = dict()
    if key_lower:
        conf_parser = ConfigParser.ConfigParser()
    else:
        conf_parser = AppConfig()
    try:
        conf_parser.read(conf_files)
        for section in conf_parser.sections():
            t_section = dict()
            for option in conf_parser.options(section):
                value = conf_parser.get(section, option)
                value_list = p_multi.findall(value)
                if value_list:
                    value = [item.strip() for item in value_list]
                t_section[option] = value
            conf_options[section] = t_section
        return 0, conf_options
    except Exception, e:
        print("Error. Can not parse configuration file(s) %s" % conf_files)
        print(e)
        return 1, ""

def get_fname(a_file):
    """
    get the filename only
    """
    fname, fext = os.path.splitext(a_file)
    return os.path.basename(fname)

def get_fext_lower(a_file):
    fname, fext = os.path.splitext(a_file)
    return fext.lower()

def get_file_dir(a_file):
    a_file = os.path.abspath(a_file)
    return os.path.dirname(a_file)

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
                print >> a_ob, lines
            else:
                for item in lines:
                    print >> a_ob, item
            a_ob.flush()
            a_ob.close()
            break
        except IOError:
            try_times += 1
            if try_times > 10:
                say_it("-- Error: can not open %s" % a_file)
                return 1
            time.sleep(5)
            say_it("-- Note: try to open %s %d times." % (a_file, try_times))

def write_file(a_file, lines):
    """
    Write a new file
    """
    return append_file(a_file, lines, append=False)

def add_cmd_line_history(log_file):
    new_line = sys.executable + " " +" ".join(sys.argv)
    append_file(log_file, new_line)

def generate_file(a_file, template_file, kwargs):
    """
    generate a file from a template file and its keywords arguments
    """
    new_ob = open(a_file, "w")
    for line in open(template_file):
        line = line % kwargs
        new_ob.write(line)
    new_ob.close()

def wrap_cp_file(src, dst, force=True):
    """
    copy a file
    """
    abs_src = os.path.abspath(src)
    abs_dst = os.path.abspath(dst)
    if abs_src == abs_dst:
        return
    try:
        if os.path.isfile(abs_dst):
            if force:
                os.remove(abs_dst)
        shutil.copy2(src, dst)
    except Exception, e:
        say_it("- Error. Not copy %s to %s" % (src, dst))
        say_it("- %s" % e)
        return 1

def get_original_lines(a_file):
    bak_file = a_file + ".original_bak"
    if wrap_cp_file(a_file, bak_file, force=False):
        return 1
    return open(bak_file).readlines()

def wrap_move_file_folder(src, dst):
    """
    move a file or folder
    """
    try:
        if os.path.exists(dst):
            if os.path.isdir(dst):
                shutil.rmtree(dst)
            else:
                os.remove(dst)
    except Exception:
        pass
    for i in range(5):
        try:
            shutil.move(src, dst)
            break
        except Exception:
            time.sleep(10)

def remove_dir_without_error(a_path):
    """
    try to remove all files/dirs in a path
    if failed, will let it be.
    """
    if not os.path.isdir(a_path):
        return
    for foo in os.listdir(a_path):
        abs_foo = os.path.join(a_path, foo)
        if os.path.isfile(abs_foo):
            try:
                os.remove(abs_foo)
            except Exception:
                continue
        else:
            remove_dir_without_error(abs_foo)
    try:
        shutil.rmtree(a_path)
    except Exception:
        return

def rm_with_error(a_path):
    """
    remove a dir or a file and return 1 if failed
    """
    e = ""
    if os.path.isfile(a_path):
        try:
            os.remove(a_path)
        except Exception, e:
            pass
    elif os.path.isdir(a_path):
        try:
            shutil.rmtree(a_path)
        except Exception, e:
            pass
    if e:
        say_it(e)
        return 1

def not_exists(a_path, comments):
    """
    return 1 if a_path not exists
    """
    if not a_path:
        say_it("-- Error. No value specified for %s" % comments)
        return 1
    if not os.path.exists(a_path):
        say_it("-- Warning. Not found %s <%s> in %s" % (a_path, comments, os.getcwd()))
        return 1

def wrap_md(a_path, comments):
    """
    return 1 if failed to make a new folder if it doesn't exist
    """
    if not a_path:
        say_it("-- Error. No value specified for %s" % comments)
        return 1
    if not os.path.isdir(a_path):
        try:
            os.makedirs(a_path)
        except Exception, e:
            say_it("-- Error. can not makedir %s <%s>" % (a_path, comments))
            say_it(e)
            say_it("")
            return 1

def get_os_name(x86=0):
    """
    get on_win and os_name
    """
    platform_in_short, on_win = sys.platform[:3], 0

    if platform_in_short == "win":
        on_win = 1
        os_name = "nt"
    elif platform_in_short == "lin":
        os_name = "lin"
    else:
        os_name = "sol"
    if not x86:
        os_name += "64"
    return on_win,  os_name

def get_xrange(a_range):
    """
    tuple: (2,8,4)   --> xrange(2, 10, 4)
    string: "2,8,4"  --> xrange(2, 10, 4)
    list: ["2", "8", "1"] --> xrange(2, 9)
    """
    if not a_range:
        return
    range_type = type(a_range)
    if range_type is tuple:
        pass
    else:
        if range_type is str:
            a_range = re.split(",", a_range)
        a_range = (int(a_range[0]), int(a_range[1]), int(a_range[2]))
    return xrange(a_range[0], a_range[1]+1, a_range[2])

def get_cmd(cmd_str, cmd_args):
    """
    get command real line from command raw strings and command arguments
    """
    cmd_str = re.sub("@\(", "%(", cmd_str)
    try:
        cmd_str = cmd_str % cmd_args
    except Exception, e:
        say_it(e, "-- Error. can not get command line")
        return 1, ""
    return 0, cmd_str

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

def get_file_line_count(a_file):
    """
    copy from xReport.py.
    get the line number of a file
    """
    count = -1
    try:
        for count, line in enumerate(open(a_file, "rU")):
            pass
    except IOError:
        pass
    count += 1
    return count

def simple_parser(a_file, patterns, but_lines=0):
    file_lines_no = get_file_line_count(a_file)
    if not file_lines_no:
        return
    start_line = 0
    if but_lines:
        start_line = file_lines_no - but_lines
    i = 0
    for line in open(a_file):
        i += 1
        if line < start_line:
            continue
        line = line.strip()
        for p in patterns:
            m = p.search(line)
            if m:
                return line, m
    return

p_license_error = [re.compile("check\s+your\s+license\s+setup\s+to\s+ensure"),
                   re.compile("infinite loop"),
                   # add more Exception here.
                   ]
p_error_msg = [re.compile("^\s*error", re.I),
               re.compile("^wrong\s+", re.I),
               re.compile("^@E:", re.I)
               # # add more Exception here.
               ]
def run_command(cmd, log_file, time_file):
    """
    launch the command line
    """
    sts = 0
    try_times = -1
    while True:
        try_times += 1
        if try_times > 3: # try to run the command 4 times
            break
        etime = ElapsedTime()
        etime.play()
        log = "Running Command: %s [%s]" % (cmd, etime.get_play_time())
        if try_times:
            log += "-- TryTime: %d" % try_times
        say_it(log)
        say_it("                 <%s>" % os.getcwd())
        sts, text = get_status_output(cmd)
        etime.stop()
        append_file(log_file, ["=" * 30,cmd, etime] + text)
        append_file(time_file, [cmd, "rem %s" % etime])
        if sts:
            t = "Status: Failed."
        else:
            t = "Status: Pass."
        say_it("%s  %s" % (t, etime))
        time.sleep(3.14)
        if not sts:
            break
        # flow failed!
        have_license_error = simple_parser(log_file, p_license_error, 100)
        if have_license_error:
            # backup log file and re-launch the command after 1 minute
            backup_log_file = log_file+str(try_times)
            if os.path.isfile(backup_log_file):
                os.remove(backup_log_file)
            os.rename(log_file, backup_log_file)
            time.sleep(60)
        else:
            break
    if sts:
        error_msg_line = simple_parser(log_file, p_error_msg, 100)
        if error_msg_line:
            say_it(error_msg_line[0])
    say_it("")
    return sts

def get_svn_dirs(svn_path):
    svn_dirs = list()
    svn_ls_cmd = "svn ls %s --username=public --password=lattice" % svn_path
    sts, text = get_status_output(svn_ls_cmd)
    if sts:
        say_it("- Error. Failed to run %s" % svn_ls_cmd)
        return 1
    p_dir = re.compile("\W$")
    for item in text:
        if p_dir.search(item):
            svn_dirs.append(p_dir.sub("", item))
    return svn_dirs

def win2unix(a_path, use_abs=1):
    """
    transfer a path to unix format
    """
    if use_abs:
        a_path = os.path.abspath(a_path)
    return re.sub(r"\\", "/", a_path)

def to_abs_list(a_value, root_path):
    """
    get the absolute path for value(s) in root_path
    """
    t = ChangeDir(root_path)
    if type(a_value) is str:
        _value = [a_value]
    else:
        _value = a_value[:]
    _value = [win2unix(item) for item in _value]
    t.comeback()
    return _value

def get_abs_path(file_string, root_path):
    _tmp_list = to_abs_list(file_string, root_path)
    return _tmp_list[0]

def get_relative_path(file_string, root_path, working_path=""):
    """
    chdir to working_path, return the file's relative path
    """
    if not working_path:
        working_path = os.getcwd()
    new_file = to_abs_list(file_string, root_path)[0]
    working_path = win2unix(working_path)
    f, d = re.split("/", new_file), re.split("/", working_path)
    ff, dd = f[:], d[:]
    for i, item in enumerate(f):
        try:
            d_item = d[i]
        except Exception:
            break
        on_win, nt_lin = get_os_name()
        if on_win:
            same = (item.lower() == d_item.lower())
        else:
            same = (item == d_item)
        if same:
            ff.remove(item)
            dd.remove(d_item)
        else:
            break
    # -----------------
    if len(ff) == len(f):
        return new_file
    else:
        dd_len = len(dd)
        if not dd_len:
            pre_path = ["."]
        else:
            if dd_len > 3:
                # sometimes the python os module can not treat ../../../../../a/b/c/d.v as a file when the file exists!
                return new_file
            pre_path = [".."] * dd_len
        new_path = pre_path + ff[:]
        return "/".join(new_path)

def announce(message):
    length = len(message) + 10
    plus_str = "=" * length
    say_it("")
    say_it(plus_str)
    say_it(message.center(length))
    say_it(plus_str)
    say_it("")

def head_announce():
    """
    head announcement
    """
    message = "Welcome to Lattice Batch-queuing System Test Suite"
    announce(message)
    return time.time()

def root_announce(start_time):
    elapsed_time = time.time() - start_time
    announce("Total Elapsed Time: %.1f seconds" % elapsed_time)

def play_announce(mark, src_design, job_design):
    """ announcement at the beginning
    """
    time_str = time.strftime('%X %x')
    say_it("")
    say_it("*---------------------------------------------")
    say_it("* Start Design: %s <%s>" % (mark, time_str))
    say_it("* SRC DESIGN: %s" % src_design)
    say_it("* JOB DESIGN: %s" % job_design)
    say_it("")
    return time.time()

def stop_announce(status, mark, play_time):
    """ announcement at the end
    """
    time_str = time.strftime('%X %x')
    elapsed_time = time.time() - play_time
    if status:
        pre_str = "Errors found when running %s" % mark
    else:
        pre_str = "Finish design %s" % mark
    say_it("")
    say_it("* %s" % pre_str)
    say_it("* Elapsed time: %.1f seconds. <%s>" % (elapsed_time, time_str))
    say_it("*---------------------------------------------")
    say_it("")

def dict_none_to_new(base_dict, new_dict):
    """
    Key cannot be flow, qa, environment, command template
    """
    for key, value in new_dict.items():
        base_value = base_dict.get(key)
        if base_value is None:
            base_dict[key] = value

def set_value(v):
    """
    set v="" if undefined v
    """
    try:
        type (eval(v))
    except NameError:
        return   ""
    return eval(v)

def get_src_files(ori_src, root_path):
    if type(ori_src) is str:
        ori_src = [ori_src]

    new_src = list()
    for item in ori_src:
        item = win2unix(item, 0)
        item_list = shlex.split(item)
        real_file = get_relative_path(item_list[-1], root_path)
        item_list[-1] = real_file
        new_src.append(item_list)
    return new_src

def copy_to_local(src_file):
    """
    Copy a file to the local path
    """
    if not_exists(src_file, "Source File"):
        return 1, 0
    _local_file = os.path.basename(src_file)
    if wrap_cp_file(src_file, _local_file):
        return 1, 0
    return 0, _local_file

def find_by_fext(top_dir, fext_pattern=".info"):
    match_files = list()
    fext_pattern = fext_pattern.lower()
    for foo in os.listdir(top_dir):
        fname, fext = os.path.splitext(foo.lower())
        if fext_pattern == fext:
            match_files.append(os.path.join(top_dir, foo))
    return match_files

def check_file_number(pattern_files, comments):
    if not pattern_files:
        say_it("-Error. No files found for %s" % comments)
        return 1

    len_files = len(pattern_files)
    if len_files != 1:
        say_it("-Error. Found %d files for %s" % (len_files, comments))
        return 1

def get_true(options, key):
    v = options.get(key)
    if v:
        if v == "0":
            return 0
        elif v == "False":
            return 0
        else:
            return 1
    return v

def get_top_name(src_file):
    """get the first top module name from the source hdl file.
    """
    top_name = simple_parser(src_file, re.compile("^entity\s+(\S+)", re.I))
    if not top_name:
        top_name = simple_parser(src_file, re.compile("^module\s+(\S+)\s*\(*", re.I))
    if not top_name:
        return
    else:
        return top_name[1].group(1)

def get_content_in_start_end(a_file, p_start, p_end):
    start, content = 0, list()
    for line in open(a_file):
        line = line.strip()
        if not line:
            continue
        if not start:
            start = p_start.search(line)
        else:
            if p_end.search(line):
                break
            content.append(line)
    return content

# ----------------------
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
        msvcrt.locking(lock_ob.fileno(), LK_UNLCK, 10)
    else:
        import fcntl
        while 1:
            fcntl.flock(lock_ob, fcntl.LOCK_EX)
            sts = func(args, kwargs)
            fcntl.flock(lock_ob,fcntl.LOCK_UN)
    return sts


if __name__ == "__main__":
    #print get_relative_path("none.log", r"D:\lscc31057\diamond\3.1\active-hdl\Books", r"f:\Mike")
    print get_file_line_count("rrr")







