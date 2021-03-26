import os
import re
import sys
import time
ON_WIN = sys.platform.startswith("win")
if ON_WIN:
    import psutil


def get_status_output(cmd):
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

def get_lin_cwd(pid):
    p = re.compile("cwd\s+->\s+(.+)")
    ls_cwd = "ls -l /proc/%s/cwd" % pid
    sts, text = get_status_output(ls_cwd)
    if sts:
        return
    for item in text:
        m = p.search(item)
        if m:
            return m.group(1)

def get_current_user():
    try:
        import pwd
        # pwd is unix only
        return pwd.getpwuid(os.getuid())[0]
    except ImportError, e:
        import getpass
        return getpass.getuser()


class HandleExceptionProcess:
    def __init__(self, wait_times=20, wait_step=3600, check_time=0,debug=True,kill_log=''):
        self.wait_times = wait_times
        self.wait_step = wait_step
        self.debug = debug
        self.check_time = check_time
        self.kill_log = kill_log
        self.kill_name_list = ['par.exe','pnmainc.exe','pnmain.exe','mpartrce.exe','trce.exe','synthesis.exe','m_gen_lattice.exe','synplify_pro.exe','synbatch.exe']
        self.cmdline_search_list = ['python.* --design=','pnmainc\s','(^|\s)par\s','(^|\s)pnmain\s','(^|\s)mpartrce\s','(^|\s)m_generate_lattice\s','(^|\s)synpwrap\s','(^|\s)synplify_pro\s','synthesis -f']
        self.cmdline_search_list = [re.compile(item) for item in self.cmdline_search_list ]

    def handle_process(self):
    
        self.process_dict = dict()
        time_flag = 0
        while True:
            if self.find_stop_tags():
                break
            if not ON_WIN:
                self.create_process_dict()
                if self.debug:
                    print '/*' * 20
                    print "DEBUG: Monitoring Processes: "
                    for key, value in self.process_dict.items():
                        print key, value
                    print '/*' * 20
                self.process_on_dict()
            else:
                self.kill_diamind_process(self.wait_step)
            time_flag += 1
            if self.check_time != 0 and time_flag >= self.check_time:
                break
            time.sleep(self.wait_times)

    def find_stop_tags(self):
        """
        will stop the scripts in wait_step seconds.
        """
        # TODO: leave it empty or make a stop folder in the execute directory.
        return

    def create_process_dict(self):
        if ON_WIN:
            cur = self.create_win_process_dict()
        else:
            cur = self.create_lin_process_dict()

        tmp_dict = dict()
        for key, value in cur.items():
            ori_value = self.process_dict.get(key)
            if ori_value:
                tmp_dict[key] = [ori_value[0]+1, ori_value[1]]
            else:
                tmp_dict[key] = value
        self.process_dict = tmp_dict


    def create_win_process_dict(self):
        '''
            On win32, we don't use it now
        '''
        process_dict = dict()
        pid_list = psutil.get_pid_list()
        for pid in pid_list:
            try:
                p = psutil.Process(pid)
                _cwd = p.cwd()
                _cmdline = p.cmdline()
            except Exception:
                continue
            _cmdline = " ".join(_cmdline)
            if self.skip_yes(_cwd, _cmdline):
                continue
            key = "%s::%s::%s" % (pid, _cwd, _cmdline)
            process_dict[key] = [1, p]
        return process_dict

    def create_lin_process_dict(self):
        process_dict = dict()
        user_name = get_current_user()
        ps_cmd = 'ps -eo user,pid,command | grep "%s "' % user_name
        sts, text = get_status_output(ps_cmd)
        if sts:
            print "ERROR: Failed to run %s" % ps_cmd
            return process_dict
        for item in text:
            item_list = re.split("\s+", item)
            _user = item_list[0]
            if _user != user_name:  # sometimes the user_name is only the partial of the _user
                continue
            _pid = item_list[1]
            _cmdline = " ".join(item_list[2:])
            _cwd = get_lin_cwd(_pid)
            if not _cwd:
                continue # maybe the process finished
            if self.skip_yes(_cwd, _cmdline):
                continue
            key = "%s::%s::%s" % (_pid, _cwd, _cmdline)
            process_dict[key] = [1, _pid]
        return process_dict

    def skip_yes(self, _cwd, _cmdline):
        for re_item  in self.cmdline_search_list:
            if re_item.search( _cmdline ):
                if self.debug:
                    print "DEBUG: Monitoring %s::%s" % (_cwd, _cmdline)
                return
        return 1

    def process_on_dict(self):
        for key, value in self.process_dict.items():
            elapsed_number = value[0]
            try:
                wait_flag = self.wait_step/self.wait_times
                if wait_flag == 0:
                    wait_flag = 2
            except:
                wait_flag = 180
            if elapsed_number < wait_flag:
                continue
            # stop the process and remove it from the process_dict
            if ON_WIN:
                process_name = value[1]
                try:
                    process_name.terminate()
                    self.pop_and_record(key)
                except Exception:
                    pass
            else:
                kill_cmd = "kill -9 %s" % value[1]
                sts, text = get_status_output(kill_cmd)
                if sts:
                    if re.search("No\s+such", text[0]):
                        self.pop_and_record(key) # can pop it
                    else:
                        pass # can't kill the pid and do NOT pop it
                else:
                    self.pop_and_record(key)

    def pop_and_record(self, key):
        #print "Kill %s successfully" % key
        self.process_dict.pop(key)
        if self.kill_log:
            log_hand = file(self.kill_log,'a')
            log_hand.write(str(key).strip()+'\n')
            log_hand.close()


    
    def run(self,timesleep=30,overtime=3600):
    
        while 1:
            self.kill_diamind_process(overtime)
            time.sleep(30)
    def kill_diamind_process(self,overtime=3600):
    
        for p in psutil.pids():
            try:
                pp = psutil.Process(p)
                pp_name = pp.name()
                time_stamp = time.time() - pp.create_time()
                if time_stamp <overtime:
                    continue
                cmd_line = pp.cmdline()
                for i in self.kill_name_list:
                    if pp_name.find(i)!= -1:
                        
                        #print '-----------Warning, kill overtime command:%s'%(pp_name)
                        
                        if self.kill_log:
                            log_hand = file(self.kill_log,'a')
                            log_hand.write('AT '+pp.cwd()+' '+'kill'+' '+" ".join(cmd_line)+'\n')
                            log_hand.close()
                            log_hand = file( os.path.join(pp.cwd(),'BQS_kill.log') ,'a')
                            log_hand.write('Killing'+' '+" ".join(cmd_line)+'\n')
                            log_hand.close()
                        pp.kill()
                for id1,item in enumerate( self.cmdline_search_list):
                    if id1 == 0:
                        if time_stamp < overtime*3: # special process for python --design
                            continue
                    if item.search((" ".join(cmd_line)).strip()):
                        
                        #print '-----------Warning, kill overtime command:%s'%( " ".join(cmd_line) )
                        
                        if self.kill_log:
                            log_hand = file(self.kill_log,'a')
                            log_hand.write('Killing'+' '+" ".join(cmd_line)+'\n')
                            log_hand.close()
                            log_hand = file( os.path.join(pp.cwd(),'BQS_kill.log') ,'a')
                            log_hand.write('Killing'+' '+" ".join(cmd_line)+'\n')
                            log_hand.close()
                            
                        pp.kill()
            except psutil.AccessDenied:
                pass
            except:
                pass
                
if __name__ == '__main__':
    #run(30,3600)
    #kill_diamind_process()
    proc = HandleExceptionProcess(debug=True,kill_log='ff.log')
    proc.handle_process()
