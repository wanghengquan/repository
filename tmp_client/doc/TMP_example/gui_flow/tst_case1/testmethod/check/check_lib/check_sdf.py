import os
import sys
import re;
#gloden_lines = file(os.path.join(os.path.dirname(__file__),'demo.sdf'),'r').readlines()
all_resource_re = [
'^\(\s*DELAYFILE$',                                                                              #DELAYFILE
'^\(\s*SDFVERSION\s+"\d\.\d"\s*\)',                                                                #SDFVERSION
'^\(\s*DESIGN\s+"[^"]+"\s*\)',                                                                     #DESIGN
'^\(\s*DATE\s+"[^"]+"\s*\)',                                                                       #DATE
'^\(\s*VENDOR\s+"[^"]+"\s*\)',                                                                     #VENDOR
'^\(\s*PROGRAM\s+"[^"]+"\s*\)',                                                                    #PROGRAM
'^\(\s*VERSION\s+"[^"]+"\s*\)',                                                                    #VERSION
'^\(\s*DIVIDER\s+/\s*\)',                                                                          #DIVIDER
'^\(\s*VOLTAGE\s+[0-9.]+\s*:[0-9.]+\s*:[0-9.]+\s*\)',                                              #VOLTAGE
'^\(\s*PROCESS\s+"[^"]+"\s*\)',                                                                    #PROCESS
'^\(\s*TEMPERATURE\s+[-0-9]+\s*:[-0-9]+\s*:[-0-9]+\s*\)',                                          #TEMPERATURE
'^\(\s*TIMESCALE\s+\d[mpu]+s\s*\)',                                                                #TIMESCALE
'^\(\s*CELL$',                                                                                      #CELL
'^\(\s*CELLTYPE\s+"[^"]+"\s*\)',                                                                   #CELLTYPE
'^\(\s*INSTANCE\s+[\S]+\s*\)|^\(\s*INSTANCE\s+\)',                                                  #INSTANCE  ->  (INSTANCE ) or (INSTANCE fir_0_SLICE_0I)
'^\(\s*DELAY$',                                                                                  #DELAY
'^\(\s*ABSOLUTE$',                                                                               #ABSOLUTE
'^\(\s*TIMINGCHECK$',                                                                            #TIMINGCHECK
'^\(\s*SETUPHOLD\s+[\S]+\s+\([posneg]{3}edge\s+[^)]+\)\s+\([0-9.-]+\s*:[0-9.-]+\s*:[0-9.-]+\s*\)\s*\([0-9.-]+\s*:[0-9.-]+\s*:[0-9.-]+\s*\)\)|^\(\s*SETUPHOLD\s+\([posneg]{3}edge\s+[^)]+\)\s+\([posneg]{3}edge\s+[^)]+\)\s+\([0-9.-]+\s*:[0-9.-]+\s*:[0-9.-]+\s*\)\s*\([0-9.-]+\s*:[0-9.-]+\s*:[0-9.-]+\s*\)\)',           #SETUPHOLD
'^\(\s*WIDTH\s+\(\w{3}edge\s+[\S]+?\)\s+\([0-9.]+\s*:[0-9.]+\s*:[0-9.]+\s*\)',                     #WIDTH
'^\(\s*INTERCONNECT\s+[\S]+\s+[\S]+\s+\([0-9.]*\s*:[0-9.]*\s*:[0-9.]*\s*\)\s*\([0-9.]*\s*:[0-9.]*\s*:[0-9.]*\s*\)\)',                       #(INTERCONNECT SLICE_69I/F0 SLICE_0I/D1 (0:0:0)(0:0:0))  
'^\(\s*IOPATH\s+[\S]+\s+[\S]+\s+(\([0-9.]*\s*:[0-9.]*\s*:[0-9.]*\s*\)\s*){2,6}\)|^\(\s*IOPATH\s+\([posneg]{3}edge\s+[^)]+\)\s+[\S]+\s+\([0-9.]*\s*:[0-9.]*\s*:[0-9.]*\s*\)\s*\([0-9.]*\s*:[0-9.]*\s*:[0-9.]*\s*\)\)'                               #IOPATH        
];
all_resource = [
                'DELAYFILE',
                'SDFVERSION',
                'DESIGN',
                'DATE',
                'VENDOR',
                'PROGRAM',
                'VERSION',
                'DIVIDER',
                'VOLTAGE',
                'PROCESS',
                'TEMPERATURE',
                'TIMESCALE',
                'CELL',
                'CELLTYPE',
                'INSTANCE',
                'DELAY',
                'ABSOLUTE',
                'TIMINGCHECK',
                'SETUPHOLD',
                'WIDTH',
                'INTERCONNECT',
                'IOPATH'      
            ]
