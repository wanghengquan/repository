import os
import platform

par_dir = os.path.join(os.getcwd(), '..', 'par')
node_file = os.path.join(par_dir, 'node_file.txt')
node_fwh = open(node_file,'w')
print >> node_fwh, '[%s]' % platform.node()
if 'nt' in os.name:
    print >> node_fwh, 'system = pc'
else:
    print >> node_fwh, 'system = linux'
print >> node_fwh, 'corenum = 2'
node_fwh.close()
print 'node file created'