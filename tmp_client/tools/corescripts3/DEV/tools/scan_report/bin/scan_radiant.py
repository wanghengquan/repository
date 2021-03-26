#! C:\Python25\python.exe
#===================================================
# Owner    : Yzhao1
# Function :
#           This file is used for scan_report for lattice
#
# Attention:1. this file used to scan the case run as gui(general gui, tcl flow)
#          : You can just run it as: *.py --job-dir=****
#          :Directory hierarchy:  top-dir/cases/impl
#          :2. If you want to get special source from the report
#          :  You can add --conf-file=*   * is a file, you can write the source in it.
#          :  You should write it each source in a line.
#          :  For example:LUT
#          :              IO
#          :3 Update --special-structure, we can write it as --special-structure="_scratch,_scratch_1,..."
#          : In this situation, the script will scan all scratch directory. but you have to make sure
#          : "_scratch,_scratch_1,..." is seperate by, and the frist is the regular, other are writed just add some character to the first
#          : and this just used by QoR
# Date     :2013/10/30
#===================================================
import optparse
import os
import sys
import re
import glob
from xml.etree import ElementTree
import xml.dom.minidom as minidom
scan_report_dir = os.path.join(os.path.dirname(__file__),'..','tools','scan_tools')
scan_report_dir = os.path.abspath(scan_report_dir)
if scan_report_dir in sys.path:
    pass
else:
    sys.path.append(scan_report_dir)
import tool_scan_radiant
from .xlib import xFamily
from xOS import not_exists, wrap_copy_file, wrap_move_dir,get_unique_file,RecoverPath
from xLog import print_always
from xTools import append_file
from .xlib import report_sort
import platform
import xConf
import time
try:
    # this step just used for win
    import msvcrt
    LK_UNLCK = 0 # unlock the file region
    LK_LOCK = 1 # lock the file region
    LK_NBLCK = 2 # non-blocking lock
    LK_RLCK = 3 # lock for writing
    LK_NBRLCK = 4 # non-blocking lock for writing
except:
    pass
def readme():
    '''
       This file used to scan the report from GUI format cases.
       Mainly you can run it as:
            python *.py --job-dir=*
       The script will scan the cases in this directory and store the
       reports under job-dir(So we need Write Authority)
       Special Attention:
            we need to keep the directory format as:
            +++++++++++++++++++++++++++++++
                job-dir
                    case1
                    case2
                    case3
                    ...
           +++++++++++++++++++++++++++++++
       If you just want to scan special case, run it as:
            python *.py --job-dir=* --design=*
       If you want to get special resources in the report, you need to write
       a file at local directory, and write each line just one resource(design,
       version and device can be ingored).
       For Example(conf.file):
            IO
            LUT
            LUt
       You can run it as:
            python *.py --job-dir=* --design=* --conf-file=*


    '''
    pass

def lock_file(file_name='temp_lock_file.log'):
    log_handle   = open(file_name,'a')
    while 1:
        try:
            a_lock = msvcrt.locking(log_handle.fileno(), LK_LOCK, 1000000)
            return log_handle
        except IOError:
            print(2)
            time.sleep(1)
            continue

def unlock_file(file_hand):
    file_hand.close()

def get_default_implementation(xml_file):
    '''
       read the ldf file and get the impl
    '''
    try:
        xml_parser = ElementTree.parse(xml_file)
    except Exception as e:
        print(e)
        return ""
    lst_node = xml_parser.getiterator()
    default_implementation = ''
    for id1,node in enumerate(lst_node):
        if node.tag.lower() == 'baliproject':
            pass
        else:
            pass
        if ('default_implementation' in node.attrib)>0:
            default_implementation = node.attrib['default_implementation']
        if node.tag.lower() == 'implementation':
            if node.attrib.get('title','NAN') == default_implementation:
                default_implementation_dir = node.attrib.get('dir','')
                if not default_implementation_dir:
                    default_implementation_dir = default_implementation
    return  default_implementation_dir
