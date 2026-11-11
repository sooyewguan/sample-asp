// ------------------------------------------------------------
// Loader/d_loader.js : paparan "sila tunggu"
// ------------------------------------------------------------

function show_loader(msg) {
	if (msg === undefined || msg === null) {
		msg = "";
	}
	var lama = document.getElementById("pg-loader-container");
	if (lama !== null) {
		document.getElementById("pg-loader-lbl").innerHTML = msg;
		return;
	}
	var luar = document.createElement("div");
	luar.id = "pg-loader-container";
	luar.style.cssText = "position:fixed;top:0;left:0;width:100%;height:100%;background-color:#FFFFFF;opacity:.90;z-index:1001;text-align:center;padding-top:35vh;font-weight:bolder;font-size:16px;";
	var lbl = document.createElement("label");
	lbl.id = "pg-loader-lbl";
	lbl.innerHTML = msg;
	luar.appendChild(lbl);
	document.body.appendChild(luar);
}

function close_loader(fn) {
	var luar = document.getElementById("pg-loader-container");
	if (luar !== null) {
		document.body.removeChild(luar);
	}
	if (fn !== null && fn !== undefined) {
		fn();
	}
}
