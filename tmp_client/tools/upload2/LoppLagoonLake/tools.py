#!/usr/bin/python
# -*- coding: utf-8 -*-
import os
import sys
import re
import stat
import time
import random
import shutil
import shlex
import string
import traceback
import platform
from multiprocessing.dummy import Pool as ThreadPool
import ConfigParserPy27 as ConfigParser
import fnmatch

__author__ = 'Shawn Yan'
__date__ = '11:15 2018/10/24'


def get_machine_name():
    """Get machine name
    """
    machine_name = platform.uname()[1]
    machine_name = re.split("\.", machine_name)
    return machine_name[0]


def ppause(log=""):
    """ wrapper of pause by raw_input
    """
    if not log:
        log = time.ctime() + ">>"
    raw_input(log)


def eexit(log=""):
    """ Exit flow
    """
    sys.exit(log)


def split_list_with_window(a_list, window=5):
    """Split a list with window
    """
    return [a_list[x:x+window] for x in range(0, len(a_list), window)]


def comma_split(raw_string, sep_mark=","):
    raw_string = raw_string.strip("{} ".format(sep_mark))
    _ = shlex.shlex(raw_string, posix=False)
    _.whitespace = sep_mark
    _.whitespace_split = True
    _ = list(_)
    _ = map(lambda x: x.strip(), _)
    return _


class ChangeDir:
    """Change the current working directory to a new path.
    and can come back to the original current working directory
    """
    def __init__(self, new_path):
        self.cur_dir = os.getcwd()
        os.chdir(new_path)

    def comeback(self):
        os.chdir(self.cur_dir)


class AppConfig(ConfigParser.ConfigParser):
    def __init__(self):
        ConfigParser.ConfigParser.__init__(self)

    def optionxform(self, optionstr):
        """
        re-define optionxform, in the release version, return optionstr.lower()
        """
        return optionstr


def get_conf_file_options(conf_files, key_lower=True):
    """
    get configuration from conf_files, conf_files can be a file or a file list
    all option will not change the case when key_lower is False
    """
    # use <xx> <yy> ... to specify a list string for an option.
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
                t_section[option] = value
            conf_options[section] = t_section
    except:
        print("Failed to parse file(s): %s" % conf_files)
        print(traceback.format_exc())
    return conf_options


def get_string_options(raw_string, key_lower=True):
    """
    get configuration from conf_files, conf_files can be a file or a file list
    all option will not change the case when key_lower is False
    """
    # use <xx> <yy> ... to specify a list string for an option.
    conf_options = dict()
    if key_lower:
        conf_parser = ConfigParser.ConfigParser()
    else:
        conf_parser = AppConfig()
    try:
        conf_parser.read_string(raw_string)
        for section in conf_parser.sections():
            t_section = dict()
            for option in conf_parser.options(section):
                value = conf_parser.get(section, option)
                t_section[option] = value
            conf_options[section] = t_section
    except:
        print("Failed to parse string")
    return conf_options


class ElapsedTime:
    """
    get elapsed time and timestamp
    """
    def __init__(self):
        self.etime = 0
        self.play()

    def play(self):
        self.start_time = time.time()

    def stop(self):
        self.etime = time.time() - self.start_time
        self.start_time = time.time()

    def get_etime(self):
        return self.etime

    def __str__(self):
        self.etime = time.time() - self.start_time
        return "Elapsed Time: %.2f seconds" % self.etime


def get_filename(a_file):
    return os.path.splitext(os.path.basename(a_file))[0]


