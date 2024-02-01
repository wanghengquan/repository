#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  Date: 13:22 2023/9/24
  File: local_scan.py
  Author: Shawn Yan
Description:
  python local_scan.py --help
  local path format example:
    D:/copyResults/p43_237112/local_results/run237112/Jedi_D2_E30_lse/T41158486/12_matrox
    Argument output: D:/copyResults/p43_237112/local_results
    fixed format: run237112/Jedi_D2_E30_lse/T41158486/12_matrox (runID, section_name, TestID, design name)
"""
import argparse
import os
import re
import shutil
import sys
import glob
import zipfile
from capuchin import xDatabase
from capuchin import xTools
from capuchin import xCopy

SQL = """
SELECT A.`project_id`, A.`id` AS run_id, B.`id` AS test_id, C.title, 
  D.`name` AS section_name, C.custom_config AS case_desc
FROM runs A
LEFT JOIN tests B ON B.run_id = A.`id`
LEFT JOIN cases C ON C.`id` = B.case_id
LEFT JOIN sections D ON D.`id` = C.section_id
WHERE (A.id = {0} OR A.plan_id={0}) AND A.suite_id IS NOT NULL
"""


class CopyAndScan(object):
    def __init__(self):
        self.db = xDatabase.get_db_link()
        unix_path = "/lsh/sw/qa/qadata/results/prj{project_id}/run{run_id}/T{test_id}"
        windows_path = r"\\lsh-smb04\sw\qa\qadata\results\prj{project_id}\run{run_id}\T{test_id}"
        self.smb_path = windows_path if sys.platform.startswith("win") else unix_path

    def process(self):
        parser = argparse.ArgumentParser()
        parser.add_argument("-i", "--plan-run-id", type=int, required=True)
        parser.add_argument("-k", "--check-only", action="store_true")
        parser.add_argument("-b", "--batch-only", action="store_true")
        parser.add_argument("--copy", action="store_true")
        parser.add_argument("-o", "--output", default=os.path.abspath("local_results"))
        parser.add_argument("--fmax-opt", choices=("max", "min", "ht", "lt"), nargs="+")
        parser.set_defaults(fmax_opt=["min"])
        opts = parser.parse_args()
        self.plan_run_id = opts.plan_run_id
        self.check_only = opts.check_only
        self.batch_only = opts.batch_only
        self.copy = opts.copy
        self.output = opts.output
        self.fmax_opt = opts.fmax_opt

        self.whole_data = self.db.query(SQL.format(self.plan_run_id))
        self.update_whole_data()
        if self.batch_only:
            for fo in self.fmax_opt:
                self.generate_batch_file_only(fo)
        elif self.check_only:
            self.check_folders()
        elif self.copy:
            self.copy_results()

    def update_whole_data(self):
        for test_data in self.whole_data:
            test_data["output"] = xTools.win2unix(self.output, 1)
            test_data["design"] = os.path.basename(test_data.get("title"))
            test_data["src_smb_path"] = self.smb_path.format(**test_data)
            test_data["dst_loc_path"] = "{output}/run{run_id}/{section_name}/T{test_id}".format(**test_data)

    def generate_batch_file_only(self, fmax_opt_name):
        local_output_file = "R{run_id}_fmax_%s.csv" % fmax_opt_name
        local_output_file = os.path.abspath(local_output_file)
        public_cmd = "python new_scan.py --top-dir {output}/run{run_id}/{section_name}/T{test_id} --design {design}"
        public_cmd += ' --more "xTestID=T{test_id}" "xSectionName={section_name}" '
        public_cmd += " -o {}".format(local_output_file)
        public_cmd += " --fmax-opt {}".format(fmax_opt_name)
        batch_ob = open("hello_scan_run{}_fmax_{}.bat".format(self.plan_run_id, fmax_opt_name), "w", newline="\n")
        p_ignore = re.compile(r"(--ignore-clock\s+[^-]+)")
        for test_data in self.whole_data:
            cmd = public_cmd.format(**test_data)
            case_desc = test_data.get("case_desc")
            if case_desc:
                desc_lines = case_desc.splitlines()
                for foo in desc_lines:
                    if foo.startswith(";"):
                        continue
                    m_ignore = p_ignore.search(foo)
                    if m_ignore:
                        cmd += (" " + m_ignore.group(1))
            print(cmd, file=batch_ob)
        batch_ob.close()

    def check_folders(self):
        print("Checking data ...")
        for test_data in self.whole_data:
            src_base_name = "{src_smb_path}/T{test_id}".format(**test_data)
            failed_message = "Error. Failed to copy {}".format(os.path.abspath(src_base_name))
            zip_file = src_base_name + ".zip"
            if os.path.isfile(zip_file) or os.path.isdir(src_base_name):
                if not os.path.isfile(zip_file):
                    f_pattern = "{}/*/_scratch/runtime_console.log".format(src_base_name)
                    chk_files = glob.glob(f_pattern)
                    if not chk_files:
                        print(failed_message)
            else:
                print(failed_message)

    def copy_results(self):
        for test_data in self.whole_data:
            src_base_name = "{src_smb_path}/T{test_id}".format(**test_data)
            print("processing {}".format(src_base_name))
            zip_file = src_base_name + ".zip"
            dst_path = test_data.get("dst_loc_path")
            if os.path.isfile(zip_file) or os.path.isdir(src_base_name):
                xTools.wrap_md(dst_path, "local design path")
                if os.path.isfile(zip_file):
                    dst_zip_file = os.path.join(dst_path, os.path.basename(zip_file))
                    shutil.copy2(zip_file, dst_zip_file)
                    zipper = zipfile.ZipFile(dst_zip_file)
                    zipper.extractall(path=dst_path)
                else:
                    copyer = xCopy.SynchronizeDocuments()
                    copyer.process_folders(src_base_name, dst_path)


if __name__ == "__main__":
    my_copy = CopyAndScan()
    my_copy.process()
