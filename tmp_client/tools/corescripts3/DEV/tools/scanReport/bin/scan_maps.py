from collections import OrderedDict


categories = {
    1: 'Project Info',
    2: 'Resource',
    3: 'Timing',
    4: 'LSE',
    5: 'Par',
    6: 'CPU Time',
    7: 'Memory',
    8: 'Errors',
    9: 'Milestone',
    10: 'Simulation',
    11: 'Coverage',
}


MAX_ID = 118
''' keyword: (id, [categories list]) '''
maps = OrderedDict(sorted(list({
    'version': (0, [1]),
    'device': (1, [1]),
    'synthesis': (2, [1]),
    'HDL_type': (3, [1]),
    'maxLoads': (4, [3]),
    'totalLoads': (5, [3]),
    'scoreHold': (6, [3]),
    'scoreSetup': (7, [3]),
    'targetFmax': (8, [3]),
    'fmax': (9, [3]),
    'fmax_pap': (10, [3]),
                     'pap': (10.2, [3]),
                     'pap_fmax': (10.3, [3]),
    'CombineLoop': (11, [3]),
    'clkName': (12, [3]),
    'route_delay': (13, [3]),
    'cell_delay': (14, [3]),
    'logic_level': (15, [3]),
    'doubleEdge': (16, [3]),
    'constraint_coverage': (17, [3]),
    'total_neg_slack_setup': (18, [3]),
    'total_neg_slack_hold': (19, [3]),
    'logic': (20, [3]),
    'route': (21, [3]),
    'Register': (22, [2]),
    'Register_per': (23, [2]),
    'Slice': (24, [2]),
    'Slice_per': (25, [2]),
    'LUT': (26, [2]),
    'LUT_per': (27, [2]),
    'IO': (28, [2]),
    'IO_per': (29, [2]),
    'EBR': (30, [2]),
    'LRAM': (30.1, [2]),
    'DSP': (31, [2]),
    'DSP_PREADD9': (32, [2]),
    'DSP_MULT9': (33, [2]),
    'DSP_MULT18': (34, [2]),
    'DSP_M18X36': (35, [2]),
    'DSP_MULT36': (36, [2]),
    'DSP_ACC54': (37, [2]),
    'DSP_REG18': (38, [2]),
    'CARRY': (39, [2]),
    'DistributedRAM': (40, [2]),
    'clkNumber': (41, [2]),
    'clkEnNumber': (102, [2]),
    'LSRNumber': (103, [2]),
    'clkMaxLoadNum': (104, [2]),
    'clkMaxLoadName': (105, [2]),
    'clkEnMaxLoadNum': (106, [2]),
    'clkEnMaxLoadName': (107, [2]),
    'LSRMaxLoadNum': (108, [2]),
    'LSRMaxLoadName': (109, [2]),
    'MULT18X18D': (42, [2]),
    'MULT9X9D': (43, [2]),
    'ALU54B': (44, [2]),
    'ALU24B': (45, [2]),
    'PRADD18A': (46, [2]),
    'PRADD9A': (47, [2]),
    'MULT36X36B': (48, [2]),
    'MULT18X18B': (49, [2]),
    'MULT18X18MACB': (50, [2]),
    'MULT18X18ADDSUBB': (51, [2]),
    'MULT18X18ADDSUBSUMB': (52, [2]),
    'MULT9X9B': (53, [2]),
    'MULT9X9ADDSUBB': (54, [2]),
    'MULT18X18C': (55, [2]),
    'MULT9X9C': (56, [2]),
    'ALU54A': (57, [2]),
    'ALU24A': (58, [2]),
    'PCS': (59, [2]),
    'lse_reg': (60, [4]),
    'lse_carry': (61, [4]),
    'lse_io': (62, [4]),
    'lse_lut4': (63, [4]),
    'lse_ebr': (64, [4]),
    'lse_dsp': (65, [4]),
    'lse_odd': (66, [4]),
    'lse_even': (67, [4]),
    'par_signals': (68, [5]),
    'par_connections': (69, [5]),
    'par_congestion_level': (70, [5]),
    'par_congestion_area': (71, [5]),
    'par_congestion_area_per': (72, [5]),
    'par_setupPAP': (72.1, [5]),
    'Placer_cpu_Time': (73, [6]),
    'Router_cpu_Time': (74, [6]),
    'par_cpu_Time': (75, [6]),
    'par_real_Time': (76, [6]),
    'map_cpu_Time': (77, [6]),
    'map_real_Time': (78, [6]),
    'synp_cpu_Time': (79, [6]),
    'synp_real_Time': (80, [6]),
    'postsyn_cpu_Time': (81, [6]),
    'postsyn_real_Time': (82, [6]),
    'lse_cpu_Time': (83, [6]),
    'Total_cpu_time': (84, [6]),
    'Total_real_time': (85, [6]),
    'lse_peak_Memory': (86, [7]),
    'synp_peak_Memory': (87, [7]),
    'postsyn_peak_Memory': (88, [7]),
    'map_peak_Memory': (89, [7]),
    'ParPeakMem': (90, [7]),
    'mapErrors': (91, [8]),
    'parErrors': (92, [8]),
    'Synthesis': (93, [9]),
    'Map': (94, [9]),
    'Par': (95, [9]),
    'BitGen': (96, [9]),
    'sim_tool': (97, [10]),
    'sim_rtl_time': (98, [10]),
    'sim_syn_time': (99, [10]),
    'sim_map_time': (100, [10]),
    'sim_par_time': (101, [10]),
    'rtl_sim_coverage': (117, [11]),
    'fmax_type': (110, [3]),
}.items()), key=lambda t: t[1][0]))
