import os
import re
import sys
xlib = os.path.join(os.path.dirname(__file__),'..','..','bin','xlib')
xlib = os.path.abspath(xlib)
if xlib in sys.path:
    pass
else:
    sys.path.append(xlib)
from xOS import not_exists, wrap_copy_file, get_fname_ext
from xLog import print_error
from tool_scan_report import ScanBasic
from xTools import time2secs, get_file_line_count,append_file



p_clock = re.compile("^Type\s+:.+\s+'([^']+)'$")
def get_clocks_from_sta_summary(sta_summary):
    if not_exists(sta_summary, "sta report summary file"):
        return
    clocks = set()
    for line in open(sta_summary):
        line = line.strip()
        m_clock = p_clock.search(line)
        if m_clock:
            clocks.add(m_clock.group(1))
    clock_list = list(clocks)
    clock_list.sort(key=str.lower)
    return clock_list

def update_sdc_file(sdc_file, clocks, tf):
    sdc_lines = ["derive_pll_clocks -use_tan_name",
                 'derive_clocks -period "%.3f MHz"' % tf, ""]
    in_ns = 1.0/tf * 1000
    in_ns = '"%.3f ns"' % in_ns
    for clk in clocks:
        sdc_lines.append("create_clock -period %s {%s}" % (in_ns, clk))
    sdc_lines.append("")
    sdc_lines.append("set_clock_groups -asynchronous \\")
    for clk in clocks[:-1]:
        sdc_lines.append("    -group { %s } \\" % clk)
    sdc_lines.append("    -group { %s }" % clocks[-1])
    sdc_lines.append("# Found %d Clocks." % len(clocks))

    append_file(sdc_file, sdc_lines, append=False)

