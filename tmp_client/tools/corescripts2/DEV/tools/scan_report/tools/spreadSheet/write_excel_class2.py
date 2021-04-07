#! C:\Python25\python.exe
#coding:utf-8
#===================================================
# Owner    : Yzhao1
# Function :
#           This file used to write the compared data from compared csv file
#           All title will be lower
# Attention:
#
# Date     :2013/1/10

#===================================================
import os,sys,csv
import re
# import csv_compare
from pyExcelerator import *
import style
import traceback
import optparse
import string
import write_csv_class
xlib = os.path.join(os.path.dirname(__file__),'..','..','bin','xlib')
xlib = os.path.abspath(xlib)
if xlib in sys.path:
    pass
else:
    sys.path.append(xlib)
from xConf import get_conf_options
red_range = 0.05
param_conf_file = os.path.join(os.path.dirname(__file__),'param.conf')
red_range_dic  = get_conf_options(param_conf_file)['red_range']
try:
    average_skil = get_conf_options(param_conf_file)['average_use']
    average_skil['use'] = average_skil['use'].split(',')
    average_skil['use'] = [item.lower() for item in average_skil['use'] ]
except:
    average_skil = {}
    average_skil['use'] = []
case_list_path =  os.path.join(__file__,'..','..','..','conf','case_list.conf')
case_list_path = os.path.abspath(case_list_path)
case_group_dic = get_conf_options(case_list_path)['case_list']
group_cases= {}
for group,cases in case_group_dic.items():
    cases = cases.split()
    for item in cases:
        group_cases.setdefault(group,[]).append(item)
all_groups = group_cases.keys()
statistic_tie_list = [['win','win'],
        ['tie','tie'],
        ['lose','lose'],
        ['less15','<-15%'],
        ['less15_5','-15%~-5%'],
        ['less5_5','-5%~5%'],
        ['more5_15','5%~15%'],
        ['more15','>15%']]
threshold = 0.15
win_lose = 0.05
USE_LESS = 0.4 # if the value is bigger, this case will useless
key_order = ['Fmax','Regs','Luts','Slices','Runtime','MapPMem','ParPMem']
key_order = ['fmax','Register','LUT','Slice','MapPeakMem','ParPeakMem','Total_cpu_time']
def float_f_s(string,cmp_part=0):
    string = str(string)
    string = string.strip()
    if string.endswith('%') and cmp_part==1:
        string = string[:-1]
        try:
            f_v =  float(string)/100.0
            f_v = float("%.4f"%f_v)
            return f_v
        except:
            return string
    try:
        f_v =  float(string)
        f_v = float("%.4f"%f_v)
        return f_v
    except:
        return string
def dict_add_value(dic,k,v):
    if k in dic.keys():
        pass
    else:
        dic[k] = v
    #return dic
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
class style:
    def __init__(self,lineStyle='0000',cellAlignment='100',cellPatternColour='', \
                cellFontColour='black',cellFontIsBold=False,cellFontSize=8, \
                myFormat=''):
        self._cellBorderLineStyle = {'0' : 0x00,   # NO_LINE
                        '8' : 0x01,   # THIN
                        '1' : 0x03,    # remove line
                        '2' : 0x02,   # MEDIUM
                        '3' : 0x03,   # DASHED
                        '4' : 0x04,   # DOTTED
                        '5' : 0x05,   # THICK
                        '6' : 0x06,   # DOUBLE
                        '7' : 0x07}   # HAIR
        self._cellAlignmentStyle = {'100' : 0x01,  # left
                       '010' : 0x02,  # center
                       '001' : 0x03}  # right
        if cellFontColour == 'red':
            cellFontColour = 0x2
        if cellFontColour == 'green':
            cellFontColour = 0x11
        if cellFontColour == 'black':
            cellFontColour = 0
        self.lineStyle=lineStyle
        self.cellAlignment=cellAlignment
        self.cellPatternColour=cellPatternColour
        self.cellFontColour=cellFontColour
        self.cellFontIsBold = cellFontIsBold
        self.cellFontSize = cellFontSize
        self.myFormat = myFormat
        self.createBorders()
        self.createAlignment()
        self.createPattern()
        self.createFont()
    def createBorders(self):
        self.myBorders = Borders()
        lineStyleList = list(self.lineStyle)
        self.myBorders.top    = self._cellBorderLineStyle[lineStyleList[0]]
        self.myBorders.bottom = self._cellBorderLineStyle[lineStyleList[1]]
        self.myBorders.left   = self._cellBorderLineStyle[lineStyleList[2]]
        self.myBorders.right  = self._cellBorderLineStyle[lineStyleList[3]]
    def createAlignment(self):
        self.myAlignment = Alignment()
        self.myAlignment.horz = self._cellAlignmentStyle[self.cellAlignment]
        self.myAlignment.vert = 0x01  # VERTICAL CENTER
    def createPattern(self):
        self.myPattern = Pattern()
        if self.cellPatternColour:
            self.myPattern.pattern = 0x01
            self.myPattern.pattern_back_colour = self.cellPatternColour
            self.myPattern.pattern_fore_colour = self.cellPatternColour
    def createFont(self):
        self.myFont = Font()
        self.myFont.colour_index = self.cellFontColour
        self.myFont.bold = self.cellFontIsBold
        self.myFont.height = self.cellFontSize * 20   # IN PIXEL
    def createStyle(self):
        myStyle = XFStyle()
        myStyle.borders = self.myBorders
        myStyle.alignment = self.myAlignment
        myStyle.pattern = self.myPattern
        myStyle.font = self.myFont
        if self.myFormat:
            myStyle.num_format_str = self.myFormat
        return myStyle

