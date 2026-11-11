<%
' ------------------------------------------------------------
' inc/fungsi.asp : fungsi-fungsi umum e-Cuti
' Perlu inc/conn.asp di-include dahulu
' ------------------------------------------------------------

' pemalar ADO (tiada adovbs.inc dalam server ini)
Const adCmdStoredProc = 4
Const adInteger = 3
Const adChar = 129
Const adVarChar = 200
Const adParamInput = 1

' tarikh -> 'yyyy-mm-dd' untuk SQL
Function TarikhSQL(d)
	TarikhSQL = Year(d) & "-" & Right("0" & Month(d), 2) & "-" & Right("0" & Day(d), 2)
End Function

' tarikh -> dd/mm/yyyy untuk paparan
Function PaparTarikh(d)
	If IsNull(d) Then
		PaparTarikh = "-"
	Else
		PaparTarikh = Right("0" & Day(d), 2) & "/" & Right("0" & Month(d), 2) & "/" & Year(d)
	End If
End Function

' teks dd/mm/yyyy -> tarikh. Pulang Null jika format salah
Function BacaTarikh(s)
	Dim a
	BacaTarikh = Null
	a = Split(Trim(s & ""), "/")
	If UBound(a) <> 2 Then Exit Function
	If Not (IsNumeric(a(0)) And IsNumeric(a(1)) And IsNumeric(a(2))) Then Exit Function
	On Error Resume Next
	BacaTarikh = DateSerial(CInt(a(2)), CInt(a(1)), CInt(a(0)))
	If Err.Number <> 0 Then
		BacaTarikh = Null
		Err.Clear
	End If
	On Error GoTo 0
End Function

' Tukar nilai decimal dari pangkalan data kepada nombor VBScript.
' ADO pulangkan lajur decimal sebagai Decimal, dan VBScript tidak boleh mengira dengannya.
Function Nombor(x)
	If IsNull(x) Then
		Nombor = 0
	Else
		Nombor = CDbl(x)
	End If
End Function

' nombor -> teks untuk SQL (elak koma perpuluhan)
Function AngkaSQL(x)
	AngkaSQL = Replace(CStr(x), ",", ".")
End Function

' buang tanda petik tunggal
Function Bersih(s)
	Bersih = Replace(s & "", "'", "''")
End Function

Function StatusLabel(s)
	Select Case Trim(s & "")
		Case "B"
			StatusLabel = "Baru"
		Case "L"
			StatusLabel = "Lulus"
		Case "T"
			StatusLabel = "Tolak"
		Case "X"
			StatusLabel = "Batal"
		Case Else
			StatusLabel = s
	End Select
End Function

' Kira hari bekerja antara dua tarikh.
' Sabtu, Ahad dan cuti umum (tblCutiUmum) tidak dikira.
Function KiraHariBekerja(dMula, dAkhir)
	Dim rsCU, dictCU, d, n
	Set dictCU = Server.CreateObject("Scripting.Dictionary")
	Set rsCU = conn.Execute("SELECT Tarikh FROM tblCutiUmum WHERE Tarikh BETWEEN '" & TarikhSQL(dMula) & "' AND '" & TarikhSQL(dAkhir) & "'")
	Do While Not rsCU.EOF
		dictCU(TarikhSQL(rsCU("Tarikh"))) = 1
		rsCU.MoveNext
	Loop
	rsCU.Close
	Set rsCU = Nothing

	n = 0
	d = dMula
	Do While d <= dAkhir
		If Weekday(d) <> 1 And Weekday(d) <> 7 Then
			If Not dictCU.Exists(TarikhSQL(d)) Then n = n + 1
		End If
		d = DateAdd("d", 1, d)
	Loop
	KiraHariBekerja = n
End Function

' Kod baki yang digunakan oleh sesuatu jenis cuti.
' Cuti Kecemasan (CK) ditolak daripada Cuti Tahunan (CT).
Function KodBaki(kod)
	If kod = "CK" Then
		KodBaki = "CT"
	Else
		KodBaki = kod
	End If
End Function

' Baki semasa = Kelayakan + BakiBawaHadapan - Diambil - permohonan yang belum diluluskan.
' Pulang Null jika jenis cuti tiada rekod baki (tiada had baki).
Function BakiSemasa(noStaf, tahun, kod)
	Dim rsB, kb, baki, sqlB
	kb = KodBaki(kod)
	BakiSemasa = Null

	Set rsB = conn.Execute("SELECT Kelayakan, BakiBawaHadapan, Diambil FROM tblBakiCuti WHERE NoStaf='" & noStaf & "' AND Tahun=" & tahun & " AND KodCuti='" & kb & "'")
	If rsB.EOF Then
		rsB.Close
		Set rsB = Nothing
		Exit Function
	End If
	baki = Nombor(rsB("Kelayakan")) + Nombor(rsB("BakiBawaHadapan")) - Nombor(rsB("Diambil"))
	rsB.Close

	sqlB = "SELECT ISNULL(SUM(BilHari),0) AS Jum FROM tblPermohonanCuti WHERE NoStaf='" & noStaf & "' AND Status='B' AND YEAR(TarikhMula)=" & tahun
	If kb = "CT" Then
		sqlB = sqlB & " AND KodCuti IN ('CT','CK')"
	Else
		sqlB = sqlB & " AND KodCuti='" & kb & "'"
	End If
	Set rsB = conn.Execute(sqlB)
	baki = baki - Nombor(rsB("Jum"))
	rsB.Close
	Set rsB = Nothing

	BakiSemasa = baki
End Function

' Simpan jejak audit
Sub CatatAudit(tindakan, butiran)
	conn.Execute "INSERT INTO tblAuditLog (NoStaf, Tindakan, Butiran, TarikhMasa, AlamatIP) VALUES ('" & Session("NoStaf") & "', '" & tindakan & "', '" & Bersih(Left(butiran, 255)) & "', GETDATE(), '" & Request.ServerVariables("REMOTE_ADDR") & "')"
End Sub
%>
