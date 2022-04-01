from xml.etree import ElementTree
from . import custom_environment

__author__ = 'Shawn'


def print_node(node, blank=""):
    for key, value in list(node.items()):
        print("%s %s:%s" % (blank, key, value))
    more_blanks = blank + "    "
    for sub_node in list(node):
        print(more_blanks, sub_node.tag)
        print_node(sub_node, more_blanks)


def print_xml(text='', xml_file=''):
    if xml_file:
        root = ElementTree.parse(xml_file)
    elif text:
        root = ElementTree.fromstring(text)
    else:
        my_log = "Can not parse the XML file or string."
        raise my_log
    my_iterator = list(root.iter("BaliProject"))
    for e in my_iterator:
        print(e.tag)
        print_node(e, "    ")


def dump2dict(a_node):
    t = dict()
    for key, value in list(a_node.items()):
        t[key] = value
    return t


def parse_ldf_file(ldf_file="", ldf_lines="", for_radiant=False):
    if ldf_file:
        root = ElementTree.parse(ldf_file)
    else:
        root = ElementTree.fromstring(ldf_lines)
    if for_radiant:
        tag = "RadiantProject"
    else:
        tag = "BaliProject"
    my_iterator = list(root.iter(tag))
    bali_node = None
    for e in my_iterator:
        if e.tag == tag:
            bali_node = e
            break
    ldf_dict = dict()
    if bali_node is None:
        return ldf_dict
    # bali
    bali_dict = dump2dict(bali_node)
    ldf_dict["bali"] = bali_dict

    # impl & source
    src_list = list()
    def_impl_name = ""
    for key, value in list(bali_node.items()):
        if key == "default_implementation":
            def_impl_name = value

    for sub_node in list(bali_node):
        tag_name = sub_node.tag
        if tag_name == "Implementation":
            impl_dict = dump2dict(sub_node)
            impl_title = impl_dict.get("title")
            if impl_title == def_impl_name:
                ldf_dict["impl"] = impl_dict
                for src_node in list(sub_node):
                    if src_node.tag == "Source":
                        this_source = dump2dict(src_node)
                        try:
                            for peter in list(src_node):
                                sally = dump2dict(peter)
                                if sally:
                                    _top = sally.get("top_module")
                                    if _top:
                                        ldf_dict["top"] = _top
                                    _lib = sally.get("lib")
                                    if _lib:
                                        this_source["work_lib"] = _lib
                        except:
                            pass
                        src_list.append(this_source)
                        # -------------
                    elif src_node.tag == "Options":
                        if ldf_dict.get("top"):
                            continue  # found already
                        t = dump2dict(src_node)
                        # try to get top
                        _top = t.get("top")
                        if not _top:
                            _top = t.get("def_top")
                        if not _top:
                            for b in list(src_node):
                                t = dump2dict(b)
                                if t.get("name") == "top":
                                    _top = t.get("value", "NoTopNameFound")
                        if _top:
                            ldf_dict["top"] = _top
    ldf_dict["source"] = src_list
    check_apollo_device = ldf_dict.get("bali", dict()).get("device")
    if check_apollo_device:
        custom_environment.env_device_is_apollo(check_apollo_device)
    return ldf_dict
