<%@ Language=VBScript %>
<%
' ------------------------------------------------------------
' default.asp : skrin log masuk e-Cuti
' ------------------------------------------------------------
Response.Expires = -1
%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Selamat Datang Ke e-Cuti</title>
<link rel="stylesheet" href="css/style.css">
<script language="javascript" src="misc.js"></script>
<script language="JavaScript">
function semakLogin() {
	var f = document.frmLogin;
	if (f.txtNoStaf.value == "" || f.txtKataLaluan.value == "") {
		alert("Pastikan anda telah mengisi No. Staf dan Kata Laluan");
		return false;
	}
	return true;
}
</script>
</head>
<body class="login-body">
<div class="login-kotak">
	<h2>e-Cuti</h2>
	<p>Sistem Permohonan Cuti Kakitangan</p>
	<% If Request.QueryString("err") = "1" Then %>
		<div class="ralat">No. Staf atau Kata Laluan tidak sah.</div>
	<% End If %>
	<% If Request.QueryString("err") = "2" Then %>
		<div class="ralat">Sesi anda telah tamat. Sila log masuk semula.</div>
	<% End If %>
	<form name="frmLogin" method="post" action="login_chk.asp" onsubmit="return semakLogin();">
		<table>
			<tr><td>No. Staf</td><td><input type="text" name="txtNoStaf" maxlength="10"></td></tr>
			<tr><td>Kata Laluan</td><td><input type="password" name="txtKataLaluan" maxlength="20"></td></tr>
			<tr><td></td><td><input type="submit" value="Log Masuk" class="butang"></td></tr>
		</table>
	</form>
</div>
</body>
</html>
