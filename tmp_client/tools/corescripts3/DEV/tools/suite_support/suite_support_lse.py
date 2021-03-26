import re
import sys
import os
from multiprocessing import Process,Value,Lock, Manager,active_children
from threading import Timer
import time
import optparse
import platform
from xConf import get_conf_options
import csv
import traceback
used_python =  sys.executable
#self.conf_options = get_conf_options(conf_files)
if platform.system().find('Win')!= -1:
    try:
        import kill_pop_window
        import xFiles
    except:
        print('Can not import relate lib for win, Please make sure you have install win32 API')
        sys.exit(-1)
import kill_old_process
############################### Update Version ##################################
# version 1.0 : user do not have to add top-dir in the options if top-dir has been writed in --options
# version 2.0 : if run lattice, the script will collect relative path according to top-dir
# version 3.0 : add rerun.bat after check and update the show log for the suite
#
################################################################################
def stop_process(pid,lock,max_process,cmd=''):
    while pid.is_alive():
        pid.terminate()
        if not pid.is_alive():
            print('Cancel it successful')
            break
        else:
            time.sleep(30)
    lock.acquire()
    max_process.value = max_process.value - 1
    rerun_bat = file('rerun.bat','a')
    rerun_bat.write(cmd+'\n')
    rerun_bat.close()
    lock.release()

def del_option(cmd_string,option):
    '''
    This function used to del the option and return the cmd
    EXample:
    cmd = '*** --option=value1 ***'
    the return will be '*** ***'
    '''
    re_option = re.compile(r'(--'+option+r'=.+?)(\s|--|$)')
    re_search = re_option.search(cmd_string)
    if re_search:
        cmd = cmd_string.replace( (re_search.group(1)).strip(),' ')
        return cmd
    else:
        return cmd_string
def get_cmd_value(cmd,option):
    '''
    this function used to get the option value from cmd, the cmd format should be as --option=value
    the return value will be "value"
    '''
    #re_option = re.compile(r'--'+option+r'=(.+?)(\w|<|--|$)')
    re_option = re.compile(r'--'+option+r'=(.+?)(\s|>|<|--|$)')
    re_search = re_option.search(cmd)
    if re_search:
        return (re_search.group(1)).strip()
    else:
        return -1
def get_suit_content(top_dir='',suite_file='',suite_name='',lattice='',scan=''):
    suite_p = re.compile('\[\s*%s\s*\](.*?)$'%suite_name)
    suite_lag = re.compile('\[(.*?)\](.*?)$')
    if not os.path.isfile(suite_file):
        print('Can not get file:%s'%suite_file)
        return -1
    all_lines  =  file(suite_file).readlines()
    return_lines = []
    begin = 0
    suite_command = ''
    suite_name_temp=''
    for l in all_lines:
        l = l.strip()
        if l.startswith('#'):
            continue
        if not l:
            continue
        suite_search = suite_p.search(l)
        if suite_search and suite_name:
            begin = 1
            suite_command = suite_search.group(1)
            suite_command = suite_command.strip()
            continue
        if suite_lag.search(l):
            if suite_name:
                begin=0
                continue
            else:
                begin = 1
                suite_lag_search = suite_lag.search(l)
                suite_name_temp = suite_lag_search.group(1)
                suite_name_temp = suite_name_temp.strip()
                suite_command = suite_lag_search.group(2)
                suite_command = suite_command.strip()
                continue
        if begin == 1:
            use_l = l
            if suite_name:
                if not scan:
                    use_l = top_dir+'/'+suite_name+'/'+use_l
                else:
                    use_l = top_dir+'/'+suite_name+'/'+use_l.split()[0]
            elif suite_name_temp:
                if not scan:
                    use_l = top_dir+'/'+suite_name_temp+'/'+use_l
                else:
                    use_l = top_dir+'/'+suite_name_temp+'/'+use_l.split()[0]
            else:
                pass
            if lattice:
                use_l = use_l.replace(top_dir,'')
                use_l = use_l.strip('/')
                use_l = use_l.strip('\\')
            if scan:
                use_l = use_l.replace(top_dir,'')
                use_l = use_l.strip('/')
                use_l = use_l.strip('\\')
            use_l_list = use_l.split()
            if not scan:
                if lattice:
                    use_l_list.insert(1,suite_command)
            use_l = " ".join(use_l_list)
            return_lines.append(use_l)
    return return_lines

