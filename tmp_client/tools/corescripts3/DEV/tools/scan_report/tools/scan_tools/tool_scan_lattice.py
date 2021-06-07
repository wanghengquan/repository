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

def get_clock_loads_from_mrp_file_old(mrp_file):
    if not_exists(mrp_file, "Lattice Mrp file"):
        return
    p_clock_number = re.compile("^Number\s+of\s+clocks:\s+(\d+)")
    p_clock = re.compile("^Net\s+([^:]+):\s+(\d+)\s+loads")  # Net CLK311_c: 10191 loads
    p_stop = re.compile("Number of Clock Enables")
    clock_number = 0
    clock_loads = dict()
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
            clock_loads[mc.group(1)] = int(mc.group(2))
    if len(clock_loads) != clock_number:
        print_error("Not found %d clocks in %s" % (clock_number, mrp_file))
        return
    return clock_loads

def get_clock_loads_from_mrp_file(mrp_file):
    if not_exists(mrp_file, "Lattice Mrp file"):
        return
    p_clock_number = re.compile("^Number\s+of\s+clocks:\s+(\d+)")
    p_net_load = re.compile("Net\s+([^:]+):\s*(\d+)\s*loads,")
    p_stop = re.compile("^Number of")
    p_skip_patterns = [re.compile("^$"),
                       re.compile("^Design:.+Date:"),
                       re.compile("^Design Summary"),
                       re.compile("^-+$")]
    clock_number = 0
    clock_loads = dict()
    mrp_ob = open(mrp_file)
    my_hot_lines = list()
    while True:
        line = mrp_ob.readline()
        if not line:
            break
        line = line.strip()
        if not clock_number:
            mcn = p_clock_number.search(line)
            if mcn:
                clock_number = int(mcn.group(1))
            continue
        if p_stop.search(line):
            break
        for p in p_skip_patterns:
            if p.search(line):
                break
        else:
            my_hot_lines.append(line)

    my_hot_lines = "".join(my_hot_lines)
    f_all = p_net_load.findall(my_hot_lines)
    for(net, load) in f_all:
        clock_loads[net] = int(load)
    if len(clock_loads) != clock_number:
        print_error("Not found %d clocks in %s" % (clock_number, mrp_file))
        # return
        """
        Sometimes no loads/rising/.. log for a net!!!!
         Net sn5wht/lclk: 8 loads, 8 rising, 0 falling (Driver: sn5wht/losc/un8_lclk
     )
     Net cmos_to_dphy_gen_inst/cmos_2_dphy_ip_inst/byte_clk_w: MIPIDPHY cmos_to_
     dphy_gen_inst/cmos_2_dphy_ip_inst/byte_clk_o_I_0/dci_wrapper_inst/clk_p_o_I
     _0 clock
     Net cmos_to_dphy_gen_clk_n_o: MIPIDPHY cmos_to_dphy_gen_inst/cmos_2_dphy_ip
     _inst/byte_clk_o_I_0/dci_wrapper_inst/clk_p_o_I_0 clock
     Net cmos_to_dphy_gen_clk_p_o: MIPIDPHY cmos_to_dphy_gen_inst/cmos_2_dphy_ip
     _inst/byte_clk_o_I_0/dci_wrapper_inst/clk_p_o_I_0 clock

        """
    return clock_loads

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
        print(line, file=prf_ob)
    for clk in clocks:
        print('FREQUENCY NET "%s" %s MHz ;' % (clk, fixed_number), file=prf_ob)
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
        print(line, file=prf_ob)

    prf_ob.close()

def remove_percent_to_float(a_string):
    new_string = re.sub("%", "", a_string)
    return float(new_string)


