#!/usr/bin/python
# -*- coding: utf-8 -*-
import re


def get_ok_inout(ori_inout, avc_inout):
    ok_inout = list()
    for i, a in enumerate(ori_inout):
        b = avc_inout[i]
        if b in ("*", "."):
            if a == "H":
                a = "L"
            else:
                a = "H"
        ok_inout.append(a)
    return "".join(ok_inout)


def get_new_avc_file(avc_file, err_file, new_avc_file):
    src_avc_ob = open(avc_file)
    dst_avc_ob = open(new_avc_file, "w")
    err_ob = open(err_file)
    err_dict = dict()
    # --- #924923.0 Inputs  -> 0011111LHHHHL
    # ---       Outputs -> 0011111LH**HL <- error 924699
    p1 = re.compile("#(\d+)\.0\s+Inputs\s+->\s+(\w+)")
    p2 = re.compile("Outputs\s+->\s+(\S+)")
    while True:
        line = err_ob.readline()
        if not line:
            break
        m1 = p1.search(line)
        if m1:
            line_no = m1.group(1)
            ori_inout = m1.group(2)
            line = err_ob.readline()
            m2 = p2.search(line)
            avc_inout = m2.group(1)
            ok_inout = get_ok_inout(ori_inout, avc_inout)
            err_dict[int(line_no)] = ok_inout
    err_ob.close()

    i = 0
    for line in src_avc_ob:
        line = line.rstrip()
        if line.startswith("r1 name"):
            i += 1
        new_code = err_dict.get(i)
        if new_code:
            new_line = "r1 name  %s;" % new_code
        else:
            new_line = line
        print(new_line, file=dst_avc_ob)

    src_avc_ob.close()
    dst_avc_ob.close()


if __name__ == "__main__":
    get_new_avc_file("fc.avc", "fc.err", "new_fc.avc")

# End of File