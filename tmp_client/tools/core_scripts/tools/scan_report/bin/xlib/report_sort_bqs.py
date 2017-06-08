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
import os,sys,re
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
    try:
      value = float(string)
    except:
      if str(string).lower() == 'none':
         value = 0
      else:
         value = -1
    return value
 
def find_note(case_dir,info_line):
    note_case = info_line.split(',')
    sw = ''
    for item in note_case:
        if item.find('Diamond')!= -1:
            sw = item
            break
    run_fail = ''
    spread_grade = ''
    synthesis_tool = ''
    # r'Diamond (64-bit) 2.2.0.35'
    # r'Diamond Version 2.2.0.60'
    sw_re = re.compile(r'Diamond\s+(.+)\s+([\d \.]+)')
    if sw != '':
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
    report_time = time.asctime()
    # get the path of the case 
    # read the mrp file
    # get the line "Target Performance:   8"
    case_path = os.path.abspath(case_dir)
    if not os.path.isdir(case_path):
        return [' ']*5
    #dir_flag = os.path.splitext(csv_name)[0] #_*_lse // _synp
    for dir in os.listdir(case_path):
        dir = os.path.join(case_path,dir) #impl , target
        if os.path.isdir(dir) :
            for f in os.listdir(dir):
                f  = os.path.join(dir,f)  # file
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
                                
                                
                    if f.find('Target')!= -1 and os.path.isdir(f):
                        for f_f in os.listdir(f):
                            f_f = os.path.join(f,f_f)
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
    return [sw,synthesis_tool,spread_grade,run_fail,report_time]
def sort_csv(csv_file,to_path,col_key='fmax',case_dir='',info_line=''):
    '''
        csv_file: the signal case result
        to_path : where the result csv file will be stored
        1 : get all the case result to the *_all.csv file
        2 : get the best col_key to the *_sorted.csv file
        
    '''
    fmax_note = '' # for note
    if not  os.path.isfile(csv_file):
        print 'can not get the %s file'%csv_file
        return -1
    to_path = os.path.abspath(to_path)
    
    if not os.path.isdir(to_path):
        print 'can not find the path: %s'%to_path
        return 
    
    #-------------- collect all the result -------------
    # the first line is the title line
    file_hand = file(csv_file)
    file_lines = file_hand.readlines()
    file_hand.close()
    col_id = ''
    try:
        title_line = file_lines[0]
        title_list = title_line.split(',')
        for id1,t in enumerate(title_list):
            if t.lower() == col_key.lower():
                col_id = id1
                break
    except:
        print 'the file:%s has no result or the key:%s'%(csv_file,col_key)
        return
                
    try:
        useful_lines = file_lines[1:]
    except:
        print 'the file:%s has no result'%csv_file
        return
    all_result = os.path.basename(to_path)
    all_result = os.path.join(to_path,all_result)+'_all.csv'
    col_id_value = 0
    col_id_best = ''
    if os.path.isfile(all_result):
        all_hand  = file(all_result,'a')
        for line in useful_lines:
            all_hand.write(line)
            line_list = line.split(',')
            if my_float(line_list[col_id]) >= col_id_value:
                col_id_value = my_float(line_list[col_id])
                col_id_best = line
        all_hand.close()
    else:
        all_hand  = file(all_result,'w')
        all_hand.write(title_line)
        for line in useful_lines:
            all_hand.write(line)
            line_list = line.split(',')
            if my_float(line_list[col_id]) >= col_id_value:
                col_id_value = my_float(line_list[col_id])
                col_id_best = line
        all_hand.close()
    
    if col_id_best:
        all_result = os.path.basename(to_path)
        all_result = os.path.join(to_path,all_result)+'_sorted.csv'
        if os.path.isfile(all_result):
            file_hand = file(all_result,'a')
            file_hand.write(col_id_best)
            file_hand.close()
        else:
            file_hand = file(all_result,'w')
            file_hand.write(title_line)
            file_hand.write(col_id_best)
            file_hand.close()
        if 1: # this part used for the sorted report!
            '''
                1. read all lines
                2. select the case_list_order
                3. write the report as the order
                4. write the note to the head of the file
            '''
            file_hand = file(all_result)
            all_lines_total =  file_hand.readlines()
            file_hand.close()
            all_lines = []
            note = []
            for id1,line in enumerate(all_lines_total):
                if line.startswith('Design'):
                    all_lines = all_lines_total[id1:]
                    break
                else:
                    note.append(line)
            if len(all_lines)<2:
                return
            design_line = all_lines[1]
            design = design_line.split(',')[0]
            find_it = 0
            for group,cases in group_cases.items():
                if design in cases:
                    group_name = group
                    cases_list = cases
                    find_it = 1
                    try:
                        fmax_note =  note_fmax_dic[group.lower()]
                    except:
                        fmax_note = ''
                    #print cases_list
                    break
            if find_it ==0:
                return
            else:
                rewrite_line = []
                rewrite_line.append(all_lines[0])
                for case in cases_list:
                    find_case_line = 0
                    for line in all_lines[1:]:
                        line_list = line.split(',')
                        #if line.startswith(case):
                        if line_list[0] == case:
                            rewrite_line.append(line)
                            find_case_line = 1
                            break
                    '''if find_case_line == 0:
                        case_null = case+','*(len(all_lines[0])-1)+'\n'
                        rewrite_line.append(case_null)'''
                if not note:
                    sw,synthesis_tool,spread_grade,run_fail,report_time = find_note(case_dir,info_line)
                    sw_line = '[SW]:,'+sw+'\n'
                    synthesis_tool_line = '[synthesis]:,'+synthesis_tool+'\n'
                    spread_grade_line = '[Speed grade]:,'+spread_grade+'\n'
                    target_fmax_line = '[Target Fmax]:,'+fmax_note+'\n'
                    not_run_line = '[Note]:'+run_fail+'\n'
                    date_line = '[Updated date]:,'+report_time+'\n'
                    note.append(sw_line)
                    note.append(synthesis_tool_line)
                    note.append(spread_grade_line)
                    note.append(target_fmax_line)
                    note.append(not_run_line)
                    note.append(date_line)
                file_hand = file(all_result,'w')
                file_hand.writelines(note)
                file_hand.writelines(rewrite_line)
                file_hand.close()
                            
            
            
            



            
if __name__=='__main__':
    csv_file=r'D:\shwan_new_structure\ecp3_run\_ecp3_report.csv'
    file_sorted,note,design_fmax = sort_csv(csv_file)
    #write_note(file_sorted,note) 