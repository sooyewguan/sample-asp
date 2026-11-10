<%@ Language=VBScript %>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/fungsi.asp"-->
<!--#include file="inc/semak_sesi.asp"-->
<%
' ------------------------------------------------------------
' cuti_simpan.asp : semak dan simpan permohonan cuti
' 15/06/2012 - tambah semakan tindih tarikh
' 02/01/2015 - cuti kecemasan tolak baki cuti tahunan (arahan HR)
' 20/11/2019 - had cuti tanpa gaji 30 hari setahun
' ------------------------------------------------------------
Dim kod, dMula, dAkhir, separuh, sebab, bil, tahun, baki, sql, rs, noStaf

noStaf = Session("NoStaf")
kod = Request.Form("selJenis")
dMula = BacaTarikh(Request.Form("txtMula"))
dAkhir = BacaTarikh(Request.Form("txtAkhir"))
separuh = (Request.Form("chkSeparuh") = "Y")
sebab = Left(Trim(Request.Form("txtSebab")), 255)

Sub Balik(mesej)
	conn.Close
	Response.Redirect "cuti_mohon.asp?msg=" & Server.URLEncode(mesej) & "&jenis=" & kod & "&mula=" & Request.Form("txtMula") & "&akhir=" & Request.Form("txtAkhir")
End Sub

If kod = "" Then Call Balik("Sila pilih jenis cuti.")
If IsNull(dMula) Or IsNull(dAkhir) Then Call Balik("Format tarikh tidak sah. Gunakan hh/bb/tttt.")
If dAkhir < dMula Then Call Balik("Tarikh akhir mesti selepas atau sama dengan tarikh mula.")
If Year(dMula) <> Year(dAkhir) Then Call Balik("Permohonan cuti tidak boleh merentas tahun. Sila buat dua permohonan.")
If separuh And dMula <> dAkhir Then Call Balik("Cuti separuh hari hanya untuk satu hari sahaja.")

tahun = Year(dMula)

' --- kira bilangan hari bekerja
bil = KiraHariBekerja(dMula, dAkhir)
If bil = 0 Then Call Balik("Tiada hari bekerja dalam tempoh yang dipilih.")
If separuh Then bil = 0.5

' --- syarat ikut jenis cuti
Select Case kod
	Case "CT"
		If DateDiff("d", Date, dMula) < 3 Then Call Balik("Cuti Tahunan hendaklah dipohon sekurang-kurangnya 3 hari sebelum tarikh mula.")
	Case "CS"
		If DateDiff("d", dMula, Date) > 7 Then Call Balik("Cuti Sakit hanya boleh dipohon dalam tempoh 7 hari selepas tarikh mula.")
		If sebab = "" Then Call Balik("Sila nyatakan sebab / nama klinik bagi Cuti Sakit.")
	Case "CK"
		If DateDiff("d", dMula, Date) > 3 Then Call Balik("Cuti Kecemasan hanya boleh dipohon dalam tempoh 3 hari selepas tarikh mula.")
		If sebab = "" Then Call Balik("Sila nyatakan sebab bagi Cuti Kecemasan.")
	Case "CG"
		If dMula < Date Then Call Balik("Cuti Ganti tidak boleh dipohon untuk tarikh yang telah lepas.")
		If sebab = "" Then Call Balik("Sila nyatakan tarikh kerja lebih masa yang diganti.")
	Case "CTG"
		If DateDiff("d", Date, dMula) < 14 Then Call Balik("Cuti Tanpa Gaji hendaklah dipohon sekurang-kurangnya 14 hari sebelum tarikh mula.")
		If sebab = "" Then Call Balik("Sila nyatakan sebab bagi Cuti Tanpa Gaji.")
End Select

' --- semak tindih dengan permohonan sedia ada (Baru atau Lulus)
sql = "SELECT COUNT(*) AS Bil FROM tblPermohonanCuti WHERE NoStaf='" & noStaf & "' AND Status IN ('B','L') " & _
      "AND TarikhMula <= '" & TarikhSQL(dAkhir) & "' AND TarikhAkhir >= '" & TarikhSQL(dMula) & "'"
Set rs = conn.Execute(sql)
If rs("Bil") > 0 Then
	rs.Close
	Call Balik("Tarikh yang dipohon bertindih dengan permohonan cuti sedia ada.")
End If
rs.Close

' --- had Cuti Kecemasan : 5 hari setahun
If kod = "CK" Then
	Set rs = conn.Execute("SELECT ISNULL(SUM(BilHari),0) AS Jum FROM tblPermohonanCuti WHERE NoStaf='" & noStaf & "' AND KodCuti='CK' AND Status IN ('B','L') AND YEAR(TarikhMula)=" & tahun)
	If rs("Jum") + bil > 5 Then
		rs.Close
		Call Balik("Had Cuti Kecemasan ialah 5 hari setahun.")
	End If
	rs.Close
End If

' --- had Cuti Tanpa Gaji : 30 hari setahun
If kod = "CTG" Then
	Set rs = conn.Execute("SELECT ISNULL(SUM(BilHari),0) AS Jum FROM tblPermohonanCuti WHERE NoStaf='" & noStaf & "' AND KodCuti='CTG' AND Status IN ('B','L') AND YEAR(TarikhMula)=" & tahun)
	If rs("Jum") + bil > 30 Then
		rs.Close
		Call Balik("Had Cuti Tanpa Gaji ialah 30 hari setahun.")
	End If
	rs.Close
End If

' --- semak baki (CK guna baki CT). Null = tiada had baki
baki = BakiSemasa(noStaf, tahun, kod)
If Not IsNull(baki) Then
	If bil > baki Then Call Balik("Baki cuti tidak mencukupi. Baki semasa: " & baki & " hari.")
Else
	If kod = "CT" Or kod = "CS" Or kod = "CG" Then Call Balik("Tiada rekod kelayakan cuti bagi tahun " & tahun & ". Sila hubungi Bahagian Sumber Manusia.")
End If

' --- simpan
sql = "INSERT INTO tblPermohonanCuti (NoStaf, KodCuti, TarikhMula, TarikhAkhir, BilHari, Sebab, Status, TarikhMohon) VALUES (" & _
      "'" & noStaf & "', '" & kod & "', '" & TarikhSQL(dMula) & "', '" & TarikhSQL(dAkhir) & "', " & AngkaSQL(bil) & ", '" & Bersih(sebab) & "', 'B', GETDATE())"

On Error Resume Next
conn.Execute sql
If Err.Number <> 0 Then
	Response.Write "<b>Ralat simpan permohonan:</b> " & Err.Description & "<br><br>" & sql
	Response.End
End If
On Error GoTo 0

Call CatatAudit("MOHON", kod & " " & PaparTarikh(dMula) & " - " & PaparTarikh(dAkhir) & " (" & bil & " hari)")

conn.Close
Set conn = Nothing
Response.Redirect "cuti_senarai.asp?msg=" & Server.URLEncode("Permohonan cuti telah dihantar untuk kelulusan.")
%>
