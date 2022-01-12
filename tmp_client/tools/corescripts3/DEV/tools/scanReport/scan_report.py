from bin.scan_method import *
from bin.scan_config import *
from bin.scan_args import *
import sys
from collections import OrderedDict
import json
import csv
from bin.scan_default import *
from bin.scan_maps import maps
import copy


def entry(args):
    options = cmd_parser.parse_args(args)
    if not options.design:
        for design in os.listdir(options.top_dir):
            options_tmp = copy.copy(options)
            if os.path.isdir(os.path.join(options_tmp.top_dir, design)):
                options_tmp.design = design
                scan_once(options_tmp)
    else:
        scan_once(options)


def scan_once(options):
    add_scan()
    scf_parser.parse_args(options)
    sched()
    report(options)
    clear_process()


def add_scan():
    add_process(ScanPattern())
    add_process(ScanStrings())
    add_process(ScanNumbers())
    add_process(ScanPrjInfo())
    add_process(ScanTimingFMAX())
    add_process(ScanTimingPAP())    
    add_process(ScanResource())
    add_process(ScanLSE())
    add_process(ScanPAR())
    add_process(ScanCPU())
    add_process(ScanMemory())
    add_process(ScanErrors())
    add_process(ScanMilestone())
    add_process(ScanSimulation())


def report(options):
    all_info = OrderedDict()
    for p in for_each_process():
        if p.stack:
            tmp = OrderedDict()
            for item in p.stack:
                tmp = OrderedDict(tmp, **item)
            if p.name not in all_info:
                all_info[p.name] = tmp
            else:
                tmp.update(all_info[p.name])
                all_info[p.name] = tmp
    if not options.rpt_file:
        if options.rpt_dir:
            rpt = os.path.join(options.rpt_dir, os.path.basename(options.top_dir) + '.csv')
        else:
            rpt = os.path.join(options.top_dir, os.path.basename(options.top_dir) + '.csv')
    else:
        if not options.rpt_dir:
            rpt = os.path.join(options.top_dir, options.rpt_file)
        else:
            rpt = os.path.join(options.rpt_dir, options.rpt_file)

    csv_row = []
    if not os.path.exists(rpt):
        with open(rpt, 'w') as f:
            writer = csv.writer(f)
            writer.writerow(['Design'] + list(maps.keys()))

    with open(rpt, 'a') as f:
        writer = csv.writer(f)
        csv_row.append(os.path.basename(options.design))
        r = {}
        for i in list(all_info.values()):
            r.update(i)
        for i in maps:
            if i in r:
                csv_row.append(r[i])
            else:
                csv_row.append('NA')
        writer.writerow(csv_row)

    all_info = json.dumps(all_info)
    print(all_info)


if __name__ == '__main__':
    try:
        entry(sys.argv[1:])
    except FileNotExist as e:
        print((e.msg))
    except PatternNotFound as e:
        print((e.msg))
    except ConfigIssue as e:
        print((e.msg))
