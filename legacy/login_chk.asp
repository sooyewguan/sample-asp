<%@ Language=VBScript %>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/fungsi.asp"-->
<%
' ------------------------------------------------------------
' login_chk.asp : semak No. Staf dan Kata Laluan
' ------------------------------------------------------------
Dim sql, rs

sql = "SELECT s.NoStaf, s.Nama, s.Peranan, s.KodJabatan, s.NoStafPenyelia, j.NamaJabatan " & _
      "FROM tblStaf s LEFT JOIN tblJabatan j ON j.KodJabatan = s.KodJabatan " & _
      "WHERE s.NoStaf='" & Request.Form("txtNoStaf") & "' AND s.KataLaluan='" & Request.Form("txtKataLaluan") & "' AND s.StatusAktif='Y'"

Set rs = conn.Execute(sql)

If rs.EOF Then
	rs.Close
	conn.Close
	Response.Redirect "default.asp?err=1"
End If

Session("NoStaf") = Trim(rs("NoStaf"))
Session("Nama") = rs("Nama")
Session("Peranan") = Trim(rs("Peranan"))
Session("KodJabatan") = Trim(rs("KodJabatan"))
Session("NamaJabatan") = rs("NamaJabatan")
Session("NoStafPenyelia") = Trim(rs("NoStafPenyelia") & "")
rs.Close
Set rs = Nothing

Call CatatAudit("LOGIN", "Log masuk berjaya")

conn.Close
Set conn = Nothing
Response.Redirect "usr_welcome.asp"
%>
