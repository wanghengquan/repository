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
from xTools import time2secs, get_file_line_count
import traceback

def get_float(raw_str):
    raw_str = re.sub("\D+", "", raw_str)
    try:
        return float(raw_str)
    except:
        return ""

def get_clocks_from_mrp_file(mrp_file):
    if not_exists(mrp_file, "Lattice Mrp file"):
        return
    p_clock_number = re.compile("^Number\s+of\s+clocks:\s+(\d+)")
    p_clock = re.compile("^Net\s+([^:]+):")
    p_stop = re.compile("Number of Clock Enables")
    clock_number = 0
    clocks = list()
    for line in open(mrp_file):
        line = line.strip()
        if not clock_number:
            mcn = p_clock_number.search(line)
            if mcn:
                clock_number = int(mcn.group(1))
            continue
        if p_stop.search(line):
            break
        mc = p_clock.search(line)
        if mc:
            clocks.append(mc.group(1))
    if len(clocks) != clock_number:
        print_error("Not found %d clocks in %s" % (clock_number, mrp_file))
        return
    return clocks

p_frequency = re.compile('^FREQUENCY\s+')
def update_clocks(prf_file, clocks, fixed_number):
    if not clocks:
        print_error("Not found any clocks name")
        return 1
    prf_file_bak = prf_file + ".a"
    if not os.path.isfile(prf_file_bak):
        wrap_copy_file(prf_file, prf_file_bak)
    prf_lines = open(prf_file_bak)
    prf_ob = open(prf_file, "w")
    for line in prf_lines:
        line = line.strip()
        if p_frequency.search(line):
            continue
        print >> prf_ob, line
    for clk in clocks:
        print >> prf_ob, 'FREQUENCY NET "%s" %s MHz ;' % (clk, fixed_number)
    prf_ob.close()

p_mhz = re.compile("\S+\s+MHz", re.I)
def update_frequency(prf_file, fixed_number):
    if not_exists(prf_file, "elder prf file"):
        return 1
    prf_file_bak = prf_file + ".b"
    wrap_copy_file(prf_file, prf_file_bak, force=True)
    prf_lines = open(prf_file_bak)
    prf_ob = open(prf_file, "w")
    for line in prf_lines:
        line = line.strip()
        if p_frequency.search(line):
            line = p_mhz.sub("%s MHz" % fixed_number, line)
        print >> prf_ob, line

    prf_ob.close()

class GetFromSynthesisLog(ScanBasic):
    def __init__(self):
        """
        Number of register bits => 753 of 5280 (14 % )   /shawn, reg_lse
        BB => 18                /shawn, io_lse
        CCU2E => 230           /shawn, carry_lse
        FD1P3XZ => 753
        LUT4 => 885           /shawn, lut4_lse
        PDP4KA => 2         /ebr_lse
        MAC16A             /dsp_lse
        """
        ScanBasic.__init__(self)
        self.patterns = {
            "001 reg_lse" : re.compile("^Number of register bits\s+=>\s+(\d+)"),
            "002 io_lse"  : re.compile("^BB\s+=>\s+(\d+)"),
            "003 carry_lse" : re.compile("^CCU2E\s+=>\s+(\d+)"),
            "004 lut4_lse" : re.compile("^LUT4\s+=>\s+(\d+)"),
            "005 ebr_lse" : re.compile("^PDP4KA\s+=>\s+(\d+)"),
            "006 dsp_lse" : re.compile("^MAC16A\s+=>\s+(\d+)"),
        }
        self.reset()

class ScanLatticeTwr:
    def __init__(self, pap, all_clk=False):
        self.post_lse = ScanLatticeTwr_sub(pap, all_clk)
        self.post_par = ScanLatticeTwr_sub(pap, all_clk)
        self.post_lse_resource = GetFromSynthesisLog()
        self.title = [item + "_lse" for item in self.post_lse.get_title()] +\
                     self.post_par.get_title() +\
                     self.post_lse_resource.get_title()
        self.data = ["NA" * len(self.title)]

    def get_title(self):
        return self.title

    def get_data(self):
        return self.data
    def set_all_data(self):
        self.all_raw_data = list()

    def scan_report(self, rpt_file,  hot_clk=""):
        if not os.path.isfile(rpt_file):
            return
        log_file = os.path.join(os.path.dirname(rpt_file), "synthesis.log")
        self.post_lse.scan_report(log_file)
        self.data = self.post_lse.get_data()[:]
        self.post_par.scan_report(rpt_file)
        self.data += self.post_par.get_data()[:]
        self.post_lse_resource.scan_report(log_file)
        self.data += self.post_lse_resource.get_data()

