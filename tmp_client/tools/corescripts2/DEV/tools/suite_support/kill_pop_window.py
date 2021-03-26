import sys,time,os,sys
import re
import string
from win32gui import *
import win32con

p_cancel = [re.compile('lattice\s+semic', re.I),
            re.compile('par\.exe', re.I),
            re.compile('map\.exe', re.I),
            re.compile('trce\.exe', re.I),
            re.compile('synthesis\.exe', re.I),
            re.compile('your\s+information', re.I),
            re.compile('scuba\.exe', re.I),
            re.compile('error', re.I),
            re.compile('vlm\.exe', re.I),
            re.compile('pnmainc\.exe', re.I),
            re.compile('synbatch\.exe', re.I),
            re.compile('drive not ready', re.I),
           ]
def kill_error_box(break_title=""):
    #print 'check all commands status....'
    titles = set()
    def foo(hwnd, nouse):
        if IsWindow(hwnd) and IsWindowEnabled(hwnd) and IsWindowVisible(hwnd):
            titles.add(GetWindowText(hwnd))
            del nouse
    while True:
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
            pass


if __name__ == "__main__":
    kill_error_box()

        