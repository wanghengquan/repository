#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 2:01 PM 3/18/2020
  file: xTools.py
  author: Shawn Yan
Description:

"""
import io
import os
import platform
import random
import re
import shlex
import string
import sys
import stat
import time
import shutil
import json
import pickle
import subprocess
import traceback
import datetime
import hashlib
import configparser
from collections import OrderedDict
from . import filelock

LINE_MARK = OrderedDict()
LINE_MARK["dos"] = [r"\r\n", "\r\n"]
LINE_MARK["unix"] = [r"\n", "\n"]
LINE_MARK["mac"] = [r"\r", "\r"]


class ChangeDir:
    """
    Change the current working directory to a new path.
    then come back to the original current working directory
    """

    def __init__(self, new_path):
        self.cur_dir = os.getcwd()
        os.chdir(new_path)

    def comeback(self):
        os.chdir(self.cur_dir)


class ElapsedTime:
    """
    Get elapsed time
    """

    def __init__(self):
        self.start_time = time.time()

    def __str__(self):
        elapsed_time = time.time() - self.start_time
        return "Elapsed Time: {:.2f} seconds".format(elapsed_time)

    def in_seconds(self):
        elapsed_time = time.time() - self.start_time
        return int(elapsed_time)


class ConfigParserLocal(configparser.ConfigParser):
    def __init__(self):
        configparser.ConfigParser.__init__(self)

    def read_string(self, u_string, source='<string>'):
        """Read configuration from a given string."""
        string_file = io.StringIO(u_string)
        self.read_file(string_file, source)


class ConfigParserRawKey(ConfigParserLocal):
    def __init__(self):
        ConfigParserLocal.__init__(self)

    def optionxform(self, optionstr):
        """
        re-define optionxform, in the release version, return optionstr.lower()
        """
        return optionstr


def ppause(log="Paused..."):
    """Pause for debugging
    """
    input(log)


def eexit(log="Exit ..."):
    """Exit for debugging
    """
    print(log)
    sys.exit()


def get_os_version():
    if sys.platform.startswith("win"):
        version_commands = ["wmic os get Caption", "ver"]
        version_patterns = [re.compile(r"(Windows)\s+(\d+)"), re.compile(r"(Windows).+Version\s+(\d+)")]
        default_os_version = "Windows"
    else:
        version_commands = ["cat /etc/redhat-release", "lsb_release -ds"]
        version_patterns = [re.compile(r"(Red Hat|CentOS).+release\s+(\S+)"), re.compile(r"(Ubuntu)\s+(\S+)")]
        default_os_version = "Unix"
    for v_cmd in version_commands:
        sts, text = get_status_output(v_cmd)
        if sts:
            continue
        for v_pat in version_patterns:
            m = v_pat.search(text)
            if m:
                os_version = "{} {}".format(m.group(1), m.group(2))
                os_version = re.sub(r"\s+", "", os_version)
                return os_version
    return default_os_version


def get_pc_os_name():
    _release = platform.release()
    pc_full_name = platform.node()
    pc_name = re.split(r"\.", pc_full_name)[0]
    os_ver = get_os_version()
    return pc_name, os_ver


def split_list_with_window(a_list, window=5):
    """Split a list with window
    """
    return [a_list[x:x + window] for x in range(0, len(a_list), window)]


def get_random_string(min_length=10, max_length=20):
    """Get random string
    """
    seeds = string.ascii_letters + string.digits + "_" * 10
    string_length = random.choice(list(range(min_length, max_length)))
    raw_random_string = "".join(random.sample(seeds, max_length + 10))
    raw_random_string = re.sub("_+", "_", raw_random_string)
    raw_random_string = raw_random_string[:string_length + 1]
    raw_random_string = raw_random_string.strip("_")
    return raw_random_string


def sleep_random(min_secs=1, max_secs=10):
    sleep_seconds = random.randint(min_secs, max_secs)
    time.sleep(sleep_seconds)


def win2unix(a_path, use_abs=0):
    """Transfer a path to unix format
    """
    if use_abs:
        a_path = os.path.abspath(a_path)
    a_path = a_path.rstrip("/")
    return re.sub(r"\\", "/", a_path)


def get_true_false(option_dict, key_name):
    """Get True or False for an option
    """
    value = option_dict.get(key_name, 0)
    value = "{}".format(value).lower().strip()
    if value in ("0", "false", "no", "na", "none"):
        return False
    return True


def get_file_line_count(a_file):
    """Get the line number of a file
    """
    count = -1
    try:
        for count, line in enumerate(open(a_file, "rU")):
            pass
    except IOError:
        pass
    count += 1
    return count


def simple_parser(input_file, patterns, tail_number=0):
    """Simple regular expression pattern for a file
    patterns is specified as SRE_Pattern or SRE_Pattern list
    return (SRE_Match, line)
    """
    file_line_count = get_file_line_count(input_file)
    matched, line = None, None
    if file_line_count:
        if not isinstance(patterns, (list, set, tuple)):
            patterns = [patterns]
        start_line = (file_line_count - tail_number) if tail_number else 0
        with open(input_file) as ob:
            for i, line in enumerate(ob):
                if i < start_line:
                    continue
                line = line.strip()
                for p in patterns:
                    matched = p.search(line)
                    if matched:
                        break  # break for searching
                if matched:
                    break  # break for reading
    return matched, line


def encrypt(s, key=365):
    """ Encrypt a string
    """
    b = bytearray(str(s).encode("gbk"))
    n = len(b)
    c = bytearray(n * 2)
    j = 0
    for i in range(0, n):
        key -= 1
        b1 = b[i]
        b2 = b1 ^ key
        c1 = b2 % 16 + 65
        c2 = b2 // 16 + 65
        c[j] = c1
        c[j + 1] = c2
        j += 2
    my_code = c.decode("gbk")
    return "-".join(my_code)


def decrypt(s, key=365):
    """ Decrypt a string
    """
    s = re.sub("-", "", s)
    c = bytearray(str(s).encode("gbk"))
    n = len(c)
    if n % 2 != 0:
        return ""
    n //= 2
    b = bytearray(n)
    j = 0
    for i in range(0, n):
        key -= 1
        c1 = c[j] - 65
        c2 = c[j + 1] - 65
        j += 2
        b2 = c2 * 16 + c1
        b1 = b2 ^ key
        b[i] = b1
    return b.decode("gbk")


def safe_run_function(func, args=None, kw=None, func_lock_file=None, timeout=60):
    """Run function with safety locker
    """
    if not args:
        args = list()
    if not kw:
        kw = dict()
    if not func_lock_file:
        func_lock_file = "{}.lock".format(func.__name__)
    file_locker = filelock.FileLock(func_lock_file, timeout=timeout)
    with file_locker:
        return func(*args, **kw)


def _get_options(raw_parser):
    options = dict()
    for section in raw_parser.sections():
        value_dict = dict()
        for option in raw_parser.options(section):
            v = raw_parser.get(section, option)
            value_dict[option] = v
        options[section] = value_dict
    return options


def get_options(conf_files="", conf_string="", key_is_lower=True):
    """Get Options from config file(s) or config string
    """
    parser = ConfigParserLocal() if key_is_lower else ConfigParserRawKey()
    try:
        if conf_files:
            parser.read(conf_files)
        elif conf_string:
            if not isinstance(conf_string, str):
                conf_string = str(conf_string)
            parser.read_string(conf_string)
        return 0, _get_options(parser)
    except Exception:
        return 1, traceback.format_exc()


def wrap_md(a_path, comments=""):
    """Make a directory
    """
    if not a_path:
        return "-- Error. No value specified for %s" % comments
    if not os.path.isdir(a_path):
        try:
            os.makedirs(a_path)
        except Exception:
            return traceback.format_exc()


def is_same_file(a_file, b_file):
    if os.path.getsize(a_file) != os.path.getsize(b_file):
        return 0
    if abs(os.path.getmtime(a_file) - os.path.getmtime(b_file)) > 5:
        return 0
    return 1


def wrap_cp_file(src, dst, force=False, silent=False):
    """
    copy a file
    """
    abs_src = os.path.abspath(src)
    abs_dst = os.path.abspath(dst)
    if abs_src == abs_dst:
        return
    msg = "" if silent else " .. Copying {} to {}".format(src, dst)
    try:
        if not os.path.isfile(abs_dst):
            will_copy = True
        else:
            will_copy = force
            if not will_copy:
                will_copy = not is_same_file(src, dst)
            if will_copy:
                os.chmod(abs_dst, stat.S_IRWXU)
                os.remove(abs_dst)
        if will_copy:
            shutil.copy2(abs_src, abs_dst)
            msg = "Fine: " + msg
        else:
            msg = ""
    except Exception:
        msg = "Failed: " + msg
    return msg


def not_exists(a_path, comments):
    """
    return 1 if a_path not exists
    """
    if not a_path:
        return "-- Error. No value specified for %s" % comments
    if not os.path.exists(a_path):
        return "-- Warning. Not found %s <%s> in %s" % (a_path, comments, os.getcwd())


def wrap_rm_file(a_file):
    if not os.path.isfile(a_file):
        return
    try:
        os.chmod(a_file, stat.S_IWRITE)
        os.remove(a_file)
    except Exception:
        pass


def wrap_rm_rf(folder_or_file, comments):
    if not_exists(folder_or_file, comments):
        return
    if os.path.isfile(folder_or_file):
        wrap_rm_file(folder_or_file)
        return
    for a, b, c in os.walk(folder_or_file):
        for foo in c:
            abs_foo = os.path.join(a, foo)
            if os.path.isfile(abs_foo):
                wrap_rm_file(abs_foo)
    try:
        shutil.rmtree(folder_or_file)
    except Exception:
        pass


def get_file_format(a_file):
    if os.path.isfile(a_file):
        with open(a_file, "rb") as ob:
            for line in ob:
                line = repr(line)
                for k, v in list(LINE_MARK.items()):
                    if v[0] in line:
                        return k


def write_file(this_file, lines, append=False, file_format=""):
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
    aw = "a" if append else "w"
    if isinstance(lines, str):
        lines = [lines]
    for i in range(5):
        try:
            with open(this_file, aw) as file_ob:
                for item in lines:
                    if new_line:
                        new_item = item + new_line
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
    return write_file(this_file, new_lines, file_format=file_format)


def get_status_output(cmd):
    """return (status, output) of executing cmd in a shell.
    source from commands.py <def getstatusoutput(cmd)>.
    """
    on_win = (sys.platform[:3] == "win")
    if not on_win:
        cmd = "{ " + cmd + "; }"
    pipe = os.popen(cmd + " 2>&1", "r")
    text = pipe.read()
    sts = pipe.close()
    text = re.sub("\n\n", "\n", text)
    if sts is None:
        sts = 0
    if not on_win:
        sts = (sts >> 8)
    return sts, text


def run_command(cmd, log_file=None, time_file=None):
    """Execute a command and dump the log files
    """
    et = ElapsedTime()
    print(("Running Command: {} {}".format(cmd, time.ctime())))
    sts, text = get_status_output(cmd)
    if log_file or time_file:
        timestamp_lines = [">> {} <{}>".format(cmd, time.ctime()), str(et), text]
        if log_file:
            write_file(log_file, timestamp_lines, append=True)
        if time_file:
            write_file(time_file, timestamp_lines[:-1], append=True)
    return sts


def get_real_path(raw_path, root_path):
    """Change dir to root_path and get the absolute path from a raw_path
    """
    _recovery = ChangeDir(root_path)
    real_path = os.path.abspath(raw_path)
    _recovery.comeback()
    return win2unix(real_path)


def get_file_dirname(a_file):
    """get file's dirname"""
    return os.path.dirname(os.path.abspath(a_file))