class write_excel:
    def __init__(self,src,cmps,output,comp_title,original_title,show_design,wb='',name_list='',no_fmax=''):
        self.src = src
        self.cmps = cmps
        self.output = output
        self.comp_title = comp_title
        self.original_title = original_title
        self.show_design = show_design
        self.lines = {}
        self.note_line = []
        self.tie_win = {}
        self.select_group_list = []
        self.file_name_line = ''
        self.skip_case_list = []
        self.re_numbers = re.compile(r'\d')
        self.re_letters = re.compile(r'[a-zA-Z]+')
        self.for_total_return = {}
        self.no_fmax = no_fmax
        for num,cmp in enumerate(self.cmps):
            self.tie_win[num] = {}
        key = self.src.csv_dic.keys()[0]
        for group in all_groups:
                group_list = group_cases[group]
                if key in group_list:
                    if set(group_list) == set(self.src.csv_dic.keys()):
                        self.select_group_list = group_list
                        first_case = 1
                        break
        if not self.select_group_list:
            self.select_group_list = self.src.csv_dic.keys()
            self.select_group_list.sort()
        self.basename,subtext = os.path.splitext(os.path.basename(self.output))
        if not wb:
            self.wb = Workbook()
            #self.sum1 = wb.add_sheet('summary')
            self.totalSheet = wb.add_sheet(self.basename)

        else:
            self.totalSheet = wb.add_sheet(self.basename)
            #self.sum1 = wb.add_sheet('summary')
        #self.for_total_return[self.basename] = {}
        self.for_total_return[self.basename] = []
    def write_note(self):
        style_class = style(lineStyle='4444',cellPatternColour='yellow')
        key_style = style_class.createStyle()
        all_keys = self.src.note.keys()
        dict_return = {}
        dict_return.update(self.src.note)
        src_dict_note_dict = {}
        cmp_dict_note_dict = []
        if self.src.note.get('Note',''):
            note_lines = self.src.note.get('Note','')
            print 'SRC   ',note_lines
            if type(note_lines) is list:
                for n_l in note_lines:
                    n_l = n_l.strip(':')
                    n_n = n_l.split(':',1)
                    if len(n_n) == 2:
                        src_dict_note_dict.setdefault(n_n[0].strip(),[]).append(n_n[1].strip())
                    else:
                        src_dict_note_dict.setdefault(n_n[0].strip(),[]).append(' ')
            else:
                note_lines = note_lines.strip()
                if note_lines and note_lines!=':':
                    note_lines = note_lines.strip(':')
                    n_n = note_lines.split(':',1)
                    if len(n_n) == 2:
                        src_dict_note_dict.setdefault(n_n[0].strip(),[]).append(n_n[1].strip())
                    else:
                        src_dict_note_dict.setdefault(n_n[0].strip(),[]).append(' ')
        for cmp in self.cmps:
            if cmp.note.get('Note',''):
                s_cmp_dict_note_dict = {}
                note_lines = cmp.note.get('Note','')

                print note_lines
                if type(note_lines) is list:
                    for n_l in note_lines:
                        n_l = n_l.strip(':')
                        n_n = n_l.split(':',1)
                        if len(n_n) == 2:
                            s_cmp_dict_note_dict.setdefault(n_n[0].strip(),[]).append(n_n[1].strip())
                        else:
                            s_cmp_dict_note_dict.setdefault(n_n[0].strip(),[]).append(' ')
                else:
                    note_lines = note_lines.strip()
                    note_lines = note_lines.strip(':')
                    if note_lines and note_lines!=':':
                        n_n = note_lines.split(':',1)
                        if len(n_n) == 2:
                            s_cmp_dict_note_dict.setdefault(n_n[0].strip(),[]).append(n_n[1].strip())
                        else:
                            s_cmp_dict_note_dict.setdefault(n_n[0].strip(),[]).append(' ')
                cmp_dict_note_dict.append(s_cmp_dict_note_dict)

            for key in cmp.note.keys():
                if key in dict_return.keys():
                    if cmp.note[key] == dict_return[key]:
                        pass
                    else:
                        if type(dict_return[key]) is list:
                            dict_return[key] = ",".join(dict_return[key])
                        if type(cmp.note[key]) is list:
                            cmp.note[key] = ",".join(cmp.note[key])
                        dict_return[key] = dict_return[key] + '::'+cmp.note[key]
        self.src_dict_note_dict = src_dict_note_dict
        self.cmp_dict_note_dict = cmp_dict_note_dict
        row = 0
        col = 0
        self.totalSheet.col(0).width = 3*3328/10
        keys = dict_return.keys()
        keys.sort()
        for key in keys:
            if key.lower() == 'note':
                continue
            value1 = dict_return[key]
            if type(value1) is list:
                value1 = ",".join(value1)
            if len(key)<= 5:
                length = 1
                self.totalSheet.write_merge(row, row, 1, 2, '['+key+']',key_style)
            else:
                length = len(key)/9 +1
                self.totalSheet.write_merge(row, row, 1, 2,'['+key+']',key_style)
            row = row + 1
            col = 3
            if len(value1)<= 5:
                self.totalSheet.write(row-1, col, value1)
            else:
                length = len(value1)/9 + 1
                self.totalSheet.write_merge(row-1, row-1, col, length+col,value1)
        return row

    def write_file_name(self,row):
        style_class = style(lineStyle='2422',cellAlignment='010')
        style_center = style_class.createStyle()
        second_part = ''
        first_part = os.path.basename(self.src.csv_file)+','*( len(self.original_title) )
        for cmp in self.cmps:
            part = os.path.basename(cmp.csv_file)+','*( len(self.original_title)-1 )
            second_part+=part
        for id1,cmp in enumerate(self.cmps):
            n1 = id1 + 1
            #part = 'cmp' +str(n1)+ ","*(len(self.comp_title)*2 )
            #part = self.src.csv_file+'VS'+cmp.csv_file+ ","*(len(self.comp_title)*2 )
            if not self.no_fmax:
                part = os.path.basename(cmp.csv_file)+'VS'+os.path.basename(self.src.csv_file)+ ","*(len(self.comp_title)*2 )
            else:
                part = os.path.basename(cmp.csv_file)+'VS'+os.path.basename(self.src.csv_file)+ ","*(len(self.comp_title)*1 )
            second_part+=part
        self.file_name_line = first_part + second_part
        line = self.file_name_line.split(',')
        finder = 0
        begin = 0
        end = 0
        self.totalSheet.write(row,0, '',style_center)
        self.totalSheet.write(row,1, '',style_center)
        #print line
        #print '======================================'
        for id1,item in enumerate(line):
            if item and finder ==0:
                finder = 1
                content = item
                begin = 2
                continue
            if item and finder ==1:
                end = id1
                self.totalSheet.write_merge(row,row,begin,end, content,style_center)
                #print content,begin,end
                begin = id1+1
                content = item
                finder = 1
                continue
            if id1 == len(line)-1:
                cols = len(line) -  begin
                self.totalSheet.write_merge(row,row,begin,len(line)-1, content,style_center)
        return row + 1

    def write_title(self,row):
        '''self.original_part_title = self.original_title
        for id1,item in enumerate(self.cmps):
            use = ["#"*(id1+1)+t for t in self.original_title[1:] ]
            self.original_part_title = self.original_part_title + use
        self.firt_compare_title = []
        for id1,item in enumerate(self.cmps):
            average_title = ['#'*id1+'Average_'+t for t in self.comp_title]
            comp_title_show = ['2#'*(id1+1)+t for t in self.comp_title]
            self.firt_compare_title += comp_title_show + average_title'''
        #print self.original_title
        self.original_part_title= [t for t in self.original_title]
        if 'LE' in self.src.old_titles:
            self.original_part_title = [t.replace('Slice','LE') for t in self.original_part_title]
        if 'FitPeakMem'in self.src.old_titles:
            self.original_part_title = [t.replace('ParPeakMem','FitPeakMem') for t in self.original_part_title]
        if self.src.alut_lut:
            self.original_part_title = [t.replace('LUT','ALUT') for t in self.original_part_title]
        for id1,item in enumerate(self.cmps):
            u_t = []
            if 'LE' in item.old_titles:
                u_t = [t.replace('Slice','LE') for t in self.original_title[1:]]
            if 'FitPeakMem'in item.old_titles:
                u_t = [t.replace('ParPeakMem','FitPeakMem') for t in u_t]
            if not u_t:
                u_t = [t for t in self.original_title[1:] ]
            if item.alut_lut:
                u_t = [t.replace('LUT','ALUT') for t in u_t ]
            use = ["#"*(id1+1)+t for t in u_t ]
            self.original_part_title = self.original_part_title + use
        self.firt_compare_title = []
        for id1,item in enumerate(self.cmps):
            average_title = ['#'*id1+'Average_'+t for t in self.comp_title]
            comp_title_show = ['2#'*(id1+1)+t for t in self.comp_title]
            if not self.no_fmax:
                self.firt_compare_title += comp_title_show + average_title
            else:
                self.firt_compare_title += comp_title_show
        self.show_title = self.original_part_title+self.firt_compare_title
        style_class = style(lineStyle='4222',cellAlignment='010')
        style_center = style_class.createStyle()
        #style_center = style.myCreateStyle(myBorders='4222',myAlignment='010')
        style_center.font.bold = 'True'
        self.totalSheet.write(row, 0, 'ID',style_center)
        col = 1
        for item in self.show_title:
            self.totalSheet.write(row, col, item,style_center)
            col = col + 1
        self.totalSheet.panes_frozen = True
        self.totalSheet.horz_split_pos = 7
        self.totalSheet.vert_split_pos = 2
        row = row + 1
        return row

    #def tool_write_with_col(self,red_range,)

    def write_body(self,row):
        if 1: # define all the styles
            line_all_bold = '2222'
            line_all_dot = '4444'
            line_left = '4424'
            line_right = '4442'

            if self.no_fmax:
                line_all_bold = '2222'
                line_all_dot = '8888'
                line_left = '8828'
                line_right = '8882'
            style_class_percent = style(lineStyle=line_all_bold,myFormat='0.00%')
            statistic_percent = style_class_percent.createStyle()
            statistic_style = style(lineStyle=line_all_bold)
            statistic_style = statistic_style.createStyle()
            body_style = style(lineStyle=line_all_dot)
            body_style = body_style.createStyle()
            body_style_red = style(lineStyle=line_all_dot,cellFontColour='red')
            body_style_red = body_style_red.createStyle()
            body_style_green = style(lineStyle=line_all_dot,cellFontColour='green')
            body_style_green = body_style_green.createStyle()
            body_style_left = style(lineStyle=line_left)
            body_style_left = body_style_left.createStyle()
            body_style_green = style(lineStyle=line_left,cellFontColour='red')
            body_style_green = body_style_green.createStyle()
            body_style_left_green = style(lineStyle=line_left,cellFontColour='green')
            body_style_left_green = body_style_left_green.createStyle()
            body_style_right = style(lineStyle=line_right)
            body_style_right = body_style_right.createStyle()
            body_style_red_percent = style(lineStyle=line_all_dot,cellFontColour='red',myFormat='0.00%')
            body_style_red_percent = body_style_red_percent.createStyle()
            body_style_percent = style(lineStyle=line_all_dot,myFormat='0.00%')
            body_style_percent = body_style_percent.createStyle()
            body_style_green_percent = style(lineStyle=line_all_dot,cellFontColour='green',myFormat='0.00%')
            body_style_green_percent = body_style_green_percent.createStyle()
            body_style_left_percent = style(lineStyle=line_left,myFormat='0.00%')
            body_style_left_percent = body_style_left_percent.createStyle()
            body_style_left_red_percent = style(lineStyle=line_left,cellFontColour='red',myFormat='0.00%')
            body_style_left_red_percent = body_style_left_red_percent.createStyle()
            body_style_left_green_percent = style(lineStyle=line_left,myFormat='0.00%',cellFontColour='green')
            body_style_left_green_percent = body_style_left_green_percent.createStyle()

            body_style_right_percent = style(lineStyle=line_right,myFormat='0.00%')
            body_style_right_percent = body_style_right_percent.createStyle()
            body_style_right_red_percent = style(lineStyle=line_right,cellFontColour='red',myFormat='0.00%')
            body_style_right_red_percent = body_style_right_red_percent.createStyle()
            body_style_right_green_percent = style(lineStyle=line_right,myFormat='0.00%',cellFontColour='green')
            body_style_right_green_percent = body_style_right_green_percent.createStyle()

            body_style_right_percent = style(lineStyle=line_right,myFormat='0.00%')
            body_style_right_percent = body_style_right_percent.createStyle()

            body_style_right_green_percent_t = style(lineStyle=line_right,myFormat='0.00%',cellFontColour='green',cellPatternColour=0x16)
            body_style_right_green_percent_t = body_style_right_green_percent_t.createStyle()
            #body_style_right_green_percent_t.pattern.pattern=0x01
            #body_style_right_green_percent_t.pattern._pattern_back_colour=0x42
            #body_style_right_green_percent_t.pattern._pattern_fore_colour=0x41

            body_style_right_red_percent_t = style(lineStyle=line_right,cellFontColour='red',myFormat='0.00%',cellPatternColour=0x16)
            body_style_right_red_percent_t = body_style_right_red_percent_t.createStyle()

            body_style_green_percent_t = style(lineStyle=line_all_dot,cellFontColour='green',myFormat='0.00%',cellPatternColour=0x16)
            body_style_green_percent_t = body_style_green_percent_t.createStyle()

            body_style_red_percent_t = style(lineStyle=line_all_dot,cellFontColour='red',myFormat='0.00%',cellPatternColour=0x16)
            body_style_red_percent_t = body_style_red_percent_t.createStyle()
            #body_style_right_red_percent_t.pattern.pattern=0x01
            #body_style_right_red_percent_t.pattern._pattern_back_colour=0x42
            #body_style_right_red_percent_t.pattern._pattern_fore_colour=0x41


        row_for_id  = row
        case_id = 0
        excel_col_list = excel_col_names()
        self.all_src_posiotion = {} #case:title:position
        self.all_cmp_position = {} # cmp_name:case:title:position
        self.all_cmp_position_average = {}# cmp_name:title:position
        self.all_cmp_position_comp = {}
        self.tie_win = {}
        self.pass_total = {}
        all_case = []
        useless_value = float( red_range_dic.get('useless_value',USE_LESS) )
        #useless_dict = {}
        self.real_average = {}
        self.real_number = {}
        for num,cmp in enumerate(self.cmps):
            self.all_cmp_position[cmp.csv_file]={}
            self.all_cmp_position_average[cmp.csv_file] = {}
            self.all_cmp_position_comp[cmp.csv_file] = {}
            self.tie_win[num]={}
            self.pass_total[num] = {}
            self.pass_total[num]['pass'] = 0
            self.pass_total[num]['total'] = 0
            all_case = all_case + cmp.csv_dic.keys()
            self.skip_case_list +=cmp.skip_case
            self.skip_case_list += list(set(self.src.csv_dic.keys())-set( cmp.csv_dic.keys()))
            self.skip_case_list += list(set( cmp.csv_dic.keys()) - set(self.src.csv_dic.keys()) )
            for id2,t in enumerate(self.comp_title):
                    if t in self.tie_win[num].keys():
                        pass
                    else:
                        self.tie_win[num][t] = {}
                        self.tie_win[num][t]['win'] = 0
                        self.tie_win[num][t]['tie'] = 0
                        self.tie_win[num][t]['lose'] = 0
                        self.tie_win[num][t]['less15'] = 0
                        self.tie_win[num][t]['less15_5'] = 0
                        self.tie_win[num][t]['less5_5'] = 0
                        self.tie_win[num][t]['more5_15'] = 0
                        self.tie_win[num][t]['more15'] = 0
                    total_value_temp = 0
                    total_value_num= 0
                    temp_used_case_num = 0
                    for id3,case in enumerate(self.select_group_list):
                        try:
                            value2 = float_f_s(cmp.csv_dic[case][t],1)
                            if re.search('\d',str(value2)):
                                temp_used_case_num = temp_used_case_num + 1
                            value1 = float_f_s(self.src.csv_dic[case][t],1)

                            value = float_f_s(value2/value1 -1,1)
                            total_value_temp = total_value_temp + value
                            total_value_num = total_value_num + 1
                        except :
                            pass
                    try:
                        av_temp = total_value_temp/total_value_num
                    except:
                        av_temp = 0
                    self.real_average.setdefault(t,[]).append(av_temp)
                    self.real_number.setdefault(t,[]).append(temp_used_case_num)
                    for id3,case in enumerate(self.select_group_list):
                        try:
                            value1 = float_f_s(self.src.csv_dic[case][t],1)
                            value2 = float_f_s(cmp.csv_dic[case][t],1)
                            value = float_f_s(value2/value1 -1,1)
                            #if value >= useless_value+av_temp or value<=av_temp-useless_value:
                            if value >= useless_value*temp_used_case_num or value<=0-useless_value*temp_used_case_num:
                                if t.lower() in average_skil['use']:
                                    self.skip_case_list +=[case]
                        except KeyError:
                            pass
                        except Exception,e:
                            pass
                            #print traceback.format_exc()
                            #print 222
                            #self.skip_case_list +=[case]
                        #print self.skip_case_list
                        #raw_input(11)
                    #######################################################
                    '''
                    for id3,case in enumerate(self.select_group_list):
                        try:
                            value1 = float_f_s(self.src.csv_dic[case][t],1)
                            value2 = float_f_s(cmp.csv_dic[case][t],1)
                            value = float_f_s(value2/value1 -1,1)
                            if value >= useless_value or value<=0-useless_value:
                                self.skip_case_list +=[case]
                        except KeyError:
                            pass
                        except:
                            self.skip_case_list +=[case]
                    '''
        #all_case = all_case

        self.skip_case_list +=self.src.skip_case
        self.skip_case_list = list(set(self.skip_case_list) )
        #self.skip_case_list += set(self.src.csv_dic.keys())-set(all_case)
        #self.skip_case_list += set(all_case)-set(self.src.csv_dic.keys())
        for id1,case in enumerate(self.select_group_list):
            if case!='Average' and case!='Gap':
                case_id =  case_id + 1
            else:
                continue
            self.totalSheet.write(row_for_id, 0, case_id,body_style_right) # write id\
            row_for_id = row_for_id + 1
        if not self.no_fmax:
            self.totalSheet.write_merge(row_for_id,row_for_id, 0,1, 'Average',statistic_style)
            row_for_id = row_for_id + 1

            self.totalSheet.write_merge(row_for_id,row_for_id ,0,1, 'Gap',statistic_style)
            self.write_title(row_for_id+1)
        for id1,t in enumerate(self.original_title): #src data
            row_case = row
            sum = 0
            num = 0
            used_p = []
            not_used_p = []
            all_item_value = [0,0]
            for id2,case in enumerate(self.select_group_list):
                dict_add_value(self.all_src_posiotion,case,{})
                dict_add_value(self.all_src_posiotion,'average',{})
                dict_add_value(self.all_src_posiotion,'gap',{})
                try:
                    value  = self.src.csv_dic[case][t]
                    value2 =  float_f_s(value,1)
                    if case not in self.skip_case_list:
                        try:
                            sum = sum + value2
                            num = num + 1
                            all_item_value.append(value2)
                        except:
                            pass

                except:
                    value2 = '-'
                if value.endswith('%'):
                    if id1 == len(self.original_title)-1:
                        self.totalSheet.write(row_case, id1+1, value2,body_style_right_percent)
                    else:
                        self.totalSheet.write(row_case, id1+1, value2,body_style_percent)
                else:
                    if id1 == len(self.original_title)-1:
                        self.totalSheet.write(row_case, id1+1, value2,body_style_right)
                    else:
                        self.totalSheet.write(row_case, id1+1, value2,body_style)
                position = excel_col_list[id1+1]+str(row_case+1)
                dict_add_value(self.all_src_posiotion[case],t,position)
                row_case =  row_case + 1
                #if id2 == 0 or id2 == len(self.select_group_list)-1: this is the old condition
                if case in self.skip_case_list:
                    not_used_p.append(position)
                used_p.append(position)
            if id1 == 0:
                continue
            if sum != 0:
                #fs = 'average('+used_p[0]+':'+used_p[1]+')' the old formula
                begin = ''
                end = ''
                used_fs = []

                for p1,p in enumerate(used_p):
                    if p not in not_used_p and begin=='':
                        begin = p
                    elif p not in not_used_p and begin!='':
                        end = p
                        if p1 == len(used_p)-1:
                            used_fs.append(begin+":"+end)
                            begin = ''
                    elif p in not_used_p and begin == '':
                        pass
                    elif p in not_used_p and begin != '':
                        end == used_p[p1-1]
                        if begin == end:
                            used_fs.append(begin)
                        elif not end:
                            used_fs.append(begin)
                        else:
                            used_fs.append(begin+":"+end)
                        end = ''
                        begin = ''
                if begin :
                    used_fs.append(begin)
                used_fs = ";".join(used_fs)
                fs = 'AVERAGE('+used_fs+')'
                #used_fs = 'average('+used_fs[0]+')'
                if not self.no_fmax:
                    try:
                        self.totalSheet.write(row_case, id1+1, Formula(fs),statistic_style)
                    except:
                        try:
                            p_v = float_f_s( float_f_s(sum)/num,1)

                        except:
                            p_v = '-'
                        self.totalSheet.write(row_case, id1+1, p_v,statistic_style)
                    #fs = 'max('+used_p[0]+':'+used_p[1]+')'+'-'+'min('+used_p[0]+':'+used_p[1]+')'

                    try:
                        fs = 'max('+used_fs+')'+'-'+'min('+used_fs+')'
                        self.totalSheet.write(row_case+1, id1+1, Formula(fs),statistic_style)
                    except:
                        self.totalSheet.write(row_case+1, id1+1, max(all_item_value) - min(all_item_value),statistic_style)

                position = excel_col_list[id1+1]+str(row_case+1)
                try:
                    p_v = float_f_s( float_f_s(sum)/num,1)
                except:
                    p_v = '-'
                dict_add_value(self.all_src_posiotion['average'],t,[position,p_v])

                position = excel_col_list[id1+1]+str(row_case+1+1)
                dict_add_value(self.all_src_posiotion['gap'],t,position)
            else:
                if not self.no_fmax:
                    self.totalSheet.write(row_case, id1+1, '-',statistic_style)
                    self.totalSheet.write(row_case+1, id1+1,'-',statistic_style)


        for id0,cmp in enumerate(self.cmps): #cmp data

            for id1,t in enumerate(self.original_title[1:]):
                sum = 0
                num = 0
                used_p = []
                not_used_p = []
                row_case = row
                all_item_value = [0,0]
                for id2,case in enumerate(self.select_group_list):
                    dict_add_value(self.all_cmp_position[cmp.csv_file],case,{})
                    dict_add_value(self.all_cmp_position_comp[cmp.csv_file],case,{})
                    dict_add_value(self.all_cmp_position_comp[cmp.csv_file],'average',{})
                    dict_add_value(self.all_cmp_position_comp[cmp.csv_file],'gap',{})
                    dict_add_value(self.all_cmp_position[cmp.csv_file],'average',{})
                    dict_add_value(self.all_cmp_position[cmp.csv_file],'gap',{})
                    try:
                        value  = cmp.csv_dic[case][t]
                        value2 =  float_f_s(value,1)
                        if case not in self.skip_case_list:
                            try:
                                sum = sum + value2
                                num = num + 1
                                all_item_value.append(value2)
                            except:
                                pass
                    except:
                        value2 = '-'
                    if id0 == 0:
                        col = id1 + 1 + len(self.original_title)
                    else:
                        col = id1 + 1 + len(self.original_title)+id0*len(self.original_title[1:])
                    if value.endswith('%'):
                        if id1 == len(self.original_title)-2:
                            self.totalSheet.write(row_case, col, value2,body_style_right_percent)
                        else:
                            self.totalSheet.write(row_case, col, value2,body_style_percent)
                    else:
                        if id1 == len(self.original_title)-2:
                            self.totalSheet.write(row_case, col, value2,body_style_right)
                        else:
                            self.totalSheet.write(row_case, col, value2,body_style)
                    position = excel_col_list[col]+str(row_case+1)
                    dict_add_value(self.all_cmp_position[cmp.csv_file][case],t,position)
                    row_case =  row_case + 1
                    #if id2 == 0 or id2 == len(self.select_group_list)-1:
                    if case in self.skip_case_list:
                        not_used_p.append(position)
                    used_p.append(position)
                if sum != 0:
                    begin = ''
                    end = ''
                    used_fs = []
                    for p1,p in enumerate(used_p):
                        if p not in not_used_p and begin=='':
                            begin = p
                        elif p not in not_used_p and begin!='':
                            end = p
                            if p1 == len(used_p)-1:
                                used_fs.append(begin+":"+end)
                                begin = ''
                        elif p in not_used_p and begin == '':
                            pass
                        elif p in not_used_p and begin != '':
                            end = used_p[p1-1]
                            if begin == end:
                                used_fs.append(begin)
                            else:
                                used_fs.append(begin+":"+end)
                            end = ''
                            begin = ''
                    if begin :
                        used_fs.append(begin)
                    used_fs = ";".join(used_fs)
                    #fs = 'average('+used_p[0]+':'+used_p[1]+')'
                    if not self.no_fmax:
                        try:
                            fs = 'average('+used_fs+')'
                            self.totalSheet.write(row_case, col, Formula(fs),statistic_style)
                        except:
                            try:
                                p_v = float_f_s( float_f_s(sum)/num,1)

                            except:
                                p_v = '-'
                            self.totalSheet.write(row_case, col, p_v,statistic_style)
                        #fs = 'max('+used_p[0]+':'+used_p[1]+')'+'-'+'min('+used_p[0]+':'+used_p[1]+')'
                        try:
                            fs = 'max('+used_fs+')'+'-'+'min('+used_fs+')'
                            self.totalSheet.write(row_case+1, col, Formula(fs),statistic_style)
                        except:
                            self.totalSheet.write(row_case+1, col, max(all_item_value)-min(all_item_value),statistic_style)
                    try:
                        p_v = float_f_s( float_f_s(sum)/num,1)
                    except:
                        p_v = '-'
                    position = excel_col_list[col]+str(row_case+1)
                    dict_add_value(self.all_cmp_position[cmp.csv_file]['average'],t,[position,p_v])
                    #print position

                    position = excel_col_list[col]+str(row_case+1+1)
                    dict_add_value(self.all_cmp_position[cmp.csv_file]['gap'],t,position)

                else:
                    if not self.no_fmax:
                        self.totalSheet.write(row_case, col, '-',statistic_style)
                        self.totalSheet.write(row_case+1, col,'-',statistic_style)
        for id1,cmp in enumerate(self.cmps): #  comp part data

            for id2,t in enumerate(self.comp_title):#first part
                row_case = row
                r_k = red_range_dic.keys()
                r_k_lower = [r.lower() for r in r_k]
                t_lower = t.lower()
                value = ''
                position_for_average_newways=[]
                notused_position_for_average_newways=[]
                value_for_average_newways = []
                if t_lower in r_k_lower:
                    t_index = r_k_lower.index(t_lower)
                    t_r_k = r_k[t_index]
                    red_range = float( red_range_dic[t_r_k ] )
                else:
                    range_value = red_range_dic.get('default','0.05')
                    red_range = float_f_s( range_value )
                for id3,case in enumerate(self.select_group_list):
                    if t=='Slice' and 'LE' in cmp.old_titles:
                        value = '-'
                        self.tie_win[id1][t]['less5_5'] +=  1
                        self.tie_win[id1][t]['tie'] +=  1
                    else:
                        try:
                            value1 = float_f_s(self.src.csv_dic[case][t],1)
                            value2 = float_f_s(cmp.csv_dic[case][t],1)
                            value = float_f_s(value2/value1 -1,1)

                            if value < 0 - win_lose:
                                if t.lower().find('fmax')!= -1:
                                    self.tie_win[id1][t]['lose']  +=  1
                                else:
                                    self.tie_win[id1][t]['win']  += 1

                            elif value > win_lose:
                                if t.lower().find('fmax')!= -1:
                                    self.tie_win[id1][t]['win']  += 1
                                else:
                                    self.tie_win[id1][t]['lose']  +=  1
                            else:
                                self.tie_win[id1][t]['tie'] +=  1
                            if value < 0 - threshold:
                                self.tie_win[id1][t]['less15'] +=  1
                            elif  -threshold<=value<-0.05:
                                self.tie_win[id1][t]['less15_5'] += 1
                            elif  -0.05<=value<0.05:
                                self.tie_win[id1][t]['less5_5'] +=  1
                            elif 0.05<=value <0.15:
                                self.tie_win[id1][t]['more5_15'] +=  1
                            elif value >= threshold:
                                self.tie_win[id1][t]['more15'] +=  1
                            else:
                                pass
                            if t.lower()=='fmax':
                                self.pass_total[id1]['pass'] +=1
                                self.pass_total[id1]['total'] +=1
                        except Exception,e:

                            value = '-'
                            self.tie_win[id1][t]['less5_5'] +=  1
                            self.tie_win[id1][t]['tie'] +=  1
                            if t.lower()=='fmax':
                                #self.pass_total[id1]['pass'] +=1
                                self.pass_total[id1]['total'] +=1
                    col = len(self.original_title) + len(self.cmps)*len(self.original_title[1:])+ \
                          id2+id1*(2*len(self.comp_title))+1
                    if value == '-':
                        #self.totalSheet.write(row_case, col, value,body_style)
                        if id2 == len(self.comp_title)-1:
                            self.totalSheet.write(row_case, col, value,body_style_right)
                        else:
                            self.totalSheet.write(row_case, col, value,body_style)

                    else:
                        formal_string = self.all_cmp_position[cmp.csv_file][case][t] + '/' + self.all_src_posiotion[case][t]+'- 1'
                        #self.totalSheet.write(row_case, col, value,body_style)
                        #self.totalSheet.write(row_case, col, str(value1)+'/'+str(value2)+'-1',body_style)
                        #self.totalSheet.write(row_case, col, Formula(formal_string),body_style_percent)
                        if id2 == len(self.comp_title)-1:
                            if t.lower().find('fmax')!= -1 and value >= red_range:
                                s = body_style_right_green_percent
                            elif t.lower().find('fmax')!= -1 and value < 0 - red_range:
                                s = body_style_right_red_percent
                            elif value >= red_range:
                                s = body_style_right_red_percent
                            elif value < 0- red_range:
                                s = body_style_right_green_percent
                            else:
                                s = body_style_right_percent
                            #av_t = self.real_average.get(t,[0,0,0])[id1] this is the old way
                            av_t = self.real_number.get(t,[0,0,0])[id1]
                            #if value >= useless_value+av_t or value<=av_t-useless_value:  this is the old way
                            if value >= useless_value*av_t or value<=0-useless_value*av_t:
                                if t.lower() in average_skil['use']:
                                    if s == body_style_right_green_percent:
                                        s = body_style_right_green_percent_t
                                    if s == body_style_right_red_percent:
                                        s = body_style_right_red_percent_t
                                else:
                                    pass
                            else:
                                pass

                            self.totalSheet.write(row_case, col, Formula(formal_string),s)
                            #s.pattern.pattern=0x00
                            #s.pattern._pattern_back_colour=0x42
                            #s.pattern._pattern_fore_colour=0x41
                        else:
                            if t.lower().find('fmax')!= -1 and value >= red_range:

                                s = body_style_green_percent
                            elif t.lower().find('fmax')!= -1 and value <0 -  red_range:

                                s = body_style_red_percent
                            elif value >= red_range:
                                s = body_style_red_percent
                            elif value < 0- red_range:
                                s = body_style_green_percent
                            else:
                                s = body_style_percent
                            av_t = self.real_average.get(t,[0,0,0])[id1]
                            av_t = self.real_number.get(t,[0,0,0])[id1]
                            #if value >= useless_value+av_t or value<=av_t-useless_value:  this is the old way
                            if value >= useless_value*av_t or value<=0-useless_value*av_t:
                                #self.skip_case_list +=[case]
                                if t.lower() in average_skil['use']:
                                    if s == body_style_red_percent:
                                        s = body_style_red_percent_t
                                    if s == body_style_green_percent:
                                        s = body_style_green_percent_t
                                else:
                                    pass
                            else:
                                pass
                            self.totalSheet.write(row_case, col, Formula(formal_string),s)


                    s = ''
                    position = excel_col_list[col]+str(row_case+1)
                    dict_add_value(self.all_cmp_position_comp[cmp.csv_file][case],t,position)
                    if value !='-':

                        #value_for_average_newways.append(float_f_s(value))
                        '''try:
                            av_t = self.real_average.get(t,[])[id1]
                        except:
                            av_t = 0
                        if value >= useless_value+av_t or value<=av_t-useless_value:
                            notused_position_for_average_newways.append(position)
                        '''
                        if case in self.skip_case_list:
                            notused_position_for_average_newways.append(position)
                        else:
                            value_for_average_newways.append(float_f_s(value))

                    else:
                        notused_position_for_average_newways.append(position)
                        #position_for_average_newways.append(position)
                    position_for_average_newways.append(position)
                    row_case = row_case + 1
                try:#write the average in the buttom
                    if 1 and (not self.no_fmax): #new_ways
                        begin = ''
                        end = ''
                        used_fs = []
                        for p1,p in enumerate(position_for_average_newways):
                            if p not in notused_position_for_average_newways and begin=='':
                                begin = p
                            elif p not in notused_position_for_average_newways and begin!='':
                                end = p
                                if p1 == len(position_for_average_newways)-1:
                                    used_fs.append(begin+":"+end)
                                    begin = ''
                            elif p in notused_position_for_average_newways and begin == '':
                                pass
                            elif p in notused_position_for_average_newways and begin != '':
                                end = position_for_average_newways[p1-1]
                                if begin == end:
                                    used_fs.append(begin)
                                else:
                                    used_fs.append(begin+":"+end)
                                end = ''
                                begin = ''
                        if begin :
                            used_fs.append(begin)
                        used_fs = ";".join(used_fs)
                        #fs = 'average('+used_p[0]+':'+used_p[1]+')'
                        fs = 'average('+used_fs+')'
                        f_content = Formula(fs)
                        try:
                            sum_1 = 0
                            num_1 = 0
                            for v in value_for_average_newways:
                                sum_1 = sum_1 + v
                                num_1 = num_1 + 1
                            fs_v = sum_1/num_1
                        except Exception,e:
                            f_content = '-'
                            fs_v = '-'
                        if t =='Slice' and 'LE' in cmp.old_titles:
                           f_content = '-'
                        if id2 == len(self.comp_title)-1:
                            self.totalSheet.write(row_case, col, f_content,statistic_percent)
                        else:
                            self.totalSheet.write(row_case, col, f_content,statistic_percent)
                        position = excel_col_list[col]+str(row_case+1)
                        #------------------ New ways write gap -------------------------#
                        if 1:
                            fs = 'max('+used_fs+')-' + 'min('+used_fs+')'
                            f_content = Formula(fs)
                            if value_for_average_newways:
                                max_v = max(value_for_average_newways)
                                min_v = min(value_for_average_newways)
                            else:
                                max_v = '-'
                                min_v = '-'
                            if t =='Slice' and 'LE' in cmp.old_titles:
                               f_content = '-'
                            if id2 == len(self.comp_title)-1:
                                self.totalSheet.write(row_case+1, col, f_content,statistic_percent)
                            else:
                                self.totalSheet.write(row_case+1, col, f_content,statistic_percent)
                            #if id2 == len(self.comp_title)-1:
                            #    self.totalSheet.write(row_case, col+1, f_content,statistic_percent)
                            #else:
                            #    self.totalSheet.write(row_case, col+1, f_content,statistic_percent)
                            #position = excel_col_list[col]+str(row_case+1+1)
                            #dict_add_value(self.all_cmp_position_comp[cmp.csv_file]['gap'],
                            #                t,[position,fs_v,max_v,min_v])
                        dict_add_value(self.all_cmp_position_comp[cmp.csv_file]['average'],t,[position,fs_v,sum_1,num_1,max_v,min_v])


                    # ------------------ The old ways write average --------------------#
                    if 0:
                        p1 = self.all_src_posiotion['average'][t][0]
                        p2 = self.all_cmp_position[cmp.csv_file]['average'][t][0]
                        f_s = p2+'/'+p1+'-1'
                        f_content = Formula(f_s)
                        #-----------The fllow process the formula if the formula is error
                        try:
                            p1_v = self.all_src_posiotion['average'][t][1]
                            p2_v = self.all_cmp_position[cmp.csv_file]['average'][t][1]
                            fs_v = p2_v/p1_v -1
                        except:
                            f_content = '-'
                        #------------------------------
                        if t =='Slice' and 'LE' in cmp.old_titles:
                           f_content = '-'
                        if id2 == len(self.comp_title)-1:
                            self.totalSheet.write(row_case, col, f_content,statistic_percent)
                        else:
                            self.totalSheet.write(row_case, col, f_content,statistic_percent)
                        position = excel_col_list[col]+str(row_case+1)
                        try:
                            p_v = self.all_cmp_position[cmp.csv_file]['average'][t][1]/ self.all_src_posiotion['average'][t][1] -1
                        except:
                            p_v = '-'
                        dict_add_value(self.all_cmp_position_comp[cmp.csv_file]['average'],t,[position,p_v])
                    if 0: # the old ways write gap
                        #---------------------Write Gap ----------------------------#

                        p1 = self.all_src_posiotion['gap'][t]
                        p2 = self.all_cmp_position[cmp.csv_file]['gap'][t]
                        f_s = p2+'/'+p1+'-1'
                        #self.totalSheet.write(row_case+1, col, Formula(f_s),body_style_percent)
                        f_content = Formula(f_s)
                        #-----------The fllow process the formula if the formula is error
                        try:
                            p1_v = self.all_src_posiotion['gap'][t][1]
                            p2_v = self.all_cmp_position[cmp.csv_file]['gap'][t][1]
                            fs_v = p2_v/p1_v -1
                        except:
                            f_content = '-'
                        #------------------------------
                        if t =='Slice' and 'LE' in cmp.old_titles:
                           f_content = '-'
                        if id2 == len(self.comp_title)-1:
                            self.totalSheet.write(row_case+1, col, f_content,statistic_percent)
                        else:
                            self.totalSheet.write(row_case+1, col, f_content,statistic_percent)
                        position = excel_col_list[col]+str(row_case+1+1)
                        #dict_add_value(self.all_cmp_position_comp[cmp.csv_file]['average'],t,position)# this may be wrong
                        dict_add_value(self.all_cmp_position_comp[cmp.csv_file]['gap'],t,position)
                except Exception,e:
                    if id2 == len(self.comp_title)-1:
                        self.totalSheet.write(row_case, col, '-',statistic_percent)
                        self.totalSheet.write(row_case+1, col, '-',statistic_percent)
                    else:
                        self.totalSheet.write(row_case, col, '-',statistic_percent)
                        self.totalSheet.write(row_case+1, col, '-',statistic_percent)
            for id2,t in enumerate(self.comp_title):#second part(_average)
                if self.no_fmax:
                    break
                row_case = row
                for id3,case in enumerate(self.select_group_list):
                    col = len(self.original_title) + len(self.cmps)*len(self.original_title[1:])+ \
                          id2+id1*(2*len(self.comp_title))+1+len(self.comp_title)

                    try:
                        p1 = self.all_cmp_position_comp[cmp.csv_file][case][t]

                        p2 = self.all_cmp_position_comp[cmp.csv_file]['average'][t][0]
                        f_s = p1 + '-'+p2
                        #print f_s
                        f_s = Formula(f_s)
                        #---------------------
                        ''' more easily way to check:
                            if case in self.skip_case_list:
                                f_s = '-'
                        '''
                        try:
                            value1 = float_f_s(self.src.csv_dic[case][t],1)

                            value2 = float_f_s(cmp.csv_dic[case][t],1)

                            value = float_f_s(value2/value1 -1)


                        except:
                            f_s = '-'
                        if self.all_cmp_position_comp[cmp.csv_file]['average'][t][1] == '-':
                            f_s = '-'
                        #--------------------------
                        #self.totalSheet.write(row_case, col, Formula(f_s),body_style_percent)
                        if id2 == len(self.comp_title)-1:
                            self.totalSheet.write(row_case, col, f_s,body_style_right_percent)
                        else:
                            self.totalSheet.write(row_case, col, f_s,body_style_percent)
                        #self.totalSheet.write(row_case+1, col, '-',body_style_percent)
                    except Exception,e:
                        #self.totalSheet.write(row_case, col, '-',body_style_percent)
                        if id2 == len(self.comp_title)-1:
                            self.totalSheet.write(row_case, col, '-',body_style_right_percent)
                        else:
                            self.totalSheet.write(row_case, col, '-',body_style_percent)
                    row_case = row_case + 1
                col = len(self.original_title) + len(self.cmps)*len(self.original_title[1:])+ \
                          id2+id1*(2*len(self.comp_title))+1+len(self.comp_title)
                if id2 == len(self.comp_title)-1:
                    self.totalSheet.write(row_case, col, '-',statistic_percent)
                    self.totalSheet.write(row_case+1, col, '-',statistic_percent)
                else:
                    self.totalSheet.write(row_case, col, '-',statistic_percent)
                    self.totalSheet.write(row_case+1, col, '-',statistic_percent)

        #for id1,t in

        return row+len(self.select_group_list)+3+1

    def write_win_tie(self,row):
        body_style = style(lineStyle='2222')
        body_style = body_style.createStyle()
        self.totalSheet.write(row, 0, 'Summary',body_style)
        #for id1,t in enumerate(self.original_title): #src data
        #    self.totalSheet.write(row, id1+1, '',body_style)
        #for i,value in enumerate(['win','tie','lose','less15','less15~5','less5~5','more5_15','more15']):
        for i,value in enumerate(['win','tie','lose','change < -15%','-15%< change < -5%','-5%< change < +5%','+5%< change < +15%','+15% < change']):
            col = len(self.original_title)+len(self.cmps)*len(self.original_title[1:])
            if i >2:
                i = i + 1
            if i <3:
                self.totalSheet.write(row+i, col, value,body_style)
            else:
                self.totalSheet.write_merge(row+i,row+i, col-1,col, value,body_style)
        for id2,cmp in enumerate(self.cmps):
            #for id1,t in enumerate(self.original_title): #cmp data
            #    col = len(self.original_title)+id2*len(self.original_title[1:])+id1+1
            #    print col
            #    self.totalSheet.write(row, col, '',body_style)
            for id1,t in enumerate(self.comp_title):

                col = len(self.original_title)+len(self.cmps)*len(self.original_title[1:])+ \
                      id2*2*len(self.comp_title)+id1 + 1
                value = self.tie_win[id2][t]['win']
                self.totalSheet.write(row, col, value,body_style)
                value = self.tie_win[id2][t]['tie']
                self.totalSheet.write(row+1, col, value,body_style)
                value = self.tie_win[id2][t]['lose']
                self.totalSheet.write(row+2, col, value,body_style)

                value = self.tie_win[id2][t]['less15']
                self.totalSheet.write(row+4, col, value,body_style)
                value = self.tie_win[id2][t]['less15_5']
                self.totalSheet.write(row+5, col, value,body_style)
                value = self.tie_win[id2][t]['less5_5']
                self.totalSheet.write(row+6, col, value,body_style)
                value = self.tie_win[id2][t]['more5_15']
                self.totalSheet.write(row+7, col, value,body_style)
                value = self.tie_win[id2][t]['more15']
                self.totalSheet.write(row+8, col, value,body_style)
        return row+8
    def return_dict(self):
        for id1,cmp in enumerate(self.cmps):
            if id1 != 0:
                break
            #self.for_total_return[self.basename][id1] = []
            self.for_total_return[self.basename].append(self.tie_win[id1])
            self.for_total_return[self.basename].append(self.all_cmp_position_comp[cmp.csv_file]['average'])
            others = [
                self.pass_total[id1]
                ]
            self.for_total_return[self.basename].append(others)
        return self.for_total_return


    def write_all(self):
        row = self.write_note()
        row = self.write_file_name(row)
        row = self.write_title(row)
        row = self.write_body(row)
        if not self.no_fmax:
            row = self.write_win_tie(row)
        # return_dict = self.return_dict()
        #self.write_total_summay(summary=return_dict) # this two lines used for qor
        self.write_note_Note(row)
        return self.return_dict()

    def write_note_Note(self,row):

        #print self.src_dict_note_dict
        #print self.cmp_dict_note_dict
        #print '-------------------'
        row = row+2
        all_cases =[]
        all_cases += self.src_dict_note_dict.keys()
        for item in self.cmp_dict_note_dict:
            all_cases +=item.keys()
        all_cases = list( set(all_cases))
        all_cases.sort()
        try:
            all_cases.remove('')
        except:
            pass
        col=1
        bold_black = style(lineStyle='8888')
        bold_black = bold_black.createStyle()
        bold_title = style(lineStyle='8888',cellFontIsBold=True)
        bold_title = bold_title.createStyle()
        self.totalSheet.write(row-1, col, 'Note Info')
        self.totalSheet.write(row, col, 'CASE NAME',bold_title)
        self.totalSheet.write_merge(row,row, col+1,col+3, os.path.basename(self.src.csv_file),bold_title)
        for id1,i in enumerate(self.cmp_dict_note_dict):
            self.totalSheet.write_merge(row,row, col+3+id1*3+1,col+3+(id1+1)*3, os.path.basename(self.cmps[id1].csv_file),bold_title)
        for id1,case in enumerate(all_cases):
            self.totalSheet.write(row+id1+1, col, case,bold_title)
            self.totalSheet.write_merge(row+id1+1,row+id1+1, col+1,col+3, ",".join(self.src_dict_note_dict.get(case,'NA')),bold_black)
            for id2,item in enumerate(self.cmp_dict_note_dict):
                self.totalSheet.write_merge(row+id1+1,row+id1+1, col+3+id2*3+1,col+3+(id2+1)*3, ",".join(item.get(case,'NA')),bold_black)

        #self.totalSheet.write(row-1, col, value1)

