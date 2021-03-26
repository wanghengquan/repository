"""
copy suites with 8 sub_processes.
"""
import os
import re
import time
import sys
import stat
import shutil

from multiprocessing import Process

def _copy_and_chmod(src, dst):
    try:
        shutil.copy2(src, dst)
        time.sleep(1)
    except IOError:
        print(("Error. Can not copy file: %s" % src))
        return 1
    try:
        os.chmod(dst, stat.S_IRWXU)
    except OSError:
        print(("Warning. Can't chmod for %s" % dst))

def wrap_copy_file(src, dst, force=False):
    src_name = os.path.basename(src)
    if re.search("^\.", src_name):
        pass
    elif re.search("^\W", src_name):
        return
    if force:
        if os.path.isfile(dst):
            os.remove(dst)
        return _copy_and_chmod(src, dst)
    else:
        if os.path.isfile(dst):
            return
        else:
            return _copy_and_chmod(src, dst)


class CopyThem:
    def __init__(self):
        self.log_file = r"latest_updateBAK.log"
        self.lines_list = list()

    def append_log(self, lines, write=0):
        if write:
            log = open(self.log_file, "w")
        else:
            log = open(self.log_file, "a")
        if type(lines) is str:
            print(lines, file=log)
        else:
            for line in lines:
                print(line, file=log)
        log.close()

    def copy_all(self, from_dir, to_dir):
        if os.path.isdir("stop"):
            sys.exit()

        if not os.path.isdir(from_dir):
            print("Not find %s" % from_dir)
            return
        if not os.path.isdir(to_dir):
            os.makedirs(to_dir)


        from_dirs_files = set(os.listdir(from_dir))
        to_dirs_files = set(os.listdir(to_dir))

        # remove some dir/files
        remove_list = to_dirs_files - from_dirs_files
        if remove_list:
            for item in remove_list:
                abs_item = os.path.join(to_dir, item)
                self.lines_list.append("  ** remove %s" % abs_item)
                try:

                    if os.path.isdir(abs_item):
                        shutil.rmtree(abs_item)
                    else:
                        os.remove(abs_item)
                except:
                    print(("Error. Can not remove %s" % abs_item))
                    pass
        # add some dir/files
        add_list = from_dirs_files - to_dirs_files
        if add_list:
            for item in add_list:
                src_item = os.path.join(from_dir, item)
                dst_item = os.path.join(to_dir, item)
                if os.path.isdir(src_item):
                    if re.search("\.dir$", src_item):
                        continue
                    #if item == "rev_1":
                    #    continue
                    self.lines_list.append("  ** add %s" % dst_item)
                    self.copy_all(src_item, dst_item)
                else:
                    self.lines_list.append("  ** add %s" % dst_item)
                    wrap_copy_file(src_item, dst_item)
        # update dir/files
        public_list = to_dirs_files & from_dirs_files
        if public_list:
            for item in public_list:
                src_item = os.path.join(from_dir, item)
                dst_item = os.path.join(to_dir, item)
                if os.path.isdir(src_item):
                    if re.search("\.dir$", src_item):
                        pass
                    else:
                        self.copy_all(src_item, dst_item)
                else:
                    src_time = os.path.getmtime(src_item)
                    dst_time = os.path.getmtime(dst_item)
                    time_diff = src_time - dst_time
                    if abs(time_diff) > 10:
                        self.lines_list.append("  ** update %s" % dst_item)
                        wrap_copy_file(src_item, dst_item, force=True)

        if self.lines_list:
            self.append_log(self.lines_list)
            self.append_log("--")
            self.lines_list = list()

my_copy = CopyThem()


if __name__ == '__main__':
    plist=[]
    for (src, dst) in [(r"Z:\regression3.0", r"E:\newSquish\sourceR3"), ]:
        for foo in os.listdir(src):
            src_foo = os.path.join(src, foo)
            dst_foo = os.path.join(dst, foo)
            if not os.path.isdir(src_foo): continue
            proc=Process(target=my_copy.copy_all,args=(src_foo, dst_foo))
            plist.append(proc)
    try:
        mp = int(sys.argv[1])
    except:
        mp = 8

    total = len(plist)

    while True:
        # -- all done?
        done_list = [1 if re.search("stopped", repr(item)) else 0 for item in plist]
        # -- working?
        doing_list = [1 if re.search("started", repr(item)) else 0 for item in plist]
        # -- initial?
        initial_list = [1 if re.search("initial", repr(item)) else 0 for item in plist]

        if sum(done_list) == total:
            break
        doing_no = sum(doing_list)
        if doing_no >  mp:
            time.sleep(10)
            continue
        # will launch one

        for i, sts in enumerate(initial_list):
            if sts == 1:
                plist[i].start()
                time.sleep(10)
                break # break for
        else:
            break  # break while

        time.sleep(10)

