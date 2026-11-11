<%@ Language=VBScript %>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/fungsi.asp"-->
<!--#include file="inc/semak_sesi.asp"-->
<%
' ------------------------------------------------------------
' lap_baki.asp : laporan baki cuti kakitangan ikut jabatan
' (menu ini hanya dipaparkan kepada Pentadbir)
' ------------------------------------------------------------
Dim rs, rsJ, sql, tahun, jab, bilRekod, jabLama

tahun = Request.QueryString("tahun")
If tahun = "" Then tahun = Year(Date)
jab = Request.QueryString("jab")

sql = "SELECT s.NoStaf, s.Nama, s.NoKP, s.Jawatan, s.KodJabatan, d.NamaJabatan, j.Keterangan, b.Kelayakan, b.BakiBawaHadapan, b.Diambil, " & _
      "(b.Kelayakan + b.BakiBawaHadapan - b.Diambil) AS Baki " & _
      "FROM tblStaf s " & _
      "INNER JOIN tblJabatan d ON d.KodJabatan = s.KodJabatan " & _
      "INNER JOIN tblBakiCuti b ON b.NoStaf = s.NoStaf " & _
      "INNER JOIN tblJenisCuti j ON j.KodCuti = b.KodCuti " & _
      "WHERE b.Tahun=" & tahun
If jab <> "" Then sql = sql & " AND s.KodJabatan='" & jab & "'"
sql = sql & " ORDER BY d.NamaJabatan, s.Nama, j.Susunan"
%>
<!--#include file="inc/atas.asp"-->
<h3>Laporan Baki Cuti Kakitangan</h3>

<form name="frmTapis" method="get" action="lap_baki.asp">
	Tahun:
	<input type="text" name="tahun" size="5" maxlength="4" value="<%=tahun%>">
	Jabatan:
	<select name="jab">
		<option value="">Semua</option>
<%
Set rsJ = conn.Execute("SELECT KodJabatan, NamaJabatan FROM tblJabatan ORDER BY NamaJabatan")
Do While Not rsJ.EOF
%>
		<option value="<%=Trim(rsJ("KodJabatan"))%>"<% If jab = Trim(rsJ("KodJabatan")) Then Response.Write " selected" %>><%=rsJ("NamaJabatan")%></option>
<%
	rsJ.MoveNext
Loop
rsJ.Close
Set rsJ = Nothing
%>
	</select>
	<input type="submit" value="Papar" class="butang">
	<input type="button" value="Cetak" class="butang" onclick="window.print();">
</form>

<table class="jadual">
<tr>
	<th>No. Staf</th>
	<th>Nama</th>
	<th>No. KP</th>
	<th>Jawatan</th>
	<th>Jenis Cuti</th>
	<th>Kelayakan</th>
	<th>Bawa Hadapan</th>
	<th>Diambil</th>
	<th>Baki</th>
</tr>
<%
Set rs = conn.Execute(sql)
bilRekod = 0
jabLama = ""
Do While Not rs.EOF
	bilRekod = bilRekod + 1
	If jabLama <> Trim(rs("KodJabatan")) Then
		jabLama = Trim(rs("KodJabatan"))
%>
<tr><td colspan="9" class="kumpulan"><%=rs("NamaJabatan")%></td></tr>
<%
	End If
%>
<tr>
	<td><%=Trim(rs("NoStaf"))%></td>
	<td><%=rs("Nama")%></td>
	<td><%=rs("NoKP")%></td>
	<td><%=rs("Jawatan")%></td>
	<td><%=rs("Keterangan")%></td>
	<td align="center"><%=rs("Kelayakan")%></td>
	<td align="center"><%=rs("BakiBawaHadapan")%></td>
	<td align="center"><%=rs("Diambil")%></td>
	<td align="center"><strong><%=rs("Baki")%></strong></td>
</tr>
<%
	rs.MoveNext
Loop
rs.Close
Set rs = Nothing

If bilRekod = 0 Then
%>
<tr><td colspan="9" align="center">Tiada rekod.</td></tr>
<%
End If
%>
</table>
<!--#include file="inc/bawah.asp"-->