all_resource_special = [
            'DELAYFILE',
            'CELL',
            'DELAY',
            'ABSOLUTE',
            'TIMINGCHECK',
            ]
all_resource_layer = [
                'CELLTYPE',
                'INSTANCE',
                'SETUPHOLD',
                'WIDTH',
                'INTERCONNECT',
                'IOPATH'
            ]
def run_sdf_check_old(check_dir):
    if os.path.isdir(check_dir):
        pass
    else:
        print 'Error: can not find directory %s'%check_dir
         
    log_hand = file(os.path.dirname(os.path.abspath(__file__))+r'\sdf_check.csv','w')
    for root1,dir1,files in os.walk(check_dir):
        for f in files:
            if f.endswith('.sdf'):
                f = os.path.join(root1,f)
                getline = sdf_check(f)
                log_hand.write(getline+'\n')
    log_hand.close()
def run_sdf_check(check_dir):
    if os.path.isdir(check_dir):
        pass
    else:
        return ['Fail', 'Error: can not find directory %s'%check_dir]
    return_list = ['True','']
    for root1,dir1,files in os.walk(check_dir):
        for f in files:
            if f.endswith('.sdf'):
                f = os.path.join(root1,f)
                return_list[1] += sdf_check(f)
    if return_list[1].find('Error')!= -1:
        return_list[0] = 'Fail'
        
    return return_list
    
