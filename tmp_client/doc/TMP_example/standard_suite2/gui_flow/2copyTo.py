#copy file into each tst folder
#put this py and source files in NEW folder 
import os
import sys
import glob
import shutil
script_dir = os.path.split(os.path.realpath(__file__))[0]

def copy_into_tst(file):
    #source file exist
    if os.path.exists(file) == False:
        print file, "not exist, couldn't copy"
        return
        
    data_lst2 = os.listdir(script_dir)   
    for item in data_lst2:        
        if os.path.isfile(item):
            #print "%s is not path" % item
            continue
        
        #only copy to folder tst
        if os.path.isdir(item) and item.startswith("tst"):                 
            copy_file = os.path.join(item, file)
            if os.path.exists(copy_file) == True:
                os.remove(copy_file)
                print file, " exist, deleted it"               
            shutil.copy(file, item)            
            print file, "--copy to--", item
    print " "
    
    
def copy_into_testdata(file):   
    #find file .ini
    if file == "ini":
        data_lst2 = os.listdir(script_dir)   
        for f in data_lst2:        
            if os.path.isfile(f) and f.endswith(".ini"):
                file = f
                break
                
    #source file exist   
    if os.path.exists(file) == False:
        print file, "not exist, couldn't copy"
        return
    
    #copy to folder testdate
    data_lst = glob.glob("*/testdata")     
    for item in data_lst:     
        copy_file  =  os.path.join(item, file) 
        if os.path.exists(copy_file) == True:
            os.remove(copy_file)
            print file, " exist, deleted it"               
        shutil.copy(file, item)            
        print file, "--copy to--", item
    print " "
    
    
def copy_into_testmethod(file):
    #source file exist
    if os.path.exists(file) == False:
        print file, "not exist, couldn't copy"
        return
        
    #copy to folder testmethod    
    data_lst = glob.glob("*/testmethod")     
    for item in data_lst:     
        copy_file  =  os.path.join(item, file) 
        if os.path.exists(copy_file) == True:
            os.remove(copy_file)
            print file, " exist, deleted it"               
        shutil.copy(file, item)            
        print file, "--copy to--", item
    print " "
   

def delete_scratch():      
    data_lst = glob.glob("*/_scratch")     
    for item in data_lst:     
        shutil.rmtree(item)
        print "deleted-- ", item                    
    print " "   
   
   
def process():
    #copy_into_tst("test.pl")

    copy_into_tst("bqs.conf")
    copy_into_tst("bqs.info")#case path
    
    copy_into_testdata("objects.map")
    copy_into_testdata("suite.conf")
    copy_into_testdata("ini")
    
    delete_scratch()
    
if __name__ == "__main__":
    process()
    raw_input('press to leave')