class ScanAlteraFit(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self)
        self.patterns = {
            "002 Device" : re.compile("^;\s+Device\s+;\s+(\S+)"),
            "003 LE" : re.compile("^;\s+Total logic elements\s+;\s+(\S+)"),
            #;     -- Combinational with no register       ; 560                       ;
            #;     -- Combinational with a register        ; 797                       ;
            "004 LUT" : [
                         re.compile("^;\s+--\s+Combinational with no register\s+;\s+(\S+)"),
                         re.compile("^;\s+--\s+Combinational with a register\s+;\s+(\S+)")],
            
            #    ; Combinational ALUT usage for logic                       ; 1,057              ;       ;
            #    ; Combinational ALUT usage for route-throughs              ; 185                ;       ;
            #    ; Memory ALUT usage                                        ; 33                 ;       ;
            #    ; ALUTs Used                                                                        ; 315 / 99,280 ( < 1 % )  ;
            "005 ALUT": [re.compile("^;\s+Combinational ALUT usage for logic\s+;\s+(\S+)\s+;\s+;"),
                         re.compile("^;\s+Combinational ALUT usage for route-throughs\s+;\s+(\S+)\s+;\s+;"),
                         re.compile("^;\s+Memory ALUT usage\s+;\s+(\S+)\s+;\s+;"),
                         re.compile("^;\s+ALUTs Used\s+;\s+(\S+)\s+;\s+;")],
            
            
            "006 IO" : re.compile("^;\s+Total pins\s+;\s+(\S+)"),
            "007 Memory" : re.compile("^;\s+Total memory bits\s+;\s+(\S+)"),
            "008 DSP" : [re.compile("^;\s+Embedded Multiplier 9-bit elements\s+;\s+(\S+)"),
                         re.compile("^;\s+DSP block 18-bit elements\s+;\s+(\S+)"),
                         re.compile("^;\s+Total DSP Blocks\s+;\s+(\S+)")],
            #; Logic utilization (in ALMs)     ; 702 / 9,430 ( 7 % )                       ;
            #; ALMs:  partially or completely used                                               ; 226 / 49,640 ( < 1 % )  ;
            "009 ALMs":[re.compile(r"^;\s+Logic utilization \(in ALMs\)\s+;\s+(\S+)"),
                        re.compile(r"^;\s+ALMs:\s+partially or completely used\s+;\s+(\S+)")],
            #; Logic utilization (ALMs needed / total ALMs on device)    ; 188 / 29,080  ; < 1 % ;
            #; Logic utilization                                                                 ; 356 / 64,000 ( < 1 % ) ;
            "010 LogicUtil":[re.compile("^;\s+Logic utilization \(ALMs needed / total ALMs on device\)\s+;\s+(\S+)"),
                             re.compile("^;\s+Logic utilization\s+;\s+(\S+)")],
            #; Total MLAB memory bits                                   ; 0                  ;       ;
            "011 Dist_RAMs":re.compile("^;\s+Total MLAB memory bits\s+;\s+(\S+)"),
            "012 PLL" : re.compile("^;\s+Total PLLs\s+;\s+(\S+)"),
            #  +------------------------------------+-------------------------------------------+
            #  ; Fitter Status                      ; Successful - Tue Dec 18 12:09:26 2012     ;
            #  ; Quartus II 32-bit Version          ; 12.1 Build 177 11/07/2012 SJ Full Version ;
            #  ; Revision Name                      ; TopLevel                                  ;
            #  ; Top-level Entity Name              ; TopLevel                                  ;
            #  ; Family                             ; Cyclone IV E                              ;
            #  ; Device                             ; EP4CE22F17C6                              ;
            #  ; Timing Models                      ; Final                                     ;
            #  ; Total logic elements               ; 16,172 / 22,320 ( 72 % )                  ;
            #  ;     Total combinational functions  ; 15,257 / 22,320 ( 68 % )                  ;
            #  ;     Dedicated logic registers      ; 4,873 / 22,320 ( 22 % )                   ;
            #  ; Total registers                    ; 4873                                      ;
            #  ; Total pins                         ; 93 / 154 ( 60 % )                         ;
            #  ; Total virtual pins                 ; 0                                         ;
            #  ; Total memory bits                  ; 272,128 / 608,256 ( 45 % )                ;
            #  ; Embedded Multiplier 9-bit elements ; 0 / 132 ( 0 % )                           ;
            #  ; Total PLLs                         ; 1 / 4 ( 25 % )                            ;
            #  +------------------------------------+-------------------------------------------+

            "013 LAB" : re.compile("^; Total LABs:  partially or completely used\s+;\s+(\S+)"),
            "014 M9K" : [re.compile("^; M9Ks\s+;\s+(\S+)"),
                         re.compile("^M9K blocks\s+;\s+(\S)")],
            "015 M10K":re.compile("^;\s+M10K blocks\s+;\s+(\S+)"),
            "016 M144K":re.compile("^;\s+M144K blocks\s+;\s+(\S+)"),
            "017 Register" : re.compile("^;\s+Total registers\s+;\s+(\S+)"),
            # ; Total LABs:  partially or completely used   ; 1,118 / 1,395 ( 80 % )     ;
            # ; M9Ks                                        ; 44 / 66 ( 67 % )           ;
            "stop" : re.compile("^;\s+Input Pins"),
            
            #"101 FitPeakMem" : re.compile("^Info: Peak virtual memory:\s+(\S+)"),
            #"102 FitCPUTime" : re.compile("^Info: Total CPU time[^:]+:\s+(\S+)")
            # Info: Peak virtual memory: 408 megabytes
            # Info: Total CPU time (on all processors): 00:00:10
        }
        self.reset()

