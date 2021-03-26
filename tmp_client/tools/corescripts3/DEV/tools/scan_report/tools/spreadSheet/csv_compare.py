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
import re
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
                if line.startswith('Design'):
                    begin = 1
                    hot_lines.append(line)
                    title = line
                    continue
                else:
                    note.append(line)
            else:
                hot_lines.append(line) 
    file_hand = file(csv_file,'rb')
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
def compare_csv(obj1=[],obj2=[],file_csv='compared.csv'):
    '''
       this file used to compare the data from "read_csv()"
       the result will be stored in a file named "comppared.csv"
    '''
    title1 = obj1[1]
    title2 = obj2[1]
    compared_dic = {}
    just_alphabet = re.compile('[a-z A-Z \- _ ]')
    if title1 != title2:
        print("ERROR: Please make sure the files are in the same vendor")
        return
    key2 = list(obj2[0].keys())
    comp_title = []
    for key,value in list(obj1[0].items()):
        if key in key2:                       # at here key is  the case name
            line_dic = {}
            for ti in title1:
                try:
                   value1 = obj1[0][key][ti]
                   value2 = obj2[0][key][ti]
                   if just_alphabet.search(value1) or  just_alphabet.search(value2):
                      if value1 == value2:
                            comp = value1
                      else:
                            comp = value1+' :: '+ value2
                      continue
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
                           if '#'+ti in comp_title:
                               pass
                           else:
                               comp_title.append('#'+ti)
                       else:     
                           try:
                                   comp =  float( value2)/float(value1) -1
                           except ZeroDivisionError:
                                   comp =  0.0
                           comp = comp*100
                           comp = str(comp)+'%'
                           if '#'+ti in comp_title:
                               pass
                           else:
                               comp_title.append('#'+ti)
                except:
                    #print obj1[0][key][ti]
                    #print ti
                    #print obj1[0][key][ti]
                    #print obj2[0][key][ti]
                    comp = '-'
                    continue
                #print comp
                line_dic['#'+ti] = comp
                #print comp,value1,value2
                
            compared_dic[value.get('Design')]=line_dic
            #print line_dic
    #print  comared_dic
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
    total_title = title1
    for new in title1[1:]:
         new = '#'+new
         total_title = total_title + [new]
    for new in comp_title:
         new = '#'+new
         total_title = total_title + [new]
    #total_title = title1+title1[1:] + comp_title
    t = ','.join(total_title)
    file3.write(t+'\n')
    #print comp_title
    for case in list(compared_dic.keys()):
        #print comared_dic[case]
        ll = []
        for k1 in title1:
            ll.append(obj1[0][case][k1])
        for k1 in title1[1:]:
            ll.append(obj2[0][case][k1])
        for k1 in comp_title:
            ll.append(str(compared_dic[case][k1]))
        l = ','.join(ll)
        file3.write(l+'\n')
    file3.close()
    return file_csv
def get_col_content(csv_dic={},title=[]):
    '''
       The return data will be as:
       {title:col1,col2,col3....}
    '''
    cases = list(csv_dic.keys())
    cases.sort()
    title_col_dic= {}
    
    for id1,case in enumerate( cases ):
      
        for id2,item in enumerate(title):
            
            title_col_dic.setdefault(item,[]).append(csv_dic[case][item])
           
    return title_col_dic
def comp_average(dic={},title=[]):
    '''
     the dic will be the return data from get_col_content
    '''
    average_list = []
    average_dic = {}
    return_dic = {}  # title:value
    for item in title:
        if item.find('##')== -1:
            if item in list(dic.keys()):
                average = 0
                total_num = 0
                value = dic[item]
                for col_value in value:
                    try:
                       average = average + float(col_value)
                       total_num = total_num + 1  
                    except:
                       pass
                try:
                    average =  average/total_num
                except:
                    average = '_'
                average_list.append(average)
                average_dic[item] = average
                return_dic[item] = average
        else:
            key1 = item[1:]
            key2 = item[2:]
            value1 = average_dic.get(key1,'_')
            value2 = average_dic.get(key2,'_')
            try:
                value =  value2/value1 -1
            except:
                value = '_'
            average_list.append(value)
            return_dic[item] = value
    return return_dic
def comp_gap(dic={},title=[]):
    '''
        The dic will be the data frm get_col_content
    '''
    gap_list = []
    gap_dic = {}
    for item in title:
        if item in list(dic.keys()):
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
def compare_sub_average(csv_dic={},title=[],average_dic={}):
    '''
        At here we use this function to compare the compared datas: compare_data - average
        csv_dic: {case_name:line}
        average_dic: the return data from comp_average.  {title:value}
        the return data will be like this:
        {case: line}   line----> {title:value}
    '''
    return_data = {}
    for case,line in list(csv_dic.items()):
        data = {}
        for col_name  in title:
            if ( col_name in list(line.keys()) ) and ( col_name in list(average_dic.keys()) ) and col_name.find('##') != -1:
               average = average_dic[col_name]
               comp = line[col_name]
               try:
                   result = float(average) - float(comp) 
               except:
                   result = '-'
               data[col_name] = result   
        return_data[case] = data
        
    return return_data  

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
        note_key = re.compile(r'\[(.+)\]')
        for line in note:
            line = line.strip()
            match_line = ''
            match_line  = note_key.search(line)
            key = 'None'
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
                value =  line.strip()
                value = value.replace(',',' ')
                if dict_retrun:
                    dict_retrun.setdefault(key,[]).append(value.strip())
                else:
                    dict_retrun.setdefault('None',[]).append(value.strip())
        return dict_retrun
def write_csv(note1=[],note2=[],file_compare1='file1',file_compare2='file2',file_csv='compred.csv'):
    '''
       At here , the function used to add the notes
    '''
    note_lines = []
    if 1:
        '''
        The follow used for writing notes
        '''
        for key,value in list(note1.items()):
            value = ' '.join(value)
            value2 = '::'
            if key in list(note2.keys()):
                value2 = value2+' '.join(note2[key])
                value = '['+key+']'+value + value2                           # �����漰��˳������
                note_lines.append(value)
        for key,value in list(note2.items()):
            value = ' '.join(value)
            value2 = '::'
            if key not in list(note1.keys()):
                #value2 = value2+' '.join(note2[key])
                value = '['+key+']'+value                            # �����漰��˳������
                note_lines.append(value)
        for key,value in list(note1.items()):
            value = ' '.join(value)
            value2 = '::'
            if key not in list(note2.keys()):
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
            s[0] = ( os.path.split(file1) )[1]
            s[len1+1] = ( os.path.split(file2) )[1]
            s[len2+2] = 'compare'
            file_line = "".join(s)
            file_hand.write(file_line+'\n')    
        file_hand.write(line)
    file_hand.close()
    
if __name__=='__main__':
    file1 = r'D:\Users\yzhao1\workspace\weekly\csv_action\real.csv'
    file2 = r'D:\Users\yzhao1\workspace\weekly\csv_action\fake.csv'
    file3 = r'D:\Users\yzhao1\workspace\weekly\csv_action\exam_compared.csv'
    a1 = read_csv_note(file1)
    a2 = read_csv_note(file2)
    file_return = compare_csv(a1,a2,file3)
    note1 = process_note(a1[2])
    note2 = process_note(a2[2])
    write_csv(note1,note2,file1,file2,file_return)
    
            
    
    