import os,time
import sys
import write_csv_class
import write_excel_class2
import style
from pyExcelerator import *

if __name__=='__main__':
    try:
        file_list = sys.argv[1]
    except:
        file_list =  'file_conf.list'
    try:
        param_conf = sys.argv[2]
    except:
        param_conf = ''
    try:
        excel_name = sys.argv[3]
    except:
        excel_name = 'test'
    file_hand = file(file_list,'r')
    lines = file_hand.readlines()
    file_hand.close()
    file_name_list = []
    return_dic_list = []
    return_all_dic={}
    wb = Workbook()
    
    name = excel_name+'.xls' 
    if os.path.isfile(name):
        print('Warning: %s has been exists'%name)
        time.sleep(20)
    write_total = ''
    done = ''
    print('Please wait ....')
    for line in lines:
        line = line.strip()
        if line.find('--no-fmax')!= -1:
            write_total = 1
        if not write_total and not done:
            statistic = wb.add_sheet('QoR_data_Summary')
            done = 1
        if not line or line.startswith('#'):
            continue
        else:
            write_csv_class.for_QoR(line,param_conf)
            return_dic = write_excel_class2.forQoR(line,wb,param_conf)
            return_all_dic.update(return_dic)
    if not write_total:
        #statistic = wb.add_sheet('QoR_data_Summary')
        write_excel_class2.write_total_summay(statistic,10, return_all_dic)
    wb.save(name)
        