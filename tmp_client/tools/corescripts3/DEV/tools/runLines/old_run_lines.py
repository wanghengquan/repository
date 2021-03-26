import os
import re
import sys
import time
import random
import shutil
import optparse
import _thread
import platform

class RunLines:
    def __init__(self):
        self.on_win = re.search("win", sys.platform)
        self.p_run_synp = re.compile("\s+--run-")
        self.elapsed_time_csv = "Elapsed_time.csv"
        self.host_name = platform.uname()[1]

    def process(self):
        self.parse_options()
        if self.process:
            self.run_with_processes()
        else:
            self.run_single_process()

    def parse_options(self):
        parser = optparse.OptionParser()
        parser.add_option("--run321", action="store_true", help="run in inverted sequence")
        parser.add_option("--run-synp", action="store_true", help="run synthesis only")
        parser.add_option("--run-mpar", action="store_true", help="run mpar only")
        parser.add_option("-p", "--process", type="int", metavar="<process number>")
        parser.add_option("--do-file", metavar="<do_file>", help="specify the batch file")
        parser.add_option("--do-fext", metavar="<do_fext>", default=".lines", help="specify the file's extension")
        opts, args = parser.parse_args()

        self.run321 = opts.run321
        self.run_synp = opts.run_synp
        self.run_mpar = opts.run_mpar
        self.process = opts.process
        self.do_file = opts.do_file
        self.do_fext = opts.do_fext.lower()

    def run_with_processes(self):
        if self.do_file or (self.do_fext !='.lines'):
            print(" ** not support --do-file or --do-fext options when running with mult-processes")
            return
        one_by_one_cmd = "s_i_n_g_l_e_r_u_n.cmd"
        if self.run321:
            one_by_one_cmd = "321_" + one_by_one_cmd
        if not os.path.isfile(one_by_one_cmd):
            ob_one = open(one_by_one_cmd, "w")
            t_line = "%s %s " % (sys.executable, sys.argv[0])
            if self.run321:
                t_line += " --run321"
            print(t_line, file=ob_one)
            print("exit", file=ob_one)
            ob_one.close()
        else:
            time.sleep(5)

        if self.process > 6:
            self.process = 6
        for i in range(self.process):
            if self.on_win:
                os.system("start %s" % one_by_one_cmd)
            else:
                _thread.start_new_thread(os.system, ("xterm -e sh %s" % one_by_one_cmd,))
            time.sleep(5)

    def get_files(self):
        self.files = list()
        if self.do_file:
            self.files.append(self.do_file)
        else:
            for foo in os.listdir("."):
                file_name, file_ext = os.path.splitext(foo.lower())
                if file_ext == self.do_fext:
                    self.files.append(foo)

    def find_stop_mark(self):
        for foo in os.listdir("."):
            if foo == "stop":
                print(" ** Find stop mark, exit...")
                return 1

    def append_file(self, a_file, line):
        a_ob = open(a_file, "a")
        print("<%s>%s@%s" % (self.host_name, time.ctime(), line), file=a_ob)
        a_ob.close()
        start_time = time.time()
        print((" ** Running <%s>" % line))
        os.system(line)
        print("")
        time_lens = time.time() - start_time
        time_ob = open(self.elapsed_time_csv, "a")
        print('%8.2f,"%s",' % (time_lens, line), file=time_ob)
        time_ob.close()
        time.sleep(random.randint(300,1000)/100.0)
        return 1

    def get_file_lines(self, a_file):
        lines = list()
        if os.path.isfile(a_file):
            for line in open(a_file):
                line = line.strip()
                if not line: continue
                if re.search("^rem", line): continue
                if re.search("^#", line): continue
                line = re.split("@", line)
                lines.append(line[-1])
        return lines, set(lines)

    def run_single_process(self):
        while True:
            run_one_command = 0
            if self.find_stop_mark():
                break
            self.get_files()
            if not self.files:
                break
            self.files.sort()
            if self.run321:
                self.files.reverse()
            for a_file in self.files:
                a_file_done = a_file + ".done"
                file_lines, file_lines_set = self.get_file_lines(a_file)
                done_lines, done_lines_set = self.get_file_lines(a_file_done)
                if done_lines_set >= file_lines_set:
                    shutil.move(a_file, "%s.fine" % a_file)
                    continue
                for line in file_lines:
                    if line in done_lines:
                        continue
                    m_run_synp = self.p_run_synp.search(line)
                    if self.run_synp:
                        if m_run_synp:
                            run_one_command = self.append_file(a_file_done, line)
                            break
                    elif self.run_mpar:
                        if not m_run_synp:
                            run_one_command = self.append_file(a_file_done, line)
                            break
                    else:
                        run_one_command = self.append_file(a_file_done, line)
                        break
                else:
                    # parse next file
                    continue
                    # rescan files and launch again
                break
            if not run_one_command:
                print("All test flow done.")
                break


if __name__ == "__main__":
    my_run = RunLines()
    my_run.process()







