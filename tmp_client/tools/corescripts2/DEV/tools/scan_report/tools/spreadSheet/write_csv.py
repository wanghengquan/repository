#! C:\Python25\python.exe
#coding:utf-8
#===================================================
# Owner    : Yzhao1
# Function :
#           This file used to compare the data in the two csv files
# Attention:
#           compare any data which can translate to float

# Date     :2013/1/7

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
statistic_tie_list = [['win','win'],
        ['tie','tie'],
        ['lose','lose'],
        ['less15','<-0.15'],
        ['less15_5','-0.15~-0.05'],
        ['less5_5','-0.05~-0.05'],
        ['more5_15','0.05~-0.15'],
        ['more15','>0.15']]

def read_csv(csv_file):
    ''' This function used to read the data from csv file
        At here the csv file should not contain any note before case data
        And the first line should be the title as "Design,....."
        the return data is a dictionary
        dict[desing] = line1
    '''
    csv_dic = {}
    file_hand = file(csv_file,'rb')
    ori_dict = csv.DictReader(file_hand)
    for item in ori_dict:
        design = item.get('Design','None')
        if design != 'None' and design != '':
            csv_dic[design] = item
        else:
            pass
        #print item
    title = ori_dict.fieldnames
    return [csv_dic,title]
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
    for id1,line in enumerate(open(csv_file)):
            line = line.strip()
            if begin == 0:
                if line.startswith('Design') or line.startswith('design'):
                    begin = 1
                    line = line.replace('#','')
                    hot_lines.append(line)
                    continue
                else:
                    note.append(line)
            else:
                line = line.replace('#','')
                hot_lines.append(line) 
    ori_dict = csv.DictReader(hot_lines)
    for item in ori_dict:
        design = item.get('Design','None')
        if design != 'None' and design != '':
            csv_dic[design] = item
        else:
            pass
        #print item
    title = ori_dict.fieldnames
    return [csv_dic,title,note]
