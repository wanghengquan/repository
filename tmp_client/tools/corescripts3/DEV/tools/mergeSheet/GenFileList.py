import os
import sys
import re

file_order = (
       "BOM",
       "Installation",
       "DownloadUpdate",
       "LicenseCheck",
       "Clarity_Designer",
       "MessageSystem",
       "Win81",
       "QoR_benchmark",
       "Affarii_DSP_QoR",
       "LSE",
       "SynplifyPro",
       "MPAR",
       "STA",
       "Programmer",
       "DeviceCover",
       "ProjectNavigator",
       "DeviceView",
       "Preference",
       "IPExpress",
       "SSView",
       "Reveal",
       "Netlist_Analyzer",
       "Netlist_View",
       "Package_View",
       "PIO_DRC",
       "IBIS",
       "SSO",
       "MICO_System",
       "Regression_Flow",
       "Reference_Design",
       "IP_Regression",
       "TAView",
       "Waveform_Editor",
       "ECO_Editor",
       "EPIC",
       "FPV_PV",
       "HelpDocument",
       "IDF",
       "IOAssistant",
       "Ldbanno_Simulation",
       "Memory_Gen",
       "NCD_View",
       "ORCAstra",
       "Pin_Migration",
       "PMI",
       "PAC_Designer",
       "POJO2",
       "Power_Calculator",
       "Report_Browser",
       "RunManager",
       "Schematic_Tools",
       "Security_Setting",
       "SimLib_compile",
       "Simulation_Wizard",
       "Simulator",
       "Source_Editor",
       "Strategy_Manager",
       "TCL_console"
       )
       
total_files = len(file_order) 
          
def read_excel_file (excel_dir):
    file_list_dict = dict()
    for foo in os.listdir (excel_dir):
        #print "file name is %s" % foo
        file_list = os.path.join(top_dir,foo)
        if os.path.isfile(file_list):
            print(os.path.basename(foo))
            key = os.path.basename(foo).split(" ")[1]
            #print "key is %s" % key
            file_list_dict[key] = foo
            #print"file_list_array is %s" % file_list_dict
    return file_list_dict
       
def dump_file_list (top_dir, file_list_array,dump_file):
    ob = open(dump_file, 'w')
    keys = list(file_list_array.keys())
    i = 0
    for list in file_order:
        if list in keys:
            ob.write(top_dir + '\\' + file_list_array[list]+'\n')
            i = i + 1
        else:
            print("Warning: xxxx %s xxxx doesn't exist! " % list)
            continue
    if i == total_files:
    	print("Successful....Total reports are %s" % i)
    else:
        print("Failed... %s files are missing" % (total_files - i))
    ob.close()

if __name__ == "__main__":
    top_dir = sys.argv[1]    
    dump_file = sys.argv[2]
    #top_dir = r'\\lsh_prince\sw\SW_Validation\LSH_Results\D3_5\TestReport\Prod\build83'
    #dump_file = "my_list.txt"
    print("Test reports are located at %s" % top_dir)
    input()
    file_list_array = read_excel_file(top_dir)
    dump_file_list(top_dir,file_list_array,dump_file)