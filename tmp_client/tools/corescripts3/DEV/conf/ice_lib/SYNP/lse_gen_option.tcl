### LSE generic options ###
### LSE version: 2_2b78_20130329_LIN ###
-frequency 200
-optimization_goal Area
-twr_paths 3
-bram_utilization 100.00
-ramstyle Auto
-romstyle Auto
-use_carry_chain 1
-carry_chain_length 0
-resource_sharing 1
-propagate_constants 1
-remove_duplicate_regs 1
-max_fanout 10000
-fsm_encoding_style Auto
-use_io_insertion 1
-use_io_reg auto
-ifd
-resolve_mixed_drivers 0
-RWCheckOnRam 0
-fix_gated_clocks 1

### output edif ####
-output_edif ./rev_1/test_syn.edf
-logfile  ./rev_1/test_syn.log 
