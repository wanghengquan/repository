__author__ = 'yzhao1'
import os
import csv
import sys
from pyExcelerator import *
import ConfigParser

class read_csv:
    def __init__(self,csv_file):
        self.csv_file = csv_file
        self.design_line = {}
    def read_csv_note(self):
        if os.path.isfile(self.csv_file):
            pass
        else:
            print "Error: can not find %s"%self.csv_file
            return -1
        begin = 0
        hot_lines = []
        for id1,line in enumerate(open(self.csv_file)):
                line = line.strip()
                if begin == 0:
                    if line.startswith('Design Name'):
                        begin = 1
                        line = line.replace(' #','#')
                        line = line.replace('#','')
                        line = line.replace(', ',',')
                        line = line.replace(' ,',',')
                        hot_lines.append(line)
                        continue
                    else:
                        pass
                else:
                    line = line.replace('#','')
                    hot_lines.append(line)
        ori_dict = csv.DictReader(hot_lines)
        for item in ori_dict:
            design = item.get('Design Name','None')
            if design != 'None' and design != '':
                self.design_line[design] = item
            else:
                pass

class write_excel:
    def __init__(self,conf_file):
        self.conf_file = conf_file
        self.order = ["lse_lighting","synp_lighting","lse_thunder","synp_thunder","lse_bolt","synp_bolt"]
        self.init_titles = "LUTs,FFs,RAMs,Post-Placer LUTs,Logic Cells,Logic Tiles,IO Cells,Post-route Fmax Clock(Slowest),Post-Route Fmax Target Freq (Mhz),Post-Route Fmax (Slowest Clock)"
        self.init_titles = self.init_titles.split(",")
        self.wb = Workbook()
        self.sheet = self.wb.add_sheet("Lightning-Thunder-Bolt QoR")
        self.begin_line = 10
        self.begin_column = 0
        for i in range(0,13):
            if i in[0,8,9,10]:
                self.sheet.col(i).width = 25*3328/10
            else:
                self.sheet.col(i).width = 10*3328/10
        self.conf_options = {}
    def write_sheet(self):
        if os.path.isfile(self.conf_file):
            pass
        else:
            print "Error: can not get file:%s"%self.conf_file
            return
        conf_parser = ConfigParser.ConfigParser()
        try:
            conf_parser.read(self.conf_file)
        except:
            print "Error, please check your conf file. Make sure the format is correct"
            return -1
        for section in conf_parser.sections():
            t_section = dict()
            for option in conf_parser.options(section):
                value = conf_parser.get(section, option)
                t_section[option] = value
            self.conf_options[section] = t_section
        for title in self.order:
            print conf_parser
            csv_file = self.conf_options.get("file_list",{}).get(title,'')
            if not csv_file:
                continue
            csv_instance = read_csv(csv_file)
            csv_instance.read_csv_note()
            self.sheet.write(self.begin_line,0,"SYNTHESIS TOOL ")
            if title.find("lse") != -1:
                self.sheet.write(self.begin_line,1,"LSE")
            else:
                self.sheet.write(self.begin_line,1,"SYNPLIFY")
            self.begin_line += 1
            self.sheet.write(self.begin_line,0,"Design Name")
            for id1,sub_title in enumerate( self.init_titles):
                if sub_title == "Post-route Fmax Clock(Slowest)":
                    sub_title = "Constrained Clocks (Slowest)"
                elif sub_title == "Post-Route Fmax Target Freq (Mhz)":
                    sub_title = "Target Freqeuncy  (MHz)"
                self.sheet.write(self.begin_line,id1+1,sub_title)
            self.sheet.write(self.begin_line,id1+1+1,"STATUS")
            self.sheet.write(self.begin_line,id1+1+1+1,"Comments")
            self.begin_line += 1

            for design,design_resource in csv_instance.design_line.items():
                target = ""
                slowest = ""
                for id1,sub_title in enumerate( ["Design Name"]+self.init_titles):
                    if sub_title == "Post-Route Fmax Target Freq (Mhz)":
                        target = design_resource.get(sub_title,"")
                    if sub_title == "Post-Route Fmax (Slowest Clock)":
                        slowest = design_resource.get(sub_title,"")
                    content = design_resource.get(sub_title,"")
                    try:
                        content = float(content)
                    except:
                        pass
                    self.sheet.write(self.begin_line,id1,content)
                result = "FAIL"
                try:
                    target =  float(target)
                    slowest = float(slowest)
                    if target < slowest:
                        result = "PASS"
                    else:
                        pass
                except:
                    pass
                self.sheet.write(self.begin_line,id1+1,result)
                self.begin_line += 1
            self.begin_line += 6
        self.wb.save("LBT_QoR.xls")






if __name__ == "__main__":
    excel_isinstance = write_excel("LBT.conf")
    excel_isinstance.write_sheet()
