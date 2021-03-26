def get_gbb_synthesis(args):
    if "now_chk_gbb" in args:
        if "check_logic_timing_not" in args:
            return 0
        if "now_chk_smart" not in args:
            return 1,
        if __run_scuba_only(args):
            return 0
        return 1


def get_gbb_map(args):
    if "now_chk_gbb" in args:
        if "now_chk_smart" not in args:
            return 1
        if __ss_only(args):
            return 0
        return 1


def get_gbb_par(args):
    if "now_chk_gbb" in args:
        if "now_chk_smart" not in args:
            return 1
        if __ssm_only(args):
            return 0
        if __in_args(("run_par_trace", "fmax_sweep", "seed_sweep", "fmax_center", "pushbutton"), args):
            return 1
        if not __in_args(("run_map", "run_par"), args):  # pushbutton
            return 1


def get_impl_lse(args):
    if "now_chk_impl" in args:
        if "now_chk_smart" not in args:
            return 1
        if __run_scuba_only(args):
            return 0
        if "+lse+" in args:
            return 1


def get_impl_synplify(args):
    if "now_chk_impl" in args:
        if "now_chk_smart" not in args:
            return 1
        if __run_scuba_only(args):
            return 0
        if "+synplify+" in args:
            return 1


def get_impl_map(args):
    if "now_chk_impl" in args:
        if "now_chk_smart" not in args:
            return 1
        if __ss_only(args):
            return 0
        return 1


def get_impl_par(args):
    if "now_chk_impl" in args:
        if "now_chk_smart" not in args:
            return 1
        if __ssm_only(args):
            return 0
        if __in_args(("run_par", "run_export", "fmax_sweep", "seed_sweep", "fmax_center", "pushbutton"), args):
            return 1
        if not __in_args(("run_map", ), args): # pushbutton
            return 1


def get_impl_bitstream(args):
    if "now_chk_impl" in args:
        if "now_chk_smart" not in args:
            return 1
        if __ssm_only(args):
            return 0
        if __in_args(("run_export_jedec", "run_export_prom", "run_export_bitstream", "run_export_xo3l"), args):
            return 1


def get_sim_rtl(args):
    if "now_chk_sim" in args:
        if "now_chk_smart" not in args:
            return 1
        if __in_args(("sim_rtl", "sim_all"), args):
            return 1


def get_sim_synthesis(args):
    if "now_chk_sim" in args:
        if "now_chk_smart" not in args:
            return 1
        if __ss_only(args):
            return 0
        if __in_args(("sim_syn_vlg", "sim_syn_vhd", "sim_all"), args):
            return 1


def get_sim_map(args):
    if "now_chk_sim" in args:
        if "now_chk_smart" not in args:
            return 1
        if __ss_only(args):
            return 0
        if __in_args(("sim_map_vlg", "sim_map_vhd", "sim_all"), args):
            return 1


def get_sim_par(args):
    if "now_chk_sim" in args:
        if "now_chk_smart" not in args:
            return 1
        if __ssm_only(args):
            return 0
        if __in_args(("sim_par_vlg", "sim_par_vhd", "sim_all"), args):
            return 1


def get_cov_bitstream(args):
    if "now_chk_cov" in args:
        if "now_chk_smart" not in args:
            return 1
        if __ssm_only(args):
            return 0
        if "run_simrel" in args:
            return 1


def __run_scuba_only(args):
    if "scuba_only" in args:
        return 1


def __run_synthesis_only(args):
    if "synthesis_only" in args:
        return 1


def __run_map_only(args):
    if "till_map" in args:
        return 1


def __ss_only(args):
    if __run_scuba_only(args):
        return 1
    if __run_synthesis_only(args):
        return 1


def __ssm_only(args):
    if __ss_only(args):
        return 1
    if __run_map_only(args):
        return 1


def __in_args(my_items, args):
    for foo in my_items:
        if foo in args:
            return 1


FILE_PATTERNS = {
        'gbb_synthesis':
        {
            'pattern': [
                r'.+?\.tws$',
            ],
            'func': get_gbb_synthesis
        },

        'gbb_map':
        {
            'pattern': [
                r'.+?\.tw1$',
            ],
            'func': get_gbb_map
        },

        'gbb_par':
        {
            'pattern': [
                r'.+?\.twr$',
            ],
            'func': get_gbb_par
        },

        'impl_lse':
        {
            'pattern': [
                r'.+?\.vm$',
                r'.+?_prim\.v$',
                r'.+?\.lsedata$',
                r'synthesis\.log$',
            ],
            'func': get_impl_lse
        },

        'impl_synplify':
        {
            'pattern': [
                r'.+?\.vm$',
                r'.+?\.srr$',
            ],
            'func': get_impl_synplify
        },

        'impl_map':
        {
            'pattern': [
                r'.+?\.mrp$',
            ],
            'func': get_impl_map
        },

        'impl_par':
        {
            'pattern': [
                r'.+?\.par$',
                r'.+?\.pad$',
            ],
            'func': get_impl_par
        },

        'impl_bitstream':
        {
            'pattern': [
                r'.+?\.bit$',
                r'.+?\.rbt$',
            ],
            'func': get_impl_bitstream
        },

        'sim_rtl':
        {
            'pattern': [
                'sim_rtl\/.+?$',
            ],
            'func': get_sim_rtl
        },

        'sim_synthesis':
        {
            'pattern': [
                'sim_syn_.+?\/.+?$',
            ],
            'func': get_sim_synthesis
        },

        'sim_map':
        {
            'pattern': [
                'sim_map_.+?\/.+?$',
            ],
            'func': get_sim_map
        },

        'sim_par':
        {
            'pattern': [
                'sim_par_.+?\/.+?$',
            ],
            'func': get_sim_par
        },

        'cov_bitstream':
        {
            'pattern': [
                r'simrel\/.+?$',
            ],
            'func': get_cov_bitstream
        },

        'uniform_funcs':
        {
            'pattern': [
                r'check_block',
                r'sim_check_block',
                r'check_lst',
                r'check_compare_par',
                r'check_sdf',
                r'check_binary',
            ],
            'func': None
        },

        'uniform_files':
        {
            'pattern': [

            ],
            'func': None
        },
}