def select_cases(top_dir=-1,suite_file=-1,suite_name=-1,lattice='',scan=''):
    if top_dir == -1:
        print('Error, can not get top dir')
        return -1
    top_dir = os.path.abspath(top_dir)
    if not os.path.isdir(top_dir):
        print('Error, can not find dir:%s'%str(top_dir))
        return -1
    if suite_file == -1:
        all_cases = []
        for root,dirs,files in os.walk(top_dir):
            root = os.path.abspath(root)
            for f in files:
                if f.endswith('.info'):
                    if lattice:
                        root = root.replace(top_dir,'')
                        root = root.strip('/')
                        root = root.strip('\\')
                    all_cases.append(root)
                    break
                elif f.endswith('.ldf'):
                    if root.endswith('par'):
                        case_t = os.path.dirname(root)
                        if lattice:
                            case_t = case_t.replace(top_dir,'')
                            case_t = case_t.strip('/')
                            case_t = case_t.strip('\\')
                        all_cases.append(case_t)
                        break
                '''elif f.endswith('.conf'):
                    if lattice:
                        root = root.replace(top_dir,'')
                        root = root.strip('/')
                        root = root.strip('\\')
                    all_cases.append(root)
                    break'''
        return list(set(all_cases))
    if suite_name == -1:
        return get_suit_content(top_dir,suite_file,lattice=lattice,scan=scan)
    else:
        return get_suit_content(top_dir,suite_file,suite_name,lattice=lattice,scan=scan)


def make_configure(check_conf, top_dir,case=''):
    ##################################################
    # Name: message_case_example
    # Function: This file used to produce a auto.conf file under case directory.
    #           The content is writen according to the csv file.
    # For check_conf file,It's a csv file and we have to make sure the format is:
    #Case_ID,Check_file,Check_method,message
    #case1,file1,check_lines,***
    ##################################################
    CONFIGURE_FILE_NAME = "auto.conf"
    CONFIGURE_FILE_TITLE = "[configuration information]\narea = auto_fe_check\ntype = fe_check\n[method]\n"
    try:
        f = open(check_conf, "r")
    except IOError:
        print("Error: Can't open file " + f + ".")
        return -1

    for line in csv.DictReader(f):
        case_dir = line["Case_ID"]
        case_dir = case_dir.strip()
        case_dir = re.sub(r'\\','/',case_dir)
        if case:
            case = re.sub(r'\\','/',case.strip())
            if case ==  case_dir:
                pass
            else:
                continue
        else:
            continue
        case_dir = os.path.join(top_dir, case_dir)
        case_dir = os.path.abspath(case_dir)
        if not ( os.path.exists(case_dir) and os.path.isdir(case_dir) ):
            print("Warning: Can't find case dir " + case_dir + ".")
        else:
            try:
                f_conf = open(os.path.join(case_dir, CONFIGURE_FILE_NAME), "w")
                f_conf.write(CONFIGURE_FILE_TITLE)
                f_conf.writelines([
                    "%s = 1\n" % line["Check_method"],
                    "[%s]\n" % line["Check_method"],
                    "file = %s\n" % line["Check_file"],
                    "check_1 = %s\n" % re.sub(r"\n", "", line["message"])
                ])
                f_conf.close()
            except IOError:
                print("Can't make " + CONFIGURE_FILE_NAME + " in " + case_dir + ".")
                return -1

    try:
        f.close()
    except IOError:
        print("Error: Can't close file" + f + ".")
        return -1

    return 0

