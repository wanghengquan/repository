#! C:\Python25\python.exe
#coding:utf-8
#===================================================
# Owner    : Yzhao1
# Function :
#           This file used to compare the data in the  csv files
# Attention:
#           compare any data which can translate to float_f

# Date     :2013/4/15

#===================================================
import os,sys,csv
import re,ConfigParser
import optparse
import traceback

xlib = os.path.join(os.path.dirname(__file__),'..','..','bin','xlib')
xlib = os.path.abspath(xlib)
if xlib in sys.path:
    pass
else:
    sys.path.append(xlib)
from xConf import get_conf_options
case_list_path =  os.path.join(__file__,'..','..','..','conf','case_list.conf')
case_list_path = os.path.abspath(case_list_path)
case_group_dic = get_conf_options(case_list_path)['case_list']
param_conf_file = os.path.join(os.path.dirname(__file__),'param.conf')
group_cases= {}
for group,cases in case_group_dic.items():
    cases = cases.split()
    for item in cases:
        group_cases.setdefault(group,[]).append(item)
all_groups = group_cases.keys()
threshold = 0.15
win_lose = 0.05
statistic_tie_list = [['win','win'],
        ['tie','tie'],
        ['lose','lose'],
        ['less15','<-0.15'],
        ['less15_5','-0.15~-0.05'],
        ['less5_5','-0.05~-0.05'],
        ['more5_15','0.05~-0.15'],
        ['more15','>0.15']]

def print_log(str):
    print str
def read_csv_note(csv_file):
    ''' This function used to read the data from csv file
        At here the csv file should can contain note  before case data
        
        After the note lines should be the title as "Design,.....":
            asdfasfasdfasdfasdfas     |
            fd                        |  
            df                        |
            ffea                      |   these are the note lines
            Desing,Lut.......
            case1,data1,.....
            ......
        the return data is a dictionary
        dict[desing] = line1
    '''
    csv_dic = {}
    note= []
    begin = 0
    hot_lines = []
    old_titles = []
    for id1,line in enumerate(open(csv_file)):
            line = line.strip()
            if begin == 0:
                if line.startswith('Design') or line.startswith('design'):
                    begin = 1
                    line = line.replace('#','')
                    old_titles = line.split(',')
                    #line2 = line.replace('LE','Slice')
                    line2 = line.replace('FitPeakMem','ParPeakMem')
                    hot_lines.append(line2)
                    continue
                else:
                    note.append(line)
            else:
                line = line.replace('#','')
                hot_lines.append(line) 
    ori_dict = csv.DictReader(hot_lines)
    '''for item in ori_dict:
        design = item.get('Design','None')
        if design != 'None' and design != '':
            csv_dic[design] = item
        else:
            pass
        #print item
    title = ori_dict.fieldnames '''
    return [ori_dict,note,old_titles]
def process_note(note=[]):
        '''
        This function used to process of the note from csv file.
        the note in the csv file will be read as:
                [key1]:******************
                       ***************
                [key2]:***********
                ...
        After the process, this function will return a dictionary as:
        dict = {key1: ********,
                key2:*********,
                ....}
        '''
        dict_retrun  = {}
        flag = 0
        note_key = re.compile(r'^\[([\w\s]+)\]')
        key = 'None'
        for line in note:
            line = line.strip()
            match_line = ''
            match_line  = note_key.search(line)
            if match_line:
               flag = 1
            else:
               flag  = 0
            if flag == 1:
                key =  match_line.group(1)
                start = match_line.start()
                end = match_line.end()
                value = ''
                for i in range(0,start):
                    #dict_retrun[key] = 
                    value = value+ line[i]
                for i in range(end,len(line)):
                    value = value + line[i]
                value = value.replace(',',' ')
                value =value.strip()
                if value:
                    dict_retrun.setdefault(key,[]).append(value.strip())
            else:
                line = line.replace(',',' ')
                line = line.strip()
                if dict_retrun:
                    if line: 
                        dict_retrun.setdefault(key,[]).append(line.strip())
                else:
                    if line:
                        dict_retrun.setdefault('None',[]).append(line.strip())
        return dict_retrun
def float_f(string):
    string = str(string)
    try:
        f_v =  float(string)
        f_v = float("%.3f"%f_v)
        return f_v
    except:
        return '-'

