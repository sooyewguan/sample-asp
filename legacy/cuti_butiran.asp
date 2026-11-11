<%@ Language=VBScript %>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/fungsi.asp"-->
<!--#include file="inc/semak_sesi.asp"-->
<%
' ------------------------------------------------------------
' cuti_butiran.asp : butiran satu permohonan
' ------------------------------------------------------------
Dim rs, sql

sql = "SELECT p.*, j.Keterangan, s.Nama, s.NoKP, s.Jawatan, d.NamaJabatan, pl.Nama AS NamaPelulus " & _
      "FROM tblPermohonanCuti p " & _
      "INNER JOIN tblJenisCuti j ON j.KodCuti = p.KodCuti " & _
      "INNER JOIN tblStaf s ON s.NoStaf = p.NoStaf " & _
      "LEFT JOIN tblJabatan d ON d.KodJabatan = s.KodJabatan " & _
      "LEFT JOIN tblStaf pl ON pl.NoStaf = p.NoStafPelulus " & _
      "WHERE p.IdPermohonan=" & Request.QueryString("id")
Set rs = conn.Execute(sql)
%>
<!--#include file="inc/atas.asp"-->
<% If rs.EOF Then %>
	<p>Rekod tidak dijumpai.</p>
<% Else %>
<h3>Butiran Permohonan Cuti #<%=rs("IdPermohonan")%></h3>
<table class="borang">
<tr><td>Nama</td><td><%=rs("Nama")%> (<%=Trim(rs("NoStaf"))%>)</td></tr>
<tr><td>No. Kad Pengenalan</td><td><%=rs("NoKP")%></td></tr>
<tr><td>Jawatan</td><td><%=rs("Jawatan")%></td></tr>
<tr><td>Jabatan</td><td><%=rs("NamaJabatan")%></td></tr>
<tr><td>Jenis Cuti</td><td><%=rs("Keterangan")%></td></tr>
<tr><td>Tarikh</td><td><%=PaparTarikh(rs("TarikhMula"))%> hingga <%=PaparTarikh(rs("TarikhAkhir"))%></td></tr>
<tr><td>Bilangan Hari</td><td><%=rs("BilHari")%></td></tr>
<tr><td>Sebab</td><td><%=rs("Sebab")%></td></tr>
<tr><td>Tarikh Mohon</td><td><%=PaparTarikh(rs("TarikhMohon"))%></td></tr>
<tr><td>Status</td><td><%=StatusLabel(rs("Status"))%></td></tr>
<tr><td>Pelulus</td><td><%=rs("NamaPelulus")%></td></tr>
<tr><td>Tarikh Keputusan</td><td><%=PaparTarikh(rs("TarikhLulus"))%></td></tr>
<tr><td>Catatan Pelulus</td><td><%=rs("CatatanPelulus")%></td></tr>
</table>
<% End If %>
<p><input type="button" value="Kembali" class="butang" onclick="history.back();"></p>
<%
rs.Close
Set rs = Nothing
%>
<!--#include file="inc/bawah.asp"-->
