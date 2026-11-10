<%@ Language=VBScript %>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/fungsi.asp"-->
<!--#include file="inc/semak_sesi.asp"-->
<%
' ------------------------------------------------------------
' cuti_senarai.asp : senarai permohonan cuti saya
' ------------------------------------------------------------
Dim rs, sql, tahun, status, bolehBatal, bilRekod

tahun = Request.QueryString("tahun")
If tahun = "" Then tahun = Year(Date)
status = Request.QueryString("status")

sql = "SELECT p.IdPermohonan, p.KodCuti, j.Keterangan, p.TarikhMula, p.TarikhAkhir, p.BilHari, p.Status, p.TarikhMohon " & _
      "FROM tblPermohonanCuti p, tblJenisCuti j " & _
      "WHERE p.KodCuti = j.KodCuti AND p.NoStaf='" & Session("NoStaf") & "' AND YEAR(p.TarikhMula)=" & tahun
If status <> "" Then sql = sql & " AND p.Status='" & status & "'"
sql = sql & " ORDER BY p.TarikhMula DESC"
%>
<!--#include file="inc/atas.asp"-->
<h3>Senarai Permohonan Cuti</h3>

<% If Request.QueryString("msg") <> "" Then %>
	<div class="makluman"><%=Request.QueryString("msg")%></div>
<% End If %>

<form name="frmTapis" method="get" action="cuti_senarai.asp">
	Tahun:
	<select name="tahun">
		<option value="<%=Year(Date)-1%>"<% If CStr(tahun) = CStr(Year(Date)-1) Then Response.Write " selected" %>><%=Year(Date)-1%></option>
		<option value="<%=Year(Date)%>"<% If CStr(tahun) = CStr(Year(Date)) Then Response.Write " selected" %>><%=Year(Date)%></option>
		<option value="<%=Year(Date)+1%>"<% If CStr(tahun) = CStr(Year(Date)+1) Then Response.Write " selected" %>><%=Year(Date)+1%></option>
	</select>
	Status:
	<select name="status">
		<option value="">Semua</option>
		<option value="B"<% If status = "B" Then Response.Write " selected" %>>Baru</option>
		<option value="L"<% If status = "L" Then Response.Write " selected" %>>Lulus</option>
		<option value="T"<% If status = "T" Then Response.Write " selected" %>>Tolak</option>
		<option value="X"<% If status = "X" Then Response.Write " selected" %>>Batal</option>
	</select>
	<input type="submit" value="Papar" class="butang">
</form>

<table class="jadual">
<tr>
	<th>Bil</th>
	<th>Jenis Cuti</th>
	<th>Tarikh Mula</th>
	<th>Tarikh Akhir</th>
	<th>Bil. Hari</th>
	<th>Tarikh Mohon</th>
	<th>Status</th>
	<th>Tindakan</th>
</tr>
<%
On Error Resume Next
Set rs = conn.Execute(sql)
If Err.Number <> 0 Then
	Response.Write "<tr><td colspan=8><b>Ralat:</b> " & Err.Description & "<br>" & sql & "</td></tr></table>"
	Response.End
End If
On Error GoTo 0

bilRekod = 0
Do While Not rs.EOF
	bilRekod = bilRekod + 1
	' Baru boleh dibatal bila-bila masa. Lulus boleh dibatal sebelum tarikh mula.
	bolehBatal = False
	If Trim(rs("Status")) = "B" Then bolehBatal = True
	If Trim(rs("Status")) = "L" And rs("TarikhMula") > Date Then bolehBatal = True
%>
<tr>
	<td align="center"><%=bilRekod%></td>
	<td><%=rs("Keterangan")%></td>
	<td align="center"><%=PaparTarikh(rs("TarikhMula"))%></td>
	<td align="center"><%=PaparTarikh(rs("TarikhAkhir"))%></td>
	<td align="center"><%=rs("BilHari")%></td>
	<td align="center"><%=PaparTarikh(rs("TarikhMohon"))%></td>
	<td align="center" class="status-<%=Trim(rs("Status"))%>"><%=StatusLabel(rs("Status"))%></td>
	<td align="center">
		<a href="cuti_butiran.asp?id=<%=rs("IdPermohonan")%>">Butiran</a>
		<% If bolehBatal Then %>
		| <a href="cuti_batal.asp?id=<%=rs("IdPermohonan")%>" onclick="return sahBatal();">Batal</a>
		<% End If %>
	</td>
</tr>
<%
	rs.MoveNext
Loop
rs.Close
Set rs = Nothing

If bilRekod = 0 Then
%>
<tr><td colspan="8" align="center">Tiada rekod.</td></tr>
<%
End If
%>
</table>
<!--#include file="inc/bawah.asp"-->
