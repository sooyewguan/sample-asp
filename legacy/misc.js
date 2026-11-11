// ------------------------------------------------------------
// misc.js : fungsi JavaScript umum e-Cuti
// ------------------------------------------------------------

function sahKeluar() {
	return confirm("Anda Ingin Keluar Dari e-Cuti?");
}

function sahBatal() {
	return confirm("Anda pasti untuk membatalkan permohonan ini?");
}

// semak format hh/bb/tttt
function tarikhSah(s) {
	var re = /^\d{1,2}\/\d{1,2}\/\d{4}$/;
	return re.test(s);
}

function semakBorangCuti() {
	var f = document.frmCuti;
	if (f.selJenis.value == "") {
		alert("Sila pilih jenis cuti");
		f.selJenis.focus();
		return false;
	}
	if (!tarikhSah(f.txtMula.value)) {
		alert("Tarikh mula tidak sah. Format hh/bb/tttt");
		f.txtMula.focus();
		return false;
	}
	if (!tarikhSah(f.txtAkhir.value)) {
		alert("Tarikh akhir tidak sah. Format hh/bb/tttt");
		f.txtAkhir.focus();
		return false;
	}
	if (f.selJenis.value != "CT" && f.txtSebab.value == "") {
		alert("Sila isi sebab / catatan");
		f.txtSebab.focus();
		return false;
	}
	if (f.txtSebab.value.length > 255) {
		alert("Sebab / catatan tidak boleh melebihi 255 aksara");
		f.txtSebab.focus();
		return false;
	}
	if (typeof show_loader == "function") { show_loader("Sila tunggu..."); }
	return true;
}

function semakBorangLulus() {
	var f = document.frmLulus;
	var pilih = "";
	for (var i = 0; i < f.radKeputusan.length; i++) {
		if (f.radKeputusan[i].checked) { pilih = f.radKeputusan[i].value; }
	}
	if (pilih == "") {
		alert("Sila pilih keputusan");
		return false;
	}
	if (pilih == "T" && f.txtCatatan.value == "") {
		alert("Catatan wajib diisi jika permohonan ditolak");
		f.txtCatatan.focus();
		return false;
	}
	return true;
}
