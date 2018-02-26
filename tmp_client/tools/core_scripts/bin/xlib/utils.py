import re
import xTools

__author__ = 'syan'


vendor_settings_dict = {"Active"  :  ["onbreak {resume}", "onerror {quit}"],
                        "Modelsim":  ["onbreak {resume}", "onerror {quit -f}"],
                        "QuestaSim": ["onbreak {resume}", "onerror {quit -f}"],
                        "default":   ["onbreak {resume}", "onerror {quit -f}"],
                        "Riviera":   ["onbreak {resume}", "onerror {quit -force}"],
                        # -------------------------
                        }
def update_simulation_do_file(vendor_name, do_file, lst_precision):
    """ add resume/quit operation to the simulation do file.
    if do file version is < 2.2, the resume/quit line will be added
    into the file before the first uncomment line.
    """
    # /////////////////// add onbreak lines
    # will insert the will_add_list into the first uncomment line
    found_resume = xTools.simple_parser(do_file, [re.compile("onbreak\s+\{\s*resume"), ])
    found_quit = xTools.simple_parser(do_file, [re.compile("onerror\s+\{\s*quit"), ])
    original_lines = xTools.get_original_lines(do_file, read_only=True)
    if found_resume and found_quit:
        t_lines = [item.rstrip() for item in original_lines]
    else:
        will_add_list = vendor_settings_dict.get(vendor_name)
        if not will_add_list:
            default_add_list = vendor_settings_dict.get("default")
            xTools.say_it("Warning. Not support simulation tool: %s" % vendor_name)
            xTools.say_it("         Use default settings: %s" % default_add_list)
            will_add_list = default_add_list
        added_already = 0
        t_lines = list()
        for line in original_lines:
            line = line.rstrip()
            t_line = line.strip()
            if not t_line:
                t_lines.append(line)
            elif added_already:
                t_lines.append(line)
            else:
                if t_line.startswith("#"):
                    t_lines.append(line)
                else:
                    for item in will_add_list:
                        t_lines.append(item)
                    t_lines.append(line)
                    added_already = 1

    # //////////////////// generate lst file by force
    p_lst = [re.compile("^asdb2ctf.+\.lst"),
             re.compile("^write list"),
             ]
    will_generate_lst = 0
    for item in t_lines:
        item = item.strip()
        for p in p_lst:
            if p.search(item):
                will_generate_lst = 1
                break
        if will_generate_lst:
            break

    if will_generate_lst: # change the lst_precision
        p1 = re.compile("configure list -strobestart")
        p2 = re.compile("asdb2.+(-time\s+\S+)")
        for i, item in enumerate(t_lines):
            if p1.search(item):
                t_lines[i] = "    configure list -strobestart {%d0000 ps} -strobeperiod {%d ns}" % (lst_precision, lst_precision)
            else:
                m2 = p2.search(item)
                if m2:
                    _item = re.sub("\s+-time\s+\S+", " -time %dns" % lst_precision, item)
                    t_lines[i] = _item
    else:
        # replace 'add wave *' and 'run *ms'
        if vendor_name == "Modelsim":
            dd = t_lines[:]
            t_lines = list()
            p_add_wave = re.compile("^\s*add\s+wave", re.I)
            p_run_time = re.compile("^\s*run\s+\d\w+", re.I)
            for item in dd:
                if p_add_wave.search(item):
                    continue
                elif p_run_time.search(item):
                    t_lines.append("add list -nodelta -hex -notrigger *")
                    t_lines.append("configure list -usestrobe 1")
                    t_lines.append("configure list -strobestart {%d0000 ps} -strobeperiod {%d ns}" % (lst_precision, lst_precision))
                    t_lines.append(item)
                    t_lines.append("write list final_lst.lst")
                else:
                    t_lines.append(item)
    # //////////////////// Write the do file
    new_ob = open(do_file,"w")
    for item in t_lines:
        print >> new_ob, item
    new_ob.close()
    if vendor_name == "Active":
        xTools.write_file('library.cfg', ['$INCLUDE = "$ACTIVEHDLLIBRARYCFG"'])













