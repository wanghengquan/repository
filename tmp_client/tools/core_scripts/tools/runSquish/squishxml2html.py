#!/usr/bin/env python
# -*- encoding=utf8 -*-
# Copyright (c) 2009-12 froglogic GmbH. All rights reserved.
# This file is part of an example program for Squish---it may be used,
# distributed, and modified, without limitation.

from __future__ import nested_scopes
from __future__ import generators
from __future__ import division

import codecs
import datetime
import optparse
import os
import random
import re
import shutil
import string
import subprocess
import sys
import tempfile
import time
import traceback
import xml.sax
import xml.sax.saxutils
if sys.platform.startswith("win"):
    import glob


def print_str(s, file_handle=sys.stdout):
    """
    Output s after encoding it with stdout encoding to
    avoid conversion errors with non ASCII characters)
    """
    if sys.__stdout__.encoding:
        print >>file_handle, s.encode(sys.__stdout__.encoding, 'replace')
    else:
        print >>file_handle, s.encode("utf-8")


if sys.version_info[0] != 2 or (
   sys.version_info[0] == 2 and sys.version_info[1] < 4):
    print_str("""%s: error: this program requires \
Python 2.4, 2.5, 2.6, or 2.7;
it cannot run with python %d.%d.
Try running it with the Python interpreter that ships with squish, e.g.:
C:\> C:\\squish\\squish-4.0.1-windows\\python\python.exe %s
""" % (os.path.basename(sys.argv[0]),
       sys.version_info[0], sys.version_info[1],
       os.path.basename(sys.argv[0])))
    sys.exit(1)


NEUTRAL_COLOR = u"#DCDCDC"  # gainsboro
PASS_COLOR = u"#f0fff0"     # honeydew
FAIL_COLOR = u"#FFB6C1"     # lightpink
ERROR_COLOR = u"#FA8072"    # salmon
LOG_COLOR = u"#DAA520"      # goldenrod
WARNING_COLOR = u"#FFA500"  # orange
FATAL_COLOR = u"#F08080"    # lightcoral
CASE_COLOR = u"#90ee90"     # lightgreen


INDEX_HTML_START = u"""\
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>Squish Report Results Summary</title></head>
<body><h3>Squish Report Results Summary</h3>
<p><b>Report generated %s</b></p>
<table border="0">
"""

SUBPAGE_HTML_START = u"""\
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>Screenshot Differences</title>
<script type="text/javascript">
function rot() {
  var imgs = document.getElementsByClassName("image");
  var currentRotState = parseInt(document.getElementById("currentRotState").value);
  currentRotState = (currentRotState + 1) % 4;
  document.getElementById("currentRotState").value = currentRotState;
  var newRot = currentRotState * 90;
  var sumWidth = 0;
  for (var i = 0; i < imgs.length; ++i) {
    imgs[i].style["-webkit-transform"] = "rotate(" + newRot + "deg)";
    imgs[i].style.MozTransform = "rotate(" + newRot + "deg)";
    var h = imgs[i].offsetHeight;
    var w = imgs[i].offsetWidth;
    if (currentRotState % 2 == 1) {
      var topIntOld = parseInt(imgs[i].style["top"]);
      var topIntNew = topIntOld + Math.round((w-h)/2);
      var topStrNew = "" + topIntNew + "px";
      imgs[i].style["top"] = topStrNew;
      var leftIntOld = parseInt(imgs[i].style["left"]);
      var leftIntNew = leftIntOld + Math.round((h-w)/2) - sumWidth;
      var leftStrNew = "" + leftIntNew + "px";
      imgs[i].style["left"] = leftStrNew;
    } else {
      var topIntOld = parseInt(imgs[i].style["top"]);
      var topIntNew = topIntOld - Math.round((w-h)/2);
      var topStrNew = "" + topIntNew + "px";
      imgs[i].style["top"] = topStrNew;
      var leftIntOld = parseInt(imgs[i].style["left"]);
      var leftIntNew = leftIntOld - Math.round((h-w)/2) + sumWidth;
      var leftStrNew = "" + leftIntNew + "px";
      imgs[i].style["left"] = leftStrNew;
    }
    sumWidth += (w-h);
  }
}
</script>
<body bgcolor="#dcdcdc" style="white-space: nowrap">
<button onclick="rot()">Rotate</button><input type="hidden" id="currentRotState" value="0" />
Differences/Expected Image/Actual Image<br />
"""

