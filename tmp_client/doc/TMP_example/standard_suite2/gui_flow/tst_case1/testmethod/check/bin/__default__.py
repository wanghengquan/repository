import queue
import os
import re
from collections import OrderedDict
import traceback
from .pattern import FILE_PATTERNS


def decrypt(s, key=365):
    """ Decrypt a string
    """
    s = re.sub("-", "", s)
    c = bytearray(str(s).encode("gbk"))
    n = len(c)
    if n % 2 != 0:
        return ""
    n //= 2
    b = bytearray(n)
    j = 0
    for i in range(0, n):
        key -= 1
        c1 = c[j] - 65
        c2 = c[j+1] - 65
        j += 2
        b2 = c2 * 16 + c1
        b1 = b2 ^ key
        b[i] = b1
    return b.decode("gbk")


ALL_METHODS = []


class Default(object):
    P_FUNCTION_GET_VALUE = re.compile(r"_get_value_(\S+)")
    TOP_DIR, DESIGN = os.path.split(os.getcwd())
    CONF_FILE = None
    DEF_CONF = None
    REPORT_PATH = './'
    TAG = '_scratch'
    REPORT = 'check.csv'
    RERUN_PATH = os.getcwd()
    BASE_PATH = os.getcwd()
    CASE_CMD = ''
    PASS = True
    FAIL = False
    CHOSE_CONF_FILE_FIRST_ONE = True
    CHOSE_CONF_FILE_ALL = False

    OPs = ['&&', '||']
    PRIORITY = {'Passed': 0, 'SW_Issue': 1, 'Failed': 3, 'Case_Issue': 4, 'NA': -1}
    STATUS = {'Passed': 200, 'Failed': 201, 'Case_Issue': 203, 'SW_Issue': 204, 'IDLE': 255}

    AUTHS = [
             # user 1 -----------
             (decrypt('P-R-M-R-L-R-I-Q-E-Q-G-Q-E-Q'),
              decrypt('P-T-M-R-L-T-I-Q-E-S-G-Q-E-Q-E-U')),
             # user 2 -----------
             (decrypt('P-R-C-R-L-Q-H-Q'),
              decrypt('P-V-L-V-P-S-L-R-E-Q-O-Q-E-V-F-V-G-V-D-V')),
             # user 3 -----------
             (decrypt('G-Q-M-R-L-Q-H-Q-P-Q-G-V'),
              decrypt('N-T-O-R-L-Q-H-Q-I-S-L-Q-H-Q-B-R-A-R-K-Q-B-Q-E-Q-B-V-N-W-N-W')),
             # user 4 -----------
             (decrypt('G-Q-C-R-P-Q'),
              decrypt('A-Q-K-Q-O-R-N-R-B-Q-E-Q-D-Q-F-S-F-V-B-V-B-V')),
             # ---
             ]

    MAX_TRIES = 5

    MAX_FILE_LINES = 450000

    CLK_NUMS = ['Number of Clocks: {0}',
                'Number of Clocks processed: {0}', ]
    CLK_ENABLES = ['Number of Clock Enables: {0}', ]

    STA_MAXLINES = 5
    STA_PATTERNS = ['{0} endpoints',
                    '{0} startpoints',
                    '{0} paths']

    FLOW = ['lse', 'synp', 'synthesis', 'map', 'par', 'bitstream', 'ibis', 'prom', 'download', 'jedec']

    FILE_PATTERNS = FILE_PATTERNS

    def __init__(self):
        pass

    @staticmethod
    def get_all_methods():
        all_methods = OrderedDict()
        for method in ALL_METHODS:
            all_methods[method] = queue.Queue()
        return all_methods


class SectionInfo:
    def __init__(self):
        self.cr_note = ''
        self.cr_status = ''
        self.title = ''
        self.result = Default.PASS
        self.show = False

    def sectioninfo(self):
        return self.__dict__


class CaseInfo:
    def __init__(self):
        self.type = ''
        self.area = ''
        self.logic_result = ''
        self.cr_note = ''
        self.cr_status = ''

    def caseinfo(self):
        return self.__dict__


class ConfigIssue(Exception):
    def __init__(self, msg, debug=False):
        super(Exception, self).__init__()
        self.msg = msg
        if debug:
            traceback.print_exc()
