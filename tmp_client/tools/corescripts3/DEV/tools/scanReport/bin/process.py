PROCESS_IDLE = 0
PROCESS_RUNNING = 1
PROCESS_PASS = 2
PROCESS_FAIL = 3
Err = -1


class Descriptor:
    def __init__(self, process):
        self.p = process
        self.p.task_struct = self
        self.stack = []
        self.args = []
        self.status = PROCESS_IDLE
        self._next = self
        self._prev = self
        self.name = 'descriptor'

    def get_results(self):
        return self.stack

    def get_prev(self):
        return self._prev

    def get_next(self):
        return self._next


class Process:
    def __init__(self, name=None):
        self.task_struct = None
        self.name = name

    def out(self, ret):
        self.task_struct.stack.append(ret)

    def run(self):
        raise NotImplementedError


task_list_head = Descriptor(Process(None))


def add_process(process):
    global task_list_head
    p = Descriptor(process)
    p_last = task_list_head.get_prev()
    p_last._next = p
    p._next = None
    p._prev = p_last
    p.status = PROCESS_RUNNING
    task_list_head._prev = p


def sched():
    global task_list_head
    descriptor = task_list_head
    while descriptor.get_next():
        descriptor = descriptor.get_next()
        if descriptor.status == PROCESS_RUNNING:
            if descriptor.p.run() != Err:
                descriptor.status = PROCESS_PASS
            else:
                descriptor.status = PROCESS_FAIL


def for_each_process():
    global task_list_head
    descriptor = task_list_head
    while descriptor.get_next():
        descriptor = descriptor.get_next()
        yield descriptor


def clear_process():
    global task_list_head
    task_list_head = Descriptor(Process(None))
