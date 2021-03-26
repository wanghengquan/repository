import os
import re

from xOS import not_exists, wrap_copy_file, get_fname_ext
from xLog import print_error
from xReport import ScanBasic
import xConf

__author__ = 'syan'

def get_clocks_from_mrp_file(mrp_file):
    """ Support more line type.
    ....
    305.   Net aaa.clk200_c: 17504 loads, 17358 rising, 146 falling (Driver:
    306.   aaa/jua_clock_ctrl/dcm200/inst/PLLInst_0 )
    307.   Net aaa/jua_core/juana_mem_pool_ctrl/juana_ddr_ctrl/ddr_int_1/ddr_mem_8/ins
    308.   t/clk_op: 11 loads, 11 rising, 0 falling (Driver: aaa/jua_core/juana_mem_poo
    309.   l_ctrl/juana_ddr_ctrl/ddr_int_1/ddr_mem_8/inst/Inst1_PLL )
    ....

    """
    if not_exists(mrp_file, "Lattice Mrp file"):
        return
    p_clock_number = re.compile("Number\s+of\s+clocks:\s+(\d+)")
    p_clock = re.compile("\s+Net\s+([^:]+):")
    p_stop = re.compile("Number of Clock Enables")
    clock_number = 0
    clocks_lines = list()
    for line in open(mrp_file):
        line = line.rstrip()
        if not clock_number:
            mcn = p_clock_number.search(line)
            if mcn:
                clock_number = int(mcn.group(1))
            continue
        if p_stop.search(line):
            break
        clocks_lines.append(line)
    clocks_lines = "".join(clocks_lines)

    clocks = list()
    m_clock = p_clock.findall(clocks_lines)
    for item in m_clock:
        clocks.append(re.sub("\s+", "", item))

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