def write_file(a_file, lines, append=False, enter_mark=None):
    """
    append a file or create a new file if append=False
    """
    try_times = 1
    a_file = os.path.abspath(a_file)
    a_dir = os.path.dirname(a_file)
    if wrap_md(a_dir, "File Path"):
        return 1
    while True:
        try:
            aw = "ab" if append else "wb"
            with open(a_file, aw) as a_ob:
                if type(lines) is str:
                    lines = [lines]
                for item in lines:
                    if enter_mark:
                        a_ob.write(item)
                        a_ob.write(enter_mark)
                    else:
                        print >> a_ob, item
            break
        except IOError:
            try_times += 1
            if try_times > 10:
                print("-- Error: can not open %s" % a_file)
                return 1
            time.sleep(5)
            print("-- Note: try to open %s %d times." % (a_file, try_times))


def get_file_enter_mark(a_file):
    fmt = ""
    with open(a_file, "rb") as ob:
        for line in ob:
            t = repr(line)
            if r"\r\n" in t:
                fmt = "\r\n"
            elif r"\n" in t:
                fmt = "\n"
            else:
                fmt = "\r"
            break
    return fmt


def update_file(a_file, new_lines):
    file_enter_mark = get_file_enter_mark(a_file)
    write_file(a_file, new_lines, append=False, enter_mark=file_enter_mark)


def get_status_output(cmd):
    """
    return (status, output) of executing cmd in a shell.
    source from commands.py <def getstatusoutput(cmd)>.
    """
    on_win = (sys.platform[:3] == "win")
    if not on_win:
        cmd = "{ " + cmd + "; }"
    pipe = os.popen(cmd + " 2>&1", "r")
    text = pipe.read()
    sts = pipe.close()
    if sts is None:
        sts = 0
    if text[-1:] == '\n':
        text = text[:-1]
    return sts, text


def run_command(cmd, log_file=None, time_file=None):
    etime = ElapsedTime()
    print(" Running %s <%s>" % (cmd, time.ctime()))
    sts, text = get_status_output(cmd)
    if log_file or time_file:
        timestamp_lines = [">> {} <{}>".format(cmd, time.ctime()), etime]
        if log_file:
            write_file(log_file, timestamp_lines + [text], append=True)
        if time_file:
            write_file(time_file, timestamp_lines, append=True)


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


def win2unix(a_path, use_abs=0):
    """
    transfer a path to unix format
    """
    if use_abs:
        a_path = os.path.abspath(a_path)
    return re.sub(r"\\", "/", a_path)


def not_exists(a_path, comments):
    """
    return 1 if a_path not exists
    """
    if not a_path:
        print("-- Error. No value specified for %s" % comments)
        return 1
    if not os.path.exists(a_path):
        print("-- Warning. Not found %s <%s> in %s" % (a_path, comments, os.getcwd()))
        return 1


def wrap_md(a_path, comments):
    """
    return 1 if failed to make a new folder if it doesn't exist
    """
    if not a_path:
        print("-- Error. No value specified for %s" % comments)
        return 1
    if not os.path.isdir(a_path):
        try:
            os.makedirs(a_path)
        except:
            print(traceback.format_exc())
            return 1


def wrap_rm_rf(folder, comments):
    if not_exists(folder, comments):
        return
    for a, b, c in os.walk(folder):
        for foo in c:
            abs_foo = os.path.join(a, foo)
            try:
                os.chmod(abs_foo, stat.S_IWRITE)
                os.remove(abs_foo)
            except:
                pass
    try:
        shutil.rmtree(folder)
    except:
        pass


def wrap_cp_file(src, dst, force=False, rec_logger=None):
    """
    copy a file
    """
    abs_src = os.path.abspath(src)
    abs_dst = os.path.abspath(dst)
    if abs_src == abs_dst:
        return
    try:
        if not os.path.isfile(abs_dst):
            will_copy = True
        else:
            will_copy = force
            if not will_copy:
                for func in (os.path.getsize, os.path.getmtime):
                    if abs(func(abs_src) - func(abs_dst)) > 5:
                        will_copy = True
                        break
            if will_copy:
                os.chmod(abs_dst, stat.S_IRWXU)
                os.remove(abs_dst)
        if will_copy:
            if rec_logger:
                rec_logger.info(" .. Copying {} to {}".format(src, dst))
            shutil.copy2(abs_src, abs_dst)
    except:
        print(traceback.format_exc())
        return 1