def get_file_name_only(a_file):
    """get file's name without file extension"""
    return os.path.splitext(os.path.basename(a_file))[0]


def set_environment(radiant_or_diamond, debug=False):
    """Set Radiant/Diamond general environment
    """
    on_windows = sys.platform.startswith("win")
    os_name = "nt64" if on_windows else "lin64"
    tcl_name = "windows" if on_windows else "linux"

    this_foundry = os.path.join(radiant_or_diamond, "ispfpga")
    this_tcl = os.path.join(radiant_or_diamond, "tcltk", tcl_name, "lib", "tcl8.5")
    this_ispvm = os.path.join(radiant_or_diamond, "ispvmsystem")

    customer_dict = dict(FOUNDRY=this_foundry, ISPVM_PATH=this_ispvm,
                         TCL_LIBRARY=this_tcl, TOOLRTF=radiant_or_diamond,
                         PATH=os.pathsep.join([os.path.join(radiant_or_diamond, "bin", os_name),
                                               os.path.join(this_foundry, "bin", os_name),
                                               os.getenv("PATH")]))
    for k, v in list(customer_dict.items()):
        if debug:
            print(("ENV: {}   VALUE: {}".format(k, v)))
        os.environ[k] = v


def get_valid_lines(a_file, skip_patterns):
    """Get valid lines from a file and skip some lines
    """
    valid_lines = list()
    with open(a_file) as ob:
        for line in ob:
            for p in skip_patterns:
                if p.search(line):
                    break
            else:
                valid_lines.append(line.strip())
    return valid_lines