INDEX_HTML_END = u"</table></body></html>\n"

SUBPAGE_HTML_END = u"</body></html>\n"

INDEX_ITEM = u"""<tr valign="%(valign)s" bgcolor="%(color)s">\
<td>%(when)s</td><td align="right">%(passes)d/%(tests)d</td><td>\
<a href="%(url)s">%(name)s</a></td></tr>\n"""

SUMMARY_MARK = "SzUzMzMzAzRzY" * 2
SUMMARY_SIZE = 2000

REPORT_START = u"""\
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>%%(title)s</title></head>
<body><h2>%%(title)s</h2>
<h3>Summary</h3><table border="0">\n%s</table>
<h3>Results</h3><table border="0">\n""" % (
        SUMMARY_MARK + " " * SUMMARY_SIZE)

REPORT_END = u"</table></body></html>\n"

SUMMARY_ITEM = u"""<tr valign="%(valign)s" bgcolor="%(color)s">\
<td>%(name)s</td><td align="right">%(value)s</td><td>%(extra)s</td>\
</tr>\n"""

CASE_ITEM = u"""<tr valign="%%(valign)s" bgcolor="%s"><td>\
<b>%%(name)s</b></td><td colspan="4">%%(start)s</td></tr>\n""" % (
        CASE_COLOR)

VERIFICATION_ITEM = u"""<tr valign="%%(valign)s" bgcolor="%s">\
<td>%%(name)s</td><td colspan="4">%%(filename_and_line)s</td>\
</tr>\n""" % NEUTRAL_COLOR

SAXPARSEEXCEPTION_ITEM = u"""<tr valign="%%(valign)s" bgcolor="%s">\
<td></td><td colspan="2" bgcolor="%s">SAXParseException: %%(name)s</td>\
<td colspan="2" bgcolor="%s">%%(error_message)s</td>\
</tr>\n""" % (NEUTRAL_COLOR, FATAL_COLOR, FATAL_COLOR)

RESULT_ITEM = u"""<tr valign="%%(valign)s" bgcolor="%s"><td></td>\
<td bgcolor="%%(color)s">%%(type)s</td><td bgcolor="%%(color)s">\
%%(when)s</td><td bgcolor="%%(color)s">%%(description)s</td>\
<td bgcolor="%%(color)s">%%(detailed_description)s</td></tr>\n""" % (
        NEUTRAL_COLOR)

SUBPAGE_IMG_TPL = '<img class="image" src="%s" style="margin-left: 10px; position: relative; top: 0px; left: 0px;" alt="%s" />'

escape = None
datetime_from_string = None

class ReportError(Exception): pass