class _GetFiles(object):
    def __init__(self, top_dir, file_pattern):
        self.top_dir = top_dir
        self.file_pattern = file_pattern

    def process(self):
        self.files = list()
        self.get_them(self.top_dir)

    def get_them(self, top_dir):
        for foo in os.listdir(top_dir):
            if foo == ".svn":
                continue
            abs_foo = os.path.join(top_dir, foo)
            if os.path.isfile(abs_foo):
                if fnmatch.fnmatch(foo, self.file_pattern):
                    self.files.append(abs_foo)
            else:
                self.get_them(abs_foo)


def get_files_from_folder(top_dir, file_pattern="*.rdf"):
    t = _GetFiles(top_dir, file_pattern)
    t.process()
    return t.files


def simple_search(a_file, re_patterns):
    if not isinstance(re_patterns, list):
        re_patterns = [re_patterns]
    try:
        with open(a_file) as ob:
            for line in ob:
                line = line.rstrip()
                for p in re_patterns:
                    m = p.search(line)
                    if m:
                        return m, line
    except:
        return None, None


def sleep_random(_min, _max):
    assert isinstance(_min, int), "Min sleep time should be an integer"
    assert isinstance(_max, int), "Max sleep time should be an integer"
    t = random.randint(_min, _max)
    print(" Sleep %d seconds." % t)
    time.sleep(t)


def get_random_string(min_length=8, max_length=60):
    seed = string.ascii_letters + string.digits * 2
    seed += "_" * 5
    while True:
        string_len = random.randint(min_length, max_length)
        new_string = "".join(random.sample(seed, string_len))
        new_string = re.sub("^[\d_]+", "", new_string)
        new_string = re.sub("_+$", "", new_string)
        new_string = re.sub("_+", "_", new_string)
        if not new_string:
            continue
        return new_string


def get_platform():
    """
    uname tuple: (system, node, release, version, machine, processor)
    ---- Windows ----
    >> platform.platform()
    Windows-7-6.1.7601-SP1
    >> platform.uname()
    ('Windows', 'D50513', '7', '6.1.7601', 'AMD64', 'Intel64 Family 6 Model 60 Stepping 3, GenuineIntel')
    ---- Ubuntu ----
    >> platform.platform()
    Linux-4.15.0-33-generic-x86_64-with-debian-stretch-sid
    >> platform.uname()
    ('Linux', 'LAB27406', '4.15.0-33-generic', '#36~16.04.1-Ubuntu SMP Wed Aug 15 17:21:05 UTC 2018',
    'x86_64', 'x86_64')
    ---- Redhat ----
    >> platform.platform()
    Linux-2.6.32-696.28.1.el6.x86_64-x86_64-with-redhat-6.6-Santiago
    >> platform.uname()
    ('Linux', 'lsh-opera.latticesemi.com', '2.6.32-696.28.1.el6.x86_64', '#1 SMP Thu Apr 26 04:27:41 EDT 2018',
    'x86_64', 'x86_64')
    """
    _p = platform.platform()
    if "Windows" in _p:
        x = "windows"
    elif "redhat" in _p:
        x = "default"
    else:
        _u = platform.version()
        if "Ubuntu" in _u:
            x = "ubuntu"
        else:
            x = ""
    assert x, "Cannot find platform name"
    return x


def get_12_time():
    """
    :return:181214083956
    """
    return time.strftime("%y%m%d%H%M%S")


def get_int_time():
    return int(time.time())


def get_valid_filename(raw_string):
    _ = re.sub("\W", " ", raw_string)
    _ = re.sub("\s+", "_", _)
    _ = re.sub("_+", "_", _)
    return _


