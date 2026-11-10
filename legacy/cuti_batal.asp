<%@ Language=VBScript %>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/fungsi.asp"-->
<!--#include file="inc/semak_sesi.asp"-->
<%
' ------------------------------------------------------------
' cuti_batal.asp : batal permohonan cuti sendiri
' Baru  -> terus batal
' Lulus -> boleh batal sebelum tarikh mula, baki dipulangkan
' ------------------------------------------------------------
Dim rs, sql, id, st, mesej, kod, bil, dMula, jumpa

id = Request.QueryString("id")

sql = "SELECT IdPermohonan, NoStaf, KodCuti, TarikhMula, BilHari, Status FROM tblPermohonanCuti WHERE IdPermohonan=" & id & " AND NoStaf='" & Session("NoStaf") & "'"
Set rs = conn.Execute(sql)

jumpa = Not rs.EOF
If jumpa Then
	st = Trim(rs("Status"))
	kod = Trim(rs("KodCuti"))
	bil = rs("BilHari")
	dMula = rs("TarikhMula")
End If
rs.Close
Set rs = Nothing

If Not jumpa Then
	mesej = "Rekod tidak dijumpai."
ElseIf st = "B" Then
	conn.Execute "UPDATE tblPermohonanCuti SET Status='X' WHERE IdPermohonan=" & id
	Call CatatAudit("BATAL", "Permohonan #" & id & " dibatalkan (belum lulus)")
	mesej = "Permohonan telah dibatalkan."
ElseIf st = "L" And dMula > Date Then
	conn.Execute "UPDATE tblPermohonanCuti SET Status='X' WHERE IdPermohonan=" & id
	' pulangkan baki
	conn.Execute "UPDATE tblBakiCuti SET Diambil = Diambil - " & AngkaSQL(bil) & " WHERE NoStaf='" & Session("NoStaf") & "' AND Tahun=" & Year(dMula) & " AND KodCuti='" & kod & "'"
	Call CatatAudit("BATAL", "Permohonan #" & id & " dibatalkan (telah lulus)")
	mesej = "Permohonan telah dibatalkan dan baki cuti dipulangkan."
Else
	mesej = "Permohonan ini tidak boleh dibatalkan."
End If

conn.Close
Set conn = Nothing

Response.Redirect "cuti_senarai.asp?msg=" & Server.URLEncode(mesej)
%>