def write_total_summay(statistic='',line='',summary={}): #only for QoR
        #------------------- summary structrue -----------------------#
        # {sheetname:[{tilte(slice):{  key(less15_5):value(1)},  },{title(slice):value(0.0%)}]}

        #--------------------------------------------------------------#
        style_class_percent = style(lineStyle='2222',myFormat='0.00%')
        statistic_percent = style_class_percent.createStyle()

        bold_title = style(lineStyle='2222',cellFontIsBold=True)
        bold_title = bold_title.createStyle()

        bold_black = style(lineStyle='4444',cellFontIsBold=True)
        bold_black = bold_black.createStyle()

        bold_title_link = style(lineStyle='2222',cellFontIsBold=True,cellFontColour='blue')
        bold_title_link = bold_title_link.createStyle()
        #-----------------------del win tie lose in the summary -------------------
        #statistic_tie_list = statistic_tie_list[3:]
        #----------------------------------------
        if not line:
            line = 25
        col = 1+3
        priority=  ['snow', 'sapphire','xo3l','xo2','ecp3','xo','xp2','ecp2','sc']
        priority_data = {}  #{key(xo2):[sheetnames,], }
        for sheet_f in summary.keys():
            try:
                f  = sheet_f.split('_')[1]  # the sheet should be "**_**_"
            except:
                f = sheet_f
            f = f.lower()
            if f in priority:
                priority_data.setdefault(f,[]).append(sheet_f)
            else:
                priority_data.setdefault('sc',[]).append(sheet_f)
        for p_id,item in enumerate(priority):
            col = 1+3
            id4 = 0
            sheets = priority_data.get(item,'')
            if sheets:
                pass
            else:
                continue
            sheets.sort()
            sheet_percent_titles = []
            for s in sheets:
                sheet_percent_titles = sheet_percent_titles + (summary[s][1]).keys()
            sheet_percent_titles.sort()
            sheet_percent_titles = set(sheet_percent_titles)  # get all the titles
            sheet_percent_titles = list(sheet_percent_titles)
            sheet_percent_titles_lower = [s_lower.lower() for s_lower in sheet_percent_titles ]
            statistic.write(line-1,col-2,item,bold_black) # print priority
            statistic.write(line-1,col-3,'Priority'+str(p_id),bold_black)
            for id1,s in enumerate(sheets):
                for_link = s.split('_')
                for_link = for_link[:2]
                for_link = '_'.join(for_link)
                #statistic.write(line,col+id1,for_link[3:],bold_title_link) # print link
                statistic.write(line,col+id1,s,bold_title_link)
                #sheets_name = "#'"+ os.path.splitext(s)[0] +"'!"+"A3"
                sheets_name = "#'"+ s +"'!"+"A3"
                statistic.set_link(line,col+id1,sheets_name,description=s)
            statistic.write(line,col+id1+1,'Average',bold_title_link)
            statistic.write(line,col+id1+1+1,'Variation ',bold_title_link)  #voc: variation  of change
            id1 = 0
            id3 = 0 # this two lines should be infornt
            #for id1,key in enumerate( sheet_percent_titles ): #key_order
            for key in key_order:
                key = key.lower()
                #print key,sheet_percent_titles_lower
                if key == 'mappeakmem':
                    continue
                if key in sheet_percent_titles_lower:
                    index = sheet_percent_titles_lower.index(key)
                    key   = sheet_percent_titles[index]
                    pass
                else:
                    continue
                statistic.write(line+id1+ 1,col-1,key,bold_title)
                all_form_sumary = 0
                all_form_num = 0
                all_gap_data = []
                for id2,s in enumerate(sheets):
                    try:

                        #print summary[s][1][key]
                        #print sheet_percent_titles
                        # this is the old way(2013/10/14)

                        try:
                            data_wr = summary[s][1][key][1]
                        except:
                            data_wr = '-'
                        sheets_name = "#'"+os.path.splitext(s)[0] +"'!"+summary[s][1][key][0]
                        #print data_wr
                        #data_wr = Formula(sheets_name)
                        statistic.write(line+id1+ 1,col+id2,data_wr,statistic_percent)
                        statistic.set_link(line+id1+ 1,col+id2,sheets_name,description=s)
                        #print sheets_name
                        all_form_sumary = all_form_sumary + summary[s][1][key][2]
                        all_form_num = all_form_num + summary[s][1][key][3]
                        all_gap_data.append(summary[s][1][key][4])
                        all_gap_data.append(summary[s][1][key][5])
                        #print summary[s][1][key][2]
                        #print summary[s][1][key][3]
                        #statistic.set_link(line,col,sheets_name,description=s)
                    except :

                        data_wr = '-'
                        statistic.write(line+id1+ 1,col+id2,data_wr,statistic_percent)
                    id3 = id2
                try:
                    a_a_all = all_form_sumary/all_form_num

                except:
                    a_a_all = '-'
                try:
                    a_a_gap = max(all_gap_data)- min(all_gap_data)
                except:
                    a_a_gap = '-'
                statistic.write(line+id1+ 1,col+id2+1,a_a_all,statistic_percent)
                statistic.write(line+id1+ 1,col+id2+1+1,a_a_gap,statistic_percent)
                id1 = id1 + 1

            # ------------------------The Second Part --------------------------#
            initial_col = col
            col =  col + id3 + 4
            line = line
            sheet_row_titles = []
            for s in sheets:
                sheet_row_titles = sheet_row_titles + (summary[s][0]).keys()
            sheet_row_titles.sort()  # this is the row title
            sheet_row_titles = set(sheet_row_titles)
            sheet_row_titles_data = {} # {{slice:{less15:1,more:23,...}},}
            for row_title in sheet_row_titles:
                sheet_row_titles_data[row_title]={}
                abs = {}
                abs2 = {}
                for s in sheets:
                    s_abs = (summary[s][0]).get(row_title,{} ) #s_abs will be: {less15:1,more:23,...}
                    if not s_abs:
                        continue
                    else:
                        for col_key in s_abs.keys():
                            abs.setdefault(col_key,[]).append(s_abs[col_key])
                for col_key in abs.keys():
                    col_value = sum(abs[col_key])
                    abs2.setdefault(col_key,col_value)
                sheet_row_titles_data[row_title] = abs2
            id1 = 0
            id4 = 0
            id2 = 0
            #for id1,row_title in enumerate(sheet_row_titles):  # key_order
            total_num_p = 0
            totla_pass_p = 0
            for s in sheets:

                for ss in summary[s][2] :
                    for ss_k in ss.keys():
                        if ss_k == 'pass':
                            totla_pass_p += ss.get(ss_k,0)
                        if ss_k == 'total':
                            total_num_p += ss.get(ss_k,0)
                #raw_input(11)
            next_col = col
            statistic.write(line,initial_col-3,'Pass/Total',bold_black)
            statistic.write(line,initial_col-2,str(totla_pass_p)+'/'+str(str(total_num_p)),bold_black)
            for row_title in key_order:
                row_title = row_title.lower()
                if row_title == 'mappeakmem':
                    continue
                row_title = row_title.lower()

                if row_title in sheet_percent_titles_lower:
                    index = sheet_percent_titles_lower.index(row_title)
                    row_title   = sheet_percent_titles[index]
                    pass
                else:
                    continue
                statistic.write(line,col+id1+1,row_title,bold_title)  # the row title
                if id1 == 0:  # write the col title
                    id3 = 0
                    for id2,s_t in enumerate(statistic_tie_list[3:]):
                        s_t_2 = s_t[1]

                        statistic.write(line+1+id2+id3,col,s_t_2,bold_title)  # the col title  id3: for the empty row between lose and **5
                        if s_t_2.lower() == 'lose':
                            id3 = 1
                id3 = 0
                for id2,s_t in enumerate(statistic_tie_list[3:]):
                    statistic.write(line+1+id2+id3,col+id1+1,sheet_row_titles_data[row_title][s_t[0]],bold_title)
                    if (s_t[1]).lower() == 'lose':
                        id3 = 1
                    id4 = id2
                id1 = id1 + 1
            line = line + len(key_order) + 5

        #---------------------The Thrid Part-----------------------#
        #line = line+4+id4
        all_data = {}
        for sheet_f in summary.keys():
            sheet_f_first = summary[sheet_f][0]
            #print sheet_f_first
            for sheet_f_first_key in sheet_f_first.keys():
                if sheet_f_first_key in all_data.keys():
                    pass
                else:
                    all_data[sheet_f_first_key] = {}
                temp=all_data[sheet_f_first_key]
                for less_more_key in sheet_f_first[sheet_f_first_key]:
                    #temp=all_data[sheet_f_first_key]
                    temp.setdefault(less_more_key,[]).append( sheet_f_first[sheet_f_first_key][less_more_key] )
                all_data[sheet_f_first_key] = temp

        row_title_keys = all_data.keys()
        row_title_keys_lower = [item.lower() for item in row_title_keys]
        id1 = 0
        id4 = 0
        col = 1
        #for id1,row_title in enumerate(row_title_keys):  # key_order
        for row_title in key_order:

            row_title = row_title.lower()
            if row_title == 'mappeakmem':
                    continue
            if row_title in row_title_keys_lower:
                index = row_title_keys_lower.index(row_title)
                row_title   = row_title_keys[index]

            else:
                continue
            statistic.write(line,col+id1+1,row_title,bold_title)  # the row title
            if id1 == 0:  # write the col title
                id3 = 0
                for id2,s_t in enumerate(statistic_tie_list[3:]):
                    s_t_2 = s_t[1]

                    statistic.write(line+1+id2+id3,col,s_t_2,bold_title)  # the col title  id3: for the empty row between lose and **5
                    if s_t_2.lower() == 'lose':
                        id3 = 1
            id3 = 0
            for id2,s_t in enumerate(statistic_tie_list[3:]):
                statistic.write(line+1+id2+id3,col+id1+1,sum(all_data[row_title][s_t[0]]) ,bold_title)
                if (s_t[1]).lower() == 'lose':
                    id3 = 1
            id1 = id1 + 1


