<%
' ------------------------------------------------------------
' inc/conn.asp : sambungan ke pangkalan data
' 12/03/2011 - asal
' 04/09/2018 - tukar server baru
' ------------------------------------------------------------
Dim conn, strConn

strConn = "Provider=SQLOLEDB;Data Source=localhost,1433;Initial Catalog=LegacyDb;User ID=workshop_app;Password=TUKAR_KATA_LALUAN_DI_SINI;"

Set conn = Server.CreateObject("ADODB.Connection")
conn.ConnectionTimeout = 15
conn.CommandTimeout = 30
conn.Open strConn
%>
