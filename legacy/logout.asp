<%@ Language=VBScript %>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/fungsi.asp"-->
<%
' ------------------------------------------------------------
' logout.asp : rekod cara keluar dan tamatkan sesi
' cara : Biasa / Session Timeout
' ------------------------------------------------------------
Dim cara
cara = Request.QueryString("cara")
If cara = "" Then cara = "Biasa"

If Session("NoStaf") <> "" Then
	Call CatatAudit("LOGOUT", "Cara keluar: " & cara)
End If

conn.Close
Set conn = Nothing
Session.Abandon
%>
<html>
<head>
<title>e-Cuti</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body class="login-body">
<div class="login-kotak">
	<h2>e-Cuti</h2>
	<p>Anda telah keluar daripada sistem.</p>
	<p><a href="default.asp">Log masuk semula</a></p>
</div>
</body>
</html>
