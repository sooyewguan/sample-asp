<%
' inc/semak_sesi.asp : pastikan pengguna telah log masuk
If Session("NoStaf") = "" Then
	Response.Redirect "timeout.asp"
End If
%>
