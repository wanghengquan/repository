"""
1.  use glob module to get the golden file and compare file if * in it.
"""
#1: IN a design, there should be just one family with the only one synthesis
#2: There is no id
#3: Before you run this file, you have to make sure the pushbutton is done
#4: if --force is used, the ldf file will transfer to info file
#5: if not use --force and info file in the case directory, the info file will be used.
#6: if synthesis tool is lse, a flag file will be used for pushbutton
#7: self.case_list+self.suite file be used to run parallel, and the *_temp file will be
#   produced at that time
#   so, before you run it, please del the self.case_list_self.suite_lines and *_temp
#   and also, please run the update diamond xml file before.
#8: add default method check_flow if the conf file is not find
#9: add tag options in the scripts, the script will replace '*tag*' with tag vaue in the conf file
#10: add check_grep in the scripts, In the method, we will use regular expression to check
#11: Delete check IBS
import os
import re
import glob
import optparse
import platform
import sys
import time
from check_lib import check_sdf
from check_lib import compare_par
from check_lib.xConf import get_conf_options
if platform.system().find('Win')!= -1:
    try:
        from check_lib import xFiles
    except:
        pass

###########- Check Max/Min Skew number -###########
class TA:
    def __init__(self,top_dir='',design='',report_path='',report='check.csv',qas=False,tag='_scratch',rerun_path=os.getcwd(),
                        conf_file='',case_command='',lse_check=False,synp_check=False,map_check=False,partrce_check=False):
        self.init_top_dir = top_dir
        self.init_design = design
        self.init_report_path = report_path
        self.init_report=  report
        self.init_tag = tag
        self.qas = qas
        self.return_log = []
        self.init_rerun_path = rerun_path
        self.check_dict = dict(

                               check_lines=self.check_lines,
                               check_flow=self.check_flow,
                               check_synpro=self.check_synpro,
                               check_lse=self.check_lse,
                               check_map=self.check_map,
                               check_partrce=self.check_partrce,
                               check_block=self.check_block,
                               check_data = self.check_data,
                               check_multiline = self.check_multiline,
                               check_no = self.check_no,
                               check_grep = self.check_grep,
                               sim_check_block = self.sim_check_block,
                               check_sdf = self.check_sdf,
                               check_compare_par = self.check_compare_par,
                               check_file = self.check_file,
                               check_lut_reference = self.check_lut_reference,
                               check_clk_reference = self.check_clk_reference,
                               check_binary = self.check_binary
                               
                               )
        #parser = optparse.OptionParser()
        #self.opts, args = parser.parse_args()
        self.cr_note_flag = ''
        self.conf_file = conf_file
        self.init_lse_check = lse_check
        self.init_synp_check=synp_check
        self.init_map_check=map_check
        self.init_partrce_check=partrce_check
        self.init_case_command = case_command
        self.logic_result_check = ""  # used for logic in methods
        self.logic_result_check_dict = {}
        self.exception_find_flag = 0
        if not  self.conf_file:
            self.conf_file = ''
        self.lines_reference_0 = ['NA']*5 # used to store based info in check_lut_reference
        self.lines_reference_1 = ['NA']*4 # the first is for par flow, lut chekc and the second is for clk check
        self.lines_reference_2 = []
        self.wrte_reference_file = 0
    def parse_options(self):
        parser = optparse.OptionParser()
        parser.add_option("--top-dir", help="specify top working directory")
        parser.add_option("--design", help="specify design name")
        parser.add_option("--conf-file", help="specify configure file if you know")
        parser.add_option("--report-path", help="specify where you want to store the report")
        parser.add_option("--tag", default='_scratch', help="replace the tag in the conf file")
        #parser.add_option("--rerun", default='1', help="if value set as 1, the cmd will be rewrite to log")
        parser.add_option("--report", default="check.csv", help="specify report name, default is check.csv")
        parser.add_option("--rerun-path", default=os.getcwd(), help="specify the directory for the rerun.bat to be stored")
        
        parser.add_option("--lse-check", action="store_true", help="Just Check lse(create conf file)")
        parser.add_option("--synp-check", action="store_true",help="Just Check synplify(create conf file)")
        parser.add_option("--map-check", action="store_true", help="Just Check map(create conf file)")
        parser.add_option("--partrce-check",action="store_true",help="Just Check partrce(create conf file)")
        parser.add_option("--case-command", help="specify case command, create conf file according to the command")
        self.opts, args = parser.parse_args()
        #return opts
    def set_options(self):
        if  self.init_top_dir:
            self.top_dir = self.init_top_dir
            self.design = self.init_design
            self.report_path = self.init_report_path
            self.report = self.init_report
            self.tag = self.init_tag
            self.rerun_path = self.init_rerun_path
        else:
            self.parse_options()
            opts = self.opts
            if not opts.top_dir:
                self.top_dir = self.init_top_dir
            else:
                self.top_dir = os.path.abspath(opts.top_dir)
            self.top_dir = os.path.abspath(self.top_dir)
            self.design = opts.design
            if not self.design:
                self.design = self.init_design
            self.report_path = opts.report_path
            if not self.report_path:
                self.report_path = self.init_report_path
            self.report = opts.report
            self.tag = opts.tag
            self.rerun_path = opts.rerun_path
            self.conf_file = opts.conf_file
            if opts.lse_check:
                self.lse_check = opts.lse_check
            else:
                self.lse_check = self.init_lse_check
            if opts.synp_check:
                self.synp_check=opts.synp_check
            else:
                self.synp_check=self.init_synp_check
            if opts.map_check:
                self.map_check = opts.map_check
            else:
                self.map_check=self.init_map_check
            if opts.partrce_check:
                self.partrce_check=opts.partrce_check
            else:
                self.partrce_check=self.init_partrce_check
            if opts.case_command:
                self.case_command = opts.case_command
            else:
                self.case_command =self.init_case_command
        
        if 1:
            if self.report=='check.csv':
                self.report = self.init_report
            if not os.path.isdir(self.top_dir):
                print 'Error: can not find directory:%s'%self.top_dir
                self.return_log.append('Error: can not find directory:%s'%self.top_dir)
                return -1

            if self.report_path :
                self.report_path = os.path.abspath(self.report_path)
                if os.path.isdir(self.report_path):
                    pass
                else:
                    #self.report_path = os.path.abspath(self.report_path)
                    os.makedirs(self.report_path)
            else:
                self.report_path = self.top_dir
            if self.report == 'check.csv':
                c_time = '_'.join( re.split(r'[\s:]',time.ctime()) )
                self.report = os.path.basename(self.report_path)+'_'+c_time+'.csv'
                self.report = os.path.join(self.report_path,self.report)
            else:
                if not os.path.dirname(self.report):
                    self.report = os.path.join(self.report_path,self.report)
                else:
                    pass
            self.result = True
            self.Comments = ""
            self.area = ""
            self.type = ""
        return 1

    def get_designs(self):
        self.designs=[]
        if self.design:
            self.designs.append( os.path.join(self.top_dir,self.design) )

        else:
            for item in os.listdir(self.top_dir):
                if os.path.isdir(os.path.join(self.top_dir,item)):
                    self.designs.append(os.path.join(self.top_dir,item))
    def pre_process_conf(self,conf_file):
        if not os.path.isfile(conf_file):
            return -1
        all_lines = file(conf_file).readlines()
        new_lines = []
        for l in all_lines:
            l = l.replace('*tag*',self.tag)
            new_lines.append(l)
        file_hand = file(conf_file,'w')
        file_hand.writelines(new_lines)

    def pre_process_value(self,line):
        return line.replace('*tag*',self.tag)
    def process(self):
        return_v = self.set_options()
        if return_v == -1:
            return 1,"\n".join(self.return_log)
        self.result = "Pass"
        self.area = 'NA'
        self.type = 'NA'
        self.device_syn = 'NA'
        self.Comments = ''
        self.total_case_num = 0
        self.run_case_num = 0
        self.get_designs()
        if not self.designs:
            print("Error. No designs will be checked")
            self.return_log.append("Error. No designs will be checked")
            return 1,"\n".join(self.return_log)
        if 1:
            if 1:
                all_lines = []
                for design in self.designs:
                    print 'Begin check case:',design
                    print time.ctime()
                    self.check_it2(design)
                    #############################################################
                    if not self.logic_result_check and not self.exception_find_flag:
                        pass
                    else:
                        print self.logic_result_check_dict
                        self.logic_result_check = self.logic_result_check+" "
                        self.logic_result_check =self.logic_result_check.replace(" ","  ")
                        all_keys = re.split("[&& ||]",self.logic_result_check)
                        for key in all_keys:
                            key = key.strip()
                            if not key:
                                continue
                            result_value = self.logic_result_check_dict.get(key,"None")
                            
                            if result_value == "None":
                                self.result = False
                                print "Error format for logic_result"
                                self.return_log.append("Error format for logic_result")
                            else:
                                self.logic_result_check = re.sub(key+" ",str(result_value),self.logic_result_check)
                        try:
                            self.logic_result_check = self.logic_result_check.replace("||","or")
                            self.logic_result_check = self.logic_result_check.replace("&&","and")
                            #self.logic_result_check = re.sub("||","or",self.logic_result_check)
                            print self.logic_result_check
                            self.result = eval(self.logic_result_check.strip())
                        except:
                            self.result = False
                            print "Can not excute login result line"
                            self.return_log.append("Can not excute login result line")
                    print self.result
                    ###############################################################
                    design = os.path.abspath(design)
                    design = design.replace('\\','/')
                    self.top_dir1 = self.top_dir.replace('\\','/')
                    self.top_dir1 = self.top_dir1.rstrip('/')
                    line = self.area+','+self.type+','+design.replace(self.top_dir1+'/','')+','+str(self.device_syn)+','+str(self.result)+',"'+self.Comments+'"'
                    line = re.sub("\s+","",line.strip())+'\n'
                    lock_file1 = os.path.join(os.path.dirname(self.report),'temp_lock_file.log')
                    if platform.system().find('Win')!= -1:
                        lock_hand = xFiles.lock_file(lock_file1)
                    all_lines.append(line)
                    if platform.system().find('Win')!= -1:
                        xFiles.unlock_file(lock_hand)
                    self.run_case_num = self.run_case_num + 1
                    print 'End check data: ',time.ctime()
            lock_file1 = os.path.join(os.path.dirname(self.report),'temp_lock_file.log')
            if platform.system().find('Win')!= -1:
                lock_hand = xFiles.lock_file(lock_file1)
            if not os.path.isfile(self.report):
                file_temp_hand = file(self.report,'w')
                file_temp_hand.write("Area,Type,Case, Device_syn,Result,Comments\n")
                file_temp_hand.writelines(all_lines)
                file_temp_hand.close()
            else:
                old_lines = file(self.report).readlines()
                file_temp_hand = file(self.report,'w')
                for l in all_lines:
                    if l in old_lines:
                        pass
                    else:
                        old_lines = old_lines+[l]
                file_temp_hand.writelines(old_lines)
                file_temp_hand.close()
            self.sumary()
            if platform.system().find('Win')!= -1:
                xFiles.unlock_file(lock_hand)
            if self.result == 'Pass' or self.result == True:
                return 0,"\n".join(self.return_log)
            else:
                if self.cr_note_flag:
                    if not self.exception_find_flag:
                        for log in ["###CR_NOTE_BEGIN###",self.cr_note_flag,"###CR_NOTE_END###"]:
                            print log
                        return 2,"\n".join(self.return_log)
                    else:
                        return 1,"\n".join(self.return_log)
                else:
                    return 1,"\n".join(self.return_log)

    def  special_sort_write(self,file_name,all_lines):
        '''
            This function special used for write reference_file for lv Jun.  we need to sort file.
            Pay special attentio to the file format. In some line, the first  9 items may be a space
            The first line is title
        '''
        title_line = all_lines[0]
        new_lines = []
        temp_format = []
        for line in all_lines[1:]:
            line_list = line.split(",")
            if not line_list[0] and (not temp_format):
                print 'Error: reference_file format error'
                return
            if line_list[0]:
                temp_format = line_list[:9]
            else:
                line_list = temp_format+line_list[9:]
            new_lines.append(",".join(line_list))
        new_lines.sort()
        file_hand = file(file_name,"w")
        file_hand.write(title_line)
        
        pre_temp = []
        for line in new_lines:
            line_list = line.split(",")
            if not pre_temp:
                file_hand.write(line)
                pre_temp = line_list[:9]
            else:
                if pre_temp == line_list[:9]:
                    temp_line = ","*9+",".join(line_list[9:])
                    file_hand.write(temp_line)
                else:
                    file_hand.write(line)
                    pre_temp = line_list[:9]
        file_hand.close()
                
    def sumary(self):
        if self.wrte_reference_file:
            if not self.lines_reference_2:
                self.lines_reference_2.append(['NA']*7)
            reference_file = os.path.join(os.path.dirname(self.report),"reference_report.csv")
            if os.path.isfile(reference_file): ## at here, we need to sort the file with added lines.
                all_lines = file(reference_file).readlines()
                temp_line = ",".join(self.lines_reference_0+self.lines_reference_1)
                for item_id,item in enumerate(self.lines_reference_2):
                    new_temp_line = temp_line+","+",".join(item)+"\n"
                    all_lines.append(new_temp_line)
                self.special_sort_write(reference_file,all_lines)   
            else:
                file_hand = file(reference_file,"w")
                file_hand.write("ID,Project,Entry,Device,PAR_flow,Exp_Res,Act_Res,Diff,Result,LpfClock,Lpf_Fmax,TwrClock,Twr_Exp_Fmax,Twr_Act_Fmax,Diff,Result\n")
                temp_line = ",".join(self.lines_reference_0+self.lines_reference_1)
                for item_id,item in enumerate(self.lines_reference_2):
                    if item_id == 0:
                        new_temp_line = temp_line+","+",".join(item)+"\n"
                    else:
                        new_temp_line = ","*len( self.lines_reference_0+self.lines_reference_1)+",".join(item)+"\n"
                    file_hand.write(new_temp_line)
                file_hand.close()
            print 0, self.lines_reference_0
            print 1,self.lines_reference_1
            print 2,self.lines_reference_2
        
        report_hand = file(self.report,'r')
        line = report_hand.readline()
        summary_dic = {}
        id1 = 0
        lines = []
        ingore = 0
        run_case_num_record = 0
        while line:
            line = line.strip()
            if not line:
                line = report_hand.readline()
                continue
            if id1 == 0:
                lines.append(line+'\n')
                id1 = 1
            elif line.startswith('SUM:'):
                ingore = 1

            elif line.startswith(',') and ingore==1:
                pass
            else:
                lines.append(line+'\n')
                line = line.split(',')
                try:
                    key = line[1]
                    res = line[4]
                except:
                    line = report_hand.readline()
                    continue
                if key in summary_dic.keys():
                    summary_dic[key][0] = summary_dic[key][0] + 1
                    if res == 'True':
                        summary_dic[key][1] = summary_dic[key][1] + 1
                    else:
                        summary_dic[key][2] = summary_dic[key][2] + 1
                else:
                    if res == 'True':
                        summary_dic[key] = [1,1,0]
                    else:
                        summary_dic[key] = [1,0,1]
                    #summary_dic[key] = 1
                run_case_num_record = run_case_num_record +1
            line = report_hand.readline()
        report_hand.close()
        append_lines = []
        line = '\nSUM:,Run No.,TYPE,TOTAL,PASS,FAIL,TIME\n'
        append_lines.append(line)
        for id1,key in  enumerate( summary_dic.keys()):
            if id1 == 0:
                #line = ',%s,%s,%s,%s,%s,%s\n'%(self.total_case_num,self.run_case_num,key,summary_dic[key][0],summary_dic[key][1],summary_dic[key][2])
                line = ',%s,%s,%s,%s,%s,%s\n'%(run_case_num_record,key,summary_dic[key][0],summary_dic[key][1],summary_dic[key][2],str(time.ctime()))
            else:
                line = ',,%s,%s,%s,%s,%s\n'%(key,summary_dic[key][0],summary_dic[key][1],summary_dic[key][2],str(time.ctime()))
            append_lines.append(line)
        report_hand = file(self.report,'w')
        report_hand.writelines(lines)
        report_hand.writelines(append_lines)
        report_hand.close()

    def check_it2(self, design_path):
        #line = self.area+','+self.type+','+design+','+str(self.device_syn)+','+str(self.result)+','+self.Comments
        self.area = 'NA'
        self.type = 'NA'
        self.device_syn = 'NA'
        self.result = True
        self.Comments = ''
        self.design_path = design_path
        self.cr_note_flag = ''
        conf_files = glob.glob(os.path.join(design_path, "*.conf"))
        #if not conf_files and self.qas:
        #    self.result = False
        #    self.Comments =  'No conf in case'
        #    return
        #print conf_files
        #print self.qas
        #print '---------------------------------------'
        #if not conf_files and (not self.qas):
        if not conf_files and not self.conf_file :
            
            print("Warrning. Not found any configure settings files for TA")
            self.return_log.append("Warrning. Not found any configure settings files for TA")
            '''
              Add default conf file to the case.
            '''
            
            self.return_log.append(design_path)
            conf_f = os.path.abspath(design_path)+r"/auto.conf"
            #trunk_cmd = " ".join(sys.argv)
            trunk_cmd = self.case_command
            if trunk_cmd.find('--run-par-trce')!= -1 or self.partrce_check:
                '''
                    write partrce conf
                '''
                conf_file_h = open(conf_f,'w')
                conf_file_h.write('[configuration information]\n')
                conf_file_h.write('area = area_auto\n')
                conf_file_h.write('type = area_auto\n')
                conf_file_h.write('[method]\n')
                conf_file_h.write('check_partrce = 1\n')
                conf_file_h.write('[check_partrce]\n')
                write_file = 0
                try:
                    for all_dir in os.listdir( os.path.abspath(design_path+'/'+self.tag) ):
                        if all_dir.startswith('Target') and os.path.isdir(os.path.join(design_path,self.tag,all_dir)):
                            conf_file_h.write('file=%s/*/*/*.twr\n'%self.tag)
                            write_file = 1
                            break
                except:
                    conf_file_h.write('file=%s/*/*.twr\n'%self.tag)
                    write_file = 1
                if write_file == 0:
                    conf_file_h.write('file=%s/*/*.twr\n'%self.tag)
                conf_file_h.close()
                conf_files = os.path.join(design_path, "auto.conf")
            elif  self.map_check or  trunk_cmd.find('--run-map ') != -1 or trunk_cmd.find('--till-map') != -1 or trunk_cmd.find('--run-map-trce') != -1 or trunk_cmd.endswith('--run-map'):
                '''
                    write map conf
                '''
                conf_file_h = open(conf_f,'w')
                conf_file_h.write('[configuration information]\n')
                conf_file_h.write('area = area_auto\n')
                conf_file_h.write('type = area_auto\n')
                conf_file_h.write('[method]\n')
                conf_file_h.write('check_map = 1\n')
                conf_file_h.write('[check_map]\n')
                write_file = 0
                try:
                    for all_dir in os.listdir( os.path.abspath(design_path+'/'+self.tag) ):
                        if all_dir.startswith('Target') and os.path.isdir(os.path.join(design_path,self.tag,all_dir)):
                            conf_file_h.write('file=%s/*/*/*.mrp\n'%self.tag)
                            write_file = 1
                            break
                except:
                    conf_file_h.write('file=%s/*/*.mrp\n'%self.tag)
                    write_file = 1
                if write_file == 0:
                    conf_file_h.write('file=%s/*/*.mrp\n'%self.tag)
                conf_file_h.close()
                conf_files = os.path.join(design_path, "auto.conf")
            elif self.synp_check or self.lse_check or trunk_cmd.find('--synthesis-only') != -1:
                if  self.lse_check or trunk_cmd.find('--synthesis=lse') != -1:
                    '''
                        write lse conf
                    '''
                    conf_file_h = open(conf_f,'w')
                    conf_file_h.write('[configuration information]\n')
                    conf_file_h.write('area = area_auto\n')
                    conf_file_h.write('type = area_auto\n')
                    conf_file_h.write('[method]\n')
                    conf_file_h.write('check_lse = 1\n')
                    conf_file_h.write('[check_lse]\n')
                    write_file = 0
                    if 1:
                        conf_file_h.write('file=%s/*/synthesis.log\n'%self.tag)
                        write_file = 1
                    if write_file == 0:
                        conf_file_h.write('file=%s/*/synthesis.log\n'%self.tag)
                    conf_file_h.close()
                    conf_files = os.path.join(design_path, "auto.conf")
                else:
                    '''
                        write synpro conf
                    '''
                    conf_file_h = open(conf_f,'w')
                    conf_file_h.write('[configuration information]\n')
                    conf_file_h.write('area = area_auto\n')
                    conf_file_h.write('type = area_auto\n')
                    conf_file_h.write('[method]\n')
                    conf_file_h.write('check_synpro = 1\n')
                    conf_file_h.write('[check_synpro]\n')
                    write_file = 0
                    if 1:
                        conf_file_h.write('file=%s/*/*.srr\n'%self.tag)
                        write_file = 1
                    if write_file == 0:
                        conf_file_h.write('file=%s/*/*.srr\n'%self.tag)
                    conf_file_h.close()
                    conf_files = os.path.join(design_path, "auto.conf")
            else:
                '''
                    write par conf
                '''
                conf_file_h = open(conf_f,'w')
                conf_file_h.write('[configuration information]\n')
                conf_file_h.write('area = area_auto\n')
                conf_file_h.write('type = area_auto\n')
                conf_file_h.write('[method]\n')
                conf_file_h.write('check_flow = 1\n')
                conf_file_h.write('[check_flow]\n')
                write_file = 0
                try:
                    for all_dir in os.listdir( os.path.abspath(design_path+'/'+self.tag) ):
                        if all_dir.startswith('Target') and os.path.isdir(os.path.join(design_path,self.tag,all_dir)):
                            conf_file_h.write('file=%s/*/*/*.par\n'%self.tag)
                            write_file = 1
                            break
                except:
                    conf_file_h.write('file=%s/*/*.par\n'%self.tag)
                    write_file = 1
                if write_file == 0:
                    conf_file_h.write('file=%s/*/*.par\n'%self.tag)
                conf_file_h.close()
                conf_files = os.path.join(design_path, "auto.conf")
        else:
           if conf_files and (not self.conf_file):
                conf_files = conf_files[0]
           elif conf_files and self.conf_file:
                used_confs = []
                conf_file_list = self.conf_file.split(',')
                for conf_f in conf_files:
                    for conf_file_l in conf_file_list:
                        if os.path.basename(conf_f) == conf_file_l+'.conf':
                            used_confs.append(conf_f)
                if not used_confs:
                    print 'Can not find any configure file'
                    self.Comments = 'Can not find any configure file'
                    self.result = False
                    return
                else:
                    conf_files = used_confs
           else:
                self.Comments = 'Can not find any configure file'
                self.result = False
                return
        if type(conf_files) == str:
            conf_files = [conf_files]
        for conf_file in conf_files:
            self.pre_process_conf(conf_file)
            self.conf_options = get_conf_options(conf_file)
            method_dict = self.conf_options.get("method")
            conf_inf = {}
            self.old_comments = ''
            try:
                conf_inf = self.conf_options.get("configuration information")
            except:
                pass
            for item ,value in conf_inf.items():
                if item =="area":
                    self.area = value
                elif item == "type":
                    self.type = value
                elif item == "cr_note":
                    self.Comments = value
                    if value.strip():
                        self.cr_note_flag = value.strip()
                elif item == "logic_result":
                    self.logic_result_check = value
                else:
                    pass
            for item, value in method_dict.items():
                if value == "1":
                    if re.search("check_lines",item):
                        self.old_item = item
                        item = "check_lines"
                    elif re.search("check_data",item):
                        self.old_item = item
                        item = "check_data"
                    elif re.search("check_multiline",item):
                        self.old_item = item
                        item = "check_multiline"
                    elif re.search("sim_check_block",item):
                        self.old_item = item
                        item = "sim_check_block"
                    elif re.search("check_block",item):
                        self.old_item = item
                        item = "check_block"
                    elif re.search("check_no",item):
                        self.old_item = item
                        item = "check_no"
                    elif re.search("check_grep",item):
                        self.old_item = item
                        item = "check_grep"
                    elif re.search('check_sdf',item):
                        self.old_item = item
                        item="check_sdf"
                    elif re.search('check_compare_par',item):
                        self.old_item = item
                        item="check_compare_par"
                        
                    elif re.search('check_synpro',item):
                        self.old_item = item
                        item="check_synpro"
                    elif re.search('check_lse',item):
                        self.old_item = item
                        item="check_lse"
                    elif re.search('check_map',item):
                        self.old_item = item
                        item="check_map"
                    elif re.search('check_partrce',item):
                        self.old_item = item
                        item="check_partrce"
                    elif re.search('check_binary',item):
                        self.old_item = item
                        item="check_binary"
                    elif re.search('check_clk_reference',item):
                        self.old_item = item
                        item="check_clk_reference"
                    elif re.search('check_file',item):
                        self.old_item = item
                        item="check_file"
                    elif re.search('check_lut_reference',item):
                        self.old_item = item
                        item="check_lut_reference"
                        self.wrte_reference_file = 1
                    else:
                        self.old_item = item
                    self.logic_result_check_dict[self.old_item] = True
                    ####
                    self.function_name = item+" "+self.old_item
                    func = self.check_dict.get(item, "")
                    if not func:
                        print("Error. Unknown method name: %s" % item)
                        self.return_log.append("Error. Unknown method name: %s" % item)
                        self.Comments = 'Unknown method name: %s"' % item
                        self.result = False
                        self.Comments = self.Comments+' : '+os.path.basename(conf_file)+"\n"
                        continue
                    try:
                        func()
                        if not self.result:
                            if self.Comments != self.old_comments:
                                self.Comments = self.Comments+' : '+os.path.basename(conf_file)+"\n"
                                self.old_comments = self.Comments
                            else:
                                pass
                    except:
                        print("Error. Can not exucte  method name: %s" % item)
                        self.return_log.append("Error. Can not exucte method: %s" % item)
                        self.Comments = 'Can not exucte method : %s, Please double check your conf file"' % item
                        self.result = False

    def check_block(self, sim_type=False):
        #######################################
        #pass  #this is the old
        #######################################
        if sim_type:
            print "Come Into the sim_check_block"
            #self.return_log.append("Come Into the sim_check_block")
        else:
            print "Come Into the ",self.old_item
            #self.return_log.append("Come Into the "+self.old_item)
        method_dict = self.conf_options.get(self.old_item)
        title = ""
        compare_file = ""
        golden_file  = ""
        check_lines = []
        keyss = method_dict.keys()
        keyss.sort()
        temp_cr_note = ""
        for item  in keyss:
            value = method_dict[item]
            if item == "title":
                title = value
            elif item == "compare_file":
                compare_file =  value
            elif item == "cr_note":
                self.cr_note_flag += value
                temp_cr_note = value
            else:
                golden_file = value
        golden_file  = os.path.join(self.design_path,golden_file)
        used = '00'
        compare_file = os.path.join(self.design_path,compare_file)
        # ------------------ use glob to get golden file and compare file
        def _get_file(file_string):
            if os.path.isfile(file_string):
                return file_string

            if re.search("\*", file_string):
                file_list = glob.glob(file_string)
                if file_list:
                    file_string = file_list[0]
            return file_string

        golden_file = _get_file(golden_file)
        compare_file = _get_file(compare_file)

        try:
            file_hand = file(golden_file,"r")
        except:
            self.result = False
            self.logic_result_check_dict[self.old_item] = False
            self.Comments = self.Comments+" " + "In %s, the golden file not exist"%self.old_item
            print 'In %s:'%self.old_item,'Fail'
            return
        for item in file_hand.readlines():
            if sim_type:
                item = item.replace('x', '0')
                item = item.replace('X', '0')
            item = item.strip()
            #if not item:
            #    continue
            #### Jason need to move
            check_lines.append(item)
        file_hand.close()
        try:
            compare_file = glob.glob(compare_file)
            compare_file = compare_file[0]
            file_hand = file(compare_file,"r")
        except:
            self.result = False
            self.logic_result_check_dict[self.old_item] = False
            self.Comments = self.Comments+" ;" + "In %s, the compare file not exist"%self.old_item
            return
        #print '*'*20,file_hand
        result_single = "Fail"
        check_line_compile = [item for item in check_lines]
        line = file_hand.readline()
        while True:
            if not line:
                break
            if sim_type:
                line = line.replace('x', '0')
                line = line.replace('X', '0')
                line = line.replace('Z', '0')
                line = line.replace('z', '0')
                line = line.replace('?', '0')
            line = line.strip()
            
            for id2,item in enumerate(check_line_compile):
                    #if not line:
                    #    break
                    #### Jason need to remove this line, as he need to keep the blank lines in the gloden file
                    if sim_type:
                        line = line.replace('x', '0')
                        line = line.replace('X', '0')
                        line = line.replace('Z', '0')
                        line = line.replace('z', '0')
                        line = line.replace('?', '0')
                        item = item.replace('x', '0')
                        item = item.replace('X', '0')
                        item = item.replace('Z', '0')
                        item = item.replace('z', '0')
                        item = item.replace('?', '0')
                    line = line.strip()
                    if line.find(item)!= -1:
                        #if item == check_line_compile[-1] and id2==len(check_line_compile)-1:
                        if id2==len(check_line_compile)-1:
                            result_single = "pass"
                            break
                        else:
                            try:
                                line = file_hand.readline()
                                line = line.strip()
                            except:
                                break
                    else:
                        #print line
                        #print item
                        result_single = "Fail"
                        #raw_input()
                        break
            if result_single == "pass":
                break
            else:
                try:
                    line = file_hand.readline()
                except:
                    break
        #print self.result
        print 'In %s:'%self.old_item,result_single
        if result_single == "Pass" and self.result:
           pass
        elif result_single == "Fail":
            if temp_cr_note:
                self.result = True
            else:
                self.result = False
                self.Comments = self.Comments+" ;" + self.old_item+" Fail"
                self.logic_result_check_dict[self.old_item] = False
            #self.device_s = self.device[]
        else:
            pass
        file_hand.close()
    def check_lines(self):
        #######################################
        #pass  #this is the old
        #######################################
        print "Come Into the %s"%self.old_item
        #self.return_log.append("Come Into the "+self.old_item)
        method_dict = self.conf_options.get(self.old_item)
        title = ""
        file_name = ""
        time = 1
        check_lines = []
        check_lines_dic = {}
        check_lines_num = []
        keyss = method_dict.keys()
        keyss.sort()
        file_name = ''
        file_name_log = ''
        temp_cr_note = ""
        for item  in keyss:
            value = method_dict[item]
            if item == "title":
                title = value
            elif item == "cr_note":
                temp_cr_note = value
                self.cr_note_flag += value
            elif item == "file":
                file_name =  value
                #p = re.compile('<id>')
                used = '00'
                file_name_log = file_name
                file_name = os.path.join(self.design_path,file_name)
            elif item == "times":
                try:
                    time = int(value)
                except:
                    pass
            else:
                try:
                    num = int( (item.split("_")[1]).strip() )
                except:
                    print "The format of your configure file is wrong"
                    self.return_log.append("The format of your configure file is wrong")
                    self.result = False
                    self.Comments = self.Comments + " # " + item+ 'format is wrong'
                    print 'In %s:'%self.old_item,'Fail'
                    self.exception_find_flag = 1
                    self.logic_result_check_dict[self.old_item] = False
                    return
                check_lines_num.append(num)
                value = value.replace(r'\;',';')
                check_lines_dic[num]= value
        check_file = file_name
        try:
            file_name = glob.glob(file_name)
            file_name = file_name[0]
            file_hand = file(file_name,"r")
        except:
            self.result = False
            self.Comments = self.Comments+" ;" + "In %s, the file %s not exist"%(self.old_item,file_name_log)
            print 'In %s:'%self.old_item,'Fail'
            self.exception_find_flag = 1
            self.logic_result_check_dict[self.old_item] = False
            return
        result_single = "Fail"
        check_lines_num.sort()
        for item in check_lines_num:
            line_use = check_lines_dic[item]
            check_lines.append(line_use)
        check_line_compile = [item for item in check_lines]
        check_start = True
        line = file_hand.readline()
        line_time = 0
        while line:
            for id2,item in enumerate(check_line_compile):
                    if line.find(item)!= -1 and id2 == 0:
                        line_time = line_time + 1
                    if line_time == time:
                        pass
                    else:
                        break
                    if line.find(item)!= -1:
                        if item == check_line_compile[-1]:
                            result_single = "pass"
                            break
                        else:
                            try:
                                readline_num = check_lines_num[id2+1] - check_lines_num[id2]
                                for i in range(0,readline_num):
                                    line = file_hand.readline()
                            except:
                                break
                    else:
                        break
            if result_single == "pass":
                break
            else:
                try:
                    line = file_hand.readline()
                except:
                    break
        #print self.result
        print 'In %s:'%self.old_item,result_single
        if result_single == "Pass" and self.result:
           pass
        elif result_single == "Fail":
            if temp_cr_note:
                self.result = True
            else:
                self.result = False
                self.Comments = self.Comments+" ;" + self.old_item
                self.logic_result_check_dict[self.old_item] = False
        else:
            pass
        #qaTools.append_file(self.report, "%s, %s, %s" % (self.old_item, self._design, result))
    def check_synpro(self):
        '''
            1. Synthesis: synplify pro
            search file:<implemetation dir>/<title_name>_<imple_name>.srr
            criteria 0: find this file
            criteria 1: cannot find '@E' at the beginning of line
            criteria 2: must find string "Mapper successful" at the bottom of report file
        '''
        print "Come Into the %s"%self.old_item
        #self.return_log.append("Come Into the "+self.old_item)
        file_name = ""
        method_dict = self.conf_options.get("check_synpro")
        keyss = method_dict.keys()
        keyss.sort()
        file_name_log=''
        temp_cr_note = ""
        for item  in keyss:
            value = method_dict[item]
            if item == "file":
                file_name =  value
                #p = re.compile('<id>')
                #file_name = p.sub(self.id+'_scratch',file_name)
                file_name_log = file_name
                file_name = os.path.join(self.design_path,file_name)
            elif item == "cr_note":
                temp_cr_note = value
                self.cr_note_flag += value

            else:
                pass
        check_file = file_name
        try:
            file_name = glob.glob(file_name)
            file_name = file_name[0]
            file_hand = file(file_name,"r")
        except:
            self.result = False
            self.Comments = self.Comments+" " + "In %s, the file %s not exist"%(self.old_item,file_name_log)
            print 'In %s:'%self.old_item,'Fail'
            self.logic_result_check_dict[self.old_item] = False
            return
        #print file_name
        result_single = "Fail"
        check_lines = 'Mapper successful'
        line = file_hand.readline()
        while line:
            line = line.strip()
            if line.startswith('@E:'):
                result_single = "Fail"
                break
            if line.find(check_lines)!= -1:
                result_single = "Pass"
                break
            else:
                try:
                    line = file_hand.readline()
                except:
                    break
        #print self.result
        print 'In %s:'%self.old_item,result_single
        if result_single == "Pass" and self.result:
           pass
        elif result_single == "Fail":
            if not temp_cr_note:
                self.result = False
                self.Comments = self.Comments+" ;" + 'check_synpro'
                self.logic_result_check_dict[self.old_item] = False
        else:
            pass
    def check_lse(self):
        '''
            search file:<implemetation dir>/synthesis.log
            criteria 0: find this file
            criteria 1: cannot find 'ERROR' at the beginning of line
            criteria 2: must find string "Elapsed CPU time" at the bottom of report file


        '''
        print "Come Into the %s"%self.old_item
        #self.return_log.append("Come Into the "+self.old_item)
        file_name = ""
        method_dict = self.conf_options.get("check_lse")
        keyss = method_dict.keys()
        keyss.sort()
        file_name_log=''
        temp_cr_note = ""
        for item  in keyss:
            value = method_dict[item]
            if item == "file":
                file_name =  value
                #p = re.compile('<id>')
                #file_name = p.sub(self.id+'_scratch',file_name)
                file_name_log = file_name
                file_name = os.path.join(self.design_path,file_name)
            elif item == "cr_note":
                temp_cr_note = value
                self.cr_note_flag += value

            else:
                pass
        check_file = file_name
        try:
            file_name = glob.glob(file_name)
            file_name = file_name[0]
            file_hand = file(file_name,"r")
        except:
            self.result = False
            self.Comments = self.Comments+" ;" + "In %s, the file %s not exist"%(self.old_item,file_name_log)
            print 'In %s:'%self.old_item,'Fail'
            self.exception_find_flag = 1
            self.logic_result_check_dict[self.old_item] = False
            return
        #print file_name
        result_single = "Fail"
        check_lines = 'Elapsed CPU time'
        line = file_hand.readline()
        while line:
            line = line.strip()
            if line.startswith('ERROR'):
                result_single = "Fail"
                break
            if line.find(check_lines)!= -1:
                result_single = "Pass"
                break
            else:
                try:
                    line = file_hand.readline()
                except:
                    break
        #print self.result
        print 'In %s:'%self.old_item,result_single
        if result_single == "Pass" and self.result:
           pass
        elif result_single == "Fail":
            if not temp_cr_note:
                self.result = False
                self.Comments = self.Comments+" ;" + 'check_lse'
                self.logic_result_check_dict[self.old_item] = False
        else:
            pass
    def check_map(self):
        '''
            search file:<implemetation dir>/<title_name>_<imple_name>.mrp
            criteria 0: find this file
            criteria 1: cannot find 'ERROR' at the beginning of line
            criteria 2: must find string "Peak Memory Usage" at the bottom of report file

        '''
        print "Come Into the %s"%self.old_item
        #self.return_log.append("Come Into the "+self.old_item)
        file_name = ""
        method_dict = self.conf_options.get("check_map")
        keyss = method_dict.keys()
        keyss.sort()
        file_name_log=''
        temp_cr_note = ""
        for item  in keyss:
            value = method_dict[item]
            if item == "file":
                file_name =  value
                #p = re.compile('<id>')
                #file_name = p.sub(self.id+'_scratch',file_name)
                file_name_log = file_name
                file_name = os.path.join(self.design_path,file_name)
            elif item == "cr_note":
                temp_cr_note = value
                self.cr_note_flag += value
            else:
                pass
        check_file = file_name
        try:
            file_name = glob.glob(file_name)
            file_name = file_name[0]
            file_hand = file(file_name,"r")
        except:
            self.result = False
            self.Comments = self.Comments+" ;" + "In %s, the file %s not exist"%(self.old_item,file_name_log)
            print 'In %s:'%self.old_item,'Fail'
            self.exception_find_flag = 1
            self.logic_result_check_dict[self.old_item] = False
            return
        #print file_name
        result_single = "Fail"
        check_lines = 'Peak Memory Usage'
        line = file_hand.readline()
        while line:
            line = line.strip()
            if line.startswith('ERROR'):
                result_single = "Fail"
                break
            if line.find(check_lines)!= -1:
                result_single = "Pass"
                break
            else:
                try:
                    line = file_hand.readline()
                except:
                    break
        #print self.result
        print 'In %s:'%self.old_item,result_single
        if result_single == "Pass" and self.result:
           pass
        elif result_single == "Fail":
            if not temp_cr_note:
                self.result = False
                self.Comments = self.Comments+"; " + 'check_map'
                self.logic_result_check_dict[self.old_item] = False
        else:
            pass
    def check_partrce(self):
        '''
            search file:<implemetation dir>/<title_name>_<imple_name>.twr
            criteria 0: find this file
            criteria 1: must find string "Cumulative negative slack" at the bottom of report file


        '''
        print "Come Into the %s"%self.old_item
        #self.return_log.append("Come Into the "+self.old_item)
        file_name = ""
        method_dict = self.conf_options.get("check_partrce")
        keyss = method_dict.keys()
        keyss.sort()
        file_name_log=''
        temp_cr_note = ""
        for item  in keyss:
            value = method_dict[item]
            if item == "file":
                file_name =  value
                #p = re.compile('<id>')
                #file_name = p.sub(self.id+'_scratch',file_name)
                file_name_log = file_name
                file_name = os.path.join(self.design_path,file_name)
            elif item == "cr_note":
                temp_cr_note = value
                self.cr_note_flag += value
            else:
                pass
        check_file = file_name
        try:
            file_name = self.get_file_except_lse(file_name)
            file_name = file_name[0]
            file_hand = file(file_name,"r")
        except:
            self.result = False
            self.Comments = self.Comments+" ;" + "In %s, the file %s not exist"%(self.old_item,file_name_log)
            print 'In %s:'%self.old_item,'Fail'
            self.exception_find_flag = 1
            self.logic_result_check_dict[self.old_item] = False
            return
        #print file_name
        result_single = "Fail"
        check_lines = 'Cumulative negative slack'
        line = file_hand.readline()
        while line:
            line = line.strip()
            #if line.startswith('ERROR'): as yibin's need
            #    result_single = "Fail"
            #    break
            if line.find(check_lines)!= -1:
                result_single = "Pass"
                break
            else:
                try:
                    line = file_hand.readline()
                except:
                    break
        #print self.result
        print 'In %s:'%self.old_item,result_single
        if result_single == "Pass" and self.result:
           pass
        elif result_single == "Fail":
            if not temp_cr_note:
                self.result = False
                self.Comments = self.Comments+" ;" + 'check_partrce'
                self.logic_result_check_dict[self.old_item] = False
        else:
            pass
    
    def check_flow(self):
        print "Come Into the %s"%self.old_item
        #self.return_log.append("Come Into the "+self.old_item)
        file_name = ""
        method_dict = self.conf_options.get("check_flow")
        keyss = method_dict.keys()
        keyss.sort()
        file_name_log=''
        temp_cr_note = ""
        for item  in keyss:
            value = method_dict[item]
            if item == "file":
                file_name =  value
                #p = re.compile('<id>')
                #file_name = p.sub(self.id+'_scratch',file_name)
                file_name_log = file_name
                used = '00'
                '''for dir in os.listdir(self.design_path):
                    dir_path = os.path.join(self.design_path,dir)
                    if os.path.isdir(dir_path):
                        if os.path.isdir(os.path.join(dir_path,'BE_flow') ):
                            used = dir_path
                            break
                        else:
                            continue'''
                file_name = os.path.join(self.design_path,file_name)
            elif item == "cr_note":
                temp_cr_note = value
                self.cr_note_flag += value

            else:
                pass
        check_file = file_name
        try:
            file_name = glob.glob(file_name)
            file_name = file_name[0]
            file_hand = file(file_name,"r")
        except:
            self.result = False
            self.Comments = self.Comments+" ;" + "In %s, the file %s not exist"%(self.old_item,file_name_log)
            print 'In %s:'%self.old_item,'Fail'
            self.exception_find_flag = 1
            self.logic_result_check_dict[self.old_item] = False
            return
        #print file_name
        result_single = "Fail"
        check_lines = 'All signals are completely routed'
        line = file_hand.readline()
        while line:
            if line.find(check_lines)!= -1:
                result_single = "Pass"
                break
            else:
                try:
                    line = file_hand.readline()
                except:
                    break
        print 'In %s:'%self.old_item,result_single
        if result_single == "Pass" and self.result:
           pass
        elif result_single == "Fail":
            if not temp_cr_note:
                self.result = False
                self.Comments = self.Comments+" ;" + 'check_flow'
                self.logic_result_check_dict[self.old_item] = False
        else:
            pass
        self.lines_reference_0[4] = result_single
        #print "-------"
        #print self.lines_reference_0
    def check_data(self):
    ###########################
    #file=par\ecp3\<id>\WithMinValue_one.twr
    #start_line = ***  (line 1)
    #result=**    or  **,** (it can be a data or the line and the position )
    #line1=**,**,** or **,** (it can be a data or the line and the position  and the operation)
    #line2=**,**,**
    #line3=**,**,
        print "Come Into the %s"%self.old_item
        #self.return_log.append("Come Into the "+self.old_item)
        file_name = ""
        method_dict = self.conf_options.get(self.old_item)
        keyss = method_dict.keys()
        keyss.sort()
        result = ''
        lines = []
        time = 1
        file_name_log = ''
        temp_cr_note = ""
        for item  in keyss:
            value = method_dict[item]
            if item == "file":
                file_name =  value
                #p = re.compile('<id>')
                #file_name = p.sub(self.id+'_scratch',file_name)
                file_name_log=  file_name
                used = '00'
                file_name = os.path.join(self.design_path,file_name)
            elif item == "start_line":
                value = value.replace(r'\;',';')
                start = value
            elif item == "cr_note":
                temp_cr_note = value
                self.cr_note_flag += value
            elif item == "times":
                try:
                      time = int(value)
                except:
                      pass
            elif item == "result":
                length = len(value.split(","))
                if length >2:
                    self.result = False
                    self.Comments = self.Comments+" ;" + '%s: the result format error in  '%self.old_item +self.function_name
                result = value

            else:
                #pass
                if item.find("line")!= -1:
                    length = len(value.split(","))
                    if length ==2 or length ==3 or length==1:
                        lines.append(value)
                    else:
                        print "WRROR: Wrong format",value
                        self.return_log.append("WRROR: Wrong format "+value)
                        self.result = False
                        self.Comments = self.Comments+" ;" + 'Wrong Format'+item
                        print 'In %s:'%self.old_item,'Fail'
                        self.exception_find_flag = 1
                        self.logic_result_check_dict[self.old_item] = False
                        return
        try:
            file_name = glob.glob(file_name)
            file_name = file_name[0]
            file_hand = file(file_name,"r")
        except:
            self.result = False
            self.Comments = self.Comments+" ;" + '%s: No file for Checking'%self.old_item
            self.logic_result_check_dict[self.old_item] = False
            return
        total_lines = file_hand.readlines()
        start_num='a'
        line_time = 0
        for id2,line in enumerate(total_lines):
            if line.find(start)!= -1:
                line_time =  line_time + 1
            if line_time == time:
                start_num = id2
                break
        if start_num == 'a':
                self.result = False
                self.Comments = self.Comments+" ;" + '%s: Not find start line'%self.old_item
                self.exception_find_flag = 1
                self.logic_result_check_dict[self.old_item] = False
                return

        result = result.split(",")
        result_check = ''
        if len(result) ==1:
            result_check = result[0]
            result_check = float(result_check)
            result_check = "%.3f"%result_check
        else:
            use_line = total_lines[ int(result[0])+start_num -1  ]
            use_line = use_line.split()
            try:
                result_check = use_line[ int(result[1])-1 ]
                result_check = result_check.split('ns')[0]
                if result_check.endswith("ns"):
                    result_check = result_check[:-2]
                result_check = float(result_check)
                result_check = "%.3f"%result_check
            except:
                self.result = False
                self.Comments = self.Comments+" ;" + '%s: the result1 format error in  '%self.old_item +self.function_name
                print 'In %s:'%self.old_item,'Fail'
                self.exception_find_flag = 1
                self.logic_result_check_dict[self.old_item] = False
                return
        use_string = ''
        for id2,item in enumerate(lines):
            item = item.split(",")
            if len(item)==2 and id2 !=len(lines)-1:
                use_string = use_string + item[0]+item[1]

            elif len(item)==1 and id2 ==len(lines)-1:

                use_string = use_string + item[0]

            else:
                use_line = total_lines[ int(item[0]) + start_num -1 ].strip()
                use_line = use_line.split()
                try:
                    data = use_line[ int(item[1]) -1 ]
                    data = data.split('ns')[0]
                    if data.endswith("ns"):
                        data = data[:-2]
                    #operation = use_line[ int(item[1]) ]
                    if id2 == len(lines) -1:
                        use_string = use_string + data
                    else:
                        use_string = use_string + data + item[2]

                except:
                    self.result = False
                    self.Comments = self.Comments+" ;" + '%s: the result2 format error:%s in'%(self.old_item,item) + self.function_name
                    print 'In %s:'%self.old_item,'Fail'
                    self.exception_find_flag = 1
                    self.logic_result_check_dict[self.old_item] = False
                    return
        try:
            line_result = ''
            line_result = eval(use_string)
            line_result = "%.3f"%line_result
        except:
            print "Error: wrong string to Eval: %s" %use_string
            self.return_log.append("Error: wrong string to Eval: %s" %use_string)
            self.result = False
            self.Comments = self.Comments+" ;" + '%s: the result3 format error:%s in ' %(self.old_item,use_string) +self.function_name
            print 'In %s:'%self.old_item,'Fail'
            self.exception_find_flag = 1
            self.logic_result_check_dict[self.old_item] = False
            return
        try:
            abs1 = abs(float(result_check))
            abs2 = abs(float(line_result))
        except:
            abs1 = 1
            abs2 = 2
        if abs1 == abs2:
            print 'In %s:'%self.old_item,'Pass'
            pass
        else:
            if not temp_cr_note:
                self.logic_result_check_dict[self.old_item] = False
                self.result = False
                self.Comments = self.Comments+" ;" + '%s: %s != %s in' %(self.old_item,result_check,line_result)+self.function_name
                print 'In %s:'%self.old_item,'Fail'
    def find_how( self,line,want,initial_want):
        '''
        at here, want will just a list, this will be used in the follow function
        '''
        return_value = -1
        line = line.strip()
        if not line:
            return -1
        if want == initial_want:

            want_line = " ".join(want)
            if line.find(want_line)!= -1:
                return  len(want)-1
            else:
                line_list = line.split()
                line_list = "".join(line_list)
                want = "".join(want)
                line_old_id = 0
                for id1,item in enumerate(line_list):
                    if item == want[0]:
                        if return_value == -1:
                            return_value = 0
                            line_old_id = id1
                            if len(want) == 1:
                                return return_value
                            else:
                                want = want[1:]
                        else:
                            return_value = return_value + 1
                            line_old_id = id1
                            if len(want) == 1:
                                return return_value
                            else:
                                want = want[1:]
                    else:

                         retrun_value = -1
                if line_old_id == len(line_list)-1:
                    return return_value
                else:
                    return -1

        else:
                line_list = line.split()
                line_list = "".join(line_list)
                want = "".join(want)
                line_old_id = 0
                for id1,item in enumerate(line_list):
                    if item == want[0]:
                        if return_value == -1:
                            return_value = 0
                            line_old_id = id1
                            if len(want) == 1:
                                return return_value
                            else:
                                want = want[1:]
                        else:
                            return_value = return_value + 1
                            line_old_id = id1
                            if len(want) == 1:
                                return return_value
                            else:
                                want = want[1:]
                    else:
                         retrun_value = -1
                         break
                if line_old_id == len(line_list)-1:
                    return return_value
                else:
                    return -1

        return return_value

    def check_multiline(self):
        #######################################
        #at here, the check_line may be showed in many lines
        #Example:  check_line = 'hello STA'
        #line1:   bababababab hello
        #line2:   STA
        #config file
        #[check_multiline]
        #file  = par\ecp3\<id>\GSR_NET_impl.mrp
        #check_line = Target Vendor:  LATTICE Target Device:  LFE3-95EAFPBGA484
        #######################################
        print "Come Into the %s"%self.old_item
        #self.return_log.append("Come Into the "+self.old_item)
        method_dict = self.conf_options.get(self.old_item)
        time = 1
        check_line = ''
        keyss = method_dict.keys()
        keyss.sort()
        file_name = ''
        file_name_log = ''
        temp_cr_note = ""
        for item  in keyss:
            value = method_dict[item]
            if item == "file":
                file_name =  value
                file_name_log = file_name
                file_name = os.path.join(self.design_path,file_name)
            elif item == "times":
                try:
                    time = int(value)
                except:
                    pass
            elif item == 'check_line':
                value = value.replace(r'\;',';')
                check_line = value
            elif item == "cr_note":
                temp_cr_note = value
                self.cr_note_flag += value
            else:
                    print "The format of your configure file is wrong"
                    self.return_log.append("The format of your configure file is wrong")
                    self.result = False
                    self.Comments = self.Comments + ' ;' + self.old_item+ ' format is wrong'
                    print 'In %s:'%self.old_item,'Fail'
                    self.exception_find_flag = 1
                    self.logic_result_check_dict[self.old_item] = False
                    return
        check_file = file_name
        try:
            file_name = glob.glob(file_name)
            file_name = file_name[0]
            file_hand = file(file_name,"r")
        except:
            self.result = False
            self.Comments = self.Comments+" ;" + "In %s, the file %s not exist"%(self.old_item,file_name_log)
            print 'In %s:'%self.old_item,'Fail'
            self.exception_find_flag = 1
            self.logic_result_check_dict[self.old_item] = False
            return
        result_single = "Fail"
        check_start = True
        line = file_hand.readline()
        line_time = 0
        find_it = 0
        #------------------new ways --------------------#
        all_lines = file_hand.readlines()
        all_lines_signal = "".join(all_lines)
        all_lines_signal = re.sub('\s+','',all_lines_signal)
        check_line = re.sub('\s+','',check_line)
        '''find_num = re.findall(check_line,all_lines_signal)
        if len(find_num)>=time:
            result_single = 'pass' '''
        all_lines_signal_list = all_lines_signal.split(check_line)
        if len(all_lines_signal_list) >= time + 1:
            result_single = 'Pass'
        print 'In %s:'%self.old_item,result_single
        if result_single == "Pass" and self.result:
           pass
        elif result_single == "Fail":
            if not temp_cr_note:
                self.result = False
                self.Comments = self.Comments+" ;" + self.old_item
                self.logic_result_check_dict[self.old_item] = False
        else:
            print result_single, self.result
            self.return_log.append(str(result_single)+' '+str(self.result))

    def check_no(self):
        '''
            This method use to check whether the line exists in the specify file.
            if not exists, the result will pass
            you can write the conf as:
            [check_no_1]
            file=a.txt
            check_line=df1
        '''
        #######################################
        #pass  #this is the old
        #######################################
        print "Come Into the %s"%self.old_item
        #self.return_log.append("Come Into the "+self.old_item)
        method_dict = self.conf_options.get(self.old_item)
        title = ""
        time = 1
        check_lines = []
        check_lines_dic = {}
        check_lines_num = []
        keyss = method_dict.keys()
        keyss.sort()
        file_name = ''
        file_name_log = ''
        temp_cr_note = ""
        for item  in keyss:
            value = method_dict[item]
            if item == "title":
                title = value
            elif item == "cr_note":
                temp_cr_note = value
                self.cr_note_flag += value
            elif item == "file":
                file_name =  value
                file_name_log= file_name
                used = '00'
                file_name = os.path.join(self.design_path,file_name)
            elif item == "times":
                try:
                    time = int(value)
                except:
                    pass
            elif item == 'check_line':
                value = value.replace(r'\;',';')
                check_line = value
            else:
                print "The format of your configure file is wrong"
                self.return_log.append("The format of your configure file is wrong")
                self.result = False
                self.Comments = self.Comments + ' ;' + item+ 'format is wrong'
                print 'In %s:'%self.old_item,'Fail'
                self.exception_find_flag = 1
                self.logic_result_check_dict[self.old_item] = False
                return
        check_file = file_name
        try:
            file_name = glob.glob(file_name)
            file_name = file_name[0]
            file_hand = file(file_name,"r")
        except:
            self.result = False
            self.Comments = self.Comments+" ;" + "In %s, the file %s not exist"%(self.old_item,file_name_log)
            print 'In %s:'%self.old_item,'Fail'
            self.exception_find_flag = 1
            self.logic_result_check_dict[self.old_item] = False
            return
        result_single = "Pass"
        line = file_hand.readline()
        while line:
            if line.find(check_line) != -1:
                result_single = 'Fail'
                break
            line = file_hand.readline()
        print 'In %s:'%self.old_item,result_single
        if result_single == "Pass" and self.result:
           pass
        elif result_single == "Fail":
            if not temp_cr_note:
                self.result = False
                self.Comments = self.Comments+" ;" + self.old_item
                self.logic_result_check_dict[self.old_item] = False
        else:
            pass
    def get_file_except_lse(self,file):
        all_files = glob.glob(file)
        if not all_files:
            return []
        else:
            if len(all_files) == 1:
                return all_files
            else:
                return_files = []
                for f in all_files:
                    if f.find('_lse.') != -1 or f.find('_LSE.')!= -1:
                        continue
                    else:
                        return_files.append(f)
                if return_files:
                    return return_files
                else:
                    return all_files
                        
    def check_grep(self):
        '''
        (1)format
        [check_grep]
        file  = <path>\<file>
        grep =<grep>
        modifier = re.IGNORE
        (2)description
        this method will try to search the file with the given "regular expression" list by check_grep,
        if script can search any string under this rule, return PASS
        '''
        print "Come Into the %s"%self.old_item
        #self.return_log.append("Come Into the "+self.old_item)
        method_dict = self.conf_options.get(self.old_item)
        time = 1
        check_line = ''
        modifier = ''
        try:
            keyss = method_dict.keys()
        except:
            self.result = False
            self.Comments = self.Comments+" ;" + self.old_item+" can not get section settings"
            return 
        keyss.sort()
        file_name = ''
        reverse = ''
        file_name_log = ''
        temp_cr_note = ""
        for item  in keyss:
            value = method_dict[item]
            if item == "file":
                file_name =  value
                file_name_log= file_name
                file_name = os.path.join(self.design_path,file_name)
            elif item == "cr_note":
                temp_cr_note = value
                self.cr_note_flag += value
            elif item == "times":
                try:
                    time = int(value)
                except:
                    pass
            elif item == 'grep':
                value = value.replace(r'\;',';')
                check_line = value
            elif item == "modifier":
                modifier = value
            elif item.lower() == 'action':
                if value.lower() == 'negative':
                    reverse = 1
            else:
                print "The format of your configure file is wrong"
                self.return_log.append("The format of your configure file is wrong")
                self.result = False
                self.logic_result_check_dict[self.old_item] = False
                self.Comments = self.Comments + ' ' + item+ 'format is wrong'
                print 'In %s:'%self.old_item,'Fail'
                self.exception_find_flag = 1
                return
        check_file = file_name
        try:
            file_name = self.get_file_except_lse(file_name)
            file_name = file_name[0]
            file_hand = file(file_name,"r")
        except:
            self.result = False
            self.logic_result_check_dict[self.old_item] = False
            self.Comments = self.Comments+" ;" + "In %s, the file %s not exist"%(self.old_item,file_name_log)
            print 'In %s:'%self.old_item,'Fail'
            return
        result_single = "Fail"

        line = file_hand.readline()
        flag = 0
        if modifier.find('re.DOTALL')!= -1 or modifier.find('re.S')!= -1:
            flag = re.S
        if modifier.find('re.IGNORECASE')!= -1 or modifier.find('re.I')!= -1:
            flag = flag | re.I
        if modifier.find('re.LOCALE')!= -1 or modifier.find('re.L')!= -1:
            flag = flag | re.L
        if modifier.find('re.MULTILINE')!= -1 or modifier.find('re.M')!= -1:
            flag = flag | re.M
        if modifier.find('re.VERBOSE')!= -1 or modifier.find('re.X')!= -1:
            flag = flag | re.X
        if flag != 0:
            check_line_re = re.compile(check_line,flag)
        else:
            check_line_re = re.compile(check_line)
        while line:
            if check_line_re.search(line):
                result_single = 'Pass'
                print line
                break
            line = file_hand.readline()
        if reverse:
            if result_single == "Pass":
                result_single = "Fail"
            else:
                result_single = "Pass"
        print 'In %s:'%self.old_item,result_single
        if result_single == "Pass" and self.result:
           pass
        elif result_single == "Fail":
            if not temp_cr_note:
                self.result = False
                self.Comments = self.Comments+" ;" + self.old_item
                self.logic_result_check_dict[self.old_item] = False
        else:
            pass

    def run_cmd(self,cmd):
        pro_lines_temp = []
        process_stat_temp = 0
        if sys.platform[:3] != "win":
            cmd = "{ " + cmd + "; }"
        pipe2 = os.popen(cmd + " 2>&1", "r")
        for item in pipe2:
            pro_lines_temp.append(item.rstrip()+'\n')
        try:
            sts = pipe2.close()
            if sts >=1:
                process_stat_temp = sts
            if sts is None: process_stat_temp = 0
        except IOError:
            #pro_lines_temp.append('In run_cmd can not run: '+cmd+'\n')
            process_stat_temp = 1

        return pro_lines_temp,process_stat_temp

    def sim_check_block(self):
        self.check_block(sim_type="YES")

    def check_sdf(self):
        '''
            In this method, you should give the sdf path
            in configure file you should write it as:

            sdf_dir=*

        '''
        print "Come Into the check_sdf"
        #self.return_log.append("Come Into the check_sdf")
        method_dict = self.conf_options.get(self.old_item)
        title = ""
        sdf_dir = ""
        keyss = method_dict.keys()
        keyss.sort()
        for item  in keyss:
            value = method_dict[item]
            if item == "title":
                title = value
            elif item == "sdf_dir":
                sdf_dir =  value
            else:
                pass
        sdf_dir  = os.path.join(self.design_path,sdf_dir)
        try:
            [result_single,info] = check_sdf.run_sdf_check(sdf_dir)
        except:
            [result_single,info] = ['Fail','Can not excute check_sdf script']
        print 'In %s:'%self.old_item,result_single
        if result_single == "True" and self.result:
           pass
        elif result_single == "Fail":
            self.result = False
            self.Comments = self.Comments+" ;" + self.old_item+info
            self.logic_result_check_dict[self.old_item] = False
            #self.device_s = self.device[]
        else:
            pass

    def check_compare_par(self):
        '''
            In this method, you should give the sdf path
            in configure file you should write it as:

            par_dir=*
            mode=*
            : for mode, you can set it as ws or ts, other value will be seem as ws

        '''
        print "Come Into the check_compare_par"
        #self.return_log.append("Come Into the check_compare_par")
        method_dict = self.conf_options.get(self.old_item)
        title = ""
        par_dir = ""
        mode = ""
        keyss = method_dict.keys()
        keyss.sort()
        for item  in keyss:
            value = method_dict[item]
            if item == "title":
                title = value
            elif item == "par_dir":
                par_dir =  value
            elif item == "mode":
                mode =  value
            else:
                pass
        par_dir  = os.path.join(self.design_path,par_dir)
        par_dir = os.path.abspath(par_dir)
        try:
            [result_single,info] = compare_par.run(par_dir,mode)
        except:
            [result_single,info] = ['Fail','Can not excute compare_par script']
        print 'In %s:'%self.old_item,result_single
        if result_single == "True" and self.result:
           pass
        elif result_single == "Fail":
            self.result = False
            self.Comments = self.Comments+" ;" + self.old_item+info
            self.logic_result_check_dict[self.old_item] = False
            #self.device_s = self.device[]
        else:
            pass

    def check_file(self):
        '''
            This method use to check whether the file exists.
            if not exists, the result will pass
            you can write the conf as:
            [method]
            check_file=1
            [check_file]
            file=./_scratch/one/top_for_lpf.sdc
            reverse = 0
            ##########################Description################
            This is the demo to show how to check a files exists or not.
            file: the file you want to find
            reverse: you want to get the reverse result.
            --------------------------------------
            At here, we also support regression expression to find a file.
            But just * will be support.
            For example:
            file=./_scratch/one/*.sdc
            If the script find any sdc file under _scratch/one, the result will be pass.
            ----------------------------------------
            If the file exists, the result is pass or the result will be fail.
            But if you write reverse=1 under the check_file section, you will get the reverse result.
            This means if the script find the file, the result will be fail.
            The default value for reverse is 0. you don't need to write it if you do not need the reverse result.
        '''
        #######################################
        #pass  #this is the old
        #######################################
        print "Come Into the %s"%self.old_item
        #self.return_log.append("Come Into the "+self.old_item)
        method_dict = self.conf_options.get(self.old_item)
        title = ""
        keyss = method_dict.keys()
        keyss.sort()
        file_name = ''
        reverse = 0
        file_name_log = ''
        temp_cr_note = ""
        for item  in keyss:
            value = method_dict[item]
            if item == "title":
                title = value
            elif item == "cr_note":
                temp_cr_note = value
                self.cr_note_flag += value
            elif item == "file":
                file_name =  value
                file_name_log= file_name
                used = '00'
                file_name = os.path.join(self.design_path,file_name)
            elif item == 'reverse':
                reverse = value
                try:
                    reverse = int(reverse)
                except:
                    self.result = False
                    self.Comments = self.Comments + ' ;' + item+ 'format is wrong'
                    print 'In %s:'%self.old_item,'Fail'
                    return
            else:
                print "The format of your configure file is wrong"
                self.return_log.append("The format of your configure file is wrong")
                self.result = False
                self.Comments = self.Comments + ' ;' + item+ 'format is wrong'
                print 'In %s:'%self.old_item,'Fail'
                self.exception_find_flag = 1
                self.logic_result_check_dict[self.old_item] = False
                return
        file_name = glob.glob(file_name)
        if len(file_name) >= 1:
            result_single = "Pass"
        else:
            result_single = "Fail"
        if reverse:
            if result_single == "Pass":
                result_single = "Fail"
            else:
                result_single = "Pass"
        if result_single == "Pass" and self.result:
           pass
        elif result_single == "Fail":
            if not temp_cr_note:
                self.result = False
                self.Comments = self.Comments+" ;" + self.old_item
                self.logic_result_check_dict[self.old_item] = False
        else:
            pass
        print 'In %s:'%self.old_item,result_single,self.result

    def clk_reference_flow(self, check_file = '',check_pattern = '',init_result = '',allowance = '', clk_name = ''):
        temp_clk_record = ['NA']*7  #LpfClock	Lpf_Fmax	TwrClock	Twr_Exp_Fmax	Twr_Act_Fmax	Diff	Result
        #self.lines_reference[1] = []
        def print_log(error_log):
            print error_log
            self.return_log.append(error_log)
            self.result = False
            self.Comments = self.Comments + ' ;' + self.old_item+ ' '+error_log
            temp_clk_record[6] = "FAIL"            
            print 'In %s:'%self.old_item,'Fail'
        if not check_file:
            print_log('Please specify check file')
            self.lines_reference_2.append(temp_clk_record)
            return
        else:
            pass
        if not check_pattern:
            print_log('Please specify check_pattern')
            self.lines_reference_2.append(temp_clk_record)
            return
        else:
            pass
        try:
            temp_clk_record[1] =init_result
            temp_clk_record[3] =init_result
            init_result = float(init_result)
            allowance = float(allowance)
        except:
            print_log('Please specify init_result/allowance as an int or float value')
            self.lines_reference_2.append(temp_clk_record)
            return
        if not clk_name:
            print_log('Please specify clk_name')
            self.lines_reference_2.append(temp_clk_record)
            return
        else:
            temp_clk_record[0] =clk_name
            temp_clk_record[2] =clk_name
        check_file = os.path.join(self.design_path,check_file) 
        check_file = glob.glob(check_file)
        print check_file
        if len(check_file) > 1:
            print_log('More than 1 check_file find')
            self.lines_reference_2.append(temp_clk_record)
            return
        if len(check_file) == 0:
            print_log('Can not find check_file')
            self.lines_reference_2.append(temp_clk_record)
            return
        all_lines = file(check_file[0]).readlines()
        check_pattern = re.compile(check_pattern)
        check_result = ''
        for line in all_lines:
            check_search = check_pattern.search(line)
            if check_search:
                try:
                    check_result = check_search.group(2)
                except:
                    print_log( 'check_result error '+'the check pattern error, can not get match value' )
                    return
                break
        if check_result:
            try:
                check_result = float(check_result)
            except:
                print_log( 'check_result error '+str(check_result) )
                temp_clk_record[4] = str(check_result)
                self.lines_reference_2.append(temp_clk_record)
                return
        else:
            print_log( 'Can not get check result '+str(check_result) )
            temp_clk_record[4] = str(check_result)
            self.lines_reference_2.append(temp_clk_record)
            return
        if check_result == 0:
            if init_result == 0:
                temp_clk_record[4] = str(check_result)
                temp_clk_record[6] = 'PASS'
                self.lines_reference_2.append(temp_clk_record)
            else:
                print_log( 'check_result error '+str(check_result) )
                temp_clk_record[4] = str(check_result)
                temp_clk_record[6] = 'FAIL'
                self.lines_reference_2.append(temp_clk_record)
                return
        else:
            if init_result == 0:
                print_log( 'check_result error '+str(check_result) )
                temp_clk_record[4] = str(check_result)
                temp_clk_record[6] = 'FAIL'
                self.lines_reference_2.append(temp_clk_record)
                return
            else:
                check_allowance = (check_result-init_result)/init_result
                print check_allowance
                print allowance/100
                if  check_allowance > allowance/100 and check_allowance>0:
                    temp_clk_record[4] = str(check_result)
                    temp_clk_record[5] = str(check_allowance*100)+'%'
                    temp_clk_record[6] = 'PASS'
                    self.lines_reference_2.append(temp_clk_record)
                else:
                    print_log( 'check_result error '+str(check_result) )
                    temp_clk_record[4] = str(check_result)
                    temp_clk_record[5] = str(check_allowance*100)+'%'
                    temp_clk_record[6] = 'FAIL'
                    self.lines_reference_2.append(temp_clk_record)
                   
    def check_clk_reference(self):
        '''
        [check_clk_reference_1]
        ;;PAP=   88.46% | 100.00 MHz |  88.46 MHz |   1.00 | FREQUENCY NET "MachXO_programmer/tck" 100.000000 MHz ;
        check_pattern = PAP=.*?\|\s+([\d\.]+)\s*MHz\s*\|\s*([\d\.]+)\s*MHz.*?FREQUENCY NET "MachXO_programmer/tck" 100.000000 MHz ;
        file = ./_scratch/*/*.twr
        init_result = 100
        allowance = 10
        clk_name = MachXO_programmer/tck
        '''
        print "Come Into the %s"%self.old_item
        method_dict = self.conf_options.get(self.old_item)
        keyss = method_dict.keys()
        keyss.sort()
        check_file = ''
        check_pattern = ''
        init_result = ''
        allowance = ''
        clk_name = ''
        for item  in keyss:
            value = method_dict[item]
            if item == 'check_pattern':
                check_pattern = value
            elif item == 'file':
                check_file = value
            elif item == 'init_result':
                init_result = value
            elif item == 'allowance':
                allowance  = value
            elif item == 'clk_name':
                clk_name = value
            else:
                print "The format of your configure file is wrong"
                self.return_log.append("The format of your configure file is wrong")
                self.result = False
                self.Comments = self.Comments + ' ;' + item+ 'format is wrong'
                print 'In %s:'%self.old_item,'Fail'
                self.logic_result_check_dict[self.old_item] = False
                return
        self.clk_reference_flow(check_file ,check_pattern,init_result ,allowance , clk_name )
        
    def lut_reference_flow(self,check_file = '',check_pattern = '',init_result = '',allowance = ''):
        temp_clk_record = ['NA']*4  #Exp_Res	Act_Res	Diff	Result
        #self.lines_reference[1] = []
        def print_log(error_log):
            print error_log
            self.return_log.append(error_log)
            self.result = False
            self.Comments = self.Comments + ' ' + self.old_item+ ' '+error_log 
            print 'In %s:'%self.old_item,'Fail'
        if not check_file:
            print_log('Please specify check file')
           
            return
        else:
            pass
        if not check_pattern:
            print_log('Please specify check_pattern')
            
            return
        else:
            pass
        try:
            self.lines_reference_1[0] =init_result
            init_result = float(init_result)
            allowance = float(allowance)
        except:
            print_log('Please specify init_result/allowance as an int or float value')
            return
        check_file = os.path.join(self.design_path,check_file) 
        check_file = glob.glob(check_file)
        if len(check_file) > 1:
            print_log('More than 1 check_file find')
            return
        if len(check_file) == 0:
            print_log('Can not find check_file find')
            return
        print check_file
        all_lines = file(check_file[0]).readlines()
        check_pattern = re.compile(check_pattern)
        check_result = ''
        for line in all_lines:
            check_search = check_pattern.search(line)
            if check_search:
                try:
                    check_result = check_search.group(1)
                except:
                    print_log( 'check_result error '+'the check pattern error, can not get match value' )
                    return
                break
        if check_result:
            try:
                check_result = float(check_result)
            except:
                print_log( 'check_result error '+str(check_result) )
                self.lines_reference_1[1] = str(check_result)
                return
        if check_result == 0:
            if init_result == 0:
                self.lines_reference_1[1] = str(check_result)
                self.lines_reference_1[3] = 'PASS'
                
            else:
                print_log( 'check_result error '+str(check_result) )
                self.lines_reference_1[1] = str(check_result)
                self.lines_reference_1[3] = 'FAIL'
                
                return
        else:
            if init_result == 0:
                print_log( 'check_result error '+str(check_result) )
                self.lines_reference_1[1] = str(check_result)
                self.lines_reference_1[3] = 'FAIL'
                return
            else:
                check_allowance = (check_result-init_result)/init_result
                if  check_allowance < allowance/100:
                    self.lines_reference_1[1] = str(check_result)
                    self.lines_reference_1[2] = str(check_allowance*100)+'%'
                    self.lines_reference_1[3] = 'PASS'
                else:
                    print_log( 'check_result error '+str(check_result) )
                    self.lines_reference_1[1] = str(check_result)
                    self.lines_reference_1[2] = str(check_allowance*100)+'%'
                    self.lines_reference_1[3] = 'FAIL'
                    
    def check_lut_reference(self):
        '''
        [check_lut_reference_1]
        ;;Number of LUT4s:        1596 out of 24288 (7%)
        check_pattern = Number of LUT4s:\s+(\d+)
        file = ./_scratch/*/*.mrp
        init_result = 100
        allowance = 5
        '''
        print "Come Into the %s"%self.old_item
        method_dict = self.conf_options.get(self.old_item)
        keyss = method_dict.keys()
        keyss.sort()
        check_file = ''
        check_pattern = ''
        init_result = ''
        allowance = ''
        for item  in keyss:
            value = method_dict[item]
            if item == 'check_pattern':
                check_pattern = value
            elif item == 'file':
                check_file = value
            elif item == 'init_result':
                init_result = value
            elif item == 'allowance':
                allowance  = value
            elif item == "id":
                self.lines_reference_0[0] = value
            elif item == "project":
                self.lines_reference_0[1] = value
            elif item == "entry":
                self.lines_reference_0[2] = value
            elif item == "device":
                self.lines_reference_0[3] = value
            else:
                print "The format of your configure file is wrong"
                self.return_log.append("The format of your configure file is wrong")
                self.result = False
                self.Comments = self.Comments + ' ;' + item+ 'format is wrong'
                print 'In %s:'%self.old_item,'Fail'
                return
        self.lut_reference_flow(check_file,check_pattern,init_result,allowance)
    def check_binary(self):
        '''
            This method used to check binary files whether they are same.
            the conf content should be as:
            [check_binary]
            compare_file = **
            golden_file = **
          
        '''
        print "Come Into the %s"%self.old_item
        method_dict = self.conf_options.get(self.old_item)
        keyss = method_dict.keys()
        keyss.sort()
        compare_file = ''
        gloden_file = ''
        temp_cr_note = ""
        for item  in keyss:
            value = method_dict[item]
            if item == 'compare_file':
                compare_file = value
            elif item == 'golden_file':
                gloden_file = value
            elif item == "cr_note":
                temp_cr_note = value
                self.cr_note_flag += value
            else:
                print "The format of your configure file is wrong"
                self.return_log.append("The format of your configure file is wrong")
                self.result = False
                self.Comments = self.Comments + ' ;' + item+ 'format is wrong'
                print 'In %s:'%self.old_item,'Fail'
                self.logic_result_check_dict[self.old_item] = False
                return
        if not compare_file or not gloden_file:
            print "The format of your configure file is wrong"
            self.return_log.append("The format of your configure file is wrong")
            self.result = False
            self.Comments = self.Comments + ' ;' + item+ 'format is wrong'
            print 'In %s:'%self.old_item,'Fail'
            self.logic_result_check_dict[self.old_item] = False
            return
        compare_file = os.path.join(self.design_path,compare_file)
        gloden_file = os.path.join(self.design_path,gloden_file)
        if not os.path.isfile(os.path.abspath(compare_file)) or not os.path.isfile(os.path.abspath( gloden_file)):
            self.return_log.append("can not find compare_file or gloden_file")
            self.result = False
            self.Comments = self.Comments + ' ;' + item+ 'can not find compare_file or gloden_file'
            print 'In %s:'%self.old_item,'Fail'
            self.logic_result_check_dict[self.old_item] = False
            self.exception_find_flag = 1
            return
        gloden_lines = ""
        compare_lines = ""
        gloden_hand = file(gloden_file,"rb")
        while 1:
            temp= gloden_hand.read(1)
            if len(temp) == 0:  
                break
            else:
                gloden_lines += temp
        compare_hand = file(compare_file,"rb")
        while 1:
            temp= compare_hand.read(1)
            if len(temp) == 0:  
                break
            else:
                compare_lines += temp
        if compare_lines == gloden_lines:
            if self.result:
                pass
            else:
                pass
        else:
            if not temp_cr_note:
                self.result = False
                self.Comments = self.Comments + ' ;' + self.old_item+ ' not the same'
                self.logic_result_check_dict[self.old_item] = False
                print 'In %s:'%self.old_item,'Fail'
if __name__ == "__main__":
    #qaLog.set_logging_level()
    checker = TA(top_dir='',design='',report_path='',report='check.csv')
    sts = checker.process()
    exit_status = sts[0]
    print "Final check status:", exit_status
    if exit_status:
        sys.exit(exit_status)


