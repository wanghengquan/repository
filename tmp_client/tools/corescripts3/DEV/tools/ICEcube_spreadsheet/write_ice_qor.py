__author__ = 'yzhao1'
import configparser
import re
import sys
import os
import csv
from pyExcelerator import *
#import style
import string
def excel_col_names():
    '''
       This function used to return the col dictionary in the excel as:
       A,B,---,AA,---ZZ
    '''
    all_letter = string.ascii_uppercase
    result = {}
    list_num_one = [ a_letter for a_letter in all_letter ]
    list_num_two = [ i + j for i in all_letter for j in all_letter]
    for key,value  in enumerate(list_num_one + list_num_two ):
        result.setdefault(key,value)
        #print key+1,'==>',value
    return result
excel_col_list = excel_col_names()
class read_csv:
    def __init__(self,csv_file):
        self.csv_file = csv_file
        self.design_line = {}
    def read_csv_note(self):
        if os.path.isfile(self.csv_file):
            pass
        else:
            print("Error: can not find %s"%self.csv_file)
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
        #print ori_dict.fieldnames
        #raw_input()
        for item in ori_dict:
            design = item.get('Design Name','None')
            if design != 'None' and design != '':
                if design == "fir_12_16_10" or design == "vga_top":
                    continue
                self.design_line[design] = item
            else:
                pass

