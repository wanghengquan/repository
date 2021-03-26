import os
import re
import sys
import stat
import glob
import time
import shutil

from xLog import print_error, print_always, print_quiet

def wrap_md(a_path, comments):
    if not a_path:
        print_error("No path name specified for %s" % comments)
        return 1
    if not os.path.isdir(a_path):
        for i in range(3): # try to create it 3 times
            try:
                os.makedirs(a_path)
                break
            except WindowsError: # on Windows
                time.sleep(5)
            except OSError:      # on Linux/Unix
                time.sleep(5)
        else:  # no break, failed to create the path
            print_error("Not created %s (%s)" % (a_path, comments))
            return 1

def not_exists(a_path, comments=""):
    if not a_path:
        if comments:
            print_error("No path name specified for %s" % comments)
        return 1
    if not os.path.exists(a_path):
        if comments:
            print_error("Not found %s (%s)" % (a_path, comments))
        return 1

def copy_and_chmod(src, dst):
    try:
        shutil.copy2(src, dst)
    except IOError:
        print_error("Can not copy file: %s" % src)
        return 1
    try:
        os.chmod(dst, stat.S_IRWXU)
    except OSError:
        print_quiet("Warning. Can't chmod for %s" % dst)

def wrap_copy_file(src, dst, force=False):
    if not os.path.isfile(dst):
        return copy_and_chmod(src, dst)
    if force:
        try:
            os.remove(dst)
            return copy_and_chmod(src, dst)
        except IOError:
            pass

def wrap_copy_dir(src, dst, force=False):
    if not_exists(src, "source path"):
        return 1
    if wrap_md(dst, "destination path"):
        return 1
    for foo in os.listdir(src):
        src_foo = os.path.join(src, foo)
        dst_foo = os.path.join(dst, foo)
        if os.path.isdir(src_foo):
            if foo == ".svn":
                continue
            else:
                wrap_copy_dir(src_foo, dst_foo)
        else:
            wrap_copy_file(src_foo, dst_foo, force)

def wrap_move_file(src, dst):
    for i in range(10):
        # try to move the file 10 times in 100 seconds.
        try:
            shutil.move(src, dst)
            break
        except OSError:
            time.sleep(10)
    else:
        print_error("Can not move file %s to %s" % (src, dst))
        return 1

def wrap_move_dir(src, dst):
    if wrap_md(dst, "Destination Path"):
        return 1
    for foo in os.listdir(src):
        src_foo = os.path.join(src, foo)
        dst_foo = os.path.join(dst, foo)
        if os.path.isfile(src_foo):
            if wrap_move_file(src_foo, dst_foo):
                return 1
        else:
            if wrap_move_dir(src_foo, dst_foo):
                return 1
    shutil.rmtree(src)

def get_hot_files(wd, hot_fext_list):
    hot_files = list()
    if os.path.isdir(wd):
        for foo in os.listdir(wd):
            fname, fext = os.path.splitext(foo.lower())
            if fext in hot_fext_list:
                hot_files.append(os.path.join(wd, foo))
    return hot_files

def get_unique_file(file_pattern, speak_out=False):
    if type(file_pattern) is str:
        files = glob.glob(file_pattern)
    else:
        files = list()
        file_dir, file_ext = file_pattern
        if not_exists(file_dir, "Base searching path"):
            return
        for foo in os.listdir(file_dir):
            foo_name, foo_ext = os.path.splitext(foo.lower())
            if foo_ext == file_ext:
                files.append(os.path.join(file_dir, foo))
    if not files:
        if speak_out:
            print_error("Not found file for %s" % str(file_pattern))
        return
    len_files = len(files)
    if len_files > 1:
        print_always("Warning. %d files found for %s" % (len_files, str(file_pattern)))
    if len_files == 1:
        return files[0]
    else:
        '''
            special process for _lse.twr
        '''
        for f in files:
            if f.endswith('_lse.twr'):
                pass
            else:
                return f
    #return files[0]

def get_unix_path(a_path):
    return re.sub(r"\\", "/", a_path)

def get_os_env_sep(x64):
    if re.search("win", sys.platform, re.I):
        os_name, env_sep = "nt", ";"
    else:
        os_name, env_sep = "lin", ":"
    if x64:
        os_name += "64"
    return os_name, env_sep

def get_fname_ext(a_path):
    base_name = os.path.basename(a_path)
    return os.path.splitext(base_name)

def get_real_path(a_path):
    if not_exists(a_path):
        a_path = a_path.split()
        a_path = " ".join(a_path)
        return a_path
    else:
        a_path = os.path.abspath(a_path)
        return get_unix_path(a_path)

class RecoverPath:
    """
    change dir to a new working path and come back to local working path
    """
    def __init__(self, new_wd):
        self.cur_dir = os.getcwd()
        os.chdir(new_wd)

    def run(self):
        os.chdir(self.cur_dir)
