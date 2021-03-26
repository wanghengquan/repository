import os
import time
import logging

ERROR_FILE = os.environ.get("ERROR_FILE", "")

def set_logging_level(debug=0, quiet=0, rpt_dir="", time_mark=0):
    log_level = out_level = logging.INFO
    if debug:
        log_level = out_level = logging.DEBUG
    elif quiet:
        log_level, out_level = logging.INFO, logging.WARNING
    msg_format = "%(message)s "
    if rpt_dir:
        if time_mark:
            log_file = os.path.join(rpt_dir, "flow_record_%s.log" % time.strftime("%H%M%S"))
        else:
            log_file = os.path.join(rpt_dir, "flow_record.log")
        logging.basicConfig(level=log_level,
            format=msg_format,
            filename=log_file,
            filemode="a")
        console = logging.StreamHandler()
        console.setLevel(out_level)
        formatter = logging.Formatter(msg_format)
        console.setFormatter(formatter)
        logging.getLogger("").addHandler(console)
    else:
        logging.basicConfig(level=out_level, format=msg_format)

def print_always(log_line):
    """ Always print out (Warning Level)
    """
    logging.warning(log_line)

def print_error(log_line, error_file=ERROR_FILE, add_ERROR=True):
    """ Always print out (Error Level)
    """
    if add_ERROR:
        log_line = "ERROR! " + log_line
    logging.error(log_line)
    if error_file:
        try:
            error_ob = open(error_file, "a")
            print(log_line, file=error_ob)
            error_ob.close()
        except IOError:
            print_always("ERROR! Can not append error_log to the file: %s" % error_file)

def print_quiet(log_line):
    """ Do not print when quietly
    """
    logging.info(log_line)

def print_debug(log_line):
    """ Print out debug message
    """
    logging.debug(log_line)

def wrap_debug(content, title=""):
    """ Wrapper for print debug message
    """
    if title:
        print_debug(title)
        print_debug(" Time: %s" % time.asctime())
    content_type = type(content)
    if content_type is dict:
        keys = list(content.keys())
        keys.sort(key=str.lower)
        total_no = len(keys)
        for i, key in enumerate(keys):
            log_line = "(%3d/%-3d) %-15s : %s" % (i+1, total_no, str(key), str(content[key]))
            print_debug(log_line)
    elif content_type is list:
        total_no = len(content)
        for i, item in enumerate(content):
            log_line = "%3d/%-3d : %s" %(i+1, total_no, str(item))
            print_debug(log_line)
    elif content_type is str:
        print_debug(content)
    else:
        new_content = eval(str(content))
        if type(new_content) in (dict, list, str):
            wrap_debug(new_content)
        else:
            print_debug(content)
    print_debug("-" * 25)

def wrap_quiet(a_string, line_lens=0):
    """ Wrapper for print information
    """
    a_list = a_string.split()
    log_line = "   * "
    if line_lens:
        for item in a_list:
            log_line = log_line + " " + item
            if len(log_line) > line_lens:
                print_quiet(log_line)
                log_line = "   * "
        if log_line:
            print_quiet(log_line)
    else:
        print_quiet(" ".join(a_list))

def play_announce():
    """ Announcement at the beginning
    """
    print_always("")
    print_always("*---------------------------------------------")
    print_always("* Welcome to Lattice Software QA Test Suite")
    print_always("* Play Time: %s" % time.asctime())
    print_always("*---------------------------------------------")
    print_always("")
    return time.time()

def stop_announce(play_time):
    """ Announcement at the end
    """
    elapsed_time = time.time() - play_time
    print_always("")
    print_always("*---------------------------------------------")
    print_always("* Finished Lattice Software QA Test Flow")
    print_always("* Stop Time: %s" % time.asctime())
    print_always("*")
    print_always("* Elapsed time: %d seconds." % elapsed_time)
    print_always("*---------------------------------------------")
    print_always("")