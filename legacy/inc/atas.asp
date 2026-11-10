<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>e-Cuti</title>
<link rel="stylesheet" href="css/style.css">
<script language="javascript" src="misc.js"></script>
<script type="text/javascript" src="Loader/d_loader.js"></script>
</head>
<body>
<div class="kepala">
	<span class="kepala-tajuk">e-Cuti : Sistem Permohonan Cuti Kakitangan</span>
	<span class="kepala-pengguna">
		<strong id="textNamaUser"><%=Session("Nama")%></strong> (<%=Session("NoStaf")%>) | <%=Session("NamaJabatan")%>
	</span>
</div>
<div class="sisi">
	<ul class="menu">
		<li><a href="usr_welcome.asp">Utama</a></li>
		<li><a href="cuti_mohon.asp">Mohon Cuti</a></li>
		<li><a href="cuti_senarai.asp">Senarai Permohonan</a></li>
<% If Session("Peranan") = "P" Or Session("Peranan") = "A" Then %>
		<li><a href="cuti_lulus.asp">Kelulusan Cuti</a></li>
<% End If %>
<% If Session("Peranan") = "A" Then %>
		<li><a href="lap_baki.asp">Laporan Baki Cuti</a></li>
<% End If %>
		<li><a href="logout.asp?cara=Biasa" onclick="return sahKeluar();">Keluar</a></li>
	</ul>
</div>
<div class="kandungan">
