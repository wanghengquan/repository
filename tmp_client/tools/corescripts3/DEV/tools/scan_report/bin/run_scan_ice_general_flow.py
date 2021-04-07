__author__ = 'yzhao1'
#===================================================
# Description: This is the scan the ICEcube general test flow, the test owner is rachel
# Owner      : SWQA Auto Yzhao1
# Version    : 1.0
# Update     : None
#===================================================
import os
import re
import optparse
import traceback
class scan:
    def parse_option(self):
        self.parser = optparse.OptionParser()
        # public options for the case
        pub_group = optparse.OptionGroup(self.parser, "Public Options")
        pub_group.add_option("--design", help="specify the design name")
        pub_group.add_option("--job-dir", help="specify the job working path name")
        pub_group.add_option("--reverse", default="", help="reverse the result")
        pub_group.add_option("--report", help="run pre-process for a case")
        self.parser.add_option_group(pub_group)

    def __init__(self,job_dir='',design='',report=''):
        self.init_titles = ["Design_Path","Design","SW_Build",
                            "Synthesis_Tool","Simulator_Tool",
                            "Family","Device","Package",
                            "Flow","Flow_Error",
                            "Verilog_Sim","Verilog_Sim_Msg",
                            "VHDL_Sim","VHDL_Sim_Msg","DMS","DMS_Msg","Others"]
        self.total_family = ["iCE65","iCE5LP","iCE40LM","iCE40UL","iCE40UP","iCE40"]
        self.parse_option()
        opts, args = self.parser.parse_args()
        self.init_data = dict( list(zip(self.init_titles,[" "]*len(self.init_titles))) )

        if opts.job_dir:
            job_dir = opts.job_dir
        if job_dir:
            self.job_dir = os.path.abspath(job_dir)
        else:
            self.job_dir = os.path.dirname(os.getcwd())

        if opts.report:
            report = opts.report
        self.report = report
        if not self.report:
            self.report = os.path.join(self.job_dir,os.path.basename(self.job_dir)+".csv")
        if opts.design:
            design = opts.design
        if design:
            self.design = design
        else:
            self.design = os.path.basename(os.getcwd())
        if opts.reverse:
            self.reverse = 1
        else:
            self.reverse = 0
        self.scan_path = os.path.join(self.job_dir,self.design,"_scratch")
    def scan_info(self):
        self.init_data["Design_Path"] = self.job_dir
        self.init_data["Design"] = self.design
        try:
            if os.path.isdir(self.scan_path):
                pass
            else:
                self.init_data["Others"] = "Error:Can not find design"
                print("Error:", "Can not find design path: ",self.scan_path)

            ########## Get SW_BUILD ###########
            # read run.log under _scratch and get "Release:        2015.08Dev.27559"
            sw_pattern = re.compile("Release:\s+(\S+)")
            run_log = os.path.join(self.scan_path,"run.log")
            if not os.path.isfile(run_log):
                self.init_data["Others"] = "Error:Can not find run.log"
                print("Error:", "Can not find: ",run_log)

            all_lines = file(run_log).readlines()
            for line in all_lines:
                line = line.strip()
                sw_search = sw_pattern.search(line)
                if sw_search:
                    self.init_data["SW_Build"] = sw_search.group(1)
                    break
            ############## get synthesis tool #####################
            # at here, the script will check run_synplify.prj/run_synplify_linux.prj/run_lse.synproj/run_lse_linux.synproj
            all_files = os.listdir(self.scan_path)
            if ("run_synplify.prj" in all_files) or ("run_synplify_linux.prj" in all_files):
                self.init_data["Synthesis_Tool"] = "synplify"
            elif ("run_lse.synproj" in all_files) or ("run_lse_linux.synproj" in all_files):
                self.init_data["Synthesis_Tool"] = "LSE"
            else:
                pass
            ################ Get Simulator_Tool ################
            # the simulation tool is get by the sim directory
            if("modelsim_verilog" in all_files) or ("modelsim_vhdl" in all_files):
                self.init_data["Simulator_Tool"] = "Modelsim"
            elif ("sim_verilog" in all_files) or ("sim_vhdl" in all_files):
                self.init_data["Simulator_Tool"] = "Active-Hdl"
            else:
                pass
            ############### get "Family","Device","Package" #############
            if "run_synplify.prj" in all_files:
                syn_conf_file = os.path.join(self.scan_path,"run_synplify.prj")
            elif "run_synplify_linux.prj" in all_files :
                syn_conf_file = os.path.join(self.scan_path,"run_synplify_linux.prj")
            elif "run_lse.synproj" in all_files :
                syn_conf_file = os.path.join(self.scan_path,"run_lse.synproj")
            elif "run_lse_linux.synproj" in all_files :
                syn_conf_file = os.path.join(self.scan_path,"run_lse_linux.synproj")
            else:
                syn_conf_file = " "
            if syn_conf_file.endswith("prj"):
                syn_conf_file_lines = file(syn_conf_file).readlines()
                #set_option -part iCE40LP8K
                #set_option -package CM225
                for line in syn_conf_file_lines:
                    if line.find("set_option -part")!= -1:
                        part = line.strip().replace("set_option -part","")
                        for family in self.total_family:
                            if part.find(family)!= -1:
                                self.init_data["Family"] = family
                                self.init_data["Device"] = part.replace(family,"").strip()
                        continue
                    if line.find("set_option -package") != -1:
                        self.init_data["Package"] = line.strip().replace("set_option -package","").strip()
                        break
            elif syn_conf_file.endswith("synproj"):
                syn_conf_file_lines = file(syn_conf_file).readlines()
                #-d %(DeviceFamily)s%(Device)s
                #-t %(DevicePackage)s
                for line in syn_conf_file_lines:
                    if line.find("-d")!= -1:
                        part = line.strip().replace("-d","")
                        for family in self.total_family:
                            if part.find(family)!= -1:
                                self.init_data["Family"] = family
                                self.init_data["Device"] = part.replace(family,"").strip()
                        continue
                    if line.find("-t") != -1:
                        self.init_data["Package"] = line.strip().replace("-t","").strip()
                        break
            else:
                pass
            ####################### get "Flow","Flow_Error","DMS","DMS_Msg" #########
            #method read run.log
            #flag = 0
            find_flag = 0
            dms_flag = 0
            dms_fail_pattern = re.compile("SBT_FAIL|Mismatch|FAIL|Fail|failed|ERROR|Error")
            for line in all_lines:
                #if line.find("========")!= -1:
                #    flag += 1
                #if flag >1:
                #    self.init_data["Synthesis"] = "Pass"
                #    break
                if line.find("-do vsim_DMS.do -c -l vsim_DMS.log ") != -1:
                    dms_flag = 1
                if (not dms_flag) and (not find_flag):
                    if (line.find("error status")!= -1 or line.find("ERROR - synthesis")!= -1 \
                            or line.lower().startswith("error") or re.search("^E\d+:",line) or line.lower().find("fail ")!= -1) \
                            and line.lower().find("cont_fail") == -1:
                        if self.reverse:
                            self.init_data["Flow"] = "Pass"
                        else:
                            self.init_data["Flow"] = "Fail"
                        self.init_data["Flow_Error"] = line.replace(","," ").strip()
                        find_flag = 1

                else:
                    #if line.lower().find("error") != -1:
                    # if # 'INFO>> Forcing cbits Completed' is find, the pre dms result will be ingored
                    if(re.search("#\s+'INFO>>\s+Forcing\s+cbits\s+Completed'",line)):
                        self.init_data["DMS"] = "Pass"
                        self.init_data["DMS_Msg"] = ""
                    elif dms_fail_pattern.search(line) and (not re.search("no\s+error",line.lower())):
                        # special for E2081: Feasibility check for IO Placement failed
                        #             E2055: Error while doing placement of the design
                        if(re.search("E2081:\s+Feasibility\s+check\s+for\s+IO\s+Placement\s+failed",line)):
                            self.init_data["DMS"] = "Pass"
                        elif(re.search("E2055:\s+Error\s+while\s+doing\s+placement\s+of\s+the\s+design",line)):
                            self.init_data["DMS"] = "Pass"
                        else:
                            self.init_data["DMS"] = "Fail"
                        self.init_data["DMS_Msg"] = line.replace(","," ").strip()
                    else:
                        pass

            if not find_flag:
                self.init_data["Flow"] = "Pass"
            ##############################################################

            #### "Verilog_Sim","Verilog_Error_Msg"
            find_sim_dir_flag = 0
            for sim_dir in ["sim_verilog","sim_vhdl","modelsim_verilog","modelsim_vhdl"]:
                if sim_dir in all_files:
                    find_sim_dir_flag = 1
                    sim_log = os.path.join(self.scan_path,sim_dir,"sim.log")
                    if not os.path.isfile(sim_log):
                        if sim_dir.find("verilog") != -1:
                            self.init_data["Verilog_Sim"] = "Fail"
                            self.init_data["Verilog_Sim_Msg"] = "Cannot find sim.log"
                        else:
                            self.init_data["VHDL_Sim"] = "Fail"
                            self.init_data["VHDL_Sim_Msg"] = "Cannot find sim.log"
                    else:
                        all_lines = file(sim_log).readlines()
                        error_flag = 0
                        for line in all_lines:
                            line = line.strip()
                            if line.find("SBT_FAIL")!= -1 or line.find("Mismatch")!= -1 or \
                                line.find("ERROR")!= -1 or line.find("Fail")!= -1 or line.find("FAIL")!= -1 :
                                if sim_dir.find("verilog") != -1:
                                    self.init_data["Verilog_Sim"] = "Fail"
                                    self.init_data["Verilog_Sim_Msg"] = line.replace(","," ").strip()
                                else:
                                    self.init_data["VHDL_Sim"] = "Fail"
                                    self.init_data["VHDL_Sim_Msg"] = line.replace(","," ").strip()
                                error_flag = 1
                                break
                        if not error_flag:
                            if sim_dir.find("verilog") != -1:
                                self.init_data["Verilog_Sim"] = "Pass"
                            else:
                                self.init_data["VHDL_Sim"] = "Pass"
            if find_sim_dir_flag == 0:
                for line in all_lines:
                    if line.startswith("Error"):
                        self.init_data["Verilog_Sim"] = "Fail"
                        self.init_data["VHDL_Sim"] = "Fail"
                        self.init_data["Others"] = "Maybe flow fail"
        except Exception as e:
            self.init_data["Others"] = re.sub("\s+"," ",str(traceback.format_exc()))
            if self.reverse:
                self.init_data["Flow"] = "Pass"
            else:
                self.init_data["Flow"] = "Fail"
        self.write_report()
        self.print_xml()
    def write_report(self):
        if os.path.isfile(self.report):
            pass
        else:
            file_hand = file(self.report,"w")
            file_hand.write(",".join(self.init_titles)+"\n")
            file_hand.close()
        new_record = []
        for title in self.init_titles:
            new_record.append(self.init_data.get(title,"NA"))
        new_lines = ",".join(new_record)+"\n"
        pass_num = 0
        total_num = 0
        fail_num = 0
        if new_lines.find(",Fail,")!= -1:
            fail_num += 1
        else:
            pass_num += 1
        total_num += 1
        old_lines = file(self.report).readlines()
        file_hand = file(self.report,"w")
        find_flag = 0

        for id1,line in enumerate(old_lines):
            if line.startswith("Total"):
                break
            if id1 == 0:
                file_hand.write(line)
            else:
                try:
                    old_design = line.split(",")[1]
                    if old_design.strip() == self.design:
                        file_hand.write(",".join(new_record)+"\n")
                        find_flag = 1
                    else:
                        file_hand.write(line)
                        if line.find(",Error,")!= -1 or line.find(",Fail,")!= -1:
                            fail_num += 1
                        else:
                            pass_num += 1

                        total_num += 1
                except:
                    file_hand.write(line)
                    print("Warning: find a line which not follow the format")
        if not find_flag:
            file_hand.write(",".join(new_record)+"\n")
        file_hand.write("Total,Pass,Fail\n")
        file_hand.write("%s,%s,%s"%(total_num,pass_num,fail_num))
        file_hand.close()

    def print_xml(self):
        print("====resource start====")
        for title in self.init_titles:
            print("<"+title.replace("/","_")+">"+self.init_data.get(title,"NA")+"</"+title.replace("/","_")+">")
        print("====resource end====")

if __name__ == "__main__":
    scan_instance = scan()
    scan_instance.scan_info()