def option():
    public_group=optparse.OptionParser()
    public_group.add_option("--top-dir", default=-1, help="specify top dir path")
    public_group.add_option("--suite-file", default=-1, help="specify suite file ")
    public_group.add_option("--suite-name", default=-1,help="specify suite name")
    public_group.add_option("--lattice", action="store_true",help="if you want to run run lattice with this script, add it in command")
    public_group.add_option("--radiant", action="store_true",help="if you want to run run Radiant with this script, add it in command")
    public_group.add_option("--check", action="store_true",help="if you want to run run check with this script, add it in command")
    public_group.add_option("--scan-cases", action="store_true",help="if you want to scan case resource results with this script, add it in command")
    public_group.add_option("--process", default=-1,help="specify process number")
    public_group.add_option("--options", help="specify options for the case running")
    public_group.add_option("--cmd-file", help="use the cmd in the file")
    public_group.add_option("--timeout", default=18000, help="specify timeout value in second during case running")
    public_group.add_option("--timeout-kill", default=7200, help="specify timeout value for old process running")
    public_group.add_option("--check-conf", default=-1, help="write auto.conf for cases under top-dir")
    opt,args=public_group.parse_args()
    return opt
def run_case(cmd,lock,max_process,result_log=''):
    lock.acquire()
    max_process.value = max_process.value + 1
    lock.release()
    time.sleep(3)
    pro_lines_temp = [cmd+'\n']
    process_stat_temp = 0
    if sys.platform[:3] != "win":
        cmd = "{ " + cmd + "; }"
    else:
       cmd = 'start /MIN '+cmd
       pass
    pipe2 = os.popen(cmd + " 2>&1", "r")
    for item in pipe2:
        pro_lines_temp.append(item.rstrip()+'\n')
    try:
        sts = pipe2.close()

        if sts >=1:
            process_stat_temp = sts
        if sts is None: process_stat_temp = 0
    except IOError:
        pro_lines_temp.append('In run_cmd can not run: '+cmd+'\n')
        process_stat_temp = 1
    time.sleep(5)

    lock.acquire()
    if result_log:
        file_hand = file(result_log,'a')
        file_hand.writelines(pro_lines_temp)
        file_hand.close()

    max_process.value = max_process.value - 1
    lock.release()

def run_kill_error():
    while True:
        kill_pop_window.kill_error_box()
        time.sleep(10)

def run_kill_longprocess(wait_times=20,timeout_kill=3600,debug=False,check_time=0):
    kill_log_name = os.path.abspath(os.getcwd()+'/temp/'+'kill_cmd_record.log')
    my_tst = kill_old_process.HandleExceptionProcess(wait_times,timeout_kill,check_time,debug,kill_log=kill_log_name)
    #my_tst = try_kill.HandleExceptionProcess(wait_times=10, wait_step=5, debug=True)
    my_tst.handle_process()