def option():
    p=optparse.OptionParser()
    p.add_option("-s","--src",action="store",type="string",dest="src",help="The first file you want to compare")
    p.add_option("-c","--cmp",action="store",type="string",dest="cmp",help="The second file you want to compare")
    p.add_option("-o","--output",action="store",type="string",dest="output",help="The output file you want to compare")
    p.add_option("-t","--comp_title",action="store",type="string",dest="comp_title",help="The title you want to compare")
    p.add_option("-r","--original_title",action="store",type="string",dest="original_title",help="The original title you want to see")
    public_group.add_option("--name-list", action="store_true", help="specify the list name in the case_list.conf, this used for write sorted report")
    opt,args=p.parse_args()
    return opt

def run():
    wb = Workbook()
    opt = option()
    src_csv = opt.src
    cmp_csvs = opt.cmp
    compare_title = opt.comp_title
    original_title = opt.original_title
    output = opt.output
    name_list = opt.name_list
    cmp_csvs = cmp_csvs.split(',')
    cmp_csvs = list(set(cmp_csvs))
    src_csv_content = write_csv_class.csv_content(src_csv)
    cmp_csv_contents = []
    title_dic = get_conf_options(param_conf_file)
    compare_title = title_dic['Comp_Title'][compare_title]
    compare_title = compare_title.split(',')
    compare_title= [item.strip() for item in compare_title]
    original_title = title_dic['Original_Title'][original_title]
    original_title = original_title.split(',')
    original_title= [item.strip() for item in original_title]
    for cmp in cmp_csvs:
        if os.path.isfile(cmp):
            cmp_csv_contents.append( write_csv_class.csv_content(cmp) )
    write_excel_o = write_excel(src_csv_content,cmp_csv_contents,output,compare_title,original_title,'',wb,name_list=name_list)
    write_excel_o.write_all()
    name = r'test'+'.xls'
    wb.save(name)
