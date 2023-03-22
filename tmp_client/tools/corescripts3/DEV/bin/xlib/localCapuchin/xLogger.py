#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 3:54 PM 10/28/2022
  file: xLogger.py
  author: Shawn Yan
Description:
  wrapper of logging
"""
import os
import logging
import logging.config
import datetime
import traceback
import yaml
from collections import OrderedDict

YAML_FORMATTERS_HANDLERS = """
version: 1
disable_existing_loggers: False

formatters:
    default:
        format: "%(asctime)s | %(levelname)-7s | %(message)s"
        datefmt: "%y-%m-%d %H:%M:%S"
    simple:
        format: "%(levelname)-7s | %(message)s"
    simplest:
        format: "%(message)s"

handlers: 
    console:
        class: logging.StreamHandler
        level: DEBUG
        formatter: {format_name}
    info_file_handler:
        class: logging.handlers.RotatingFileHandler
        level: INFO
        formatter: {format_name}
        filename: {info_log_file}
        maxBytes: 10142857
        backupCount: 20
        # encoding: utf8
    error_file_handler:
        class: logging.handlers.RotatingFileHandler
        level: ERROR
        formatter: {format_name}
        filename: {error_log_file}
        maxBytes: 10142857
        backupCount: 10
        # encoding: utf8 
"""

YAML_CONSOLE_INFO = """
loggers:
    fileLogger:
        level: DEBUG
        handlers: [console, info_file_handler] 
        propagate: no
"""
YAML_CONSOLE_INFO_ERROR = """
loggers:
    fileLogger:
        level: DEBUG
        handlers: [console, info_file_handler, error_file_handler]
        propagate: no
"""


def use_shanghai_time(_no1, _no2):
    shanghai_time = datetime.datetime.utcnow() + datetime.timedelta(hours=8)
    return shanghai_time.timetuple()


logging.Formatter.converter = use_shanghai_time


def create_logger(info_log_file, error_log_file=None, format_name="default"):
    info_log_file = os.path.abspath(info_log_file)
    raw_desc = YAML_FORMATTERS_HANDLERS + (YAML_CONSOLE_INFO_ERROR if error_log_file else YAML_CONSOLE_INFO)
    description = raw_desc.format(info_log_file=info_log_file, error_log_file=error_log_file, format_name=format_name)
    config_dict = yaml.safe_load(description)
    logging.config.dictConfig(config_dict)
    return get_logger()


def create_flow_logger_by_itself(this_file, info_and_error=False, format_name="default"):
    t = os.path.abspath(this_file)
    base_dir = os.path.dirname(t)
    log_dir = os.path.join(base_dir, "logs")
    if not os.path.isdir(log_dir):
        os.mkdir(log_dir)
    file_name = os.path.splitext(os.path.basename(this_file))[0]
    log_file = os.path.join(log_dir, "flow_{}.log".format(file_name))
    if info_and_error:
        error_file = os.path.join(log_dir, "error_{}.log".format(file_name))
    else:
        error_file = None
    return create_logger(log_file, error_file, format_name)


def get_logger():
    temp = logging.getLogger("fileLogger")
    if temp.handlers:
        return temp


def remove_logger_handlers(logger):
    _handlers = logger.handlers
    if _handlers:
        for foo in _handlers:
            foo.close()


def say_it(msg, comments="", show=1, logger=None, log_level="info"):
    """Wrapper of print
    """
    if not show:
        return

    def _dump_it(notes):
        notes = str(notes)
        if not logger:
            print(notes)
        else:
            if log_level == "debug":
                logger.debug(notes)
            elif log_level == "info":
                logger.info(notes)
            elif log_level == "warning":
                logger.warning(notes)
            else:
                logger.error(notes)

    if comments:
        _dump_it(comments)
    if isinstance(msg, str):
        _dump_it(msg)
    elif isinstance(msg, (list, tuple, set)):
        for item in msg:
            _dump_it("  - {}".format(item))
    elif isinstance(msg, (dict, OrderedDict)):
        msg_keys = list(msg.keys())
        if isinstance(msg, dict):
            try:
                msg_keys.sort(key=str.lower)
            except (AttributeError, TypeError):
                msg_keys.sort()
        for key in msg_keys:
            value = msg.get(key)
            _dump_it("  - {:<21}: {}".format(key, value))
    else:
        _dump_it(msg)


class Voice(object):
    def __init__(self, logger=None):
        self.logger = logger

    def say_debug(self, msg, comments="", debug=None):
        say_it(msg, comments, show=debug, logger=self.logger, log_level="debug")

    def say_info(self, msg, comments=""):
        say_it(msg, comments, show=1, logger=self.logger, log_level="info")

    def say_warning(self, msg, comments=""):
        say_it(msg, comments, show=1, logger=self.logger, log_level="warning")

    def say_error(self, msg, comments=""):
        say_it(msg, comments, show=1, logger=self.logger, log_level="error")

    def say_traceback(self, comments=""):
        tb_msg = traceback.format_exc()
        chk_tb_msg = str(tb_msg)
        chk_tb_msg = chk_tb_msg.strip()
        if chk_tb_msg == "None":
            return
        self.say_error(tb_msg, comments)