def get_str_time(epoch_time):
    return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(epoch_time))


def get_epoch_time_before_n_days(days=90):
    _now = datetime.datetime.now()
    _delta = datetime.timedelta(days=days)
    _t = _now - _delta
    return time.mktime(_t.timetuple())


def run_squish(aut, aut_path, test_suite, result_path, test_cases=None):
    """
    already added squish bin into PATH
    all path in UNIX format
    """
    # start the squishserver (and don't wait)
    if sys.platform.startswith("win"):
        subprocess.Popen(["squishserver", "--verbose"])
    else:
        subprocess.Popen(["squishserver"])
    time.sleep(10)
    # add AUT
    subprocess.call(["squishrunner", "--config", "addAUT", aut, aut_path])
    # execute the test (and wait for it to finish)
    exec_list = ["squishrunner", "--testsuite", test_suite]
    if test_cases:
        exec_list.append("--testcase")
        exec_list.extend(test_cases)
    exec_list.append("--reportgen")
    exec_list.append("xml3,%s" % result_path)
    subprocess.call(exec_list)
    # stop the squishserver
    subprocess.call(["squishserver", "--stop"])


def __get_now():
    return datetime.datetime.utcnow() + datetime.timedelta(hours=8)


def get_shanghai_time():
    time_now = __get_now()
    return time_now.strftime('%H:%M:%S %m/%d/%Y UTC+8')


