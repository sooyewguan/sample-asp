<%@ Language=VBScript %>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/fungsi.asp"-->
<!--#include file="inc/semak_sesi.asp"-->
<%
' ------------------------------------------------------------
' usr_welcome.asp : skrin utama, baki cuti tahun semasa
' ------------------------------------------------------------
Dim rs, sql, tahun, bilTunggu, bakiS, proses
tahun = Year(Date)
%>
<!--#include file="inc/atas.asp"-->
<h3>Selamat Datang, <%=Session("Nama")%></h3>

<h4>Baki Cuti Tahun <%=tahun%></h4>
<table class="jadual">
<tr>
	<th>Jenis Cuti</th>
	<th>Kelayakan</th>
	<th>Bawa Hadapan</th>
	<th>Diambil</th>
	<th>Dalam Proses</th>
	<th>Baki</th>
</tr>
<%
sql = "SELECT b.KodCuti, j.Keterangan, b.Kelayakan, b.BakiBawaHadapan, b.Diambil " & _
      "FROM tblBakiCuti b, tblJenisCuti j " & _
      "WHERE b.KodCuti = j.KodCuti AND b.NoStaf='" & Session("NoStaf") & "' AND b.Tahun=" & tahun & " ORDER BY j.Susunan"
Set rs = Server.CreateObject("ADODB.Recordset")
rs.CursorLocation = 3
rs.Open sql, conn
If rs.EOF Then
%>
<tr><td colspan="6">Tiada rekod baki cuti bagi tahun ini.</td></tr>
<%
End If
Do While Not rs.EOF
	bakiS = BakiSemasa(Session("NoStaf"), tahun, Trim(rs("KodCuti")))
	proses = Nombor(rs("Kelayakan")) + Nombor(rs("BakiBawaHadapan")) - Nombor(rs("Diambil")) - bakiS
%>
<tr>
	<td><%=rs("Keterangan")%></td>
	<td align="center"><%=rs("Kelayakan")%></td>
	<td align="center"><%=rs("BakiBawaHadapan")%></td>
	<td align="center"><%=rs("Diambil")%></td>
	<td align="center"><%=proses%></td>
	<td align="center"><strong><%=bakiS%></strong></td>
</tr>
<%
	rs.MoveNext
Loop
rs.Close
%>
</table>
<p class="nota">Nota: Cuti Kecemasan ditolak daripada baki Cuti Tahunan.</p>

<%
If Session("Peranan") = "P" Or Session("Peranan") = "A" Then
	If Session("Peranan") = "A" Then
		sql = "SELECT COUNT(*) AS Bil FROM tblPermohonanCuti WHERE Status='B'"
	Else
		sql = "SELECT COUNT(*) AS Bil FROM tblPermohonanCuti p, tblStaf s WHERE p.NoStaf = s.NoStaf AND p.Status='B' AND s.NoStafPenyelia='" & Session("NoStaf") & "'"
	End If
	Set rs = conn.Execute(sql)
	bilTunggu = rs("Bil")
	rs.Close
%>
<div class="makluman">
	Terdapat <strong><%=bilTunggu%></strong> permohonan cuti menunggu kelulusan.
	<a href="cuti_lulus.asp">Lihat senarai</a>
</div>
<%
End If
Set rs = Nothing
%>
<!--#include file="inc/bawah.asp"-->
