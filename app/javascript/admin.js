adminMenu();

var ADMIN_NAV_CLOSED_CLASS="menu-closed";

function getBody() {
	return document.getElementsByTagName("body")[0];
}

function closeAdminMenu() {
	var body = getBody();
	if (body) {
		body.classList.remove(ADMIN_NAV_CLOSED_CLASS);
	}
}

function openAdminMenu() {
	var body = getBody();
	if (body) {
		body.classList.add(ADMIN_NAV_CLOSED_CLASS);
	}
}


function adminMenu() {
	var button = document.getElementById("adminMenuButton");
	var body = getBody();
	if (button && body) {
		button.addEventListener("click", function () {
			if (body.classList.contains(ADMIN_NAV_CLOSED_CLASS)) {
				closeAdminMenu();
			} else {
				openAdminMenu();
			}
		});
	}
}

function updateFileName(input, displayId) {
	var fileNameDisplay = document.getElementById(displayId);
	if (input.files && input.files.length > 0) {
		var fileName = input.files[0].name;
		if (fileNameDisplay) {
			fileNameDisplay.textContent = "Arquivo selecionado: " + fileName;
			fileNameDisplay.style.display = "block";
		}
	} else {
		if (fileNameDisplay) {
			fileNameDisplay.style.display = "none";
		}
	}
}