class ScanAlteraFmax:
    def __init__(self):
        self.title = ['Seed','PAP',"targetFmax", "fmax", "clkName"]
        self.data = ["NA"] * len(self.title)

        self.p_tf = re.compile('^derive_clocks -period "([\d\.]+)\s+MHz"')
        self.p_fmax_start = re.compile("^;\s+Fmax\s+;")
        self.p_fmax = re.compile("""^;\s+[\d\.]+\s+MHz\s+
                                     ;\s+([\d\.]+)\s+MHz\s+
                                     ;\s+(\S+)\s+;""", re.VERBOSE)

    def get_title(self):
        return self.title

    def get_data(self):
        return self.data

    def scan_report(self, rpt_file):
        self.data = ["NA"] * len(self.title)
        if not_exists(rpt_file, "report file for scanning Altera fmax"):
            return
        sdc_file = re.sub("\.sta\.rpt", ".sdc", rpt_file)
        if not_exists(sdc_file):
            sdc_file = os.path.join(os.path.dirname(sdc_file), "..", os.path.basename(sdc_file))
            if not_exists(sdc_file, "SDC file"):
                return 1

        target_fmax = self.get_target_fmax(sdc_file)
        fmax, clk_name = self.get_fmax(rpt_file)
        self.data = [target_fmax, "%.2f" % fmax, clk_name]
        
        
    def scan_report_temp(self, rpt_file):
        self.data = ["NA"] * len(self.title)
        if not_exists(rpt_file, "report file for scanning Altera fmax"):
            return
        sdc_file = re.sub("\.sta\.rpt", ".sdc", rpt_file)
        seed  =  os.path.basename( os.path.dirname(sdc_file))
        if not_exists(sdc_file):
            sdc_file = os.path.join(os.path.dirname(sdc_file), "..", os.path.basename(sdc_file))
            if not_exists(sdc_file, "SDC file"):
                return 1

        target_fmax = self.get_target_clk_fmax(sdc_file)
        print target_fmax
        fmax_clk_name = self.get_fmax_temp(rpt_file)
        #print '-----------------------------'
        #print target_fmax
        #print fmax, clk_name
        #raw_input()
        pap = 1000000000
        pap_clk = ''
        pap_target_fmax = ''
        pap_fmax = -1
        print fmax_clk_name
        #raw_input()
        for clk_name,fmax in fmax_clk_name.items():
            if clk_name in target_fmax.keys():
                pap1 = (fmax / target_fmax[clk_name])*100
                pap1 = "%.2f"%pap1
                print pap1
                print '================================='
                if float(pap1) < pap:
                    print 'GGGGGGGGGGGGGGGGGGGGG',pap1,pap
                    pap = float(pap1)
                    pap_target_fmax = target_fmax[clk_name]
                    pap_clk = clk_name
                    pap_fmax = fmax
        pap = str(pap)+'%' 
        self.data = [seed,pap,str(pap_target_fmax),str(pap_fmax),pap_clk] 
        print self.data 
        #raw_input()     
        #self.data = [seed,pap,"%.2f"%target_fmax[clk_name], "%.2f" % fmax, clk_name]
        '''
        fmax_clk_name = self.get_fmax_temp(rpt_file)
        for key in fmax_clk_name.keys():
            d = []
            if key in target_fmax.keys():
                d.append(target_fmax[key])
                d.append(fmax_clk_name[key])
                d.append(key)
            if d:
                if ["NA"] * len(self.title) == self.data:
                    self.data = []
                else:
                    self.data.append(d)
                
        '''
        #self.data = [target_fmax, "%.2f" % fmax, clk_name]
        
    def get_fmax_temp(self, rpt_file):
        fmax_start = 0
        fmax, clk_name = 100000, ""
        return_dict = {}
        for line in open(rpt_file):
            line = line.strip()
            m_fmax = self.p_fmax.search(line)
            if m_fmax:
                cur_fmax = float(m_fmax.group(1))
                cur_clk_name = m_fmax.group(2)
                if cur_fmax and cur_clk_name:
                    return_dict[cur_clk_name] = cur_fmax
        return return_dict
    def get_target_fmax(self, sdc_file):
        for line in open(sdc_file):
            line = line.strip()
            m_tf = self.p_tf.search(line)
            if m_tf:
                return m_tf.group(1)
        return "NoTargetFmax"
    def get_target_clk_fmax(self,sdc_file):
        '''
        This function used to replace get_target_fmax, it will return a dict as{clk:target_fmax)
        '''
        #create_clock -period "9.576 ns" 
        #-name {CLK72M_IN}
        self.p_target_clk = re.compile(r'create_clock -period "([\.\d]+)\s+ns"')
        self.p_target_clk_name = re.compile(r'-name {(.+?)}')
        key = ''
        value = ''
        return_dict = {}
        for line in open(sdc_file):
            line = line.strip()
            m_clk = self.p_target_clk.search(line)
            if m_clk:
                try:
                    value = m_clk.group(1)
                    value = float(value)
                    value = 1000/value
                except:
                    value = ''
            m_clk_name = self.p_target_clk_name.search(line)
            if m_clk_name:
                try:
                    key = m_clk_name.group(1)
                except:
                    key = ''
                if key and value:
                    return_dict[key]=value
                
        return return_dict

        

    def get_fmax(self, rpt_file):
        fmax_start = 0
        fmax, clk_name = 100000, ""
        for line in open(rpt_file):
            line = line.strip()
            if fmax_start:
                if not line:
                    fmax_start = 0
                else:
                    m_fmax = self.p_fmax.search(line)
                    if m_fmax:
                        cur_fmax = float(m_fmax.group(1))
                        cur_clk_name = m_fmax.group(2)
                        if cur_fmax < fmax:
                            fmax = cur_fmax
                            clk_name = cur_clk_name
            else:
                if self.p_fmax_start.search(line):
                    fmax_start = 1
        return fmax, clk_name
    def reset(self):
        self.data = ["NA"] * len(self.title)