class csv_content:
    def __init__(self,csv_file,no_fmax=""):
        self.csv_file = csv_file
        if not os.path.isfile(self.csv_file):
            print 'Error can not get file:%s \n\n\n\n'%self.csv_file
            sys.exit(-1)
        self.ori_dict,note_list,self.old_titles = read_csv_note(self.csv_file)
        self.note = process_note(note_list)
        self.csv_dic = {}
        re_lettter = re.compile(r'[a-zA-Z]')
        re_num = re.compile(r'\d')
        self.skip_case = []
        self.alut_lut = ''
        self.no_fmax = no_fmax
        for item in self.ori_dict:
            design = item.get('Design','None')
            if design != 'None' and design != '':
                self.csv_dic[design] = item
            else:
                pass
        #---------------------------------------#
        # at here, if the fmax value is not true,
        # all the other value will be ingored
        #--------------------------------------#
        for case,dic in self.csv_dic.items():
            if 'fmax' in dic.keys():
                fmax_value = dic.get('fmax','')
            else:
                fmax_value = dic.get('Fmax','')
            if not self.no_fmax:
                if not fmax_value or fmax_value=='-' or fmax_value=='_' or re_lettter.search(fmax_value):
                    self.skip_case.append(case)
                    for k in self.csv_dic[case].keys():
                        v = self.csv_dic[case][k]
                        try:
                            if re_lettter.search(v):
                                #print case,k,v
                                pass
                            else:
                                if k.lower() == 'design':
                                    pass
                                else:
                                    self.csv_dic[case][k] = '-'
                        except:
                            self.csv_dic[case][k] = '-'
        #-----------------------------------#
        # at here, for the data of LUT and ALUT
        # if ALUT has value, use the ALUT value 
        # repalce LUT value
        #------------------------------------#
        for case,dic in self.csv_dic.items():
            if 'ALUT' in dic.keys() and 'LUT' in dic.keys():
                alut_value = dic.get('ALUT','')
                lut_value = dic.get('LUT','')
                if alut_value and re_num.search(alut_value):
                    self.csv_dic[case]['LUT'] = alut_value
                    self.alut_lut = 1
            if 'LE' in  dic.keys():
                v = self.csv_dic[case].get('LE','-')
                self.csv_dic[case]['Slice'] = v
        self.title = self.ori_dict.fieldnames
        self.average_dict =  {}
        self.gap_dict = {}
        for t in self.title:
            self.average_dict[t] = []
            self.gap_dict[t]= []
    def set_average_gap(self,skip_case_list):
        average_dict_v = {}
        gap_dict_v = {}
        for case,case_dict in self.csv_dic.items():
            if case in skip_case_list:
                continue
            for id1,t in enumerate(self.title):
                value = case_dict[t]
                value_f = float_f(value)
                t = self.old_titles[id1] # use the old title here 
                average_dict_v.setdefault(t,[]).append(value_f)
                gap_dict_v.setdefault(t,[]).append(value_f)
        
        for t in self.old_titles:
            total_value = 0
            length = 0
            for v in average_dict_v.get(t,[]):
                try:
                    total_value = total_value + v
                    length = length  + 1
                except:
                    pass
            try:
                #print total_value,length
                self.average_dict[t] = str(total_value/length)
            except:
                self.average_dict[t] = '-'
            try:
                gap_dict_v[t] = list( set(gap_dict_v[t]) )
                if '-' in gap_dict_v[t]:
                    gap_dict_v[t].remove('-')
                self.gap_dict[t] = str(max(gap_dict_v[t]) - min(gap_dict_v[t]))
            except:
                self.gap_dict[t] = '-'
    def get_average_gap(self):
        return [self.average_dict,self.gap_dict]
                
                    
                
