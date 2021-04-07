#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 4:14 PM 3/31/2020
  file: run_lines.py
  author: Shawn Yan
Description:

"""
import logging
import os
import sys
import re
import threading
import time
import platform
import argparse
from multiprocessing.dummy import Pool as ThreadPool

try:
    import warnings
except ImportError:
    warnings = None

try:
    import msvcrt
except ImportError:
    msvcrt = None

try:
    import fcntl
except ImportError:
    fcntl = None


# Backward compatibility
# ------------------------------------------------
try:
    TimeoutError
except NameError:
    TimeoutError = OSError


# Data
# ------------------------------------------------
__all__ = [
    "Timeout",
    "BaseFileLock",
    "WindowsFileLock",
    "UnixFileLock",
    "SoftFileLock",
    "FileLock"
]

__version__ = "3.0.12"


_logger = None
def logger():
    """Returns the logger instance used in this module."""
    global _logger
    _logger = _logger or logging.getLogger(__name__)
    return _logger


# Exceptions
# ------------------------------------------------
class Timeout(TimeoutError):
    """
    Raised when the lock could not be acquired in *timeout*
    seconds.
    """

    def __init__(self, lock_file):
        """
        """
        #: The path of the file lock.
        self.lock_file = lock_file
        return None

    def __str__(self):
        temp = "The file lock '{}' could not be acquired."\
               .format(self.lock_file)
        return temp


# Classes
# ------------------------------------------------

# This is a helper class which is returned by :meth:`BaseFileLock.acquire`
# and wraps the lock to make sure __enter__ is not called twice when entering
# the with statement.
# If we would simply return *self*, the lock would be acquired again
# in the *__enter__* method of the BaseFileLock, but not released again
# automatically.
#
# :seealso: issue #37 (memory leak)
class _Acquire_ReturnProxy(object):

    def __init__(self, lock):
        self.lock = lock
        return None

    def __enter__(self):
        return self.lock

    def __exit__(self, exc_type, exc_value, traceback):
        self.lock.release()
        return None


class BaseFileLock(object):
    """
    Implements the base class of a file lock.
    """

    def __init__(self, lock_file, timeout = -1):
        """
        """
        # The path to the lock file.
        self._lock_file = lock_file

        # The file descriptor for the *_lock_file* as it is returned by the
        # os.open() function.
        # This file lock is only NOT None, if the object currently holds the
        # lock.
        self._lock_file_fd = None

        # The default timeout value.
        self.timeout = timeout

        # We use this lock primarily for the lock counter.
        self._thread_lock = threading.Lock()

        # The lock counter is used for implementing the nested locking
        # mechanism. Whenever the lock is acquired, the counter is increased and
        # the lock is only released, when this value is 0 again.
        self._lock_counter = 0
        return None

    @property
    def lock_file(self):
        """
        The path to the lock file.
        """
        return self._lock_file

    @property
    def timeout(self):
        """
        You can set a default timeout for the filelock. It will be used as
        fallback value in the acquire method, if no timeout value (*None*) is
        given.

        If you want to disable the timeout, set it to a negative value.

        A timeout of 0 means, that there is exactly one attempt to acquire the
        file lock.

        .. versionadded:: 2.0.0
        """
        return self._timeout

    @timeout.setter
    def timeout(self, value):
        """
        """
        self._timeout = float(value)
        return None

    # Platform dependent locking
    # --------------------------------------------

    def _acquire(self):
        """
        Platform dependent. If the file lock could be
        acquired, self._lock_file_fd holds the file descriptor
        of the lock file.
        """
        raise NotImplementedError()

    def _release(self):
        """
        Releases the lock and sets self._lock_file_fd to None.
        """
        raise NotImplementedError()

    # Platform independent methods
    # --------------------------------------------

    @property
    def is_locked(self):
        """
        True, if the object holds the file lock.

        .. versionchanged:: 2.0.0

            This was previously a method and is now a property.
        """
        return self._lock_file_fd is not None

    def acquire(self, timeout=None, poll_intervall=0.05):
        """
        Acquires the file lock or fails with a :exc:`Timeout` error.

        .. code-block:: python

            # You can use this method in the context manager (recommended)
            with lock.acquire():
                pass

            # Or use an equivalent try-finally construct:
            lock.acquire()
            try:
                pass
            finally:
                lock.release()

        :arg float timeout:
            The maximum time waited for the file lock.
            If ``timeout < 0``, there is no timeout and this method will
            block until the lock could be acquired.
            If ``timeout`` is None, the default :attr:`~timeout` is used.

        :arg float poll_intervall:
            We check once in *poll_intervall* seconds if we can acquire the
            file lock.

        :raises Timeout:
            if the lock could not be acquired in *timeout* seconds.

        .. versionchanged:: 2.0.0

            This method returns now a *proxy* object instead of *self*,
            so that it can be used in a with statement without side effects.
        """
        # Use the default timeout, if no timeout is provided.
        if timeout is None:
            timeout = self.timeout

        # Increment the number right at the beginning.
        # We can still undo it, if something fails.
        with self._thread_lock:
            self._lock_counter += 1

        lock_id = id(self)
        lock_filename = self._lock_file
        start_time = time.time()
        try:
            while True:
                with self._thread_lock:
                    if not self.is_locked:
                        logger().debug('Attempting to acquire lock %s on %s', lock_id, lock_filename)
                        self._acquire()

                if self.is_locked:
                    logger().info('Lock %s acquired on %s', lock_id, lock_filename)
                    break
                elif timeout >= 0 and time.time() - start_time > timeout:
                    logger().debug('Timeout on acquiring lock %s on %s', lock_id, lock_filename)
                    raise Timeout(self._lock_file)
                else:
                    logger().debug(
                        'Lock %s not acquired on %s, waiting %s seconds ...',
                        lock_id, lock_filename, poll_intervall
                    )
                    time.sleep(poll_intervall)
        except:
            # Something did go wrong, so decrement the counter.
            with self._thread_lock:
                self._lock_counter = max(0, self._lock_counter - 1)

            raise
        return _Acquire_ReturnProxy(lock = self)

    def release(self, force = False):
        """
        Releases the file lock.

        Please note, that the lock is only completly released, if the lock
        counter is 0.

        Also note, that the lock file itself is not automatically deleted.

        :arg bool force:
            If true, the lock counter is ignored and the lock is released in
            every case.
        """
        with self._thread_lock:

            if self.is_locked:
                self._lock_counter -= 1

                if self._lock_counter == 0 or force:
                    lock_id = id(self)
                    lock_filename = self._lock_file

                    logger().debug('Attempting to release lock %s on %s', lock_id, lock_filename)
                    self._release()
                    self._lock_counter = 0
                    logger().info('Lock %s released on %s', lock_id, lock_filename)

        return None

    def __enter__(self):
        self.acquire()
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self.release()
        return None

    def __del__(self):
        self.release(force = True)
        return None


# Windows locking mechanism
# ~~~~~~~~~~~~~~~~~~~~~~~~~

class WindowsFileLock(BaseFileLock):
    """
    Uses the :func:`msvcrt.locking` function to hard lock the lock file on
    windows systems.
    """

    def _acquire(self):
        open_mode = os.O_RDWR | os.O_CREAT | os.O_TRUNC

        try:
            fd = os.open(self._lock_file, open_mode)
        except OSError:
            pass
        else:
            try:
                msvcrt.locking(fd, msvcrt.LK_NBLCK, 1)
            except (IOError, OSError):
                os.close(fd)
            else:
                self._lock_file_fd = fd
        return None

    def _release(self):
        fd = self._lock_file_fd
        self._lock_file_fd = None
        msvcrt.locking(fd, msvcrt.LK_UNLCK, 1)
        os.close(fd)

        try:
            os.remove(self._lock_file)
        # Probably another instance of the application
        # that acquired the file lock.
        except OSError:
            pass
        return None

# Unix locking mechanism
# ~~~~~~~~~~~~~~~~~~~~~~

class UnixFileLock(BaseFileLock):
    """
    Uses the :func:`fcntl.flock` to hard lock the lock file on unix systems.
    """

    def _acquire(self):
        open_mode = os.O_RDWR | os.O_CREAT | os.O_TRUNC
        fd = os.open(self._lock_file, open_mode)

        try:
            fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except (IOError, OSError):
            os.close(fd)
        else:
            self._lock_file_fd = fd
        return None

    def _release(self):
        # Do not remove the lockfile:
        #
        #   https://github.com/benediktschmitt/py-filelock/issues/31
        #   https://stackoverflow.com/questions/17708885/flock-removing-locked-file-without-race-condition
        fd = self._lock_file_fd
        self._lock_file_fd = None
        fcntl.flock(fd, fcntl.LOCK_UN)
        os.close(fd)
        return None

# Soft lock
# ~~~~~~~~~

class SoftFileLock(BaseFileLock):
    """
    Simply watches the existence of the lock file.
    """

    def _acquire(self):
        open_mode = os.O_WRONLY | os.O_CREAT | os.O_EXCL | os.O_TRUNC
        try:
            fd = os.open(self._lock_file, open_mode)
        except (IOError, OSError):
            pass
        else:
            self._lock_file_fd = fd
        return None

    def _release(self):
        os.close(self._lock_file_fd)
        self._lock_file_fd = None

        try:
            os.remove(self._lock_file)
        # The file is already deleted and that's what we want.
        except OSError:
            pass
        return None


# Platform filelock
# ~~~~~~~~~~~~~~~~~

#: Alias for the lock, which should be used for the current platform. On
#: Windows, this is an alias for :class:`WindowsFileLock`, on Unix for
#: :class:`UnixFileLock` and otherwise for :class:`SoftFileLock`.
FileLock = None

if msvcrt:
    FileLock = WindowsFileLock
elif fcntl:
    FileLock = UnixFileLock
else:
    FileLock = SoftFileLock

    if warnings is not None:
        warnings.warn("only soft file lock is available")


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# MY CODE
def get_pc_os_name():
    """Get PC name and OS name
    original data:
      ('Linux', 'lsh-tmp.latticesemi.com', '3.10.0-123.el7.x86_64', '#1 SMP Mon May 5 11:16:57 EDT 2014', ...)
      ('redhat', '7.7', '...')

      ('Linux', 'LAB0007', '4.15.0-42-generic', '#45~16.04.1-Ubuntu SMP Mon Nov 19 13:02:27 UTC 2018', ...)
      ('debian', 'stretch/sid', '')

      ('Windows', 'LD0078', '10', '10.0.18362', 'AMD64', 'Intel64 Family 6 Model 158 Stepping 10, GenuineIntel')
      ('', '', '')
    """
    _un = platform.uname()
    _di = platform.dist()
    pc_name = re.split(r"\.", _un[1])[0]
    os_name = _di[0]
    if _un[0] == "Windows":
        os_name = "{0}{2}".format(*_un)
    else:
        if _di[0] == "redhat":
            os_name = "{0}{1}".format(*_di)
        elif _di[0] == "debian":
            x = "Ubuntu"
            if x in _un[3]:
                os_name = x
    return pc_name, os_name


def safe_run_function(func, args=None, kw=None, func_lock_file=None):
    """Run function with safety locker
    """
    if not args:
        args = list()
    if not kw:
        kw = dict()
    if not func_lock_file:
        func_lock_file = "{}.lock".format(func.__name__)
    file_locker = FileLock(func_lock_file, timeout=10)
    with file_locker:
        return func(*args, **kw)


def get_status_output(cmd):
    """return (status, output) of executing cmd in a shell.
    source from commands.py <def getstatusoutput(cmd)>.
    """
    on_win = (sys.platform[:3] == "win")
    if not on_win:
        cmd = "{ " + cmd + "; }"
    pipe = os.popen(cmd + " 2>&1", "r")
    text = pipe.read()
    sts = pipe.close()
    return sts, text


def single_space(raw_string):
    return re.sub(r"\s+", " ", raw_string)


class RunLines(object):
    def __init__(self):
        self.on_windows = sys.platform.startswith("win32")
        self.default_fext = ".lines"
        self.stop_folder = "stop_running_batch_flow"
        self.p_skip = re.compile("^(rem|#)")
        self.elapsed_time_file = "ElapsedTime.csv"
        self.machine = "_".join(get_pc_os_name())
        self.done_template = "<{:15}>{} ::: {}"
        self.p_cmd = re.compile(r":::\s+(.+)")

    def run(self):
        self.get_options()
        print("start running batch command lines ...")
        if self.stop:
            print("Try to create stop tag directory...")
            if not os.path.isdir(self.stop_folder):
                os.mkdir(self.stop_folder)
            print("done.")
        else:
            if os.path.isdir(self.stop_folder):
                os.rmdir(self.stop_folder)
            self.this_run()

    def get_options(self):
        parser = argparse.ArgumentParser()
        parser.add_argument("-p", "--process", type=int, choices=list(range(2, 10)), help="specify process number")
        parser.add_argument("--run321", action="store_true", help="run command in reversed order")
        parser.add_argument("--do-file", nargs="+", help="specify batch file(s)")
        parser.add_argument("--do-fext", help="specify batch file extension, default is {}".format(self.default_fext))
        parser.add_argument("--stop", action="store_true", help="try to stop running flow")
        parser.add_argument("--silent", action="store_true", help="run command silently")
        parser.set_defaults(do_fext=self.default_fext)
        opts = parser.parse_args()
        self.process = opts.process
        self.run321 = opts.run321
        self.do_file = opts.do_file
        self.do_fext = opts.do_fext
        self.stop = opts.stop
        self.silent = opts.silent
        if self.process:
            if not self.on_windows:
                self.silent = True

    def single_run(self, reserved=None):
        while True:
            if os.path.isdir(self.stop_folder):
                print("Find stop tag and exit")
                break
            new_command = safe_run_function(self.get_new_command)
            if not new_command:
                break  # all flows are done.
            print(("running {}".format(new_command)))
            start_time = time.time()
            if self.silent:
                sts, text = get_status_output(new_command)
            else:
                sts = os.system(new_command)
            sts = "Failed" if sts else "Passed"
            elapsed_time = time.time() - start_time
            safe_run_function(self.record_elapsed_time, args=(elapsed_time, new_command, sts))
        t = eval(input("exit manually..."))

    def record_elapsed_time(self, elapsed_time, command, sts):
        with open(self.elapsed_time_file, "a") as ob:
            print("{}, {}, {:.2f}, {}".format(sts, self.machine, elapsed_time, command), file=ob)

    def this_run(self):
        if self.process:
            if self.silent:
                pool = ThreadPool(self.process)
                pool.map(self.single_run, list(range(self.process)))
                pool.close()
                pool.join()
            else:  # on Windows
                open_new_console_and_run = "start {} {}".format(sys.executable, __file__)
                if self.run321:
                    open_new_console_and_run += " --run321"
                if self.do_file:
                    open_new_console_and_run += " --do-file {}".format(" ".join(self.do_file))
                elif self.do_fext:
                    open_new_console_and_run += " --do-fext {}".format(self.do_fext)
                if self.silent:
                    open_new_console_and_run += " --silent"
                for i in range(self.process):
                    os.system(open_new_console_and_run)
        else:
            self.single_run()

    def get_new_command(self):
        self.batch_files = list()
        if self.do_file:
            for cm in self.do_file:
                if os.path.isfile(cm):
                    self.batch_files.append(cm)
        else:
            for foo in os.listdir("."):
                if foo.endswith(self.do_fext):
                    self.batch_files.append(foo)
        if not self.batch_files:
            return
        self.batch_files.sort(key=str.lower)

        if self.run321:
            my_file = self.batch_files[-1]
        else:
            my_file = self.batch_files[0]

        done_file = os.path.splitext(my_file)[0] + ".done"
        original_lines = self.__get_original_lines(my_file)
        done_lines = self.__get_done_lines(done_file)
        new_lines = set(original_lines) - set(done_lines)
        if not new_lines:
            fine_file = my_file + ".fine"
            if os.path.isfile(fine_file):
                os.remove(fine_file)
            os.rename(my_file, my_file + ".fine")
        else:
            if self.run321:
                original_lines.reverse()
            for item in original_lines:
                if item in new_lines:
                    with open(done_file, "a") as ob:
                        print(self.done_template.format(self.machine, time.ctime(), item), file=ob)
                    return item

    def __get_original_lines(self, original_file):
        original_lines = list()
        with open(original_file) as ob:
            for line in ob:
                line = line.strip()
                if not line:
                    continue
                if self.p_skip.search(line):
                    continue
                original_lines.append(single_space(line))
        return original_lines

    def __get_done_lines(self, done_file):
        done_lines = list()
        if os.path.isfile(done_file):
            with open(done_file) as ob:
                for line in ob:
                    line = line.strip()
                    m = self.p_cmd.search(line)
                    if m:
                        done_lines.append(single_space(m.group(1)))
        return done_lines


if __name__ == "__main__":
    p = RunLines()
    p.run()
