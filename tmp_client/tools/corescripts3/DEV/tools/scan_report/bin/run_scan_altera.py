#! C:\Python25\python.exe
#===================================================
# Owner    : Yzhao1
# Function :
#           This file is used for scan_report for alter
#           As there are many differences between us and alter, there is no need to run push-button again.
#           At here, we just support the the fmax/seed model.
#           
# Attention:
#           
#           
# Date     :2015/2/26
#===================================================
import optparse
import os
import sys
import re,glob
scan_report_dir = os.path.join(os.path.dirname(__file__),'..','tools','scan_tools')
scan_report_dir = os.path.abspath(scan_report_dir)
if scan_report_dir in sys.path:
    pass
else:
    sys.path.append(scan_report_dir)
import tool_scan_altera
from .xlib import xFamily
from xOS import not_exists, wrap_copy_file, wrap_move_dir,get_unique_file,RecoverPath,get_unique_file
from xLog import print_always
from xTools import append_file
from .xlib import report_sort
def option():
    _family = xFamily.get_family_by_vendor('altera')
    _syn_dict = dict(lattice=("synp", "lse"), altera=("synp", "qis"), xilinx=("synp", "xst"), cube=("synp", "lse"))
    _synthesis = _syn_dict.get('altera') 
    public_group=optparse.OptionParser() 
    #public_group.add_option("--top-dir", help="specify top source path")
    public_group.add_option("--job-dir", default=os.getcwd(), help="specify job working path")
    public_group.add_option("--special-structure", default="_scratch", help="specify tag name for results file")
    #public_group.add_option("--synthesis", type="choice", default="synp", choices=_synthesis,help="specify synthesis name")
    public_group.add_option("--design", help="specify design name")
    #public_group.add_option("--family", type="choice", choices=_family, help="specify family name")
    #public_group.add_option("--pap", action="store_true", help="dump Lattice Performance Achievement Percentage data")
    public_group.add_option("--report-name", default='report.csv',help="specify report_name you want to store")
    public_group.add_option("--report-path", help="specify the report path")
    opt,args=public_group.parse_args() 
    return opt
