import re


def _csv2dict(csv_file, start_title_mark=""):
    """
    convert csv file's line to a dictionary
    After find the title line, line --> dictionary
    otherwise line --< list
    """
    if not start_title_mark:
        start_title_mark = "Design"
    title = list()
    for line in open(csv_file):
        line = line.strip()
        if not line:
            continue
        line = re.split(",", line)
        line = [item.strip() for item in line]
        if title:
            d = dict(list(zip(title, line)))
            lt, ll = len(title), len(line)
            if lt > ll:   # less content in line
                for key in title[ll:]:
                    d[key] = "NA"
            elif lt < ll: # more content in line
                d["restKey"] = line[lt:]
            yield d
        else:
            if line[0] == start_title_mark:
                title = line
            yield line

def get_csv_dict(csv_file, user_key="", start_title_mark=""):
    """
    get preface lines and csv dictionary
    """
    d = _csv2dict(csv_file, start_title_mark)
    if not user_key:
        user_key = ["Design"]
    csv_dict = dict()
    for i, line in enumerate(d):
        if type(line) is dict:
            my_key = [line.get(item) for item in user_key]
            my_key = ",".join(my_key)
            csv_dict[my_key] = line
        else: # is a list
            pre_key = "pre_%03d" % i
            csv_dict[pre_key] = line
    return csv_dict