class SquishReportHandler(xml.sax.handler.ContentHandler, xml.sax.handler.ErrorHandler):

    def __init__(self, opts, fh, squishDir=None, tempDir=None):
        xml.sax.handler.ContentHandler.__init__(self)
        if opts.preserve:
            self.valign = "middle"
        else:
            self.valign = "top"
        self.preserve = opts.preserve
        self.fh = fh
        self.in_report = False
        self.in_suite = False
        self.in_case = False
        self.in_test = False
        self.suite_start = None
        self.suite_passes = 0
        self.suite_fails = 0
        self.suite_fatals = 0
        self.suite_errors = 0
        self.suite_expected_fails = 0
        self.suite_unexpected_passes = 0
        self.parse_error = False
        self.suite_tests = 0
        self.suite_cases = 0
        self.suite_url = None
        self.suite_name = None
        self.squishDir = squishDir
        self.tempDir = tempDir
        self.targetDir = opts.dir
        self.resetCaseMembers()

    def resetCaseMembers(self):
        self.in_result = False
        self.in_description = False
        self.in_detailed_description = False
        self.in_description_object = False
        self.in_description_failedImage = False
        self.in_description_file = False
        self.in_message = False
        self.case_name = None
        self.result_type = None
        self.result_time = None
        self.description = []
        self.detailed_description = []
        self.description_object = []
        self.description_failedImage = []
        self.description_file = []
        self.message_type = None
        self.message_time = None
        self.message = []
        self.currentAbsVpFile = None

    def writeParseError(self, name, exception):
        err = str(exception)
        self.fh.write(SAXPARSEEXCEPTION_ITEM % dict(valign=self.valign,
                    name=escape(name),
                    error_message=escape(err)))
        print_str(err)

    def warning(self, exception):
        self.writeParseError("Warning", exception)

    def error(self, exception):
        self.parse_error = True
        self.writeParseError("Error", exception)

    def fatalError(self, exception):
        self.parse_error = True
        self.writeParseError("Fatal error", exception)

    def startElement(self, name, attributes):
        if name == u"SquishReport":
            version = attributes.get(u"version").split(".")
            if not version or int(version[0]) < 2:
                raise ReportError("unrecognized Squish Report version; "
                        "try using squishrunner's xml2.1 report-generator")
            self.in_report = True
            return
        elif not self.in_report:
            raise ReportError("unrecognized XML file")
        if name == u"test":
            if not self.in_suite:
                self.suite_name = escape(attributes.get("name") or "Suite")
                self.fh.write(REPORT_START % dict(title=self.suite_name))
                self.in_suite = True
            else:
                if self.in_case:
                    raise ReportError("nested tests are not supported")
                self.resetCaseMembers()
                self.case_name = attributes.get("name" or "Test")
                self.suite_cases += 1
                self.in_case = True
        elif name == u"prolog":
            if self.in_case:
                self.fh.write(CASE_ITEM % dict(name=escape(self.case_name),
                        valign=self.valign, start=datetime_from_string(
                                attributes.get("time"))))
            elif self.in_suite:
                self.suite_start = datetime_from_string(
                        attributes.get("time"))
        elif name == u"epilog":
            # We ignore epilog times
            pass
        elif name == u"verification":
            line = attributes.get("line") or ""
            if line:
                line = "#" + line
            filename = attributes.get("file") or ""
            if filename:
                filename = os.path.normpath(filename)
            filename_and_line = filename + line
            vpName = attributes.get("name")
            self.currentAbsVpFile = findVpFile(filename, vpName)
            self.fh.write(VERIFICATION_ITEM % dict(valign=self.valign,
                    name=escape(attributes.get("name") or "TEST"),
                    filename_and_line=escape(filename_and_line)))
        elif name == u"result":
            self.result_type = attributes.get("type")
            self.result_time = datetime_from_string(attributes.get("time"))
            self.suite_tests += 1
            if self.result_type == u"PASS":
                self.suite_passes += 1
            elif self.result_type == u"FAIL":
                self.suite_fails += 1
            elif self.result_type == u"FATAL":
                self.suite_fatals += 1
            elif self.result_type == u"ERROR":
                self.suite_errors += 1
            elif self.result_type in (u"XPASS", u"UPASS"):
                self.suite_unexpected_passes += 1
            elif self.result_type == u"XFAIL":
                self.suite_expected_fails += 1
            self.in_result = True
        elif name == u"description":
            if not (self.in_result or self.in_message):
                raise ReportError("misplaced description")
            self.in_description = False
            self.in_detailed_description = False
            self.in_description_object = False
            self.in_description_failedImage = False
            self.in_description_file = False
            type = attributes.get("type")
            if not type:
                self.in_description = True
            elif type == u"DETAILED":
                self.in_detailed_description = True
            elif type == u"object":
                self.in_description_object = True
            elif type == u"failedImage":
                self.in_description_failedImage = True
            elif type == u"file":
                self.in_description_file = True
            else:
                self.in_description = True
        elif name == u"message":
            self.message_type = attributes.get("type")
            if self.message_type == u"FATAL":
                self.suite_fatals += 1
            elif self.message_type == u"ERROR":
                self.suite_errors += 1
            self.message_time = datetime_from_string(
                    attributes.get("time"))
            self.in_message = True


    def characters(self, text):
        if self.in_message and not (self.in_description or self.in_detailed_description or self.in_description_object or self.in_description_failedImage or self.in_description_file):
            self.message.append(text)
        elif self.in_description:
            self.description.append(text)
        elif self.in_detailed_description:
            self.detailed_description.append(text)
        elif self.in_description_object:
            self.description_object.append(text)
        elif self.in_description_failedImage:
            self.description_failedImage.append(text)
        elif self.in_description_file:
            self.description_file.append(text)


    def endElement(self, name):
        if name == u"SquishReport":
            self.fh.write(REPORT_END)
        elif name == u"test":
            if self.in_test:
                self.in_test = False
            elif self.in_case:
                self.in_case = False
        elif name == u"prolog":
            pass
        elif name == u"epilog":
            # We ignore epilog times
            pass
        elif name == u"verification":
            self.currentAbsVpFile = None
        elif name == u"result":
            color = FAIL_COLOR
            if self.result_type in (u"PASS", u"XFAIL"):
                color = PASS_COLOR
            elif self.result_type == u"ERROR":
                color = ERROR_COLOR
            elif self.result_type == u"LOG":
                color = LOG_COLOR
            detailed_description = escape_and_handle_image(
                    "".join(self.detailed_description), self.preserve, self.currentAbsVpFile, "".join(self.description_object), self.squishDir, self.targetDir, self.tempDir)
            description = escape_and_handle_image(
                    "".join(self.description), self.preserve, self.currentAbsVpFile, "".join(self.description_object), self.squishDir, self.targetDir, self.tempDir)
            self.fh.write(RESULT_ITEM % dict(color=color,
                    type=self.result_type, when=self.result_time,
                    description=description,
                    detailed_description=detailed_description,
                    valign=self.valign))
            self.result_type = None
            self.result_time = None
            self.description = []
            self.detailed_description = []
            self.description_object = []
            self.description_failedImage = []
            self.description_file = []
            self.in_result = False
        elif name == u"description":
            if self.in_detailed_description:
                self.in_detailed_description = False
            elif self.in_description_object:
                self.in_description_object = False
            elif self.in_description_failedImage:
                self.in_description_failedImage = False
            elif self.in_description_file:
                self.in_description_file = False
            elif self.in_description:
                self.in_description = False
        elif name == u"message":
            color = LOG_COLOR
            if self.message_type == u"WARNING":
                color = WARNING_COLOR
            if self.message_type == u"ERROR":
                color = ERROR_COLOR
            elif self.message_type == u"FATAL":
                color = FATAL_COLOR
            msg = self.message
            detail_msg = ""
            if (len("".join(self.message).strip()) == 0 and
                len(self.description) > 0):
                msg = self.description
                detail_msg = self.detailed_description
                self.description = []
                self.detailed_description = []
                self.description_object = []
                self.description_failedImage = []
                self.description_file = []
            msg = escape_and_handle_image("".join(msg), self.preserve, subFilesDir=self.targetDir)
            detail_msg = escape_and_handle_image("".join(detail_msg),
                    self.preserve, subFilesDir=self.targetDir)
            self.fh.write(RESULT_ITEM % dict(color=color,
                    type=self.message_type, when=self.message_time,
                    description=msg,
                    detailed_description=detail_msg,
                    valign=self.valign))
            self.message = []
            self.in_message = False


