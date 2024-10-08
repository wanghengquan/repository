import os
import re
import sys
import shlex
import glob
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

__author__ = 'syan'

p_clock = re.compile("^Timing constraint: Default period analysis for net", re.I)
# Timing constraint: Default period analysis for net
# "syncro_i/clk155mhzgen/CKOUT_i_m2"
# Timing constraint: Default period analysis for net "rstatus_ck_left_i_0_cb"
def get_clocks_from_map_twr(map_twr):
    if not_exists(map_twr, "_map.twr file"):
        return
    clocks = set()
    my_line = ""
    for line in open(map_twr):
        line = line.strip()
        if p_clock.search(line):
            my_line = line
        if my_line:
            if not line:
                # can get clock name
                my_line = shlex.split(my_line)
                clocks.add(my_line[-1])
                my_line = ""
            else:
                line = " " + line
                my_line += line
    clock_list = list(clocks)
    clock_list.sort(key=str.lower)
    return clock_list

def update_ucf_file(ucf_file, clocks, tf):
    ucf_lines = ["# clocks number: %s" % len(clocks)]
    mhz_str = "%.2f MHz HIGH 50%%;" % tf
    for i, clk in enumerate(clocks):
        ucf_lines.append('NET "%s" TNM_NET = %s;' % (clk, clk))
        new_spec = re.sub("\W", "_", clk)
        ucf_lines.append('TIMESPEC TS_%s = PERIOD "%s" %s' % (new_spec, clk, mhz_str))
        if not( (i+1)%5 ):
            ucf_lines.append("")
    append_file(ucf_file, ucf_lines, append=False)

class ScanXilinxTwr:
    def __init__(self):
        self.title = ["targetFmax", "fmax", "clkName", "logic", "route", "level"]
        self.create_patterns()
        self.all_raw_data = list()

    def get_title(self):
        return self.title

    def create_patterns(self):
        self.p_clock_start = re.compile("^Timing constraint: Default period analysis for net", re.I)
        self.p_clock = re.compile("^Source Clock:\s+(\S+)")
        self.p_min_period = re.compile("^Minimum period is\s+([\d\.]+)ns")
        # (20.7% logic, 79.3% route)
        self.p_logic_route = re.compile("""\(
                                (?P<logic>[\d\.]+%)\s+logic,\s+
                                (?P<route>[\d\.]+%)\s+route
                                \)
                                """, re.VERBOSE)
        self.p_level = re.compile("\(Levels of Logic =\s+(\d+)\)", re.I)
        self.p_tf = re.compile("\s+([\d\.]+)\s+MHz")

    def scan_report(self, rpt_file, hot_clk=""):
        self.all_raw_data = list()
        if not_exists(rpt_file, "report file"):
            return 1
        self.rpt_file = rpt_file
        self.get_target_fmax()
        self.all_raw_data = list()

        start = 0
        t_dict = dict()
        for line in open(rpt_file):
            line = line.strip()
            if not start:
                if self.p_clock_start.search(line):
                    start = 1
                continue

            m_clock = self.p_clock.search(line)
            m_min_period = self.p_min_period.search(line)
            m_logic_route = self.p_logic_route.search(line)
            m_level = self.p_level.search(line)
            if m_clock:
                _clk_name = m_clock.group(1)
                if hot_clk:
                    if _clk_name != hot_clk:
                        t_dict = dict()
                        start = 0
                        continue
                t_dict["clkName"] = m_clock.group(1)
            elif m_min_period:
                _ns = m_min_period.group(1)
                _mhz = eval("1000.0/%s" % _ns)
                t_dict["fmax"] = "%.3f" % _mhz
                t_dict["targetFmax"] = self.target_fmax
            elif m_level:
                t_dict["level"] = m_level.group(1)
            elif m_logic_route:
                t_dict["logic"] = m_logic_route.group("logic")
                t_dict["route"] = m_logic_route.group("route")
                start = 0
                self.all_raw_data.append(t_dict)
                t_dict = dict()

    def get_target_fmax(self):
        ucf_file = get_fname_ext(self.rpt_file)[0] + ".ucf"
        if not_exists(ucf_file, "UCF file"):
            self.target_fmax = "-"
        else:
            for line in open(ucf_file):
                m_tf = self.p_tf.search(line)
                if m_tf:
                    self.target_fmax = m_tf.group(1)
                    break
            else:
                self.target_fmax = "NA"

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

    def get_data(self):
        return self._get_minimize("fmax")

    def get_central_fmax(self):
        fmax_minimize = self._get_minimize("fmax")
        fmax_idx = self.title.index("fmax")
        return fmax_minimize[fmax_idx]

    def get_all_data(self):
        all_data = list()
        for item in self.all_raw_data:
            t_data = [item.get(foo) for foo in self.title]
            all_data.append(t_data)
        return all_data
    def reset(self):
        self.all_raw_data = list()


