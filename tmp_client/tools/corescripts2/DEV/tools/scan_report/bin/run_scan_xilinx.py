#! C:\Python25\python.exe
#===================================================
# Owner    : Yzhao1
# Function :
#           This file is used for scan_report for Xilinx
#           
# Attention:
#           
#           
# Date     :2013/2/5
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
import tool_scan_xilinx
from xlib import xFamily
from xOS import not_exists, wrap_copy_file, wrap_move_dir,get_unique_file,RecoverPath,get_unique_file
from xLog import print_always
from xTools import append_file
from xlib import report_sort

def option():
    _family = xFamily.get_family_by_vendor('xilinx')
    _syn_dict = dict(lattice=("synp", "lse"), altera=("synp", "qis"), xilinx=("synp", "xst"), cube=("synp", "lse"))
    _synthesis = _syn_dict.get('xilinx') 
    public_group=optparse.OptionParser() 
    #public_group.add_option("--top-dir", help="specify top source path")
    public_group.add_option("--job-dir", default=os.getcwd(), help="specify job working path")
    public_group.add_option("--special-structure", default="_scratch", help="specify tag name for results file")
    #public_group.add_option("--synthesis", type="choice", default="synp", choices=_synthesis,help="specify synthesis name")
    public_group.add_option("--design", help="specify design name")
    #public_group.add_option("--family", type="choice", choices=_family, help="specify family name")
    #public_group.add_option("--pap", action="store_true", help="dump Lattice Performance Achievement Percentage data")
    #public_group.add_option("--report-name", default='report.csv',help="specify report_name you want to store")
    public_group.add_option("--report-name", default='report.csv',help="specify report_name you want to store")
    public_group.add_option("--report-path", help="specify the report path")
    opt,args=public_group.parse_args() 
    return opt