class ScanLatticeTwr:
    def __init__(self, pap,all_clk=False):
        self.pap = pap  # Performance Achievement Percentage

        self.title = [r"Seed_Target","pap", "PAPFactor", "targetFmax", "fmax", "clkName", "logic",
                      "route", "level", "twrLabel","score_setup","score_hold",'Pass_num',"S_pref_num",'H_pref_num',
                      "logic_level", "carry_chain", "cell_delay", "routing_delay"]
        self.all_clk=all_clk
        self.create_patterns()
        self.all_raw_data = list()
        #Score: 1467 (setup), 0 (hold)
        self.score = re.compile('Score: (\d+) \(setup\), (\d+) \(hold\)')
        self.score_data_setup = 'NA'
        self.score_data_hold = 'NA'
    def create_patterns(self):
        self.p_fre_clk = re.compile('^Preference: FREQUENCY[^"]+"([^"]+)"')
        # Preference: FREQUENCY NET "ck19fb_out_o" 280.000000 MHz ;
        self.p_lrl = re.compile("""
                                (?P<delay>[\d\.]+)ns
                                \s+\(
                                (?P<logic>[\d\.]+%)\s+logic,\s+
                                (?P<route>[\d\.]+%)\s+route
                                \),\s+
                                (?P<level>\d+)\s+logic\s+level
                                """, re.VERBOSE)
        # Delay:               0.298ns  (81.2% logic, 18.8% route), 2 logic levels.
        if self.pap:
            self.create_pap_patterns()
        else:
            self.create_fmax_patterns()

    def create_pap_patterns(self):
        self.rpt_start = re.compile("Dump PAP Details", re.I)
        # PAP=   48.92% | 280.00 MHz | 137.01 MHz |   1.00 | FREQUENCY NET "spi4_clk_int" 280.000000 MHz ;
        self.rpt_pattern = re.compile('''PAP=\s+
                                      ([\d\.]+%)\s+            # PAP
                                      ([\d\.]+)\s+MHz\s+       # Constraint
                                      ([\d\.]+)\s+MHz\s+       # Actual
                                      ([\d\.]+)\s+             # Factor
                                      FREQUENCY[^"]+
                                      "([^"]+)"                # Clock name
                                      ''', re.VERBOSE | re.I)
        # can prcess the line as:
        # PAP=  131.14% |  80.00 MHz | 104.91 MHz |   1.00 | FREQUENCY 80.000000 MHz ;
        self.rpt_pattern = re.compile('''PAP=\s+
                                      ([\d\.]+%)\s+            # PAP
                                      ([\d\.]+)\s+MHz\s+       # Constraint
                                      ([\d\.]+)\s+MHz\s+       # Actual
                                      ([\d\.]+)\s+             # Factor
                                      FREQUENCY
                                      (.*?)\d+\.                 # Clock name
                                      ''', re.VERBOSE | re.I)
        self.raw_title = ["pap", "targetFmax", "fmax", "PAPFactor", "clkName"]
        self.rpt_stop = re.compile("Overall Performance")

    def create_fmax_patterns(self):
        self.rpt_start = re.compile("^Report\s+Summary")
        # FREQUENCY NET "fir_clk_c" 300.000000    |             |             |
        # MHz ;                                   |  300.000 MHz|  443.656 MHz|   2
        self.rpt_pattern = re.compile('''FREQUENCY[^"]+
                                      "([^"]+)"              # Clock name
                                      [^;]+;
                                      \s+([\d\.\-]+)\s+MHz    # Constraint
                                      \s+([\d\.\-]+)\s+MHz     # Actual
                                      \s+\d+                 # Level
                                      ''', re.VERBOSE | re.I)
        if self.all_clk:
            self.rpt_pattern = re.compile('''FREQUENCY[^"]+
                                      "([^"]+)"              # Clock name
                                      [^;]+;
                                      \s+([\d\.\-]+)\s+(MHz)?     # Constraint
                                      \s+([\d\.\-]+)\s+(MHz)?     # Actual
                                      \s+\d+                 # Level
                                      ''', re.VERBOSE | re.I)
        self.raw_title = ["clkName", "targetFmax", "fmax"]
        self.rpt_stop = re.compile("^$")  # empty line

    def get_title(self):
        return self.title

    def get_all_data(self):
        return self.all_raw_data
        #all_data = list()
        #for item in self.all_raw_data:
        #    t_data = [item.get(foo) for foo in self.title]
        #    all_data.append(t_data)
        #return all_data
    def set_all_data(self):
        self.all_raw_data = list()



    def get_data(self):
        if self.pap:
            return self.get_pap_data()
        else:
            return self.get_fmax_data()

    def get_pap_data(self):
        """The minimize PAP clock data
        """
        return self._get_minimize("pap")

    def get_fmax_data(self):
        """The minimize fmax clock data
        """
        return self._get_minimize("fmax")

    def get_central_fmax(self):
        fmax_data = self._get_minimize("fmax")
        fmax_idx = self.title.index("fmax")
        return fmax_data[fmax_idx]

    def scan_report(self, rpt_file,  hot_clk=""):
        self.hot_clk = hot_clk
        self.rpt_file = rpt_file
        self.raw_data = list()
        if not os.path.isfile(rpt_file):
            return
        start, hotlines1 = 0, list()
        hotlines2 = list()
        start_flag = 0
        set_up_pref_num_fail = 0
        hold_pref_num_fail = 0
        frequency_flag = 0
        for line in open(rpt_file):
            if not start:
                if self.rpt_start.search(line):
                    start = 1
                    start_flag += 1
                continue
            line = line.strip()
            if self.rpt_stop.search(line) and start_flag == 1:
                start = 0
                continue
            if self.rpt_stop.search(line) and start_flag > 1:
                break
            line = re.sub("\s*\|", " ", line)
            if start_flag == 1:
                hotlines1.append(line)
                frequency_flag += 1
                if line.startswith('FREQUENCY'):
                    frequency_flag = 0
                if line.endswith('*') and frequency_flag<3:
                    set_up_pref_num_fail += 1
                    frequency_flag = 0
            else:
                hotlines2.append(line)
                frequency_flag += 1
                if line.startswith('FREQUENCY'):
                    frequency_flag = 0
                if line.endswith('*') and frequency_flag<3:
                    hold_pref_num_fail += 1
                    frequency_flag = 0

        hotlines1 = "".join(hotlines1)
        hotlines2 = "".join(hotlines2)
        self.raw_data  = self.rpt_pattern.findall(hotlines1)
        set_up_pref_num= hotlines1.count('FREQUENCY')
        #set_up_pref_num_fail  = hotlines1.count('*')

        hold_pref_num=  hotlines2.count('FREQUENCY')
        #hold_pref_num_fail = hotlines2.count('*')

        if not self.raw_data:
            print_error("No frequency data found in %s" % rpt_file)
            return 1
            #
        set_up_pref = str(set_up_pref_num)+'\\'+str(set_up_pref_num_fail)
        hold_pref = str(hold_pref_num)+'\\'+str(hold_pref_num_fail)
        ###########new add for score ###############
        for line in open(rpt_file):
            p = self.score.search(line)
            if p:
                self.score_data_setup = p.group(1)
                self.score_data_hold = p.group(2)
        self._get_all_raw_data(rpt_file,set_up_pref,hold_pref)


    def _get_all_raw_data(self, rpt_file,set_up_pref='',hold_pref=''):
        self.all_raw_data = list()
        ##########
        # at here, add the pass number for Jeffrey
        # and the case directory will be:\\d27417\benchmark\D3.4.0.80\L25_ecp2\apxc_lever\_scratch
        # at here, the script scan twr file. and the path look as '_scratch\Target_fmax_050.00MHz\Impl\*.twr'
        _scratch_dir =  os.path.dirname( os.path.dirname(os.path.dirname(rpt_file)) )
        pass_num = 0
        for temp_dir in os.listdir(_scratch_dir):
            if os.path.isdir(os.path.join(_scratch_dir,temp_dir)) and temp_dir.startswith('Target') and (not temp_dir.endswith('Failed') ):
                pass_num += 1
        #########################################################
        try:
            all_clk_file = file("all_clock.csv","a")
        except IOError:
            return
        all_clk_file.write("Design,"+",".join(self.raw_title) + "\n")
        for item in self.raw_data:
            if self.all_clk:
                item = [ item[0],item[1],item[3] ]
            t_data = dict(list(zip(self.raw_title, item)))
            full_path = os.path.abspath(rpt_file)
            all_clk_file.write(os.path.basename(_scratch_dir)+","+",".join(item) + "\n")
            full_path_re = re.compile(r'Target_(seed|fmax)_([\w\d_\.]+)')
            full_path_m = full_path_re.search(full_path)
            if full_path_m:

                try:
                    t_data["Seed_Target"]  = full_path_m.group(2)
                except:
                    t_data["Seed_Target"] = 'NA'
            else:
                t_data["Seed_Target"] = 'NA'
            t_data['Pass_num'] = str(pass_num)
            t_data["twrLabel"] = os.path.basename(os.path.dirname( os.path.dirname( os.path.abspath(rpt_file) ) ) )+'_'+ \
                                os.path.basename( os.path.dirname( os.path.abspath(rpt_file) ) )+'_'+get_fname_ext(rpt_file)[0]
            clk_name = t_data.get("clkName")
            if self.hot_clk:
                if clk_name != self.hot_clk or clk_name.find(self.hot_clk)== -1:
                    continue
            lrl = self._get_lrl(t_data.get("clkName"))
            if lrl:
                t_data.update(lrl)
            pap_number = t_data.get("pap")
            if not pap_number:
                try:
                    pap_number = "%s/%s" % (t_data.get("fmax"), t_data.get("targetFmax"))
                    pap_number = eval(pap_number) * 100
                    pap_number = "%.2f%%" % pap_number
                    t_data["pap"] = pap_number
                    t_data["PAPFactor"] = "-"
                except:
                    t_data["pap"] = "-"
                    t_data["PAPFactor"] = "-"
            ###########add for score ############
            t_data.update({'score_setup':self.score_data_setup,'score_hold':self.score_data_hold})
            ###########add for score ############
            t_data.update({'S_pref_num':set_up_pref,'H_pref_num':hold_pref})
            self.all_raw_data.append(t_data)
        all_clk_file.close()



    def _get_lrl(self, clk_name):
        start = 0
        rpt_ob = open(self.rpt_file)
        ori_dict= dict()
        while True:
            line = rpt_ob.readline()
            if not line:
                break
            if not start:
                m_fre_clk = self.p_fre_clk.search(line)
                if m_fre_clk:
                    fre_clk = m_fre_clk.group(1)
                    if fre_clk == clk_name:
                        start = 1
                continue
            m_lrl = self.p_lrl.search(line)
            if m_lrl:
                lrl_title = ["logic", "route", "level"]
                lrl_data = [m_lrl.group(item) for item in lrl_title]
                ori_dict = dict(list(zip(lrl_title, lrl_data)))

                delay_ns = float(m_lrl.group("delay"))
                ori_dict["logic_level"] = m_lrl.group("level")
                _cell_delay = delay_ns * remove_percent_to_float(m_lrl.group("logic")) /100.0
                ori_dict["cell_delay"] = "%.3f" % _cell_delay
                _routing_delay = delay_ns * remove_percent_to_float(m_lrl.group("route"))/100.0
                ori_dict["routing_delay"] = "%.3f" % _routing_delay
                ori_dict["carry_chain"] = self._get_carry_chain(rpt_ob)
                break
        return ori_dict

    def _get_carry_chain(self, rpt_ob):
        cc_number = 0
        p_FCO = re.compile("\.FCO\s+to\s+")
        p_FCI = re.compile("\.FCI\s+to\s+")
        while True:
            line = rpt_ob.readline()
            if not line:
                break
            m_lrl = self.p_lrl.search(line)
            if m_lrl:
                break
            if p_FCO.search(line):
                line = rpt_ob.readline()
                if p_FCI.search(line):
                    cc_number += 1
        return str(cc_number)

    def _get_float(self, raw_str):
        raw_str = re.sub("\D+", "", raw_str)
        return float(raw_str)


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
                new_value = self._get_float(new_value)
                old_value = self._get_float(old_value)
                if old_value > new_value:
                    min_data = item
        return [min_data.get(item, "NA") for item in self.title]

