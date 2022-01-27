REVISION = ("3545", "Thu Dec 30 11:02:51 2021", "support multi-command and [check_block] for checking rbt")
# REVISION = ("3532", "Wed Dec 22 14:13:42 2021", "add reportGen tool")
# REVISION = ("3498", "Sat Oct  9 10:52:47 2021", "support sim-bit-vlg")
# REVISION = ("3474", "Wed Sep  8 20:55:16 2021", "support simrel BIDI multiple select signals")
# REVISION = ("3467", "Tue Aug 31 08:44:36 2021", "add filelocker for searching simrel path and use random order")
# REVISION = ("3458", "Wed Aug 25 14:28:07 2021", "set device paths in a unique family.ini file")
# REVISION = ("3448", "Wed Aug 18 09:06:33 2021", "scan right simulation time and get Modelsim version")
# REVISION = ("3416", "Thu Jul 29 09:42:22 2021", "support lfmxo5 simulation/IPgen")
# REVISION = ("3373", "Mon Jun 21 08:52:23 2021", "remove license settings each time")
# REVISION = ("3367", "Wed Jun 16 11:18:36 2021", "run post/map timing flow by default")
# REVISION = ("3366", "Wed Jun 16 11:16:03 2021", "run post/map timing flow by default")
# REVISION = ("3332", "Mon May 24 15:23:57 2021", "record license when using linux19v")
# REVISION = ("3330", "Thu May 20 10:33:01 2021", "support vcs and xrun simulation")
# REVISION = ("3323", "Fri May 14 10:48:47 2021", "support VCS simulation flow")
# REVISION = ("3307", "Thu Apr 29 10:04:21 2021", "can launch run-squish.bat in different location")
# REVISION = ("3284", "Tue Apr 13 08:55:20 2021", "remove needless newline for run log on Windows")
# REVISION = ("3281", "Mon Apr 12 10:59:37 2021", "UnicodeDecodeError exception in log file when checking it")
# REVISION = ("3268", "Wed Apr  7 13:50:31 2021", "Update all to Python3.8.7")
# REVISION = ("3235", "Tue Mar  2 09:26:18 2021", "support customer do file")
# REVISION = ("3216", "Wed Feb  3 09:56:09 2021", "compile ap6a00 simulation library with applatform files")
# REVISION = ("3210", "Mon Feb  1 09:14:28 2021", "modify pmi library file")
# REVISION = ("3206", "Fri Jan 22 16:29:02 2021", "fix timeout bug of compiling simulation library with processes")
# REVISION = ("3174", "Fri Dec 25 10:40:57 2020", "support ipx simulation flow")
# REVISION = ("3149", "Thu Dec 10 13:51:01 2020", "Jira swqalab and MemoryError for dumping command console log")
# REVISION = ("3144", "Tue Dec  8 08:49:58 2020", "--lpf-factor for using new constraint in lpf file")
# REVISION = ("3140", "Thu Dec  3 16:20:42 2020", "copy modelsim.ini file to local working path to avoid failed when using threads")
# REVISION = ("3109", "Thu Nov 12 14:55:48 2020", "support new check method: check_value")
# REVISION = ("3108", "Tue Nov 10 09:16:39 2020", "add check method check_simulation_flow")
# REVISION = ("3097", "Wed Nov  4 13:34:38 2020", "exception for shlex split do file lines")
# REVISION = ("3092", "Mon Nov  2 13:55:34 2020", "use map_lib.ini to get Radiant Simulation library name")
# REVISION = ("3091", "Fri Oct 30 10:30:41 2020", "support pmi and blackbox in simulation flow")
# REVISION = ("3087", "Fri Oct 23 09:47:37 2020", "use -L instead of -lib work for Modelsim")
# REVISION = ("3086", "Thu Oct 22 14:54:49 2020", "+define+SV_IO_UNFOLD for vlog sv file with Modelsim")
# REVISION = ("3085", "Wed Oct 21 16:13:38 2020", "support cmd_file (run.pl, run.py, etc) and execute check flow ONLY when check_conf specified")
# REVISION = ("3082", "Tue Oct 20 16:16:12 2020", "update do line for Modelsim Vlog systemVerilog file")
# REVISION = ("3076", "Thu Oct 15 10:50:26 2020", "use Diamond/Radiant precompiled simulation library as default one")
# REVISION = ("3074", "Wed Oct 14 11:14:51 2020", "add -sv -mfcu for compiling Radiant/Modelsim simulation library")
# REVISION = ("3063", "Sat Oct 10 08:45:26 2020", "change condition for generating lst file in Modelsim flow")
# REVISION = ("3060", "Fri Oct  9 09:47:20 2020", "add modelsim OEM license server 1717@labd0012")
# REVISION = ("3059", "Fri Oct  9 09:27:37 2020", "change modelsim vsim command in template file")
# REVISION = ("3056", "Fri Oct  9 07:27:17 2020", "update check Diamond IBIS method")
# REVISION = ("3046", "Mon Sep 28 16:21:47 2020", "bug for checking simrel output status")
# REVISION = ("3009", "Mon Sep  7 10:24:29 2020", "support pmi simulation flow with specified Active-HDL")
# REVISION = ("2997", "Tue Sep  1 11:11:58 2020", "fix Diamond failed in psbrtlwrap flow")
# REVISION = ("2985", "Wed Aug 26 08:22:00 2020", "print out error log when not found HDL library files")
# REVISION = ("2965", "Tue Aug 18 09:21:32 2020", "run synthesis only when no --run-xxx specified except --run-synthesis")
# REVISION = ("2921", "Mon Jul 27 09:12:15 2020", "fix bug for check_almost before_pattern_$n")
# REVISION = ("2911", "Wed Jul 22 14:14:18 2020", "support before_pattern_$n for checkNumber method")
# REVISION = ("2903", "Tue Jul 21 10:38:05 2020", "fix bug for check_diamond_flow")
# REVISION = ("2879", "Mon Jul  6 14:10:55 2020", "support multiple check conf files by [--check-conf=x,y,z]")
# REVISION = ("2877", "Fri Jul  3 10:07:00 2020", "recover xSimulation.py")
# REVISION = ("2872", "Wed Jul  1 11:02:53 2020", "support customer do file which have +incdir+")
# REVISION = ("2842", "Mon Jun 15 16:34:28 2020", "support check_almost method")
# REVISION = ("2807", "Wed Jun  3 09:33:51 2020", "show user authority data for checking CR in JIRA if failed")
# REVISION = ("2792", "Mon May 25 10:53:48 2020", "fix fug in generating jedi d1 avc_change_freq.avc file")
# REVISION = ("2786", "Fri May 22 10:17:12 2020", "try to get simrel job id for timeout operation")
# REVISION = ("2785", "Fri May 22 09:28:49 2020", "get simrel job id")
# REVISION = ("2784", "Fri May 22 08:05:14 2020", "try to get simrel job id for timeout operation")
# REVISION = ("2783", "Thu May 21 16:26:41 2020", "multi-process for compiling Simulation library")
# REVISION = ("2782", "Wed May 20 14:24:52 2020", "re-write pad2signal module")
# REVISION = ("2780", "Tue May 19 16:39:21 2020", "add -sv -mfcu for compiling jd5d00 simulation library")
# REVISION = ("2779", "Tue May 19 13:46:05 2020", "generate avc file for Jedi d1 device")
# REVISION = ("2777", "Fri May 15 16:07:44 2020", "use <-voptargs=+acc> for Questasim vsim command")
# REVISION = ("2775", "Fri May 15 14:09:24 2020", "fix bug of scanning Radiant twr MPW frequency")
# REVISION = ("2774", "Fri May 15 10:48:27 2020", "add -sv -mfcu for compiling Questasim simulation library")
# REVISION = ("2771", "Thu May 14 15:29:37 2020", "remove braces when create fmax_center ldc/fdc file")
# REVISION = ("2762", "Mon May 11 14:50:40 2020", "fix bug for checking CR in check flow")
# REVISION = ("2751", "Thu May  7 15:41:28 2020", "fix bug in scan Radiant twr file")
# REVISION = ("2748", "Thu May  7 09:52:36 2020", "fix bug for getting ports from Radiant twr file")
# REVISION = ("2747", "Wed May  6 16:56:59 2020", "fmax_center format: $int,$int,$number")
# REVISION = ("2738", "Sun Apr 26 16:18:23 2020", "support Simrel BIDI ports")
# REVISION = ("2737", "Sun Apr 26 14:30:18 2020", "use new Questasim licence")
# REVISION = ("2731", "Fri Apr 24 08:59:16 2020", "support jd5d00 simulation flow")
# REVISION = ("2730", "Thu Apr 23 16:46:33 2020", "support jd5d80 simrel flow")
# REVISION = ("2729", "Thu Apr 23 08:40:48 2020", "run udb2sv for simulation flow if needed")
# REVISION = ("2727", "Fri Apr 17 08:27:03 2020", "check before checking in scripts")
# REVISION = ("2726", "Fri Apr 17 08:22:04 2020", "check before checking in scripts")
# REVISION = ("2724", "Thu Apr 16 15:50:08 2020", "add simple checking flow before committing new updates")
# REVISION = ("2722", "Tue Apr  7 14:29:52 2020", "unzip LIB_thunderplus.zip if needed")
# REVISION = ("2721", "Fri Apr  3 10:05:55 2020", "use jedi_30k and jedi_15k for LFD2NX simrel path")
# REVISION = ("2720", "Mon Mar 30 14:00:15 2020", "support jd5d00 simulation flow")
# REVISION = ("2717", "Fri Mar 27 17:10:12 2020", "treat child killed as Error message")
# REVISION = ("2716", "Fri Mar 27 09:59:58 2020", "always copy avc_change_freq.avc file in simrel flow")
# REVISION = ("2714", "Thu Mar 26 10:41:42 2020", "support Radiant Family LFD2NX simulation flow")
# REVISION = ("2709", "Tue Mar 10 09:14:01 2020", "get right Diamond par file by checking 'Command Line:' string")
# REVISION = ("2707", "Wed Mar  4 10:50:25 2020", "use +define+SV_IO_UNFOLD instead of +define+sv_syn for ActiveHDL tb sv file if needed")
# REVISION = ("2706", "Wed Mar  4 10:49:30 2020", "use +define+SV_IO_UNFLOD instead of +define+sv_syn for ActiveHDL tb sv file if needed")
# REVISION = ("2705", "Wed Mar  4 10:47:27 2020", "add +define+sv_syn for ActiveHDL tb sv file if needed")
# REVISION = ("2703", "Tue Mar  3 14:34:47 2020", "scan report for LRAM and PAP/FMAX")
# REVISION = ("2702", "Mon Mar  2 13:33:40 2020", "use xsim_ncv for Jedi")
# REVISION = ("2701", "Mon Mar  2 11:30:27 2020", "update jedi_15k and jedi_30k simrel path")
# REVISION = ("2697", "Thu Feb 27 14:50:51 2020", "use strategy tcl commands for trce report format instead of ALT_REPORT env")
# REVISION = ("2695", "Tue Feb 25 16:00:50 2020", "update check_script_usage.docx")
# REVISION = ("2694", "Tue Feb 25 10:50:46 2020", "use latest check_script_usage.docx file which comes from Teams")
# REVISION = ("2693", "Mon Feb 17 11:02:02 2020", "update check.py for check_lines which has more than one matched check_1 lines")
# REVISION = ("2690", "Fri Jan 17 09:20:39 2020", "generate svwf file if dis-contiguous bus usage")
# REVISION = ("2688", "Tue Jan 14 10:23:48 2020", "dump report of min-fmax:(fmax, fmax_pap) and min_pap:(pap, pap_fmax)")
# REVISION = ("2687", "Tue Jan 14 09:51:16 2020", "fix bug for dumping Diamond Router CPU time")
# REVISION = ("2686", "Tue Jan 14 09:30:37 2020", "support --strategy ")
# REVISION = ("2685", "Fri Jan 10 14:43:14 2020", "dump min pap and min fmax and its pap_fmax")
# REVISION = ("2684", "Thu Jan  9 13:53:46 2020", "use -sv2k12 for vlog ActiveHDL System Verilog file")
# REVISION = ("2683", "Thu Jan  9 08:54:18 2020", "scan and check only when --scan-only")
# REVISION = ("2681", "Mon Jan  6 09:27:46 2020", "fix bug for scanning Diamond twr file")
# REVISION = ("2680", "Fri Jan  3 14:30:46 2020", "add column fmax_PAP and PAP_fmax for PAP data")
# REVISION = ("2679", "Thu Jan  2 09:57:58 2020", "add backup ActiveHDL license 1700@d25970")
# REVISION = ("2678", "Mon Dec 30 10:10:07 2019", "put 1700@labd0012 and 7788@labd0012 ahead")
# REVISION = ("2675", "Tue Dec 24 10:16:57 2019", "add syan as JIRA access username")
# REVISION = ("2672", "Tue Dec 17 11:03:35 2019", "scan Placer/Router/lse cpu time")
# REVISION = ("2671", "Fri Dec 13 10:58:59 2019", "Scan data for Radiant 'PAR_SUMMARY::Timing PAP<setup>'")
# REVISION = ("2670", "Thu Dec 12 11:08:52 2019", "search run.* file under design folder and execute it")
# REVISION = ("2669", "Wed Dec 11 14:43:51 2019", "update Diamond lse flow check string")
# REVISION = ("2660", "Thu Nov 28 13:47:52 2019", "add license 7788@lsh-violin")
# REVISION = ("2655", "Fri Nov 15 16:23:03 2019", "generate svwf file for simrel flow (Yin and Jye)")
# REVISION = ("2654", "Fri Nov 15 14:44:16 2019", "keep original Radiant LSE cmd line options")
# REVISION = ("2646", "Wed Nov 13 10:18:15 2019", "fix bug for generating pdc file in QoR flow")
# REVISION = ("2643", "Wed Nov 13 09:07:04 2019", "rerun failed flow because Fail to get license for Lattice OEM Synplify")
# REVISION = ("2642", "Tue Nov 12 15:05:06 2019", "support [qa]cmd_file=*.[cmd|bat|sh|csh|py|pl] flow")
# REVISION = ("2636", "Mon Nov 11 09:46:23 2019", "add option --gen-pdc for Radiant QoR flow")
# REVISION = ("2635", "Mon Nov 11 09:33:40 2019", "fix bug when generating pdc file based on synthesis project file")
# REVISION = ("2633", "Sat Nov  9 15:55:51 2019", "add pdc file for Radiant flow")
# REVISION = ("2628", "Thu Nov  7 14:57:58 2019", "use xncv and xsim_ncv for jedi simrel flow - JYE")
# REVISION = ("2622", "Sat Nov  2 10:18:08 2019", "*) update scan_tools, support for different report format")
# REVISION = ("2621", "Sat Nov  2 10:17:20 2019", "add [sim] use_dbg_in_riviera=[0|1]")
# REVISION = ("2620", "Sat Nov  2 10:16:35 2019", "*) update scan_tools, support for different report format")
# REVISION = ("2614", "Thu Oct 24 16:10:39 2019", "support [simrel]ctl_file=xx for simrel flow")
# REVISION = ("2609", "Wed Oct 23 09:53:04 2019", "Radiant partrce_report_format=Diamond Style")
# REVISION = ("2601", "Tue Oct 15 18:18:34 2019", "fix bug in pad2signal")
# REVISION = ("2600", "Tue Oct 15 10:59:12 2019", "--check-logic-timing-not for not checking logic timing, used with check-smart or check-sections")
# REVISION = ("2599", "Tue Oct 15 09:20:20 2019", "remove LSC_RECORD_CPUMEM")
# REVISION = ("2598", "Sat Oct 12 09:44:07 2019", "*) update check script, sort defects and defects_history")
# REVISION = ("2597", "Wed Oct  9 16:31:16 2019", "*) update pad2sig.py")
# REVISION = ("2595", "Fri Sep 27 15:18:32 2019", "skip Port Name if Buffer Type is None for simrel flow")
# REVISION = ("2594", "Mon Sep 23 14:50:23 2019", "do not use non-alphanumeric character for simulation library path")
# REVISION = ("2593", "Thu Sep 19 11:03:47 2019", "support new error msg format Errno")
# REVISION = ("2590", "Wed Sep 11 15:46:27 2019", "use real path for Radiant user_constrait file")
# REVISION = ("2586", "Fri Sep  6 13:57:50 2019", "set Radiant Squish SKIP_UPLOAD_CHECK=1")
# REVISION = ("2584", "Wed Sep  4 11:25:52 2019", "fix bug for copying Radiant simulation library files")
# REVISION = ("2583", "Fri Aug 30 09:49:12 2019", "add Radiant env: ALT_REPORT=1")
# REVISION = ("2581", "Wed Aug 21 16:23:09 2019", "Radiant ipgen for lifcl")
# REVISION = ("2580", "Mon Aug 19 15:47:51 2019", "generate .svwf file in simrel flow")
# REVISION = ("2570", "Fri Aug  9 09:28:34 2019", "jedi simrel tcl_ncv and outwaves")
# REVISION = ("2568", "Thu Aug  8 10:14:53 2019", "update .lib file name for Radiant simulation library")
# REVISION = ("2567", "Thu Aug  8 09:49:02 2019", "fix bug for argparse default value is False if arguments are store_true")
# REVISION = ("2566", "Thu Aug  8 09:11:50 2019", "compile uaplatform.f simulation library for device lifcl")
# REVISION = ("2565", "Wed Aug  7 14:35:08 2019", "change method to add blackbox simulation libraruy")
# REVISION = ("2562", "Tue Aug  6 14:41:40 2019", "support LIFCL simulation flow")
# REVISION = ("2561", "Fri Aug  2 13:39:50 2019", "run postsyn with new vendor when use different version for synthesis and mpar")
# REVISION = ("2560", "Thu Aug  1 07:49:12 2019", "support Radiant simrel flow")
# REVISION = ("2556", "Wed Jul 31 14:22:17 2019", "add --dev-path for Squish scripts")
# REVISION = ("2555", "Tue Jul 30 16:36:24 2019", "add simrel path for 'je5d30' device")
# REVISION = ("2549", "Fri Jul 26 14:30:37 2019", "support --set-strategy=xx --set-strategy=yy")
# REVISION = ("2548", "Thu Jul 25 09:30:05 2019", "add debug message for searching IP path")
# REVISION = ("2532", "Fri Jul 19 13:59:14 2019", "wrap scanner for SMB and local path")
# REVISION = ("2527", "Fri Jul 19 08:32:08 2019", "scan unzipped cases in lsh-smb02 ")
# REVISION = ("2522", "Wed Jul 17 16:31:22 2019", "support radiant_be and radiant_fe option")
# REVISION = ("2521", "Wed Jul 17 10:11:23 2019", "scan script, add clkenable and lsr info")
# REVISION = ("2516", "Tue Jul  9 14:53:21 2019", "fix bug for compiling simulation library")
# REVISION = ("2515", "Tue Jul  9 11:09:58 2019", "check script, add option preset-options")
# REVISION = ("2513", "Tue Jul  9 09:30:08 2019", "compile Radiant simulation file 1 time only and add check-smart functions")
# REVISION = ("2512", "Tue Jul  9 08:49:40 2019", "check script, update password")
# REVISION = ("2511", "Fri Jul  5 17:25:21 2019", "check script, update -check-section")
# REVISION = ("2510", "Fri Jul  5 17:13:59 2019", "check script, update -check-section")
# REVISION = ("2509", "Fri Jul  5 15:40:10 2019", "check script update check-section")
# REVISION = ("2508", "Fri Jul  5 10:50:09 2019", "add new option --check-section")
# REVISION = ("2507", "Fri Jul  5 09:22:48 2019", "return case_issue if pointed config file not found")
# REVISION = ("2505", "Mon Jul  1 14:01:59 2019", "option --preformance for Radiant is changed to normal string argument for future any updated")
# REVISION = ("2503", "Thu Jun 27 15:27:12 2019", "update function get_conf_files")
# REVISION = ("2497", "Mon Jun 24 13:40:07 2019", "modify scan report name")
# REVISION = ("2495", "Tue Jun 18 09:35:07 2019", "new default config file uploaded for check")
# REVISION = ("2494", "Fri Jun 14 15:27:23 2019", "suppprt inner_tcl_file and outer_tcl_file for Radiant test flow")
# REVISION = ("2493", "Thu Jun 13 10:01:25 2019", "copy config file from dev to local when no expected local config found")
# REVISION = ("2489", "Mon Jun  3 08:29:24 2019", "add local awk.exe for Windows DMS flow")
# REVISION = ("2487", "Thu May 30 09:29:51 2019", "update questasim and modelsim do file template for black box")
# REVISION = ("2484", "Mon May 27 15:17:58 2019", "add -dbg for Riviera simulation vlog cmd and update Riviera simulation template")
# REVISION = ("2481", "Thu May 23 13:49:40 2019", "support new scan script")
# REVISION = ("2477", "Thu May 16 12:15:37 2019", "change --set-env to append mode")
