<%@ Language=VBScript %>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/fungsi.asp"-->
<!--#include file="inc/semak_sesi.asp"-->
<%
' ------------------------------------------------------------
' cuti_lulus.asp : senarai permohonan menunggu kelulusan
' Penyelia (P)  : permohonan staf di bawah seliaan
' Pentadbir (A) : semua permohonan
' ------------------------------------------------------------
Dim rs, sql, bilRekod

If Session("Peranan") <> "P" And Session("Peranan") <> "A" Then
	Response.Write "Anda tiada kebenaran untuk skrin ini."
	Response.End
End If

sql = "SELECT p.IdPermohonan, p.NoStaf, s.Nama, j.Keterangan, p.TarikhMula, p.TarikhAkhir, p.BilHari, p.Sebab, p.TarikhMohon " & _
      "FROM tblPermohonanCuti p, tblStaf s, tblJenisCuti j " & _
      "WHERE p.NoStaf = s.NoStaf AND p.KodCuti = j.KodCuti AND p.Status='B'"
If Session("Peranan") = "P" Then
	sql = sql & " AND s.NoStafPenyelia='" & Session("NoStaf") & "'"
End If
sql = sql & " ORDER BY p.TarikhMohon"

Set rs = conn.Execute(sql)
%>
<!--#include file="inc/atas.asp"-->
<h3>Kelulusan Cuti</h3>

<% If Request.QueryString("msg") <> "" Then %>
	<div class="makluman"><%=Request.QueryString("msg")%></div>
<% End If %>

<table class="jadual">
<tr>
	<th>Bil</th>
	<th>Nama</th>
	<th>Jenis Cuti</th>
	<th>Tarikh</th>
	<th>Bil. Hari</th>
	<th>Sebab</th>
	<th>Tarikh Mohon</th>
	<th>Tindakan</th>
</tr>
<%
bilRekod = 0
Do While Not rs.EOF
	bilRekod = bilRekod + 1
%>
<tr>
	<td align="center"><%=bilRekod%></td>
	<td><%=rs("Nama")%><br><small><%=Trim(rs("NoStaf"))%></small></td>
	<td><%=rs("Keterangan")%></td>
	<td align="center"><%=PaparTarikh(rs("TarikhMula"))%> - <%=PaparTarikh(rs("TarikhAkhir"))%></td>
	<td align="center"><%=rs("BilHari")%></td>
	<td><%=rs("Sebab")%></td>
	<td align="center"><%=PaparTarikh(rs("TarikhMohon"))%></td>
	<td align="center"><a href="cuti_lulus_borang.asp?id=<%=rs("IdPermohonan")%>">Proses</a></td>
</tr>
<%
	rs.MoveNext
Loop
rs.Close
Set rs = Nothing

If bilRekod = 0 Then
%>
<tr><td colspan="8" align="center">Tiada permohonan menunggu kelulusan.</td></tr>
<%
End If
%>
</table>
<!--#include file="inc/bawah.asp"-->
