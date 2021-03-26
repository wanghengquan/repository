import msvcrt
LK_UNLCK = 0 # unlock the file region 
LK_LOCK = 1 # lock the file region
LK_NBLCK = 2 # non-blocking lock 
LK_RLCK = 3 # lock for writing 
LK_NBRLCK = 4
def lock_file(file_name='process_lock_file.log'):
    log_handle   = open(file_name,'a')
    while 1:
        try:
            a_lock = msvcrt.locking(log_handle.fileno(), LK_LOCK, 1000000)
            return log_handle
        except IOError:
            print(2)
            time.sleep(1)
            continue

def unlock_file(file_hand):
    file_hand.close()