def run_web(src,cmp,comp_title,original_title,output):
    #opt = option()
    wb = Workbook()
    src_csv = src
    cmp_csvs = cmp
    compare_title = comp_title
    original_title = original_title
    output = output
    cmp_csvs = cmp_csvs.split(',')
    src_csv_content = write_csv_class.csv_content(src_csv)
    cmp_csv_contents = []
    title_dic = get_conf_options(param_conf_file)
    if compare_title.find('l25')!= -1:
        compare_title = title_dic['Comp_Title'][compare_title]
        compare_title = compare_title.split(',')
        compare_title= [item.strip() for item in compare_title]
    else:
        compare_title = compare_title.split(',')
    if original_title.find('Design')!= -1:
        original_title = original_title.split(',')

    else:
        original_title = title_dic['Original_Title'][original_title]
        original_title = original_title.split(',')
        original_title= [item.strip() for item in original_title]
    for cmp in cmp_csvs:
        if os.path.isfile(cmp):
            cmp_csv_contents.append( write_csv_class.csv_content(cmp) )
    write_excel_o = write_excel(src_csv_content,cmp_csv_contents,output,compare_title,original_title,'',wb)

    write_excel_o.write_all()
    name = os.path.splitext(output)[0]+'.xls'
    wb.save(name)