class ScanLatticeTwr_sub:
    def __init__(self, pap, all_clk=False):
        self.pap = pap
        self.all_clk = all_clk
        self.title =["targetFmax", "Fmax","clkName", "level", "score"]
        self.data = ["NA"] * len(self.title)
        self.create_patterns()

    def create_patterns(self):
        self.p_start = re.compile("SETUP SUMMARY REPORT")
        self.p_stop = re.compile("-{100}")  # show 3 times
        self.title_start_str = "Preference"
        self.p_ports_nets = re.compile("""get_(ports|nets)\s+
                                      (
                                      [^\]]+
                                      )\]""", re.X)


    def get_title(self):
        return self.title

    def get_data(self):
        if self.all_raw_data:
            return self._get_minimize("Fmax")
        else:
            return self.data

    def set_all_data(self):
        self.all_raw_data = list()

    def scan_report(self, rpt_file,  hot_clk=""):
        self.data = ["NA"] * len(self.title)
        if not os.path.isfile(rpt_file):
            return
        # -- get lines
        lines = self._get_lines(rpt_file)
        # -- search lines, get the self.all_raw_data
        self.get_all_raw_data(lines)

    def _get_lines(self, rpt_file):
        rpt_ob = open(rpt_file)
        start = 0
        show_times = 0
        lines = list()
        while True:
            line = rpt_ob.readline()
            if not line:
                break
            if self.p_start.search(line):
                start = 1
            if start:
                if self.p_stop.search(line):
                    show_times += 1
                    if show_times == 3:
                        break
                line = line.strip()
                if line:
                    lines.append(line)
        return lines

    def _get_minimize(self, key):
        min_data = dict()
        for item in self.all_raw_data:
            new_value = item.get(key)
            old_value = min_data.get(key)
            if new_value.strip() == '-':
                continue
            if not old_value:
                min_data = item
            else:
                new_value = get_float(new_value)
                old_value = get_float(old_value)
                if old_value > new_value:
                    min_data = item
        return [min_data.get(item, "NA") for item in self.title]

    def get_all_raw_data(self, lines):
        self.all_raw_data = list()
        long_string_list = list()
        raw_titles = list()
        for item in lines:
            item_list = re.split("\s*\|\s*", item)
            if item_list[0] == self.title_start_str:
                raw_titles = item[:]
                continue
            if raw_titles:
                new_item = re.sub("[\|\s]+$", "", item)
                if not new_item:
                    new_item = "  jOIn  "
                long_string_list.append(new_item)
        long_string = "".join(long_string_list)
        real_list = re.split("\s+jOIn\s+", long_string)
        for data in real_list:
            _one_data = dict()
            data_list = re.split("\s*\|\s*", data)
            if not data_list:
                continue
            m_clk = self.p_ports_nets.search(data_list[0])
            if not m_clk:
                continue
            # -----------------
            _one_data["clkName"] = m_clk.group(2)
            _one_data["targetFmax"] = self.transfer_ns_mhz(data_list[1])
            _one_data["level"] = data_list[3]
            _one_data["Fmax"] = self.transfer_ns_mhz(data_list[4])
            _one_data["score"] = data_list[5]
            self.all_raw_data.append(_one_data)
            # -----------------

    def transfer_ns_mhz(self, raw_string):
        """
        5.000 ns ->
        27.000 MHz -> 27.00
        :param raw_string:
        :return:
        """

        raw_string = raw_string.strip()
        raw_list = re.split("\s+", raw_string)
        decimal = raw_list[0]
        try:
            decimal = float(decimal)
        except ValueError:
            return "-"

        if raw_string.endswith("ns"):
            return "%.2f" % (1*1000/decimal)
        else:
            return "%.2f" % decimal