class ScanLatticeMrp(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self)
        self.patterns = {
            "001 version" : re.compile("^Mapper:.+version:\s+(.+)"),
            "002 device" : [re.compile("^Target Device:\s+(\S+)"),
                            re.compile("^Target Performance:\s+(\S+)")],
            # Target Device:  LFEC6EFPBGA256
            # Target Performance:   5
            # Mapper:  ep5g00,  version:  Diamond Version 2.1.0.56
            # -----
            "003 Register" : [re.compile("^Number of registers:\s+(\d+)"),
                              re.compile("^Number of PFU registers:\s+(\d+)")],
            "003 Register_per" : [re.compile("^Number of registers:.+\(([^\)]+)\)"),
                              re.compile("^Number of PFU registers:.+\(([^\)]+)\)")],

            "004 Slice" : re.compile("^Number of SLICEs:\s+(\d+)"),
            "004 Slice_per" : re.compile("^Number of SLICEs:.+\(([^\)]+)\)"),
            "005 LUT" : [re.compile("^Total number of LUT4s:\s+(\d+)"),
                         re.compile("^Number of LUT4s:\s+(\d+)")],
            "005 LUT_per" : [re.compile("^Total number of LUT4s:.+\(([^\)]+)\)"),
                         re.compile("^Number of LUT4s:.+\(([^\)]+)\)")],
            # Number of registers:    728
            # Number of SLICEs:           656 out of  3072 (21%)
            # Total number of LUT4s:     774
            #Number of LUT4s:        57172 out of 92016
            # -----
            "006 IO" : [re.compile("^Number of PIO sites used:\s+(\d+)"),
                        re.compile("^Number of external PIOs:\s+(\d+)")],
            "007 EBR" : re.compile("^Number of block RAMs:\s+(\d+)"),
            "008 DRAM" : [re.compile("^Number of distributed RAM:\s+(\d+)"),re.compile("^Number used as distributed RAM:\s+(\d+)")],

            # Number of PIO sites used: 143 out of 195 (73%)
            # Number of block RAMs:  3 out of 10 (30%)
            # Number of distributed RAM:  16 (32 LUT4s)
            # -----
            "009 DSP" : re.compile("^Number of Used DSP Sites:\s+(\d+)"),
            "010 DSP_MULT" : re.compile("^Number of Used DSP MULT Sites:\s+(\d+)"),
            "011 DSP_ALU" : re.compile("^Number of Used DSP ALU Sites:\s+(\d+)"),
            # Number of Used DSP Sites:  0 out of 48 (0 %)
            # Number of Used DSP MULT Sites:  0 out of 48 (0 %)
            # Number of Used DSP ALU Sites:  0 out of 24 (0 %)
            # -----
            "012 PCS" : re.compile("^Number of PCS \(SerDes\):\s+(\d+)"),
            # Number of PCS (SerDes):  0 out of 1 (0%) with bonded PIO sites
            #Number of distributed RAM:   0 (0 LUT4s)
            "013 distributed_RAM" : [re.compile("^Number of distributed RAM:\s+(\d+)"), re.compile("^Number used as distributed RAM:\s+(\d+)")],
            #Number of ripple logic:    2598 (5196 LUT4s)
            "014 CCU" : [re.compile("^Number of ripple logic:\s+(\d+)"),re.compile("^Number used as ripple logic:\s+(\d+)")],
            ### add dsp detail

            "015 MULT18X18D" : re.compile("^MULT18X18D\s+(\d+)"),
            "016 MULT9X9D" : re.compile("^MULT9X9D\s+(\d+)"),
            "017 ALU54B" : re.compile("^ALU54B\s+(\d+)"),
            "018 ALU24B" : re.compile("^ALU24B\s+(\d+)"),
            "019 PRADD18A" : re.compile("^PRADD18A\s+(\d+)"),
            "019 PRADD9A" : re.compile("^PRADD9A\s+(\d+)"),

            "020 MULT36X36B" : re.compile("^MULT36X36B\s+(\d+)"),
            "021 MULT18X18B" : re.compile("^MULT18X18B\s+(\d+)"),
            "022 MULT18X18MACB" : re.compile("^MULT18X18MACB\s+(\d+)"),
            "023 MULT18X18ADDSUBB" : re.compile("^MULT18X18ADDSUBB\s+(\d+)"),
            "024 MULT18X18ADDSUBSUMB" : re.compile("^MULT18X18ADDSUBSUMB\s+(\d+)"),
            "025 MULT9X9B" : re.compile("^MULT9X9B\s+(\d+)"),
            "026 MULT9X9ADDSUBB" : re.compile("^MULT9X9ADDSUBB\s+(\d+)"),


            "027 MULT18X18C" : re.compile("^MULT18X18C\s+(\d+)"),
            "028 MULT9X9C" : re.compile("^MULT9X9C\s+(\d+)"),
            "029 ALU54A" : re.compile("^ALU54A\s+(\d+)"),
            "030 ALU24A" : re.compile("^ALU24A\s+(\d+)"),
            "stop" : re.compile("^Page\s+80"),

            "100 MapCPUTime" : re.compile("^Total CPU Time:\s+(.+)"),
            "101 map_peak_Memory" : re.compile("^Peak Memory Usage:\s+(\d+) MB")
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
        self.keys_clocks = list(self.patterns_for_clocks.keys())
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
                             "002 mrp_REAL_Time": re.compile("Total\s+REAL\s+Time:\s+(.+)"),
                             "003 clkNumber" : re.compile("NO_PATTERN"),
                             "004 maxLoads" : re.compile("NO_PATTERN"),
                             "005 totalLoads" : re.compile("NO_PATTERN"),

                             }
        self.patterns_par = {
                             #Total CPU time 1 mins 41 secs
                             "001 par_cpu_Time": re.compile("Total\s+CPU\s+time\s+to\s+completion:?\s+(.+)"),
                             #Total REAL time: 1 mins 42 secs
                             "002 par_real_Time": re.compile("Total\s+REAL\s+time\s+to\s+completion:\s+(.+)"),
                             "003 Complete" : re.compile("All signals are completely routed."),
                             "004 Par_Done" : re.compile("par done!"),
                             "004 parComment" : re.compile("(ERROR\s+-\s+.{1,100})"),
                             #PAR peak memory usage: 59.777 Mbytes
                             "005 ParPeakMem": re.compile("PAR\s+peak\s+memory\s+usage:\s+([\d \.]+)\s+Mbytes"),
                             "006 par_signals": re.compile("Number\s+of\s+Signals:\s+(.+)"),
                             "007 par_connections": re.compile("Number\s+of\s+Connections:\s+(.+)"),
                             "008 par_congestion_level" : re.compile("Initial\s+congestion\s+level\s+at.+is\s+(\d+)"),
                             "009 par_congestion_area" : re.compile("Initial\s+congestion\s+area.+is\s+(\d+)"),
                             "010 par_congestion_area_per" : re.compile("Initial\s+congestion\s+area.+is\s+\d+\s+\(([^\)]+)\)"),
                             }
        self.srr_data     = {
                            'srr_Real_time':'NA',
                            'srr_Cpu_time' : 'NA',
                            'CCU_lse':'NA',
                            'SynPeakMem':'NA',
                            'lse_CPU_Time':'NA',
                            'PostLSEClk':'NA',
                            'PostLSEFmax':'NA',
                            'LsePeakMem':'NA'
                            }
        self.mrp_time = {}
        for key in list(self.patterns_mrp.keys()):
            key = key.split()[1]
            self.mrp_time[key] = 'NA'
        self.par_data={}
        for key in list(self.patterns_par.keys()):
            key = key.split()[1]
            self.par_data[key] = 'NA'
        self.reset()
    def scan_srr(self,srr_file):
        self.srr_data     = {
                            'srr_Real_time':'NA',
                            'srr_Cpu_time' : 'NA',
                            'CCU_lse':'NA',
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
                print('Error: in srr and automake add')

    def get_srr_time_data(self):
        return self.srr_data
    def scan_mrp(self,mrp_file):
        self.clk_loads = dict()
        for key in list(self.patterns_mrp.keys()):
            key = key.split()[1]
            self.mrp_time[key] = 'NA'
        if not mrp_file:
            return
        self.clk_loads = get_clock_loads_from_mrp_file(mrp_file)
        self.clk_loads_data = dict()
        self.clk_loads_data["clkNumber"] = str(len(self.clk_loads))
        _loads = [self.clk_loads[key] for key in list(self.clk_loads.keys())]
        try:
            self.clk_loads_data["maxLoads"] = str(max(_loads))
            self.clk_loads_data["totalLoads"] = str(sum(_loads))
        except ValueError:
            self.clk_loads_data["maxLoads"] = self.clk_loads_data["totalLoads"] = "NA"

        file_hand = file(mrp_file,'r')
        lines = file_hand.readlines()
        file_hand.close()


        for line in lines:
            line  = line.strip()
            for key in list(self.patterns_mrp.keys()):
                value = self.patterns_mrp[key]
                match = value.search(line)
                if match:
                    match_data = match.group(1)
                    match_data = time2secs(match_data.strip())
                    self.mrp_time[key.split()[1]] = match_data
        self.mrp_time.update(self.clk_loads_data)
    def get_mrp_time_data(self):
        return self.mrp_time
    def scan_par(self,par_file):
        self.par_data={}
        for key in list(self.patterns_par.keys()):
            key = key.split()[1]
            self.par_data[key] = 'NA'
        if not par_file:
            return
        file_hand = file(par_file,'r')
        lines = file_hand.readlines()
        file_hand.close()

        for line in lines:
            line = line.strip()
            for key in list(self.patterns_par.keys()):
                p_value = self.patterns_par[key]
                p_match = p_value.search(line)
                p_key = key.split()[1]
                if p_match:
                    if p_key in ('Complete', 'Par_Done'):
                       self.par_data[p_key] = 'YES'
                    elif p_key in ("parComment", ):
                        self.par_data[p_key] = re.sub(",", "", p_match.group(1))
                    else:
                        self.par_data[p_key] = time2secs( (p_match.group(1)).strip() )
    def get_par_time_data(self):
        return self.par_data
    def reset_par_time_data(self):
        for key in list(self.patterns_par.keys()):
            key = key.split()[1]
            self.par_data[key] = 'NA'
    def get_total_time(self):
        srr_time = self.get_srr_time_data()
        mrp_time = self.get_mrp_time_data()
        par_time = self.get_par_time_data()
        self.total_time = {}
        self.real_time = 0
        self.cpu_time = 0
        for key in list(srr_time.keys()):
            key_lower = key.lower()
            if key_lower.find('real_time')!= -1:
                try:
                    self.real_time = self.real_time + int(srr_time[key])
                except Exception as e:
                    print(e)
                    pass
            if key_lower.find('cpu_time')!= -1:
                try:
                    self.cpu_time = self.cpu_time + int(float(srr_time[key]))
                except:
                    pass
        for key in list(mrp_time.keys()):
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
        for key in list(par_time.keys()):
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
        srr_title =  list(srr_time.keys())
        srr_title.sort()
        mrp_title =  list(mrp_time.keys())
        mrp_title.sort()
        par_title =  list(par_time.keys())
        par_title.sort()
        title = srr_title+mrp_title+par_title+['Total_cpu_time','Total_real_time']
        return title

if __name__ == "__main__":
    mrp_file = r"D:\Users\yzhao1\workspace\scan_report\run\08_vj1kfpga\_xo2_synp\xo2_synp_08_vj1k.mrp"
    pp = ScanLatticeMrp()
    pp.scan_report(mrp_file)
    pp.scan_clocks(mrp_file)
    print(pp.get_parse_line_clocks())
    print('----------------------')
    pp = ScanLatticeTime()
    pp.scan_srr(r'D:\Users\yzhao1\workspace\scan_report\bs\blowfish\_sc_synp\rev_1\sc_synp_blowfis.srr')
    print(pp.get_srr_time_data())
    pp.scan_mrp(mrp_file)
    print('-------------')
    pp.scan_par(r'\\d27817\test_dir\strdom_test_ecp3_ecp4u\zzz_ecp3_L25_job_dir_60standard\g64\_ecp3_synp\Target_Fmax_is_035MHz\5_1.par')
    print(pp.get_par_time_data())
    pp.get_total_time()
    pp.get_title()