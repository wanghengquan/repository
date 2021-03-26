class ConfigIssue(Exception):
    def __init__(self, msg):
        super(Exception, self).__init__()
        self.msg = 'Config issue:' + msg


class FileNotExist(Exception):
    def __init__(self, filename):
        super(Exception, self).__init__()
        self.msg = 'file ' + filename + ' not found!'


class PatternNotFound(Exception):
    def __init__(self, pattern, detail):
        super(Exception, self).__init__()
        self.msg = pattern + ': ' + detail + ' not found!'


class CliIssue(Exception):
    def __init__(self, msg):
        super(Exception, self).__init__()
        self.msg = 'Command line issue:' + msg
