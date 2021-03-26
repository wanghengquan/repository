__author__ = 'yzhao1'
#===================================================
# Description: This is the scan the ICEcube QoR test flow
# Owner      : SWQA Auto Yzhao1
# Version    : 1.0
# Update     : None
#===================================================
import optparse
import os
import sys
import re
import optparse
import  time
class scan_log():
    def __init__(self):
        '''
        scan srr file
        :return:
        '''
        self.patterns = {
            "001 Version" : re.compile("^Mapper:.+version:\s+(.+)"),
            }
        self.srr_file = 'NA'
        self.placer_file = 'NA'
        self.packer_file = 'NA'
        self.router_file = 'NA'
        self.run_log_file = 'NA'
        self.data = {}
        self.titles = [ 'design','netlister_runtime','ppfmax', 'lut','carry','ram','rom', 'fmaxtarget',
                        'iocell', 'fmax', 'fmaxclock', 'timer_runtime', 'bitmap_runtime',
                        'logictile', 'logiccell', 'router_runtime', 'placer_runtime', 'synfmax',
                        'totallut','Post_Placer_Carrys','bramcell', 'ff', 'parser_runtime', 'packer_runtime','peak_mem']
        self.output_file = 'result_'+str(time.time())+".csv"

    def reset(self):
        for title in self.titles:
            self.data[title] = 'NA'
        self.data['design'] = os.path.basename(self.design)
    def parse_option(self):
        self.parser = optparse.OptionParser()
        # public options for the case
        pub_group = optparse.OptionGroup(self.parser, "Public Options")
        pub_group.add_option("--job-dir", help="specify the top source path name")
        pub_group.add_option("--design", help="specify the design name")
        pub_group.add_option("--report", help="specify the report name")
        self.parser.add_option_group(pub_group)

    def get_scan_file(self):
        '''
        This function used to get the need file for scan
        :return:
        '''

        if os.path.isdir(self.design):
            self.reset()
        else:
            print 'Error, can not get design path at ',self.design
        find_scratch=0
        for root,dirs,fs in os.walk(self.design):
            if '_scratch' in dirs:
                find_scratch = 1
            for single_file in fs:
                if single_file == 'run_log':
                    self.run_log_file = os.path.join(root,single_file)
                if single_file == 'run.log' and find_scratch:
                    self.run_log_file = os.path.join(root,single_file)
                elif single_file.endswith('.srr') and (not root.endswith('synlog')):
                    self.srr_file = os.path.join(root,single_file)
                elif single_file == 'placer.log':
                    self.placer_file = os.path.join(root,single_file)
                elif single_file.endswith('_info.log'):
                    self.packer_file = os.path.join(root,single_file)
                elif single_file.endswith('_timing.rpt'):
                    self.router_file = os.path.join(root,single_file)
                else:
                    pass
    def scan_srr(self):
        #n_par_alu_io_v0|clk     100.0 MHz     35.0 MHz      10.000        28.551        -18.551     inferred     Inferred_clkgroup_0
        srr_pattern = re.compile('(\S+)\s+([\d.]+)\s+MHz\s+([\d.]+)\s+MHz')
        if os.path.isfile(self.srr_file):
            pass
        else:
            print "Error: at scan_srr, can not get file:%s"%self.srr_file
            return
        all_lines = file(self.srr_file).readlines()
        begin_line = 0
        min_fmax = 1000
        for line in all_lines:
            if line.find('Performance Summary')!= -1:
                begin_line = 1
                continue
            elif line.find('Clock Relationships') != -1:
                break
            else:
                if begin_line:
                    line_search = srr_pattern.search(line)
                    if line_search:
                        if float(line_search.group(3)) < min_fmax:
                            self.data['synfmax'] = line_search.group(3)
                            min_fmax = line_search.group(3)

    def scan_placer(self):
        '''
        Scan placer.log
        :return:
        '''
        placer_pattern = re.compile('Frequency:\s+([\d\.]+)\s+MHz')
        if not os.path.isfile(self.placer_file):
            print 'Error: at san_placer can not get file:%s'%self.placer_file
            return
        all_lines = file(self.placer_file).readlines()
        min_fmax = 10000
        for line in all_lines:
            placer_search = placer_pattern.search(line)
            if placer_search:
                temp_fmax = placer_search.group(1)
                if (float(temp_fmax) < min_fmax):
                    self.data['ppfmax'] = temp_fmax
        #print self.data

    def scan_packer(self):
        '''
        scan _info.log under sbt/outputs/packer/*_info.log
        :return:
        Used Logic Cell: 3644/7680
        Used Logic Tile: 726/960
        Used IO Cell:    159/256
        Used Bram Cell For iCE40: 0/32
        '''
        pattern_list = [
            ('logiccell',re.compile('Used Logic Cell:\s+(\d+)')),
            ('logictile',re.compile('Used Logic Tile:\s+(\d+)')),
            ('iocell',re.compile('Used IO Cell:\s+(\d+)')),
            ('bramcell',re.compile('Used Bram Cell.*?:\s+(\d+)'))
        ]
        if not os.path.isfile(self.packer_file):
            print "Error: at scan_packer can not find file:%s"%self.packer_file
            return
        all_lines = file(self.packer_file).readlines()
        for line in all_lines:
            for pattern in pattern_list:
                pattern_search = pattern[1].search(line)
                if pattern_search:
                    self.data[pattern[0]] = pattern_search.group(1)
            if line.find('***** Placement Info *****')!= -1:
                break
        #print self.data

    def scan_router(self):
        if not os.path.isfile(self.router_file):
            print 'Error, at scan_router can not get file%s'%self.router_file
            return
        #Clock: n_par_alu_io_v0|clk  | Frequency: 22.24 MHz  | Target: 100.00 MHz  |
        pattern = re.compile('Clock:\s+(\S+)\s+\|\s+Frequency:\s+([\d\.]+)\s+MHz\s+\|\s+Target:\s+([\d\.]+)\s+MHz')
        all_lines = file(self.router_file).readlines()
        min_fmax = ''
        min_clock = ''
        min_target = ''
        for line in all_lines:
            if line.find('virtual_clock')!= -1:
                continue
            if line.find('End of Clock Frequency Summary')!= -1:
                break
            pattern_search = pattern.search(line)
            if pattern_search:
                temp_clk = pattern_search.group(1)
                temp_fmax = pattern_search.group(2)
                temp_target = pattern_search.group(3)
                if(min_fmax == '' or float(temp_fmax) < min_fmax):
                    min_fmax = temp_fmax
                    min_clock = temp_clk
                    min_target = temp_target
        self.data['fmax'] = min_fmax
        self.data['fmaxclock'] = min_clock
        self.data['fmaxtarget'] = min_target
        #print self.data

    def scan_run_log(self):
        '''
        Scan run_log, get the lut and etc. resources
        :return:
        '''
        if not os.path.isfile(self.run_log_file):
            print 'Error: at scan_run_log can not get file %s'%self.run_log_file
            return
        synth_flag = 0
        pack_flag = 0
        synth_pattern_list = [
            ('lut',re.compile('Number of LUTs\s+:\s+(\d+)')),  #Number of LUTs      	:	2857
            ('ff',re.compile('Number of DFFs\s+:\s+(\d+)')),   #Number of DFFs      	:	1550
            ('carry',re.compile('Number of Carrys\s+:\s+(\d+)')),   #Number of Carrys    	:	57
            ('ram',re.compile('Number of BRAMs\s+:\s+(\d+)')),    #Number of BRAMs\s*:\s*(\d+)
            ('ram',re.compile('Number of RAMs\s+:\s+(\d+)')),    #Number of RAMs      	:	0
            ('rom',re.compile('Number of ROMs\s+:\s+(\d+)')),  #Number of ROMs      	:	0

        ]
        total_lut_pattern = re.compile('Number of LUTs\s+:\s+(\d+)')         # Number of LUTs      	:	3197
        Post_Placer_Carrys_pattern = re.compile('Number of Carrys\s+:\s+(\d+)')         # Number of Carrys      	:	3197
        #Post-Placer Carrys
        time_pattern_list = [
            ('parser_runtime',re.compile('EDF Parser run-time:\s+([\d\.]+)')), #EDF Parser run-time: 2 (sec)
            ('placer_runtime',re.compile('Placer run-time:\s+([\d\.]+)')),    #Placer run-time: 107.9 sec.
            ('packer_runtime',re.compile('Packer run-time:\s+([\d\.]+)')),    #Packer run-time: 3 (sec)
            ('router_runtime',re.compile('Router run-time\s*:\s+([\d\.]+)')), #Router run-time : 43 seconds

            ('bitmap_runtime',re.compile('Bitmap run-time:\s+([\d\.]+)')),    #Bitmap run-time: 5 (sec)
            ('netlister_runtime',re.compile('Netlister run-time:\s+([\d\.]+)')), #Netlister run-time: 22 (sec)
            ('timer_runtime',re.compile('Timer run-time\s*:\s+([\d\.]+)')),    #Timer run-time: 10 seconds
            ('peak_mem',re.compile('PEAK\s*MEMORY\s*:\s+([\d\.]+)')),           #PEAK\s*MEMORY\s*:\s*(\d+),  this is useless
        ]
        all_lines = file(self.run_log_file).readlines()
        for line in all_lines:
            if line.find('Input Design Statistics')!= -1:
                synth_flag = 1
                continue
            if synth_flag:
                for synth_pattern in synth_pattern_list:
                    title = synth_pattern[0]
                    pattern = synth_pattern[1]
                    pattern_search = pattern.search(line)
                    if pattern_search:
                        self.data[title] = pattern_search.group(1)
                        if title == "rom":
                            synth_flag = 0

            if line.find('Design Statistics after Packing')!= -1:
                pack_flag = 1
                continue
            if pack_flag:
                # Number of LUTs      	:	3197
                # Number of Carrys    	:	57
                total_lut_search = total_lut_pattern.search(line)
                if total_lut_search:
                    self.data['totallut'] = total_lut_search.group(1)
                    continue
                Post_Placer_Carrys_search = Post_Placer_Carrys_pattern.search(line)
                if Post_Placer_Carrys_search:
                    self.data['Post_Placer_Carrys'] = Post_Placer_Carrys_search.group(1)
                    pack_flag = 0
                    continue
            for time_pattern in time_pattern_list:
                title = time_pattern[0]
                pattern = time_pattern[1]
                pattern_search = pattern.search(line)
                if pattern_search:
                    self.data[title] = pattern_search.group(1)
                    break
        #print self.data
    def print_file(self):
        def add(add1,add2):
            error_flag = 0
            try:
                add1 = float(add1)
            except:
                add1 = 0
                error_flag = 1
            try:
                add2 = float(add2)
            except:
                add2 = 0
                error_flag = 1
            result = add1 + add2
            if result == 0  and error_flag:
                return 'NA'
            else:
                return str(result)

        output_file = self.output_file
        header_0 = "Design ,Post-Synthesis Stage,,,,Post-PnR Stage,,,,,, Fmax Details,,,,,Runtime Details,,,,,,,Memory Consumption,,,,,,";
        header = "Design Name,#LUTs,#FFs,#RAMs,#Carry,#Post-Placer LUTs,#Post-Placer Carrys, #Logic Cells, #Logic Tiles, #IO Cells , #BRAM cells,#Post-Synth Fmax (Slowest Clock),Post-Placer Fmax (Slowest Clock),Post-route Fmax Clock(Slowest), Post-Route Fmax Target Freq (Mhz), Post-Route Fmax (Slowest Clock),Parser Runtime,Placer Runtime,Packer Runtime,Router Runtime,Bitmap Runtime,Netlister Runtime,Timer Runtime,Peak Memory,Total Wall Clock Time,Total CPU Time,Comments";

        if os.path.isfile(output_file):
            pass
        else:
            file_hand = file(output_file,"w")
            file_hand.write(header_0+"\n")
            file_hand.write(header+"\n")
            file_hand.close()
        file_hand = file(output_file,"a")
        title_order = ['design','lut', 'ff', 'ram', 'carry','totallut','Post_Placer_Carrys', 'logiccell',
                       'logictile', 'iocell', 'bramcell', 'synfmax', 'ppfmax', 'fmaxclock',
                       'fmaxtarget', 'fmax', 'parser_runtime', 'placer_runtime', 'packer_runtime',
                       'router_runtime', 'bitmap_runtime', 'netlister_runtime', 'timer_runtime',
                       'peak_mem', 'total_runtime', 'total_cputime', 'comments']
        line = ''
        self.print_line = ""
        for title in title_order:
            temp_data = ""
            if title == "ram":
                #line = line + ","+ add( self.data.get(title,'-'), self.data.get("rom",'-'))
                temp_data = add( self.data.get(title,'-'), self.data.get("rom",'-'))
            else:
                #line = line + ","+self.data.get(title,'-')
                temp_data = self.data.get(title,'-')
            line = line + ","+temp_data
            if title == 'design':
                pass  # self.print_line += "\t"+"<Design>"+temp_data+"</Design>\n"
            else:
                self.print_line += "\t"+"<%s>"%title+temp_data+"</%s>\n"%title
        line = line.lstrip(',')
        file_hand.write(line+"\n")
        file_hand.close()

        print '#BQS_RETRN_DATA_BEGIN#'
        print '<scan_case>\n'+self.print_line+"</scan_case>"
        print '#BQS_RETRN_DATA_END#'
        print "===TMP Detail==="
        print self.print_line
        print "===TMP end==="

    def process(self):
        self.parse_option()
        opts, args = self.parser.parse_args()
        if opts.report:
            self.output_file = opts.report
        else:
            self.output_file = "result.csv"
        design_list = []
        if opts.job_dir:
            if not os.path.isdir(opts.job_dir):
                print 'Error: can not find directory:',opts.job_dir
                return
            self.output_file = os.path.join(opts.job_dir,self.output_file)
            if opts.design:
                design_list.append(os.path.join(opts.job_dir,opts.design))
            else:
                for f_d in os.listdir(opts.job_dir):
                    f_d_path  = os.path.join(opts.job_dir,f_d)
                    if os.path.isdir(f_d_path):
                        design_list.append(f_d_path)
        elif  opts.design:
                design_list.append(opts.design)
        else:
            print 'Error: please run script as *.py --design=* --job-dir=*'
            return
        for design in design_list:
            self.design = design
            self.get_scan_file()
            self.scan_srr()
            self.scan_placer()
            self.scan_packer()
            self.scan_router()
            self.scan_run_log()
            self.print_file()
if __name__ == '__main__':
    srr_file = r'D:\ICE\regresion_win\run\Justalu\alu_init\SYNTH\rev_1\test_syn.srr'
    placer_file = r'D:\ICE\regresion_win\run\Justalu\alu\SYNTH\rev_1\sbt\outputs\placer\placer.log'
    packer_file = r'D:\ICE\regresion_win\run\Justalu\alu\SYNTH\rev_1\sbt\outputs\packer\n_par_alu_io_v0_info.log'
    router_file = r'D:\ICE\regresion_win\run\Justalu\alu\SYNTH\rev_1\sbt\outputs\router\n_par_alu_io_v0_timing.rpt'
    log_file = r'D:\ICE\regresion_win\run\Justalu\alu\SYNTH\run_log'
    #instance = scan_log(srr_file,placer_file,packer_file,router_file,log_file)
    #instance = scan_log(r'D:\ICE\regresion_win\run\Justalu\alu')
    instance = scan_log()
    instance.process()
    print instance.data

