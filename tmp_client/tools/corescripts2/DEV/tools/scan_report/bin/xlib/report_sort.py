#! C:\Python25\python.exe
#===================================================
# Owner    : Yzhao1
# Function :
#           This file is used for export the best fmax line
#           from the new structure result.
# Attention:
#           1  the first line should begin with "Desing"
#           2  In the first line, it should contain 'fmax'

# Date     :2013/1/7

#===================================================
import os,sys,re,copy
import time
import shutil,stat
import csv
import glob
from xConf import get_conf_options
case_list_path =  os.path.join(__file__,'..','..','..','conf','case_list.conf')
case_list_path = os.path.abspath(case_list_path)
case_group_dic = get_conf_options(case_list_path)['case_list']
group_cases= {}
for group,cases in case_group_dic.items():
    cases = cases.split()
    for item in cases:
        group_cases.setdefault(group,[]).append(item)
##########################
note_fmax_dic = dict(ecp2_60='All sweep from 50MHz to 300MHz stepping in 10MHz;ADPCMtest,adpcm_codec_64ch from 10MHz to 50MHz stepping in 5MHZ ',
                 sc_24 = 'All sweep from 100MHz to 400MHz stepping in 10MHz;',
                 large_25 ='Sweeping step is 5MHz step, range is 10-100Mhz; step 10 MHz, range is 50MHz-300MHz',
                 xo_103 ='All sweep from 100MHz to 400MHz stepping in 10MHz;' )
##############################################################
        
def my_float(string):
    '''Special for the csv model. 
    '''
    string = str(string)
    percent_flag = 0
    if string.find('%')!= -1:
        string = string.replace('%','')
        percent_flag = 1
    try:
      value = float(string)
      if percent_flag == 1:
         value = value/100
    except:
      if str(string).lower() == 'none':
         value = 0
      else:
         value = -1
    return value