def getExpectedImage(absVpFile, squishDir, tempDir):
    convertVp = os.path.join(os.path.join(squishDir, "bin"), "convertvp")
    # XXX assumes usage of --resultdir switch to squishrunner
    subprocess.call([convertVp, "--fromvp", absVpFile, tempDir])
    return os.path.join(tempDir, "img_1.png") # XXX limitation of convertvp.

def getDiffedImage(absVpFile, widgetName, actualImage, squishDir, tempDir):
    vpdiff = os.path.join(os.path.join(squishDir, "bin"), "vpdiff")
    targetFile = os.path.join(tempDir, randomFilename()) + ".png"
    cmd = [vpdiff, absVpFile, widgetName, actualImage, targetFile, "--highlights"]
    subprocess.call(cmd)
    return os.path.join(targetFile)

def randomFilename():
    return ''.join([random.choice(string.letters+string.digits) for i in range(8)])

def packageImage(absPathToImage, targetDir):
    (root, ext) = os.path.splitext(absPathToImage)
    fileName = randomFilename() + ext
    targetFile = os.path.join(targetDir, fileName)
    try:
        shutil.copy(absPathToImage, targetFile)
    except IOError as e:
        print_str(str(e), sys.stderr)
    return fileName

def escape_and_handle_image(description, preserve, absVpFile=None, widgetName=None, squishDir=None, subFilesDir=None, tempDir=None):
    match = re.search(ur"""saved\s+as\s+['"](?P<image>[^'"]+)['"]""",
            description, re.IGNORECASE)
    if match:
        before = escape(description[:match.start()])
        actualImage = match.group("image")
        actImage = packageImage(actualImage, subFilesDir)

        after = escape(description[match.end():])
        if absVpFile is not None and squishDir is not None and subFilesDir is not None and tempDir is not None:
            expectedImage = getExpectedImage(absVpFile, squishDir, tempDir)
            diffedImage = getDiffedImage(absVpFile, widgetName, actualImage, squishDir, tempDir)
            expImage = packageImage(expectedImage, subFilesDir)
            dffImage = packageImage(diffedImage, subFilesDir)

            imgPageName = "%s.html" % (randomFilename(), )
            imgPageFile = open(os.path.join(subFilesDir, imgPageName), 'w')
            imgPageFile.write(SUBPAGE_HTML_START)
            imgPageFile.write(SUBPAGE_IMG_TPL % (dffImage, "Diff View"))
            imgPageFile.write(SUBPAGE_IMG_TPL % (expImage, "Expected Image"))
            imgPageFile.write(SUBPAGE_IMG_TPL % (actImage, "Actual Image"))
            imgPageFile.write(SUBPAGE_HTML_END)
            imgPageFile.close()

            description = '%s <a href="%s">View</a> %s' % (
                before, imgPageName, after)
        else:
            description = '%s <a href="./%s">%s</a> %s' % (
                before, actImage, actImage, after)

    else:
        # the logscreenshotOnFail/Error case
        match = re.search(
                ur"""screenshot\s+in\s+['"](?P<image>[^'"]+)['"]""",
                description, re.IGNORECASE)
        if match is not None:
            description = escape(description, True)
            before = escape(description[:match.start()])
            actualImage = match.group("image")
            actImage = packageImage(actualImage, subFilesDir)
            after = escape(description[match.end():])
            description = '%s<a href="./%s">Screenshot</a>%s' % (
                    before, actImage, after)
        else:
            description = escape(description)
    if preserve:
        description = "<pre>%s</pre>" % description

    return description


