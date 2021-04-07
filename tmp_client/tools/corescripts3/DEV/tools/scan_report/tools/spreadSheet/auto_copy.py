'''
Created on 2012-11-5

@author: yzhao1
'''
import os
import sys
import shutil,time
import re
import glob
def get_cmd_value(str,cmd):
    '''
    This function used to get the comand value from a line.
    str is the comand line
    cmd is the name you want to return
    EXAMPLE: 
         '*** *** --comand=value *** ***'
         the return is "value" 
    '''
    cmd =  '--'+cmd
    cmd_re = re.compile(r"""%s\s?=\s?([\w : \\ _ - \. ]+)
                    ($
                    |\s+--)"""%cmd,re.VERBOSE)
    cmd_compile = cmd_re.search(str)
    if cmd_compile:
        return (cmd_compile.group(1)).strip()
    else:
        print('Nothing find')
        return 
    
    
def get_src_data(file_name,get_sweeping=0):
    '''
    At here the file_name command should be like this:
    python for_svn.py  --suite=S24_sc   --top-dir=D:\new_all\trunk   --run-synpwrap  --job-dir=D:\new_all\run  --x64 --diamond=C:\lscc\diamond\2.2_x64
    
    this is just a line of the bat.
    Then the script will parse the line. Get the data from top_dir and job_dir.
    the data in the top_dir is top_dir\suite\*_sorted.csv   this file will named as: family + diamond + synplify +standard01.csv
    the data in the job_dir is job_dir\suite\*_sorted.csv, *_sort_all.csv.  
                                                            the first file will name as family + diamond + synplify+.csv
                                                            the next file will name as  family + diamond + synplify_all+.csv
    if --sweeping exists in the line(auto_copy bat file), the sweeping data will be used to compare!
    '''
    file_hand = file(file_name,'r')
    lines = file_hand.readlines()
    file_hand.close()
    files = []
    for_ini={}
    src_files = ['-']*len(lines)  # this is the return data
    for id1,item in enumerate(lines):
        item = item.strip()
        suite = get_cmd_value(item,'suite')
        top_dir = get_cmd_value(item,'top-dir')
        job_dir = get_cmd_value(item,'job-dir')
        impl = get_cmd_value(item,'impl')
        if (not suite) or (not top_dir) or (not job_dir):
            continue
        else:
            pass
        if not os.path.isdir('src'):
            try:
                os.mkdir('src')
                curr_dir = 'src'
            except:
                print('can not make src directory')
        else:
            curr_dir = 'src'
        #if item.find('--sweeping') == -1:
        if get_sweeping == 0:
            top_file = glob.glob(os.path.join(top_dir,suite,'*_sorted.csv') )
            if not top_file:
                print("can not  find top_file in:%s"%suite)
                print(os.path.join(top_dir,suite,'*_sorted.csv'))
                continue
            #----------------------- Get the top_dir file
            top_file = top_file[0]
            #curr_dir = os.getcwd()
            basename = os.path.join(curr_dir, os.path.basename(top_file) )
            shutil.copy2(top_file, basename ) # copy the file to local
            file_hand = file(basename,'r')
            all_line = file_hand.readlines()
            file_hand.close()
            sw = ''
            syn = ''
            for a_l in all_line:
                if a_l.find(r'[SW]:') != -1:
                    al = a_l.split(r'[SW]:')
                    sw = al[1]
                if a_l.find(r'[synthesis]') != -1:
                    al = a_l.split(r'[synthesis]:')
                    syn = al[1][:40]
                if syn and sw:
                    break
            
            new_name = (suite).strip() +'_'+ sw.strip() +'_'+ syn.strip() +'_'+'standard01.csv'
            new_name = new_name.replace('"','')
            new_name = new_name.replace(',','')
            try: # rename the local file to src/**
                os.rename(basename,os.path.join(curr_dir,new_name))
            except:
                print('can not rename:',basename,' ----> ',os.path.join(curr_dir,new_name))
            try:
                os.rename(top_file,os.path.join(os.path.dirname(top_file),new_name))
                shutil.copy2(os.path.join(os.path.dirname(top_file),new_name),os.path.basename(top_file))
            except:
                print('can\t rename:%s or can not copy'%new_name)
            #if item.find('--sweeping') == -1:
            if get_sweeping == 0:
                print('------------------','you are not sweeping')
                src_files[id1] = os.path.join(curr_dir,new_name)
            else:
                pass
            ###  copy the stand data to the server
            if not impl:
                default_from_dir = r"\\d50534\apachedata\spreadsheet"
                if suite.find('103')!= -1:
                    suite2 = 'X103'
                else:
                    suite2 = (suite.split('_'))[0]
                full_default_from_dir = os.path.join(default_from_dir,suite2)
                print(full_default_from_dir)
                try:
                    shutil.copy2(os.path.join(curr_dir,new_name), full_default_from_dir)
                except:
                    print('Can not copy %s to the Server'%new_name)
        #--------------------------- 
        #----------------------- Get the job_dir file
        job_file = glob.glob(os.path.join(job_dir,suite,'*.csv') )
        if not job_file:
            print("can not find job_file in:%s"%suite)
            continue
        print('#'*40)
        print(job_file)
        print('#'*40)
        sorted_file = ''
        sorted_file_all = ''
        for file1 in job_file:
            if file1.endswith('_sorted.csv'):
                sorted_file = file1
            if file1.endswith('_sorted_all.csv'):
                sorted_file_all = file1
        sw = ''
        syn = ''
        for file1 in (sorted_file,sorted_file_all): 
            if not file1:
                break            
            basename = os.path.basename(file1)
            shutil.copy2(file1, os.path.join(curr_dir,basename) )
            file_hand = file(os.path.join(curr_dir,basename),'r')
            all_line = file_hand.readlines()
            file_hand.close()
            
            for a_l in all_line:
                if a_l.find(r'[SW]:') != -1:
                    al = a_l.split(r'[SW]:')
                    sw = al[1]
                if a_l.find(r'[synthesis]') != -1:
                    al = a_l.split(r'[synthesis]:')
                    syn = al[1]
                if syn and sw:
                    break
            if basename.find('_sorted_all.csv')!= -1:
                new_name = (suite).strip() +'_'+ sw.strip() +'_'+ syn.strip() +'_all.csv'
            else:           
                new_name = (suite).strip() +'_'+ sw.strip() +'_'+ syn.strip() +'NewPC.csv'
            new_name = new_name.replace('"','')
            new_name = new_name.replace(',','')
            try:
                os.rename(os.path.join(curr_dir,basename),os.path.join(curr_dir,new_name))
            except:
                print('can not rename:',os.path.join(curr_dir,basename),'----------->',os.path.join(curr_dir,new_name))
            #if item.find('--sweeping') != -1 and new_name.find('NewPC')!= -1:
            if get_sweeping == 1 and new_name.find('NewPC')!= -1:
                print('HHH, get you ')
                src_files[id1] = os.path.join(curr_dir,new_name)
            else:
                pass
            
            try:
                top_dir = os.path.dirname(top_file)
                shutil.copy2(os.path.join(curr_dir,new_name), top_dir)
                #os.remove(new_name)
            except:
                print('can not copy sweeping data to the stand! or can not remove:  %s'%new_name)
                
            
            #----------------------------Rename the old file -----------------------#
            old_file_rename = os.path.join(os.path.dirname(file1),new_name)
            try:
                os.rename(file1,old_file_rename)
            except:
                print('Can not rename:%s'%file1)
                pass
            #--------------------------END --------------------------------------#
    return src_files
    
    