#####class ScanLatticeTwr:
#####    def __init__(self, pap,all_clk=False):
#####        self.pap = pap  # Performance Achievement Percentage
#####
#####        self.title = [r"Seed/Target","PAP", "PAPFactor", "targetFmax", "fmax", "clkName", "logic", "route", "level", "twrLabel","score_setup","score_hold",'Pass_num',"S_pref_num",'H_pref_num']
#####        self.all_clk=all_clk
#####        self.create_patterns()
#####        self.all_raw_data = list()
#####        #Score: 1467 (setup), 0 (hold)
#####        self.score = re.compile('Score: (\d+) \(setup\), (\d+) \(hold\)')
#####        self.score_data_setup = 'NA'
#####        self.score_data_hold = 'NA'
#####    def create_patterns(self):
#####        self.p_fre_clk = re.compile('^Preference: FREQUENCY[^"]+"([^"]+)"')
#####        # Preference: FREQUENCY NET "ck19fb_out_o" 280.000000 MHz ;
#####        self.p_lrl = re.compile("""\s+\(
#####                                (?P<logic>[\d\.]+%)\s+logic,\s+
#####                                (?P<route>[\d\.]+%)\s+route
#####                                \),\s+
#####                                (?P<level>\d+)\s+logic\s+level
#####                                """, re.VERBOSE)
#####        # Delay:               0.298ns  (81.2% logic, 18.8% route), 2 logic levels.
#####        if self.pap:
#####            self.create_pap_patterns()
#####        else:
#####            self.create_fmax_patterns()
#####
#####    def create_pap_patterns(self):
#####        self.rpt_start = re.compile("Dump PAP Details", re.I)
#####        # PAP=   48.92% | 280.00 MHz | 137.01 MHz |   1.00 | FREQUENCY NET "spi4_clk_int" 280.000000 MHz ;
#####        self.rpt_pattern = re.compile('''PAP=\s+
#####                                      ([\d\.]+%)\s+            # PAP
#####                                      ([\d\.]+)\s+MHz\s+       # Constraint
#####                                      ([\d\.]+)\s+MHz\s+       # Actual
#####                                      ([\d\.]+)\s+             # Factor
#####                                      FREQUENCY[^"]+
#####                                      "([^"]+)"                # Clock name
#####                                      ''', re.VERBOSE | re.I)
#####        # can prcess the line as:
#####        # PAP=  131.14% |  80.00 MHz | 104.91 MHz |   1.00 | FREQUENCY 80.000000 MHz ;
#####        self.rpt_pattern = re.compile('''PAP=\s+
#####                                      ([\d\.]+%)\s+            # PAP
#####                                      ([\d\.]+)\s+MHz\s+       # Constraint
#####                                      ([\d\.]+)\s+MHz\s+       # Actual
#####                                      ([\d\.]+)\s+             # Factor
#####                                      FREQUENCY
#####                                      (.*?)\d+\.                 # Clock name
#####                                      ''', re.VERBOSE | re.I)
#####        self.raw_title = ["PAP", "targetFmax", "fmax", "PAPFactor", "clkName"]
#####        self.rpt_stop = re.compile("Overall Performance")
#####
#####    def create_fmax_patterns(self):
#####        self.rpt_start = re.compile("^Report\s+Summary")
#####        # FREQUENCY NET "fir_clk_c" 300.000000    |             |             |
#####        # MHz ;                                   |  300.000 MHz|  443.656 MHz|   2
#####        self.rpt_pattern = re.compile('''FREQUENCY[^"]+
#####                                      "([^"]+)"              # Clock name
#####                                      [^;]+;
#####                                      \s+([\d\.\-]+)\s+MHz    # Constraint
#####                                      \s+([\d\.\-]+)\s+MHz     # Actual
#####                                      \s+\d+                 # Level
#####                                      ''', re.VERBOSE | re.I)
#####        if self.all_clk:
#####            self.rpt_pattern = re.compile('''FREQUENCY[^"]+
#####                                      "([^"]+)"              # Clock name
#####                                      [^;]+;
#####                                      \s+([\d\.\-]+)\s+(MHz)?     # Constraint
#####                                      \s+([\d\.\-]+)\s+(MHz)?     # Actual
#####                                      \s+\d+                 # Level
#####                                      ''', re.VERBOSE | re.I)
#####        self.raw_title = ["clkName", "targetFmax", "fmax"]
#####        self.rpt_stop = re.compile("^$")  # empty line
#####
#####    def get_title(self):
#####        return self.title
#####
#####    def get_all_data(self):
#####        return self.all_raw_data
#####        #all_data = list()
#####        #for item in self.all_raw_data:
#####        #    t_data = [item.get(foo) for foo in self.title]
#####        #    all_data.append(t_data)
#####        #return all_data
#####    def set_all_data(self):
#####        self.all_raw_data = list()
#####
#####
#####
#####    def get_data(self):
#####        if self.pap:
#####            return self.get_pap_data()
#####        else:
#####            return self.get_fmax_data()
#####
#####    def get_pap_data(self):
#####        """The minimize PAP clock data
#####        """
#####        return self._get_minimize("PAP")
#####
#####    def get_fmax_data(self):
#####        """The minimize fmax clock data
#####        """
#####        return self._get_minimize("fmax")
#####
#####    def get_central_fmax(self):
#####        fmax_data = self._get_minimize("fmax")
#####        fmax_idx = self.title.index("fmax")
#####        return fmax_data[fmax_idx]
#####
#####    def scan_report(self, rpt_file,  hot_clk=""):
#####        self.hot_clk = hot_clk
#####        self.rpt_file = rpt_file
#####        self.raw_data = list()
#####        if not os.path.isfile(rpt_file):
#####            return
#####        start, hotlines1 = 0, list()
#####        hotlines2 = list()
#####        start_flag = 0
#####        set_up_pref_num_fail = 0
#####        hold_pref_num_fail = 0
#####        frequency_flag = 0
#####        for line in open(rpt_file):
#####            if not start:
#####                if self.rpt_start.search(line):
#####                    start = 1
#####                    start_flag += 1
#####                continue
#####            line = line.strip()
#####            if self.rpt_stop.search(line) and start_flag == 1:
#####                start = 0
#####                continue
#####            if self.rpt_stop.search(line) and start_flag > 1:
#####                break
#####            line = re.sub("\s*\|", " ", line)
#####            if start_flag == 1:
#####                hotlines1.append(line)
#####                frequency_flag += 1
#####                if line.startswith('FREQUENCY'):
#####                    frequency_flag = 0
#####                if line.endswith('*') and frequency_flag<3:
#####                    set_up_pref_num_fail += 1
#####                    frequency_flag = 0
#####            else:
#####                hotlines2.append(line)
#####                frequency_flag += 1
#####                if line.startswith('FREQUENCY'):
#####                    frequency_flag = 0
#####                if line.endswith('*') and frequency_flag<3:
#####                    hold_pref_num_fail += 1
#####                    frequency_flag = 0
#####
#####        hotlines1 = "".join(hotlines1)
#####        hotlines2 = "".join(hotlines2)
#####        self.raw_data  = self.rpt_pattern.findall(hotlines1)
#####        set_up_pref_num= hotlines1.count('FREQUENCY')
#####        #set_up_pref_num_fail  = hotlines1.count('*')
#####
#####        hold_pref_num=  hotlines2.count('FREQUENCY')
#####        #hold_pref_num_fail = hotlines2.count('*')
#####
#####        if not self.raw_data:
#####            print_error("No frequency data found in %s" % rpt_file)
#####            return 1
#####            #
#####        set_up_pref = str(set_up_pref_num)+'\\'+str(set_up_pref_num_fail)
#####        hold_pref = str(hold_pref_num)+'\\'+str(hold_pref_num_fail)
#####        ###########new add for score ###############
#####        for line in open(rpt_file):
#####            p = self.score.search(line)
#####            if p:
#####                self.score_data_setup = p.group(1)
#####                self.score_data_hold = p.group(2)
#####        self._get_all_raw_data(rpt_file,set_up_pref,hold_pref)
#####
#####
#####    def _get_all_raw_data(self, rpt_file,set_up_pref='',hold_pref=''):
#####        self.all_raw_data = list()
#####        ##########
#####        # at here, add the pass number for Jeffrey
#####        # and the case directory will be:\\d27417\benchmark\D3.4.0.80\L25_ecp2\apxc_lever\_scratch
#####        # at here, the script scan twr file. and the path look as '_scratch\Target_fmax_050.00MHz\Impl\*.twr'
#####        _scratch_dir =  os.path.dirname( os.path.dirname(os.path.dirname(rpt_file)) )
#####        pass_num = 0
#####        for temp_dir in os.listdir(_scratch_dir):
#####            if os.path.isdir(os.path.join(_scratch_dir,temp_dir)) and temp_dir.startswith('Target') and (not temp_dir.endswith('Failed') ):
#####                pass_num += 1
#####        #########################################################
#####        all_clk_file = file("aaa.csv","w")
#####        all_clk_file.write(",".join(self.raw_title) + "\n")
#####        for item in self.raw_data:
#####            if self.all_clk:
#####                item = [ item[0],item[1],item[3] ]
#####            t_data = dict(zip(self.raw_title, item))
#####            full_path = os.path.abspath(rpt_file)
#####            all_clk_file.write(",".join(item) + "\n")
#####            full_path_re = re.compile(r'Target_(seed|fmax)_([\w\d_\.]+)')
#####            full_path_m = full_path_re.search(full_path)
#####            if full_path_m:
#####
#####                try:
#####                    t_data["Seed/Target"]  = full_path_m.group(2)
#####                except:
#####                    t_data["Seed/Target"] = 'NA'
#####            else:
#####                t_data["Seed/Target"] = 'NA'
#####            t_data['Pass_num'] = str(pass_num)
#####            t_data["twrLabel"] = os.path.basename(os.path.dirname( os.path.dirname( os.path.abspath(rpt_file) ) ) )+'_'+ \
#####                                os.path.basename( os.path.dirname( os.path.abspath(rpt_file) ) )+'_'+get_fname_ext(rpt_file)[0]
#####            clk_name = t_data.get("clkName")
#####            if self.hot_clk:
#####                if clk_name != self.hot_clk or clk_name.find(self.hot_clk)== -1:
#####                    continue
#####            lrl = self._get_lrl(t_data.get("clkName"))
#####            if lrl:
#####                t_data.update(lrl)
#####            pap_number = t_data.get("PAP")
#####            if not pap_number:
#####                try:
#####                    pap_number = "%s/%s" % (t_data.get("fmax"), t_data.get("targetFmax"))
#####                    pap_number = eval(pap_number) * 100
#####                    pap_number = "%.2f%%" % pap_number
#####                    t_data["PAP"] = pap_number
#####                    t_data["PAPFactor"] = "-"
#####                except:
#####                    t_data["PAP"] = "-"
#####                    t_data["PAPFactor"] = "-"
#####            ###########add for score ############
#####            t_data.update({'score_setup':self.score_data_setup,'score_hold':self.score_data_hold})
#####            ###########add for score ############
#####            t_data.update({'S_pref_num':set_up_pref,'H_pref_num':hold_pref})
#####            self.all_raw_data.append(t_data)
#####        all_clk_file.close()
#####
#####
#####
#####    def _get_lrl(self, clk_name):
#####        start = 0
#####        for line in open(self.rpt_file):
#####            if not start:
#####                m_fre_clk = self.p_fre_clk.search(line)
#####                if m_fre_clk:
#####                    fre_clk = m_fre_clk.group(1)
#####                    if fre_clk == clk_name:
#####                        start = 1
#####                continue
#####            m_lrl = self.p_lrl.search(line)
#####            if m_lrl:
#####                lrl_title = ["logic", "route", "level"]
#####                lrl_data = [m_lrl.group(item) for item in lrl_title]
#####                return dict(zip(lrl_title, lrl_data))
#####
#####    def _get_float(self, raw_str):
#####        raw_str = re.sub("\D+", "", raw_str)
#####        return float(raw_str)
#####
#####    def _get_minimize(self, key):
#####        min_data = dict()
#####        for item in self.all_raw_data:
#####            new_value = item.get(key)
#####            old_value = min_data.get(key)
#####            if new_value.strip() == '-':
#####                continue
#####            if not old_value:
#####                min_data = item
#####            else:
#####                new_value = self._get_float(new_value)
#####                old_value = self._get_float(old_value)
#####                if old_value > new_value:
#####                    min_data = item
#####        return [min_data.get(item, "NA") for item in self.title]
#####
class ScanLatticeMrp(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self)
        self.patterns = {
            "001 Registers" : re.compile("Number\s+of\s+slice\s+registers:\s+(\d+)"),
            "002 LUT4s    " : re.compile("Number\s+of\s+LUT4s:\s+(\d+)"),
            "003 PIO      " : re.compile("Number\s+of\s+PIO\s+sites\s+used:\s+(\d+)"),
            "004 DSPs     " : re.compile("Number\s+of\s+DSPs:\s+(\d+)"),
            "005 I2Cs     " : re.compile("Number\s+of\s+I2Cs:\s+(\d+)"),
            "006 HFOSCs   " : re.compile("Number\s+of\s+HFOSCs:\s+(\d+)"),
            "007 LFOSCs   " : re.compile("Number\s+of\s+LFOSCs:\s+(\d+)"),
            "008 LEDDAs   " : re.compile("Number\s+of\s+LEDDAs:\s+(\d+)"),
            "009 RGBAs    " : re.compile("Number\s+of\s+RGBAs:\s+(\d+)"),
            "010 FILTERs  " : re.compile("Number\s+of\s+FILTERs:\s+(\d+)"),
            "011 SRAMs    " : re.compile("Number\s+of\s+SRAMs:\s+(\d+)"),
            "012 WARMBOOTs" : re.compile("Number\s+of\s+WARMBOOTs:\s+(\d+)"),
            "013 SPIs     " : re.compile("Number\s+of\s+SPIs:\s+(\d+)"),
            "014 EBRs     " : re.compile("Number\s+of\s+EBRs:\s+(\d+)"),
            "015 PLLs     " : re.compile("Number\s+of\s+PLLs:\s+(\d+)"),
            "016 LSRs     " : re.compile("Number\s+of\s+LSRs:\s+(\d+)"),


            "stop" : re.compile("^Page\s+8"),

            "100 MapCPUTime" : re.compile("^Total CPU Time:\s+(.+)"),
            "101 MapPeakMem" : re.compile("^Peak Memory Usage:\s+(\d+) MB")
            # Total CPU Time: 0 secs
            # Peak Memory Usage: 51 MB
        }
        self.patterns_for_clocks={
                                  # Number of clocks:  1
                                  "001 clocks" : re.compile("^Number\s+of\s+clocks:\s+(\d+)"),
                                  #Net mclkin_c: 787 loads, 785 rising, 2 falling (Driver: PIO mclkin )
                                  "002 loads"  : re.compile("^Net\s+(.+):\s+(\d+)\s+loads"),
                                  "stop" : re.compile("^Page\s+8")
                                  }
        self.reset()
        self.data_clocks = {}
    def parse_line_clocks(self,mrp_file):  #
        '''
           first: find the begin line
           then scan the useful line
        '''
        lines = (file(mrp_file,'r')).readlines()
        #print lines
        begin_line_pattern =  self.patterns_for_clocks.get("001 clocks" )
        useful_line_pattern = self.patterns_for_clocks.get("002 loads" )
        begin =0
        clock_number = 0
        match_number = 0
        for line in lines:
            #print line
            line = line.strip()
            match_begin = begin_line_pattern.search(line)
            if  match_begin and begin==0:
                clock_number = int(match_begin.group(1))
                begin = 1
            elif begin == 1:
                match = useful_line_pattern.search(line)
                if match:
                    self.data_clocks[match.group(1)] = match.group(2)
                    match_number = match_number + 1
                    if match_number == clock_number:
                        break
                else:
                    pass
    def get_parse_line_clocks(self):
        return self.data_clocks

    def scan_clocks(self,mrp_file):
        self.keys_clocks = self.patterns_for_clocks.keys()
        self.data_clocks = {}
        line_count = get_file_line_count(mrp_file)
        stop_pattern = self.patterns_for_clocks.get("stop")
        if not line_count:
            return
        self.parse_line_clocks(mrp_file)

