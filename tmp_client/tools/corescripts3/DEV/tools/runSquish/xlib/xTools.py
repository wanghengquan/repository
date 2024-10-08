import os
from . import filelock
import re
import hashlib
import sys
import time
import shlex
import stat
import shutil
import configparser
from collections import OrderedDict

__author__ = 'syan'
__version__ = '17:21 14/1/17'

LINE_MARK = OrderedDict()
LINE_MARK["dos"] = [r"\r\n", "\r\n"]
LINE_MARK["unix"] = [r"\n", "\n"]
LINE_MARK["mac"] = [r"\r", "\r"]


def say_it(an_object, comments="", show=1):
    """
    wrapper of print
    """

    if not show:
        return
        # ---------------------
    log = ""
    bqs_l_o_g = os.getenv("bqs_l_o_g")
    if bqs_l_o_g:
        try:
            log = open(bqs_l_o_g, "a")
            if comments:
                print(comments, file=log)
        except Exception:
            log = ""
            pass
        # ---------------------

    if comments:
        say_it(comments)

    obj_type = type(an_object)
    if obj_type is str:
        print(an_object)
        if log: print(an_object, file=log)
    elif obj_type is list or obj_type is tuple:
        for item in an_object:
            print(("- %s" % item))
            if log: print("- %s" % item, file=log)
    elif obj_type is dict:
        keys = list(an_object.keys())
        keys.sort(key=str.lower)
        for key in keys:
            _val = an_object.get(key)
            print(("- %-20s: %s" % (key, _val)))
            if log: print("- %-20s: %s" % (key, _val), file=log)
    else:
        print(an_object)
        if log: print(an_object, file=log)
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

class AppConfig(configparser.ConfigParser):
    def __init__(self):
        configparser.ConfigParser.__init__(self)

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
        conf_parser = configparser.ConfigParser()
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
    except Exception as e:
        # print(("Error. Can not parse configuration file(s) %s" % conf_files))
        # print(e)
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
                say_it("-- Warning: can not open %s" % a_file)
                return 1
            time.sleep(5)
            say_it("-- Note: try to open %s %d times." % (a_file, try_times))

def write_file(a_file, lines):
    """
    Write a new file
    """
    return append_file(a_file, lines, append=False)


def get_file_format(a_file):
    if os.path.isfile(a_file):
        with open(a_file, "rb") as ob:
            for line in ob:
                line = repr(line)
                for k, v in list(LINE_MARK.items()):
                    if v[0] in line:
                        return k


def new_write_file(this_file, lines, append=False, file_format=""):
    """Write/append a file
    """
    this_file = os.path.abspath(this_file)
    this_dir = os.path.dirname(this_file)
    ret = wrap_md(this_dir, "")
    if ret:
        return ret
    if append and (not file_format):
        file_format = get_file_format(this_file)
    new_line = LINE_MARK.get(file_format)
    if new_line:
        new_line = new_line[1]
    if new_line:
        aw = "a+b" if append else "w+b"
    else:
        aw = "a" if append else "w"
    if isinstance(lines, str):
        lines = [lines]
    for i in range(5):
        try:
            with open(this_file, aw) as file_ob:
                for item in lines:
                    if new_line:
                        new_item = item + new_line
                        new_item = new_item.encode(encoding="utf-8")
                        file_ob.write(new_item)
                    else:
                        print(item, file=file_ob)
            return
        except IOError:
            time.sleep(2.71)
    return "Failed to open file: {}".format(this_file)


def update_file(this_file, new_lines):
    """Update a file and keep the original file format
    """
    file_format = get_file_format(this_file)
    return new_write_file(this_file, new_lines, file_format=file_format)



def generate_file(a_file, template_file, kwargs):
    """
    generate a file from a template file and its keywords arguments
    """
    new_ob = open(a_file, "w")
    for line in open(template_file):
        line = line % kwargs
        new_ob.write(line)
    new_ob.close()


