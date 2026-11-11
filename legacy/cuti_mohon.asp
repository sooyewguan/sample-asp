<%@ Language=VBScript %>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/fungsi.asp"-->
<!--#include file="inc/semak_sesi.asp"-->
<%
' ------------------------------------------------------------
' cuti_mohon.asp : borang permohonan cuti
' ------------------------------------------------------------
Dim rs
%>
<!--#include file="inc/atas.asp"-->
<h3>Permohonan Cuti</h3>

<% If Request.QueryString("msg") <> "" Then %>
	<div class="ralat"><%=Request.QueryString("msg")%></div>
<% End If %>

<form name="frmCuti" method="post" action="cuti_simpan.asp" onsubmit="return semakBorangCuti();">
<table class="borang">
<tr>
	<td>Nama</td>
	<td><%=Session("Nama")%> (<%=Session("NoStaf")%>)</td>
</tr>
<tr>
	<td>Jenis Cuti <span class="wajib">*</span></td>
	<td>
		<select name="selJenis">
			<option value="">-- Sila Pilih --</option>
<%
Set rs = conn.Execute("SELECT KodCuti, Keterangan FROM tblJenisCuti WHERE StatusAktif='Y' ORDER BY Susunan")
Do While Not rs.EOF
%>
			<option value="<%=Trim(rs("KodCuti"))%>"<% If Request.QueryString("jenis") = Trim(rs("KodCuti")) Then Response.Write " selected" %>><%=rs("Keterangan")%></option>
<%
	rs.MoveNext
Loop
rs.Close
Set rs = Nothing
%>
		</select>
	</td>
</tr>
<tr>
	<td>Tarikh Mula <span class="wajib">*</span></td>
	<td><input type="text" name="txtMula" size="12" maxlength="10" value="<%=Request.QueryString("mula")%>"> (hh/bb/tttt)</td>
</tr>
<tr>
	<td>Tarikh Akhir <span class="wajib">*</span></td>
	<td><input type="text" name="txtAkhir" size="12" maxlength="10" value="<%=Request.QueryString("akhir")%>"> (hh/bb/tttt)</td>
</tr>
<tr>
	<td>Separuh Hari</td>
	<td><input type="checkbox" name="chkSeparuh" value="Y"> Ya (hanya jika Tarikh Mula sama dengan Tarikh Akhir)</td>
</tr>
<tr>
	<td>Sebab / Catatan</td>
	<td><textarea name="txtSebab" rows="4" cols="50"></textarea></td>
</tr>
<tr>
	<td></td>
	<td>
		<input type="submit" value="Hantar" class="butang">
		<input type="reset" value="Set Semula" class="butang">
	</td>
</tr>
</table>
</form>

<div class="nota">
	<strong>Peringatan:</strong>
	<ul>
		<li>Cuti Tahunan hendaklah dipohon sekurang-kurangnya 3 hari sebelum tarikh mula.</li>
		<li>Cuti Sakit boleh dipohon dalam tempoh 7 hari selepas tarikh mula.</li>
		<li>Sabtu, Ahad dan cuti umum tidak dikira sebagai hari cuti.</li>
	</ul>
</div>
<!--#include file="inc/bawah.asp"-->