def run_qt(exe_file, install_iss="", uninstall_iss="", create_only=False):
    """
    Support QT operations
    install_iss has higher priority
    """
    _iss = install_iss if install_iss else uninstall_iss
    _iss = win2unix(_iss, 1)
    kwargs = dict(
        exe=exe_file,
        iss=_iss,
        iu="install" if install_iss else "uninstall",
        uninstall_tag="" if install_iss else "-uninst",

        ca="Create" if create_only else "Apply",
        create_tag="/r" if create_only else "/s",
    )
    msg = "{ca} {iss} to {iu} {exe}".format(**kwargs)
    print(msg)
    cmd_line = '{exe} {create_tag} /f1"{iss}" {uninstall_tag}'.format(**kwargs)
    cmd_line = win2unix(cmd_line)
    file_mark = '{ca}_{iu}'.format(**kwargs)
    return run_command(cmd_line, file_mark + ".log", file_mark + ".time")


def wrapper(args):
    src, dst = args[0], args[1]
    sts = wrap_cp_file(src, dst, force=False)
    if sts:
        print("Failed to copy {} to {}".format(src, dst))


class SyncFolders(object):
    def __init__(self, src, dst, pool_size=0, debug=0):
        self.src = src
        self.dst = dst
        self.pool_size = pool_size
        self.debug = debug

        self.skip_patterns = (
            re.compile("\.lnk$"),
            re.compile("^Thumbs\.db$"),
            re.compile("^~\$"),
            re.compile("\.swp$"),
            re.compile("^\.svn$"),
            re.compile("bk5-32IM-jd-CORE"),
            re.compile("10_QA_Testcase"),  # always failed to access it
            re.compile("R140114_JohnsonDrop"),  # always failed to access it
        )

    def process(self):
        try:
            self.will_copy_files = list()
            self.create_or_remove(self.src, self.dst)
            self.check_and_copy_files()
        except:
            pass

    def create_or_remove(self, from_dir, to_dir):
        if not os.path.isdir(from_dir):
            return
        if wrap_md(to_dir, "Destination Folder"):
            return
        try:
            from_dfs = os.listdir(from_dir)
            to_dfs = os.listdir(to_dir)
        except OSError:
            return
        set_of_from = self.get_set_of_dfs(from_dfs)
        set_of_to = self.get_set_of_dfs(to_dfs)
        need_remove_fds = set_of_to - set_of_from
        need_check_fds = set_of_to & set_of_from
        need_create_fds = set_of_from - set_of_to
        # remove them!
        for foo in need_remove_fds:
            abs_foo = os.path.join(to_dir, foo)
            if os.path.isfile(abs_foo):
                try:
                    os.remove(abs_foo)
                except:
                    pass
            else:
                shutil.rmtree(abs_foo, ignore_errors=True)
        # check them!
        for foo in need_check_fds:
            from_foo = os.path.join(from_dir, foo)
            to_foo = os.path.join(to_dir, foo)
            self.check_df(from_foo, to_foo, check_from_df=False)  # use local path for os.listdir
        # create them!
        for foo in need_create_fds:
            from_foo = os.path.join(from_dir, foo)
            to_foo = os.path.join(to_dir, foo)
            self.check_df(from_foo, to_foo, check_from_df=True)

    def check_df(self, from_df, to_df, check_from_df=True):
        this_df = from_df if check_from_df else to_df
        if os.path.isdir(this_df):
            self.create_or_remove(from_df, to_df)
        else:
            self.will_copy_files.append([from_df, to_df])

    def get_set_of_dfs(self, dfs):
        my_set = set()
        for foo in dfs:
            for p in self.skip_patterns:
                if p.search(foo):
                    break
            else:
                my_set.add(foo)
        return my_set

    def check_and_copy_files(self):
        if self.pool_size > 1:
            pool = ThreadPool(self.pool_size)
            pool.map(wrapper, self.will_copy_files)
            pool.close()
            pool.join()
        else:
            map(wrapper, self.will_copy_files)