class ScanXilinxMrp(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self)
        self.patterns = {
            "001 Device" : [re.compile("^Target Device\s+:\s+(\S+)"),
                            re.compile("^Target Package\s+:\s+(\S+)"),
                            re.compile("^Target Speed\s+:\s+-(\S+)")],
            # Target Device  : xc6slx25t
            # Target Package : csg324
            # Target Speed   : -4
            # -----
            "002 Register" : re.compile("^Number of Slice Registers:\s+(\S+)"),
            "003 LUT" : re.compile("^Number of Slice LUTs:\s+(\S+)"),
            # Number of Slice Registers:  1,097 out of  30,064    3%
            # Number of Slice LUTs:       967 out of  15,032    6%
            #Number of bonded IOBs:                       126 out of     170   74%
            "004 IO": re.compile("Number of bonded IOBs:\s+(\S+)"),
            # Number of occupied Slices:                   508 out of   3,758   13%
            "005 Slice":re.compile("Number of occupied Slices:\s+(\S+)"),
            #Number used as Memory:                      27 out of   3,664    1%
            "006 Dist_RAMs":re.compile("Number used as Memory:\s+(\S+)"),
            #  Number of RAMB16BWERs:                         0 out of      52    0%
            #Number of RAMB8BWERs:                          1 out of     104    1%
            #Number of RAMB36E1/FIFO36E1s:                  0 out of     135    0%
            #Number of RAMB18E1/FIFO18E1s:                  0 out of     270    0%
            "007 Block_RAM":[re.compile("Number of RAMB16BWERs:\s+(\S+)"),
                             re.compile("Number of RAMB8BWERs:\s+(\S+)"),
                             re.compile("Number of RAMB36E1/FIFO36E1s:\s+(\S+)"),
                             re.compile("Number of RAMB18E1/FIFO18E1s:\s+(\S+)"),],
              #Number of DSP48A1s:                            0 out of      38    0%
              #Number of   DSP48E1s:                            0 out of     240    0%
            "008 Dsp":[re.compile("Number\s+of\s+DSP48A1s:\s+(\S+)"),
                       re.compile("Number\s+of\s+DSP48E1s:\s+(\S+)")],
            #Number of MMCME2_ADVs:                         1 out of      10   10%
            #Number of PLLE2_ADVs:                          0 out of       6    0%
            #Number of DCM/DCM_CLKGENs:                     0 out of       4    0%
            #Number of MMCM_ADVs:                           0 out of       6    0%
            "009 PLL":[re.compile("Number of MMCME2_ADVs:\s+(\S+)"),
                       re.compile("Number of PLLE2_ADVs:\s+(\S+)"),
                       re.compile("Number of DCM/DCM_CLKGENs:\s+(\S+)"),
                       re.compile("Number of MMCM_ADVs:\s+(\S+)")],

        }
        self.reset()
    def _parse_line(self, key, line):
        pattern = self.patterns.get(key)
        pattern_type = type(pattern)
        if pattern_type is list:
            for p in pattern:
                m = p.findall(line)
                if not m:
                    continue

                got_string = self._get_string(m[0])
                try:
                    got_string = int(got_string)
                except ValueError:
                    pass
                key_content = self.data.get(key)
                if key_content == "NA":
                    if line.find('RAMB16BWERs')!= -1:
                        self.data[key] = got_string * 16
                    elif line.find('RAMB8BWERs')!= -1:
                        self.data[key] = got_string * 8
                    elif line.find('RAMB36E1')!= -1:
                        self.data[key] = got_string * 36
                    elif line.find('RAMB18E1')!= -1:
                        self.data[key] = got_string * 18
                    else:
                        self.data[key] = got_string
                else:
                    try:
                        if line.find('RAMB16BWERs')!= -1:
                            self.data[key] += got_string * 16
                        elif line.find('RAMB8BWERs')!= -1:
                            self.data[key] += got_string * 8
                        elif line.find('RAMB36E1')!= -1:
                            self.data[key] += got_string * 36
                        elif line.find('RAMB18E1')!= -1:
                            self.data[key] += got_string * 8
                        else:
                            self.data[key] += got_string
                        #self.data[key] += (0+got_string)
                    except TypeError:
                        self.data[key] = str(key_content) + "-" + str(got_string)
        else:  # single pattern
            m = pattern.findall(line)
            if m:
                got_string = self._get_string(m[0])
                self.data[key] = re.sub(",", "", got_string)