if __name__ == '__main__':

    max_process = Value('d',0)
    lock = Lock()
    check_again = ''
    check_report = ''
    if 1:#new way
        opt = option()
        top_dir = opt.top_dir
        set_value = opt.timeout
        suite_file = opt.suite_file
        suite_name = opt.suite_name
        all_command = opt.options
        if not top_dir:
            top_dir = get_cmd_value(all_command,'top-dir')
        if top_dir == -1:
            top_dir = os.getcwd()
            print('Warning: can not get top-dir in your command!!!\n\n\nLocal will be used')
            #sys.exit(-1)
        top_dir = os.path.abspath(top_dir)
        check_conf = opt.check_conf
        if check_conf != -1:
            if not os.path.isfile(check_conf):
                print('Error, can not find file:%s \n\n'%check_conf)
                sys.exit(-1)
        if suite_file and os.path.isfile(str(suite_file)):
            pass
        else:
            print('Warning: can not get suite file')
        if not all_command:
            all_command = ''
        if opt.cmd_file:
            if os.path.isfile(opt.cmd_file):
                pass
            else:
                print('Warning: Can not get file:%s'%opt.cmd_file)
            try:
                conf_options = get_conf_options(opt.cmd_file,False)
                signal_cmd_dict = conf_options.get('cmd',{})
                signal_cmd = signal_cmd_dict.get(suite_name,'')

                if not signal_cmd:
                    signal_cmd = signal_cmd_dict.get('all','')

                all_command = all_command + ' '+signal_cmd
            except:
                cmd_hand = file(opt.cmd_file).readlines()
                for signal_cmd in cmd_hand:
                    signal_cmd = signal_cmd.strip()
                    if signal_cmd:
                        all_command = all_command + ' '+signal_cmd
        try:
            set_value = int(set_value)
        except:
            set_value = 5*60*60


        if opt.lattice or opt.radiant:
            script_dir = os.path.dirname(__file__)
            if opt.lattice:
                run_lattice = os.path.join(script_dir,'..','..','bin','run_lattice.py')
            else:
                run_lattice = os.path.join(script_dir,'..','..','bin','run_diamondng.py')
            opt.lattice = 1
            run_lattice = os.path.abspath(run_lattice)
            if all_command.find(run_lattice)!= -1:
                pass
            else:
                all_command = used_python+' '+run_lattice+' '+ all_command
            if all_command.find('--top-dir')== -1:
                all_command = all_command+ ' --top-dir='+top_dir
            if suite_name!= -1:
                all_command = all_command + ' --check-rpt='+os.path.join(top_dir,suite_name+'.csv')
            else:
                all_command = all_command + ' --check-rpt='+os.path.join(top_dir,os.path.basename(top_dir)+'.csv')
            check_again = 1
            check_report = ' --check-rpt='+os.path.join(os.getcwd(),os.path.basename(top_dir)+'_'+str(suite_name)+'_auto.csv')
        if opt.check:
            script_dir = os.path.dirname(__file__)
            run_lattice = os.path.join(script_dir,'..','check','check.py')
            run_lattice = os.path.abspath(run_lattice)
            if all_command.find(run_lattice)!= -1:
                pass
            else:
                all_command = used_python+' '+run_lattice+' '+ all_command
                if suite_name!= -1:
                    all_command = all_command + ' --report='+os.path.join(top_dir,suite_name+'.csv')
                else:
                    all_command = all_command + ' --report='+os.path.join(top_dir,os.path.basename(top_dir)+'.csv')
        if opt.scan_cases:
            script_dir = os.path.dirname(__file__)
            run_scan = os.path.join(script_dir,'..','scan_report','bin','run_scan_lattice_step_general_case.py')
            run_scan = os.path.abspath(run_scan)
            if all_command.find(run_scan)!= -1:
                pass
            else:
                all_command = used_python+' '+run_scan+' '+ all_command + '  --default-list=1 '
        process_num = opt.process
        try:
            process_num = int(process_num)
        except:
            process_num = -1

    cases = select_cases(top_dir,suite_file,suite_name,opt.lattice,opt.scan_cases)
    #all_lines = get_suit_content(suite_file,suite_name)
    re_p = re.compile('\s')
    time_flag = str(time.ctime())
    time_flag = re.sub('[\s:]','_',time_flag)
    time_flag = re.sub('[a-z]','',time_flag)
    try:
        os.makedirs('temp')
    except:
        pass
    log_file = 'temp/result.log'
    new_lines_bat = 'new_'+os.path.basename(top_dir)+'_'+time_flag+'.bat'
    run_cmd = []
    file_hand = file('temp/'+new_lines_bat,'w')
    file_hand_check_file = os.path.join('temp',( os.path.basename(top_dir)+'_check_'+time_flag+'.bat'))
    file_hand_check = file(file_hand_check_file,'w')
    for l in cases:
        #cmd = 'python '+new_cmd+ ' '+all_command+' --design='+l   before
        l = l.strip()
        if check_conf != -1:
            write_stat = make_configure(check_conf, top_dir,case=l)
            if write_stat != 0:
                print('Error, can not write conf for all cases, Please check\n\n\n')
                sys.exit(-1)
        suite_name_list = suite_name.split('-')
        l = l.replace(suite_name,suite_name_list[0])

        cmd = all_command+' --design='+l

        #cmd = all_command+' --design='+l
        run_cmd.append(cmd)
        if check_again == 1:
            file_hand_check.write(cmd+check_report+' --check-only \n')
        file_hand.write(cmd+'\n')
    file_hand.close()
    file_hand_check.close()
    #kill_pop_window.kill_error_box()
    if platform.system().find('Win')!= -1:
        p_killer = Process(target=run_kill_error,args=())
        p_killer.start()
    p_process_killer = Process(target=run_kill_longprocess,args=(20,int(opt.timeout_kill)))
    p_process_killer.start()
    if process_num == -1:
        if cases == -1:
            pass
        else:
            for id1,cmd in enumerate(run_cmd):
                print_logs = []
                if 1: # used for process multi-process-lulti-machine
                    case_run_over = 0
                    if platform.system().find('Win')!= -1:
                        lock_hand = xFiles.lock_file('temp/'+'temp_lock_file.log')
                    run_over_file = 'temp/'+'run_over_'+new_lines_bat
                    if os.path.isfile(run_over_file):
                        run_over_lines = file(run_over_file).readlines()
                        for case_l in run_over_lines:
                            if case_l.find(cmd+'\n') != -1:
                                case_run_over = 1
                                break
                    if case_run_over == 1:
                        #run_cmd.remove(cmd)
                        pass
                    else:
                        run_over_file_hand = file(run_over_file,'a')
                        try:
                            machine_name = platform.uname()[1] + ' '
                        except:
                            machine_name = ' '
                        run_over_file_hand.write(machine_name+cmd+'\n')
                        run_over_file_hand.close()
                    if platform.system().find('Win')!= -1:
                        xFiles.unlock_file(lock_hand)
                        if case_run_over == 1:
                            continue

                print_logs.append('='*50)
                print_logs.append("|  "+"BQS Platform".center(50))
                print_logs.append('-'*50)
                t_flag = str(time.ctime())
                print_logs.append("|  "+"%-20s"%('Show_time')+'|'+ t_flag.center(30))
                print_logs.append('-'*50)
                print_logs.append( "|  "+"%-20s"%('Running ')+'|'+get_cmd_value(cmd,'design').replace(top_dir,'').strip('\\').strip('/').center(30))
                left_num = len(run_cmd)-id1 -1
                print_logs.append('-'*50)
                print_logs.append("|  "+"%-20s"%('Status(Finish/Total)')+'|'+( str(id1+1)+'/'+str(len(run_cmd))+' over in the suite').center(30))
                pro_lines_temp = []
                file_hand = file(log_file,'a')
                if sys.platform[:3] != "win":
                    cmd = "{ " + cmd + "; }"
                pipe2 = os.popen(cmd + " 2>&1", "r")
                #os.system(cmd)
                for item in pipe2:
                    pro_lines_temp.append(item.rstrip()+'\n')
                try:
                    sts = pipe2.close()
                    if sts >=1:
                        process_stat_temp = sts
                    if sts is None: process_stat_temp = 0
                except IOError:
                    pro_lines_temp.append('In run_cmd can not run: '+cmd+'\n')
                    process_stat_temp = 1
                file_hand.writelines(pro_lines_temp)
                file_hand.close()
                print_logs.append('='*50)
                print_logs.append('\n\n\n')
                for p_log in print_logs:
                    print(p_log)
            print('All has been run over!\n')
    else:
        if cases == -1:
            pass
        else:
            total_case_num = len(run_cmd)
            watch_dog_process=[]
            running_process = []
            running_cases = []
            flag_job_dir = get_cmd_value(all_command,'job-dir')
            if flag_job_dir == -1 or not flag_job_dir:
                flag_job_dir = top_dir
            new_lines_bat = os.path.basename(flag_job_dir)+'_'+str(suite_file)+'_'+str(suite_name)
            new_lines_bat = re.sub('\W','_',new_lines_bat)+'.txt'
            while 1:
                print_logs = ['\n\n']

                if run_cmd:
                    cmd = run_cmd[0]
                    lock.acquire()
                    now_value = max_process.value
                    lock.release()

                    '''
                    if you want to run it in serval process, this file will be useful
                    '''

                    if now_value < process_num:
                        if 1: # used for process multi-process-lulti-machine
                            case_run_over = 0
                            if platform.system().find('Win')!= -1:
                                lock_hand = xFiles.lock_file('temp/'+'temp_lock_file.log')
                            run_over_file = 'run_over_'+new_lines_bat
                            if os.path.isfile(run_over_file):
                                run_over_lines = file(run_over_file).readlines()
                                for case_l in run_over_lines:
                                    if case_l.find(cmd+'\n') != -1:
                                        case_run_over = 1
                                        break
                            if case_run_over == 1:
                                run_cmd.remove(cmd)
                                pass
                            else:
                                run_over_file_hand = file(run_over_file,'a')
                                try:
                                    machine_name = platform.uname()[1] + ' '
                                except:
                                    machine_name = ' '
                                run_over_file_hand.write(machine_name+cmd+'\n')
                                run_over_file_hand.close()
                            if platform.system().find('Win')!= -1:
                                xFiles.unlock_file(lock_hand)
                            if case_run_over == 1:
                                continue
                        #print '='*50
                        print_logs.append('='*50)
                        t_flag = str(time.ctime())
                        print_logs.append("|  "+"BQS Platform".center(50))
                        print_logs.append('-'*50)
                        t_flag = str(time.ctime())
                        print_logs.append("|  "+"%-20s"%('Show_time')+'|'+ t_flag.center(30))
                        #print 'Running: ',get_cmd_value(cmd,'design')
                        print_logs.append('-'*50)
                        run_over  = total_case_num -len(run_cmd)
                        print_logs.append("|  "+"%-20s"%('Status(Finish/Total)')+'|'+( str(run_over+1)+'/'+str(total_case_num)+' over in the suite').center(30))
                        print_logs.append('-'*50)
                        print_logs.append( "|  "+"%-20s"%('Running ')+'|'+(get_cmd_value(cmd,'design').replace(top_dir,'').strip('\\').strip('/')+'(Launch)').center(30))
                        running_cases.append(get_cmd_value(cmd,'design').replace(top_dir,'').strip('\\').strip('/')+'('+time.strftime("%H:%M:%S", time.localtime())+')')
                        p1 = Process(target=run_case,args=(cmd,lock,max_process,log_file))
                        p1.start()
                        p1_time = Timer(set_value,stop_process,[p1,lock,max_process,cmd])
                        p1_time.start()
                        watch_dog_process.append(p1_time)
                        running_process.append(p1)
                        watch_dog_process_t = []
                        running_process_t = []
                        running_cases_t = []
                        if len(running_process) > process_num:
                            for id1,s_r in enumerate(running_process):
                                if s_r.is_alive():
                                    running_process_t.append(s_r)
                                    watch_dog_process_t.append(watch_dog_process[id1])
                                    running_cases_t.append(running_cases[id1])
                                else:
                                    if watch_dog_process[id1].is_alive():
                                        to_stop_dog = watch_dog_process[id1]
                                        #watch_dog_process.remove(to_stop_dog)
                                        #print 'Cancel :',to_stop_dog,time.ctime()
                                        to_stop_dog.cancel()
                                        #running_cases.pop(id1)
                            watch_dog_process = watch_dog_process_t
                            running_process = running_process_t
                            running_cases = running_cases_t
                        run_cmd.remove(cmd)
                        for r_c in running_cases[:-1] :
                            print_logs.append( "|  "+"%-20s"%(' ')+'|'+(r_c.center(30)))
                        print_logs.append('='*50)
                        print_logs.append('\n\n\n')
                        for p_log in print_logs:
                            print(p_log)
                        time.sleep(10)
                    else:
                        t_flag = str(time.ctime())
                        run_over  = total_case_num -len(run_cmd)
                        time.sleep(10)
                        watch_dog_process_t = []
                        running_process_t = []
                        running_cases_t = []
                        if 1:
                            for id1,s_r in enumerate(running_process):
                                if s_r.is_alive():
                                    running_process_t.append(s_r)
                                    watch_dog_process_t.append(watch_dog_process[id1])
                                    running_cases_t.append(running_cases[id1])
                                else:
                                    if watch_dog_process[id1].is_alive():
                                        to_stop_dog = watch_dog_process[id1]
                                        #watch_dog_process.remove(to_stop_dog)
                                        #print 'Cancel :',to_stop_dog,time.ctime()
                                        to_stop_dog.cancel()
                                        #running_cases.pop(id1)
                            watch_dog_process = watch_dog_process_t
                            running_process = running_process_t
                            running_cases = running_cases_t
                        print_logs.append('='*50)
                        print_logs.append("|  "+"BQS Platform".center(50))
                        print_logs.append('-'*50)
                        print_logs.append("|  "+"%-20s"%('Show_time')+'|'+ t_flag.center(30))
                        print_logs.append('-'*50)
                        print_logs.append("|  "+"%-20s"%('Status(Finish/Total)')+'|'+( str(run_over)+'/'+str(total_case_num)+' over in the suite').center(30))
                        print_logs.append('-'*50)
                        try:
                            print_logs.append( "|  "+"%-20s"%('Running ')+'|'+(running_cases[0].center(30)))
                            for r_c in running_cases[1:] :
                                print_logs.append( "|  "+"%-20s"%(' ')+'|'+(r_c.center(30)))

                        except:
                            pass
                        print_logs.append('='*50)
                        for p_log in print_logs:
                            print(p_log)
                        time.sleep(10)
                else:
                    if max_process.value <= 0:
                        print('All run over')
                        for i in watch_dog_process:
                                #if i.is_alive():
                                i.cancel()
                                #print 'cancel a watch dog',time.ctime()
                        break
                    else:
                        t_flag = str(time.ctime())
                        left_num = max_process.value
                        watch_dog_process_t = []
                        running_process_t = []
                        running_cases_t = []
                        if 1:
                            for id1,s_r in enumerate(running_process):
                                if s_r.is_alive():
                                    running_process_t.append(s_r)
                                    watch_dog_process_t.append(watch_dog_process[id1])
                                    running_cases_t.append(running_cases[id1])
                                else:
                                    if watch_dog_process[id1].is_alive():
                                        to_stop_dog = watch_dog_process[id1]
                                        to_stop_dog.cancel()
                            watch_dog_process = watch_dog_process_t
                            running_process = running_process_t
                            running_cases = running_cases_t
                        print_logs.append('='*50)
                        print_logs.append("|  "+"BQS Platform".center(50))
                        print_logs.append('-'*50)
                        print_logs.append("|  "+"%-20s"%('Show_time')+'|'+ t_flag.center(30))
                        print_logs.append('-'*50)
                        try:
                            print_logs.append("|  "+"%-20s"%('Status(Finish/Total)')+'|'+( str(total_case_num-left_num)+'/'+str(total_case_num)+' over in the suite').center(30))
                            print_logs.append('-'*50)
                            print_logs.append( "|  "+"%-20s"%('Running ')+'|'+running_cases[0].center(30))
                            for r_c in running_cases[1:]:

                                print_logs.append( "|  "+"%-20s"%(' ')+'|'+(r_c.center(30)))
                        except:
                            pass
                        print_logs.append('='*50)
                        print_logs.append('\n\n\n\n')
                        for p_log in print_logs:
                            print(p_log)
                        time.sleep(10)
    if platform.system().find('Win')!= -1:
        while True:
            if p_killer.is_alive():
                p_killer.terminate()
            if p_killer.is_alive():
                pass
            else:
                break
            time.sleep(30)
            print('Waiting for stop kill pop thread,',time.ctime())
    for i in range(0,4):
            print(i)
            run_kill_longprocess(wait_times=1,timeout_kill=int(opt.timeout_kill),debug=False,check_time=3)
            print('Waiting for stop kill old process thread,',time.ctime())
    while 1:
        if p_process_killer.is_alive():
            p_process_killer.terminate()
        if p_process_killer.is_alive():
            pass
        else:
            break
        time.sleep(30)
        print('Waiting for stop kill old process thread: ',time.ctime())
    if check_again == 1:
        for l in file(file_hand_check_file).readlines():
            os.system(l)
    try:
        os.remove('temp_lock_file.log')
    except:
        pass