def forQoR(line,wb,param_conf=''):
    src_csv = write_csv_class.get_cmd_value(line,'src')
    cmp_csvs = write_csv_class.get_cmd_value(line,'cmp')
    compare_title = write_csv_class.get_cmd_value(line,'Comp_Title')
    original_title = write_csv_class.get_cmd_value(line,'Original_Title')
    output = write_csv_class.get_cmd_value(line,'output')
    no_fmax = write_csv_class.get_cmd_value(line,'no-fmax')
    cmp_csvs = cmp_csvs.replace('"','')
    cmp_csvs = cmp_csvs.split(',')
    cmp_csvs = list(set(cmp_csvs))
    src_csv_content = write_csv_class.csv_content(src_csv,no_fmax)
    cmp_csv_contents = []
    param_conf_file = os.path.join(os.path.dirname(__file__),'param.conf')
    if param_conf:
        if os.path.isfile(param_conf):
            param_conf_file = param_conf
        else:
            print 'Error, can not find file:%s\n\n'%param_conf
            sys.exit(-1)
    title_dic = get_conf_options(param_conf_file)
    compare_title = title_dic['Comp_Title'][compare_title]
    compare_title = compare_title.split(',')
    compare_title= [item.strip() for item in compare_title]
    original_title = title_dic['Original_Title'][original_title]
    original_title = original_title.split(',')
    original_title= [item.strip() for item in original_title]
    for cmp in cmp_csvs:
        if os.path.isfile(cmp):
            cmp_csv_contents.append( write_csv_class.csv_content(cmp,no_fmax) )
        else:
            print 'Error: can get file: %s'%cmp
            #raw_input()
    write_excel_o = write_excel(src_csv_content,cmp_csv_contents,output,compare_title,original_title,'',wb,no_fmax=no_fmax)
    return write_excel_o.write_all()
    #write_total_summay
if __name__ == '__main__':
    run()