class write_csv:
    def __init__(self,src,cmps,output,comp_title,original_title,show_design,no_fmax=""):
        self.src = src          
        self.cmps = cmps
        self.output = output
        self.comp_title = comp_title
        self.original_title = original_title
        self.show_design = show_design
        self.skip_case_list = []
        self.lines = {}
        self.note_line = []
        self.tie_win = {}
        self.select_group_list = []
        self.file_name_line = ''
        self.average_newways={}
        self.no_fmax = no_fmax
        for num,cmp in enumerate(self.cmps):
            self.tie_win[num] = {}
            self.skip_case_list +=cmp.skip_case
            self.average_newways[num]={}
        self.skip_case_list +=self.src.skip_case
        key = self.src.csv_dic.keys()[0]
        for group in all_groups:
                group_list = group_cases[group]
                if key in group_list:
                    self.select_group_list = group_list
                    first_case = 1
                    break
        if not self.select_group_list:
            self.select_group_list = self.src.csv_dic.keys()
        
    def original_part(self):
        average_line = []
        gap_line = []
        if self.original_title[0].lower()!='design':
            print 'Please make sure the first number is "Design" :%s'%self.original_title
            return 1 
        self.original_part_title = self.original_title
        if self.src.alut_lut:
            self.original_part_title = [t.replace('LUT','ALUT') for t in self.original_title]
        if 'LE' in self.src.old_titles:
            self.original_part_title = [t.replace('Slice','LE') for t in self.original_part_title]
        if 'FitPeakMem'in self.src.old_titles: 
            self.original_part_title = [t.replace('ParPeakMem','FitPeakMem') for t in self.original_part_title]
        for id1,item in enumerate(self.cmps):
            replace_t = []
            if 'LE' in item.old_titles:
                replace_t = [t.replace('Slice','LE') for t in self.original_title]
            if 'FitPeakMem'in item.old_titles: 
                replace_t = [t.replace('ParPeakMem','FitPeakMem') for t in replace_t]
            if not replace_t:
                replace_t = [ t for t in self.original_title]
            if item.alut_lut:
                replace_t = [t.replace('LUT','ALUT') for t in replace_t]
            use = ["#"*(id1+1)+t for t in replace_t[1:] ]
            self.original_part_title = self.original_part_title + use
        for id1,case in enumerate(self.select_group_list):
            for t in self.original_title:
                try:
                    value  = self.src.csv_dic[case][t]
                except:
                    value = '-'
                self.lines.setdefault(id1+1,[]).append(value)
           
            for cmp in self.cmps:
                for t in self.original_title[1:]:
                    try:
                        value  = cmp.csv_dic[case][t]
                    except:
                        value = '-'
                    self.lines.setdefault(id1+1,[]).append(value)
        self.skip_case_list = self.src.skip_case 
        for cmp in self.cmps:
            self.skip_case_list += cmp.skip_case
        self.skip_case_list = list( set(self.skip_case_list) )
        self.src.set_average_gap(self.skip_case_list)
        src_average_dict,src_gap_dict = self.src.get_average_gap()
        for t in self.original_title:
            if t == 'Slice' and 'LE' in self.src.old_titles:
                t = 'LE'
            if t == 'ParPeakMem' and 'FitPeakMem' in self.src.old_titles:
                t = 'FitPeakMem'
            v = src_average_dict.get(t,'-')
            if not v:
                v = '-'
            average_line.append(v)
            g = src_gap_dict.get(t,'-')
            if not g:
                g = '-'
            gap_line.append(g)
        
        for cmp in self.cmps:
            cmp.set_average_gap(self.skip_case_list)
            average_dict,gap_dict = cmp.get_average_gap()
            for t in self.original_title[1:]:
                if t == 'Slice' and 'LE' in cmp.old_titles:
                    t = 'LE'
                if t == 'ParPeakMem' and 'FitPeakMem' in cmp.old_titles:
                    t = 'FitPeakMem'
                v = average_dict.get(t,'-')
                if not v:
                    v = '-'
                average_line.append(v)
                
                g = gap_dict.get(t,'-')
                if not g:
                    g = '-'
                gap_line.append(g)
        average_line =  average_line
        gap_line =  gap_line
        self.lines['average'] = average_line
        self.lines['gap'] = gap_line
        
    def compare_part(self):
        self.firt_compare_title = []
        
        for id1,item in enumerate(self.cmps):
            average_title = ['#'*id1+'Average_'+t for t in self.comp_title]
            comp_title_show = ['2#'*(id1+1)+t for t in self.comp_title]
            self.firt_compare_title += comp_title_show + average_title
        for id1,case in enumerate(self.select_group_list):
            src_values = []
            for t in self.comp_title:
                if case not in self.src.csv_dic.keys():
                    value1 = '-'
                else:
                    if t == 'Slice' and 'LE' in self.src.csv_dic[case].keys():
                        value1 = '-'
                    else:
                        try:
                            value1  = self.src.csv_dic[case][t]
                        except:
                            value1 = '-'
                src_values.append(value1)
            #print src_values
            for num,cmp in enumerate(self.cmps):
                cmp_values = []
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
                    win = 0
                    tie = 0
                    lose = 0
                    less15 = 0
                    less15_5 = 0
                    less5_5 = 0
                    more5_15 = 0
                    more15 = 0
                    if case not in cmp.csv_dic.keys():
                        value2 = '-'
                    else:
                        if case not in cmp.csv_dic.keys():
                            value2 = '-'
                        else:
                            if t == 'Slice' and 'LE' in cmp.csv_dic[case].keys():
                                value2 = '-'
                            else:
                                try:
                                    value2  = cmp.csv_dic[case][t]
                                except:
                                    value2 = '-'
                    
                    try:
                        #print float_f(src_values[id2]),src_values,"#",id2,src_values[id2],float_f(value2)
                        value = float_f(value2)/float_f(src_values[id2]) -1
                        value = float_f(value)
                        if value < 0 - win_lose:
                            lose  = lose + 1
                        elif value > win_lose:
                            win  = win + 1
                        else:
                            tie = tie + 1
                        if value < 0 - threshold:
                            less15 = less15 + 1
                        elif  -threshold<=value<-0.05:
                            less15_5 = less15_5 + 1
                        elif  -0.05<=value<0.05:
                            less5_5 = less5_5 + 1
                        elif 0.05<=value <0.15:
                            more5_15 = more5_15 + 1
                        elif value >= threshold:
                            more15 = more15 + 1
                        else:
                            pass
                    except:
                        value = '-'
                        tie = tie + 1
                        less5_5 =  less5_5 + 1
                    self.tie_win[num][t]['win'] += win 
                    self.tie_win[num][t]['tie'] += tie
                    self.tie_win[num][t]['lose'] += lose
                    self.tie_win[num][t]['less15'] += less15
                    self.tie_win[num][t]['less15_5'] += less15_5
                    self.tie_win[num][t]['less5_5'] += less5_5
                    self.tie_win[num][t]['more5_15'] += more5_15
                    self.tie_win[num][t]['more15'] += more15
                    
                    self.lines.setdefault(id1+1,[]).append(str(value))
                    self.average_newways[num].setdefault(t,[]).append(value)
                
    def compare_part_average_old(self): # this is the old ways
        src_average_dict,src_gap_dict = self.src.get_average_gap()
        for cmp in self.cmps:
            cmp.set_average_gap(self.skip_case_list)
            average_dict,gap_dict = cmp.get_average_gap()
                
            for id2,t in enumerate(self.comp_title):
                value1 = float_f( src_average_dict.get(t,'-'))
                value2 = float_f( average_dict.get(t,'-') )
                try:
                    value = value2 / value1 -1
                except:
                    value = '-'
                value = float_f(value)
                self.lines.setdefault('average',[]).append(str(value))
            for id2,t in enumerate(self.comp_title):
                self.lines.setdefault('average',[]).append('-')
        self.lines['average'].remove('-')
        self.lines['average'].insert(0,'Average')
    def compare_part_average(self): # this is the new ways
        
        for num,cmp in enumerate(self.cmps):
            
            for id2,t in enumerate(self.comp_title):
                use_list = self.average_newways[num][t]
                sum_v = 0
                num_v = 0
                for v in use_list:
                    try:
                        sum_v = sum_v + v
                        num_v = num_v + 1
                    except:
                        pass
                try:
                    value = sum_v / num_v
                except:
                    value = '-'
                value = float_f(value)
                self.lines.setdefault('average',[]).append(str(value))
            for id2,t in enumerate(self.comp_title):
                self.lines.setdefault('average',[]).append('-')
        self.lines['average'].remove('-')
        self.lines['average'].insert(0,'Average')
           
    def compare_part_gap(self):
            src_average_dict,src_gap_dict = self.src.get_average_gap()
            for cmp in self.cmps:
                max_value = -10000000
                min_value = 1000000
                cmp_values = []
                cmp_average_dict,cmp_gap_dict = cmp.get_average_gap()
                for id2,t in enumerate(self.comp_title):
                    value = '-'
                    for id1,case in enumerate(self.select_group_list):
                        try:
                            f1 = float_f(cmp_gap_dict.get(t,'-'))
                            f2 = float_f(src_gap_dict.get(t,'-'))
                            value2  = float_f(f1/f2 -1)
                        except:
                            value2 = '-'
                        if value2 != '-':
                            try:
                                max_value = max(max_value,value2)
                                min_value = min(min_value,value2)
                                value = max_value - min_value
                            except:
                                value = '-'
                    
                    self.lines.setdefault('gap',[]).append(str(value))
                for id2,t in enumerate(self.comp_title):
                    self.lines.setdefault('gap',[]).append('-')
            self.lines['gap'].remove('-')
            self.lines['gap'].insert(0,'Gap')
    
    def compare_part_sub_average(self):
        src_average_dict,src_gap_dict = self.src.get_average_gap()
        for id1,case in enumerate(self.select_group_list):
            src_values = []
            for t in self.comp_title:
                try:
                    value1  = self.src.csv_dic[case][t]
                except:
                    value1 = '-'
                src_values.append(value1)
            #print src_values  
            for cmp in self.cmps:
                average_dict,gap_dict = cmp.get_average_gap()
                cmp_values = []
                for id2,t in enumerate(self.comp_title):
                    try:
                        value2  = cmp.csv_dic[case][t]
                    except:
                        value2 = '-'
                    try:
                        #print float_f(src_values[id2]),src_values,"#",id2,src_values[id2],float_f(value2)
                        value = float_f(value2)/float_f(src_values[id2]) -1
                        value = float_f(value)
                    except:
                        value = '-'
                    #-------------------#
                    value1 = float_f( src_average_dict.get(t,'-'))
                    value2 = float_f( average_dict.get(t,'-') )
                    try:
                        value_average = value2 / value1 -1
                    except:
                        value_average = '-'
                    value_average = float_f(value_average)
                    try:
                        value  = value - value_average
                    except:
                        value = '-'
                    self.lines.setdefault(id1+1,[]).append(str(value))
                    
    def write_tie_win(self):
        find = 0
        for item in self.show_title:
            self.lines.setdefault('z0',[]).append('')
            self.lines.setdefault('z4',[]).append('')
            if item.startswith('2#'):
                #item = item[1:]
                item = item.replace('2#','')
                if item in self.comp_title:
                    if find == 0:
                        self.lines.setdefault('z1win',[]).append('Win')
                        self.lines.setdefault('z2tie',[]).append('Tie')
                        self.lines.setdefault('z3lose',[]).append('Lose')
                        self.lines.setdefault('z4less15',[]).append('change < -15%')
                        self.lines.setdefault('z5less15_5',[]).append('-15%< change < -5%')
                        self.lines.setdefault('z6less5_5',[]).append('-5%< change < +5%')
                        self.lines.setdefault('z7more5_15',[]).append('+5%< change < +15%')
                        self.lines.setdefault('z8more15',[]).append('+15% < change')
                                 
                    v = self.tie_win[find/( len(self.comp_title) )][item]['win']
                    self.lines.setdefault('z1win',[]).append(str(v))
                    v = self.tie_win[find/( len(self.comp_title) )][item]['tie']
                    self.lines.setdefault('z2tie',[]).append(str(v))
                    v = self.tie_win[find/( len(self.comp_title) )][item]['lose']
                    self.lines.setdefault('z3lose',[]).append(str(v))
                    v = self.tie_win[find/( len(self.comp_title) )][item]['less15']
                    self.lines.setdefault('z4less15',[]).append(str(v))
                    v = self.tie_win[find/( len(self.comp_title) )][item]['less15_5']
                    self.lines.setdefault('z5less15_5',[]).append(str(v))
                    v = self.tie_win[find/( len(self.comp_title) )][item]['less5_5']
                    self.lines.setdefault('z6less5_5',[]).append(str(v))
                    v = self.tie_win[find/( len(self.comp_title) )][item]['more5_15']
                    self.lines.setdefault('z7more5_15',[]).append(str(v))
                    v = self.tie_win[find/( len(self.comp_title) )][item]['more15']
                    self.lines.setdefault('z8more15',[]).append(str(v))
                    find = find + 1
            else:
                self.lines.setdefault('z1win',[]).append('')
                self.lines.setdefault('z2tie',[]).append('')
                self.lines.setdefault('z3lose',[]).append('')
                self.lines.setdefault('z4less15',[]).append('')
                self.lines.setdefault('z5less15_5',[]).append('')
                self.lines.setdefault('z6less5_5',[]).append('')
                self.lines.setdefault('z7more5_15',[]).append('')
                self.lines.setdefault('z8more15',[]).append('')
        self.lines.setdefault('z1win',[]).remove('')
        self.lines.setdefault('z2tie',[]).remove('')
        self.lines.setdefault('z3lose',[]).remove('')
        self.lines.setdefault('z4less15',[]).remove('')
        self.lines.setdefault('z5less15_5',[]).remove('')
        self.lines.setdefault('z6less5_5',[]).remove('')
        self.lines.setdefault('z7more5_15',[]).remove('')
        self.lines.setdefault('z8more15',[]).remove('')
    def show_title(self):
        self.show_title = self.original_part_title+self.firt_compare_title
    def add_note(self):
        all_keys = self.src.note.keys()
        for cmp in self.cmps:
            all_keys = all_keys + cmp.note.keys()
        all_keys = list(set(all_keys))
        self.note_line.append(",".join(all_keys))
        use_line = []
        for key in all_keys:
            if key in self.src.note.keys():
                string = self.src.note[key]
                string = [s.replace(',',' ') for s in string]
                string = ",".join(string)
                use_line.append(string) 
            else:
                use_line.append('')
        self.note_line.append(",".join(use_line))
        for cmp in self.cmps:
            use_line = []
            for key in all_keys:
                if key in cmp.note.keys():
                    string = cmp.note[key]
                    string = [s.replace(',',' ') for s in string]
                    string = ",".join(string)
                    use_line.append(string) 
                else:
                    use_line.append('')
            self.note_line.append(",".join(use_line))
    def add_note_horizonal(self):
        all_keys = self.src.note.keys()
        for cmp in self.cmps:
            all_keys = all_keys + cmp.note.keys()
        all_keys = list(set(all_keys))
        
        for key in all_keys:
            use_line = ['['+key+']']
            if key in self.src.note.keys():
                string = self.src.note[key]
                string = [s.replace(',',' ') for s in string]
                string = ",".join(string)
                string = string.strip()
                use_line.append(','+string+'\n') 
            else:
                use_line.append(',\n')
            #print use_line
            for cmp in self.cmps:
                    if key in cmp.note.keys():
                        string = cmp.note[key]
                        string = [s.replace(',',' ') for s in string]
                        string = ",".join(string)
                        string = string.strip()
                        use_line.append(','+string+'\n') 
                    else:
                        use_line.append(',\n')
            self.note_line.append("".join(use_line))
    def write_file_name(self):
        second_part = ''
        first_part = os.path.basename(self.src.csv_file)+','*( len(self.original_title) )
        for cmp in self.cmps:
            part = os.path.basename(cmp.csv_file)+','*( len(self.original_title)-1 )
            second_part+=part
        for id1,cmp in enumerate(self.cmps):
            n1 = id1 + 1
            #part = 'cmp' +str(n1)+ ","*(len(self.comp_title)*2 )
            part = os.path.basename(cmp.csv_file)+'VS'+os.path.basename(self.src.csv_file)+ ","*(len(self.comp_title)*2 )
            second_part+=part
        self.file_name_line = first_part + second_part  
            
            
            
    def write_file(self):
        self.original_part()
        self.compare_part()
        self.show_title()
        self.compare_part_average()
        self.compare_part_gap()
        self.compare_part_sub_average()
        self.write_tie_win()
        self.write_file_name()
        file_hand = file(self.output,'w')
        #self.add_note()
        self.add_note_horizonal()
        for line_n in self.note_line:
            file_hand.write(line_n)
        file_hand.write(self.file_name_line+'\n')    
        file_hand.write( ",".join(self.show_title ) +'\n' )
        
        line_nums = self.lines.keys()
        line_nums.sort()
        for line_n in line_nums:
            line_content = ",".join(self.lines[line_n])
            file_hand.write(line_content+'\n')
        file_hand.close()
        #return self.output,bb
   
