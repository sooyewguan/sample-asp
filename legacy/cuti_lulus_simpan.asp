<%@ Language=VBScript %>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/fungsi.asp"-->
<!--#include file="inc/semak_sesi.asp"-->
<%
' ------------------------------------------------------------
' cuti_lulus_simpan.asp : simpan keputusan Lulus / Tolak
' 08/08/2016 - guna stored procedure sp_LulusCuti (kemaskini baki sekali)
' ------------------------------------------------------------
Dim rs, sql, id, keputusan, catatan, noStafMohon, penyelia, kod, dMula, baki, cmd

If Session("Peranan") <> "P" And Session("Peranan") <> "A" Then
	Response.Write "Anda tiada kebenaran untuk skrin ini."
	Response.End
End If

id = Request.Form("hidId")
keputusan = Request.Form("radKeputusan")
catatan = Left(Trim(Request.Form("txtCatatan")), 255)

Sub Balik(mesej)
	conn.Close
	Response.Redirect "cuti_lulus.asp?msg=" & Server.URLEncode(mesej)
End Sub

If Not IsNumeric(id) Then Call Balik("Permohonan tidak sah.")
If keputusan <> "L" And keputusan <> "T" Then Call Balik("Sila pilih keputusan.")
If keputusan = "T" And catatan = "" Then Call Balik("Catatan wajib diisi jika permohonan ditolak.")

sql = "SELECT p.NoStaf, p.KodCuti, p.TarikhMula, p.Status, s.NoStafPenyelia FROM tblPermohonanCuti p, tblStaf s WHERE p.NoStaf = s.NoStaf AND p.IdPermohonan=" & id
Set rs = conn.Execute(sql)
If rs.EOF Then
	rs.Close
	Call Balik("Permohonan tidak dijumpai.")
End If
If Trim(rs("Status")) <> "B" Then
	rs.Close
	Call Balik("Permohonan ini telah diproses.")
End If
noStafMohon = Trim(rs("NoStaf"))
penyelia = Trim(rs("NoStafPenyelia") & "")
kod = Trim(rs("KodCuti"))
dMula = rs("TarikhMula")
rs.Close
Set rs = Nothing

' pelulus tidak boleh luluskan cuti sendiri
If noStafMohon = Session("NoStaf") Then Call Balik("Anda tidak boleh memproses permohonan cuti sendiri.")

' penyelia hanya untuk staf di bawah seliaan. Pentadbir boleh semua.
If Session("Peranan") = "P" And penyelia <> Session("NoStaf") Then Call Balik("Permohonan ini bukan di bawah seliaan anda.")

' semak baki sekali lagi sebelum lulus (baki sudah tolak permohonan ini)
If keputusan = "L" Then
	baki = BakiSemasa(noStafMohon, Year(dMula), kod)
	If Not IsNull(baki) Then
		If baki < 0 Then Call Balik("Baki cuti pemohon tidak mencukupi. Permohonan tidak boleh diluluskan.")
	End If
End If

Set cmd = Server.CreateObject("ADODB.Command")
Set cmd.ActiveConnection = conn
cmd.CommandText = "sp_LulusCuti"
cmd.CommandType = adCmdStoredProc
cmd.Parameters.Append cmd.CreateParameter("@IdPermohonan", adInteger, adParamInput, , CLng(id))
cmd.Parameters.Append cmd.CreateParameter("@NoStafPelulus", adVarChar, adParamInput, 10, Session("NoStaf"))
cmd.Parameters.Append cmd.CreateParameter("@Keputusan", adChar, adParamInput, 1, keputusan)
cmd.Parameters.Append cmd.CreateParameter("@Catatan", adVarChar, adParamInput, 255, catatan)

On Error Resume Next
cmd.Execute
If Err.Number <> 0 Then
	Response.Write "<b>Ralat simpan keputusan:</b> " & Err.Description
	Response.End
End If
On Error GoTo 0
Set cmd = Nothing

If keputusan = "L" Then
	Call CatatAudit("LULUS", "Permohonan #" & id & " (" & noStafMohon & ") diluluskan")
Else
	Call CatatAudit("TOLAK", "Permohonan #" & id & " (" & noStafMohon & ") ditolak")
End If

conn.Close
Set conn = Nothing
Response.Redirect "cuti_lulus.asp?msg=" & Server.URLEncode("Keputusan telah disimpan.")
%>