def add_license_control(ini_file):
    return
    p = re.compile("AllowLicenseControl=(.+)")
    with open(ini_file) as ob:
        for line in ob:
            m = p.search(line)
            if m:
                if m.group(1) == "true":
                    return  # do not change
    ini_lines = open(ini_file).readlines()
    with open(ini_file, "w") as ob:
        for line in ini_lines:
            if p.search(line):
                continue
            print(line, file=ob, end="")
            if "[General]" in line:
                print("AllowLicenseControl=true", file=ob)


def safe_copy_file(_src, _dst, _force):
    if os.path.isfile(_dst):
        if _force:
            try:
                os.remove(_dst)
            except:
                pass
        else:
            return
    try:
        shutil.copy2(_src, _dst)
        os.chmod(_dst, stat.S_IRWXU)
    except:
        print("Failed to copy {} to {}".format(_src, _dst))

    if _dst.endswith(".setting.ini"):
        add_license_control(_dst)


def file_sha1(file_name, ignore_format=False, max_call_times=None):
    """
    get sha1 code for a file.
    if ignore_format is True, will not calculate sha1 code for newline tag.
    if the file is huge, will calculate sha1 core max_call_times at most to save time.
    """
    _FILE_SLIM = 65536  # read stuff in 64kb chunks!
    call_times = 0
    my_sha1 = hashlib.sha1()
    with open(file_name, "rb") as ob:
        while True:
            data = ob.read(_FILE_SLIM)
            if not data:
                break
            if ignore_format:
                data = data.decode(encoding="utf-8")
                data = data.replace("\r", '')
                data = data.replace("\n", '')
                data = data.encode(encoding="utf-8")
            if max_call_times:
                call_times += 1
                if call_times > max_call_times:
                    break
            my_sha1.update(data)
    return my_sha1.hexdigest()


def wrap_cp_file(src, dst, force=True):
    """
    copy a file
    """
    abs_src = os.path.abspath(src)
    abs_dst = os.path.abspath(dst)
    if abs_src == abs_dst:
        return
    if os.path.isfile(abs_src) and os.path.isfile(abs_dst):
        # change mode when OSError or PermissionError
        for foo in (abs_src, abs_dst):
            try:
                with open(foo) as ob:
                    pass
            except:
                os.chmod(foo, stat.S_IRWXU)
        code_a, code_b = file_sha1(abs_src), file_sha1(abs_dst)
        if code_a == code_b:
            print("Message: same file for {}".format(abs_dst))
            return
        else:
            sts_a, options_a = get_conf_options(abs_src, key_lower=False)
            sts_b, options_b = get_conf_options(abs_dst, key_lower=False)
            if sts_a or sts_b:  # cannot parse options
                pass
            else:
                will_copy = 0
                for section_name, option_a_dict in list(options_a.items()):
                    if will_copy:
                        break
                    option_b_dict = options_b.get(section_name, dict())
                    for key, value_a in list(option_a_dict.items()):
                        if key in ("RecentProjList", "LastProjPath", "LastFilePath", "RecentFileList"):
                            continue
                        value_b = option_b_dict.get(key)
                        if value_a != value_b:
                            will_copy = 1
                            break
                if not will_copy:
                    return
    copy_lock_file = os.path.splitext(abs_dst)[0] + ".lock"
    dir_name = os.path.dirname(abs_dst)
    if not os.path.isdir(dir_name):
        wrap_md(dir_name, "layout_path")
    print("[MSG] try to update {}".format(abs_dst))
    filelock.safe_run_function(safe_copy_file, args=(abs_src, abs_dst, force), func_lock_file=copy_lock_file)


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
        except Exception as e:
            pass
    elif os.path.isdir(a_path):
        try:
            shutil.rmtree(a_path)
        except Exception as e:
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
        except Exception as e:
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
    return range(a_range[0], a_range[1]+1, a_range[2])

def get_cmd(cmd_str, cmd_args):
    """
    get command real line from command raw strings and command arguments
    """
    cmd_str = re.sub("@", "%", cmd_str)
    try:
        cmd_str = cmd_str % cmd_args
    except Exception as e:
        say_it(e, "-- Error. can not get command line")
        return 1, ""
    return 0, cmd_str