class ScanLatticeTime(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self)
        self.patterns = {
            "001 edif2ngd" : re.compile("^([\.\d]+)\s+,\s+\S+edif2ngd\s+"),
            "002 ngdbuild" : re.compile("^([\.\d]+)\s+,\s+\S+ngdbuild\s+"),
            "003 map" : re.compile("^([\.\d]+)\s+,\s+\S+map\s+"),
            "004 par" : re.compile("^([\.\d]+)\s+,\s+\S+par\s+"),
            "005 trce" : re.compile("^([\.\d]+)\s+,\s+\S+trce\s+")
        }
        self.patterns_srr = {
                             #Process took 0h:00m:01s realtime, 0h:00m:01s cputime
                             "001 srr_time" : re.compile("^Process\s+took\s+(.+)\s+realtime,\s+(.+)\s+cputime NO use"), # this is useless now( according to jeffrey ye)
                             #CCU2D:          88    #synthesis
                             #CCU2D => 85   #lse
                             "002 CCU_lse" : re.compile("^CCU.*?\s+(\d+)"),
                             #------------
                             # Number of register bits => 678 of 48066 (1 % )
                             # LUT4 => 2131
                             "000 Regs" : re.compile("^Number of register bits =>\s+(\d+)"),
                             "000 LUT4" : re.compile("^LUT4\s+=>\s+(\d+)"),

                             #------------
                             #Peak Memory Usage: 125.008  MB
                             # This is the old one-- "003 SynPeakMem":re.compile("^Peak\sMemory\sUsage:\s+([\d.]+)"),
                             #At Mapper Exit (Real Time elapsed 0h:00m:30s; CPU Time elapsed 0h:00m:30s; Memory used current: 69MB peak: 241MB)
                             #"003 SynPeakMem":re.compile("^At\sMapper\sExit.+?peak:\s([\d.]+)MB"),
                             "003 SynPeakMem":re.compile("Memory used current:.+?peak:\s([\d.]+)MB"),
                             #Elapsed CPU time for LSE flow : 7.301  secs
                             "004 lse_CPU_Time":re.compile("^Elapsed\s+CPU\s+time\s+for\s+LSE\s+flow\s+:\s+([\d.]+)"),
                             "005 PostLSEClk_PostLSEFmax":re.compile('''create_clock\s+-period\s+\S+\s+-name\s+
                                        \S+\s+
                                        \[get_nets\s+(\S+?)\]\s+
                                        [\.\d]+\s+MHz\s+
                                        ([\.\d]+)\s+MHz''', re.VERBOSE | re.I),
                             #Peak Memory Usage: 51.152  MB
                             "007 LsePeakMem":re.compile("^Peak\sMemory\sUsage:\s+([\d.]+)"),
                             #At c_hdl Exit (Real Time elapsed 0h:00m:03s; CPU Time elapsed 0h:00m:03s; Memory used current: 3MB peak: 4MB)
                             "008 at_c_hdl":re.compile("^At c_hdl Exit \(Real Time elapsed\s+(.+);\s+CPU Time elapsed\s+(.+);"),
                             #At syn_nfilter Exit (Real Time elapsed 0h:00m:00s; CPU Time elapsed 0h:00m:00s; Memory used current: 77MB peak: 78MB)
                             "009 at_syn_nfilter":re.compile("^At syn_nfilter Exit \(Real Time elapsed\s+(.+);\s+CPU Time elapsed\s+(.+);"),
                             #At Mapper Exit (Real Time elapsed 0h:00m:00s; CPU Time elapsed 0h:00m:00s; Memory used current: 88MB peak: 153MB)
                             "010 pre_opt_map":re.compile("^At Mapper Exit \(Real Time elapsed\s+(.+);\s+CPU Time elapsed\s+(.+);"),
                             }
        self.patterns_mrp = {
                             #   Total CPU Time: 3 secs
                             "001 mrp_CPU_Time": re.compile("Total\s+CPU\s+Time:\s+(.+)"),

                             #   Total REAL Time: 4 secs
                             "002 mrp_REAL_Time": re.compile("Total\s+REAL\s+Time:\s+(.+)")
                             }
        self.patterns_par = {
                             #Total CPU time 1 mins 41 secs
                             "001 par_CPU_Time": re.compile("Total\s+CPU\s+time\s+to\s+completion:?\s+(.+)"),
                             #Total REAL time: 1 mins 42 secs
                             "002 par_REAL_Time": re.compile("Total\s+REAL\s+time\s+to\s+completion:\s+(.+)"),
                             "003 Complete" : re.compile("All signals are completely routed."),
                             "004 Par_Done" : re.compile("par done!"),
                             #PAR peak memory usage: 59.777 Mbytes
                            # "005 ParPeakMem":re.compile("PAR\s+peak\s+memory\s+usage:\s+([\d \.]+)\s+Mbytes"),
                             # peak-memory=214.9 M
                             "006 NG_ParPeakMem" : re.compile("peak-memory=([\d \.]+)\s+"),
                             }
        self.srr_data     = {
                            'srr_Real_time':'NA',
                            'srr_Cpu_time' : 'NA',
                            'CCU_lse':'NA',
                            'Regs':'NA',
                            'LUT4':'NA',

                            'SynPeakMem':'NA',
                            'lse_CPU_Time':'NA',
                            'PostLSEClk':'NA',
                            'PostLSEFmax':'NA',
                            'LsePeakMem':'NA'
                            }
        self.mrp_time = {}
        for key in self.patterns_mrp.keys():
            key = key.split()[1]
            self.mrp_time[key] = 'NA'
        self.par_data={}
        for key in self.patterns_par.keys():
            key = key.split()[1]
            self.par_data[key] = 'NA'
        self.reset()
    def scan_srr(self,srr_file):
        self.srr_data     = {
                            'srr_Real_time':'NA',
                            'srr_Cpu_time' : 'NA',
                            'CCU_lse':'NA',
                            'Regs':'NA',
                            'LUT4':'NA',
                            'SynPeakMem':'NA',
                            'lse_CPU_Time':'NA',
                            'PostLSEClk':'NA',
                            'PostLSEFmax':'NA',
                            'LsePeakMem':'NA'
                            }
        self.find_009_flag = 0
        if not srr_file:
            return
        file_hand =  file(srr_file,'r')
        lines = file_hand.readlines()
        file_hand.close()
        hotlines=[]
        for line in lines:
            line = line.strip()
            hotlines.append(line)
            match = (self.patterns_srr["001 srr_time"]).search(line)
            if match: # this is useless now,
                if self.srr_data['srr_Real_time'] == "NA":
                    self.srr_data['srr_Real_time'] = '0'
                    self.srr_data['srr_Cpu_time'] = '0'
                self.srr_data['srr_Real_time'] = str( int(self.srr_data.get("srr_Real_time",0))+ int( time2secs(match.group(1))) )
                self.srr_data['srr_Cpu_time'] = str( int(self.srr_data.get('srr_Cpu_time',0))+ int( time2secs(match.group(2))) )
                continue
            match = (self.patterns_srr["008 at_c_hdl"]).search(line)
            if match:
                if self.srr_data['srr_Real_time'] == "NA":
                    self.srr_data['srr_Real_time'] = '0'
                    self.srr_data['srr_Cpu_time'] = '0'
                self.srr_data['srr_Real_time'] = str( int(self.srr_data.get("srr_Real_time",0))+ int( time2secs(match.group(1))) )
                self.srr_data['srr_Cpu_time'] = str( int(self.srr_data.get('srr_Cpu_time',0))+ int( time2secs(match.group(2))) )

            match = (self.patterns_srr["009 at_syn_nfilter"]).search(line)
            if match :
                if self.srr_data['srr_Real_time'] == "NA":
                    self.srr_data['srr_Real_time'] = '0'
                    self.srr_data['srr_Cpu_time'] = '0'
                self.find_009_flag += 1
                if  self.find_009_flag != 2:
                    pass
                else:
                    self.srr_data['srr_Real_time'] = str( int(self.srr_data.get("srr_Real_time",0))+ int( time2secs(match.group(1))) )
                    self.srr_data['srr_Cpu_time'] = str( int(self.srr_data.get('srr_Cpu_time',0))+ int( time2secs(match.group(2))) )

            match = (self.patterns_srr["010 pre_opt_map"]).search(line)
            if match:
                if self.srr_data['srr_Real_time'] == "NA":
                    self.srr_data['srr_Real_time'] = '0'
                    self.srr_data['srr_Cpu_time'] = '0'
                self.srr_data['srr_Real_time'] = str( int(self.srr_data.get("srr_Real_time",0))+ int( time2secs(match.group(1))) )
                self.srr_data['srr_Cpu_time'] = str( int(self.srr_data.get('srr_Cpu_time',0))+ int( time2secs(match.group(2))) )

            match = (self.patterns_srr["002 CCU_lse"]).search(line)
            if match:
                self.srr_data['CCU_lse'] = match.group(1)
                continue
            match = (self.patterns_srr["000 Regs"]).search(line)
            if match:
                self.srr_data['Regs'] = match.group(1)
                continue
            match = (self.patterns_srr["000 LUT4"]).search(line)
            if match:
                self.srr_data['LUT4'] = match.group(1)
                continue


            match = (self.patterns_srr["003 SynPeakMem"]).search(line)
            if match:
                old_data = self.srr_data.get('SynPeakMem','')
                if not old_data or old_data == "NA":
                    self.srr_data['SynPeakMem'] = match.group(1)
                else:
                    if old_data == "NA":
                       old_data = 0
                    if float(old_data) < float(match.group(1)):
                        self.srr_data['SynPeakMem'] = match.group(1)
                    else:
                        pass
                continue
            match = (self.patterns_srr["004 lse_CPU_Time"]).search(line)
            if match:
                self.srr_data['lse_CPU_Time'] = time2secs(match.group(1))
                continue
            match = (self.patterns_srr["007 LsePeakMem"]).search(line)
            if match and srr_file.endswith('synthesis.log'):
                self.srr_data['LsePeakMem'] = match.group(1)
                continue
        hotlines = " ".join(hotlines)
        hotlines = re.sub("\s*\|", "", hotlines)
        all_hot_data = self.patterns_srr["005 PostLSEClk_PostLSEFmax"].findall(hotlines)
        if not all_hot_data:
            pass
        else:
            old_fmax = -1
            for (clk_t, fmax_t) in all_hot_data:
                float_fmax = float(fmax_t)
                if old_fmax < 0 or float_fmax < old_fmax:
                    self.srr_data['PostLSEClk'] = clk_t
                    self.srr_data['PostLSEFmax'] = fmax_t
                    old_fmax = float(fmax_t)
        '''
            at here, we use to get the cpu time from the automat.log
        '''
        automat_log = os.path.join(os.path.dirname(os.path.dirname(srr_file)),'run_till_map.log')
        if not os.path.isfile(automat_log):
            return
        elif srr_file.endswith('.srr'):
            temp_cpu_time = 0
            temp_real_time = 0
            set_flag = 0
            all_lines = file(automat_log).readlines()
            for l in all_lines:
                if l.startswith('edif2ngd:') or l.startswith('ngdbuild:'):
                    set_flag = 1
                value = re.compile("Total\s+CPU\s+Time:\s+(.+)")
                match = value.search(l)
                if match and set_flag:
                    match_data = match.group(1)
                    match_data = time2secs(match_data.strip())
                    temp_cpu_time += int(match_data)
                value = re.compile("Total\s+REAL\s+Time:\s+(.+)")
                match = value.search(l)
                if match and set_flag:
                    match_data = match.group(1)
                    match_data = time2secs(match_data.strip())
                    temp_real_time += int(match_data)
                    set_flag = 0
                if l.startswith('map'):
                    break

            try:
                self.srr_data['srr_Cpu_time'] =str( int(self.srr_data['srr_Cpu_time'])+int( temp_cpu_time) )
                self.srr_data['srr_Real_time'] =str( int(self.srr_data['srr_Real_time'])+int(temp_real_time) )
            except:
                print 'Error: in srr and automake add'

    def get_srr_time_data(self):
        return self.srr_data
    def scan_mrp(self,mrp_file):
        for key in self.patterns_mrp.keys():
            key = key.split()[1]
            self.mrp_time[key] = 'NA'
        if not mrp_file:
            return
        file_hand = file(mrp_file,'r')
        lines = file_hand.readlines()
        file_hand.close()


        for line in lines:
            line  = line.strip()
            for key in self.patterns_mrp.keys():
                value = self.patterns_mrp[key]
                match = value.search(line)
                if match:
                    match_data = match.group(1)
                    match_data = time2secs(match_data.strip())
                    self.mrp_time[key.split()[1]] = match_data
    def get_mrp_time_data(self):
        return self.mrp_time
    def scan_par(self,par_file):
        self.par_data={}
        for key in self.patterns_par.keys():
            key = key.split()[1]
            self.par_data[key] = 'NA'
        if not par_file:
            return
        file_hand = file(par_file,'r')
        lines = file_hand.readlines()
        file_hand.close()


        for line in lines:
            line = line.strip()
            for key in self.patterns_par.keys():
                p_value = self.patterns_par[key]
                p_match = p_value.search(line)
                p_key = key.split()[1]
                if p_match:
                    if p_key == 'Complete' or p_key == 'Par_Done':
                       self.par_data[p_key] = 'YES'
                    else:
                        self.par_data[p_key] = time2secs( (p_match.group(1)).strip() )
    def get_par_time_data(self):
        return self.par_data
    def reset_par_time_data(self):
        for key in self.patterns_par.keys():
            key = key.split()[1]
            self.par_data[key] = 'NA'
    def get_total_time(self):
        srr_time = self.get_srr_time_data()
        mrp_time = self.get_mrp_time_data()
        par_time = self.get_par_time_data()
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
                    self.cpu_time = self.cpu_time + int(float(srr_time[key]))
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
        srr_time = self.get_srr_time_data()
        mrp_time = self.get_mrp_time_data()
        par_time = self.get_par_time_data()
        srr_title =  srr_time.keys()
        srr_title.sort()
        mrp_title =  mrp_time.keys()
        mrp_title.sort()
        par_title =  par_time.keys()
        par_title.sort()
        title = srr_title+mrp_title+par_title+['Total_cpu_time','Total_real_time']
        return title

if __name__ == "__main__":
    mrp_file = r"D:\Users\yzhao1\workspace\scan_report\run\08_vj1kfpga\_xo2_synp\xo2_synp_08_vj1k.mrp"
    pp = ScanLatticeMrp()
    pp.scan_report(mrp_file)
    pp.scan_clocks(mrp_file)
    print pp.get_parse_line_clocks()
    print '----------------------'
    pp = ScanLatticeTime()
    pp.scan_srr(r'D:\Users\yzhao1\workspace\scan_report\bs\blowfish\_sc_synp\rev_1\sc_synp_blowfis.srr')
    print pp.get_srr_time_data()
    pp.scan_mrp(mrp_file)
    print '-------------'
    pp.scan_par(r'\\d27817\test_dir\strdom_test_ecp3_ecp4u\zzz_ecp3_L25_job_dir_60standard\g64\_ecp3_synp\Target_Fmax_is_035MHz\5_1.par')
    print pp.get_par_time_data()
    pp.get_total_time()
    pp.get_title()