def sdf_check(check_file):
    print check_file
    if os.path.isfile(check_file):
        pass
    else:
        return '%s,can not get file'%check_file
    gloden_lines = file(check_file).readlines()
    re_str = [re.compile(url, re.I) for url in all_resource_re];
    re_dict = dict( zip(all_resource,re_str) )
    file_begin = '';
    cell_begin = '';
    delay_begin = '';
    absolute_begin = '';
    timingcheck_begin = '';
    connect_next_line = 0
    old_line = ''
    for id1,l in enumerate( gloden_lines ):
        l = l.strip()
        l = re.sub('\s+',' ',l)
        if not l:
            continue
        if old_line:
            l = old_line + ' '+l
        if l == '(':
            old_line = l
            connect_next_line += 1
        if connect_next_line >=4:
                print l
                return '%s,Error, connect too many lines from:%s'%(check_file,str(id1-4))
                
        else:
            if not file_begin:
                if re.search(re_dict['DELAYFILE'],l):
                    file_begin = 1
                    old_line = ''
                    connect_next_line = 0
                    continue
                else:
                    return '%s,Error content in line:%s'%(check_file,str(id1+1))
                    
            if not cell_begin:
                if re.search(re_dict['CELL'],l):
                    cell_begin = 1
                    old_line = ''
                    connect_next_line = 0
                    continue
                else:
                    pass
            else:
                if re.search(re_dict['CELL'],l):
                    cell_begin += 1
                    old_line = ''
                    connect_next_line = 0
                    continue
                else:
                    pass
            if not delay_begin:
                if re.search(re_dict['DELAY'],l):
                    delay_begin = 1
                    old_line = ''
                    connect_next_line = 0
                    if not cell_begin:
                        return '%s,Error, Can not find DELAY flag before CELL at line :%s'%(check_file,str(id1+1))
                        
                    continue
                else:
                    pass
            else:
                if re.search(re_dict['DELAY'],l):
                    delay_begin += 1
                    old_line = ''
                    connect_next_line = 0
                    if not cell_begin%2:
                        return '%s,Error, Can not find DELAY flag before CELL at line :%s'%(check_file,str(id1+1))
                         
                    continue
                else:
                    pass
            if not absolute_begin:
                if re.search(re_dict['ABSOLUTE'],l):
                    absolute_begin = 1
                    old_line = ''
                    connect_next_line = 0
                    if not cell_begin:
                        return '%s,Error, Can not find ABSOLUTE flag before CELL at line :%s'%(check_file,str(id1+1))
                         
                    if not delay_begin:
                        return '%s,Error, Can not find ABSOLUTE flag before DELAY at line :%s'%(check_file,str(id1+1))
                         
                    continue
                else:
                    pass 
            else:
                if re.search(re_dict['ABSOLUTE'],l):
                    absolute_begin += 1
                    old_line = ''
                    connect_next_line = 0
                    if not cell_begin%2:
                        return '%s,Error, Can not find ABSOLUTE flag before CELL at line :%s'%(check_file,str(id1+1))
                         
                    if not delay_begin%2:
                        return '%s,Error, Can not find ABSOLUTE flag before DELAY at line :%s'%(check_file,str(id1+1))
                         
                    continue
                else:
                    pass
            if not timingcheck_begin:
                if re.search(re_dict['TIMINGCHECK'],l):
                    timingcheck_begin = 1
                    old_line = ''
                    connect_next_line = 0
                    if not cell_begin:
                        return '%s,Error, Can not find DELAY flag before CELL at line :%s'%(check_file,str(id1+1))
                         
                    continue
                else:
                    pass
            else:
                if re.search(re_dict['TIMINGCHECK'],l):
                    timingcheck_begin = 1
                    old_line = ''
                    connect_next_line = 0
                    if not cell_begin%2:
                        return '%s,Error, Can not find DELAY flag before CELL at line :%s'%(check_file,str(id1+1))
                         
                    continue
                else:
                    pass
                    
            if l == ')':
                old_line = ''
                connect_next_line = 0
                if timingcheck_begin and timingcheck_begin%2:
                    timingcheck_begin += 1
                    continue
                if absolute_begin and absolute_begin%2:
                    absolute_begin += 1
                    continue
                if delay_begin and delay_begin%2:
                    delay_begin += 1
                    continue
                if cell_begin and cell_begin%2:
                    cell_begin += 1
                    continue
                if file_begin and file_begin%2:
                    file_begin += 1
                    continue
                else:
                    print 'Error: can not find the corresponding level'
            if 1:
                find_it = 0
                for item in all_resource:
                    if item in all_resource_special:
                        continue
                    if item in all_resource_layer:
                        continue
                    if re.search(re_dict[item],l):
                        find_it = 1 
                        break
                if re.search(re_dict['CELLTYPE'],l):
                    
                    if cell_begin and cell_begin%2:
                        find_it = 1
                    else:
                        return '%s,Error: find CELLTYPE before CELL at line:%s'%(check_file,str(id1+1))
                         
                if re.search(re_dict['INSTANCE'],l):
                    
                    if cell_begin and cell_begin%2:
                        find_it = 1
                    else:
                        return '%s,Error: find INSTANCE before CELL at line:%s'%(check_file,str(id1+1))
                         
                        
                if re.search(re_dict['IOPATH'],l):
                    if cell_begin and cell_begin%2 and delay_begin and delay_begin%2 and absolute_begin and absolute_begin%2:
                        find_it = 1
                    else:
                        return '%s,Error: find IOPATH before absolute_begin/delay_begin at line:%s'%(check_file,str(id1+1))
                         
                        
                if re.search(re_dict['INTERCONNECT'],l):
                    if cell_begin and cell_begin%2 and delay_begin and delay_begin%2 and absolute_begin and absolute_begin%2:
                        find_it = 1
                    else:
                        return '%s,Error: find INTERCONNECT before absolute_begin/delay_begin at line:%s'%(check_file,str(id1+1))
                         
                     
                if re.search(re_dict['SETUPHOLD'],l):
                    if cell_begin and cell_begin%2 and timingcheck_begin and timingcheck_begin%2 :
                        find_it = 1
                    else:
                        return '%s,Error: find SETUPHOLD before timingcheck_begin/cell_begin at line:%s'%(check_file,str(id1+1))
                         
                if re.search(re_dict['WIDTH'],l):
                    if cell_begin and cell_begin%2 and timingcheck_begin and timingcheck_begin%2 :
                        find_it = 1
                    else:
                        return '%s,Error: find WIDTH before timingcheck_begin/cell_begin at line:%s'%(check_file,str(id1+1))
                         
                        
                if find_it == 1:
                    old_line = ''
                    connect_next_line = 0
                    continue
                else:
                    old_line = l
                    connect_next_line += 1
                    continue
                              
    if 1:
        if timingcheck_begin and  timingcheck_begin%2:
           return '%s,Error, can not find the begin/end of TIMINGCHECK'%(check_file)
        if absolute_begin and  absolute_begin%2:
            return '%s,Error, can not find the begin/end of ABSOLUTE'%(check_file)
        if delay_begin and  delay_begin%2:
            return '%s,Error, can not find the begin/end of DELAY'%(check_file)
        if cell_begin and  cell_begin%2:
            return '%s,Error, can not find the begin/end of CELL'%(check_file)
            
        if not file_begin or file_begin%2:
            return '%s,Error, can not find the begin/end of DELAYFILE'%(check_file)
    return '%s,pass'%check_file
    
if __name__ == '__main__':
    #run_sdf_check(r'\\d27817\test_dir\strdom\__diamond3.3.0.65\Back_annotation\all_cases\ECP5U')
    #run_sdf_check(r'\\d27817\test_dir\strdom\__diamond3.3.0.65\Back_annotation\all_cases')
    #run_sdf_check(r'C:\Users\yzhao1\Desktop\zzzz\w')
    try:
        run_dir = sys.argv[1]
    except:
        run_dir = os.getcwd()
    run_sdf_check(run_dir)
    