def compare_csv(obj1=[],obj2=[],file_csv='compared.csv',original_title=[],compare_title = []):
    '''
       this file used to compare the data from "read_csv_note()"
       the result will be stored in a file named "compared.csv"
    '''
    title1 = obj1[1]
    title2 = obj2[1]
    compared_dic = {}
    just_alphabet = re.compile('[a-z A-Z \- _ ]')
    
    if title1 != title2:
        print "ERROR: Please make sure the files are in the same vendor"
        return
    title1 = original_title    
    key2 = obj2[0].keys()   # at here the key2 is the case name list
    if not compare_title:
        comp_title = []
    else:
        comp_title = compare_title
    select_group_list = []
    first_case = 0
    for key,value in obj1[0].items():
        if first_case == 0:
            for group in all_groups:
                group_list = group_cases[group]
                if key in group_list:
                    select_group_list = group_list
                    first_case = 1
                    break
        if key in key2:                     #at here key is  the case name, obj1[0] = {casename:line1}, line1 = {title:value}
            line_dic = {}
            for ti in title1:
                try:
                   value1 = obj1[0][key][ti]
                   value2 = obj2[0][key][ti]
                   if just_alphabet.search(value1) or  just_alphabet.search(value2):
                      comp = '_'
                   else:
                       if value1.find('%') != -1 and value2.find('%') != -1 :
                           data1 = value1.split('%')[0]
                           data2 = value2.split('%')[0]
                           try:
                                   comp =  float( data2)/float(data1) -1
                           except ZeroDivisionError:
                                   comp =  0.0
                           comp = comp*100
                           comp = str(comp)+'%'
                           '''
                           if '#'+ti in comp_title:    # this will be used in the title as *,*,,,,,#*,#*,,,,,##*,##*,...,
                               pass
                           else:
                               comp_title.append('#'+ti)
                           '''
                               
                       else:     
                           try:
                                   comp =  float( value2)/float(value1) -1
                                   comp = comp*100
                                   comp = str(comp)+'%'
                           except ZeroDivisionError:
                                   comp =  0.0
                                   comp = str(comp)+'%'
                           except:
                               comp = 'NA'
                               
                           '''
                           if '#'+ti in comp_title:
                               pass
                           else:
                               comp_title.append('#'+ti)
                           '''
                except Exception,e:
                    print e
                    print traceback.format_exc()
                
                    continue
                if ti in comp_title:
                    line_dic['#'+ti] = comp
                
            compared_dic[value.get('Design')]=line_dic
    comp_title = ['#'+ti for ti in comp_title ]   
    '''
    dict_writer = csv.DictWriter(file(file3, 'wb'), fieldnames=title1)
    title_dic = {}
    
    for item in title1:
       title_dic[item] = item
    dict_writer.writerow(title_dic)
    for item in comared_dic.keys():
      dict_writer.writerow(comared_dic[item])   
    '''
    
    file3 = file(file_csv,'w')
    total_title = title1    #  at here the total_title is the coloum should be shown in the csv file of the origianl part
    for new in title1[1:]:  # title1[0] is 'Design'
         new = '#'+new
         total_title = total_title + [new]
    t_a = []     
    for new in comp_title:
         new = '#'+new
         total_title = total_title + [new]
         t_a.append(new[1:]+'_Average')
    for new in t_a:
        total_title = total_title + [new]
    t = ','.join(total_title)
    file3.write(t+'\n')
    
    average_list1 = {}  # the data structure is {fmax:1 2 3 4, DEV:a,g,c,...}
    average_list2 = {}
    tie_lose = {}
    for_csv_lines = []
    cases = compared_dic.keys()
    cases.sort()
    if not select_group_list:
        select_group_list = cases
    for roal_case in select_group_list:
        case = roal_case
        if case in cases:
            ll = []
            for k1 in title1:                                      # the first file part
                v1 = obj1[0][case][k1]
                ll.append(v1)
                average_list1.setdefault(k1,[]).append(v1)
                
            for k1 in title1[1:]:                                  # the second file part
                v1 = obj2[0][case][k1]
                ll.append(v1)
                average_list2.setdefault(k1,[]).append(v1)
                
            for k1 in comp_title:
                #print k1,                     # the compare part
                ll.append(str(compared_dic[case][k1]))
                tie_lose.setdefault(k1,[]).append( compared_dic[case][k1] )
                
            l = ','.join(ll)
            for_csv_lines.append(l)
        else:
            ll = []
            for k1 in title1:                                      # the first file part
                v1 = '_'
                ll.append(v1)
                average_list1.setdefault(k1,[]).append(v1)
                
            for k1 in title1[1:]:                                  # the second file part
                v1 = '_'
                ll.append(v1)
                average_list2.setdefault(k1,[]).append(v1)
                
            for k1 in comp_title:
                #print k1,                     # the compare part
                ll.append('_')
                tie_lose.setdefault(k1,[]).append( '_' )
            ll[0] = case    
            l = ','.join(ll)
            for_csv_lines.append(l)
        
    average_line,gap_line,compare_average = comp_average(average_list1,average_list2,title1,comp_title)
    average_list =average_line[2*len(title1)-1 :]    
    for id1,case in enumerate( select_group_list ):   # write compare - average
        line = []
        #print compared_dic[case]
        for id2,t in enumerate(comp_title):
            if case in compared_dic.keys():
                v = compared_dic[case][t]
                a = average_list[id2]
                #print t,v,a
                result = '_'            
                try:
                    if v.find('%')!= -1 and a.find('%')!= -1:
                        result = float(v.split('%')[0]) - float(a.split('%')[0]) 
                        result = str(result)+'%'
                except Exception,e:
                    #print e
                    result =  '_'
            else:
                result = '_'
            line.append(result)
        line = ","+",".join(line)            
        for_csv_lines[id1] = for_csv_lines[id1] + line             
    for l in for_csv_lines:
        file3.write(l+'\n')
    #print  for_csv_lines[0]                                      
    #average_line,gap_line = comp_average(average_list1,average_list2,title1,comp_title) #Gap Average part
    average_line[0] = 'Average'
    average_line = ",".join(average_line)
    file3.write('\n')
    file3.write(average_line+'\n')    
    gap_line[0] = 'Gap'
    gap_line = ",".join(gap_line)
    file3.write(gap_line+'\n')
    file3.write('\n')
    static_result = statistic_tie_percent(tie_lose,comp_title) 
    line = [' ']*( len(title1)*2 -1)+ comp_title
    line[0] = 'Sumary:'    
    line = ",".join(line)
    file3.write(line+'\n')

    for item1 in statistic_tie_list:                  # Summary: tie lose win
        line = [' ']*( len(title1)*2 -2)
        line = line + [item1[1]]
        for item2 in comp_title:
                    a = static_result[item2][item1[0] ]
                    line = line + [str(a)]
                    
        line = ','.join(line)
        file3.write(line+'\n')
        if item1[0]=='lose':
            file3.write('\n')        
    file3.close()
    
    return file_csv,static_result,compare_average  # the second,third member is add later
