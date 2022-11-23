import sys,time,os,sys
import re
import string
import win32gui
from win32gui import *
import win32con

#re.compile('lattice\s+semic', re.I),
p_cancel = [re.compile('edif2ngd\.exe', re.I),
            re.compile('par\.exe', re.I),
            re.compile('bitgen\.exe', re.I),
            re.compile('map\.exe', re.I),
            re.compile('trce\.exe', re.I),
            re.compile('synthesis\.exe', re.I),
            re.compile('your\s+information', re.I),
            re.compile('scuba\.exe', re.I),
            re.compile('^error', re.I),
            re.compile('vlm\.exe', re.I),
            re.compile('pnmainc\.exe', re.I),
            #re.compile('pnmain\.exe', re.I),  --20221123,Jason: when 'PNMAIN_CONSOLE_DEBUG=1' enabled pnmain window will open
            re.compile('synbatch\.exe', re.I),
            re.compile('drive not ready', re.I),
            re.compile('sbtimer\.exe', re.I),
            re.compile('vsim\sstandalone', re.I),
            re.compile('timing\.exe', re.I),
            re.compile('^lattice\ssemiconductor$', re.I),
            re.compile('vsimk\.exe', re.I),
            re.compile('^\s*Active-HDL\s+[\d\.]+\s*$', re.I)
           ]
def kill_error_box(break_title=""):
    #print 'check all commands status....'
    #for titles, we can also read from "kill_title.conf"
    kill_title_file = os.path.join(os.path.dirname(__file__),"kill_title.conf");
    if os.path.isfile(kill_title_file):
            conf_titles = file(kill_title_file).readlines()
            for line in conf_titles:
                line = line.strip()
                if line:
                    line_compile = re.compile(line,re.I)
                    if line_compile not in p_cancel:
                        p_cancel.append(line_compile)
    titles = set()
    def foo(hwnd, nouse):
        if IsWindow(hwnd) and IsWindowEnabled(hwnd) and IsWindowVisible(hwnd):
            titles.add(GetWindowText(hwnd))
            del nouse
    while True:
        print  ("sleep.......")
        try:
            EnumWindows(foo, 0)
            lt = [t for t in titles if t]
            lt.sort()
            for t in lt:
                for p in p_cancel:
                    if p.search(t):
                        hWnd = FindWindow(None, t)
                        print("Killing [%s] ..." % t)
                        PostMessage(hWnd, win32con.WM_CLOSE, 0, 0)
                        time.sleep(5)
            if break_title:
                for t in lt:
                    if break_title.search(t):
                        break
                else:
                    print("All Test Flow DONE!")
                    break  # exit the while loop
            break
        except:
            print (1)
            pass


if __name__ == "__main__":
    kill_error_box()