def findVpFile(scriptFile, vpName):
    if not vpName:
        return None
    guess = os.path.join(os.path.join(os.path.dirname(scriptFile), "verificationPoints"), vpName)
    if os.path.exists(guess):
        return guess
    guess = os.path.join(os.path.join(os.path.join(os.path.dirname(os.path.dirname(scriptFile)), "shared"), "verificationPoints"), vpName)
    if os.path.exists(guess):
        return guess
    guess = os.path.join(os.path.join(os.path.dirname(os.path.dirname(scriptFile)), "verificationPoints"), vpName)
    if os.path.exists(guess):
        return guess

    print_str("VpFile not found: (scriptFile=%s, vpName=%s)" % (scriptFile, vpName), sys.stderr)
    return None


def process_suite(opts, filename, index_fh=None):
    tempDir = tempfile.mkdtemp()
    extension = os.path.splitext(filename)[1]
    html_file = os.path.abspath(os.path.join(opts.dir,
            os.path.basename(filename.replace(extension, ".html"))))
    if opts.preserve:
        valign = "middle"
    else:
        valign = "top"
    fh = None

    squishDir = opts.squishdir
    if squishDir is None:
        pass
    elif not os.path.exists(squishDir):
        print_str("Given Squish directory doesn't exists. Ignoring it.", sys.stderr)
        squishDir = None
    elif not os.path.exists(os.path.join(squishDir, "bin")):
        print_str("Given Squish directory is not a valid Squish directory. It lacks the 'bin' subdirectory. Ignoring it.", sys.stderr)
        squishDir = None
    elif not os.path.exists(os.path.join(os.path.join(squishDir, "bin"), "convertvp")):
        print_str("Given Squish directory is not a valid Squish directory. It lacks 'bin/convertvp' utility. Ignoring it.", sys.stderr)
        squishDir = None

    try:
        try:
            fh = codecs.open(html_file, "w", encoding="utf-8")
            reporter = SquishReportHandler(opts, fh, squishDir, tempDir)
            parser = xml.sax.make_parser()
            parser.setContentHandler(reporter)
            parser.setErrorHandler(reporter)
            parser.parse(filename)
            write_summary_entry(valign, reporter, html_file)
            if index_fh is not None:
                write_index_entry(valign, index_fh, reporter,
                                  os.path.basename(html_file))
            if opts.verbose:
                print_str("wrote '%s'" % html_file)
        
        except (EnvironmentError, ValueError, ReportError,
                xml.sax.SAXParseException), err:
            traceback.print_exc()
            
    finally:
        if fh is not None:
            fh.close()
    shutil.rmtree(tempDir)