def get_compare_file(diamond,file_name):
    file_hand = file(file_name,'r')
    lines = file_hand.readlines()
    file_hand.close()
    files = []
    for_ini={}
    compare_files = ['-']*len(lines)  # this is the return data
    curr_dir = os.getcwd()
    if not os.path.isdir('cmp'):
        try:
            os.mkdir('cmp')
            curr_dir = 'cmp'
        except:
            print('can not make src directory')
    else:
        curr_dir = 'cmp'
    for id1,item in enumerate(lines):
        item = item.strip()
        suite = get_cmd_value(item,'suite')
        if not suite:
            continue
        suite2 = suite.split('_')[0]
        default_from_dir = r"\\d50534\apachedata\spreadsheet"
        #use_dir = [r'ecp2_60',r'large_25',r'sc_24',r'xo_103']
        if suite2.find('103')!= -1:
            suite2 = 'X103'
        full_dir = os.path.join(default_from_dir,suite2)
        print(full_dir)
        for file1 in os.listdir(full_dir):
            print('------------------------------')
            print('fiel1',file1)
            print(diamond)
            print('suite',suite)
            
            if file1.find(diamond)!= -1 and file1.find('standard01')!= -1 and file1.find(suite)!= -1:
                file_dir = os.path.join(full_dir,file1)
                file1 = file1.replace(',',' ')
                file1 = os.path.join(curr_dir,file1)
                shutil.copy2(file_dir,file1)
                print('DONE')
                compare_files[id1] = file1
    return compare_files

def write_file_conf(src_file=[],compare_file=[]):   
    if not src_file or not compare_file:
        print("No src_file or compare_file")
        return
    if len(src_file)!=len(compare_file):
        print("the src_file and compare_file number are not same")
        return
    file_hand = file('file_conf.list','w')
    all_output = []
    for id1,file1 in enumerate(src_file):
        file2 = compare_file[id1]
        if file1=='-' or file2 =='-':
            continue
        else:
            # --output=102_88.csv --title=lattice_title --original-title=title2
            not_usual = re.compile(r'[^\w$]')
            output = os.path.basename(file1)[:14]+'_'+os.path.basename(file2)[:14]
            if output.find('X103')!= -1:
                try:
                    ss = (os.path.basename(file1)).split('_')
                    output = "_".join(ss[:4])
                except:
                    pass
            else:
                try:
                    ss = (os.path.basename(file1)).split('_')
                    output = "_".join(ss[:2])
                except:
                    pass
                
            output = not_usual.sub('',output)
            if output in all_output:
                output = output+str(id1)
            else:
                all_output.append(output)
            if output.find('L25')!= -1 or output.find('l25')!= -1:
                line = '--cmp='+file1 + '  ' + '--src='+ file2 + ' ' +'--output='+r'temp\\'+output + '  --Comp_Title=l25 --Original_Title=original_default'
            else:
                line = '--cmp='+file1 + '  ' + '--src='+ file2 + ' ' +'--output='+r'temp\\'+output + '  --Comp_Title=non_l25 --Original_Title=original_default'
            file_hand.write(line+'\n')
    file_hand.close()
      
if __name__ == '__main__':
    bat = sys.argv[1]
    #a = get_src_data('run_for_svn.bat')
    diamond_str = sys.argv[2]
    try:
        get_sweeping = sys.argv[3]
        if get_sweeping.strip() == '--sweeping':
            get_sweeping = 1
    except:
        get_sweeping = 0
        
    #print a
    a = get_src_data(bat,get_sweeping)
    #b = get_compare_file('2.2.0.36','run_for_svn.bat')
    #diamond_str = ''.join(diamond_str)
    b = get_compare_file(diamond_str,bat)
    write_file_conf(a,b)
    try:
        os.mkdir('temp')
    except:
        pass
    

        
    
