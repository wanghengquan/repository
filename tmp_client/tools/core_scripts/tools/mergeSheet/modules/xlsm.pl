' used for compiling the Excel macro file only.

Sub MergeExcel(useSheetName As Boolean, combineAll As Boolean, listFile, logFile, rptFile)
    Open logFile For Output As #1
    Dim wb As Workbook
    Dim ws As Object
    Dim oriExcel As String
    Dim color As String
    Dim oriColorExcel As String
    Dim wbOrig As Workbook
    Dim sheetNameExp As Object
    Dim excelFileNameExp As Object
    Dim skipExcelExp As Object
    Dim sheetNameMatch As Object
    Dim excelFileNameMatch As Object
    Dim skipExcelMatch As Object

    Set sheetNameExp = CreateObject("vbscript.regexp")
    Set excelFileNameExp = CreateObject("vbscript.regexp")
    Set skipExcelExp = CreateObject("vbscript.regexp")
    sheetNameExp.Pattern = "^(Summary)"
    excelFileNameExp.Pattern = "Diamond\S+\s+(.+)\s+Test"
    skipExcelExp.Pattern = "^(;|#|$)"

    Dim colorSheetExp As Object
    Set colorSheetExp = CreateObject("vbscript.regexp")
    colorSheetExp.Pattern = "(\w+)@(.+)"


    Application.ScreenUpdating = False ' show on screen
    Set wb = Workbooks.Add(xlWorksheet)
    Open listFile For Input As #2
    Do While Not EOF(2)
        Input #2, oriColorExcel
        Debug.Print "original line -- " & oriColorExcel
        Set colorSheetMatch = colorSheetExp.Execute(oriColorExcel)
        Debug.Print "match -- " & colorSheetMatch(0).Submatches(0) & "???" & colorSheetMatch(0).Submatches(1)
    ' Loop
    ' Exit Sub

        color = colorSheetMatch(0).Submatches(0)
        oriExcel = colorSheetMatch(0).Submatches(1)

        Set skipExcelMatch = skipExcelExp.Execute(oriExcel)
        If skipExcelMatch.Count = 0 Then ' will do
            Write #1, "Parsing " & oriExcel
            Set wbOrig = Workbooks.Open(Filename:=oriExcel, ReadOnly:=True)
            For Each ws In wbOrig.Sheets
                If combineAll Then
                    ws.Copy After:=wb.Sheets(wb.Sheets.Count)
                    wb.Sheets(wb.Sheets.Count).Name = ws.Name
                ElseIf ws.Name = "QoR Status" Or ws.Name = "QoR_data_Summary" Then
                    ws.Copy After:=wb.Sheets(wb.Sheets.Count)
                    wb.Sheets(wb.Sheets.Count).Name = ws.Name

                Else
                    Set sheetNameMatch = sheetNameExp.Execute(ws.Name)
                    If sheetNameMatch.Count >= 1 Then
                        ws.Copy After:=wb.Sheets(wb.Sheets.Count)
                        Write #1, "    copy sheet " & ws.Name & " from " & oriExcel
                        If color = "RED" Then
                            ActiveSheet.Tab.ColorIndex = 3
                        ElseIf color = "GREEN" Then
                            ActiveSheet.Tab.ColorIndex = 4
                        Else
                            ActiveSheet.Tab.ColorIndex = 6
                        End If

                        If useSheetName Then
                            wb.Sheets(wb.Sheets.Count).Name = ws.Name
                        Else
                            Set excelFileNameMatch = excelFileNameExp.Execute(oriExcel)
                            Debug.Print excelFileNameMatch.Count & "-----" & oriExcel
                            If excelFileNameMatch.Count = 0 Then
                                Write #1, "Can't parse file: " & oriExcel
                            Else
                                'Debug.Print oriExcel, excelFileNameMatch(0).Submatches(0)
                                On Error GoTo err1:
                                    wb.Sheets(wb.Sheets.Count).Name = excelFileNameMatch(0).Submatches(0)
                            End If
                        End If
                    End If
                End If
            Next
            wbOrig.Close
        End If
    Loop
    Close #2
    Application.DisplayAlerts = False
    wb.Sheets(1).Delete
    wb.SaveAs (rptFile)
    wb.Close
    Set wb = Nothing
    Close #1
    Exit Sub
err1:
    Write #1, "Error. sheet name" & excelFileNameMatch(0).Submatches(0) & " exist in 2 files"
    MsgBox "sheet name: " & excelFileNameMatch(0).Submatches(0) & " conflicted."
    Exit Sub
End Sub

' MergeExcel(False, False, "t_file_list", "dir_.log", "dir_")



Sub mergeExcelK()
    ' Debug.Print "asd"
    Call MergeExcel(False, False, "C:\sheet\file_list", "dir_.log", "dir_")
End Sub


