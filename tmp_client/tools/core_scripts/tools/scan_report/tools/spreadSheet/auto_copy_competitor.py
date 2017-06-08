'''
Created on 2013-8-14

@author: yzhao1

This file used to speciallfy for the QoR between lattice and competitors
Pay special attention to the bat file as your arguments.

Example:

python for_svn_*.py --suite=E60_cyclone4 ****
---
python for_svn.py --suite=E60_ecp3 ****

the line "for_svn_*.py --suite=E60_cyclone4 "  will compare to "for_svn.py --suite=E60_ecp3"

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
        print 'Nothing find'
        return 
    
    
def get_src_data(file_name):
    '''
    At here we will get the competitor file 
    '''
    file_hand = file(file_name,'r')
    lines = file_hand.readlines()
    file_hand.close()
    files = []
    for_ini={}
    src_files = []  # this is the return data
    for id1,item in enumerate(lines):
        item = item.strip()
        if item.startswith('rem'):
            continue
        if item.startswith('#'):
            continue
        if item.find('for_svn_altera.py')!= -1 or item.find('for_svn_xilinx.py')!= -1:
            pass
        else:
            continue
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
                print 'can not make src directory'
        else:
            curr_dir = 'src'
        if item.find('--sweeping') == -1:
            top_file = glob.glob(os.path.join(top_dir,suite,'*_sorted.csv') )
            if not top_file:
                print "can not  find top_file in:%s"%suite
                print os.path.join(top_dir,suite,'*_sorted.csv')
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
            
            new_name = (suite).strip() +'_'+ sw.strip() +'_'+ syn.strip() +'_'+'standard01_cmd.csv'
            new_name = new_name.replace('"','')
            new_name = new_name.replace(',','')
            try: # rename the local file to src/**
                os.rename(basename,os.path.join(curr_dir,new_name))
            except:
                print 'can not rename:',basename,' ----> ',os.path.join(curr_dir,new_name)
            try:
                os.rename(top_file,os.path.join(os.path.dirname(top_file),new_name))
                shutil.copy2(os.path.join(os.path.dirname(top_file),new_name),os.path.basename(top_file))
            except:
                print 'can\t rename:%s or can not copy'%new_name
            if item.find('--sweeping') == -1:
                src_files.append(os.path.join(curr_dir,new_name))
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
                print full_default_from_dir
                try:
                    shutil.copy2(os.path.join(curr_dir,new_name), full_default_from_dir)
                except:
                    print 'Can not copy %s to the Server'%new_name
        #--------------------------- 
        #----------------------- Get the job_dir file
        job_file = glob.glob(os.path.join(job_dir,suite,'*.csv') )
        if not job_file:
            print "can not find job_file in:%s"%suite
            continue
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
                new_name = (suite).strip() +'_'+ sw.strip() +'_'+ syn.strip() +'_all_cmd.csv'
            else:           
                new_name = (suite).strip() +'_'+ sw.strip() +'_'+ syn.strip() +'NewPC_cmd.csv'
            new_name = new_name.replace('"','')
            new_name = new_name.replace(',','')
            try:
                os.rename(os.path.join(curr_dir,basename),os.path.join(curr_dir,new_name))
            except:
                print 'can not rename:',os.path.join(curr_dir,basename),'----------->',os.path.join(curr_dir,new_name)
            if item.find('--sweeping') != -1 and new_name.find('NewPC')!= -1:
                print 'HHH, get you '
                src_files.append( os.path.join(curr_dir,new_name))
            else:
                pass
            
            try:
                top_dir = os.path.dirname(top_file)
                shutil.copy2(os.path.join(curr_dir,new_name), top_dir)
                #os.remove(new_name)
            except:
                print 'can not copy sweeping data to the stand! or can not remove:  %s'%new_name
                
            
            #----------------------------Rename the old file -----------------------#
            old_file_rename = os.path.join(os.path.dirname(file1),new_name)
            try:
                os.rename(file1,old_file_rename)
            except:
                print 'Can not rename:%s'%file1
                pass
            #--------------------------END --------------------------------------#
    return src_files
    
    
def get_compare_data(file_name):
    '''
    At here we will get the competitor file 
    '''
    file_hand = file(file_name,'r')
    lines = file_hand.readlines()
    file_hand.close()
    files = []
    for_ini={}
    src_files = []  # this is the return data
    for id1,item in enumerate(lines):
        item = item.strip()
        if item.startswith('rem'):
            continue
        if item.startswith('#'):
            continue
        if item.find('for_svn.py')!= -1:
            pass
        else:
            continue
        suite = get_cmd_value(item,'suite')
        top_dir = get_cmd_value(item,'top-dir')
        job_dir = get_cmd_value(item,'job-dir')
        impl = get_cmd_value(item,'impl')
        if (not suite) or (not top_dir) or (not job_dir):
            continue
        else:
            pass
        if not os.path.isdir('cmp'):
            try:
                os.mkdir('cmp')
                curr_dir = 'cmp'
            except:
                print 'can not make cmp directory'
        else:
            curr_dir = 'cmp'
        if item.find('--sweeping') == -1:
            top_file = glob.glob(os.path.join(top_dir,suite,'*_sorted.csv') )
            if not top_file:
                print "can not  find top_file in:%s"%suite
                print os.path.join(top_dir,suite,'*_sorted.csv')
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
            
            new_name = (suite).strip() +'_'+ sw.strip() +'_'+ syn.strip() +'_'+'standard01_cmd.csv'
            new_name = new_name.replace('"','')
            new_name = new_name.replace(',','')
            try: # rename the local file to src/**
                os.rename(basename,os.path.join(curr_dir,new_name))
            except:
                print 'can not rename:',basename,' ----> ',os.path.join(curr_dir,new_name)
            try:
                os.rename(top_file,os.path.join(os.path.dirname(top_file),new_name))
                shutil.copy2(os.path.join(os.path.dirname(top_file),new_name),os.path.basename(top_file))
            except:
                print 'can\t rename:%s or can not copy'%new_name
            if item.find('--sweeping') == -1:
                src_files.append(os.path.join(curr_dir,new_name))
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
                print full_default_from_dir
                try:
                    shutil.copy2(os.path.join(curr_dir,new_name), full_default_from_dir)
                except:
                    print 'Can not copy %s to the Server'%new_name
        #--------------------------- 
        #----------------------- Get the job_dir file
        job_file = glob.glob(os.path.join(job_dir,suite,'*.csv') )
        if not job_file:
            print "can not find job_file in:%s"%suite
            continue
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
                new_name = (suite).strip() +'_'+ sw.strip() +'_'+ syn.strip() +'_all_cmd.csv'
            else:           
                new_name = (suite).strip() +'_'+ sw.strip() +'_'+ syn.strip() +'NewPC_cmd.csv'
            new_name = new_name.replace('"','')
            new_name = new_name.replace(',','')
            try:
                os.rename(os.path.join(curr_dir,basename),os.path.join(curr_dir,new_name))
            except:
                print 'can not rename:',os.path.join(curr_dir,basename),'----------->',os.path.join(curr_dir,new_name)
            if item.find('--sweeping') != -1 and new_name.find('NewPC')!= -1:
                print 'HHH, get you '
                src_files.append( os.path.join(curr_dir,new_name))
            else:
                pass
            
            try:
                top_dir = os.path.dirname(top_file)
                shutil.copy2(os.path.join(curr_dir,new_name), top_dir)
                #os.remove(new_name)
            except:
                print 'can not copy sweeping data to the stand! or can not remove:  %s'%new_name
                
            
            #----------------------------Rename the old file -----------------------#
            old_file_rename = os.path.join(os.path.dirname(file1),new_name)
            try:
                os.rename(file1,old_file_rename)
            except:
                print 'Can not rename:%s'%file1
                pass
            #--------------------------END --------------------------------------#
    return src_files
 
    
    
def write_file_conf(src_file=[],compare_file=[]):   
    if not src_file or not compare_file:
        print "No src_file or compare_file"
        return
    file_hand = file('file_conf.list','w')
    all_output = []
    for id1,file1 in enumerate(src_file):
        basename = os.path.basename(file1)
        suite = basename.split('_')[0]
        for id2,f2 in enumerate(compare_file):
            f22 = os.path.basename(f2)
            if f22.startswith(suite):
                print file1,f2
                file2 = f2
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

    #print a
    a = get_src_data(bat)
    print a
    #b = get_compare_file('2.2.0.36','run_for_svn.bat')
    #diamond_str = ''.join(diamond_str)
    b = get_compare_data(bat)
    print b
    write_file_conf(a,b)
    try:
        os.mkdir('temp')
    except:
        pass
    

        
    
