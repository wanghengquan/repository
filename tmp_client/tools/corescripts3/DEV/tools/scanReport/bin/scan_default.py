import os
import re


MUST_HAVE = (
    'sim_rtl_time',
    'sim_syn_time',
    'sim_map_time',
    'sim_par_time',
    'sim_tool',
)


LOCAL_URL = 'mysql+pymysql://root:1234@localhost:3306/test'

SCAN_FMAX_START_PRE = r'4\.1  Setup Detailed Report'
SCAN_FMAX_START_CONSTRAINT = r'4\.1\.\d+.+?constraint\:\s+(?P<Constraint>.+?\-name\s+\{(?P<clkname>.+?)\}\s+-.+?$)'
SCAN_FMAX_END_CONSTRAINT = r'(End of Detailed Report for timing paths|End-of-path required time)'
MAX_FMAX = 500

class Default:
    def __init__(self, options):
        radiant_rdf = os.path.join(options['tag'], '*.rdf')
        radiant_sweep_sim_log = os.path.join(options['tag_path'], "*", "run_sim*.log")
        radiant_sweep_runtime_log = os.path.join(options['tag_path'], 'runtime_console.log')
        radiant_sweep_run_pb_log = os.path.join(options['tag_path'], "run_till_map.log")
        radiant_sweep_mrp_file = os.path.join(options['tag_path'], options['seed_folder'], "*", "*.mrp")
        radiant_sweep_par_file = os.path.join(options['tag_path'], options['seed_folder'], "*", "*.par")
        radiant_sweep_synthesis_log = os.path.join(options['tag_path'], "*", "synthesis.log")
        radiant_sweep_srr_file = os.path.join(options['tag_path'], "*", "*.srr")
        radiant_sweep_twr_file = os.path.join(options['tag_path'], options['seed_folder'], "*", "*.twr")
        radiant_no_sweep_sim_log = os.path.join(options['tag_path'], "*", "run_sim*.log")
        radiant_no_sweep_run_pb_log = os.path.join(os.path.join(options['tag_path'], "run_pb.log"))
        radiant_no_sweep_mrp_file = os.path.join(options['tag_path'], "*", "*.mrp")
        radiant_no_sweep_par_file = os.path.join(options['tag_path'], "*", "*.dir", "*.par")
        radiant_no_sweep_synthesis_log = os.path.join(options['tag_path'], "*", "synthesis.log")
        radiant_no_sweep_srr_file = os.path.join(options['tag_path'], "*", "*.srr")
        radiant_no_sweep_twr_file = os.path.join(options['tag_path'], "*", "*.twr")
        radiant_no_sweep_runtime_log = os.path.join(options['tag_path'], 'runtime_console.log')

        diamond_ldf = os.path.join(options['tag'], '*.ldf')
        diamond_sweep_sim_log = os.path.join(options['tag_path'], "*", "run_sim*.log")
        diamond_sweep_runtime_log = os.path.join(options['tag_path'], 'runtime_console.log')
        diamond_sweep_run_pb_log = os.path.join(options['tag_path'], "run_till_map.log")
        diamond_sweep_mrp_file = os.path.join(options['tag_path'], options['seed_folder'], "*", "*.mrp")
        diamond_sweep_par_file = os.path.join(options['tag_path'], options['seed_folder'], "*", "*.par")
        diamond_sweep_synthesis_log = os.path.join(options['tag_path'], "*", "synthesis.log")
        diamond_sweep_srr_file = os.path.join(options['tag_path'], "*", "*.srr")
        diamond_sweep_twr_file = os.path.join(options['tag_path'], options['seed_folder'], "*", "*.twr")
        diamond_no_sweep_sim_log = os.path.join(options['tag_path'], "*", "run_sim*.log")
        diamond_no_sweep_run_pb_log = os.path.join(os.path.join(options['tag_path'], "run_pb.log"))
        diamond_no_sweep_runtime_log = os.path.join(options['tag_path'], 'runtime_console.log')
        diamond_no_sweep_mrp_file = os.path.join(options['tag_path'], "*", "*.mrp")
        diamond_no_sweep_par_file = os.path.join(options['tag_path'], "*", "*.dir", "*.par")
        diamond_no_sweep_synthesis_log = os.path.join(options['tag_path'], "*", "synthesis.log")
        diamond_no_sweep_srr_file = os.path.join(options['tag_path'], "*", "*.srr")
        diamond_no_sweep_twr_file = os.path.join(options['tag_path'], "*", "*.twr")

        self.radiant = {
            'sweep': {
                'file': {
                    'prj_info_synthesis_file': radiant_rdf,
                    'prj_info_device_file': radiant_rdf,
                    'prj_info_version_file': radiant_sweep_mrp_file,
                    'prj_info_HDL_type_file': radiant_rdf,

                    'timing_seed_file': radiant_sweep_twr_file,
                    'timing_scoreSetup_file': radiant_sweep_par_file,
                    'timing_scoreHold_file': radiant_sweep_par_file,
                    'timing_maxloads_file': radiant_sweep_mrp_file,
                    'timing_totalloads_file': radiant_sweep_mrp_file,

                    'resource_Register_file': radiant_sweep_mrp_file,
                    'resource_Register_per_file': radiant_sweep_mrp_file,
                    'resource_Slice_file': radiant_sweep_par_file,
                    'resource_Slice_per_file': radiant_sweep_par_file,
                    'resource_LUT_file': radiant_sweep_mrp_file,
                    'resource_LUT_per_file': radiant_sweep_mrp_file,
                    'resource_IO_file': radiant_sweep_mrp_file,
                    'resource_IO_per_file': radiant_sweep_mrp_file,
                    'resource_EBR_file': radiant_sweep_mrp_file,
                    'resource_LRAM_file': radiant_sweep_mrp_file,
                    'resource_DSP_file': radiant_sweep_mrp_file,
                    'resource_DSP_PREADD9_file': radiant_sweep_mrp_file,
                    'resource_DSP_MULT9_file': radiant_sweep_mrp_file,
                    'resource_DSP_MULT18_file': radiant_sweep_mrp_file,
                    'resource_DSP_M18X36_file': radiant_sweep_mrp_file,
                    'resource_DSP_MULT36_file': radiant_sweep_mrp_file,
                    'resource_DSP_ACC54_file': radiant_sweep_mrp_file,
                    'resource_DSP_REG18_file': radiant_sweep_mrp_file,
                    'resource_CARRY_file': radiant_sweep_mrp_file,
                    'resource_DistributedRAM_file': radiant_sweep_mrp_file,
                    'resource_clkNumber_file': radiant_sweep_mrp_file,
                    'resource_clkEnNumber_file': radiant_sweep_mrp_file,
                    'resource_LSRNumber_file': radiant_sweep_mrp_file,
                    'resource_clkMaxLoad_file': radiant_sweep_mrp_file,
                    'resource_clkEnMaxLoad_file': radiant_sweep_mrp_file,
                    'resource_LSRMaxLoad_file': radiant_sweep_mrp_file,

                    'lse_reg_file': radiant_sweep_synthesis_log,
                    'lse_carry_file': radiant_sweep_synthesis_log,
                    'lse_io_file': radiant_sweep_synthesis_log,
                    'lse_lut4_file': radiant_sweep_synthesis_log,
                    'lse_ebr_file': radiant_sweep_synthesis_log,
                    'lse_dsp_file': radiant_sweep_synthesis_log,
                    'lse_odd_file': radiant_sweep_synthesis_log,
                    'lse_even_file': radiant_sweep_synthesis_log,

                    'par_signals_file': radiant_sweep_par_file,
                    'par_connections_file': radiant_sweep_par_file,
                    'par_congestion_level_file': radiant_sweep_par_file,
                    'par_congestion_area_file': radiant_sweep_par_file,
                    'par_congestion_area_per_file': radiant_sweep_par_file,
                    'par_setupPAP_file': radiant_sweep_par_file, 

                    'cpu_Placer_cpu_Time_file': radiant_sweep_par_file,
                    'cpu_Router_cpu_Time_file': radiant_sweep_par_file,
                    'cpu_par_cpu_Time_file': radiant_sweep_par_file,
                    'cpu_par_real_Time_file': radiant_sweep_par_file,
                    'cpu_map_cpu_Time_file': radiant_sweep_mrp_file,
                    'cpu_map_real_Time_file': radiant_sweep_mrp_file,
                    'cpu_synp_Time_file': radiant_sweep_srr_file,
                    'cpu_postsyn_cpu_Time_file': radiant_sweep_run_pb_log,
                    'cpu_postsyn_real_Time_file': radiant_sweep_run_pb_log,
                    'cpu_lse_cpu_Time_file': radiant_sweep_synthesis_log,
                    
                    'memory_lse_peak_Memory_file': radiant_sweep_synthesis_log,
                    'memory_synp_peak_Memory_file': radiant_sweep_srr_file,
                    'memory_postsyn_peak_Memory_file': radiant_sweep_run_pb_log,
                    'memory_map_peak_Memory_file': radiant_sweep_mrp_file,
                    'memory_ParPeakMem_file': radiant_sweep_par_file,

                    'comments_mapComments_file': radiant_sweep_mrp_file,
                    'comments_parComments_file': radiant_sweep_par_file,

                    'milestone_Synplify_file': radiant_sweep_srr_file,
                    'milestone_LSE_file': radiant_sweep_synthesis_log,
                    'milestone_Map_file': radiant_sweep_mrp_file,
                    'milestone_Par_file': radiant_sweep_par_file,

                    'simulation_sim_tool_file': radiant_sweep_sim_log,
                    'simulation_sim_time_file': radiant_sweep_runtime_log,
                },

                'pattern': {
                    'prj_info_synthesis_pattern': '\s+synthesis="([^"]+)"\s+',
                    'prj_info_device_pattern': [
                        '\s+device="([^"]+)"\s+',
                        'performance_grade="([^"]+)"\s+'
                    ],
                    'prj_info_version_pattern': 'Mapper:\s+version(.+)',
                    'prj_info_HDL_type_pattern': '<Source name.+type="([^"]+)"',
                    'prj_info_HDL_type_exclude_pattern': 'excluded="TRUE">',

                    'timing_constraint_coverage_pattern': 'Constraint Coverage:\s+(.+)',
                    'timing_total_neg_slack_setup_pattern': 'Total Negative Slack:.+([\d\.]+)\s+ns\s+\(setup\)',
                    'timing_total_neg_slack_hold_pattern': 'Total Negative Slack:.+([\d\.]+)\s+ns\s+\(hold\)',
                    'timing_route_logic_pattern': 'Delay\s+Ratio\s+:\s+([\d\.]+)%\s+\(route\),'
                                                  '\s+([\d\.]+)%\s+\(logic\)',
                    'timing_path_delay_pattern': '\+\s+Data Path Delay\s+([\d\.]+)',
                    'timing_arrive_time_pattern': 'Clock\s+Arrival\s+Time.+?:(\w+)',
                    'timing_setup_path_pattern': '^[\d\.]+\s+Setup path details for constraint:'
                                                 '.+get_(ports|nets)\s+([^\]]+)\]',
                    'timing_path_pattern': '\++\s*Path\s+1\s+\++',
                    'timing_scoreSetup_pattern': 'PAR_SUMMARY::Timing score<setup/<ns>> =\s+([\d\.]+)',
                    'timing_scoreHold_pattern': 'PAR_SUMMARY::Timing score<hold /<ns>> =\s+([\d\.]+)',
                    'timing_CombineLoop_pattern': '\++\s+Loop\d+',
                    'timing_maxloads_pattern': '(Pin|Port|Net)\s+[^:]+:\s+(?P<maxLoads>\d+)\s*loads,\s+'
                                                 '.+?\((Net|Driver):\s+[^\)]+\)',
                    'timing_totalloads_pattern': '(Pin|Port|Net)\s+[^:]+:\s+(?P<totalLoads>\d+)\s*loads,\s+'
                                                   '.+?\((Net|Driver):\s+[^\)]+\)',

                    'resource_start_pattern': 'Number\s+of\s+Signals:\s+(.+)',
                    'resource_Register_pattern': 'Number\s+of.+?registers:\s+(\d+)',
                    'resource_Register_per_pattern': 'Number\s+of.+?registers:\s+\d+.+\((.+)\)',
                    'resource_Slice_pattern': 'SLICE\s+(\d+)/\d+\s+\S+\s+used',
                    'resource_Slice_per_pattern': 'SLICE\s+\d+/\d+\s+(\S+)\s+used',
                    'resource_LUT_pattern': 'Number of LUT4s:\s+(\d+)',
                    'resource_LUT_per_pattern': 'Number of LUT4s:.+out\s+of\s+\d+\s+\((.+)\)',
                    'resource_IO_pattern': 'Number of P?[IO sites|IOs].+used:\s+(\d+)',
                    'resource_IO_per_pattern': 'Number of P?[IO sites|IOs].+used:\s+\d+.+\((.+)\)',
                    'resource_EBR_pattern': 'Number of (?:EBRs|Block\s+RAMs|block\s+RAMs):\s+(\d+)',
                    'resource_LRAM_pattern': 'Number of Large RAMs:\s+(\d+)',
                    'resource_DSP_pattern': 'Number of DSPs:\s+(\d+)',
                    'resource_DSP_PREADD9_pattern': 'Number of PREADD9:\s+(\d+)',
                    'resource_DSP_MULT9_pattern': 'Number of MULT9:\s+(\d+)',
                    'resource_DSP_MULT18_pattern': 'Number of MULT18:\s+(\d+)',
                    'resource_DSP_M18X36_pattern': 'Number of M18X36:\s+(\d+)',
                    'resource_DSP_MULT36_pattern': 'Number of MULT36:\s+(\d+)',
                    'resource_DSP_ACC54_pattern': 'Number of ACC54:\s+(\d+)',
                    'resource_DSP_REG18_pattern': 'Number of REG18:\s+(\d+)',
                    'resource_CARRY_pattern': [
                        "Number\s+of\s+ripple\s+logic:\s+(?P<CARRY>\d+)",
                        "Number\s+used\s+as\s+ripple\s+logic:\s+(?P<CARRY>\d+)"
                    ],
                    'resource_DistributedRAM_pattern': 'Number\s+used\s+as\s+distributed\s+RAM:\s+(\d+)',
                    'resource_clkNumber_pattern': 'Number of clocks:\s+(\d+)',
                    'resource_clkEnNumber_pattern': 'Number of Clock Enables:\s+(\d+)',
                    'resource_LSRNumber_pattern': 'Number of LSRs:\s+(\d+)',
                    'resource_clkMaxLoad_pattern': '(Net|Pin)\s+(?P<clkMaxLoadName>.+?)\s*:\s+(?P<clkMaxLoadNum>\d+)\s*loads',
                    'resource_clkMaxLoad_start_pattern': 'Number of Clocks',
                    'resource_clkMaxLoad_stop_pattern': 'Number of Clock Enables',
                    'resource_clkEnMaxLoad_pattern': '(Net|Pin)\s+(?P<clkEnMaxLoadName>.+?)\s*:\s+'
                                                     '(?P<clkEnMaxLoadNum>\d+)\s*loads',
                    'resource_clkEnMaxLoad_start_pattern': 'Number of Clock Enables',
                    'resource_clkEnMaxLoad_stop_pattern': 'Number of LSR',
                    'resource_LSRMaxLoad_pattern': '(Net|Pin)\s+(?P<LSRMaxLoadName>.+?)\s*:\s+(?P<LSRMaxLoadNum>\d+)\s*loads',
                    'resource_LSRMaxLoad_start_pattern': 'Number of LSR',
                    'resource_LSRMaxLoad_stop_pattern': 'Top 10 highest fanout non-clock nets',

                    'lse_reg_pattern': 'Number of register bits\s*=>\s*(\d+)',
                    'lse_carry_pattern': ['CCU2\s*=>\s*(?P<lse_carry>\d+)', 'FA2\s*=>\s*(?P<lse_carry>\d+)'],
                    'lse_io_pattern': 'BB_B\s*=>\s*(\d+)',
                    'lse_lut4_pattern': 'LUT4\s*=>\s*(\d+)',
                    'lse_ebr_pattern': [
                        'EBR_B\s*=>\s*(?P<lse_ebr>\d+)',
                        'VFB_B\s*=>\s*(?P<lse_ebr>\d+)',
                    ],
                    'lse_dsp_pattern': 'MAC16\s*=>\s*(\d+)',
                    'lse_odd_pattern': 'Number of odd-length carry chains :\s*(\d+)',
                    'lse_even_pattern': 'Number of even-length carry chains :\s*(\d+)',
                    'lse_start_pattern': 'Begin Area Report',
                    'lse_stop_pattern': 'Begin Clock Report',

                    'par_signals_pattern': 'Number\s+of\s+Signals:\s+(.+)',
                    'par_connections_pattern': 'Number\s+of\s+Connections:\s+(.+)',
                    'par_congestion_level_pattern': 'Initial\s+congestion\s+level\s+at.+is\s+(\d+)',
                    'par_congestion_area_pattern': 'Initial\s+congestion\s+area.+is\s+(\d+)',
                    'par_congestion_area_per_pattern': 'Initial\s+congestion\s+area.+is\s+\d+\s+\(([^\)]+)\)',
                    'par_setupPAP_pattern': 'PAR_SUMMARY::Timing\s+PAP<setup/<ns>>\s+=\s+([\d\.]+)',
                    'par_start_pattern': 'Number\s+of\s+Signals:\s+(.+)',

                    'cpu_Placer_cpu_Time_pattern': 'Total\s+Placer\s+CPU\s+time:([^,]+),',
                    'cpu_Router_cpu_Time_pattern': 'Total\s+CPU\s+time\s+(.+)',
                    'cpu_router_stop_pattern': 'End\s+of\s+route',
                    'cpu_par_start_pattern': 'End\s+of\s+route',
                    'cpu_par_cpu_Time_pattern': 'Total\s+CPU\s+Time:(.+)',
                    'cpu_par_real_Time_pattern': 'Total\s+REAL\s+Time:(.+)',
                    'cpu_map_cpu_Time_pattern': 'Total CPU Time:\s+(.+)',
                    'cpu_map_real_Time_pattern': 'Total REAL Time:\s+(.+)',
                    'cpu_synp_Time_pattern': [
                        re.compile("(Pre-mapping|Mapper)\s+(successful!)"),
                        re.compile("""At\s+(Mapper|c_hdl|syn_nfilter|c_vhdl)\s+Exit\s+\(Real\s+
                                    Time\s+elapsed\s+(\S+);\s+CPU\s+Time\s+elapsed\s+(\S+)""", re.X)
                    ],
                    'cpu_postsyn_cpu_Time_pattern': 'Total CPU Time:\s+(.+)',
                    'cpu_postsyn_real_Time_pattern': 'Total REAL Time:\s+(.+)',
                    'cpu_postsyn_start_pattern': 'Command Line: postsyn',
                    'cpu_postsyn_stop_pattern': 'Copyright',
                    'cpu_lse_cpu_Time_pattern': 'Total CPU Time:\s+(.+)',

                    'memory_lse_peak_Memory_pattern': 'Peak Memory Usage:\s+([\d\.]+)',
                    'memory_synp_peak_Memory_pattern': 'Memory used current:\s+\S+\s+peak:\s+(?P<synp_peak_Memory>\d+)',
                    'memory_postsyn_peak_Memory_pattern': 'Peak Memory Usage:\s+(\d+)',
                    'memory_postsyn_peak_Memory_start_pattern': 'Command Line: postsyn',
                    'memory_map_peak_Memory_pattern': 'Peak Memory Usage:\s+(\d+)',
                    'memory_ParPeakMem_pattern': 'after\s+PAR.+memory\s+([\d\.]+)\s+\S+$',

                    'comments_mapComments_pattern': '(ERROR\s+-\s+.{1,135})',
                    'comments_parComments_pattern': '(ERROR\s+-\s+.{1,135})',

                    'milestone_Synplify_pattern': 'Mapper\s+successful!',
                    'milestone_LSE_pattern': '',
                    'milestone_Map_pattern': 'Number\s+of\s+errors:\s+0',
                    'milestone_Par_pattern': 'All\s+signals\s+are\s+completely\s+routed',

                    'simulation_sim_active_tool_pattern': '(active-hdl)',
                    'simulation_sim_active_version_pattern': 'Simulator\s+build\s+([\d\.]+)',
                    'simulation_sim_modelsim_tool_pattern': 'Model\s+Technology\s+(ModelSim)',
                    'simulation_sim_modelsim_version_pattern': 'Edition\s+([\d\.]+)',
                    'simulation_sim_riviera_tool_pattern': '(riviera-pro)',
                    'simulation_sim_riviera_version_pattern': 'version\s+([\d\.]+)',
                    'simulation_sim_questa_tool_pattern': '(Questa Sim)',
                    'simulation_sim_questa_version_pattern': 'Version\s+(.+?)\s',
                    'simulation_sim_rtl_start_pattern': '(.+?/.+?)/.+?/vsim.+?do_sim_rtl',
                    'simulation_sim_syn_start_pattern': '(.+?/.+?)/.+?/vsim.+?do_sim_syn',
                    'simulation_sim_map_start_pattern': '(.+?/.+?)/.+?/vsim.+?do_sim_map',
                    'simulation_sim_par_start_pattern': '(.+?/.+?)/.+?/vsim.+?do_sim_par',
                    'simulation_sim_time_pattern': 'Elapsed Time: (.+?)\s+seconds',
                    'simulation_sim_time_stop_pattern': '^$',
                },
            },

            'no_sweep': {
                'file': {
                    'prj_info_synthesis_file': radiant_rdf,
                    'prj_info_device_file': radiant_rdf,
                    'prj_info_version_file': radiant_no_sweep_run_pb_log,
                    'prj_info_HDL_type_file': radiant_rdf,

                    'timing_seed_file': radiant_no_sweep_twr_file,
                    'timing_scoreSetup_file': radiant_no_sweep_par_file,
                    'timing_scoreHold_file': radiant_no_sweep_par_file,
                    'timing_maxloads_file': radiant_no_sweep_mrp_file,
                    'timing_totalloads_file': radiant_no_sweep_mrp_file,
                    
                    'resource_Register_file': radiant_no_sweep_mrp_file,
                    'resource_Register_per_file': radiant_no_sweep_mrp_file,
                    'resource_Slice_file': radiant_no_sweep_par_file,
                    'resource_Slice_per_file': radiant_no_sweep_par_file,
                    'resource_LUT_file': radiant_no_sweep_mrp_file,
                    'resource_LUT_per_file': radiant_no_sweep_mrp_file,
                    'resource_IO_file': radiant_no_sweep_mrp_file,
                    'resource_IO_per_file': radiant_no_sweep_mrp_file,
                    'resource_EBR_file': radiant_no_sweep_mrp_file,
                    'resource_LRAM_file': radiant_sweep_mrp_file,
                    'resource_DSP_file': radiant_no_sweep_mrp_file,
                    'resource_DSP_PREADD9_file': radiant_no_sweep_mrp_file,
                    'resource_DSP_MULT9_file': radiant_no_sweep_mrp_file,
                    'resource_DSP_MULT18_file': radiant_no_sweep_mrp_file,
                    'resource_DSP_M18X36_file': radiant_no_sweep_mrp_file,
                    'resource_DSP_MULT36_file': radiant_no_sweep_mrp_file,
                    'resource_DSP_ACC54_file': radiant_no_sweep_mrp_file,
                    'resource_DSP_REG18_file': radiant_no_sweep_mrp_file,
                    'resource_CARRY_file': radiant_no_sweep_mrp_file,
                    'resource_DistributedRAM_file': radiant_no_sweep_mrp_file,
                    'resource_clkNumber_file': radiant_no_sweep_mrp_file,
                    'resource_clkEnNumber_file': radiant_no_sweep_mrp_file,
                    'resource_LSRNumber_file': radiant_no_sweep_mrp_file,
                    'resource_clkMaxLoad_file': radiant_no_sweep_mrp_file,
                    'resource_clkEnMaxLoad_file': radiant_no_sweep_mrp_file,
                    'resource_LSRMaxLoad_file': radiant_no_sweep_mrp_file,

                    'lse_reg_file': radiant_no_sweep_synthesis_log,
                    'lse_carry_file': radiant_no_sweep_synthesis_log,
                    'lse_io_file': radiant_no_sweep_synthesis_log,
                    'lse_lut4_file': radiant_no_sweep_synthesis_log,
                    'lse_ebr_file': radiant_no_sweep_synthesis_log,
                    'lse_dsp_file': radiant_no_sweep_synthesis_log,
                    'lse_odd_file': radiant_no_sweep_synthesis_log,
                    'lse_even_file': radiant_no_sweep_synthesis_log,

                    'par_signals_file': radiant_no_sweep_par_file,
                    'par_connections_file': radiant_no_sweep_par_file,
                    'par_congestion_level_file': radiant_no_sweep_par_file,
                    'par_congestion_area_file': radiant_no_sweep_par_file,
                    'par_congestion_area_per_file': radiant_no_sweep_par_file,
                    'par_setupPAP_file': radiant_no_sweep_par_file, 

                    'cpu_Placer_cpu_Time_file': radiant_no_sweep_par_file,
                    'cpu_Router_cpu_Time_file': radiant_no_sweep_par_file,
                    'cpu_par_cpu_Time_file': radiant_no_sweep_par_file,
                    'cpu_par_real_Time_file': radiant_no_sweep_par_file,
                    'cpu_map_cpu_Time_file': radiant_no_sweep_mrp_file,
                    'cpu_map_real_Time_file': radiant_no_sweep_mrp_file,
                    'cpu_synp_Time_file': radiant_no_sweep_srr_file,
                    'cpu_postsyn_cpu_Time_file': radiant_no_sweep_run_pb_log,
                    'cpu_postsyn_real_Time_file': radiant_no_sweep_run_pb_log,
                    'cpu_lse_cpu_Time_file': radiant_no_sweep_synthesis_log,

                    'memory_lse_peak_Memory_file': radiant_no_sweep_synthesis_log,
                    'memory_synp_peak_Memory_file': radiant_no_sweep_srr_file,
                    'memory_postsyn_peak_Memory_file': radiant_no_sweep_run_pb_log,
                    'memory_map_peak_Memory_file': radiant_no_sweep_mrp_file,
                    'memory_ParPeakMem_file': radiant_no_sweep_par_file,

                    'comments_mapComments_file': radiant_no_sweep_mrp_file,
                    'comments_parComments_file': radiant_no_sweep_par_file,

                    'milestone_Synplify_file': radiant_no_sweep_srr_file,
                    'milestone_LSE_file': radiant_no_sweep_synthesis_log,
                    'milestone_Map_file': radiant_no_sweep_mrp_file,
                    'milestone_Par_file': radiant_no_sweep_par_file,

                    'simulation_sim_tool_file': radiant_no_sweep_sim_log,
                    'simulation_sim_time_file': radiant_no_sweep_runtime_log,
                },

                'pattern': {
                    'prj_info_synthesis_pattern': '\s+synthesis="([^"]+)"\s+',
                    'prj_info_device_pattern': [
                        '\s+device="([^"]+)"\s+',
                        'performance_grade="([^"]+)"\s+'
                    ],
                    'prj_info_version_pattern': 'map:\s+version\s+(.+)',
                    'prj_info_HDL_type_pattern': '<Source name.+type="([^"]+)"',
                    'prj_info_HDL_type_exclude_pattern': 'excluded="TRUE">',

                    'timing_constraint_coverage_pattern': 'Constraint Coverage:\s+(.+)',
                    'timing_total_neg_slack_setup_pattern': 'Total Negative Slack:.+([\d\.]+)\s+ns\s+\(setup\)',
                    'timing_total_neg_slack_hold_pattern': 'Total Negative Slack:.+([\d\.]+)\s+ns\s+\(hold\)',
                    'timing_route_logic_pattern': 'Delay\s+Ratio\s+:\s+([\d\.]+)%\s+\(route\),'
                                                  '\s+([\d\.]+)%\s+\(logic\)',
                    'timing_path_delay_pattern': '\+\s+Data Path Delay\s+([\d\.]+)',
                    'timing_arrive_time_pattern': 'Clock\s+Arrival\s+Time.+?:(\w+)',
                    'timing_setup_path_pattern': '^[\d\.]+\s+Setup path details for constraint:'
                                                 '.+get_(ports|nets)\s+([^\]]+)\]',
                    'timing_path_pattern': '\++\s*Path\s+1\s+\++',
                    'timing_scoreSetup_pattern': 'PAR_SUMMARY::Timing score<setup/<ns>> =\s+([\d\.]+)',
                    'timing_scoreHold_pattern': 'PAR_SUMMARY::Timing score<hold /<ns>> =\s+([\d\.]+)',
                    'timing_CombineLoop_pattern': '\++\s+Loop\d+',
                    'timing_maxloads_pattern': '(Pin|Port|Net)\s+[^:]+:\s+(?P<maxLoads>\d+)\s*loads,\s+'
                                                 '.+?\((Net|Driver):\s+[^\)]+\)',
                    'timing_totalloads_pattern': '(Pin|Port|Net)\s+[^:]+:\s+(?P<totalLoads>\d+)\s*loads,\s+'
                                                   '.+?\((Net|Driver):\s+[^\)]+\)',

                    'resource_Register_pattern': 'Number\s+of.+?registers:\s+(\d+)',
                    'resource_Register_per_pattern': 'Number\s+of.+?registers:\s+\d+.+\((.+)\)',
                    'resource_Slice_pattern': 'SLICE\s+(\d+)/\d+\s+\S+\s+used',
                    'resource_Slice_per_pattern': 'SLICE\s+\d+/\d+\s+(\S+)\s+used',
                    'resource_LUT_pattern': 'Number of LUT4s:\s+(\d+)',
                    'resource_LUT_per_pattern': 'Number of LUT4s:.+out\s+of\s+\d+\s+\((.+)\)',
                    'resource_IO_pattern': 'Number of P?[IO sites|IOs].+used:\s+(\d+)',
                    'resource_IO_per_pattern': 'Number of P?[IO sites|IOs].+used:\s+\d+.+\((.+)\)',
                    'resource_EBR_pattern': 'Number of (?:EBRs|Block\s+RAMs|block\s+RAMs):\s+(\d+)',
                    'resource_LRAM_pattern': 'Number of Large RAMs:\s+(\d+)',
                    'resource_DSP_pattern': 'Number of DSPs:\s+(\d+)',
                    'resource_DSP_PREADD9_pattern': 'Number of PREADD9:\s+(\d+)',
                    'resource_DSP_MULT9_pattern': 'Number of MULT9:\s+(\d+)',
                    'resource_DSP_MULT18_pattern': 'Number of MULT18:\s+(\d+)',
                    'resource_DSP_M18X36_pattern': 'Number of M18X36:\s+(\d+)',
                    'resource_DSP_MULT36_pattern': 'Number of MULT36:\s+(\d+)',
                    'resource_DSP_ACC54_pattern': 'Number of ACC54:\s+(\d+)',
                    'resource_DSP_REG18_pattern': 'Number of REG18:\s+(\d+)',
                    'resource_CARRY_pattern': [
                        "Number\s+of\s+ripple\s+logic:\s+(?P<CARRY>\d+)",
                        "Number\s+used\s+as\s+ripple\s+logic:\s+(?P<CARRY>\d+)"
                    ],
                    'resource_DistributedRAM_pattern': 'Number\s+used\s+as\s+distributed\s+RAM:\s+(\d+)',
                    'resource_clkNumber_pattern': 'Number of clocks:\s+(\d+)',
                    'resource_clkEnNumber_pattern': 'Number of Clock Enables:\s+(\d+)',
                    'resource_LSRNumber_pattern': 'Number of LSRs:\s+(\d+)',
                    'resource_clkMaxLoad_pattern': '(Net|Pin)\s+(?P<clkMaxLoadName>.+?)\s*:\s+(?P<clkMaxLoadNum>\d+)\s*loads',
                    'resource_clkMaxLoad_start_pattern': 'Number of Clocks',
                    'resource_clkMaxLoad_stop_pattern': 'Number of Clock Enables',
                    'resource_clkEnMaxLoad_pattern': '(Net|Pin)\s+(?P<clkEnMaxLoadName>.+?)\s*:\s+'
                                                     '(?P<clkEnMaxLoadNum>\d+)\s*loads',
                    'resource_clkEnMaxLoad_start_pattern': 'Number of Clock Enables',
                    'resource_clkEnMaxLoad_stop_pattern': 'Number of LSR',
                    'resource_LSRMaxLoad_pattern': '(Net|Pin)\s+(?P<LSRMaxLoadName>.+?)\s*:\s+(?P<LSRMaxLoadNum>\d+)\s*loads',
                    'resource_LSRMaxLoad_start_pattern': 'Number of LSR',
                    'resource_LSRMaxLoad_stop_pattern': 'Top 10 highest fanout non-clock nets',

                    'lse_reg_pattern': 'Number of register bits\s*=>\s*(\d+)',
                    'lse_carry_pattern': ['CCU2\s*=>\s*(?P<lse_carry>\d+)', 'FA2\s*=>\s*(?P<lse_carry>\d+)'],
                    'lse_io_pattern': 'BB_B\s*=>\s*(\d+)',
                    'lse_lut4_pattern': 'LUT4\s*=>\s*(\d+)',
                    'lse_ebr_pattern': [
                        'EBR_B\s*=>\s*(?P<lse_ebr>\d+)',
                        'VFB_B\s*=>\s*(?P<lse_ebr>\d+)',
                    ],
                    'lse_dsp_pattern': 'MAC16\s*=>\s*(\d+)',
                    'lse_odd_pattern': 'Number of odd-length carry chains :\s*(\d+)',
                    'lse_even_pattern': 'Number of even-length carry chains :\s*(\d+)',
                    'lse_start_pattern': 'Begin Area Report',
                    'lse_stop_pattern': 'Begin Clock Report',

                    'par_signals_pattern': 'Number\s+of\s+Signals:\s+(.+)',
                    'par_connections_pattern': 'Number\s+of\s+Connections:\s+(.+)',
                    'par_congestion_level_pattern': 'Initial\s+congestion\s+level\s+at.+is\s+(\d+)',
                    'par_congestion_area_pattern': 'Initial\s+congestion\s+area.+is\s+(\d+)',
                    'par_congestion_area_per_pattern': 'Initial\s+congestion\s+area.+is\s+\d+\s+\(([^\)]+)\)',
                    'par_setupPAP_pattern': 'PAR_SUMMARY::Timing\s+PAP<setup/<ns>>\s+=\s+([\d\.]+)',
                    'par_start_pattern': 'Number\s+of\s+Signals:\s+(.+)',

                    'cpu_Placer_cpu_Time_pattern': 'Total\s+Placer\s+CPU\s+time:([^,]+),',
                    'cpu_Router_cpu_Time_pattern': 'Total\s+CPU\s+time\s+(.+)',
                    'cpu_router_stop_pattern': 'End\s+of\s+route',
                    'cpu_par_start_pattern': 'End\s+of\s+route',
                    'cpu_par_cpu_Time_pattern': 'Total\s+CPU\s+Time:(.+)',
                    'cpu_par_real_Time_pattern': 'Total\s+REAL\s+Time:(.+)',
                    'cpu_map_cpu_Time_pattern': 'Total CPU Time:\s+(.+)',
                    'cpu_map_real_Time_pattern': 'Total REAL Time:\s+(.+)',
                    'cpu_synp_Time_pattern': [
                        re.compile("(Pre-mapping|Mapper)\s+(successful!)"),
                        re.compile("""At\s+(Mapper|c_hdl|syn_nfilter|c_vhdl)\s+Exit\s+\(Real\s+
                        Time\s+elapsed\s+(\S+);\s+CPU\s+Time\s+elapsed\s+(\S+)""", re.X)
                    ],
                    'cpu_postsyn_cpu_Time_pattern': 'Total CPU Time:\s+(.+)',
                    'cpu_postsyn_real_Time_pattern': 'Total REAL Time:\s+(.+)',
                    'cpu_postsyn_start_pattern': 'Command Line: postsyn',
                    'cpu_postsyn_stop_pattern': 'Copyright',
                    'cpu_lse_cpu_Time_pattern': 'Total CPU Time:\s+(.+)',

                    'memory_lse_peak_Memory_pattern': 'Peak Memory Usage:\s+([\d\.]+)',
                    'memory_synp_peak_Memory_pattern': 'Memory used current:\s+\S+\s+peak:\s+(?P<synp_peak_Memory>\d+)',
                    'memory_postsyn_peak_Memory_pattern': 'Peak Memory Usage:\s+(\d+)',
                    'memory_postsyn_peak_Memory_start_pattern': 'Command Line: postsyn',
                    'memory_map_peak_Memory_pattern': 'Peak Memory Usage:\s+(\d+)',
                    'memory_ParPeakMem_pattern': 'after\s+PAR.+memory\s+([\d\.]+)\s+\S+$',

                    'comments_mapComments_pattern': '(ERROR\s+-\s+.{1,135})',
                    'comments_parComments_pattern': '(ERROR\s+-\s+.{1,135})',

                    'milestone_Synplify_pattern': 'Mapper\s+successful!',
                    'milestone_LSE_pattern': '',
                    'milestone_Map_pattern': 'Number\s+of\s+errors:\s+0',
                    'milestone_Par_pattern': 'All\s+signals\s+are\s+completely\s+routed',

                    'simulation_sim_active_tool_pattern': '(active-hdl)',
                    'simulation_sim_active_version_pattern': 'Simulator\s+build\s+([\d\.]+)',
                    'simulation_sim_modelsim_tool_pattern': 'Model\s+Technology\s+(ModelSim)',
                    'simulation_sim_modelsim_version_pattern': 'Edition\s+([\d\.]+)',
                    'simulation_sim_riviera_tool_pattern': '(riviera-pro)',
                    'simulation_sim_riviera_version_pattern': 'version\s+([\d\.]+)',
                    'simulation_sim_questa_tool_pattern': '(Questa Sim)',
                    'simulation_sim_questa_version_pattern': 'Version\s+(.+?)\s',
                    'simulation_sim_rtl_start_pattern': '(.+?/.+?)/.+?/vsim.+?do_sim_rtl',
                    'simulation_sim_syn_start_pattern': '(.+?/.+?)/.+?/vsim.+?do_sim_syn',
                    'simulation_sim_map_start_pattern': '(.+?/.+?)/.+?/vsim.+?do_sim_map',
                    'simulation_sim_par_start_pattern': '(.+?/.+?)/.+?/vsim.+?do_sim_par',
                    'simulation_sim_time_pattern': 'Elapsed Time: (.+?)\s+seconds',
                    'simulation_sim_time_stop_pattern': '^$'
                },
            },
        }

        self.diamond = {
            'sweep': {
                'file': {
                    'prj_info_synthesis_file': diamond_ldf,
                    'prj_info_device_file': diamond_sweep_mrp_file,
                    'prj_info_version_file': diamond_sweep_mrp_file,
                    'prj_info_HDL_type_file': diamond_ldf,

                    'timing_seed_file': diamond_sweep_twr_file,
                    'timing_scoreSetup_file': diamond_sweep_par_file,
                    'timing_scoreHold_file': diamond_sweep_par_file,
                    'timing_maxloads_file': diamond_sweep_mrp_file,
                    'timing_totalloads_file': diamond_sweep_mrp_file,

                    'resource_Register_file': diamond_sweep_mrp_file,
                    'resource_Register_per_file': diamond_sweep_mrp_file,
                    'resource_Slice_file': diamond_sweep_par_file,
                    'resource_Slice_per_file': diamond_sweep_par_file,
                    'resource_LUT_file': diamond_sweep_mrp_file,
                    'resource_LUT_per_file': diamond_sweep_mrp_file,
                    'resource_IO_file': diamond_sweep_mrp_file,
                    'resource_IO_per_file': diamond_sweep_mrp_file,
                    'resource_EBR_file': diamond_sweep_mrp_file,
                    'resource_CARRY_file': diamond_sweep_mrp_file,
                    'resource_DistributedRAM_file': diamond_sweep_mrp_file,
                    'resource_clkNumber_file': diamond_sweep_mrp_file,
                    'resource_MULT18X18D_file': diamond_sweep_mrp_file,
                    'resource_MULT9X9D_file': diamond_sweep_mrp_file,
                    'resource_ALU54B_file': diamond_sweep_mrp_file,
                    'resource_ALU24B_file': diamond_sweep_mrp_file,
                    'resource_PRADD18A_file': diamond_sweep_mrp_file,
                    'resource_PRADD9A_file': diamond_sweep_mrp_file,
                    'resource_MULT36X36B_file': diamond_sweep_mrp_file,
                    'resource_MULT18X18B_file': diamond_sweep_mrp_file,
                    'resource_MULT18X18MACB_file': diamond_sweep_mrp_file,
                    'resource_MULT18X18ADDSUBB_file': diamond_sweep_mrp_file,
                    'resource_MULT18X18ADDSUBSUMB_file': diamond_sweep_mrp_file,
                    'resource_MULT9X9B_file': diamond_sweep_mrp_file,
                    'resource_MULT9X9ADDSUBB_file': diamond_sweep_mrp_file,
                    'resource_MULT18X18C_file': diamond_sweep_mrp_file,
                    'resource_MULT9X9C_file': diamond_sweep_mrp_file,
                    'resource_ALU54A_file': diamond_sweep_mrp_file,
                    'resource_ALU24A_file': diamond_sweep_mrp_file,
                    'resource_PCS_file': diamond_sweep_mrp_file,
                    'resource_clkEnNumber_file': diamond_sweep_mrp_file,
                    'resource_LSRNumber_file': diamond_sweep_mrp_file,
                    'resource_clkMaxLoad_file': diamond_sweep_mrp_file,
                    'resource_clkEnMaxLoad_file': diamond_sweep_mrp_file,
                    'resource_LSRMaxLoad_file': diamond_sweep_mrp_file,

                    'lse_reg_file': diamond_sweep_synthesis_log,
                    'lse_carry_file': diamond_sweep_synthesis_log,
                    'lse_io_file': diamond_sweep_synthesis_log,
                    'lse_lut4_file': diamond_sweep_synthesis_log,
                    'lse_ebr_file': diamond_sweep_synthesis_log,
                    'lse_dsp_file': diamond_sweep_synthesis_log,
                    'lse_odd_file': diamond_sweep_synthesis_log,
                    'lse_even_file': diamond_sweep_synthesis_log,

                    'par_signals_file': diamond_sweep_par_file,
                    'par_connections_file': diamond_sweep_par_file,
                    'par_congestion_level_file': diamond_sweep_par_file,
                    'par_congestion_area_file': diamond_sweep_par_file,
                    'par_congestion_area_per_file': diamond_sweep_par_file,

                    'cpu_Placer_cpu_Time_file': diamond_sweep_par_file,
                    'cpu_Router_cpu_Time_file': diamond_sweep_par_file,
                    'cpu_par_cpu_Time_file': diamond_sweep_par_file,
                    'cpu_par_real_Time_file': diamond_sweep_par_file,
                    'cpu_map_cpu_Time_file': diamond_sweep_mrp_file,
                    'cpu_map_real_Time_file': diamond_sweep_mrp_file,
                    'cpu_synp_Time_file': diamond_sweep_srr_file,
                    'cpu_postsyn_cpu_Time_file': diamond_sweep_run_pb_log,
                    'cpu_postsyn_real_Time_file': diamond_sweep_run_pb_log,
                    'cpu_lse_cpu_Time_file': diamond_sweep_synthesis_log,

                    'memory_lse_peak_Memory_file': diamond_sweep_synthesis_log,
                    'memory_synp_peak_Memory_file': diamond_sweep_srr_file,
                    'memory_postsyn_peak_Memory_file': diamond_sweep_run_pb_log,
                    'memory_map_peak_Memory_file': diamond_sweep_mrp_file,
                    'memory_ParPeakMem_file': diamond_sweep_par_file,

                    'comments_mapComments_file': diamond_sweep_mrp_file,
                    'comments_parComments_file': diamond_sweep_par_file,

                    'milestone_Synplify_file': diamond_sweep_srr_file,
                    'milestone_LSE_file': diamond_sweep_synthesis_log,
                    'milestone_Map_file': diamond_sweep_mrp_file,
                    'milestone_Par_file': diamond_sweep_par_file,

                    'simulation_sim_tool_file': diamond_sweep_sim_log,
                    'simulation_sim_time_file': diamond_sweep_runtime_log,
                },

                'pattern': {
                    'prj_info_synthesis_pattern': '\s+synthesis="([^"]+)"\s+',
                    'prj_info_device_pattern': [
                        '^Target Device:\s+(\S+)',
                        '^Target Performance:\s+(\S+)'
                    ],
                    'prj_info_version_pattern': '^Mapper:.+version:\s+(.+)',
                    'prj_info_HDL_type_pattern': '<Source name.+type="([^"]+)"',
                    'prj_info_HDL_type_exclude_pattern': 'excluded="TRUE">',

                    'timing_constraint_coverage_pattern': 'Constraints cover.+?\(([\d\.]+%)\s+coverage\)',
                    'timing_total_neg_slack_setup_pattern': 'Total Negative Slack:.+([\d\.]+)\s+ns\s+\(setup\)',
                    'timing_total_neg_slack_hold_pattern': 'Total Negative Slack:.+([\d\.]+)\s+ns\s+\(hold\)',
                    'timing_route_logic_pattern': '(?P<delay>[\d\.]+)ns\s+\((?P<logic>[\d\.]+%)\s+logic,\s+(?P<route>'
                                                  '[\d\.]+%)\s+route\),\s+(?P<level>\d+)\s+logic\s+level',
                    'timing_path_delay_pattern': '\+\s+Data Path Delay\s+([\d\.]+)',
                    'timing_arrive_time_pattern': 'Clock\s+Arrival\s+Time.+?:(\w+)',
                    'timing_setup_path_pattern': '^[\d\.]+\s+Setup path details for constraint:'
                                                 '.+get_(ports|nets)\s+([^\]]+)\]',
                    'timing_path_pattern': '\++\s*Path\s+1\s+\++',
                    'timing_scoreSetup_pattern': 'PAR_SUMMARY::Timing score<setup/<ns>> =\s+([\d\.]+)',
                    'timing_scoreHold_pattern': 'PAR_SUMMARY::Timing score<hold /<ns>> =\s+([\d\.]+)',
                    'timing_CombineLoop_pattern': '\++\s+Loop\d+',
                    'timing_maxloads_pattern': '(Pin|Port|Net)\s+[^:]+:\s+(?P<maxLoads>\d+)\s*loads,\s+'
                                               '.+?\((Net|Driver):\s+[^\)]+\)',
                    'timing_totalloads_pattern': '(Pin|Port|Net)\s+[^:]+:\s+(?P<totalLoads>\d+)\s*loads,\s+'
                                                 '.+?\((Net|Driver):\s+[^\)]+\)',

                    'resource_start_pattern': 'Number\s+of\s+Signals:\s+(.+)',
                    'resource_Register_pattern': 'Number of.+registers:\s+(\d+)',
                    'resource_Register_per_pattern': 'Number of.+registers:\s+\d+.+\((.+)\)',
                    'resource_Slice_pattern': 'SLICE\s+(\d+)/\d+\s+\S+\s+used',
                    'resource_Slice_per_pattern': 'SLICE\s+\d+/\d+\s+(\S+)\s+used',
                    'resource_LUT_pattern': 'Number of LUT4s:\s+(\d+)',
                    'resource_LUT_per_pattern': 'Number of LUT4s:.+out\s+of\s+\d+\s+\((.+)\)',
                    'resource_IO_pattern': 'Number of P?[IO sites|IOs].+used:\s+(\d+)',
                    'resource_IO_per_pattern': 'Number of P?[IO sites|IOs].+used:\s+\d+.+\((.+)\)',
                    'resource_EBR_pattern': 'Number of (?:EBRs|Block\s+RAMs|block\s+RAMs):\s+(\d+)',
                    'resource_CARRY_pattern': [
                        "Number\s+of\s+ripple\s+logic:\s+(?P<CARRY>\d+)",
                        "Number\s+used\s+as\s+ripple\s+logic:\s+(?P<CARRY>\d+)"
                    ],
                    'resource_DistributedRAM_pattern': 'Number\s+used\s+as\s+distributed\s+RAM:\s+(\d+)',
                    'resource_clkNumber_pattern': 'Number of clocks:\s+(\d+)',
                    'resource_MULT18X18D_pattern': 'MULT18X18D\s+(\d+)',
                    'resource_MULT9X9D_pattern': 'MULT9X9D\s+(\d+)',
                    'resource_ALU54B_pattern': 'ALU54B\s+(\d+)',
                    'resource_ALU24B_pattern': 'ALU24B\s+(\d+)',
                    'resource_PRADD18A_pattern': 'PRADD18A\s+(\d+)',
                    'resource_PRADD9A_pattern': 'PRADD9A\s+(\d+)',
                    'resource_MULT36X36B_pattern': 'MULT36X36B\s+(\d+)',
                    'resource_MULT18X18B_pattern': 'MULT18X18B\s+(\d+)',
                    'resource_MULT18X18MACB_pattern': 'MULT18X18MACB\s+(\d+)',
                    'resource_MULT18X18ADDSUBB_pattern': 'MULT18X18ADDSUBB\s+(\d+)',
                    'resource_MULT18X18ADDSUBSUMB_pattern': 'MULT18X18ADDSUBSUMB\s+(\d+)',
                    'resource_MULT9X9B_pattern': 'MULT9X9B\s+(\d+)',
                    'resource_MULT9X9ADDSUBB_pattern': 'MULT9X9ADDSUBB\s+(\d+)',
                    'resource_MULT18X18C_pattern': 'MULT18X18C\s+(\d+)',
                    'resource_MULT9X9C_pattern': 'MULT9X9C\s+(\d+)',
                    'resource_ALU54A_pattern': 'ALU54A\s+(\d+)',
                    'resource_ALU24A_pattern': 'ALU24A\s+(\d+)',
                    'resource_PCS_pattern': 'Number of PCS \(SerDes\):\s+(\d+)',
                    'resource_clkEnNumber_pattern': 'Number of Clock Enables:\s+(\d+)',
                    'resource_LSRNumber_pattern': 'Number of LSRs:\s+(\d+)',
                    'resource_clkMaxLoad_pattern': '(Net|Pin)\s+(?P<clkMaxLoadName>.+?)\s*:\s+(?P<clkMaxLoadNum>\d+)\s*loads',
                    'resource_clkMaxLoad_start_pattern': 'Number of Clocks',
                    'resource_clkMaxLoad_stop_pattern': 'Number of Clock Enables',
                    'resource_clkEnMaxLoad_pattern': '(Net|Pin)\s+(?P<clkEnMaxLoadName>.+?)\s*:\s+'
                                                     '(?P<clkEnMaxLoadNum>\d+)\s*loads',
                    'resource_clkEnMaxLoad_start_pattern': 'Number of Clock Enables',
                    'resource_clkEnMaxLoad_stop_pattern': 'Number of LSR',
                    'resource_LSRMaxLoad_pattern': '(Net|Pin)\s+(?P<LSRMaxLoadName>.+?)\s*:\s+(?P<LSRMaxLoadNum>\d+)\s*loads',
                    'resource_LSRMaxLoad_start_pattern': 'Number of LSR',
                    'resource_LSRMaxLoad_stop_pattern': 'Top 10 highest fanout non-clock nets',

                    'lse_reg_pattern': 'Number of register bits\s*=>\s*(\d+)',
                    'lse_carry_pattern': ['CCU2\s*=>\s*(?P<lse_carry>\d+)', 'FA2\s*=>\s*(?P<lse_carry>\d+)'],
                    'lse_io_pattern': 'BB_B\s*=>\s*(\d+)',
                    'lse_lut4_pattern': 'LUT4\s*=>\s*(\d+)',
                    'lse_ebr_pattern': [
                        'EBR_B\s*=>\s*(?P<lse_ebr>\d+)',
                        'VFB_B\s*=>\s*(?P<lse_ebr>\d+)',
                    ],
                    'lse_dsp_pattern': 'MAC16\s*=>\s*(\d+)',
                    'lse_odd_pattern': 'Number of odd-length carry chains :\s*(\d+)',
                    'lse_even_pattern': 'Number of even-length carry chains :\s*(\d+)',
                    'lse_start_pattern': 'Begin Area Report',
                    'lse_stop_pattern': 'Begin Clock Report',

                    'par_signals_pattern': 'Number\s+of\s+Signals:\s+(.+)',
                    'par_connections_pattern': 'Number\s+of\s+Connections:\s+(.+)',
                    'par_congestion_level_pattern': 'Initial\s+congestion\s+level\s+at.+is\s+(\d+)',
                    'par_congestion_area_pattern': 'Initial\s+congestion\s+area.+is\s+(\d+)',
                    'par_congestion_area_per_pattern': 'Initial\s+congestion\s+area.+is\s+\d+\s+\(([^\)]+)\)',
                    'par_start_pattern': 'Number\s+of\s+Signals:\s+(.+)',

                    'cpu_Placer_cpu_Time_pattern': 'Total\s+placer\s+CPU\s+time:([^,]+)',
                    'cpu_Router_cpu_Time_pattern': 'Total\s+CPU\s+time\s+(.+)',
                    'cpu_router_stop_pattern': 'End\s+of\s+route',
                    'cpu_par_start_pattern': 'End\s+of\s+route',
                    'cpu_par_cpu_Time_pattern': 'Total\s+CPU\s+time\s+to\s+completion:?\s+(.+)',
                    'cpu_par_real_Time_pattern': 'Total\s+REAL\s+time\s+to\s+completion:\s+(.+)',
                    'cpu_map_cpu_Time_pattern': 'Total CPU Time:\s+(.+)',
                    'cpu_map_real_Time_pattern': 'Total REAL Time:\s+(.+)',
                    'cpu_synp_Time_pattern': [
                        re.compile("(Pre-mapping|Mapper)\s+(successful!)"),
                        re.compile("""At\s+(Mapper|c_hdl|syn_nfilter|c_vhdl)\s+Exit\s+\(Real\s+
                                    Time\s+elapsed\s+(\S+);\s+CPU\s+Time\s+elapsed\s+(\S+)""", re.X)
                    ],
                    'cpu_postsyn_cpu_Time_pattern': 'Total CPU Time:\s+(.+)',
                    'cpu_postsyn_real_Time_pattern': 'Total REAL Time:\s+(.+)',
                    'cpu_postsyn_start_pattern': 'Command Line: postsyn',
                    'cpu_postsyn_stop_pattern': 'Copyright',
                    'cpu_lse_cpu_Time_pattern': 'CPU time for LSE flow :\s+([\d\.]+)\s+secs',

                    'memory_lse_peak_Memory_pattern': 'Peak Memory Usage:\s+([\d\.]+)',
                    'memory_synp_peak_Memory_pattern': 'Memory used current:\s+\S+\s+peak:\s+(?P<synp_peak_Memory>\d+)',
                    'memory_postsyn_peak_Memory_pattern': 'Peak Memory Usage:\s+(\d+)',
                    'memory_postsyn_peak_Memory_start_pattern': 'Command Line: postsyn',
                    'memory_map_peak_Memory_pattern': 'Peak Memory Usage:\s+(\d+)',
                    # 'memory_ParPeakMem_pattern': 'PAR\s+peak\s+memory\s+usage:\s+([\d \.]+)\s+Mbytes',
                    'memory_ParPeakMem_pattern': 'peak\s+memory\s+([\d\.]+)\s+Mbytes\s+after\s+destruction',

                    'comments_mapComments_pattern': '(ERROR\s+-\s+.{1,135})',
                    'comments_parComments_pattern': '(ERROR\s+-\s+.{1,135})',

                    'milestone_Synplify_pattern': 'Mapper\s+successful!',
                    'milestone_LSE_pattern': '',
                    'milestone_Map_pattern': 'Number\s+of\s+errors:\s+0',
                    'milestone_Par_pattern': 'All\s+signals\s+are\s+completely\s+routed',

                    'simulation_sim_active_tool_pattern': '(active-hdl)',
                    'simulation_sim_active_version_pattern': 'Simulator\s+build\s+([\d\.]+)',
                    'simulation_sim_modelsim_tool_pattern': 'Model\s+Technology\s+(ModelSim)',
                    'simulation_sim_modelsim_version_pattern': 'Edition\s+([\d\.]+)',
                    'simulation_sim_riviera_tool_pattern': '(riviera-pro)',
                    'simulation_sim_riviera_version_pattern': 'version\s+([\d\.]+)',
                    'simulation_sim_questa_tool_pattern': '(Questa Sim)',
                    'simulation_sim_questa_version_pattern': 'Version\s+(.+?)\s',
                    'simulation_sim_rtl_start_pattern': '(.+?/.+?)/.+?/vsim.+?do_sim_rtl',
                    'simulation_sim_syn_start_pattern': '(.+?/.+?)/.+?/vsim.+?do_sim_syn',
                    'simulation_sim_map_start_pattern': '(.+?/.+?)/.+?/vsim.+?do_sim_map',
                    'simulation_sim_par_start_pattern': '(.+?/.+?)/.+?/vsim.+?do_sim_par',
                    'simulation_sim_time_pattern': 'Elapsed Time: (.+?)\s+seconds',
                    'simulation_sim_time_stop_pattern': '^$'
                },
            },

            'no_sweep': {
                'file': {
                    'prj_info_synthesis_file': diamond_ldf,
                    'prj_info_device_file': diamond_no_sweep_mrp_file,
                    'prj_info_version_file': diamond_no_sweep_mrp_file,
                    'prj_info_HDL_type_file': diamond_ldf,

                    'timing_seed_file': diamond_no_sweep_twr_file,
                    'timing_scoreSetup_file': diamond_no_sweep_par_file,
                    'timing_scoreHold_file': diamond_no_sweep_par_file,
                    'timing_maxloads_file': diamond_no_sweep_mrp_file,
                    'timing_totalloads_file': diamond_no_sweep_mrp_file,

                    'resource_Register_file': diamond_no_sweep_mrp_file,
                    'resource_Register_per_file': diamond_no_sweep_mrp_file,
                    'resource_Slice_file': diamond_no_sweep_par_file,
                    'resource_Slice_per_file': diamond_no_sweep_par_file,
                    'resource_LUT_file': diamond_no_sweep_mrp_file,
                    'resource_LUT_per_file': diamond_no_sweep_mrp_file,
                    'resource_IO_file': diamond_no_sweep_mrp_file,
                    'resource_IO_per_file': diamond_no_sweep_mrp_file,
                    'resource_EBR_file': diamond_no_sweep_mrp_file,
                    'resource_CARRY_file': diamond_no_sweep_mrp_file,
                    'resource_DistributedRAM_file': diamond_no_sweep_mrp_file,
                    'resource_clkNumber_file': diamond_no_sweep_mrp_file,
                    'resource_MULT18X18D_file': diamond_no_sweep_mrp_file,
                    'resource_MULT9X9D_file': diamond_no_sweep_mrp_file,
                    'resource_ALU54B_file': diamond_no_sweep_mrp_file,
                    'resource_ALU24B_file': diamond_no_sweep_mrp_file,
                    'resource_PRADD18A_file': diamond_no_sweep_mrp_file,
                    'resource_PRADD9A_file': diamond_no_sweep_mrp_file,
                    'resource_MULT36X36B_file': diamond_no_sweep_mrp_file,
                    'resource_MULT18X18B_file': diamond_no_sweep_mrp_file,
                    'resource_MULT18X18MACB_file': diamond_no_sweep_mrp_file,
                    'resource_MULT18X18ADDSUBB_file': diamond_no_sweep_mrp_file,
                    'resource_MULT18X18ADDSUBSUMB_file': diamond_no_sweep_mrp_file,
                    'resource_MULT9X9B_file': diamond_no_sweep_mrp_file,
                    'resource_MULT9X9ADDSUBB_file': diamond_no_sweep_mrp_file,
                    'resource_MULT18X18C_file': diamond_no_sweep_mrp_file,
                    'resource_MULT9X9C_file': diamond_no_sweep_mrp_file,
                    'resource_ALU54A_file': diamond_no_sweep_mrp_file,
                    'resource_ALU24A_file': diamond_no_sweep_mrp_file,
                    'resource_PCS_file': diamond_no_sweep_mrp_file,
                    'resource_clkEnNumber_file': diamond_no_sweep_mrp_file,
                    'resource_LSRNumber_file': diamond_no_sweep_mrp_file,
                    'resource_clkMaxLoad_file': diamond_no_sweep_mrp_file,
                    'resource_clkEnMaxLoad_file': diamond_no_sweep_mrp_file,
                    'resource_LSRMaxLoad_file': diamond_no_sweep_mrp_file,
                    
                    'lse_reg_file': diamond_no_sweep_synthesis_log,
                    'lse_carry_file': diamond_no_sweep_synthesis_log,
                    'lse_io_file': diamond_no_sweep_synthesis_log,
                    'lse_lut4_file': diamond_no_sweep_synthesis_log,
                    'lse_ebr_file': diamond_no_sweep_synthesis_log,
                    'lse_dsp_file': diamond_no_sweep_synthesis_log,
                    'lse_odd_file': diamond_no_sweep_synthesis_log,
                    'lse_even_file': diamond_no_sweep_synthesis_log,

                    'par_signals_file': diamond_no_sweep_par_file,
                    'par_connections_file': diamond_no_sweep_par_file,
                    'par_congestion_level_file': diamond_no_sweep_par_file,
                    'par_congestion_area_file': diamond_no_sweep_par_file,
                    'par_congestion_area_per_file': diamond_no_sweep_par_file,

                    'cpu_Placer_cpu_Time_file': diamond_no_sweep_par_file,
                    'cpu_Router_cpu_Time_file': diamond_no_sweep_par_file,
                    'cpu_par_cpu_Time_file': diamond_no_sweep_par_file,
                    'cpu_par_real_Time_file': diamond_no_sweep_par_file,
                    'cpu_map_cpu_Time_file': diamond_no_sweep_mrp_file,
                    'cpu_map_real_Time_file': diamond_no_sweep_mrp_file,
                    'cpu_synp_Time_file': diamond_no_sweep_srr_file,
                    'cpu_postsyn_cpu_Time_file': diamond_no_sweep_run_pb_log,
                    'cpu_postsyn_real_Time_file': diamond_no_sweep_run_pb_log,
                    'cpu_lse_cpu_Time_file': diamond_no_sweep_synthesis_log,

                    'memory_lse_peak_Memory_file': diamond_no_sweep_synthesis_log,
                    'memory_synp_peak_Memory_file': diamond_no_sweep_srr_file,
                    'memory_postsyn_peak_Memory_file': diamond_no_sweep_run_pb_log,
                    'memory_map_peak_Memory_file': diamond_no_sweep_mrp_file,
                    'memory_ParPeakMem_file': diamond_no_sweep_par_file,

                    'comments_mapComments_file': diamond_no_sweep_mrp_file,
                    'comments_parComments_file': diamond_no_sweep_par_file,

                    'milestone_Synplify_file': diamond_no_sweep_srr_file,
                    'milestone_LSE_file': diamond_no_sweep_synthesis_log,
                    'milestone_Map_file': diamond_no_sweep_mrp_file,
                    'milestone_Par_file': diamond_no_sweep_par_file,

                    'simulation_sim_tool_file': diamond_no_sweep_sim_log,
                    'simulation_sim_time_file': diamond_no_sweep_runtime_log,
                },

                'pattern': {
                    'prj_info_synthesis_pattern': '\s+synthesis="([^"]+)"\s+',
                    'prj_info_device_pattern': [
                        '^Target Device:\s+(\S+)',
                        '^Target Performance:\s+(\S+)'
                    ],
                    'prj_info_version_pattern': '^Mapper:.+version:\s+(.+)',
                    'prj_info_HDL_type_pattern': '<Source name.+type="([^"]+)"',
                    'prj_info_HDL_type_exclude_pattern': 'excluded="TRUE">',

                    'timing_constraint_coverage_pattern': 'Constraints cover.+?\(([\d\.]+%)\s+coverage\)',
                    'timing_total_neg_slack_setup_pattern': 'Total Negative Slack:.+([\d\.]+)\s+ns\s+\(setup\)',
                    'timing_total_neg_slack_hold_pattern': 'Total Negative Slack:.+([\d\.]+)\s+ns\s+\(hold\)',
                    'timing_route_logic_pattern': '(?P<delay>[\d\.]+)ns\s+\((?P<logic>[\d\.]+%)\s+logic,\s+(?P<route>'
                                                  '[\d\.]+%)\s+route\),\s+(?P<level>\d+)\s+logic\s+level',
                    'timing_path_delay_pattern': '\+\s+Data Path Delay\s+([\d\.]+)',
                    'timing_arrive_time_pattern': 'Clock\s+Arrival\s+Time.+?:(\w+)',
                    'timing_setup_path_pattern': '^[\d\.]+\s+Setup path details for constraint:'
                                                 '.+get_(ports|nets)\s+([^\]]+)\]',
                    'timing_path_pattern': '\++\s*Path\s+1\s+\++',
                    'timing_scoreSetup_pattern': 'PAR_SUMMARY::Timing score<setup/<ns>> =\s+([\d\.]+)',
                    'timing_scoreHold_pattern': 'PAR_SUMMARY::Timing score<hold /<ns>> =\s+([\d\.]+)',
                    'timing_CombineLoop_pattern': '\++\s+Loop\d+',
                    'timing_maxloads_pattern': '(Pin|Port|Net)\s+[^:]+:\s+(?P<maxLoads>\d+)\s*loads,\s+'
                                               '.+?\((Net|Driver):\s+[^\)]+\)',
                    'timing_totalloads_pattern': '(Pin|Port|Net)\s+[^:]+:\s+(?P<totalLoads>\d+)\s*loads,\s+'
                                                 '.+?\((Net|Driver):\s+[^\)]+\)',

                    'resource_start_pattern': 'Number\s+of\s+Signals:\s+(.+)',
                    'resource_Register_pattern': 'Number of.+registers:\s+(\d+)',
                    'resource_Register_per_pattern': 'Number of.+registers:\s+\d+.+\((.+)\)',
                    'resource_Slice_pattern': 'SLICE\s+(\d+)/\d+\s+\S+\s+used',
                    'resource_Slice_per_pattern': 'SLICE\s+\d+/\d+\s+(\S+)\s+used',
                    'resource_LUT_pattern': 'Number of LUT4s:\s+(\d+)',
                    'resource_LUT_per_pattern': 'Number of LUT4s:.+out\s+of\s+\d+\s+\((.+)\)',
                    'resource_IO_pattern': 'Number of P?[IO sites|IOs].+used:\s+(\d+)',
                    'resource_IO_per_pattern': 'Number of P?[IO sites|IOs].+used:\s+\d+.+\((.+)\)',
                    'resource_EBR_pattern': 'Number of (?:EBRs|Block\s+RAMs|block\s+RAMs):\s+(\d+)',
                    'resource_CARRY_pattern': [
                        "Number\s+of\s+ripple\s+logic:\s+(?P<CARRY>\d+)",
                        "Number\s+used\s+as\s+ripple\s+logic:\s+(?P<CARRY>\d+)"
                    ],
                    'resource_DistributedRAM_pattern': 'Number\s+used\s+as\s+distributed\s+RAM:\s+(\d+)',
                    'resource_clkNumber_pattern': 'Number of clocks:\s+(\d+)',
                    'resource_MULT18X18D_pattern': 'MULT18X18D\s+(\d+)',
                    'resource_MULT9X9D_pattern': 'MULT9X9D\s+(\d+)',
                    'resource_ALU54B_pattern': 'ALU54B\s+(\d+)',
                    'resource_ALU24B_pattern': 'ALU24B\s+(\d+)',
                    'resource_PRADD18A_pattern': 'PRADD18A\s+(\d+)',
                    'resource_PRADD9A_pattern': 'PRADD9A\s+(\d+)',
                    'resource_MULT36X36B_pattern': 'MULT36X36B\s+(\d+)',
                    'resource_MULT18X18B_pattern': 'MULT18X18B\s+(\d+)',
                    'resource_MULT18X18MACB_pattern': 'MULT18X18MACB\s+(\d+)',
                    'resource_MULT18X18ADDSUBB_pattern': 'MULT18X18ADDSUBB\s+(\d+)',
                    'resource_MULT18X18ADDSUBSUMB_pattern': 'MULT18X18ADDSUBSUMB\s+(\d+)',
                    'resource_MULT9X9B_pattern': 'MULT9X9B\s+(\d+)',
                    'resource_MULT9X9ADDSUBB_pattern': 'MULT9X9ADDSUBB\s+(\d+)',
                    'resource_MULT18X18C_pattern': 'MULT18X18C\s+(\d+)',
                    'resource_MULT9X9C_pattern': 'MULT9X9C\s+(\d+)',
                    'resource_ALU54A_pattern': 'ALU54A\s+(\d+)',
                    'resource_ALU24A_pattern': 'ALU24A\s+(\d+)',
                    'resource_PCS_pattern': 'Number of PCS \(SerDes\):\s+(\d+)',
                    'resource_clkEnNumber_pattern': 'Number of Clock Enables:\s+(\d+)',
                    'resource_LSRNumber_pattern': 'Number of LSRs:\s+(\d+)',
                    'resource_clkMaxLoad_pattern': '(Net|Pin)\s+(?P<clkMaxLoadName>.+?)\s*:\s+(?P<clkMaxLoadNum>\d+)\s*loads',
                    'resource_clkMaxLoad_start_pattern': 'Number of Clocks',
                    'resource_clkMaxLoad_stop_pattern': 'Number of Clock Enables',
                    'resource_clkEnMaxLoad_pattern': '(Net|Pin)\s+(?P<clkEnMaxLoadName>.+?)\s*:\s+'
                                                     '(?P<clkEnMaxLoadNum>\d+)\s*loads',
                    'resource_clkEnMaxLoad_start_pattern': 'Number of Clock Enables',
                    'resource_clkEnMaxLoad_stop_pattern': 'Number of LSR',
                    'resource_LSRMaxLoad_pattern': '(Net|Pin)\s+(?P<LSRMaxLoadName>.+?)\s*:\s+(?P<LSRMaxLoadNum>\d+)\s*loads',
                    'resource_LSRMaxLoad_start_pattern': 'Number of LSR',
                    'resource_LSRMaxLoad_stop_pattern': 'Top 10 highest fanout non-clock nets',
                    
                    'lse_reg_pattern': 'Number of register bits\s*=>\s*(\d+)',
                    'lse_carry_pattern': ['CCU2\s*=>\s*(?P<lse_carry>\d+)', 'FA2\s*=>\s*(?P<lse_carry>\d+)'],
                    'lse_io_pattern': 'BB_B\s*=>\s*(\d+)',
                    'lse_lut4_pattern': 'LUT4\s*=>\s*(\d+)',
                    'lse_ebr_pattern': [
                        'EBR_B\s*=>\s*(?P<lse_ebr>\d+)',
                        'VFB_B\s*=>\s*(?P<lse_ebr>\d+)',
                    ],
                    'lse_dsp_pattern': 'MAC16\s*=>\s*(\d+)',
                    'lse_odd_pattern': 'Number of odd-length carry chains :\s*(\d+)',
                    'lse_even_pattern': 'Number of even-length carry chains :\s*(\d+)',
                    'lse_start_pattern': 'Begin Area Report',
                    'lse_stop_pattern': 'Begin Clock Report',

                    'par_signals_pattern': 'Number\s+of\s+Signals:\s+(.+)',
                    'par_connections_pattern': 'Number\s+of\s+Connections:\s+(.+)',
                    'par_congestion_level_pattern': 'Initial\s+congestion\s+level\s+at.+is\s+(\d+)',
                    'par_congestion_area_pattern': 'Initial\s+congestion\s+area.+is\s+(\d+)',
                    'par_congestion_area_per_pattern': 'Initial\s+congestion\s+area.+is\s+\d+\s+\(([^\)]+)\)',
                    'par_start_pattern': 'Number\s+of\s+Signals:\s+(.+)',


                    'cpu_Placer_cpu_Time_pattern': 'Total\s+placer\s+CPU\s+time:([^,]+)',
                    'cpu_Router_cpu_Time_pattern': 'Total\s+CPU\s+time\s+(.+)',
                    'cpu_router_stop_pattern': 'End\s+of\s+route',
                    'cpu_par_start_pattern': 'End\s+of\s+route',
                    'cpu_par_cpu_Time_pattern': 'Total\s+CPU\s+time\s+to\s+completion:?\s+(.+)',
                    'cpu_par_real_Time_pattern': 'Total\s+REAL\s+time\s+to\s+completion:\s+(.+)',
                    'cpu_map_cpu_Time_pattern': 'Total CPU Time:\s+(.+)',
                    'cpu_map_real_Time_pattern': 'Total REAL Time:\s+(.+)',
                    'cpu_synp_Time_pattern': [
                        re.compile("(Pre-mapping|Mapper)\s+(successful!)"),
                        re.compile("""At\s+(Mapper|c_hdl|syn_nfilter|c_vhdl)\s+Exit\s+\(Real\s+
                        Time\s+elapsed\s+(\S+);\s+CPU\s+Time\s+elapsed\s+(\S+)""", re.X)
                    ],
                    'cpu_postsyn_cpu_Time_pattern': 'Total CPU Time:\s+(.+)',
                    'cpu_postsyn_real_Time_pattern': 'Total REAL Time:\s+(.+)',
                    'cpu_postsyn_start_pattern': 'Command Line: postsyn',
                    'cpu_postsyn_stop_pattern': 'Copyright',
                    'cpu_lse_cpu_Time_pattern': 'CPU time for LSE flow :\s+([\d\.]+)\s+secs',

                    'memory_lse_peak_Memory_pattern': 'Peak Memory Usage:\s+([\d\.]+)',
                    'memory_synp_peak_Memory_pattern': 'Memory used current:\s+\S+\s+peak:\s+(?P<synp_peak_Memory>\d+)',
                    'memory_postsyn_peak_Memory_pattern': 'Peak Memory Usage:\s+(\d+)',
                    'memory_postsyn_peak_Memory_start_pattern': 'Command Line: postsyn',
                    'memory_map_peak_Memory_pattern': 'Peak Memory Usage:\s+(\d+)',
                    # 'memory_ParPeakMem_pattern': 'PAR\s+peak\s+memory\s+usage:\s+([\d \.]+)\s+Mbytes',
                    'memory_ParPeakMem_pattern': 'peak\s+memory\s+([\d\.]+)\s+Mbytes\s+after\s+destruction',

                    'comments_mapComments_pattern': '(ERROR\s+-\s+.{1,135})',
                    'comments_parComments_pattern': '(ERROR\s+-\s+.{1,135})',

                    'milestone_Synplify_pattern': 'Mapper\s+successful!',
                    'milestone_LSE_pattern': '',
                    'milestone_Map_pattern': 'Number\s+of\s+errors:\s+0',
                    'milestone_Par_pattern': 'All\s+signals\s+are\s+completely\s+routed',

                    'simulation_sim_active_tool_pattern': '(active-hdl)',
                    'simulation_sim_active_version_pattern': 'Simulator\s+build\s+([\d\.]+)',
                    'simulation_sim_modelsim_tool_pattern': 'Model\s+Technology\s+(ModelSim)',
                    'simulation_sim_modelsim_version_pattern': 'Edition\s+([\d\.]+)',
                    'simulation_sim_riviera_tool_pattern': '(riviera-pro)',
                    'simulation_sim_riviera_version_pattern': 'version\s+([\d\.]+)',
                    'simulation_sim_questa_tool_pattern': '(Questa Sim)',
                    'simulation_sim_questa_version_pattern': 'Version\s+(.+?)\s',
                    'simulation_sim_rtl_start_pattern': '(.+?/.+?)/.+?/vsim.+?do_sim_rtl',
                    'simulation_sim_syn_start_pattern': '(.+?/.+?)/.+?/vsim.+?do_sim_syn',
                    'simulation_sim_map_start_pattern': '(.+?/.+?)/.+?/vsim.+?do_sim_map',
                    'simulation_sim_par_start_pattern': '(.+?/.+?)/.+?/vsim.+?do_sim_par',
                    'simulation_sim_time_pattern': 'Elapsed Time: (.+?)\s+seconds',
                    'simulation_sim_time_stop_pattern': '^$'
                },
            },
        }

    def get_options(self):
        return self.__dict__