def get_status_output(cmd):
    """
    return (status, output) of executing cmd in a shell.
    source from commands.py <def getstatusoutput(cmd)>.
    """
    on_win = (sys.platform[:3] == "win")
    if not on_win:
        cmd = "{ " + cmd + "; }"
    pipe = os.popen(cmd + " 2>&1", "r")
    text = list()
    for item in pipe:
        text.append(item.rstrip())
    try:
        sts = pipe.close()
        if sts is None: sts = 0
        if not on_win:
            sts = (sts >> 8)
    except IOError:
        sts = 1
    if sts is None: sts = 0
    if sts > 200:
        sts = (sts >> 8)
    return sts, text

def old_get_status_output(cmd):
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

def run_command(cmd, log_file, time_file):
    """
    launch the command line
    """
    etime = ElapsedTime()
    etime.play()
    say_it("Running Command: %s [%s]" % (cmd, etime.get_play_time()))
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
    say_it("")
    time.sleep(3.88)
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

def head_announce():
    """
    head announcement
    """
    say_it("")
    say_it("*---------------------------------------------")
    say_it("* Welcome to Lattice Batch-queuing System Test Suite")

def play_announce(src_design, job_design, comments=list()):
    """ announcement at the beginning
    """
    say_it("* Play Time: %s" % time.asctime())
    say_it("*---------------------------------------------")
    say_it("")
    say_it("* SRC DESIGN: %s" % src_design)
    say_it("* JOB DESIGN: %s" % job_design)
    if comments:
        for item in comments:
            say_it(item)
    say_it("")

    return time.time()

def stop_announce(play_time):
    """ announcement at the end
    """
    elapsed_time = time.time() - play_time
    say_it("")
    say_it("*---------------------------------------------")
    say_it("* Finished Lattice Batch-queuing System Test Flow")
    say_it("* Stop Time: %s" % time.asctime())
    say_it("*")
    say_it("* Elapsed time: %d seconds." % elapsed_time)
    say_it("*---------------------------------------------")
    say_it("")

def dict_none_to_new(base_dict, new_dict):
    """
    Key cannot be flow, qa, environment, command template
    """
    for key, value in list(new_dict.items()):
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
        if i < start_line:
            continue
        line = line.strip()
        for p in patterns:
            m = p.search(line)
            if m:
                return line, m
    return


def get_environment(radiant_diamond, nt_lin, squish):
    current_list = [os.path.join(radiant_diamond, "ispfpga"),
                    os.path.join(radiant_diamond, "ispfpga", "bin", nt_lin),
                    os.path.join(radiant_diamond, "bin", nt_lin)
                    ]
    _ld_library_path = current_list[1:]
    kwargs = dict()
    kwargs["FOUNDRY"] = current_list[0:1]
    kwargs["LD_LIBRARY_PATH"] = _ld_library_path
    kwargs["DISABLE_TMCHECK"] = "1"
    _tmp_path = _ld_library_path + [os.path.join(squish, "bin")]
    if nt_lin.startswith("nt"):
        kwargs["PATH"] = _tmp_path + ["%PATH%"]
        kwargs["CASE_PATH"] = ['%realParentPath%']
    else:
        kwargs["PATH"] = _tmp_path + ["$PATH"]
        kwargs["CASE_PATH"] = ['$(cd "$(dirname "$0")"; cd ..; pwd)']
    kwargs["PATH"].insert(0, os.path.dirname(sys.executable))
    # ------------
    env_lines = list()
    _env_cmd = "set" if nt_lin.startswith("nt") else "export"
    for key, value in list(kwargs.items()):
        _ = "%s %s=%s" % (_env_cmd, key, os.pathsep.join(value))
        env_lines.append(_)

    return "\n".join(env_lines)


