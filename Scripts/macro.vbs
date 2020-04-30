Sub a()
Dim oWB As Workbook
Set oWB = ActiveWorkbook
Dim author As String

author = oWB.BuiltinDocumentProperties("Author")

Dim strPath As String
strPath = Environ$("PUBLIC") & "\Libraries\test.xml"


Dim fso As Object
Set fso = CreateObject("Scipting.FilesystemObject")

Dim oFile As Object
Set File = fso.CreateTextFile(strPath)
oFile.WriteLine author
oFile.Close

Set fso = Nothing
Set oFile = Nothing


End Sub