class ScanTimeMem:
    def __init__(self):
        self.patterns_srr = {
                             #Real Time elapsed 0h:01m:23s; CPU Time elapsed 0h:01m:23s; Memory used current: 55MB peak: 295MB
                             "001 srr_time" : re.compile("Real Time elapsed\s+(.+);\s+CPU Time elapsed\s+(.+);.*?peak:\s+(\d+)MB"),
                             }
        self.srr_data     = {
                            'srr_real_time':'NA',
                            'srr_cpu_time' : 'NA',
                            'SynPeakMem'   : 'NA'
                            }
        self.patterns_map = {
                             #   Info: Total CPU time (on all processors): 00:00:08
                             "001 map_cpu_time": re.compile("Info: Total CPU time \(on all processors\):\s+(.+)"),

                             # Info: Elapsed time: 00:00:28
                             "002 map_real_time": re.compile("Info: Elapsed time:\s+(.+)"),
                             #Peak virtual memory: 399 megabytes
                             "003 MapPeakMem"   : re.compile("Peak virtual memory:\s+(\S+)\s+megabytes")
                             
                             }
        
        self.map_data = {}
        for key in self.patterns_map.keys():
            key = key.split()[1]
            self.map_data[key] = 'NA'
        self.patterns_fit = {
                             #Info: Total CPU time (on all processors): 00:01:25
                             "001 Fit_cpu_time" : re.compile("Info: Total CPU time \(on all processors\):\s+(\S+)"),
                             #Info: Elapsed time: 00:01:11
                             "002 Fit_real_time": re.compile("Info: Elapsed time:\s+(\S+)"),
                             #Info: Peak virtual memory: 607 megabytes
                             "003 FitPeakMem" : re.compile("Info: Peak virtual memory:\s+(\d+)\s+megabytes"),
                             "004 Fit_Done": re.compile("^; Fitter Status\s+; Successful")
                             }
        self.fit_data = {}
        for key in self.patterns_fit.keys():
            key = key.split()[1]
            self.fit_data[key] = 'NA'
        self.total_time = {'Total_cpu_time' :'NA',
                           'Total_real_time': 'NA'
                           }
    def scan_srr(self,srr_file):
        if not os.path.isfile(srr_file):
            return 
        file_hand =  file(srr_file,'r')
        lines = file_hand.readlines()
        file_hand.close()
        
        for line in lines:
            line = line.strip()
            match = (self.patterns_srr["001 srr_time"]).search(line)
            if match:
                self.srr_data['srr_real_time'] = time2secs(match.group(1))
                self.srr_data['srr_cpu_time'] = time2secs(match.group(2))
                self.srr_data['SynPeakMem'] = match.group(3)
    def scan_map(self,map_file):
        if not os.path.isfile(map_file):
            return
        file_hand = file(map_file,'r')
        lines = file_hand.readlines()
        file_hand.close()
        for line in lines:
            line  = line.strip()
            for key in self.patterns_map.keys():
                value = self.patterns_map[key]
                match = value.search(line)
                if match:
                    if key.find('Fit_Done')== -1:
                        match_data = match.group(1)
                        if key !='MapPeakMem':
                            match_data = time2secs(match_data.strip())
                        self.map_data[key.split()[1]] = match_data
                    else:
                        self.map_data[key.split()[1]] = 'YES'
    
    def scan_fit(self,fit_file):
        if not os.path.isfile(fit_file):
            return
        file_hand = file(fit_file,'r')
        lines = file_hand.readlines()
        file_hand.close()
        for line in lines:
            line  = line.strip()
            for key in self.patterns_fit.keys():
                value = self.patterns_fit[key]
                match = value.search(line)
                if match:
                    if key.find('Fit_Done') == -1:
                        match_data = match.group(1)
                        if key !='FitPeakMem':
                            match_data = time2secs(match_data.strip())
                        self.fit_data[key.split()[1]] = match_data
                    else:
                        self.fit_data[key.split()[1]] = 'YES' 
    def get_srr_data(self):
        return self.srr_data
    def get_map_data(self):
        return self.map_data
    def get_fit_data(self):
        return self.fit_data
    def set_srr_data(self):
         for key in self.srr_data.keys():
             self.srr_data[key] = 'NA'
    def set_map_data(self):
        for key in self.map_data.keys():
            self.map_data[key]  = 'NA'
    def set_fit_data(self):
        for key in self.fit_data.keys():
            self.fit_data[key] = 'NA'
    def reset(self):
        self.set_srr_data()
        self.set_fit_data()
        self.set_map_data()
        self.total_time = {'Total_cpu_time' :'NA',
                           'Total_real_time': 'NA'
                           }
                    
    def get_total_time(self):
        srr_time = self.get_srr_data()
        mrp_time = self.get_map_data()
        par_time = self.get_fit_data()
        self.total_time = {}
        self.real_time = 0
        self.cpu_time = 0
        for key in srr_time.keys():
            key_lower = key.lower()
            if key_lower.find('real_time')!= -1:
                try:
                    self.real_time = self.real_time + int(srr_time[key])
                except Exception,e:
                    print e
                    pass
            if key_lower.find('cpu_time')!= -1:
                try:
                    self.cpu_time = self.cpu_time + int(srr_time[key])
                except:
                    pass
        for key in mrp_time.keys():
            key_lower = key.lower()
            if key_lower.find('real_time')!= -1:
                try:
                    self.real_time = self.real_time + int(mrp_time[key])
                except:
                    pass
            if key_lower.find('cpu_time')!= -1:
                try:
                    self.cpu_time = self.cpu_time +int( mrp_time[key])
                except:
                    pass
        for key in par_time.keys():
            key_lower = key.lower() 
            if key_lower.find('real_time')!= -1:
                try:
                    self.real_time = self.real_time + int(par_time[key])
                except:
                    pass
            if key_lower.find('cpu_time')!= -1:
                try:
                    self.cpu_time = self.cpu_time + int(par_time[key])
                except:
                    pass
        self.total_time['Total_cpu_time'] = str(self.cpu_time)
        self.total_time['Total_real_time'] = str(self.real_time)
        return self.total_time    
    def get_title(self):
        srr_time = self.get_srr_data()
        mrp_time = self.get_map_data()
        par_time = self.get_fit_data()
        srr_title =  srr_time.keys()
        srr_title.sort()
        mrp_title =  mrp_time.keys()
        mrp_title.sort()
        par_title =  par_time.keys()
        par_title.sort()
        title = srr_title+mrp_title+par_title+['Total_cpu_time','Total_real_time']  
        return title
    def get_data(self):
        title = self.get_title()
        dic = {}
        data  = []
        dic.update(self.get_srr_data())
        dic.update(self.get_map_data())
        dic.update(self.get_fit_data())
        dic.update(self.get_total_time())
        for t in title:
            data.append(dic[t])
        return data
            
            
    
if __name__ == "__main__":
    mrp_file = r"C:\Users\yzhao1\Desktop\cyc4\08_vj1kfpga\_cyclone4_synp\Target_fmax_is_050.000MHz\cyclone4_synp_08_vj1k.fit.rpt"

    pp = ScanAlteraFit()
    pp.scan_report(mrp_file)
    print pp.get_title()
    print pp.get_data()
