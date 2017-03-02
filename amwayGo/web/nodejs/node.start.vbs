'다음과 같이 실행 시킨다
'D:\파일경로\node.start.vbs master 8888

Set oShell = WScript.CreateObject ("WScript.Shell")
Set args = WScript.Arguments


If args.length <> 2 Then
    WScript.Echo "argument master[slave] port"
    WScript.Quit
End If

Dim AOF5_HOME, NODE_HOME, LOG4J_HOME, SERVER
Dim oShell

AOF5_PROJECT = "lgaca"
AOF5_HOME    = "D:\eGovPlatform\workspace-project\" + AOF5_PROJECT
NODE_HOME    = "C:\Program Files\nodejs"
LOG4J_HOME   = "D:\eGovPlatform\log\" + AOF5_PROJECT
SERVER       = args.Item(0)
PORT         = args.Item(1)

WScript.Echo "node server start... " + SERVER + " port " + PORT

oShell.Run "cmd /K C: & cd " + NODE_HOME + " & node " + AOF5_HOME + "\web\nodejs\server.js service " + SERVER + " " + PORT + " > " + LOG4J_HOME + "\node.server.log", 0

Set oShell = Nothing