class compare_csv:
    def __init__(self,src_csv,cmp_csv,compare_titles,summary_title,title_flag,src_name,cmp_name,conf_dict,store_dir):
        self.src_csv = src_csv
        self.cmp_csv = cmp_csv
        self.compare_titles = compare_titles
        self.title_flag = title_flag
        self.sheet = ''
        self.wb = Workbook()
        self.sheet_name = os.path.splitext(os.path.basename(src_name))[0]+" VS "+ \
                          os.path.splitext(os.path.basename(cmp_name))[0]
        self.sheet = self.wb.add_sheet(self.sheet_name)
        self.sheet_summary = self.wb.add_sheet(title_flag.upper()+ "_QoR")
        self.style = XFStyle()
        self.style.num_format_str = "0.00%"
        self.green_style = XFStyle()
        self.green_style.pattern.pattern = 0x01
        self.style.num_format_str = "0.00%"
        self.green_style.pattern.pattern_back_colour = "green"
        self.green_style.pattern.pattern_fore_colour = "green"
        self.all_diff = {}
        self.conf_dict = conf_dict
        self.summary_title = summary_title
        self.store_dir = store_dir
    def write_title(self):
        self.sheet.write(0,0,"Design Name")
        self.sheet.write(1,0,"")
        for id,title in enumerate(self.compare_titles):
            self.sheet.write(0,1+id*3,title)
            self.sheet.write(1,id*3+1,"pre")
            self.sheet.write(1,id*3+2,"curr")
            self.sheet.write(1,id*3+3,"diff")
    def write_body(self):
        designs = list(self.src_csv.design_line.keys())
        designs.sort()
        begin_line = 2
        for id1,design in enumerate(designs):
            self.all_diff[design] = {}
            self.sheet.write(begin_line+id1,0,design)
            for id2,title in enumerate(self.compare_titles):
                pre = self.cmp_csv.design_line.get(design,{}).get(title,'')
                try:
                    pre = float(pre)
                except:
                    pass
                self.sheet.write(begin_line+id1,1+id2*3+0,pre)
                cur = self.src_csv.design_line.get(design,{}).get(title,'')
                try:
                    cur = float(cur)
                except:
                    pass
                self.sheet.write(begin_line+id1,1+id2*3+1,cur)
                try:
                    pre = float(pre)
                    cur = float(cur)
                    percent = (cur-pre)/pre
                except:
                    percent = ''
                position1 = excel_col_list[1+id2*3+0]+str(begin_line+id1+1)
                position2 = excel_col_list[1+id2*3+1]+str(begin_line+id1+1)
                if percent == '':
                    self.sheet.write(begin_line+id1,1+id2*3+2,'-')
                else:
                    diff = Formula("("+position2+"-"+position1+")/"+position1)
                    self.sheet.write(begin_line+id1,1+id2*3+2,diff,self.style)
                diff_position = excel_col_list[1+id2*3+2]+str(begin_line+id1+1)
                self.all_diff[design][title] = [diff_position,percent]

    def write_summary(self):

        self.sheet_summary.col(2).width = 25*3328/10
        self.sheet_summary.write(1,2,"BUILD CMPR VERSIONS",self.green_style)
        self.sheet_summary.write(2,2,"Mode",self.green_style)
        self.sheet_summary.write(3,2,"LSE/SYNP VERSION ",self.green_style)
        self.sheet_summary.write(1,3,self.conf_dict.get('build_version'))
        self.sheet_summary.write(2,3,self.title_flag.upper())
        if self.title_flag.find("lse")!= -1:
            self.sheet_summary.write(3,3,self.conf_dict.get('lse_version'))
        elif self.title_flag.find("synp") != -1:
            self.sheet_summary.write(3,3,self.conf_dict.get('syn_version'))
        else:
            self.sheet_summary.write(3,3,'Synplify Pro Prod Vs LSE Prod.')
        if self.title_flag.find("area") != -1:
            self.sheet_summary.write(0,11,'Area Mode : " -ve Logicell average indicate reduction (improvement)  in Area"')
            self.sheet_summary.write(1,11,'Area Mode : " +ve Logicell average indicate increase  ( digression) in  Area"')
        if self.title_flag.find("timing")!= -1:
            self.sheet_summary.write(0,11,'Timing Mode : "+ Average indicate  improvement in timing" ')
            self.sheet_summary.write(1,11,'Timing Mode : "-  Average indicate digression in timing" ')
            self.sheet_summary.write(2,11,'Timing QoR digression should not be > 0.5% between releases')
        all_design = list(self.all_diff.keys())
        all_design.sort()
        average_dict = {}
        for id1, design in enumerate(all_design):
            self.sheet_summary.write(7+id1,2,design)
        win = 0
        loss = 0
        loss_10 = 0
        for id1,title in enumerate( self.summary_title ):
            self.sheet_summary.write(6,3+id1,title)
            total = 0
            num = 0.0
            for id2, design in enumerate(all_design):
                num += 1
                try:
                    total += self.all_diff[design][title][1]
                except:
                    pass
                self.sheet_summary.write(7+id2,3+id1,self.all_diff[design][title][1],self.style)
                #content = "QoR!"+self.all_diff.get(design)[0]
                #self.sheet_summary.write(7+id2,3+id1,Formula(content)) #this can not tobe realized as python not support
                if self.title_flag.find("area")!= -1:
                    if title == "Logic Cells":
                        if self.all_diff[design][title][1] > 0.1:
                            loss_10 += 1
                        elif self.all_diff[design][title][1] <= 0:
                            win += 1
                        else:
                            loss += 1
                elif self.title_flag.find("timing")!= -1:
                    if 1:# for timing model, just care fmax
                        if self.all_diff[design][title][1] < -0.05:
                            loss_10 += 1
                        elif self.all_diff[design][title][1] >= 0:
                            win += 1
                        else:
                            loss += 1
            print(total)
            print(num)
            try:
                average = total/num
            except:
                average = ''
            print(average)
            average_dict[title] = average
        for id1,title in enumerate(self.summary_title):
            self.sheet_summary.write(4,11+id1,title)
            self.sheet_summary.write(5,11+id1,average_dict[title],self.style )

        # special for logic cell
        self.sheet_summary.write(4,11+id1+1,"Win")
        self.sheet_summary.write(4,11+id1+2,"Loss")
        if self.title_flag.find("area")!= -1:
            self.sheet_summary.write(4,11+id1+3,"Loss>10%")
        else:
            self.sheet_summary.write(4,11+id1+3,"Loss>5%")
        #if self.title_flag == "lse_area":
        if 1:
            self.sheet_summary.write(5,11+id1+1,win/num,self.style)
            self.sheet_summary.write(5,11+id1+2,loss/num,self.style)
            self.sheet_summary.write(5,11+id1+3,loss_10/num,self.style)
        #else:
        #    self.sheet_summary.write(5,11+id1+3,loss_10/num,self.style)
    def process(self):
        if self.src_csv.read_csv_note():
            return 1
        if self.cmp_csv.read_csv_note():
            return 1
        self.write_title()
        self.write_body()
        self.write_summary()
        self.wb.save(self.store_dir+"/"+self.sheet_name+".xls")