def get_shanghai_digital_time():
    time_now = __get_now()
    return time_now.strftime('%y%m%d%H%M%S')


def get_shanghai_epoch_time():
    time_now = __get_now()
    return int(time.mktime(time_now.timetuple()))


def get_shanghai_weekday():
    """
    :return: 0-6: Monday, Tuesday, ..., Sunday
    """
    time_now = __get_now()
    return time_now.weekday()


def _get_number_name_dict(backup_root_dir, true_name):
    p_number = re.compile(re.escape(true_name) + r"_\d+(-\d+)$")
    number_name_dict = dict()
    for foo in os.listdir(backup_root_dir):
        m_number = p_number.search(foo)
        if m_number:
            number_name_dict[int(m_number.group(1))] = os.path.join(backup_root_dir, foo)
    return number_name_dict


def get_new_backup_name(backup_root_dir, true_name):
    number_name_dict = _get_number_name_dict(backup_root_dir, true_name)
    if not number_name_dict:
        new_number = -1
    else:
        keys = list(number_name_dict.keys())
        keys.sort()
        new_number = keys[0] - 1
    return os.path.join(backup_root_dir, "{}_{}{:05}".format(true_name, get_shanghai_digital_time()[:-2], new_number))


def get_current_backup_name(backup_root_dir, true_name):
    number_name_dict = _get_number_name_dict(backup_root_dir, true_name)
    if not number_name_dict:
        return
    else:
        keys = list(number_name_dict.keys())
        keys.sort()
        return number_name_dict.get(keys[0])