class ScanXilinxTime(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self)
        self.patterns = {
            "002 ngdbuild" : re.compile("^([\.\d]+)\s+,\s+\S+ngdbuild\s+"),
            "003 map" : re.compile("^([\.\d]+)\s+,\s+\S+map\s+"),
            "004 par" : re.compile("^([\.\d]+)\s+,\s+\S+par\s+"),
            "005 trce" : re.compile("^([\.\d]+)\s+,\s+\S+trce\s+")
        }
        self.reset()
class ScanXilinxTimeMem:
    def __init__(self):
        self.patterns_srr = {
                             #Real Time elapsed 0h:00m:05s; CPU Time elapsed 0h:00m:05s; Memory used current: 40MB peak: 141MB
                             "001 srr_time" : re.compile("Real Time elapsed\s+(.+);\s+CPU Time elapsed\s+(.+);.*?peak:\s+(\d+)MB"),
                             }
        self.srr_data     = {
                            'srr_real_time':'NA',
                            'srr_cpu_time' : 'NA',
                            'SynPeakMem'   : 'NA'
                            }
        self.patterns_map = {
                             #   Total CPU time to MAP completion:   18 secs
                             "001 map_cpu_time": re.compile("Total CPU time to MAP completion:\s+(.+)"),

                             # Total REAL time to MAP completion:  21 secs
                             "002 map_real_time": re.compile("Total REAL time to MAP completion:\s+(.+)"),
                             #Peak Memory Usage:  393 MB
                             "003 MapPeakMem"   : re.compile("Peak Memory Usage:\s+([\d ,]+)MB")

                             }

        self.map_data = {}
        for key in list(self.patterns_map.keys()):
            key = key.split()[1]
            self.map_data[key] = 'NA'
        self.patterns_par = {
                             #Total CPU time to PAR completion: 17 secs
                             "001 par_cpu_time" : re.compile("Total CPU time to PAR completion:\s+(.+)$"),
                             #Total REAL time to PAR completion: 21 secs
                             "002 par_real_time": re.compile("Total REAL time to PAR completion:\s+(.+)$"),
                             #Peak Memory Usage:  668 MB
                             "003 ParPeakMem" : re.compile("Peak Memory Usage:\s+(\d+)\s+MB"),
                             "004 Par_Done":re.compile('PAR done!'),
                             "005 Complete":re.compile('All signals are completely routed')
                             }
        self.par_data = {}
        for key in list(self.patterns_par.keys()):
            key = key.split()[1]
            self.par_data[key] = 'NA'
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
            for key in list(self.patterns_map.keys()):
                value = self.patterns_map[key]
                match = value.search(line)
                if match:
                    match_data = match.group(1)
                    if key !='MapPeakMem':
                        match_data = time2secs(match_data.strip())
                    self.map_data[key.split()[1]] = match_data

    def scan_par(self,par_file):
        if not os.path.isfile(par_file):
            return
        file_hand = file(par_file,'r')
        lines = file_hand.readlines()
        file_hand.close()
        for line in lines:
            line  = line.strip()
            for key in list(self.patterns_par.keys()):
                value = self.patterns_par[key]
                match = value.search(line)
                p_key = key.split()[1]
                if match:
                    if p_key == 'Complete' or p_key == 'Par_Done':
                       self.par_data[p_key] = 'YES'
                    else:
                        self.par_data[p_key] = time2secs( (match.group(1)).strip() )
    def get_srr_data(self):
        return self.srr_data
    def get_map_data(self):
        return self.map_data
    def get_par_data(self):
        return self.par_data
    def set_srr_data(self):
         for key in list(self.srr_data.keys()):
             self.srr_data[key] = 'NA'
    def set_map_data(self):
        for key in list(self.map_data.keys()):
            self.map_data[key]  = 'NA'
    def set_par_data(self):
        for key in list(self.par_data.keys()):
            self.par_data[key] = 'NA'
    def reset(self):
        self.set_srr_data()
        self.set_par_data()
        self.set_map_data()
        self.total_time = {'Total_cpu_time' :'NA',
                           'Total_real_time': 'NA'
                           }

    def get_total_time(self):
        srr_time = self.get_srr_data()
        mrp_time = self.get_map_data()
        par_time = self.get_par_data()
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
                    self.cpu_time = self.cpu_time + int(srr_time[key])
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
        srr_time = self.get_srr_data()
        mrp_time = self.get_map_data()
        par_time = self.get_par_data()
        srr_title =  list(srr_time.keys())
        srr_title.sort()
        mrp_title =  list(mrp_time.keys())
        mrp_title.sort()
        par_title =  list(par_time.keys())
        par_title.sort()
        title = srr_title+mrp_title+par_title+['Total_cpu_time','Total_real_time']
        return title
    def get_data(self):
        title = self.get_title()
        dic = {}
        data  = []
        dic.update(self.get_srr_data())
        dic.update(self.get_map_data())
        dic.update(self.get_par_data())
        dic.update(self.get_total_time())
        for t in title:
            data.append(dic[t])
        return data