def write_summary_entry(valign, reporter, html_file):
    summary = []
    color = NEUTRAL_COLOR
    summary.append(SUMMARY_ITEM % dict(color=color, name="Test Cases",
            value=reporter.suite_cases, extra="", valign=valign))
    summary.append(SUMMARY_ITEM % dict(color=color, name="Tests",
            value=reporter.suite_tests, extra="", valign=valign))
    extra = ""
    if reporter.suite_expected_fails != 0:
        extra = " plus %d expected fails" % reporter.suite_expected_fails
    summary.append(SUMMARY_ITEM % dict(color=color, name="Passes",
            value=reporter.suite_passes, extra=extra, valign=valign))
    extra = ""
    if reporter.suite_unexpected_passes != 0:
        extra = " plus %d unexpected passes" % (
                reporter.suite_unexpected_passes)
    color = FAIL_COLOR
    if reporter.suite_fails == 0:
        color = NEUTRAL_COLOR
    summary.append(SUMMARY_ITEM % dict(color=color, name="Fails",
            value=reporter.suite_fails, extra=extra, valign=valign))
    color = ERROR_COLOR
    if reporter.suite_errors == 0:
        color = NEUTRAL_COLOR
    summary.append(SUMMARY_ITEM % dict(color=color, name="Errors",
            value=reporter.suite_errors, extra="", valign=valign))
    color = FATAL_COLOR
    if reporter.suite_fatals == 0:
        color = NEUTRAL_COLOR
    summary.append(SUMMARY_ITEM % dict(color=color, name="Fatals",
            value=reporter.suite_fatals, extra="", valign=valign))
    summary = u"".join(summary)
    summary = summary.encode("utf8")
    if len(summary) > SUMMARY_SIZE + len(SUMMARY_MARK):
        print_str("internal error: summary too big to write---try doubling SUMMARY_SIZE", sys.stderr)
        return

    fh = None
    try:
        fh = open(html_file, "r+b")
        data = fh.read(8000 + SUMMARY_SIZE)
        i = data.find(SUMMARY_MARK)
        if i == -1:
            print_str("internal error: failed to write summary", sys.stderr)
        else:
            fh.seek(i)
            fh.write(summary)
    finally:
        if fh is not None:
            fh.close()


