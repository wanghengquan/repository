import os
import re

top_dir = r"E:\newSquish\sourceR3"
diamond = r"C:\lscc\diamond\3.2_x64"
squish = r"E:\newSquish\squish423"
rpt_dir = r"E:\newSquish\run"
p_tst = re.compile("^tst_")

def find_suite(wd, wd_list):
    find_times = [0,0]
    for foo in wd_list:
        fname, fext = os.path.splitext(foo.lower())
        if fext == ".map":
            find_times[0] = 1
        elif fext == ".conf":
            find_times[1] = 1
    if sum(find_times) == 2:
        return wd
suite_tst = list()
def find_suite_tst(top_dir):
    for foo in os.listdir(top_dir):
        abs_foo = os.path.join(top_dir, foo)
        if os.path.isdir(abs_foo):
            foo_list = os.listdir(abs_foo)
            suite_name = find_suite(abs_foo, foo_list)
            if suite_name:
                suite_tst.append([suite_name, [item for item in foo_list if p_tst.search(item)]])
            else:
                find_suite_tst(abs_foo)

find_suite_tst(top_dir)

py_line = r"python .\run_squish.py"
kline = " --diamond=%s --squish=%s " % (diamond, squish)

for (suite, tst_list) in suite_tst:
    suite_path, suite_name = os.path.split(suite)
    my_path = os.path.basename(suite_path)
    if re.search("suite_FE_17_POJO2", suite):
        dia_line = kline
    else:
        dia_line = kline
    for item in tst_list:
        print r"%s --suite=%s --case=%s --rpt-dir=%s --timeout=0 %s" % (py_line, suite, item, os.path.join(rpt_dir, my_path, suite_name, item), dia_line)


print "cmd"