def statistic_tie_percent(dic={},title=[]):
    '''
        At here dic: {title:[value1,value2.....]}
        the return data will be:
        {title:{win:*,lose:*,tie:* ...}}
    '''
    return_dic = {}
    for item in title:
        win = 0
        tie = 0
        lose = 0
        less15 = 0
        less15_5 = 0
        less5_5 = 0
        more5_15 = 0
        more15 = 0
        win_lose = 0.03
        if item in dic.keys():
            value_list = dic[item]
            title_dic = {}
            for value in value_list:
                #print value
                try:
                    value =( value.split('%') )[0]
                    value = float(value)/100.0 
                    if value < 0 - win_lose:
                        lose  = lose + 1
                    elif value > win_lose:
                        win  = win + 1
                    else:
                        tie = tie + 1
                    if value < 0 - 0.15:
                        less15 = less15 + 1
                    elif  -0.15<=value<-0.05:
                        less15_5 = less15_5 + 1
                    elif  -0.05<=value<0.05:
                        less5_5 = less5_5 + 1
                    elif 0.05<=value <0.15:
                        more5_15 = more5_15 + 1
                    elif value >= 0.15:
                        more15 = more15 + 1
                    else:
                        pass
                except:
                     tie = tie + 1
                     less5_5 =  less5_5 + 1
                
            title_dic['win'] = win
            title_dic['tie'] = tie
            title_dic['lose'] = lose
            title_dic['less15'] = less15
            title_dic['less15_5'] = less15_5
            title_dic['less5_5'] = less5_5
            title_dic['more5_15'] = more5_15
            title_dic['more15'] = more15
            return_dic[item] = title_dic            
    return return_dic
def get_col_content(csv_dic={},title=[]):
    '''
       The return data will be as:
       {title:col1,col2,col3....}
    '''
    cases = csv_dic.keys()
    cases.sort()
    title_col_dic= {}
    
    for id1,case in enumerate( cases ):
      
        for id2,item in enumerate(title):
            
            title_col_dic.setdefault(item,[]).append(csv_dic[case][item])
           
    return title_col_dic