class write_spreadsheet:
    def __init__(self,conf_file):
        self.conf = conf_file
        self.conf_options = dict()
        self.init_file_title = ['lse_area','lse_timing','synp_area','synp_timing']
        self.init_compare_titles = ['LUT','FF','Carry','BRAM','LogicCell','LogicTile']
        self.init_area_summary_titles = ['LUT','FF','Carry','BRAM','LogicCell','LogicTile']
        self.init_timing_summary_titles = ['Post-Route Fmax (Slowest Clock)']
        self.compare_titles = []
        self.area_titles = []
        self.timging_titles = []
        #self.src_file = src_file
        #self.cmp_file = cmp_file

    def read_conf(self):
        conf_parser = configparser.ConfigParser()
        try:
            conf_parser.read(self.conf)
        except:
            print("Error, please check your conf file. Make sure the format is correct")
            return -1
        for section in conf_parser.sections():
            t_section = dict()
            for option in conf_parser.options(section):
                value = conf_parser.get(section, option)
                t_section[option] = value
            self.conf_options[section] = t_section
    def process(self):
        try:
            os.makedirs("LSE")
            os.makedirs("SYNPLIFY")
            os.makedirs("SYNPLIFY_VS_LSE")
        except:
            pass
        self.read_conf()
        src_file_dict = self.conf_options.get('src_files')
        cmp_file_dict = self.conf_options.get('cmp_files')
        compare_titles_dict = self.conf_options.get("compare_title",{})
        if not compare_titles_dict:
            self.compare_titles = self.init_compare_titles
            self.area_titles = self.init_area_summary_titles
            self.timging_titles = self.init_timing_summary_titles
        else:
            self.compare_titles = ( compare_titles_dict.get("compare_title")).split(",")
            self.area_titles = ( compare_titles_dict.get("area_summary_title")).split(",")
            self.timging_titles = ( compare_titles_dict.get("timing_summary_title")).split(",")

        for title in self.init_file_title:
            src_file = src_file_dict.get(title)
            cmp_file  = cmp_file_dict.get(title)
            if not src_file or not cmp_file:
                continue
            src_instance = read_csv(src_file)
            cmp_instance = read_csv(cmp_file)
            if title.find("area")!= -1:
                summary_title = self.area_titles

            else:
                summary_title = self.timging_titles
            if title.find("lse") != -1:
                dir = "LSE"
            elif title.find("synp") != -1:
                dir = "SYNPLIFY"
            else:
                dir = "SYNPLIFY_VS_LSE"
            write_instance = compare_csv(src_instance,cmp_instance,self.compare_titles,summary_title,
                                         title,src_file,cmp_file,self.conf_options.get('basic_conf',{}),dir)
            write_instance.process()
        for title in ['area',"timing"]:
            src_file = src_file_dict.get("lse_"+title)
            cmp_file  = cmp_file_dict.get("synp_"+title)
            if not src_file or not cmp_file:
                continue
            src_instance = read_csv(src_file)
            cmp_instance = read_csv(cmp_file)
            if title.find("area")!= -1:
                summary_title = self.area_titles

            else:
                summary_title = self.timging_titles

            if title.find("lse") != -1:
                dir = "LSE"
            elif title.find("synp") != -1:
                dir = "SYNPLIFY"
            else:
                dir = "SYNPLIFY_VS_LSE"
            write_instance = compare_csv(src_instance,cmp_instance,self.compare_titles,summary_title,
                                         title,src_file,cmp_file,self.conf_options.get('basic_conf',{}),dir)
            write_instance.process()
if __name__ == "__main__":
    conf_file = "conf.conf"
    instance = write_spreadsheet(conf_file)
    instance.process()

