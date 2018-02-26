__author__ = 'syan'
import sys
from xlib import flowLattice

private_options = dict(is_ng_flow=True)
my_test = flowLattice.FlowLattice(private_options)
sts = my_test.process()
sys.exit(sts)