class ScanLatticeTwr:
    def __init__(self, pap):
        self.pap = pap  # Performance Achievement Percentage
        self.title = ["PAP", "PAPFactor", "targetFmax", "fmax", "clkName", "logic", "route", "level", "twrLabel"]
        self.create_patterns()
        self.all_raw_data = list()

    def create_patterns(self):
        self.p_fre_clk = re.compile('^Preference: FREQUENCY[^"]+"([^"]+)"')
        # Preference: FREQUENCY NET "ck19fb_out_o" 280.000000 MHz ;
        self.p_lrl = re.compile("""\s+\(
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
        self.raw_title = ["PAP", "targetFmax", "fmax", "PAPFactor", "clkName"]
        self.rpt_stop = re.compile("Overall Performance")

    def create_fmax_patterns(self):
        self.rpt_start = re.compile("^Report\s+Summary")
        # FREQUENCY NET "fir_clk_c" 300.000000    |             |             |
        # MHz ;                                   |  300.000 MHz|  443.656 MHz|   2
        self.rpt_pattern = re.compile('''FREQUENCY[^"]+
                                      "([^"]+)"              # Clock name
                                      [^;]+;
                                      \s+([\d\.]+)\s+MHz     # Constraint
                                      \s+([\d\.]+)\s+MHz     # Actual
                                      \s+\d+                 # Level
                                      ''', re.VERBOSE | re.I)
        self.raw_title = ["clkName", "targetFmax", "fmax"]
        self.rpt_stop = re.compile("^$")  # empty line

    def get_title(self):
        return self.title

    def get_all_data(self):
        #return self.all_raw_data
        all_data = list()
        for item in self.all_raw_data:
            t_data = [item.get(foo) for foo in self.title]
            all_data.append(t_data)
        return all_data

    def get_data(self):
        if self.pap:
            return self.get_pap_data()
        else:
            return self.get_fmax_data()

    def get_pap_data(self):
        """The minimize PAP clock data
        """
        return self._get_minimize("PAP")

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
        start, hotlines = 0, list()
        for line in open(rpt_file):
            if not start:
                if self.rpt_start.search(line):
                    start = 1
                continue
            line = line.strip()
            if self.rpt_stop.search(line):
                break
            line = re.sub("\s*\|", "", line)
            hotlines.append(line)
        hotlines = "".join(hotlines)

        self.raw_data  = self.rpt_pattern.findall(hotlines)
        if not self.raw_data:
            print_error("No frequency data found in %s" % rpt_file)
            return 1
            #
        self._get_all_raw_data(rpt_file)

    def _get_all_raw_data(self, rpt_file):
        self.all_raw_data = list()
        for item in self.raw_data:
            t_data = dict(zip(self.raw_title, item))
            t_data["twrLabel"] = get_fname_ext(rpt_file)[0]
            clk_name = t_data.get("clkName")
            if self.hot_clk:
                if clk_name != self.hot_clk:
                    continue
            lrl = self._get_lrl(t_data.get("clkName"))
            t_data.update(lrl)
            pap_number = t_data.get("PAP")
            if not pap_number:
                pap_number = "%s/%s" % (t_data.get("fmax"), t_data.get("targetFmax"))
                pap_number = eval(pap_number) * 100
                pap_number = "%.2f%%" % pap_number
                t_data["PAP"] = pap_number
                t_data["PAPFactor"] = "-"
            self.all_raw_data.append(t_data)

    def _get_lrl(self, clk_name):
        start = 0
        for line in open(self.rpt_file):
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
                return dict(zip(lrl_title, lrl_data))
        return dict()

    def _get_float(self, raw_str):
        raw_str = re.sub("\D+", "", raw_str)
        return float(raw_str)

    def _get_minimize(self, key):
        min_data = dict()
        for item in self.all_raw_data:
            new_value = item.get(key)
            old_value = min_data.get(key)
            if not old_value:
                min_data = item
            else:
                new_value = self._get_float(new_value)
                old_value = self._get_float(old_value)
                if old_value > new_value:
                    min_data = item
                    #return min_data
        return [min_data.get(item, "NA") for item in self.title]

class ScanLatticeMrp(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self)
        self.patterns = {
            "001 Version" : re.compile("^Mapper:.+version:\s+(.+)"),
            "002 Device" : [re.compile("^Target Device:\s+(\S+)"),
                            re.compile("^Target Performance:\s+(\S+)")],
            # Target Device:  LFEC6EFPBGA256
            # Target Performance:   5
            # Mapper:  ep5g00,  version:  Diamond Version 2.1.0.56
            # -----
            "003 Register" : re.compile("^Number of registers:\s+(\d+)"),
            "004 Slice" : re.compile("^Number of SLICEs:\s+(\d+)"),
            "005 LUT" : re.compile("^Total number of LUT4s:\s+(\d+)"),
            # Number of registers:    728
            # Number of SLICEs:           656 out of  3072 (21%)
            # Total number of LUT4s:     774
            # -----
            "006 IO" : re.compile("^Number of PIO sites used:\s+(\d+)"),
            "007 EBR" : re.compile("^Number of block RAMs:\s+(\d+)"),
            "008 DRAM" : re.compile("^Number of distributed RAM:\s+(\d+)"),
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

            "stop" : re.compile("^Page\s+8"),

            "100 MapCPUTime" : re.compile("^Total CPU Time:\s+(.+)"),
            "101 MapPeakMem" : re.compile("^Peak Memory Usage:\s+(\d+) MB")
            # Total CPU Time: 0 secs
            # Peak Memory Usage: 51 MB
        }
        self.reset()

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
        self.reset()

def get_flow_conf(a_file):
    a_dict = xConf.get_conf_options(a_file)
    flow = a_dict.get("flow")
    '''run_scuba = 1
run_synthesis = 1
synthesis = synpwrap
; synthesis = lse


run_translate = 1
run_map = 1
run_map_trce = 1

run_par = 1
run_trce = 1

run_bitgen = 1

    '''
    t = dict()
    for key, value in flow.items():
        if value == "1":
            value = True
        elif value == "0":
            value = False
        t[key] = value
    return t



if __name__ == "__main__":
    mrp_file = r"D:\shawn\new_run\vinci\ecp3\ecp3_synp_vinci.mrp"

    pp = ScanLatticeMrp()
    pp.scan_report(mrp_file)
    print pp.get_title()
    print pp.get_data()

