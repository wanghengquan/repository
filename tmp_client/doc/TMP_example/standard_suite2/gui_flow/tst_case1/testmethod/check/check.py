from bin.core import main
import sys
from bin.tools import log
from bin.__default__ import ConfigIssue, Default


try:
    ret, (status, comments) = main()
except ConfigIssue as e:
    log(e.msg)
    ret, (status, comments) = 4, ('Case_Issue', None)


log('-' * 44 + 'final reports' + '-' * 43)
if status == 'SW_Issue': # and comments.startswith('SW_Issue'):
    log('###CR_NOTE_BEGIN###')
    log(', '.join(comments))
    log('###CR_NOTE_END###')

final_status = next((i for i in list(Default.PRIORITY.keys()) if Default.PRIORITY[i] == ret))
final_ret = Default.STATUS[final_status]
log('Final check status: ' + str(final_ret))
log(final_status)

sys.exit(final_ret)