def sort_csv(csv_file,col_key='fmax',fail_log='',add_average='',list_order=True,name_list='',default_case_list=""):
    '''
        In this function, I will sort the content of the csv file and the sorted file will be named as
           csv_file_sorted.csv
        in the program, all the lines will be listed in a dictionary, the key is the first col of the 
           line. So the case name will always be the key. 
           EXAMPLE:
           dic[case1]=[line1,line2,line3]
           line1  is a dictinoary processed by csv model.
    '''
    csv_file = os.path.abspath(csv_file)
    name,suffix = os.path.splitext(csv_file)
    name_sorted = name+'_sorted'
    file_sorted = name_sorted+'.csv'
    all_record = name_sorted+'_all'+'.csv'
    hot_lines=[]
    use_lines=[]
    design_line_dic={}
    title = ''
    title_dic = {}
    default_values = {}  # title:'_'
    begin = 0
    note = []
    design_fmax = {}
    group_name = ''  # this is the cases group name  ecp_60,xo_103 and so on
    cases_list = ''
    all_case_name = []
    for id1,line in enumerate(open(csv_file)):
            line = line.strip()
            if begin == 0:
                if line.startswith('Design'):
                    begin = 1
                    hot_lines.append(line)
                    title = line + ",passPoints"
                    continue
                else:
                    note.append(line)
            else:
                hot_lines.append(line) 
                if line.split(',')[0] in all_case_name:
                    pass
                else:
                    all_case_name.append(line.split(',')[0])  
            
    ori_dict = csv.DictReader(hot_lines)
    #ori_dict2 = copy.deepcopy(ori_dict)
    csv_dict = dict()
    note_case = {}
    find_it = 0
    sw = ''
    for id1,item in enumerate(ori_dict):
        design = item['Design']
        design_line_dic.setdefault(design,[]).append(item)
        sw2  = item.get('Version','None')
        sw2 = sw2.strip()
        #print '-----',sw2
        if sw2 == 'None' or sw2 == '' or sw2 == '-' or sw2 == '_':
            pass
        else:
            sw = sw2
            note_case = item
        if id1 == 0:
            for group,cases in group_cases.items():
                if design in cases:
                    if (group.lower() == name_list.lower()) or ( set(cases)==set(all_case_name) ):
                        group_name = group
                        cases_list = cases
                        #note_case = item
                        find_it = 1
                        #print cases_list
                        break
    if find_it == 1 and list_order:
        pass
    else:
        note_case = item
        cases_list = design_line_dic.keys()
        cases_list.sort()
        #if design in design_line_dic.keys():
           #design_line_dic[design].append((item,hot_lines[id1]))
        #   design_line_dic[design].append(item)
        #else:
        #   design_line_dic[design]=[item]
    #------------------The follow step used for export note information -----------------#
    if default_case_list:
        cases_list = all_case_name
    try:
        fmax_note =  note_fmax_dic[group.lower()]
    except:
        fmax_note = ''
    run_fail = ''
    spread_grade = ''
    synthesis_tool = ''
    # r'Diamond (64-bit) 2.2.0.35'
    # r'Diamond Version 2.2.0.60'
    sw_re = re.compile(r'Diamond\s+(.+)\s+([\d \.]+)')
    if sw != 'None':
        if sw.find('64-bit')!= -1:
            sw_re = re.compile(r'Diamond\s+(\(.+\))\s+([\d \.]+)')
            sw_cmp = sw_re.search(sw)
            if sw_cmp:
                sw = 'Diamond_64bit'+sw_cmp.group(2)
                synthesis_tool = 'lse'
        else:
            sw_cmp = sw_re.search(sw)
            if sw_cmp:
                sw = 'Diamond'+sw_cmp.group(2)
                synthesis_tool = 'lse'
            
    #sw_line = '[SW]:'+sw
    
    report_time = time.asctime()
    # get the path of the case 
    # read the mrp file
    # get the line "Target Performance:   8"
    case_path,csv_name  = os.path.split(csv_file)
    case_name = note_case.get('Design',"")
    case_path = os.path.join(case_path,case_name)
    #dir_flag = os.path.splitext(csv_name)[0] #_*_lse // _synp
    if os.path.isdir(case_path):
        for dir in os.listdir(case_path):
            if dir in ['models','others','source']:
                continue
            dir_add = os.path.join(case_path,dir) # _scratch
            if os.path.isdir(dir_add):
                pass
            else:
                continue
            for dir_add_add in os.listdir(dir_add):
                dir2 = os.path.join(dir_add,dir_add_add) #impl , target
                if os.path.isdir(dir2) :
                    for f in os.listdir(dir2):
                        f  = os.path.join(dir2,f)  # file
                        if os.path.isfile(f):
                            f2 = f
                            if os.path.isfile(f2) and f2.endswith('mrp') and (not spread_grade): #get spread_grade
                                    f_hand = file(f,'r')
                                    lines = f_hand.readlines()
                                    f_hand.close()
                                    for line in lines:
                                        if line.find('Target Performance:')!= -1:
                                            line_content = line.split(':')
                                            spread_grade = line_content[1].strip()
                                            break
                            if os.path.isfile(f2) :
                                        if f2.endswith('edi') or f2.endswith('edn') or f2.endswith('edf'):
                                            file_hand = file(f2,'r')
                                            lines = file_hand.readlines()
                                            file_hand.close()
                                            for line in lines:
                                                if line.find('program')!= -1:  #(program "Synplify Pro" (version "G-2012.09L beta, mapper maplat, Build 489R"))
                                                    line_content = line.split('program')
                                                    synthesis_tool = line_content[1]
                                                    if synthesis_tool.find('lse')!= -1:
                                                        synthesis_tool = 'lse'
                                                    else:
                                                        syn_re = re.compile(r'version\s+(.+?)\s+')
                                    
                                                        syn_cmp = syn_re.search(synthesis_tool)
                                                        if syn_cmp:
                                                            synthesis_tool = syn_cmp.group(1)
                                                            synthesis_tool = re.sub(r'[^\w]','',synthesis_tool)
                                                            synthesis_tool = 'synp'+synthesis_tool
                                                        else:
                                                            synthesis_tool = 'lse' 
                                                    break
                        if f.find('rev_1')!= -1: # get synthesis tool
                            if os.path.isdir(f):
                                for dir_list in os.listdir(f):
                                    dir_list = os.path.join(f,dir_list)
                                    #if os.path.isfile(dir_list) and (not synthesis_tool):
                                    if os.path.isfile(dir_list):
                                        if dir_list.endswith('edi') or dir_list.endswith('edn') or dir_list.endswith('edf'):
                                            file_hand = file(dir_list,'r')
                                            lines = file_hand.readlines()
                                            file_hand.close()
                                            for line in lines:
                                                if line.find('program')!= -1:  #(program "Synplify Pro" (version "G-2012.09L beta, mapper maplat, Build 489R"))
                                                    line_content = line.split('program')
                                                    synthesis_tool = line_content[1]
                                                    
                                                    if synthesis_tool.find('lse')!= -1:
                                                        synthesis_tool = 'lse'
                                                    else:
                                                        syn_re = re.compile(r'version\s+(.+?)\s+')
                                    
                                                        syn_cmp = syn_re.search(synthesis_tool)
                                                        if syn_cmp:
                                                            synthesis_tool = syn_cmp.group(1)
                                                            synthesis_tool = re.sub(r'[^\w]','',synthesis_tool)
                                                            synthesis_tool = 'synp'+synthesis_tool
                                                        else:
                                                            synthesis_tool = 'lse' 
                                                    break
                        if (not spread_grade) or (not synthesis_tool):
                            if f.endswith('syr') and os.path.isfile(f): #get xst for xilinx
                                f_hand  = file(f)
                                f_lines = f_hand.readlines()
                                for f_line in f_lines:
                                    if f_line.find('Release')!= -1:
                                        # Release 14.3 - xst P.40xd (nt64)
                                        synthesis_tool = f_line
                                        synthesis_tool = synthesis_tool.replace('Release','')
                                        synthesis_tool = 'XST'+re.sub('\s+','_',synthesis_tool)          
                            if f.find('Target')!= -1 and os.path.isfile(f):
            
                                if 1:
                                    f_f = f
                                    if f_f.endswith('fit.rpt'): #for alter
                                        f_f_hand = file(f_f,'r')
                                        f_f_lines = f_f_hand.readlines()
                                        f_f_hand.close()
                                        for f_line in f_f_lines:
                                            if f_line.find('Quartus')!= -1 and sw=='None':
                                                qua_re = re.compile(r'Version\s+(\S+)\s+Build')
                                                que_re_cmp = qua_re.search(f_line)
                                                if que_re_cmp:
                                                    sw = 'Quartus' +que_re_cmp.group(1)
                                                else:
                                                    sw = 'Quartus'
                                                if f_line.find('64-Bit')!= -1:
                                                    sw = sw + '(64bit)'
                                            speed_re = re.compile(r'^; Device\s+;\s+(\S+)')
                                            speed_re_cmp = speed_re.search(f_line)
                                            if speed_re_cmp:
                                                spread_grade = speed_re_cmp.group(1)[-1]
                                                
                                            if spread_grade and sw:
                                                break
                                    #-------------for xilinx -----------------#
                                    if f_f.endswith('.par'):
                                        f_f_hand = file(f_f,'r')
                                        f_f_lines = f_f_hand.readlines()
                                        f_f_hand.close()
                                        for f_line in f_f_lines:
                                            if f_line.find('Release')!= -1:
                                                ise_re = re.compile(r'Release\s+(\S+)')
                                                ise_re_cmp = ise_re.search(f_line)
                                                if ise_re_cmp:
                                                    sw = 'ISE' +ise_re_cmp.group(1)
                                                else:
                                                    sw = 'ISE'
                                                if f_line.find('nt64')!= -1:
                                                    sw = sw + '(64bit)'
                                                                                  
                                            if  sw:
                                                break
                                    if f_f.endswith('.mrp'):
                                        f_f_hand = file(f_f,'r')
                                        f_f_lines = f_f_hand.readlines()
                                        f_f_hand.close()
                                        for f_line in f_f_lines:
                                            if not spread_grade:
                                                ise_re = re.compile(r'Target Speed\s+:\s+(\S+)')
                                                ise_re_cmp = ise_re.search(f_line)
                                                if ise_re_cmp:
                                                    spread_grade = ise_re_cmp.group(1)
                                                else:
                                                    pass
                                                                                  
                                            if  spread_grade:
                                                break
                                    if spread_grade and sw:
                                        break          
                            if f.find('rev_1')!= -1 and os.path.isdir(f):
                                for f_srr in os.listdir(f):
                                    f_srr = os.path.join(f,f_srr)
                                    if os.path.isfile(f_srr) and f_srr.endswith('srr'):
                                        f_srr_hand = file(f_srr)
                                        f_srr_lines = f_srr_hand.readlines()
                                        f_srr_hand.close()
                                        for f_srr_line in f_srr_lines:
                                            ##Build: Synplify Pro G-2012.09-SP1 , Build 168R, Nov 26 2012
                                            syn_re = re.compile(r'Build: Synplify Pro\s+(\S+)')
                                            syn_re_cmp = syn_re.search(f_srr_line)
                                            if syn_re_cmp:
                                                synthesis_tool = syn_re_cmp.group(1)
                                                synthesis_tool = re.sub(r'[^\w]','',synthesis_tool)
                                                synthesis_tool = 'synp'+syn_re_cmp.group(1)
    else:
        pass
                            
    #------------------------------END---------------------------------------------------#
    fmax_average = []
    for key,value in design_line_dic.items():
        pass_points = 0
        for result in value:
            my_focus_float = my_float(result.get(col_key,0))
            if my_focus_float > 0:
                pass_points += 1
        sort_value = list()
        for result in value:
            my_focus_float = my_float(result.get(col_key,0))
            t = result.copy()
            t["passPoints"] = pass_points
            sort_value.append((my_focus_float, t))
        sort_value.sort()
       
        all_sum = 0
        all_num = 0
        best_num = 0
        for item in value:
            try:
                v = float(item.get(col_key,0))
                all_sum = all_sum + v
                all_num = all_num + 1
                if v > best_num:
                    best_num = v
            except:
                pass
        try:
            v = all_sum/all_num
            v = float("%.3f"%v)
            v = str(v)
            fmax_average.append(str(v))
        except:
            fmax_average.append('-')
            v = '-'
        if add_average:
             (sort_value[-1][1]).update({'Average_famx':v})
             (sort_value[-1][1]).update({'Best_famx':best_num})
             use_lines.append(sort_value[-1][1])
        else:
             use_lines.append(sort_value[-1][1])
            
    cases = design_line_dic.keys()
    cases.sort()
    not_run  = set(cases_list) - set(cases)
    not_run = ' ,'.join(not_run) + '\n'
    not_run = ''
    if not fail_log:

            csv_path = os.path.join(os.path.dirname(case_path),'fail_case.log')
            csv_files = glob.glob(csv_path)
    else:
        csv_files = [fail_log]
    fail_lines= []
    for f in csv_files:
        file_hand_fail = file(f,'r')
        fail_lines  = file_hand_fail.readlines()
        file_hand_fail.close()

    for fail_line in fail_lines:
        if fail_line.strip():
            not_run = not_run+','+fail_line
        else:
            pass
        
    #----------------------------- Add the infor to note ------------------------------#
    sw_line = '[SW]:,'+sw
    synthesis_tool_line = '[synthesis]:,'+synthesis_tool
    spread_grade_line = '[Speed grade]:,'+spread_grade
    target_fmax_line = '[Target Fmax]:,'+fmax_note
    not_run_line = '[Note]:'+not_run
    date_line = '[Updated date]:,'+report_time
    note.append(sw_line)
    note.append(synthesis_tool_line)
    note.append(spread_grade_line)
    note.append(target_fmax_line)
    note.append(not_run_line)
    note.append(date_line)
    #------------------------------END ------------------------------------------------#
    use_lines = [(item['Design'],item) for item in use_lines]
    #use_lines.sort()
    #use_lines = [item[1] for item in use_lines]
    title = title.split(',')
    if add_average:
        title.append('Average_famx')
        title.append('Best_famx')
        title2 = ['Design','Version','Device','Slice','Register','LUT','Average_famx','fmax','twrLabel']
        dict_writer2 = csv.DictWriter(file(name_sorted+'_DSP'+'.csv', 'wb'), fieldnames=title2)
    dict_writer = csv.DictWriter(file(file_sorted, 'wb'), fieldnames=title)
    for item in title:
       title_dic[item] = item
       default_values[item]='_'
    dict_writer.writerow(title_dic)
    if add_average:
        title2_dic={}
        default2_values={}
        for item in title2:
            title2_dic[item] = item
            default2_values[item]='_'
        dict_writer2.writerow(title2_dic)
    ##############################################
    for case in cases_list:
        if case in cases:
            for item in use_lines:
                if add_average and  item[0].lower() == case.lower():
                    use_dic = {}
                    for t in title2:
                        try:
                            use_dic[t] = (item[1]).get(t,'-')
                        except:
                            use_dic[t] = '-'
                    dict_writer2.writerow(use_dic)
                    
                if item[0].lower() == case.lower():
                   dict_writer.writerow(item[1])
                   temp_t_f = str(item[1]['targetFmax'])
                   #if temp_t_f.find('.')!= -1:
                   if re.search('\.[1-9]',temp_t_f):
                       temp_value = '-'
                   else:
                       temp_value = item[1]['targetFmax']
                   design_fmax[item[1]['Design'] ]= temp_value
                   break
        else:
            default_values['Design']=case
            dict_writer.writerow(default_values)
            design_fmax[case]= '_'
            if add_average:
                use_dic = {}
                for t in title2:
                    try:
                        use_dic[t] = (item[1]).get(t,'-')
                    except:
                        use_dic[t] = '-'
                #dict_writer2.writerow(use_dic)
            
    ##############################################
    '''for item in use_lines:
      dict_writer.writerow(item)
      design_fmax[item['Design'] ]= item['fmax'] '''
    file_all_hand =  csv.DictWriter(file(all_record,'wb'),fieldnames=title)
    file_all_hand.writerow(title_dic)
    for case in cases:
        #print case,len(design_line_dic[case])
        value = design_line_dic[case]
        all_sort, pass_points = list(), 0
        for result in value:
            my_focus_float = my_float(result.get(col_key,0))
            if my_focus_float > 0:
                pass_points += 1
        all_sort = [(my_float(item.get(col_key,0)),item) for item in value ]
        all_sort.sort()
        for item in all_sort:
            my_line = item[1]
            my_line["passPoints"] = pass_points
            #print item[1]['Design']
            file_all_hand.writerow(my_line)
    #file_all_hand.close()
    return (file_sorted,note,design_fmax)
