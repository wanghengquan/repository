import os
import re
from xTools import not_exists, append_file
from xReport import ScanBasic

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

def get_a_clocks(fit_rpt):
    p_total_clock = re.compile(':\s+Found\s+(\d+)\s+clock', re.I)
    # Info (332111): Found 12 clocks
    p_clock = re.compile('Info\s+\S+\s+[\d\.]+\s+(\S+)$')
    # Info (332111):   10.000 pll2|U1|altpll_component|auto_generated|pll1|clk[2]
    start = 0
    clocks_a = list()
    total_number = -1
    for line in open(fit_rpt):
        if not start:
            m = p_total_clock.search(line)
            if m:
                start = 1
                total_number = int(m.group(1))
            continue
        line = line.strip()
        m_clock = p_clock.search(line)
        if m_clock:
            clocks_a.append(m_clock.group(1))
            if len(clocks_a) == total_number: break
        else:
            start += 1
        if start == 8:
            break
    if len(clocks_a) != total_number:
        print("Error. Not found all clocks in %s" % fit_rpt)
    return clocks_a

def get_b_clocks(fit_rpt, p_start, clk_list):
    start = 0
    clocks_b = list()
    p_skip = re.compile('^\+-+\+-+')
    # ; Name
    # ; Location           ; Fan-Out ; Usage                                               ; Global
    # ; Global Resource Used ; Global Line Name ; Enable Signal Source Name ;

    # ; CLKDLL_pll1:pll1|pll_cy4_U1:U1|altpll:altpll_component|pll_cy4_altpll:auto_generated|wire_pll1_clk[1]
    # ; PLL_2              ; 22      ; Clock                                               ; yes
    # ; Global Clock         ; GCLK8            ; --                        ;
    usage_idx = 0
    for line in open(fit_rpt):
        line = line.strip()
        if not start:
            if p_start.search(line):
                start = 1
            continue
        if not line: break
        if p_skip.search(line): continue

        line = re.split("\s*;\s*", line)
        if line[1] == 'Name':
            usage_idx = line.index('Usage')
            continue
        if usage_idx:
            usage_str = line[usage_idx]
            usage_str = re.split("\s*,\s*", usage_str.lower())
            for item in clk_list:
                if item in usage_str:
                    clocks_b.append(line[1])
    return clocks_b

def get_clocks_from_fit_rpt(fit_rpt):
    if not_exists(fit_rpt, "fit rpt file"):
        return
    clocks_a = get_a_clocks(fit_rpt)
    cs_p, cs_clk_list = re.compile("^; Control Signals\s+;$"), ["clock", "latch enable", "global clock"]
    clocks_b_cs = get_b_clocks(fit_rpt, cs_p, cs_clk_list)
    clocks = list()
    for foo in (clocks_a, clocks_b_cs):
        for bar in foo:
            if bar not in clocks:
                clocks.append(bar)
    return clocks


def update_sdc_file(sdc_file, clocks, tf):
    sdc_lines = ["derive_pll_clocks -use_tan_name",
                 'derive_clocks -period "%.3f MHz"' % tf, ""]
    in_ns = 1.0/tf * 1000
    in_ns = '"%.3f ns"' % in_ns
    for clk in clocks:
        sdc_lines.append("create_clock -period %s \\" % in_ns)
        sdc_lines.append("             -name {%s} {%s}" % (clk, clk))
        sdc_lines.append("")
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
            "004 LUT" : re.compile("^;\s+Total combinational functions\s+;\s+(\S+)"),
            "004 Register" : re.compile("^;\s+Total registers\s+;\s+(\S+)"),
            "005 IO" : re.compile("^;\s+Total pins\s+;\s+(\S+)"),
            "006 Memory" : re.compile("^;\s+Total memory bits\s+;\s+(\S+)"),
            "007 DSP" : [re.compile("^;\s+Embedded Multiplier 9-bit elements\s+;\s+(\S+)"),
                         re.compile("^;\s+DSP block 18-bit elements\s+;\s+(\S+)")],
            "008 PLL" : re.compile("^;\s+Total PLLs\s+;\s+(\S+)"),
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

            "009 LAB" : re.compile("^; Total LABs:  partially or completely used\s+;\s+(\S+)"),
            "010 M9K" : re.compile("^; M9Ks\s+;\s+(\S+)"),
            # ; Total LABs:  partially or completely used   ; 1,118 / 1,395 ( 80 % )     ;
            # ; M9Ks                                        ; 44 / 66 ( 67 % )           ;
            "stop" : re.compile("^;\s+Input Pins"),

            "101 FitPeakMem" : re.compile("^Info: Peak virtual memory:\s+(\S+)"),
            "102 FitCPUTime" : re.compile("^Info: Total CPU time[^:]+:\s+(\S+)")
            # Info: Peak virtual memory: 408 megabytes
            # Info: Total CPU time (on all processors): 00:00:10
        }
        self.reset()

class ScanAlteraFmax:
    def __init__(self):
        self.title = ["targetFmax", "fmax", "clkName"]
        self.data = ["NA"] * len(self.title)

        self.p_tf = re.compile('^derive_clocks -period "([\d\.]+)\s+MHz"')
        self.p_fmax_start = re.compile("^;\s+Fmax\s+;")
        self.p_fmax = re.compile("""^;\s+([\d\.]+)\s+MHz\s+
                                     ;\s+[\d\.]+\s+MHz\s+
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

        target_fmax = self.get_target_fmax(sdc_file)
        fmax, clk_name = self.get_fmax(rpt_file)
        self.data = [target_fmax, "%.2f" % fmax, clk_name]

    def get_target_fmax(self, sdc_file):
        if not_exists(sdc_file):
            return "NoTargetFmax"
        for line in open(sdc_file):
            line = line.strip()
            m_tf = self.p_tf.search(line)
            if m_tf:
                return m_tf.group(1)
        return "NoTargetFmax"

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


if __name__ == "__main__":
    pp = get_clocks_from_fit_rpt(r"cyclone4_synp_12.fit.rpt")
    print len(pp), pp