def option():
    p=optparse.OptionParser()
    p.add_option("-f","--no-fmax",action="store_true",help="no fmax in the compare file")
    p.add_option("-s","--src",action="store",type="string",dest="src",help="The first file you want to compare")
    p.add_option("-c","--cmp",action="store",type="string",dest="cmp",help="The second file you want to compare")
    p.add_option("-o","--output",action="store",type="string",dest="output",help="The output file you want to compare")    
    p.add_option("-t","--comp_title",action="store",type="string",dest="comp_title",help="The title you want to compare")
    p.add_option("-r","--original_title",action="store",type="string",dest="original_title",help="The original title you want to see")
    opt,args=p.parse_args() 
    return opt
def run():
    opt = option()
    src_csv = opt.src
    cmp_csvs = opt.cmp
    compare_title = opt.comp_title
    original_title = opt.original_title
    output = opt.output
    no_fmax = opt.no_fmax
    cmp_csvs = cmp_csvs.split(',')
    src_csv_content = csv_content(src_csv)
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
            cmp_csv_contents.append( csv_content(cmp) )
    write_csv_o = write_csv(src_csv_content,cmp_csv_contents,output,compare_title,original_title,'')

    write_csv_o.write_file()
def run_web(src,cmp,comp_title,original_title,output):
    #opt = option()
    src_csv = src
    cmp_csvs = cmp
    compare_title = comp_title
    original_title = original_title
    output = output
    cmp_csvs = cmp_csvs.split(',')
    src_csv_content = csv_content(src_csv)
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
            cmp_csv_contents.append( csv_content(cmp) )
    write_csv_o = write_csv(src_csv_content,cmp_csv_contents,output,compare_title,original_title,'')

    write_csv_o.write_file()