########### The follow support for vivado ##################
class ScanXilinxTimingRpt(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self)

        self.reset()
        self.title = ["IO", "fmax", "clkName","targetFmax"]
        self.data = ['NA']*len(self.title)
    def get_title(self):
        return self.title
    def get_data(self):
        return self.data
    def scan_report(self, rpt_file):
        IoRpt = glob.glob(os.path.join(os.path.dirname(rpt_file),'*io_placed.rpt'))
        if IoRpt:
            IoRpt = IoRpt[0]
            target_fmax_dir = os.path.basename(os.path.dirname(IoRpt))
            #Target_Fmax_is_060.00MHz
            target_pattern = re.compile('Target_Fmax_is_(\d+)')
            if target_pattern.search(target_fmax_dir):
                self.data[3] = str( int( (target_pattern.search(target_fmax_dir)).group(1) ) )
            file_hand = file(IoRpt)
            line = file_hand.readline()
            begin_flag = 0
            patten = re.compile('\|\s+(\d+)')
            while line:
                '''
                +---------------+
                | Total User IO |
                +---------------+
                |           163 |
                +---------------+
                '''
                if line.find('Total User IO')!= -1:
                    begin_flag = 1
                    line = file_hand.readline()
                elif begin_flag != 0:
                    begin_flag += 1
                    if begin_flag == 3:
                        patten_search = patten.search(line)
                        if patten_search:
                            self.data[0] = patten_search.group(1)
                        break
                    else:
                        line = file_hand.readline()
                else:
                    line = file_hand.readline()

        '''
            Begin to get the fmax
        '''
        if not_exists(rpt_file, "report file"):
            return 1
        file_hand = file(rpt_file)
        line = file_hand.readline()
        begin_flag = 0
        search_character = re.compile('[a-z,A-Z]')
        temp_fmax = 10000
        temp_clock = ''
        temp_period = ''
        period_flag = 0
        index = 1
        while line:
            line = line.strip()
            ############################ At here, we need to find the period ##################
            #Clock     Waveform(ns)         Period(ns)      Frequency(MHz)
            #-----     ------------         ----------      --------------
            #mclkin_c  {0.000 1.724}        3.448           290.023
            #print line
            line_temp = re.sub("\s","",line.strip())
            if line_temp == "ClockWaveform(ns)Period(ns)Frequency(MHz)" :
                period_flag = 1
                line = file_hand.readline()
                continue
            elif period_flag == 1:
                period_flag += 1
                line = file_hand.readline()
                continue
            elif period_flag == 2:
                try:
                    line_use = line.split("}")[1]
                    line_use = line_use.strip()
                    temp_period = float(line_use.split()[0])
                except:
                    pass
                period_flag += 1
                line = file_hand.readline()
                continue
            else:
                pass
            #print period_flag
            #raw_input()




            if line.find('| Intra Clock Table') != -1:
                begin_flag = 1
            elif line.startswith('Clock '):
                begin_flag += 1
                index = line.index("WNS(ns)")+7
            elif begin_flag >= 1:
                begin_flag += 1
                if begin_flag >5 and line:
                    if search_character.search(line):
                        line_list = (line[0:index]).strip().split()
                        if len(line_list)>=2:
                            temp = line_list[1]
                            try:
                                temp = float(temp)
                                temp = temp_period - temp
                                temp = 1000/temp
                                temp = "%.3f"%temp
                                temp = float(temp)
                                if temp < temp_fmax:
                                    temp_fmax = temp
                                    temp_clock = line_list[0]
                            except:
                                pass
                if begin_flag >5 and (not line):
                    break
            elif begin_flag and not line:
                break
            line = file_hand.readline()
        if temp_fmax:
            self.data[1] = str(temp_fmax)
            self.data[2] = temp_clock