def comp_average(average_list1={},average_list2={},title1=[],comp_title=[]):
    '''
    The return data is a list, the first member is average line  
    The second member is the gap line
     
    '''
    compare_average = {}
    line1 = []  
    line2 = []
    gap1 = []
    gap2 = []    
    for id1,k1 in enumerate( title1 ):
            sum = 0
            num = 0
            average1 = '_'
            average2 = '_'
            percent = 0
            max1 = -100000000
            min1 = 100000000
            for value in average_list1[k1]:                         # the first part average
            
                if value.find('%')!= -1:
                    percent = 1
                    value = float( value.split('%')[0] )
                    sum = sum + value
                    num = num + 1
                    max1 = max(value,max1)
                    min1 = min(value,min1)
                else:
                    try:
                        value = float(value)
                        sum = sum + value
                        num = num + 1
                        max1 = max(value,max1)
                        min1 = min(value,min1)
                    except ValueError:
                        pass
            try:
                average1 = sum/num
                if abs(max1)==100000000 or abs(min1)==100000000:
                    gap = '_'
                else:
                    gap = max1 - min1
                    
                if percent == 1:
                    average1 = str(average1)+ '%'
                    gap = str(gap)+ '%'
                    
            except ZeroDivisionError:
                average1 = '_'
                gap = '_'
                
            line1.append( str(average1) )
            gap1.append(str(gap))
            if id1 != 0:                                            # id1 response to "Design "
                percent = 0 
                sum = 0
                num = 0
                max2 = -100000000
                min2 = 100000000                
                for value in average_list2[k1]:                         # the second part average
                
                    if value.find('%')!= -1:
                        value = float( value.split('%')[0] )
                        sum = sum + value
                        num = num + 1
                        percent = 1
                        max2 = max(value,max2)
                        min2 = min(value,min2)
                    else:
                        try:
                            value = float(value)
                            sum = sum + value
                            num = num + 1
                            max2 = max(value,max2)
                            min2 = min(value,min2)
                        except ValueError:
                            pass
                try:
                    average2 = sum/num
                    if abs(max2)==100000000 or abs(min2)==100000000:
                        gap = '_'
                    else:
                        gap = max2 - min2                   
                    if percent==1:
                        average2 = str(average2)+ '%'
                        gap = str(gap)+'%'                        
                except ZeroDivisionError:
                    average2 = '_'
                    gap = '_'
                line2.append( str(average2) )
                gap2.append(str(gap))
                #print k1,comp_title
                if "#"+k1 in comp_title:    
                    try:
                        
                        average1 = str(average1)
                        average2 = str(average2)
                        if average1.find('%')!= -1 and average2.find('%')!= -1:
                            
                            average2 = float( average2.split('%')[0] )
                            average1 = float( average1.split('%')[0] )
                            
                            try:
                                compare = average2/average1 -1
                                compare = str(compare*100)+'%'
                            except:
                                compare = '_'
                        else:
                          
                            average2 = float( average2 )
                            average1 = float( average1 )
                            
                            
                            try:
                                compare = average2/average1 -1
                                compare = str(compare*100)+ '%'
                                #print average2,average1,compare,k1
                            except:
                                compare = '_'
               
                    except Exception,e:
                        #print e
                        compare = '_'                            
                    compare_average['#'+k1]=compare
    #print compare_average
    compare_average_list=[]
    for item in comp_title:
        compare_average_list.append(compare_average[item])
    line = line1+line2 + compare_average_list
    #gap = gap1 + gap2 + ['_']*len(compare_average_list) # ignore the line in gap
    gap = gap1 + gap2 + compare_average_list
    return [line,gap,compare_average] # the last one is just added
def comp_gap(dic={},title=[]):
    '''
        This function is useless now
        The dic will be the data frm get_col_content
        
    '''
    gap_list = []
    gap_dic = {}
    for item in title:
        if item in dic.keys():
            gap = 0
            max_value= -100000000
            min_value = 100000000
            value = dic[item]
            
            for col_value in value:
                try:
                   col_value = float(col_value)
                   if col_value >= max_value:
                       max_value = col_value
                   if col_value <= min_value:
                       min_value = col_value
                except:
                   pass
            try:
                if max_value==100000000 or min_value==100000000:
                    gap = '_'
                else:
                    gap =  max_value - min_value
            except:
                gap = '_'
            gap_list.append(gap)
            gap_dic[item] = gap
    return gap_dic


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
        note_key = re.compile(r'\[([\w\s]+)\]')
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
                dict_retrun.setdefault(key,[]).append(value.strip())
            else:
               line = line.replace(',',' ')
               if dict_retrun:
                   dict_retrun.setdefault(key,[]).append(line.strip())
               else:
                   dict_retrun.setdefault('None',[]).append(line.strip())
        return dict_retrun
def write_csv(note1={},note2={},file_compare1='file1',file_compare2='file2',file_csv='compred.csv'):
    '''
       At here , the function used to add the notes
    '''
    note_lines = []
    if 1:
        '''
        The follow used for writing notes
        '''
        keys = note1.keys()
        keys.sort()
        for key in keys:
            value = note1[key]
            value = ' '.join(value)
            value2 = '::'
            if key in note2.keys():
                if value == ' '.join(note2[key]):
                    pass
                else:
                    value2 = value2+' '.join(note2[key])
                    value = value + value2                    # �����漰��˳������
                value = '['+key+']' + value
                note_lines.append(value)
                
        for key,value in note2.items():
            value = ' '.join(value)
            value2 = '::'
            if key not in note1.keys():
                #value2 = value2+' '.join(note2[key])
                value = '['+key+']'+value                            # �����漰��˳������
                note_lines.append(value)
        for key,value in note1.items():
            value = ' '.join(value)
            value2 = '::'
            if key not in note2.keys():
                #value2 = value2+' '.join(note2[key])
                value = '['+key+']'+value                            # �����漰��˳������
                note_lines.append(value)
        
    file_hand = file(file_csv,'r')
    lines = file_hand.readlines()
    file_hand.close()
    file_hand = file(file_csv,'w')
    for line in note_lines:
        file_hand.write(line+'\n')
    for id1,line in enumerate(lines):
        if id1 == 0:
            title = line
            titles = line.split(',')
            title = []
            len1 = 0
            len2 = 0
            len3 = 0
            for id2,t in enumerate(titles):
                if t.find('#')!= -1:
                    len1 =  id2
                    break
            for id2,t in enumerate(titles):
                if t.find('##')!= -1:
                    len2=  id2
                    break
            len3 = len(titles) - len2
            s = [',']*(len(titles) +1)
            s[0] = ( os.path.split(file_compare1) )[1]
            s[len1+1] = ( os.path.split(file_compare2) )[1]
            s[len2+2] = 'compare'
            file_line = "".join(s)
            file_hand.write(file_line+'\n')    
        file_hand.write(line)
    file_hand.close()