def remove_elder_backup_directory(backup_root_dir, true_name, number_backups):
    number_name_dict = _get_number_name_dict(backup_root_dir, true_name)
    keys = list(number_name_dict.keys())
    keys.sort()
    for k in keys[number_backups:]:
        wrap_rm_rf(number_name_dict[k], "")


def comma_split(raw_string):
    """
    get a list by splitting a string by comma and remove empty items.
    """
    raw_string = raw_string.strip(", ")
    _a = shlex.shlex(raw_string, posix=True)
    _a.whitespace = ','
    _a.whitespace_split = True
    _a = list(_a)
    _b = list()
    for foo in _a:
        new_foo = foo.strip()
        if new_foo:
            _b.append(new_foo)
    return _b


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


class GetFolderSHA1Dict(object):
    def __init__(self, top_dir, simple_mode=True):
        self.top_dir = top_dir
        self.simple_mode = simple_mode
        self.folder_sha1_dict = dict()

    def process(self):
        self._create_dict(self.top_dir, skip_files=True)

    def get_folder_sha1_dict(self):
        return self.folder_sha1_dict

    @staticmethod
    def skip_it(file_or_dir):
        full_names = (".svn", "Thumbs.db", ".idea")
        end_names = (".pyc", ".lnk", ".swp")
        start_names = ("~", )
        if file_or_dir in full_names:
            return 1
        for foo in end_names:
            if file_or_dir.endswith(foo):
                return 1
        for foo in start_names:
            if file_or_dir.startswith(foo):
                return 1

    def _create_dict(self, this_top, skip_files=False):
        if not os.path.isdir(this_top):
            return
        rel_name = os.path.relpath(this_top, self.top_dir)
        dirs, files = list(), dict()
        try:
            original_dfs = os.listdir(this_top)
        except Exception:
            print(("Cannot list directory: {}".format(this_top)))
            return
        for foo in original_dfs:
            if self.skip_it(foo):
                continue
            abs_foo = os.path.join(this_top, foo)
            try:  # try to deal with it
                if os.path.isdir(abs_foo):
                    dirs.append(foo)
                    self._create_dict(abs_foo)
                else:
                    if skip_files:  # exclude of all files under the root path
                        continue
                    sha1_code = "" if self.simple_mode else file_sha1(abs_foo)
                    files[foo] = sha1_code
            except Exception:
                print(("Cannot deal with {}".format(abs_foo)))
        self.folder_sha1_dict[rel_name] = dict(DIRS=dirs, FILES=files)


def dump_json(json_file, data):
    """
    dump data to json file
    """
    with open(json_file, "w") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)


def load_json(json_file):
    """
    load data from json file
    """
    with open(json_file, 'r') as f:
        data = f.read().encode(encoding='utf-8')
        return json.loads(data)


def dump_pickle(pickle_file, data):
    """
    dump data to pickle file. pickle file supports any CODING data.
    """
    with open(pickle_file, "wb") as ob:
        pickle.dump(data, ob)


def load_pickle(pickle_file):
    """
    load data from pickle file. pickle file supports any CODING data.
    """
    with open(pickle_file, "rb") as ob:
        return pickle.load(ob)


class NS(object):
    """Namespace for dictionary"""
    def __init__(self, **kwargs):
        self.__dict__.update(kwargs)

    def __repr__(self):
        sorted_items = sorted(self.__dict__.items())
        kwarg_str = ', '.join(['%s=%r' % tup for tup in sorted_items])
        return '%s(%s)' % (type(self).__name__, kwarg_str)

    __hash__ = None

    def __eq__(self, other):
        return vars(self) == vars(other)

    def __ne__(self, other):
        return not (self == other)


def get_files(root_path, partial_name, fext_name, get_single=False):
    if partial_name:
        possible_names = (partial_name, partial_name + fext_name)
    else:
        possible_names = (fext_name,)
    possible_files = list()
    for foo in os.listdir(root_path):
        for bar in possible_names:
            if foo.endswith(bar):
                possible_files.append(win2unix(os.path.join(root_path, foo)))
                break
    if get_single:
        return possible_files[0] if possible_files else ""
    return possible_files
