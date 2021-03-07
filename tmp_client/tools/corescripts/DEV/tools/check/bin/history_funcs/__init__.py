import os, re

def get_message(design_dir):
    scratch_dir = os.path.join(design_dir, "_scratch")
    files = ["create_ldf.log", "synthesis_flow.log", "run_pb.log", "runtime_console.log"]
    files = [os.path.join(scratch_dir, item) for item in files]
    p_list = [re.compile("^ERROR", re.I),
              re.compile("Running milestone", re.I),
              re.compile("^@E:")
              ]
    for log_file in files:
        if os.path.isfile(log_file):
            for line in open(log_file):
                line = line.strip()
                for p in p_list:
                    if p.search(line):
                        return line
    return ""