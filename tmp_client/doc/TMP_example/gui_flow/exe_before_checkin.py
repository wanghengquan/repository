import os
import sys
import glob
import shutil

script_dir = os.path.split(os.path.realpath(__file__))[0]
map_file = os.path.join(script_dir, 'objects.map')
cnf_file = os.path.join(script_dir, 'suite.conf')
lst_file = os.path.join(script_dir, 'case_list.ini')
lyt_file = os.path.join(script_dir, 'suite_be_05_fv.ini')

os.chdir(script_dir)
data_lst = glob.glob("*/testdata")

for item in data_lst:
    item_path = os.path.join(script_dir, item)
    if not os.path.exists(item_path):
        print "Warning:cannot find path:%s" % item_path
        continue
    shutil.copy(map_file, item_path)
    shutil.copy(cnf_file, item_path)
    shutil.copy(lyt_file, item_path)
    
ini_frh = open(lst_file, 'w')
for item in data_lst:
    case_path = os.path.split(item)[0]
    print >> ini_frh, case_path
ini_frh.close()
raw_input('press to leave')