def set_lm_license_environment(root_file):
    # DO NOt use .. to get the DEV path
    root_file = os.path.abspath(root_file)
    root_path = os.path.dirname(root_file)
    for i in range(2):
        root_path = os.path.dirname(root_path)

    conf_file = os.path.join(root_path, "conf", "default.ini")
    if not os.path.isfile(conf_file):
        print("Warning. Not found {}".format(conf_file))
        return 1
    sts, options = get_conf_options(conf_file, key_lower=False)
    d_env = options.get("environment", dict())
    x = "AllowLicenseControl"
    if d_env.get(x) in ("1", "yes", "true", "True"):
        os.environ[x] = "1"
    env_key = "LM_LICENSE_FILE"
    my_env = d_env.get(env_key)
    if my_env:
        os.environ[env_key] = os.pathsep.join(my_env)
    else:
        print("Warning. Not found {} in {}".format(env_key, conf_file))
        return 1


IMG_PERL = ('testSettings->logScreenshotOnError(1);', 'testSettings->logScreenshotOnFail(1);')


def _update_test_pl_file(design_path):
    msg = "update test.pl in {}".format(design_path)
    pl_files = list()
    file_a = os.path.join(design_path, "test.pl")
    if os.path.isfile(file_a):
        pl_files.append(file_a)
    for foo in os.listdir(design_path):
        file_b = os.path.join(design_path, foo, "test.pl")
        if os.path.isfile(file_b):
            pl_files.append(file_b)
    for pl in pl_files:
        new_lines = list()
        added = 0
        with open(pl, encoding="utf-8") as ob:
            for line in ob:
                line_y = line.rstrip()
                line_x = re.sub(r"\s", "", line)
                if not line_x:
                    if not added:
                        new_lines.extend(IMG_PERL)
                        added = 1
                elif line_x in IMG_PERL:
                    continue
                new_lines.append(line_y)
        sts = "Successfully" if added else "NO Changes!"
        print("{}: {}".format(msg, sts))
        update_file(pl, new_lines)


def _remove_console_log_file(design_path):
    log_file = os.path.join(design_path, "console.log")
    if os.path.isfile(log_file):
        log_file = os.path.realpath(log_file)
        print("removing {}".format(log_file))
        rm_with_error(log_file)


def _add_disable_gpu_in_public_pl_file(design_path):
    p_add = re.compile(r'(startApplication)\("(pnmain|radiant)"\);')
    f_add = lambda x: p_add.sub(r'\1("\2 --disable-gpu");', x)
    for a, b, c in os.walk(design_path):
        public_pl_file = os.path.join(a, "public.pl")
        if os.path.isfile(public_pl_file):
            old_lines = open(public_pl_file).readlines()
            new_lines = list()
            for foo in old_lines:
                new_foo = f_add(foo)
                new_foo = new_foo.rstrip()
                new_lines.append(new_foo)
            update_file(public_pl_file, new_lines)
            return


def very_first_process(design_path):
    _update_test_pl_file(design_path)
    _remove_console_log_file(design_path)
    # _add_disable_gpu_in_public_pl_file(design_path)


def sort_by_num(raw_string):
    p = re.compile(r"_(\d+)")
    m = p.search(raw_string)
    if m:
        return int(m.group(1))
    else:
        return 0


def _printout_images_info(design_path):
    """Show 9 pictures at most.
       will try to print the newer file if exceed 9.
    """
    _max_pic_number = 8
    images = dict()
    for foo in os.listdir(design_path):
        abs_foo = os.path.join(design_path, foo)
        if os.path.isfile(abs_foo):
            continue
        if foo.endswith("Images"):
            images.setdefault(foo, list())
            for bar in os.listdir(abs_foo):
                if bar.endswith(".png"):
                    images[foo].append(bar)
    if images:
        for k, v in list(images.items()):
            v.sort(key=sort_by_num, reverse=True)
        nine_images = dict()
        images_number = 0
        for i in range(0, 10):
            if images_number > _max_pic_number:
                break
            for k, v in list(images.items()):
                nine_images.setdefault(k, list())
                try:
                    nine_images[k].append(v[i])
                    images_number += 1
                    if images_number > _max_pic_number:
                        break
                except IndexError:
                    continue
        say_it("")
        say_it("Images Number: {}".format(images_number))
        ii = 1
        for kk, vv in list(nine_images.items()):
            for foo in vv:
                say_it("-PNG{}: {}/{}".format(ii, kk, foo))
                ii += 1


def ultimate_process(design_path):
    _printout_images_info(design_path)