class scan_general_case:
    def __init__(self,job_dir=os.getcwd(),design='',conf_file='',pap=False,
                report_name='report.csv',report_path='',force_na=False,
                special_structure='_scratch',flow='general',qor_auto=False,
                list_order=False,name_list='',default_case_list=''):
        self.init_job_dir = job_dir
        self.init_design = design
        self.init_conf_file = conf_file
        self.init_pap = pap
        self.init_report_name = report_name
        self.init_report_path = report_path
        self.init_force_na = force_na
        self.init_special_structure = special_structure
        self.init_flow = flow
        self.init_qor_auto = qor_auto
        self.init_list_order = list_order
        self.init_name_list = name_list
        self.init_ldf = ''
        self.default_case_list = default_case_list
        self.scan_set()
    def option(self):
        _family = xFamily.get_family_by_vendor('lattice')
        _syn_dict = dict(lattice=("synp", "lse"), altera=("synp", "qis"), xilinx=("synp", "xst"), cube=("synp", "lse"))
        _synthesis = _syn_dict.get('lattice')
        public_group=optparse.OptionParser()
        public_group.add_option("--job-dir", default=os.getcwd(), help="specify job working path")
        public_group.add_option("--design", help="specify design name")
        public_group.add_option("--conf-file", help="specify the configure file")
        public_group.add_option("--pap", action="store_true", help="dump Lattice Performance Achievement Percentage data, or the PAP will be NAN")
        public_group.add_option("--report-name", default='report.csv',help="specify report_name you want to store")
        public_group.add_option("--report-path", help="specify the report path")
        public_group.add_option("--force-na", action="store_true", help="force the data become NAN if can get data from par file")
        public_group.add_option("--special-structure",default="_scratch",help="specify the special structure for the case")
        public_group.add_option("--flow",default="general",help="specify the case flow")
        public_group.add_option("--qor-auto", action="store_true", help="write the pass/fail log in the qor flow ")
        public_group.add_option("--list-order", action="store_true", help="sort the report as spcial order listed in the case_list file located in conf directory ")
        public_group.add_option("--name-list", help="specify the list name in the case_list.conf, this used for write sorted report")
        public_group.add_option("--ldf",help="specify the ldf file name in the case")
        public_group.add_option("--all-clk",action="store_true",help="get all clk info in twr file and write to all_clk.csv ")
        public_group.add_option("--default-list",default="",help="If this option is set, the order for qor will be use the default order(csv case order)")

        self.opt,self.args=public_group.parse_args()
    def scan_set(self):
        self.option()
        job_dir = self.opt.job_dir
        if job_dir == os.getcwd():
            job_dir = self.init_job_dir
        self.job_dir = os.path.abspath(job_dir)
        self.need_design = self.opt.design
        if not self.need_design:
            self.need_design = self.init_design
        self.pap = self.opt.pap
        if not self.pap:
            self.pap = self.init_pap
        self.conf_file = self.opt.conf_file
        if not self.conf_file:
            self.conf_file = self.init_conf_file
        self.report_file = self.opt.report_name
        if self.report_file == 'report.csv':
            self.report_file = self.init_report_name
        if self.report_file == 'report.csv':
            self.report_file = os.path.basename(self.job_dir)+'.csv'
        self.report_path = self.opt.report_path
        if not self.report_path:
            self.report_path = self.init_report_path
        self.special_structure = self.opt.special_structure
        if self.special_structure=='_scratch':
            self.special_structure =  self.init_special_structure
        if self.special_structure.find(",")!= -1:
            self.special_structure = self.special_structure.split(',')
            self.special_structure = [s.strip() for s in self.special_structure]
        self.flow = self.opt.flow
        if self.flow == 'general':
            self.flow = self.init_flow
        self.qor_auto = self.opt.qor_auto
        if not self.qor_auto:
            self.qor_auto = self.init_qor_auto
        self.list_order = self.opt.list_order
        if not self.list_order:
            self.list_order = self.init_list_order
        self.name_list = self.opt.name_list
        if not self.name_list:
            self.name_list = self.init_name_list
        if not self.name_list:
            self.name_list = os.path.basename(self.job_dir)
        self.ldf_name = self.opt.ldf
        if not self.ldf_name:
            self.ldf_name = self.init_ldf
        self.force_NAN = self.opt.force_na
        if not self.force_NAN:
            self.force_NAN = self.init_force_na
        if not self.report_path:
            self.report_path = self.job_dir
        self.all_clk = self.opt.all_clk
        if not  self.all_clk:
             self.all_clk = False
        self.default_case_list = self.opt.default_list
        self.scan_mrp = tool_scan_radiant.ScanLatticeMrp()
        self.scan_twr = tool_scan_radiant.ScanLatticeTwr(self.pap,self.all_clk)
        self.scan_time = tool_scan_radiant.ScanLatticeTime()

        self.all_designs = []
        if os.path.isdir(self.job_dir) and  self.need_design:
            self.all_designs=[self.need_design]
        else:
            if os.path.isdir(self.job_dir):
                pass
            else:
                print('The job_dir:%s is not a directory'%job_dir)
                self.report_file_list = []
                return -1
            '''for dir in os.listdir(self.job_dir):  # get all the design path
            dir2 =  os.path.join(self.job_dir,dir)
            if os.path.isdir(dir2):
                self.all_designs.append(dir)
            else:
                pass'''
            for dir in os.listdir(self.job_dir):  # get all the design path
                dir2 =  os.path.join(self.job_dir,dir)
                if type(self.special_structure)!= list:
                    if os.path.isdir(dir2) and [self.special_structure] == os.listdir(dir2):
                        self.all_designs.append(dir)
                    else:
                        pass
                else:
                    #case/_scratch_1
                    #case/_scratch_2
                    #...
                    if os.path.isdir(dir2):#case
                        if os.path.isdir(dir2) and [self.special_structure[0]] == os.listdir(dir2):
                            self.all_designs.append(dir)
                        else:
                            for dir3 in os.listdir(dir2):#_scratch_1
                                if dir3 in self.special_structure:
                                    dir4 = dir+'***'+dir3
                                    self.all_designs.append(dir4)
            if 1:
                for root1,dir1,files1 in os.walk(self.job_dir):
                    '''for f in files1:
                         if f.endswith('.ldf'):
                             case_t = os.path.join(root1,'..')
                             case_t = os.path.abspath(case_t)
                             case_t = case_t.replace(self.job_dir,'')
                             case_t = case_t.strip('\\')
                             case_t = case_t.strip('/')
                             self.all_designs.append(case_t)
                         root = os.path.abspath(root)'''

                    if type(self.special_structure) != list:
                        if self.special_structure in root1: # special process for some case produce '.info'
                            continue
                        if self.special_structure in dir1:
                            case_t = root1
                            case_t = os.path.abspath(case_t)
                            case_t = case_t.replace(self.job_dir,'')
                            case_t = case_t.strip('\\')
                            case_t = case_t.strip('/')
                            self.all_designs.append(case_t)
                    for f in files1:
                        if f.endswith('.info'):
                            case_t = root1
                            case_t = os.path.abspath(case_t)
                            case_t = case_t.replace(self.job_dir,'')
                            case_t = case_t.strip('\\')
                            case_t = case_t.strip('/')
                            self.all_designs.append(case_t)
                            break
                        elif f.endswith('.ldf'):
                            if root1.endswith('par'):
                                case_t = os.path.join(root1,'..')
                                case_t = os.path.abspath(case_t)
                                case_t = case_t.replace(self.job_dir,'')
                                case_t = case_t.strip('\\')
                                case_t = case_t.strip('/')
                                self.all_designs.append(case_t)
                                break
            if not self.all_designs:
                for dir in os.listdir(self.job_dir):  # get all the design path
                    dir2 =  os.path.join(self.job_dir,dir)
                    if os.path.isdir(dir2):
                        self.all_designs.append(dir)
                    else:
                        pass
        self.all_designs = list(set(self.all_designs))
        self.report_file_list = []
        scanner = (self.scan_mrp, self.scan_twr, self.scan_time)
        self.add_report(scanner,self.report_path,self.report_file)
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

    def add_report(self,scanner,report_path,report_file):
        self.report_file = os.path.join(report_path,report_file)
        if self.report_file in self.report_file_list:
            pass
        else:
            self.report_file_list.append(self.report_file)
            if not_exists(self.report_file):
                title = ["Design"]
                for item in scanner: #mrp twr time
                   title += item.get_title()
                append_file(self.report_file, ",".join(title))
            if 1:
                report_name,subtex = os.path.splitext(self.report_file)
                self.report_file_mrp = report_name+'_mrp'+subtex
                if not_exists(self.report_file_mrp):
                    title = ["Design"]
                    #for item in scanner: #mrp twr time
                    title += (scanner[0]).get_title()
                    append_file(self.report_file_mrp, ",".join(title))
                self.report_file_twr = report_name+'_twr'+subtex
                if not_exists(self.report_file_twr):
                    title = ["Design"]
                   #for item in scanner: #mrp twr time
                    title += (scanner[1]).get_title()
                    append_file(self.report_file_twr, ",".join(title))
                self.report_file_time = report_name+'_time'+subtex
                if not_exists(self.report_file_time):
                    title = ["Design"] +['Target_fmax']
                    #for item in scanner: #mrp twr time
                    title += (scanner[2]).get_title()
                    append_file(self.report_file_time, ",".join(title))
                self.report_file_clock = report_name+'_clock'+subtex
                if not_exists(self.report_file_clock):
                    append_file(self.report_file_clock, ",".join(['Design','Colck','Loads']))

    def for_bqs_data_f(self,all_time_data):
        #print '123##################################################'
        self.for_bqs_data = '<scan_case>\n'
        self.for_bqs_data = self.for_bqs_data + "\t<Design>"+self.design+"</Design>\n"
        self.for_lrf20_data = ""
        for i_d in all_time_data:
            self.for_bqs_data = self.for_bqs_data + "\t<%s>"%i_d+all_time_data.get(i_d,'NA')+"</%s>\n"%i_d
            self.for_lrf20_data = self.for_lrf20_data + "\t<%s>"%i_d+all_time_data.get(i_d,'NA')+"</%s>\n"%i_d
        for id_f,i_d in enumerate(self.scan_mrp.get_title()):
            try:
                self.for_bqs_data = self.for_bqs_data + "\t<%s>"%i_d+self.scan_mrp.get_data()[id_f]+"</%s>\n"%i_d
                self.for_lrf20_data = self.for_lrf20_data + "\t<%s>"%i_d+self.scan_mrp.get_data()[id_f]+"</%s>\n"%i_d
            except:
                pass
        for id_f,i_d in enumerate(self.scan_twr.get_title()):
            if i_d == 'Pass_num':
                continue
            try:
                self.for_bqs_data = self.for_bqs_data + "\t<%s>"%i_d+self.scan_twr.get_data()[id_f]+"</%s>\n"%i_d
                self.for_lrf20_data = self.for_lrf20_data + "\t<%s>"%i_d+self.scan_twr.get_data()[id_f]+"</%s>\n"%i_d
            except:
                continue
        self.for_bqs_data = self.for_bqs_data +"</scan_case>"
        print('#BQS_RETRN_DATA_BEGIN#')
        print(self.for_bqs_data)
        print('#BQS_RETRN_DATA_END#')

        print("====resource start====")
        replace_p = re.compile("[^<]/")
        self.for_lrf20_data = re.sub(replace_p,"_",self.for_lrf20_data)
        print(self.for_lrf20_data)
        print("====resource end====")

        #print '456##################################################'

    def write_report(self):
        self.for_bqs_data = '<scan_case>\n'
        all_time_data = dict(list(self.srr_data.items())+list(self.mrp_data.items())+list(self.par_data.items()) + list(self.real_cpu_total.items()) )
        data_list = []
        for key in self.scan_time.get_title():
            value = all_time_data.get(key,'NA')
            data_list.append(value)
        data_list2 = [self.design]+['-'] +data_list
        if platform.system().find('Win')!= -1:
            file_lock = os.path.join(os.getcwd(),'temp_lock_file.log')
            lock_hand = lock_file(file_lock)
        append_file(self.report_file_time,",".join(data_list2))
        if  self.force_NAN:
            if all_time_data['Complete'] == 'NA' or all_time_data['Par_Done'] == 'NA':
                data_list = ['_']*len(self.scan_mrp.get_data()) +['_']*len(self.scan_twr.get_data()) +\
                           ['_']*len(data_list)
            else:
                data_list = self.scan_mrp.get_data() + \
                  self.scan_twr.get_data() + data_list
        else:
            data_list = self.scan_mrp.get_data() + \
                  self.scan_twr.get_data() + data_list
        # print all_time_data
        self.for_bqs_data_f(all_time_data)


        data = [self.design] + data_list
        append_file(self.report_file, ",".join(data))
        data = [self.design]
        append_file(self.report_file_mrp,",".join([self.design]+ self.scan_mrp.get_data() ))
        append_file(self.report_file_twr,",".join([self.design]+ self.scan_twr.get_data() ))
        #append_file(report_file_time,",".join([design]+ scan_time.get_data()))
        self.scan_time.reset_par_time_data()

        clock_dict = self.scan_mrp.get_parse_line_clocks()
        for key in list(clock_dict.keys()):
            line = self.design+','+key+','+clock_dict[key]
            append_file(self.report_file_clock,line)
        if platform.system().find('Win')!= -1:
            unlock_file(lock_hand)

    def write_NA_report(self,report_name,design='_'):
        '''
            This used for write NA or '_' to the report
        '''
        lines =  file(report_name).readlines()
        line_length = len(lines[0].split(','))
        if platform.system().find('Win')!= -1:
            file_lock = os.path.join(os.getcwd(),'temp_lock_file.log')
            lock_hand = lock_file(file_lock)
        new_line = [design]+['_']*(line_length-1)
        lines = lines+[",".join(new_line)+'\n']
        file_hand  = file(report_name,'w')
        file_hand.writelines(lines)
        file_hand.close()
        if platform.system().find('Win')!= -1:
            unlock_file(lock_hand)
    def write_NA_all_report(self,design='_'):
        #print '##################################################'
        self.for_bqs_data = '<scan_case>\n'
        self.for_bqs_data = self.for_bqs_data + "\t<design>"+design+"</design>\n"+'</scan_case>\n'
        print('#BQS_RETRN_DATA_BEGIN#')
        print(self.for_bqs_data)
        print('#BQS_RETRN_DATA_END#')
        #print '##################################################'
        reports = [self.report_file,self.report_file_mrp,self.report_file_twr,self.report_file_clock,self.report_file_time]
        for f in reports:
            self.write_NA_report(f,design)

    def scan_report(self):
        if self.flow == 'general':
            self.scan_report_general()
        elif self.flow == 'qor':
            self.scan_qor_report()
        elif self.flow == 'seed':
            self.scan_multi_seed_report()
        elif self.flow == 'dsp':
            self.scan_multi_seed_DSP_report()
        else:
            pass
        if self.conf_file:
            print(self.report_file)
            self.process_report_sort(self.conf_file,self.report_file)
    def scan_report_general(self):
        for design in self.all_designs:
            self.scan_mrp = tool_scan_radiant.ScanLatticeMrp()
            self.scan_twr = tool_scan_radiant.ScanLatticeTwr(self.pap)
            self.scan_time = tool_scan_radiant.ScanLatticeTime()
            if self.need_design:
                if design == self.need_design:
                    pass
                else:
                    continue
            self.design = design
            print_always( 'scanning %s'%design)
            design_path = os.path.join(self.job_dir,self.design)# e60_ecp3/g64
            srr_file = ''
            '''
            For tcl flow design, at here we have to read the ldf file
            and find the Implementation directory
            '''
            ldf_path = os.path.join(design_path,self.special_structure)
            ###### add for check whether the user have the wrong options. If "Target find under ldf_path, go to qor scan"
            qor_flag = 0
            if os.path.isdir(ldf_path):
                ldf_path_files_dirs = os.listdir(ldf_path)
                for f_d in ldf_path_files_dirs:
                    if f_d.startswith("Target_seed") and os.path.isdir(os.path.join(ldf_path,f_d)):
                        qor_flag = 1
                        self.scan_multi_seed_DSP_report()
                        break
                    if f_d.startswith("Target_fmax") and os.path.isdir(os.path.join(ldf_path,f_d)):
                        qor_flag = 1
                        self.scan_qor_report()
                        break
            if qor_flag:
                break
            if not self.ldf_name:
                ldf_file = get_unique_file([ldf_path, ".ldf"])
            else:
                ldf_file = glob.glob(os.path.join(ldf_path, '*'+self.ldf_name+'*'))
                if ldf_file:
                    ldf_file = ldf_file[0]
            if ldf_file:
                #ldf_path = os.path.join(design_path,self.special_structure)
                #ldf_file = get_unique_file([ldf_path, ".ldf"])
                if not ldf_file:
                    print('Error: can not get ldf file')
                    self.write_NA_all_report(self.design)
                    continue
                impl = get_default_implementation(ldf_file)
                if not impl:
                    print('Error: can not get the implementation in ldf file!!!')
                    self.write_NA_all_report(self.design)
                    continue
                dir_scan = os.path.join(design_path,self.special_structure,impl)
                if not os.path.isdir(dir_scan):
                    print('Error can not get the implementation directory:%s!!!'%dir_scan)
                    self.write_NA_all_report(self.design)
                    continue
            else:
                '''
                    This is the command case model
                '''
                dir_scan = ldf_path
            time_file = ''
            self.scan_time.reset_par_time_data()
            srr_file = get_unique_file([dir_scan, ".srr"])
            if not srr_file:
                srr_file = get_unique_file(dir_scan+ "/synthesis.log")
            if srr_file:
                self.scan_time.scan_srr(srr_file)
            mrp_file = get_unique_file([dir_scan, ".mrp"])
            if mrp_file:
                self.scan_mrp.scan_report(mrp_file)
                self.scan_time.scan_mrp(mrp_file)
                self.scan_mrp.scan_clocks(mrp_file)
                twr_file = get_unique_file(os.path.splitext(mrp_file)[0]+'.twr')
            else:
                twr_file = get_unique_file([dir_scan, ".twr"])
            par_file = get_unique_file([dir_scan, ".par"])

            if twr_file:
                self.scan_twr.scan_report(twr_file)
            self.scan_time.scan_report(time_file)
            if par_file:
                self.scan_time.scan_par(par_file)
            self.srr_data = self.scan_time.get_srr_time_data()
            self.mrp_data = self.scan_time.get_mrp_time_data()
            self.par_data = self.scan_time.get_par_time_data()
            self.real_cpu_total = self.scan_time.get_total_time()
            self.write_report()
            self.scan_twr.set_all_data()
            self.scan_time.reset_par_time_data()

    def scan_qor_report(self):
        '''
            This part just use for qor scan
        '''
        target_fmax_re = re.compile(r"Target_fmax_(.+)MHz")
        root_dir = os.getcwd()
        for design in self.all_designs:
            self.scan_mrp = tool_scan_radiant.ScanLatticeMrp()
            self.scan_twr = tool_scan_radiant.ScanLatticeTwr(self.pap,self.all_clk)
            self.scan_time = tool_scan_radiant.ScanLatticeTime()
            if self.need_design:
                if design == self.need_design:
                    pass
                else:
                    continue
            self.design = design
            print_always( 'scanning %s'%design)
            if type(self.special_structure)==list:
                if design.find('***')!= -1:
                    design,self.special_structure_temp = design.split('***')
                    self.design = design
                else:
                    self.special_structure_temp = self.special_structure[0]
            else:
                self.special_structure_temp = self.special_structure
            design_path = os.path.join(self.job_dir,design,self.special_structure_temp)# e60_ecp3/g64
            srr_file = ''
            if not os.path.isdir(design_path):
                self.write_NA_all_report(self.design)
                continue
            for dir in os.listdir(design_path): # dir:Target_Fmax_is_060MHz, get the srr file
                dir_scan = os.path.join(design_path,dir)
                if (not re.search("Target", dir)) and os.path.isdir(dir_scan) and not srr_file:
                    srr_file = get_unique_file([dir_scan, ".srr"])
                    if not srr_file:
                        srr_file = get_unique_file(dir_scan+ "/synthesis.log")
            find_target_dir = 0
            for dir in os.listdir(design_path): # dir:Target_Fmax_is_060MHz
                dir_scan = os.path.join(design_path,dir)
                #if (not re.search("Target", dir)) and os.path.isdir(dir_scan) and not srr_file:
                #    srr_file = get_unique_file([dir_scan, ".srr"])
                if re.search("Target_fmax", dir) and os.path.isdir(dir_scan) and (not dir.endswith('Failed')) :
                    pass
                else:
                    continue
                recover = RecoverPath(dir_scan)
                used_dir = ''
                for f_d in os.listdir(dir_scan):
                    f_d_full = os.path.join(dir_scan,f_d)
                    if os.path.isdir(f_d_full):
                        if used_dir:
                            print('Worning: There are two implementation in the design')
                        used_dir = f_d_full
                #srr_file = get_unique_file([used_dir, ".srr"])
                if not srr_file:
                    pass
                else:
                    srr_file = os.path.join(design_path,dir,srr_file)
                    self.scan_time.scan_srr(srr_file)
                mrp_file = get_unique_file([used_dir, ".mrp"])
                if not_exists(mrp_file, "map report file"):
                    continue
                self.scan_mrp.scan_report(mrp_file)
                self.scan_time.scan_mrp(mrp_file)
                twr_file = time_file = par_file= ""
                target_fmax_for_time = '_'
                #------------------------------------------------#
                if 1:
                     useful_dir = used_dir
                     base_name = os.path.basename(useful_dir)
                     self.scan_time.reset_par_time_data()
                     target_fmax_for_match = target_fmax_re.search(dir)
                     if target_fmax_for_match:
                         target_fmax_for_time = target_fmax_for_match.group(1)
                     twr_p = os.path.join(useful_dir,'*'+base_name+".twr")
                     twr_file = get_unique_file(twr_p)
                     if not twr_file:
                         twr_file = get_unique_file([useful_dir, ".twr"])
                     time_file = os.path.join(useful_dir, time_file)
                     par_file = get_unique_file([useful_dir, ".par"])
                     if twr_file:
                         self.scan_twr.scan_report(twr_file)
                         self.scan_time.scan_report(time_file)
                         self.scan_time.scan_par(par_file)
                         #########################
                         #time_title = ['design']+scan_time.get_title2()
                         srr_data = self.scan_time.get_srr_time_data()
                         mrp_data = self.scan_time.get_mrp_time_data()
                         par_data = self.scan_time.get_par_time_data()
                         real_cpu_total = self.scan_time.get_total_time()
                         all_time_data = dict(list(srr_data.items())+list(mrp_data.items())+list(par_data.items()) + list(real_cpu_total.items()) )
                         data_list = []
                         for key in self.scan_time.get_title():
                             value = all_time_data.get(key,'NA')
                             data_list.append(value)
                         data_list2 = [design]+[target_fmax_for_time] +data_list
                         append_file(self.report_file_time,",".join(data_list2))

                         #########################
                         #data = [design] + scan_mrp.get_data() + \
                         #      scan_twr.get_data() + data_list
                         if  self.force_NAN:
                             if all_time_data['Complete'] == 'NA' or all_time_data['Par_Done'] == 'NA':
                                 data_list = ['_']*len(self.scan_mrp.get_data()) +['_']*len(self.scan_twr.get_data()) +\
                                             ['_']*len(data_list)
                             else:
                                 data_list = self.scan_mrp.get_data() + \
                                   self.scan_twr.get_data() + data_list
                         else:
                                 data_list = self.scan_mrp.get_data() + \
                                   self.scan_twr.get_data() + data_list
                         self.for_bqs_data_f(all_time_data)
                         data = [design] + data_list
                         append_file(self.report_file, ",".join(data))
                         data = [design]
                         append_file(self.report_file_mrp,",".join([design]+ self.scan_mrp.get_data() ))
                         append_file(self.report_file_twr,",".join([design]+ self.scan_twr.get_data() ))
                         #append_file(report_file_time,",".join([design]+ scan_time.get_data()))
                         if self.all_clk:
                            all_clk_file = os.path.join( os.path.dirname(self.report_file_twr) , "all_clk.csv" )
                            if os.path.isfile(all_clk_file):
                                pass
                            else:
                                all_clk_titles =  ["Design","Target_Fmax_Dir","clkName", "targetFmax", "fmax"]

                                append_file(all_clk_file,",".join(all_clk_titles))
                            all_raw_data = self.scan_twr.get_all_data()
                            for all_raw_data_item in all_raw_data:
                                all_raw_data_line = design +","+ target_fmax_for_time+","+all_raw_data_item.get("clkName","NA")  \
                                                                +","+all_raw_data_item.get("targetFmax","NA")+","+all_raw_data_item.get("fmax","NA")
                                append_file(all_clk_file,all_raw_data_line)
                         self.scan_time.reset_par_time_data()
                     if not twr_file:
                         self.scan_time.scan_report(time_file)
                         self.scan_time.scan_par(par_file)
                         srr_data = self.scan_time.get_srr_time_data()
                         mrp_data = self.scan_time.get_mrp_time_data()
                         par_data = self.scan_time.get_par_time_data()
                         real_cpu_total = self.scan_time.get_total_time()
                         all_time_data = dict(list(srr_data.items())+list(mrp_data.items())+list(par_data.items()) + \
                                               list(real_cpu_total.items()) )
                         data_list = []
                         for key in self.scan_time.get_title():
                             value = all_time_data.get(key,'NA')
                             data_list.append(value)
                         data_list2 = [design]+[target_fmax_for_time] +data_list
                         append_file(self.report_file_time,",".join(data_list2))
                         self.for_bqs_data_f(all_time_data)
                         #data = [design] + scan_mrp.get_data()+ data_list
                         if  self.force_NAN:
                             if all_time_data['Complete'] == 'NA' or all_time_data['Par_Done'] == 'NA':
                                 data = [design] + ['_']*len(self.scan_mrp.get_data())+  ['_']*len(data_list)
                             else:
                                 data = [design] + self.scan_mrp.get_data()+ data_list
                         else:
                             data = [design] + self.scan_mrp.get_data()+ data_list
                         append_file(self.report_file, ",".join(data))
                         append_file(self.report_file_mrp,",".join([design]+ self.scan_mrp.get_data()))
                         self.scan_time.reset_par_time_data()
                self.scan_mrp.scan_clocks(mrp_file)
                clock_dict = self.scan_mrp.get_parse_line_clocks()
                for key in list(clock_dict.keys()):
                    line = design+','+key+','+clock_dict[key]
                    append_file(self.report_file_clock,line)
                find_target_dir = 1
                recover.run()
            self.scan_twr.set_all_data()
            if find_target_dir == 0:
                self.write_NA_all_report(self.design)
        os.chdir(root_dir)
        for f in self.report_file_list:
            #if self.job_dir == self.report_path: #this is the old way
            if 1:
                if os.path.isfile(f):
                    try:
                        file_sorted,note,design_fmax = report_sort.sort_csv(f,list_order=self.list_order,name_list=self.name_list,default_case_list=self.default_case_list)
                        report_sort.get_best_all_clk(file_sorted)
                        report_sort.write_note(file_sorted,note)
                    except:
                        pass
        if self.qor_auto:#write some log or bat file
            file_hand_pass = file('pass_case.log','w')
            #----------read fail case first:
            try:
                file_hand_fail = file('fail_case.log','r')
                fail_case_lines = file_hand_fail.readlines()
                file_hand_fail.close()
                fail_case_lines2 = [f_c.split(':')[0].strip() for f_c in fail_case_lines]
            except:
                fail_case_lines2 = []
            file_hand_fail = file('fail_case.log','w')
            for key in list(design_fmax.keys()):
                v = design_fmax[key]
                if re.search(r'\d',v):
                    file_hand_pass.write(key+'\n')
                else:
                    if key in fail_case_lines2:
                        fail_k = fail_case_lines[fail_case_lines2.index(key)]
                        file_hand_fail.write(fail_k.strip()+'\n')
                    else:
                        file_hand_fail.write(key+'\n')
            file_hand_pass.close()
            file_hand_fail.close()
            #----------------update run_stand-------------------#
            if 1:
                pass_log = glob.glob('pass_case.log')
                if pass_log:
                    pass_log = pass_log[0]
                else:
                    pass_log = '__'
                if os.path.isfile(pass_log):
                    file_hand = file(pass_log,'r')
                    lines = file_hand.readlines()
                    file_hand.close()
                    stand_name = glob.glob('*'+'_run_stand.bat')
                    if stand_name:
                        stand_name = stand_name[0]
                    #stand_name = os.path.join(top_base,top_base2+'_'+syn+'_run_standard.bat')
                    else:
                        stand_name = ''
                    run_standard = file(stand_name,'r')
                    run_standard_lines = run_standard.readlines()
                    run_standard_lines = list(set(run_standard_lines))
                    run_standard.close()
                    #--------------
                    try :
                        again_name = glob.glob('*'+'run_again.bat')
                        if again_name:
                            again_name = again_name[0]
                        #stand_name = os.path.join(top_base,top_base2+'_'+syn+'_run_standard.bat')
                        else:
                            again_name = ''
                        try:
                            again = file(again_name,'r')
                            again_lines = again.readlines()
                            again_lines = list(set(again_lines))
                            again.close()
                            replaced_job_dir = os.path.basename(os.getcwd())
                            again_lines = [re.sub(r'--job-dir=\S+','--job-dir='+replaced_job_dir,ag) for ag in again_lines]
                            new_again = []
                            #again_lines = [re.sub(r'--job-dir=\S+',replaced_job_dir,ag) for ag in again_lines]
                                #for ag in again_lines:
                            for ag in again_lines:
                                    file_f = re.findall('--file=(\S+)',ag)
                                    if file_f:
                                        new_f = os.path.basename(file_f[-1])
                                        ag = re.sub(r'--file=(\S+)','--file='+new_f,ag)
                                    new_again.append(ag)

                            run_standard_lines1 = run_standard_lines + new_again
                            run_standard_lines1 = list(set(run_standard_lines1))
                        except:
                            run_standard_lines1 = list(set(run_standard_lines))
                            #pass

                        #run_standard_lines = run_standard_lines + again_lines
                    except:
                        pass


                    useful_lines = []
                    for case in lines:
                        case = case.strip()
                        if not case:
                             continue
                        else:
                             pass
                        case_tab = '--design='+case
                        case_tab_re = re.compile(case_tab+r'(\s+|$)')
                        for line in run_standard_lines1:
                            line = line.strip()
                            if not line:
                                continue
                            if case_tab_re.search(line):
                                try:
                                    fmax = float( design_fmax[case.strip()] )
                                    fmax = str( int( fmax ))
                                    line = re.sub(r'--fmax-sweep=[\s\d]+\d','',line)
                                    line2 = line + ' --fmax-sweep='+fmax+' '+fmax+' '+'10 \n'
                                    useful_lines.append(line2)
                                except:
                                    #line2 = line
                                    pass


                    run_standard = file(stand_name,'w')
                    run_standard.writelines(useful_lines)
                    run_standard.close()

            if 1:  # write run_again.bat
                fail_log = glob.glob('fail_case.log')
                if fail_log:
                    fail_log = fail_log[0]
                else:
                    fail_log = '__'
                if os.path.isfile(fail_log):
                    file_hand = file(fail_log,'r')
                    lines = file_hand.readlines()
                    lines = list(set(lines))
                    file_hand.close()
                    if 1:
                        if not run_standard_lines:
                            stand_name = glob.glob('*'+'_run_stand.bat')
                            if stand_name:
                                stand_name = stand_name[0]
                            #stand_name = os.path.join(top_base,top_base2+'_'+syn+'_run_standard.bat')
                            else:
                                stand_name = ''
                            try:
                                run_standard = file(stand_name,'r')
                                run_standard_lines = run_standard.readlines()
                                run_standard_lines = list(set(run_standard_lines))
                                run_standard.close()
                            except:
                                run_standard_lines = []
                        replaced_job_dir = str(os.path.abspath(os.getcwd()))
                        replaced_job_dir = re.sub(r'\\','/',replaced_job_dir)
                        run_standard_lines = [re.sub(r'--job-dir=\S+',r'--job-dir='+replaced_job_dir,ag) for ag in run_standard_lines]
                        new_again = []
                        for ag in run_standard_lines:
                                file_f = re.findall('--file=(\S+)',ag)
                                if file_f:
                                    new_f = '--file='+'../'+file_f[-1]
                                    ag = re.sub(r'--file=(\S+)',new_f,ag)
                                new_again.append(ag)
                        run_standard_lines = new_again
                        try:
                            again_name = glob.glob('*'+'run_again.bat')
                            if again_name:
                                again_name = again_name[0]
                            #stand_name = os.path.join(top_base,top_base2+'_'+syn+'_run_standard.bat')
                            else:
                                again_name = ''
                            again = file(again_name,'r')
                            again_lines = again.readlines()
                            again_lines = list(set(again_lines))
                            again.close()
                            run_standard_lines = run_standard_lines + again_lines
                        except:
                            pass
                    useful_lines = []
                    for case in lines:
                        case = case.strip()
                        if not case:
                             continue
                        else:
                             pass
                        case_tab = '--design='+case
                        case_tab_re = re.compile(case_tab+r'(\s+|$)')
                        for line in run_standard_lines:
                            line = line.strip()
                            if not line:
                                continue
                            if case_tab_re.search(line):

                                try:
                                    line2 = line+'\n'
                                    useful_lines.append(line2)
                                    #fmax = float( design_fmax[case.strip()] )
                                    #fmax = str( int( fmax ))
                                    #line = case_tab_re.sub('',line)
                                    #line = re.sub(r'--fmax-sweep=[\s\d]+\d','',line)
                                    #line2 = line + ' --fmax-sweep='+fmax+' '+fmax+' '+'10 \n'
                                except:
                                    pass
                                    #pass


                    run_standard = file('run_again.bat','w')
                    run_standard.writelines(useful_lines)
                    run_standard.close()

    def scan_multi_seed_report(self):
        '''
           This part used for scan mutli seed cases
        '''
        root_dir = os.getcwd()
        target_fmax_re = re.compile(r"Target_seed_(.+)")
        for design in self.all_designs:
            self.scan_mrp = tool_scan_radiant.ScanLatticeMrp()
            self.scan_twr = tool_scan_radiant.ScanLatticeTwr(self.pap)
            self.scan_time = tool_scan_radiant.ScanLatticeTime()
            if self.need_design:
                if design == self.need_design:
                    pass
                else:
                    continue
            self.design = design
            print_always( 'scanning %s'%design)
            design_path = os.path.join(self.job_dir,design,self.special_structure)# e60_ecp3/g64
            srr_file = ''
            find_target_case = 0
            if not os.path.isdir(design_path):
                self.write_NA_all_report(design)
                continue
            for dir in os.listdir(design_path): # dir:Target_Fmax_is_060MHz
                dir_scan = os.path.join(design_path,dir)
                if (not re.search("Target", dir)) and os.path.isdir(dir_scan) and (not srr_file):
                    srr_file = get_unique_file([dir_scan, ".srr"])
                if target_fmax_re.search(dir_scan) and os.path.isdir(dir_scan) and (not dir.endswith('Failed')) :
                    pass
                else:
                    continue
                recover = RecoverPath(dir_scan)
                used_dir = ''
                #-------
                #used_dir = dir_scan
                for f_d in os.listdir(dir_scan):
                    f_d_full = os.path.join(dir_scan,f_d)
                    if os.path.isdir(f_d_full):
                        if used_dir:
                            print('Warning: There are two implementation in the design')
                        used_dir = f_d_full
                #-------------
                if not srr_file:
                    pass
                else:
                    srr_file = os.path.join(design_path,dir,srr_file)
                    self.scan_time.scan_srr(srr_file)
                print(used_dir)
                mrp_file = get_unique_file([used_dir, ".mrp"])
                if not_exists(mrp_file, "map report file"):
                    print(os.path.dirname(used_dir))
                    print(111111111)
                    continue
                self.scan_mrp.scan_report(mrp_file)
                self.scan_time.scan_mrp(mrp_file)
                twr_file = time_file = par_file= ""
                target_fmax_for_time = '_'
                #------------------------------------------------#
                if 1:
                     used_for_par = used_dir
                     #useful_dir = os.path.dirname(used_dir)
                     useful_dir = used_dir
                     base_name = os.path.basename(useful_dir)
                     self.scan_time.reset_par_time_data()
                     target_fmax_for_match = target_fmax_re.search(dir)
                     if target_fmax_for_match:
                         target_fmax_for_time = target_fmax_for_match.group(1)
                     twr_p = os.path.join(useful_dir,'*'+base_name+".twr")
                     twr_file = get_unique_file(twr_p)
                     if not twr_file:
                         twr_file = get_unique_file([useful_dir, ".twr"])
                     time_file = os.path.join(useful_dir, time_file)
                     par_file = get_unique_file([used_for_par, ".par"])

                     if twr_file:
                         self.scan_twr.scan_report(twr_file)
                         self.scan_time.scan_report(time_file)
                         self.scan_time.scan_par(par_file)
                         #########################
                         srr_data = self.scan_time.get_srr_time_data()
                         mrp_data = self.scan_time.get_mrp_time_data()
                         par_data = self.scan_time.get_par_time_data()
                         real_cpu_total = self.scan_time.get_total_time()
                         all_time_data = dict(list(srr_data.items())+list(mrp_data.items())+list(par_data.items()) + list(real_cpu_total.items()) )
                         data_list = []
                         for key in self.scan_time.get_title():
                             value = all_time_data.get(key,'NA')
                             data_list.append(value)
                         data_list2 = [design]+[target_fmax_for_time] +data_list
                         append_file(self.report_file_time,",".join(data_list2))

                         #########################
                         #data = [design] + scan_mrp.get_data() + \
                         #      scan_twr.get_data() + data_list
                         if  self.force_NAN:
                             if all_time_data['Complete'] == 'NA' or all_time_data['Par_Done'] == 'NA':
                                 data_list = ['_']*len(self.scan_mrp.get_data()) +['_']*len(self.scan_twr.get_data()) +\
                                             ['_']*len(data_list)
                             else:
                                 data_list = self.scan_mrp.get_data() + \
                                   self.scan_twr.get_data() + data_list
                         else:
                             data_list = self.scan_mrp.get_data() + \
                               self.scan_twr.get_data() + data_list
                         self.for_bqs_data_f(all_time_data)
                         data = [design] + data_list
                         append_file(self.report_file, ",".join(data))
                         data = [design]
                         append_file(self.report_file_mrp,",".join([design]+ self.scan_mrp.get_data() ))
                         append_file(self.report_file_twr,",".join([design]+ self.scan_twr.get_data() ))
                         #append_file(report_file_time,",".join([design]+ scan_time.get_data()))
                         self.scan_time.reset_par_time_data()
                     if not twr_file:
                         srr_data = self.scan_time.get_srr_time_data()
                         mrp_data = self.scan_time.get_mrp_time_data()
                         par_data = self.scan_time.get_par_time_data()
                         real_cpu_total = self.scan_time.get_total_time()
                         all_time_data = dict(list(srr_data.items())+list(mrp_data.items())+list(par_data.items()) + \
                                               list(real_cpu_total.items()) )
                         data_list = []
                         for key in self.scan_time.get_title():
                             value = all_time_data.get(key,'NA')
                             data_list.append(value)
                         data_list2 = [design]+[target_fmax_for_time] +data_list
                         append_file(self.report_file_time,",".join(data_list2))
                         #data = [design] + scan_mrp.get_data()+ data_list
                         if all_time_data['Complete'] == 'NA' or all_time_data['Par_Done'] == 'NA':
                             data = [design] + ['_']*len(self.scan_mrp.get_data())+  ['_']*len(data_list)
                         else:
                             data = [design] + self.scan_mrp.get_data()+ data_list
                         self.for_bqs_data_f(all_time_data)

                         append_file(self.report_file, ",".join(data))
                         append_file(self.report_file_mrp,",".join([design]+ self.scan_mrp.get_data()))
                         self.scan_time.reset_par_time_data()
                self.scan_mrp.scan_clocks(mrp_file)
                clock_dict = self.scan_mrp.get_parse_line_clocks()
                for key in list(clock_dict.keys()):
                    line = design+','+key+','+clock_dict[key]
                    append_file(self.report_file_clock,line)
                find_target_case = 1
                recover.run()
            self.scan_twr.set_all_data()
            if find_target_case == 0:
                self.write_NA_all_report(design)
        os.chdir(root_dir)
        for f in self.report_file_list:
            #if self.job_dir == self.report_path:
                if os.path.isfile(f):
                    file_sorted,note,design_fmax = report_sort.sort_csv(f,list_order=self.list_order,name_list=self.name_list,default_case_list=self.default_case_list)
                    report_sort.write_note(file_sorted,note)

    def scan_multi_seed_DSP_report(self):
        '''
           This part used for scan mutli seed DSP cases
        '''
        root_dir = os.getcwd()
        target_fmax_re = re.compile(r"Target_seed_(.+)")
        clk_conf = os.path.join(os.path.dirname(__file__),'xlib','dsp_clk.conf')
        design_clk = xConf.get_conf_options(clk_conf,False).get('dsp_clk',{})
        if not design_clk:
            print('Error, can get design clock configure')
            return
        for design in self.all_designs:
            self.scan_mrp = tool_scan_radiant.ScanLatticeMrp()
            self.scan_twr = tool_scan_radiant.ScanLatticeTwr(self.pap)
            self.scan_time = tool_scan_radiant.ScanLatticeTime()
            if self.need_design:
                if design == self.need_design:
                    pass
                else:
                    continue
            print_always( 'scanning %s'%design)
            design_path = os.path.join(self.job_dir,design,self.special_structure)# e60_ecp3/g64
            srr_file = ''
            find_case_target = 0
            if not os.path.isdir(design_path):
                self.write_NA_all_report(design)
                continue
            for dir in os.listdir(design_path): # dir:Target_Fmax_is_060MHz
                dir_scan = os.path.join(design_path,dir)
                if (not re.search("Target", dir)) and os.path.isdir(dir_scan) and (not srr_file):
                    srr_file = get_unique_file([dir_scan, ".srr"])
                if target_fmax_re.search(dir_scan) and os.path.isdir(dir_scan) and (not dir.endswith('Failed')) :
                    pass
                else:
                    continue
                recover = RecoverPath(dir_scan)
                used_dir = ''
                #-------
                #used_dir = dir_scan
                for f_d in os.listdir(dir_scan):
                    f_d_full = os.path.join(dir_scan,f_d)
                    if os.path.isdir(f_d_full):
                        if used_dir:
                            print('Warning: There are two implementation in the design')
                        used_dir = f_d_full
                #-------------
                if not srr_file:
                    pass
                else:
                    srr_file = os.path.join(design_path,dir,srr_file)
                    self.scan_time.scan_srr(srr_file)
                mrp_file = get_unique_file([os.path.dirname(used_dir), ".mrp"])
                if not_exists(mrp_file, "map report file"):
                    continue
                self.scan_mrp.scan_report(mrp_file)
                self.scan_time.scan_mrp(mrp_file)
                twr_file = time_file = par_file= ""
                target_fmax_for_time = '_'
                #------------------------------------------------#
                if 1:
                     useful_dir = used_dir
                     base_name = os.path.basename(useful_dir)
                     self.scan_time.reset_par_time_data()
                     target_fmax_for_match = target_fmax_re.search(dir)
                     if target_fmax_for_match:
                         target_fmax_for_time = target_fmax_for_match.group(1)
                     twr_p = os.path.join(useful_dir,'*'+base_name+".twr")
                     twr_file = get_unique_file(twr_p)
                     if not twr_file:
                         twr_file = get_unique_file([os.path.dirname(useful_dir), ".twr"])
                     time_file = os.path.join(useful_dir, time_file)
                     par_file = get_unique_file([useful_dir, ".par"])
                     clk_name = ''
                     design_clk_keys = list(design_clk.keys())
                     design_clk_keys.sort()
                     print(design)
                     self.design = design
                     for k in design_clk_keys:
                        if design.startswith(k):
                            clk_name = design_clk.get(k,'')
                     if not clk_name:
                        clk_name = design_clk.get('default','')
                     if twr_file:
                         self.scan_twr.scan_report(twr_file,clk_name)
                         self.scan_time.scan_report(time_file)
                         self.scan_time.scan_par(par_file)
                         #########################
                         srr_data = self.scan_time.get_srr_time_data()
                         mrp_data = self.scan_time.get_mrp_time_data()
                         par_data = self.scan_time.get_par_time_data()
                         real_cpu_total = self.scan_time.get_total_time()
                         all_time_data = dict(list(srr_data.items())+list(mrp_data.items())+list(par_data.items()) + list(real_cpu_total.items()) )
                         data_list = []
                         for key in self.scan_time.get_title():
                             value = all_time_data.get(key,'NA')
                             data_list.append(value)
                         data_list2 = [design]+[target_fmax_for_time] +data_list
                         append_file(self.report_file_time,",".join(data_list2))

                         #########################
                         #data = [design] + scan_mrp.get_data() + \
                         #      scan_twr.get_data() + data_list
                         if all_time_data['Complete'] == 'NA' or all_time_data['Par_Done'] == 'NA':
                             data_list = ['_']*len(self.scan_mrp.get_data()) +['_']*len(self.scan_twr.get_data()) +\
                                         ['_']*len(data_list)
                         else:
                             data_list = self.scan_mrp.get_data() + \
                               self.scan_twr.get_data() + data_list
                         self.for_bqs_data_f(all_time_data)
                         data = [design] + data_list
                         append_file(self.report_file, ",".join(data))
                         data = [design]
                         append_file(self.report_file_mrp,",".join([design]+ self.scan_mrp.get_data() ))
                         append_file(self.report_file_twr,",".join([design]+ self.scan_twr.get_data() ))
                         #append_file(report_file_time,",".join([design]+ scan_time.get_data()))
                         self.scan_time.reset_par_time_data()
                     if not twr_file:
                         self.scan_time.scan_report(time_file)
                         self.scan_time.scan_par(par_file)
                         srr_data = self.scan_time.get_srr_time_data()
                         mrp_data = self.scan_time.get_mrp_time_data()
                         par_data = self.scan_time.get_par_time_data()
                         real_cpu_total = self.scan_time.get_total_time()
                         all_time_data = dict(list(srr_data.items())+list(mrp_data.items())+list(par_data.items()) + \
                                               list(real_cpu_total.items()) )
                         data_list = []
                         for key in self.scan_time.get_title():
                             value = all_time_data.get(key,'NA')
                             data_list.append(value)
                         data_list2 = [design]+[target_fmax_for_time] +data_list
                         append_file(self.report_file_time,",".join(data_list2))
                         #data = [design] + scan_mrp.get_data()+ data_list
                         if all_time_data['Complete'] == 'NA' or all_time_data['Par_Done'] == 'NA':
                             data = [design] + ['_']*len(self.scan_mrp.get_data())+ ['_']*len(self.scan_twr.get_data())+ ['_']*len(data_list)
                         else:
                             data = [design] + self.scan_mrp.get_data()+self.scan_twr.get_data()+ data_list
                         self.for_bqs_data_f(all_time_data)
                         append_file(self.report_file, ",".join(data))
                         append_file(self.report_file_mrp,",".join([design]+ self.scan_mrp.get_data()))
                         self.scan_time.reset_par_time_data()
                self.scan_mrp.scan_clocks(mrp_file)
                clock_dict = self.scan_mrp.get_parse_line_clocks()
                for key in list(clock_dict.keys()):
                    line = design+','+key+','+clock_dict[key]
                    append_file(self.report_file_clock,line)
                find_case_target = 1
                recover.run()
            if find_case_target == 0:
                self.write_NA_all_report(design)
            self.scan_twr.set_all_data()
        os.chdir(root_dir)
        for f in self.report_file_list:
                if os.path.isfile(f):
                    file_sorted,note,design_fmax = report_sort.sort_csv(f,list_order=self.list_order,add_average=1,name_list=self.name_list,default_case_list=self.default_case_list)
                    report_sort.write_note(file_sorted,note)

    def process_report(self,conf_file,report_file,new_name=''):
        if os.path.isfile(conf_file):
            pass
        else:
            print('Error: can find file:%s'%conf_file)
            return
        if os.path.isfile(report_file):
            pass
        else:
            print('Error: can find file:%s'%report_file)
            return
        source_list = file(conf_file).readlines()
        source_list = source_list + ['Design']
        s_new = []
        for s in source_list:
            s = s.strip()
            if not s:
                continue
            else:
                s_new.append(s)
        s_new = list(set(s_new))
        report_list = file(report_file).readlines()
        note_lines = []
        for l in report_list:
            if l.startswith('Design'):
                title = l
                break
            else:
                note_lines.append(l)
        title_list = title.split(',')
        title_list = [t.strip() for t in title_list]
        id_list = []
        for id1,t in enumerate(title_list):
            if t in s_new:
                id_list.append(id1)
            else:
                pass
        new_lines = []
        start_flag = 0
        for line in report_list:
            if line.startswith('Design') or start_flag == 1:
                start_flag = 1;
            else:
                continue
            line_list = line.split(',')
            add_line  = ''
            for t in id_list:
                temp_t = ''
                try:
                    temp_t = line_list[t]
                except:
                    pass
                add_line = add_line + ','+ temp_t
            add_line = add_line[1:]+'\n'
            new_lines.append(add_line)
        if not new_name:
            new_report = os.path.basename(report_file)
            new_report = 'source_list_'+new_report
        else:
            new_report = os.path.basename(new_name)
        new_report = os.path.join(os.path.dirname(report_file),new_report)
        file_hand = file(new_report,'w')
        if note_lines:
            for l in note_lines:
                file_hand.write(l)
        file_hand.writelines(new_lines)
        file_hand.close()
    def process_report_sort(self,conf_file,report_file):
        self.process_report(conf_file,report_file)
        report_file_sorted = os.path.splitext(report_file)[0] + '_sorted'+'.csv'
        if os.path.isfile(report_file_sorted):
            self.process_report(conf_file,report_file_sorted,new_name=os.path.basename(report_file_sorted))
            #self.process_report(conf_file,report_file_sorted,new_name='22.csv')

if __name__=='__main__':
    a = scan_general_case()
    a.scan_report()