def scan_report():
    opt = option()
    scanner = (tool_scan_altera.ScanAlteraFit(), tool_scan_altera.ScanAlteraFmax())
    job_dir = opt.job_dir
    if not os.path.isdir(job_dir):
        print('Error, can not get directory:%s'%job_dir)
        return -1
    design = opt.design
    tag = opt.special_structure
    report_name = opt.report_name #this is useless now
    if report_name == 'report.csv':
        report_file = os.path.basename(job_dir)+'.csv'
    report_path = opt.report_path
    if not report_path:
        report_path = job_dir
    report_file = os.path.join(report_path,report_file)
    scan_fit = tool_scan_altera.ScanAlteraFit()
    scan_fmax =  tool_scan_altera.ScanAlteraFmax()
    scan_time_mem = tool_scan_altera.ScanTimeMem()
    all_designs = []
    if not design:
        if os.path.isdir(job_dir):
            pass
        else:
            print('The job_dir:%s is not a directory'%job_dir)
            return
        for dir in os.listdir(job_dir):  # get all the design path
            dir2 =  os.path.join(job_dir,dir)
            if os.path.isdir(dir2):
                all_designs.append(dir)
            else:
                pass
    else:
        all_designs.append(design)
    report_file_list = []
    if 1:
        root_dir = os.getcwd()
        title = ["Design"]
        for item in (scan_fit,scan_fmax,scan_time_mem): #mrp twr time
            title += item.get_title()
        append_file(report_file, ",".join(title))
        global_title = title
        for design in all_designs:
            print_always( 'scanning %s'%design)
            design_path = os.path.join(job_dir,design)
            for dir in os.listdir(design_path): #at here dir should be as "_cyclone4_syn"
                if dir == tag:
                    #####################
                    scanner = (scan_fit, scan_fmax,scan_time_mem)
                    
                    report_file_list.append(report_file)
                    if not_exists(report_file):
                        append_file(report_file, ",".join(global_title))
                    if 1:
                        report_name,subtex = os.path.splitext(report_file)
                        report_file_fit = report_name+'_fit'+subtex
                        if not_exists(report_file_fit):
                            title = ["Design"]
                            #for item in scanner: #mrp twr time
                            title += (scanner[0]).get_title()
                            append_file(report_file_fit, ",".join(title))
                        report_file_sta = report_name+'_sta'+subtex
                        if not_exists(report_file_sta):
                            title = ["Design"]
                            #for item in scanner: #mrp twr time
                            title += (scanner[1]).get_title()
                            append_file(report_file_sta, ",".join(title))
                        report_file_time_mem = report_name+'_time_mem'+subtex
                        if not_exists(report_file_time_mem):
                            title = ["Design"]
                            title += (scanner[2]).get_title()
                            append_file(report_file_time_mem, ",".join(title))  
                ######################
                    dir_scan = os.path.join(design_path,dir)
                    recover = RecoverPath(dir_scan) 
                    fit_file = sta_file = map_file = srr_file =  ""
                    
                    if 'rev_1' in os.listdir('.'): # this part used to scan srr if run synthesis with synpro
                        scan_time_mem.reset()
                        foo = os.path.join(dir_scan,'rev_1')
                        srr_file = get_unique_file(foo+'/'+'*.srr')
                        if srr_file:
                            scan_time_mem.scan_srr(srr_file)
                    
                    for foo in os.listdir("."):
                        data = []
                        if os.path.isdir(foo):
                            if re.search("Target", foo):
                                scan_fit.reset()
                                scan_fmax.reset()
                                scan_time_mem.set_fit_data()
                                scan_time_mem.set_map_data()
                                print_always("  Scanning %s" % foo)
                                fit_file = get_unique_file(foo+'/'+"*.fit.rpt")
                                sta_file = get_unique_file(foo+'/'+"*.sta.rpt")
                                map_file = get_unique_file(foo+'/'+'*.map.rpt')
                                if fit_file:
                                    scan_fit.scan_report(fit_file)
                                    #raw_input(1)
                                    scan_time_mem.scan_fit(fit_file)
                                    #raw_input(2)
                                    data1=[design]+scan_fit.get_data()
                                    append_file(report_file_fit, ",".join(data1))
                                    data = data + data1
                                else:
                                    data1=[design]+['NA']*len(scan_fit.get_title() )
                                    data = data + data1
                                    print('AA')
                                if sta_file:
                                    scan_fmax.scan_report(sta_file)
                                    #raw_input(3)
                                    data2=[design]+scan_fmax.get_data()
                                    append_file(report_file_sta, ",".join(data2))
                                    data = data + data2[1:]
                                else:
                                    data1=['NA']*len(scan_fmax.get_title() )
                                    data = data + data1
                                if map_file:
                                    scan_time_mem.scan_map(map_file)
                                    #raw_input(4)
                                    scan_t_m = scan_time_mem.get_data()
                                    append_file(report_file_time_mem, ",".join([design]+scan_t_m))
                                    data  = data + scan_t_m
                                else:
                                    data1=['NA']*len(scan_time_mem.get_title() )
                                    data = data + data1
                                append_file(report_file, ",".join(data))
                                for_bqs_data = '<scan_case>\n'
                                for id1, t in enumerate( global_title):
                                    for_bqs_data = for_bqs_data + "\t<%s>"%t+data[id1]+"</%s>\n"%t
                                for_bqs_data = for_bqs_data +"</scan_case>"
                                print('#BQS_RETRN_DATA_BEGIN#')
                                print(for_bqs_data)
                                print('#BQS_RETRN_DATA_END#')
                    recover.run()
        os.chdir(root_dir) 
    #report_file_list = []    
    for f in report_file_list:
        if os.path.isfile(f):
            file_sorted,note,design_fmax = report_sort.sort_csv(f)
            report_sort.write_note(file_sorted,note)
    #----------------update run_stand-------------------#
    if 0:
        pass_log = glob.glob('*'+syn+'_pass_case.log')
        if pass_log:
            pass_log = pass_log[0]
        else:
            pass_log = '__'
        if os.path.isfile(pass_log):
            file_hand = file(pass_log,'r')
            lines = file_hand.readlines()
            file_hand.close()
            stand_name = glob.glob('*'+syn+'_run_standard.bat')
            if stand_name:
                stand_name = stand_name[0]
            #stand_name = os.path.join(top_base,top_base2+'_'+syn+'_run_standard.bat')
            else:
                stand_name = ''
            run_standard = file(stand_name,'r')
            run_standard_lines = run_standard.readlines()
            run_standard.close()
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
                            fmax = float( design_fmax[case.strip()] )
                            fmax = str( int( fmax ))
                        #line = case_tab_re.sub('',line)
                            line = re.sub(r'--fmax-sweep=[\s\d]+\d','',line)
                            line2 = line + ' --fmax-sweep='+fmax+' '+fmax+' '+'10 \n'
                        except:
                            line2 = line
                        
                        useful_lines.append(line2)
            run_standard = file(stand_name,'w')
            run_standard.writelines(useful_lines)
            run_standard.close()
        

if __name__=='__main__':
    scan_report()