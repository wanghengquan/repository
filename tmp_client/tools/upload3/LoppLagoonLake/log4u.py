#!/usr/bin/python
# -*- coding: utf-8 -*-
import os
import traceback
import logging
import logging.handlers as hand
from .tools import wrap_md

__author__ = 'Shawn Yan'
__date__ = '15:46 2018/8/13'

LOGGER_NAME = "La Isla Bonita"

_format_dict = {
    0: '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    1: '%(asctime)s - %(levelname)s - %(message)s',
    2: '%(asctime)s - %(levelname)s - %(message)s',
    3: '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    4: '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
}
_date_dict = {
    0: "[%d/%b/%Y %H:%M:%S]",
    1: "%Y-%m-%d_%H:%M:%S",
    2: "%Y-%m-%d_%H-%M-%S",
}


class Logger4U(object):
    def __init__(self, log_file="", size1_time0=1, backup_count=20):
        self.log_file = log_file
        self.size1_time0 = size1_time0
        self.backup_count = backup_count
        logging.basicConfig(format=_format_dict[1], datefmt=_date_dict[0])
        self.logger = logging.getLogger(LOGGER_NAME)

    def set_logger(self):
        self.logger.setLevel(logging.DEBUG)
        self.handler = None
        if self.log_file:
            self.log_file = os.path.abspath(self.log_file)
            log_dir = os.path.dirname(self.log_file)
            if wrap_md(log_dir, "Log Folder"):
                return 1
            if self.size1_time0:  # SIZE, default is 1 M
                self.handler = hand.RotatingFileHandler(self.log_file, maxBytes=1000000, backupCount=self.backup_count)
            else:  # TIME, default by Day
                self.handler = hand.TimedRotatingFileHandler(self.log_file, when="D", interval=1, backupCount=self.backup_count)
            self.handler.setFormatter(logging.Formatter(fmt=_format_dict[2], datefmt=_date_dict[1]))
            self.logger.addHandler(self.handler)

    def remove_logger(self):
        if self.handler:
            self.logger.removeHandler(self.handler)


def get_logger():
    return logging.getLogger(LOGGER_NAME)


def create_self_logger(log_file):
    t = Logger4U(log_file)
    t.set_logger()
    return t.logger


def say_it(msg, comments="", show=1, log_key="Y_O_S_E_L_O_G", raw=True):
    """Wrapper of print
    """
    if not show:
        return
    try:
        log = open(os.getenv(log_key), "a")
    except (TypeError, IOError):
        log = ""

    def _dump_it(notes):
        notes = str(notes)
        if log:
            print(notes, file=log)
        print(notes)

    if comments:
        _dump_it(comments)
    if isinstance(msg, str):
        _dump_it(msg)
    elif isinstance(msg, list) or isinstance(msg, tuple) or isinstance(msg, set):
        for item in msg:
            _dump_it("  - %s" % str(item))
    elif isinstance(msg, dict):
        msg_keys = list(msg.keys())
        if not raw:  # for checking quickly
            try:
                msg_keys.sort(key=str.lower)
            except (AttributeError, TypeError):
                msg_keys.sort()
        for key in msg_keys:
            value = msg.get(key)
            _dump_it("  - %-20s: %s" % (str(key), str(value)))
    else:
        _dump_it(msg)
    if log:
        log.close()


def say_tb():
    say_it(traceback.format_exc())
