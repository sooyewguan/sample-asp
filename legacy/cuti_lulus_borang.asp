<%@ Language=VBScript %>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/fungsi.asp"-->
<!--#include file="inc/semak_sesi.asp"-->
<%
' ------------------------------------------------------------
' cuti_lulus_borang.asp : borang keputusan (Lulus / Tolak)
' ------------------------------------------------------------
Dim rs, sql, id, noStafMohon, nama, ket, kod, dMula, dAkhir, bil, sebab, dMohon, baki

If Session("Peranan") <> "P" And Session("Peranan") <> "A" Then
	Response.Write "Anda tiada kebenaran untuk skrin ini."
	Response.End
End If

id = Request.QueryString("id")
sql = "SELECT p.*, s.Nama, j.Keterangan FROM tblPermohonanCuti p, tblStaf s, tblJenisCuti j " & _
      "WHERE p.NoStaf = s.NoStaf AND p.KodCuti = j.KodCuti AND p.Status='B' AND p.IdPermohonan=" & id
Set rs = conn.Execute(sql)
If rs.EOF Then
	rs.Close
	conn.Close
	Response.Redirect "cuti_lulus.asp?msg=" & Server.URLEncode("Permohonan tidak dijumpai atau telah diproses.")
End If

noStafMohon = Trim(rs("NoStaf"))
nama = rs("Nama")
ket = rs("Keterangan")
kod = Trim(rs("KodCuti"))
dMula = rs("TarikhMula")
dAkhir = rs("TarikhAkhir")
bil = Nombor(rs("BilHari"))
sebab = rs("Sebab")
dMohon = rs("TarikhMohon")
rs.Close
Set rs = Nothing

baki = BakiSemasa(noStafMohon, Year(dMula), kod)
%>
<!--#include file="inc/atas.asp"-->
<h3>Keputusan Permohonan Cuti #<%=id%></h3>

<form name="frmLulus" method="post" action="cuti_lulus_simpan.asp" onsubmit="return semakBorangLulus();">
<input type="hidden" name="hidId" value="<%=id%>">
<table class="borang">
<tr><td>Nama</td><td><%=nama%> (<%=noStafMohon%>)</td></tr>
<tr><td>Jenis Cuti</td><td><%=ket%></td></tr>
<tr><td>Tarikh</td><td><%=PaparTarikh(dMula)%> hingga <%=PaparTarikh(dAkhir)%></td></tr>
<tr><td>Bilangan Hari</td><td><%=bil%></td></tr>
<tr><td>Sebab</td><td><%=sebab%></td></tr>
<tr><td>Tarikh Mohon</td><td><%=PaparTarikh(dMohon)%></td></tr>
<tr>
	<td>Baki Selepas Permohonan Ini</td>
	<td>
	<% If IsNull(baki) Then %>
		Tiada had baki
	<% Else %>
		<%=baki%> hari
	<% End If %>
	</td>
</tr>
<tr>
	<td>Keputusan <span class="wajib">*</span></td>
	<td>
		<input type="radio" name="radKeputusan" value="L"> Lulus
		<input type="radio" name="radKeputusan" value="T"> Tolak
	</td>
</tr>
<tr>
	<td>Catatan</td>
	<td><textarea name="txtCatatan" rows="3" cols="50"></textarea><br><small>Wajib diisi jika permohonan ditolak.</small></td>
</tr>
<tr>
	<td></td>
	<td>
		<input type="submit" value="Simpan" class="butang">
		<input type="button" value="Kembali" class="butang" onclick="location.href='cuti_lulus.asp';">
	</td>
</tr>
</table>
</form>
<!--#include file="inc/bawah.asp"-->