def option():
    p=optparse.OptionParser()
    p.add_option("-s","--src",action="store",type="string",dest="src",help="The first file you want to compare")
    p.add_option("-c","--cmp",action="store",type="string",dest="cmp",help="The second file you want to compare")
    p.add_option("-o","--output",action="store",type="string",dest="output",help="The output file you want to compare")    
    p.add_option("-t","--comp_title", defaults="comments", action="store",type="string",dest="comp_title",help="The title you want to compare")
    p.add_option("-r","--original_title", defaults="comments", action="store",type="string",dest="original_title",help="The original title you want to see")
    opt,args=p.parse_args() 
    return opt    
def run(file1,file2,output,title,original_title):
    if (not file1) or (not file2) or (not output) or (not title):
       print '''
           Please learn how to use it through -h
           You should run it as:
           python write_csv.py --file1=*** --file2=*** --output=***  title=*** --original-title=***
           '''
       sys.exit()
    a1 = read_csv_note(file1)
    a2 = read_csv_note(file2)
    compare_title = a1[1][1:]   # Provide the title you want to compare
    #compare_title = ['Register',    'Slice']
    title_dic = get_conf_options(param_conf_file)
    compare_title = title_dic['Comp_Title'][title]
    compare_title = compare_title.split(',')
    compare_title= [item.strip() for item in compare_title]
    original_title = title_dic['Original_Title'][original_title]
    original_title = original_title.split(',')
    original_title= [item.strip() for item in original_title]
    file_return,static_result,compare_average = compare_csv(a1,a2,output,original_title,compare_title)
    note1 = process_note(a1[2])
    note2 = process_note(a2[2])
    write_csv(note1,note2,file1,file2,file_return)
    return_dic = {}  # filename:static_result,compare_average
    return_dic[file_return] = [static_result,compare_average]
    import write_excel2
    write_excel2.write_excel(file_return, return_dic)
    return file_return, return_dic
    
    
    
if __name__=='__main__':
    opt = option()
    file1 = opt.file1 
    file2 = opt.file2
    file3 = opt.output
    title = opt.cmp_title
    original = opt.original_title
    print file1,file2,file3,title,original
    if (not file1) or (not file2) or (not file3) or (not title):
       print '''
           Please learn how to use it through -h
           You should run it as:
           python write_csv.py --file1=*** --file2=*** --output=***  title=*** --original-title=***
           '''
       sys.exit()
    a1 = read_csv_note(file1)
    a2 = read_csv_note(file2)
    compare_title = a1[1][1:]   # Provide the title you want to compare
    #compare_title = ['Register',    'Slice']
    title_dic = get_conf_options(param_conf_file)
    compare_title = title_dic['Comp_Title'][title]
    compare_title = compare_title.split(',')
    compare_title= [item.strip() for item in compare_title]
    original_title = title_dic['Original_Title'][original]
    original_title = original_title.split(',')
    original_title= [item.strip() for item in original_title]
    file_return,static_result,compare_average = compare_csv(a1,a2,file3,original_title,compare_title)
    note1 = process_note(a1[2])
    note2 = process_note(a2[2])
    write_csv(note1,note2,file1,file2,file_return)
    return_dic = {}  # filename:static_result,compare_average
    return_dic[file_return] = [static_result,compare_average]
    import write_excel2
    write_excel2.write_excel(file_return, return_dic)
    print file_return, return_dic
    
    
    
            
    
    