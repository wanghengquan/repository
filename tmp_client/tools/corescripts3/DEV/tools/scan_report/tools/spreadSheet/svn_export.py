#! C:\Python25\python.exe
import os
import re
import sys
p_dir =  re.compile("/$")
def svn_export_file(url_file,file_name,dir):
    a = os.system('svn export --force -q  --username=public --password=lattice '+url_file+' '+os.path.join(dir,file_name))
def svn_export_dir(url_dir,dir):
    if os.path.isdir(dir):
        pass
    else:
        os.makedirs(dir)
    os.system('svn export --force -q  --username=public --password=lattice '+url_dir+' '+dir)
def svn_export_case(url_case,family,case,dir):
    dir_path =  os.path.join(dir,case)
    if os.path.isdir(dir):
       if os.path.isdir(dir_path):
           pass
       else:
           os.makedirs(dir_path)
           
    else:
       os.makedirs(dir_path)
    ls_case = 'svn ls '+ url_case
    case_dir_file = os.popen(ls_case)
    #print case_dir_file
    for d_f in case_dir_file:
        #print d_f
        d_f = d_f.strip()
        if p_dir.search(d_f):  # at here the directory should be "models,others,source"
           if d_f == 'source/' or d_f== 'others/':
              url_dir = url_case+r'/'+d_f
              dir_path =  os.path.join(dir,case,d_f)
              svn_export_dir(url_dir,dir_path)
           elif d_f == 'models/':
                ls_models = 'svn ls '+ url_case+r'/'+d_f
                familys = os.popen(ls_models)
                for f in familys:
                    f = f.strip()
                    if f == family+'/' or f == family+'m/':
                        url_dir = url_case+r'/'+d_f + r'/'+f
                        dir_path =  os.path.join(dir,case,'models',f)
                        svn_export_dir(url_dir,dir_path)
                    else:
                        pass
           elif d_f == 'others/':
                ls_models = 'svn ls '+ url_case+r'/'+d_f
                familys = os.popen(ls_models)
                for f in familys:
                    f = f.strip()
                    if f == family+'/' or f == family+'m/':
                        url_dir = url_case+r'/'+d_f + r'/'+f
                        dir_path =  os.path.join(dir,case,'others',f)
                        svn_export_dir(url_dir,dir_path)
                    else:
                        pass 
        else:
            dir_path =  os.path.join(dir,case)
            if d_f == '_qa_'+family+'.info' or d_f == '_qa_'+family+'m.info': # special for ecp2m
               f_url =  url_case+r'/'+d_f
               print(f_url)
               svn_export_file(f_url,d_f,dir_path)
            elif d_f.find('_qa_')!= -1:
                pass
            else:
               
               f_url =  url_case+r'/'+d_f
               print(f_url)
               svn_export_file(f_url,d_f,dir_path)
if __name__ == '__main__':
    suite =  'E60_ecp3'
    suite2 =  suite.split('_')[0].strip()
    family =  suite.split('_')[1].strip()
    url = r' http://d50534/'+suite2+r'/trunk'
    cmd = 'svn ls '+ url
    
    raw_file_dirs = os.popen(cmd)  # at here all the list is case
    for id1,item in enumerate(raw_file_dirs):
        item =  item.strip()
        if p_dir.search(item):
            case_url = url+r'/'+item
            svn_export_case(case_url,family,item[:-1],suite)
        else:
           case_url = url+r'/'+item
           svn_export_file(case_url,item,suite)
        break
    
            
            
            

