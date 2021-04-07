import os
import sys
#output requirements: maximum 10 line will be take by client
#build:  xxxxx = xxxxxxxx
#build:  xxxxx = xxxxxxxx

top_dir = os.getcwd()
#scan_dir = r'/lsh/sw/release/rel'
beta_key = 'ng1_0b'
trunk_key = 'ng1_0'

if 'win' in sys.platform:
    print ('This script do not support windows, only Linux platform supported')
    scan_dir = r'Z:/release/rel'
    extra_dir = r'eit/pc/install'
else:
    scan_dir = r'/lsh/sw/release/rel'
    extra_dir = r'eit/lin/install'


beta_folder_list = []
trunk_folder_list = []
for item in os.listdir(scan_dir):
    if item.split(".")[0] == beta_key:
        beta_folder_list.append(item)
    if item.split(".")[0] == trunk_key:
        trunk_folder_list.append(item)

def build_check_pass(build):
    build_path = os.path.join(scan_dir, build, extra_dir)
    if not os.path.exists(build_path):
        print (build + ':not find build path:' + build_path)
        return False
    if 'win' in sys.platform:
        pnmain_path = os.path.join(build_path, 'bin/nt64/pnmain.exe')
    else:
        pnmain_path = os.path.join(build_path, 'bin/lin64/pnmain')
    if not os.path.exists(pnmain_path):
        print (build + ':not find pnmain')
        return False
    if 'win' in sys.platform:
        map_path = os.path.join(build_path, 'ispfpga/bin/nt64/map.exe')
    else:
        map_path = os.path.join(build_path, 'ispfpga/bin/lin64/map')
    if not os.path.exists(map_path):
        print (build + ':not find map file')
        return False
    return True

beta_build = []
for beta in beta_folder_list:
    if (not build_check_pass(beta)):
        print ("Not beta build:" + beta)
    continue
    beta_build.append(beta)
print (beta_build)
    
trunk_build = []
for trunk in trunk_folder_list:
    if (not build_check_pass(trunk)):
        print ("Not trunk build:" + trunk)
    continue
    trunk_build.append(trunk)
print (trunk_build)

#get top5 beta build
beta_build_num_list = []
for build in beta_build:
    if '.' not in build:
        print (build + ': skipped')
        continue
    id  = build.split('.')[1]
    beta_build_num_list.append(id)
beta_build_num_list.sort()
beta_build_num_list.reverse()
print ('beta total:' + ','.join(beta_build_num_list))
counter = 0
beta_final_list = []
for index in beta_build_num_list[1:]:
    if (counter < 5):
        beta_final_list.append(index)
    counter += 1;
print ('beta final:' + ','.join(beta_final_list))



#get top5 trunk build
trunk_build_num_list = []
for build in trunk_build:
    if '.' not in build:
        print (build + ': skipped')
        continue
    id  = build.split('.')[1]
    trunk_build_num_list.append(id)
trunk_build_num_list.sort()
trunk_build_num_list.reverse()
print ('trunk total:' + ','.join(trunk_build_num_list))
counter = 0
trunk_final_list = []
for index in trunk_build_num_list[1:]:
    if (counter < 5):
        trunk_final_list.append(index)
    counter += 1;
print ('trunk final:' + ','.join(trunk_final_list))

###############print final output#####################
for build in beta_final_list:
    print ('build:ng1_0b.%s = %s/ng1_0b.%s/%s' % (build, scan_dir, build, extra_dir))

for build in trunk_final_list:
    print ('build:ng1_0.%s = %s/ng1_0.%s/%s' % (build, scan_dir, build, extra_dir))