def for_QoR(line,param_conf=''):
    src_csv = get_cmd_value(line,'src')
    cmp_csvs = get_cmd_value(line,'cmp')
    compare_title = get_cmd_value(line,'Comp_Title')
    original_title = get_cmd_value(line,'Original_Title')
    output = get_cmd_value(line,'output')
    no_fmax = get_cmd_value(line,'no-fmax')
    cmp_csvs = cmp_csvs.replace('"','')
    cmp_csvs = cmp_csvs.split(',')
    src_csv_content = csv_content(src_csv,no_fmax)
    cmp_csv_contents = []
    param_conf_file = os.path.join(os.path.dirname(__file__),'param.conf')
    if param_conf:
        if os.path.isfile(param_conf):
            param_conf_file = param_conf
        else:
            print 'Error, can not find file:%s\n\n'%param_conf
            sys.exit(-1)
    title_dic = get_conf_options(param_conf_file)
    try:
        compare_title = title_dic['Comp_Title'][compare_title]
    except:
        print 'Error, can not find key:%s'%compare_title
        sys.exit(-1)
    compare_title = compare_title.split(',')
    compare_title= [item.strip() for item in compare_title]
    try:
        original_title = title_dic['Original_Title'][original_title]
    except:
        print 'Error, can not find key:%s'%original_title
        sys.exit(-1)
        
    original_title = original_title.split(',')
    original_title= [item.strip() for item in original_title]
    if set(compare_title) - set(original_title):
        print 'Error, you have to make sure compare_title is a sub set of original title \n\n\n\n'
        sys.exit(-1)
    for cmp in cmp_csvs:
        if os.path.isfile(cmp):
            cmp_csv_contents.append( csv_content(cmp,no_fmax) )
            #print cmp,111
    write_csv_o = write_csv(src_csv_content,cmp_csv_contents,output,compare_title,original_title,'',no_fmax)
    write_csv_o.write_file()
    os.remove(output)
def get_cmd_value(str,cmd):
    '''
    This function used to get the command value from a line.
    str is the command line
    cmd is the name you want to return
    EXAMPLE: 
         '*** *** --command=value *** ***'
         the return is "value" 
    '''
    '''cmd =  '--'+cmd
    cmd_re = re.compile(r"""%s\s?=\s?([\w : \\ _ \- \. , "]+)
                    ($
                    |\s+--)"""%cmd,re.VERBOSE)
    cmd_compile = cmd_re.search(str)
    if cmd_compile:
        #print cmd_compile.groups(-1)
        print (cmd_compile.group(1)).strip()
        return (cmd_compile.group(1)).strip()
    else:
        print 'Nothing find'
        return'''
    re_option = re.compile(r'--'+cmd+r'=(.+?)(--|$)')
    re_search = re_option.search(str)
    if re_search:
        return (re_search.group(1)).strip()
    else:
        return ''   
if __name__ == '__main__':
    run()