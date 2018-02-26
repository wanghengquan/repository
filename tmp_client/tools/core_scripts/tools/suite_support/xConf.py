#!/usr/bin/env python
#
# Configuration File Parser
#
# class AppConfig will override the original function: optionxform
#       which can keep the original option name (case sensitive)
#       for configuration dictionary.
#

import ConfigParser

class AppConfig(ConfigParser.ConfigParser):
    def __init__(self):
        ConfigParser.ConfigParser.__init__(self)

    def optionxform(self, optionstr):
        """
        re-define optionxform, in the release version, return optionstr.lower()
        """
        return optionstr

def get_conf_options(conf_files, key_lower=True):
    conf_options = dict()
    if key_lower:
        conf_parser = ConfigParser.ConfigParser()
    else:
        conf_parser = AppConfig()
    conf_parser.read(conf_files)
    for section in conf_parser.sections():
        t_section = dict()
        for option in conf_parser.options(section):
            value = conf_parser.get(section, option)
            t_section[option] = value
        conf_options[section] = t_section
    return conf_options