def write_note(file_sorted,note=[]):
    file_hand = file(file_sorted,'r')
    lines  = file_hand.readlines()
    file_hand.close()
    file_hand = file(file_sorted,'w')
    for line in note:
        file_hand.write(line+'\n')
    for line in lines:
        file_hand.write(line)
    file_hand.close() 
def get_best_all_clk(file_sorted):
    '''
        first, read the _sorted csv file, get the desig name and targetFmax
        second, read all_clk and get the targetFmax line 
        thrid, write to best_all_clk.csv
    '''
    if not os.path.isfile(file_sorted):
        return
    all_clk = os.path.join( os.path.dirname(file_sorted),"all_clk.csv")
    best_clk =  os.path.join( os.path.dirname(file_sorted),"best_all_clk.csv")
    if os.path.isfile(all_clk):
        pass
    else:
        return
    hot_lines = []
    for id1,line in enumerate(open(file_sorted)):
        hot_lines.append(line)     
    ori_dict = csv.DictReader(hot_lines)
    design_targetFmax = []
    for id1,item in enumerate(ori_dict):
        try:
            targetFmax = int(float(item.get("targetFmax","")))
        except:
            targetFmax = ""
        temp = ( item.get("Design",""),targetFmax )
        design_targetFmax.append(temp) 
    hot_lines = []
    for id1,line in enumerate(open(all_clk)):
            hot_lines.append(line) 
            
    ori_dict2 = csv.DictReader(hot_lines)
    if not ori_dict2.fieldnames:
        titles = ['Design','Target_Fmax_Dir','clkName','targetFmax','fmax']
    else:
        titles = ori_dict2.fieldnames
    dict_writer = csv.DictWriter(file(best_clk, 'wb'), fieldnames=titles)
    dict_writer.writerow( dict( zip(titles,titles) ) )
    for id1,item in enumerate(ori_dict2):
        design = item.get("Design","-")
        Target_Fmax_Dir = int(float(item.get("Target_Fmax_Dir","-") ))
        try:
            Target_Fmax_Dir = int(float(item.get("Target_Fmax_Dir","")))
        except:
            Target_Fmax_Dir = "-"
        for design_targetFmax_item in design_targetFmax:
            if (design,Target_Fmax_Dir) == design_targetFmax_item:
                dict_writer.writerow(item)
    
    
if __name__=='__main__':
    csv_file=r'D:\shwan_new_structure\ecp3_run\_ecp3_report.csv'
    file_sorted,note,design_fmax = sort_csv(csv_file)
    write_note(file_sorted,note) 