class ScanXilinxPlacedRpt(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self)
        self.patterns = {
            #| Tool Version : Vivado v.2014.4 (win64) Build
            "001 Version" : re.compile("^\| Tool Version :\s+(.*?)\s+Build"),
            "002 Device" : [re.compile("^\| Device\s+:\s+(\S+)"),
                           ],
            #| Device       : xc7a100t
            # -----
            "003 Register" : re.compile("Slice Registers\s+\|\s+(\S+)"),
            #| Slice Registers         |  832 |     0 |    126800 |  0.65 |
            "004 LUT" : re.compile("\| Slice LUTs\s+\|\s+(\S+)"),
            #| Slice LUTs              |  810 |     0 |     63400 |  1.27 |
            #| Bonded IOB                  |  135 |     0 |       170 | 79.41 |
            "005 IO": re.compile("^\| Bonded IOB\s+\|\s+(\S+)"),
            #| Slice                                                       |       314 |     0 |     15850 |  1.98 |
            "006 Slice":re.compile("^\| Slice\s+\|\s+(\S+)"),
            #| Block RAM Tile |    0 |     0 |       135 |  0.00 |
            #|   RAMB36/FIFO* |    0 |     0 |       135 |  0.00 |
            #|   RAMB18       |    0 |     0 |       270 |  0.00 |
            "007 Block_RAM":[re.compile("\| Block RAM Tile \|\s+(\S+)"),
                             re.compile("\|   RAMB36/FIFO\* \|\s+(\S+)"),
                             re.compile("\|   RAMB18       \|\s+(\S+)"),
                            ],
            #| DSPs      |    0 |     0 |       240 |  0.00 |
            "008 Dsp":[re.compile("\| DSPs\s+\|\s+(\S+)"),
                      ],


        }
        self.reset()

    def _parse_line(self,key,line):
        pattern = self.patterns.get(key)
        pattern_type = type(pattern)
        if pattern_type is list:
            for p in pattern:
                m = p.findall(line)
                if not m:
                    continue
                got_string = self._get_string(m[0])
                try:
                    if got_string.find(',')!= -1:
                        got_string = got_string.replace(',', '')
                    got_string = int(got_string)
                except ValueError:
                    pass
                key_content = self.data.get(key)
                if key_content == "NA":
                    self.data[key] = got_string
                    self.patterns_data[key] = [got_string]
                    self.patterns_used[key] = [p]
                else:
                    try:
                        if len(self.patterns_data[key]) == len(pattern)  \
                           or p in self.patterns_used[key]:
                            return
                        else:
                            self.patterns_data[key].append(got_string)
                            self.patterns_used[key].append(p)

                        self.data[key] += (0+got_string)
                    except TypeError:
                        if len(self.patterns_data[key]) == len(pattern):
                            return
                        self.data[key] = str(key_content) + "-" + str(got_string)

        else:  # single pattern
            m = pattern.findall(line)
            if m:
                got_string = self._get_string(m[0])
                self.data[key] = re.sub(",", "", got_string)

                '''if key in self.patterns_data.keys():
                    print self.patterns_data
                    pass
                else:
                    self.patterns_data[key] = got_string'''






if __name__ == "__main__":
    twr_file = r"D:\Users\yzhao1\workspace\scan_report\at7\08_vj1kfpga\_artix7_synp\Target_fmax_is_050.000MHz\artix7_synp_08_vj1k.twr"
    pp = ScanXilinxTwr()
    pp.scan_report(twr_file)
    print(pp.get_data())
    print(pp.get_central_fmax())
    print(pp.get_all_data())

    print('-' * 100)

    pp.scan_report(twr_file, "dram_clk")
    print(pp.get_data())
    print(pp.get_central_fmax())
    print(pp.get_all_data())
