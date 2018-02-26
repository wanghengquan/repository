#! C:\Python25\python.exe
#===================================================
# Owner    : Yzhao1
# Function :
#           This file is run case specially as:

# Date     :2012/12/27

#===================================================
import os
import sys
import re
import time
import shutil
import glob
def set_enviroment(diamond,os_name):
    #======================================
    # This function used to set environment for diamond
    #=======================================
    diamond = os.path.abspath(diamond)
    if os.path.isdir(diamond):
        pass
    else:
        print 'Please Specify the Diamond And Make Sure it is exists'
        sys.exit()
    if diamond:
        os.environ["LM_LICENSE_FILE"] = r'1700@d27'
        os.environ["TW_PAP_VERBOSE"] = '1'
        os.environ["LSC_RECORD_CPUMEM"] = '1'
        os.environ["CLEAN_VDBS"]='1'
        
        os.environ["LSC_CALLALLDEVS"] = '1'
        os.environ["LSC_NO_INI_PATH"] = '1'
        os.environ["SEDISABLE"] = '1'
        
        os.environ["XIL_TIMING_ALLOW_IMPOSSIBLE"] = '1'
        os.environ["XIL_PAR_ENABLE_LEGALIZER"] = '1'
        foundry = os.path.join(diamond, "ispfpga")
        sv_cpld_bin = os.path.join(diamond, "bin", os_name)
        sv_fpga_bin = os.path.join(foundry, "bin", os_name)
        tcl_library = os.path.join(diamond, "tcltk", "lib", "tcl8.5")
        os.environ["FOUNDRY"] = foundry
        #### if the system is linux, ";" should be ":"
        t_value = sv_cpld_bin + ';' + sv_fpga_bin
        os.environ["PATH"] = t_value + ';' + os.getenv("PATH", "")
        os.environ["LD_LIBRARY_PATH"] = t_value
        os.environ["PATH"] = os.getenv("PATH", "") + r'C:\lscc\diamond\2.1_x64\bin\nt64'
        os.environ["QACPLDBIN"] = sv_cpld_bin
        os.environ["QAFPGABIN"] = sv_fpga_bin
        if tcl_library:
            os.environ["TCL_LIBRARY"] = tcl_library
    

def get_xml_file(file_path=""):
    if not file_path:
        for i in range(1,2):
            if not os.path.isfile("DiamondDevFile.xml"):
                print "Generating DiamondDevFile.xml ..."
                createdevfile_exe = os.path.join(os.getenv("QACPLDBIN", "NO_QACPLDBIN"), "createdevfile")
                create_cmd = "%s -path ." % createdevfile_exe
                print create_cmd
                os.popen(create_cmd)
            if os.path.isfile("DiamondDevFile.xml"):
                os.remove("DiamondDevFile.xml")
                print "Generating DiamondDevFile.xml ..."
                createdevfile_exe = os.path.join(os.getenv("QACPLDBIN", "NO_QACPLDBIN"), "createdevfile")
                create_cmd = "%s -path ." % createdevfile_exe
                print create_cmd
                os.popen(create_cmd)
    else:
        for i in range(1,2):
            if not os.path.isfile("DiamondDevFile.xml"):
                print "Generating ..."
                createdevfile_exe = os.path.join(os.getenv("QACPLDBIN", "NO_QACPLDBIN"), "createdevfile")
                create_cmd = "%s -path %s" % (createdevfile_exe,file_path)
                print create_cmd
                os.popen(create_cmd)
            elif os.path.isfile(os.path.join(file_path,"DiamondDevFile.xml")):
                print 'The File eixsts'
                os.remove(os.path.join(file_path,"DiamondDevFile.xml"))
                print "Generating Again ..."
                createdevfile_exe = os.path.join(os.getenv("QACPLDBIN", "NO_QACPLDBIN"), "createdevfile")
                create_cmd = "%s -path %s" % (createdevfile_exe,file_path)
                print create_cmd
                os.popen(create_cmd)
if __name__ == '__main__':
    diamond = sys.argv[1]
    system  = sys.argv[2]
    try:
        file_path = sys.argv[3]
    except:
        file_path = ''
    #set_enviroment(r'C:\lscc\diamond\2.2_x64','nt64')

    #get_xml_file()
    set_enviroment(diamond,system)
    get_xml_file(file_path)