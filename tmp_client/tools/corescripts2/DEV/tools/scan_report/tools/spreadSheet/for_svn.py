#! C:\Python25\python.exe
#===================================================
# Owner    : Yzhao1
# Function :
#           This file is used for export cases from svn server
#           from the new structure result.
# Attention: the first parameter should be the --suite=***
#             the second parameter should be the --top-dir=***
#             If you want the --impl command, it should be in the third place
#                             --impl=***
#             all the directory please use absloute path


# Date     :2013/1/21

#===================================================
import os
import sys,re
import svn_export
import shutil
def get_cmd_value(str,cmd):
    '''
    This function used to get the comand value from a line.
    str is the comand line
    cmd is the name you want to return
    EXAMPLE: 
         '*** *** --comand=value *** ***'
         the return is "value" 
    '''
    cmd =  '--'+cmd
    cmd_re = re.compile(r"""%s\s?=\s?([\w : \\ _ - \. ]+)
                    ($
                    |\s+--)"""%cmd,re.VERBOSE)
    cmd_compile = cmd_re.search(str)
    if cmd_compile:
        #print cmd_compile.groups(-1)
        return (cmd_compile.group(1)).strip()
    else:
        print 'Nothing find'
        return


priviledge = ['L25_ecp3',
            'E60_ecp3',    
            'E60_xo2',
            'L25_ecp2',
            'L25_sc',   
            'E60_xp2',   
            'E60_ecp2',
            'X103A_xo2',   
            'X103T_xo2',      
            'X103A_xo',    
            'X103T_xo',
            'S24_ecp3', 
            'S24_ecp2',    
            'S24_sc']
all_cmd = " ".join(sys.argv)
impl = get_cmd_value(all_cmd,'impl')
run_suites= []
suites= []
suite = sys.argv[1]
suite = (suite.split('=')[1]).strip()
svn_directory = sys.argv[2]
svn_directory = (svn_directory.split('=')[1]).strip()
svn_suite  = os.path.join(svn_directory,suite)
if suite.find('103')!= -1:
    suite2 = 'X103'
    family = suite.split('_')[1]
else:
    suite2 = suite.split('_')[0]
    family = suite.split('_')[1]
########################################################
# The following steps are used for svn export right case and right family
if not impl:
    url = r' http://d50534/'+suite2+r'/trunk'
    cmd = 'svn ls '+ url+'  --username=public --password=lattice'
    p_dir =  re.compile("/$")
    raw_file_dirs = os.popen(cmd)  # at here all the list is case
    for id1,item in enumerate(raw_file_dirs):
        item =  item.strip()
        if p_dir.search(item):
            case_url = url+r'/'+item
            svn_export.svn_export_case(case_url,family,item[:-1],svn_suite)
        else:
            case_url = url+r'/'+item
            svn_export.svn_export_file(case_url,item,svn_suite)
        
    #------------ check out the scripts ---------------------#
    script_url = r'http://d50534/auto/trunk'
    script_export = 'svn export '+script_url+'  '+ svn_directory+'/trunk'+ ' ' + '--username=public --password=lattice --force' 
    done = os.system(script_export) 
    if not done:
        print "script checkout done" 
    else:
        print "Please check the command:" 
        print script_export
        #sys.exit() 

    
cmds = []
if not impl:
    for item in sys.argv[3:]:
        cmds.append(item)
else:
    for item in sys.argv[4:]:
        cmds.append(item)
cmd = ' '.join(cmds)  # cmd =  --synp-wrap --top-dir= *** --job-dir=aaaa --design=***
for_job_dir = cmd.split('--job-dir')[1]  # =aaa --design=***
for_job_dir = for_job_dir.split('-')[0]  #  =aaa
for_job_dir = for_job_dir.replace('=',' ') # aaa


cmds = cmd.split('--job-dir')
cmd2 = cmds[1] # =aaa --design=***
cmd2.strip()
cmd3 = cmd2.split('-')
if len(cmd3)==1:
   cmd_use = ' '
else:
   cmd_use = '-'+'-'.join(cmd3[1:])
cmd = cmds[0]+' --job-dir='+suite+' '+cmd_use   # all th upper steps are used for write --job-dir

for_job_dir =for_job_dir.strip()
if not os.path.isdir(os.path.join(for_job_dir,suite)):
    #os.makedirs(for_job_dir)
    os.makedirs(os.path.join(for_job_dir,suite))

file_bat_suite = file(os.path.join(for_job_dir,suite+'.bat'),'w')
top_dir = os.path.join(svn_directory,suite)
cmd1 = r'python '+os.path.join(svn_directory,'trunk','bin','runLattice.py')  +'  '+ cmd + ' --top-dir='+top_dir
for item in os.listdir(svn_suite):
    if os.path.isdir(os.path.join(svn_suite,item)):
        pass
    else:
        continue
      
    cmd2 =  cmd1 + ' --design='+item+'\n'
    file_bat_suite.write(cmd2)
#file_bat_suite.write(cmd1)
file_bat_suite.close()
#----------------------------------  not for runlines ---------------#
#cmd1 = r'python '+os.path.join(svn_directory,'trunk','bin','runLattice.py')  +'  '+ cmd + ' --top-dir='+top_dir+'\n'
#file_bat_suite.write(cmd1)
#file_bat_suite.close()
file_sweeping_bat_name = os.path.join(for_job_dir,suite,'scan_data'+'.bat')
file_sweeping_bat = file(file_sweeping_bat_name,'w')
cmd1 = r'python '+os.path.join(svn_directory,'trunk','bin','run_scan_lattice.py')+' ' + '--job-dir='+os.path.join(for_job_dir,suite)
file_sweeping_bat.write(cmd1)
file_sweeping_bat.close()
shutil.copy2(file_sweeping_bat_name,top_dir)

#------------ write copy.bat in the top_dir ----------------#
if impl:
    #run_standard_dir = os.path.join(for_job_dir,suite,'scan_data'+'.bat')
    impl_suite = os.path.join(impl,suite)
    if os.path.isdir(impl_suite):
        pass
    else:
        os.makedirs(impl_suite)
    file_hand = file( os.path.join(for_job_dir,suite,'copy.bat'),'w' )
    copy_cmd = 'copy '+suite+'_run_standard.bat'+' '+impl # copy run_stand
    file_hand.write(copy_cmd+'\n')
    copy_cmd = 'copy '+'fail_case.log'+' '+impl_suite # copy fail_log
    file_hand.write(copy_cmd+'\n')
    file_hand.close()
else:
    file_hand = file( os.path.join(for_job_dir,suite,'copy.bat'),'w' )
    copy_cmd = 'copy '+suite+'_run_standard.bat'+' '+svn_directory # copy run_stand
    file_hand.write(copy_cmd+'\n')
    copy_cmd = 'copy '+'fail_case.log'+' '+top_dir # copy fail_log
    file_hand.write(copy_cmd+'\n')
    file_hand.close()

file_bat = file(os.path.join(for_job_dir,'lanuch.bat'),'w')
all_files = os.listdir(for_job_dir)
run_lines = r'python '+os.path.join(svn_directory,'trunk','tools','runLines','runLines.py')
for item in priviledge:
    item = item+'.bat'
    if item in all_files:
        file_bat.write('call '+run_lines+'  '+ item+'\n')
file_bat.close()
    
    

    
    