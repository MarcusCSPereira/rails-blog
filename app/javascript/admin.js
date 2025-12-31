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

function initMarkdownEditor() {
	const markdownButton = document.getElementById('markdown-button');
	
	if (markdownButton) {
		markdownButton.addEventListener('click', (event) => {
			event.preventDefault();
			const el = document.querySelector('textarea');
			const stackedit = new Stackedit();

			// Open the iframe
			stackedit.openFile({
				name: 'Filename', // with an optional filename
				content: {
					text: el.value // and the Markdown content.
				}
			});

			// Listen to StackEdit events and apply the changes to the textarea.
			stackedit.on('fileChange', (file) => {
				el.value = file.content.text;
			});
		});
	}
}

// Initialize markdown editor when DOM is ready
if (document.readyState === 'loading') {
	document.addEventListener('DOMContentLoaded', initMarkdownEditor);
} else {
	initMarkdownEditor();
}