def scan_report():
    opt = option()
    job_dir = opt.job_dir
    design = opt.design
    scan_mrp = tool_scan_xilinx.ScanXilinxMrp()
    scan_twr = tool_scan_xilinx.ScanXilinxTwr()
    scan_time = tool_scan_xilinx.ScanXilinxTimeMem()
    scan_timing_rpt = tool_scan_xilinx.ScanXilinxTimingRpt()
    scan_placed_rpt = tool_scan_xilinx.ScanXilinxPlacedRpt()
    tag = opt.special_structure
    report_name = opt.report_name #this is useless now
    if report_name == 'report.csv':
        report_file = os.path.basename(job_dir)+'.csv'
    report_path = opt.report_path
    if not report_path:
        report_path = job_dir
    report_file = os.path.join(report_path,report_file)
    all_designs = []
    if os.path.isdir(job_dir):
        pass
    else:
        print 'The job_dir:%s is not a directory'%job_dir
        return
    if not design:
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
        for design in all_designs:
            print_always( 'scanning %s'%design)
            design_path = os.path.join(job_dir,design,tag)
            for dir in os.listdir(design_path):
                if dir.endswith('.runs') and os.path.isdir(os.path.join(design_path,dir)):
                    #####################
                    scanner = (scan_mrp, scan_twr, scan_time)
                    report_file_list.append(report_file)
                    
                ######################
                    dir_scan = os.path.join(design_path,dir)
                    twr_file = time_file = ""
                    if 'rev_1' in os.listdir(dir_scan):
                        scan_time.set_srr_data()
                        foo = os.path.join(dir_scan,'rev_1','*.srr')
                        srr_file = get_unique_file(foo)
                        if srr_file:
                            scan_time.scan_srr(srr_file)
                            
                    for foo in os.listdir(dir_scan):
                        if os.path.isdir( os.path.join(design_path,dir,foo) ):
                            if re.search("Target", foo): # this is ISE
                                recover = RecoverPath(os.path.join(design_path,dir,foo))
                                scan_mrp.reset()
                                #scan_time.reset()
                                scan_time.set_map_data()
                                scan_time.set_par_data()
                                scan_twr.reset()
                                print_always("  Scanning %s" % foo)
                                _project_name = "%s_%s" % (dir, design[:7])
                                project_name = _project_name.strip("_")
                                mrp_file = os.path.join(dir_scan,foo,project_name + "_map.mrp")
                                if os.path.isfile(mrp_file):
                                    if not_exists(report_file):
                                        title = ["Design"]
                                        for item in scanner: #mrp twr time
                                            title += item.get_title()
                                        append_file(report_file, ",".join(title))
                                    if 1:
                                        report_name,subtex = os.path.splitext(report_file)
                                        report_file_mrp = report_name+'_mrp'+subtex
                                        if not_exists(report_file_mrp):
                                            title = ["Design"]
                                            #for item in scanner: #mrp twr time
                                            title += (scanner[0]).get_title()
                                            append_file(report_file_mrp, ",".join(title))
                                        report_file_twr = report_name+'_twr'+subtex
                                        if not_exists(report_file_twr):
                                            title = ["Design"]
                                            #for item in scanner: #mrp twr time
                                            title += (scanner[1]).get_title()
                                            append_file(report_file_twr, ",".join(title))
                                        report_file_time = report_name+'_time_mem'+subtex
                                        if not_exists(report_file_time):
                                            title = ["Design"]
                                            #for item in scanner: #mrp twr time
                                            title += (scanner[2]).get_title()
                                            append_file(report_file_time, ",".join(title))
                                
                                    scan_mrp.scan_report(mrp_file)
                                    scan_time.scan_map(mrp_file)
                                    par_file = os.path.join(dir_scan,foo,project_name + ".par")
                                    scan_time.scan_par(par_file)
                                    twr_file = os.path.join(dir_scan,foo,project_name + ".twr")
                                    scan_twr.scan_report(twr_file)
                                    #time_file = os.path.join(dir_scan,foo,"mpar_log.time")
                                    #scan_time.scan_report(time_file)
                                    data1 = scan_mrp.get_data()
                                    append_file(report_file_mrp, ",".join([design]+data1))
                                    data2 = scan_twr.get_data()
                                    append_file(report_file_twr, ",".join([design]+data2))
                                    data3 = scan_time.get_data()
                                    append_file(report_file_time, ",".join([design]+data3))
                                    data = data1 + data2+ data3
                                    append_file(report_file, ",".join([design]+data))
                                
                                #for vivado
                                if not os.path.isfile(twr_file):
                                    if 1:
                                        title = ["Design"]
                                        for item in [scan_timing_rpt,scan_placed_rpt]: #mrp twr time
                                            title += item.get_title()
                                        if not_exists(report_file):
                                            append_file(report_file, ",".join(title))
                                        if 0:
                                            report_name,subtex = os.path.splitext(report_file)
                                            report_file_mrp = report_name+'_mrp'+subtex
                                            if not_exists(report_file_mrp):
                                                title = ["Design"]
                                                #for item in scanner: #mrp twr time
                                                title += (scanner[0]).get_title()
                                                append_file(report_file_mrp, ",".join(title))
                                            report_file_twr = report_name+'_twr'+subtex
                                            if not_exists(report_file_twr):
                                                title = ["Design"]
                                                #for item in scanner: #mrp twr time
                                                title += (scanner[1]).get_title()
                                                append_file(report_file_twr, ",".join(title))
                                            report_file_time = report_name+'_time_mem'+subtex
                                            if not_exists(report_file_time):
                                                title = ["Design"]
                                                #for item in scanner: #mrp twr time
                                                title += (scanner[2]).get_title()
                                                append_file(report_file_time, ",".join(title))
                                    timing_rpt  = os.path.join(dir_scan,foo,'*timing_summary_routed.rpt')
                                    timing_rpt = get_unique_file(timing_rpt)
                                    total_data = [design]
                                    if timing_rpt:
                                        scan_timing_rpt.scan_report(timing_rpt)
                                        total_data +=scan_timing_rpt.get_data()
                                    else:
                                        total_data +=['NA']*len(scan_timing_rpt.get_title())
                                        
                                    placed_rpt  = os.path.join(dir_scan,foo,'*utilization_placed.rpt')
                                    placed_rpt = glob.glob(placed_rpt)
                                    used_rpt = ''
                                    for rpt in placed_rpt:
                                        if rpt.find('clock_utilization')!= -1:
                                            continue
                                        else:
                                            used_rpt = rpt
                                            break
                                    if used_rpt:
                                        scan_placed_rpt.scan_report(used_rpt)
                                        total_data +=scan_placed_rpt.get_data()
                                    else:
                                        total_data +=['NA']*len(scan_placed_rpt.get_title())
                                        
                                    append_file(report_file, ",".join(total_data))
                                    for_bqs_data = '<scan_case>\n'
                                    for id1, t in enumerate( title):
                                        
                                        for_bqs_data = for_bqs_data + "\t<%s>"%t+total_data[id1]+"</%s>\n"%t
                                    for_bqs_data = for_bqs_data +"</scan_case>"
                                    print '#BQS_RETRN_DATA_BEGIN#'
                                    print for_bqs_data
                                    print '#BQS_RETRN_DATA_END#'
                                recover.run()
        os.chdir(root_dir)
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
    