def write_index_entry(valign, index_fh, reporter, html_file):
    color = FAIL_COLOR
    if ((reporter.suite_tests ==
        reporter.suite_passes + reporter.suite_expected_fails) and
        not reporter.suite_errors and not reporter.suite_fatals and
        not reporter.parse_error):
        color = PASS_COLOR
    index_fh.write(INDEX_ITEM % dict(color=color, valign=valign,
            when=reporter.suite_start, passes=reporter.suite_passes,
            tests=reporter.suite_tests, url=html_file,
            name=reporter.suite_name))


def parse_options():
    parser = optparse.OptionParser(usage="""\
usage: %prog [-h|--help|-d|--dir|--squish|...] [results1.xml [results2.log [...]]]

If only one file is specified and no directory is specified the file is
converted to HTML and output to the current working directory; verbose
is not supported in this case. If multiple files are specified they are
converted to HTML in files of the same name but with a suffix of
.html---they are put in the current working directory unless a directory
is specified. If multiple files are specified an index.html file is also
output that has links to each results file.

All referenced images from the Test Results are placed into the target
directory as well.

If the --squish option is given, the expected images from failed screenshot
VPs are extracted and stored in the target directory and displayed in the
generated report next to the failed images.""")
    parser.add_option("-d", "--dir", dest="dir",
            help="output directory [default: .]")
    parser.add_option("-i", "--iso", dest="iso",
            action="store_true",
            help="use ISO date/time format [default: off]")
    parser.add_option("-p", "--preserve", dest="preserve",
            action="store_true",
            help="preserve message formatting [default: off]")
    parser.add_option("-s", "--squishdir", dest="squishdir",
                      help="path to Squish installation")
    parser.add_option("-v", "--verbose", dest="verbose",
            action="store_true",
            help="list each file as it is output [default: off]")
    parser.set_defaults(iso=False, preserve=False, verbose=False, squish=None)
    opts, args = parser.parse_args()
    if len(args) < 1:
        parser.error("no files have been specified")
    args = [x for x in args if x.lower().endswith(".log") or
                               x.lower().endswith(".xml")]
    if not args:
        parser.error("no .log or .xml files have been specified")
    return opts, args


def create_functions(opts):
    global escape
    if not opts.preserve:
        def function(s, is_multiline=False):
            return (xml.sax.saxutils.escape(s).strip().
                replace("\\n", "\n").replace("\n", "<br/>"))
    else:
        def function(s, is_multiline=False):
            if is_multiline:
                return "<pre>%s</pre>" % (
                        xml.sax.saxutils.escape(s).replace("\\n",
                                                           "\n").strip())
            else:
                return xml.sax.saxutils.escape(s).replace("\\n",
                                                          "\n").strip()
    escape = function

    global datetime_from_string
    if not opts.iso:
        # Sadly, Python doesn't properly support time zones out of the box
        def function(s):
            if s is None:
                return ""
            return time.asctime(time.strptime(s[:19],
                    "%Y-%m-%dT%H:%M:%S")).replace(" ", "&nbsp;")
    else:
        def function(s):
            if s is None:
                return ""
            return s
    datetime_from_string = function


def main():
    opts, args = parse_options()
    if sys.platform.startswith("win"):
        temp = []
        for arg in args:
            temp.extend(glob.glob(arg))
        args = temp
    create_functions(opts)
    if not opts.dir:
        opts.dir = "."
    if len(args) == 1 and not opts.dir:
        opts.verbose = False
        process_suite(opts, args[0])
    else:
        if not os.path.exists(opts.dir):
            os.makedirs(opts.dir)
        index_file = os.path.abspath(os.path.join(opts.dir, "index.html"))
        fh = None
        try:
            fh = codecs.open(index_file, "w", encoding="utf-8")
            if opts.iso:
                when = datetime.date.today().isoformat()
            else:
                when = datetime.date.today().strftime("%x")
            fh.write(INDEX_HTML_START % when)
            for filename in args:
                process_suite(opts, filename, fh)
            fh.write(INDEX_HTML_END)
            if opts.verbose:
                print_str("wrote '%s'" % index_file)
        except:
            traceback.print_exc()
        if fh is not None:
            fh.close()


main()
