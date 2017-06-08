import sys
from xlib import flowClassic

__author__ = 'syan'

private_options = dict()
my_test = flowClassic.FlowClassic(private_options)
try:
    sts = my_test.process()
except Exception, e:
    print e
    sts = 1
sys.exit(sts)
