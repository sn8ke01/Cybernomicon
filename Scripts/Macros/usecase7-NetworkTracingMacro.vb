Function CSV_Import(strFile)
    Dim ws As Worksheet
    Set ws = ActiveWorkbook.Sheets("Sheet1")
    With ws.QueryTables.Add(Connection:="TEXT;" & strFile, Destination:=ws.Range("A1"))
     .TextFileParseType = xlDelimited
     .TextFileCommaDelimiter = True
     .Refresh
    End With
    ActiveWorkbook.Saved = True
End Function

Function network_trace(secs)
    If secs = 0 Then secs = 2
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    Set objFile = objFSO.CreateTextFile("c:\windows\temp\network_trace.ps1", True)
    objFile.Write "$IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]""Administrator"")" & vbCrLf
    objFile.Write "if (-not $IsAdmin) {" & vbCrLf
    objFile.Write "    $cmd = $MyInvocation.MyCommand.Path + "" $args""" & vbCrLf
    objFile.Write "    $arguments = ""-windowstyle hidden -NoProfile -Command """"& {$cmd} """"""" & vbCrLf
    objFile.Write "    $proc = Start-Process ""$psHome\powershell.exe"" -Verb Runas -ArgumentList $arguments -ErrorAction 'stop'" & vbCrLf
    
    objFile.Write "    $proc.WaitForExit()" & vbCrLf
    objFile.Write "    Break" & vbCrLf
    objFile.Write "}" & vbCrLf
    objFile.Write "New-NetEventSession -Name “Session1” -CaptureMode SaveToFile -LocalFilePath ""C:\windows\temp\packets.etl""" & vbCrLf
    objFile.Write "Add-NetEventProvider -Name “Microsoft-Windows-TCPIP” -SessionName “Session1”" & vbCrLf
    objFile.Write "Start-NetEventSession -Name “Session1”" & vbCrLf
    objFile.Write "Start-Sleep -s $args[0]" & vbCrLf
    objFile.Write "tracerpt c:\windows\temp\packets.etl -o c:\windows\temp\packets.csv -of csv -y -rl 5" & vbCrLf
    objFile.Write "Stop-NetEventSession -Name session1" & vbCrLf
    objFile.Write "Remove-NetEventSession" & vbCrLf
    objFile.Write "Get-Content c:\windows\temp\packets.csv" & vbCrLf
    objFile.Close
    Set objShell = CreateObject("Wscript.shell")
    objShell.Run "powershell -windowstyle hidden -file c:\windows\temp\network_trace.ps1 " & Str(secs), 0, True
    CSV_Import "c:\windows\temp\packets.csv"
End Function

Private Sub Workbook_Open()
    network_trace 2
End Sub
