import os
import re
import optparse
import time
import inspect

from win32com.client import Dispatch

def get_this_file():
    this_file = inspect.getfile(inspect.currentframe())
    return os.path.abspath(this_file)

this_dir = os.path.dirname(get_this_file())

def wrap_check(a_file, a_error):
    if not a_file:
        print(("Error. Not specify %s" % a_error))
        return 1
    a_file = os.path.abspath(a_file)
    if not os.path.isfile(a_file):
        print("Error. not found %s: %s" % (a_error, a_file))
        return 1
class MergeExcelReportFile:
    def __init__(self):
        self.tag_name = time.strftime("%B_%d_%Y")
    def process(self):
        self.get_options()
        if self.check_options():
            return 1
        self.run_it()
    def run_it(self):
        wb = Dispatch('Excel.Application')
        wb.Visible = 1
        excel = wb.Workbooks.Open(self.macro_file)
        macro_cmd_line = ""
        macro_cmd_line += "%s!%s(" % (excel.Name, self.macro_name)
        for item in (self.use_sheet, self.combine):
            if item:
                macro_cmd_line += "True, "
            else:
                macro_cmd_line += "False, "
        macro_cmd_line += '"%s", "%s", "%s")' % (self.list_file, self.log_file, self.rpt_file)
        print(macro_cmd_line)
        wb.ExecuteExcel4Macro(macro_cmd_line)
        excel.Close(SaveChanges=False)
        wb.Quit()

    def get_options(self):
        parser = optparse.OptionParser()
        parser.add_option("-f", "--list-file", dest="list_file", help="specify the list file")
        parser.add_option("-l", "--log-file", dest="log_file", default=self.tag_name, help="specify log file name")
        parser.add_option("-r", "--rpt_file", dest="rpt_file", default=self.tag_name, help="specify target excel file name")
        parser.add_option("-u", "--use-sheet", dest="use_sheet", action="store_true", help="")
        parser.add_option("-c", "--combine", dest="combine", action="store_true", help="combine all sheets to a single excel file")
        parser.add_option("-m", "--macro-file", dest="macro_file", default="MergeExcel.xlsm", help="specify macro file")
        parser.add_option("-n", "--macro-name", dest="macro_name", default="MergeExcel", help="specify macro name")
        opts, args = parser.parse_args()
        self.list_file = opts.list_file
        self.log_file = opts.log_file
        self.rpt_file = opts.rpt_file
        self.use_sheet = opts.use_sheet
        self.combine = opts.combine
        self.macro_file = opts.macro_file
        self.macro_name = opts.macro_name
    def check_options(self):
        if wrap_check(self.list_file, "list_file"):
            return 1
        if not os.path.isfile(self.macro_file):
            self.macro_file = os.path.join(this_dir, self.macro_file)
        if wrap_check(self.macro_file, "macro_file"):
            return 1
        if not self.macro_name:
            print("Error. No macro name specified")
            return 1
        #
        self.rpt_file = re.sub("\.xlsx*", "", self.rpt_file)
        self.list_file = os.path.abspath(self.list_file)
        self.log_file = os.path.abspath(self.log_file) + ".log"
        self.rpt_file = os.path.abspath(self.rpt_file) + ".xlsx"
        self.macro_file = os.path.abspath(self.macro_file)

if __name__ == "__main__":
    my_merge = MergeExcelReportFile()
    my_merge.process()



# Sub MergeExcel(useSheetName As Boolean, combineAll As Boolean, listFile, logFile, rptFile)
#     Open logFile For Output As #1
#     Dim wb As Workbook
#     Dim ws As Object
#     Dim oriExcel As String
#     Dim wbOrig As Workbook
#     Dim sheetNameExp As Object
#     Dim excelFileNameExp As Object
#     Dim skipExcelExp As Object
#     Dim sheetNameMatch As Object
#     Dim excelFileNameMatch As Object
#     Dim skipExcelMatch As Object
#
#     Set sheetNameExp = CreateObject("vbscript.regexp")
#     Set excelFileNameExp = CreateObject("vbscript.regexp")
#     Set skipExcelExp = CreateObject("vbscript.regexp")
#     sheetNameExp.Pattern = "^(Summary)"
#     excelFileNameExp.Pattern = "Diamond\S+\s+(\S+)"
#     skipExcelExp.Pattern = "^(;|#|$)"
#
#     Application.ScreenUpdating = False ' show on screen
#     Set wb = Workbooks.Add(xlWorksheet)
#     Open listFile For Input As #2
#     Do While Not EOF(2)
#         Input #2, oriExcel
#         Set skipExcelMatch = skipExcelExp.Execute(oriExcel)
#         If skipExcelMatch.Count = 0 Then ' will do
#             Write #1, "Parsing " & oriExcel
#             Set wbOrig = Workbooks.Open(Filename:=oriExcel, ReadOnly:=True)
#             For Each ws In wbOrig.Sheets
#                 If combineAll Then
#                     ws.Copy After:=wb.Sheets(wb.Sheets.Count)
#                     wb.Sheets(wb.Sheets.Count).Name = ws.Name
#                 Else
#                     Set sheetNameMatch = sheetNameExp.Execute(ws.Name)
#                     If sheetNameMatch.Count >= 1 Then
#                         ws.Copy After:=wb.Sheets(wb.Sheets.Count)
#                         Write #1, "    copy sheet " & ws.Name & " from " & oriExcel
#                         If useSheetName Then
#                             wb.Sheets(wb.Sheets.Count).Name = ws.Name
#                         Else
#                             Set excelFileNameMatch = excelFileNameExp.Execute(oriExcel)
#                             Debug.Print excelFileNameMatch.Count & "-----" & oriExcel
#                             If excelFileNameMatch.Count = 0 Then
#                                 Write #1, "Can't parse file: " & oriExcel
#                             Else
#                                 'Debug.Print oriExcel, excelFileNameMatch(0).Submatches(0)
#                                 On Error GoTo err1:
#                                     wb.Sheets(wb.Sheets.Count).Name = excelFileNameMatch(0).Submatches(0)
#                             End If
#                         End If
#                     End If
#                 End If
#             Next
#             wbOrig.Close
#         End If
#     Loop
#     Close #2
#     Application.DisplayAlerts = False
#     wb.Sheets(1).Delete
#     wb.SaveAs (rptFile)
#     wb.Close
#     Set wb = Nothing
#     Close #1
#     Exit Sub
# err1:
#     Write #1, "Error. sheet name" & excelFileNameMatch(0).Submatches(0) & " exist in 2 files"
#     MsgBox "sheet name: " & excelFileNameMatch(0).Submatches(0) & " conflicted."
#     Exit Sub
# End Sub




