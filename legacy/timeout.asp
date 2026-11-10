<%@ Language=VBScript %>
<%
' ------------------------------------------------------------
' timeout.asp : sesi tamat (dipanggil oleh inc/semak_sesi.asp)
' ------------------------------------------------------------
%>
<html>
<head>
<title>e-Cuti</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body class="login-body">
<div class="login-kotak">
	<h3>Sesi Tamat</h3>
	<p>Sesi anda telah tamat kerana tiada aktiviti selama 20 minit.</p>
	<p><input type="button" value="Log Masuk Semula" class="butang" onclick="location.href='logout.asp?cara=Session+Timeout';"></p>
</div>
</body>
</html>
