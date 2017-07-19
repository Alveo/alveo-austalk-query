//For Select All/None/Toggle
function selectAll() {
  checkboxes = document.getElementsByName('selected');
  for(var i=0, n=checkboxes.length;i<n;i++) {
    checkboxes[i].checked = true;
  }
}
function selectNone() {
  checkboxes = document.getElementsByName('selected');
  for(var i=0, n=checkboxes.length;i<n;i++) {
    checkboxes[i].checked = false;
  }
}
//for expanding and collaping bootstrap accordion's
function toggleExpand() {
	accordions = document.getElementsByName('participant');
	for(var i=0, n=accordions.length;i<n;i++) {
		accordions[i].click();
	}
}
function expandAll() {
	accordions = document.getElementsByName('participant');
	for(var i=0, n=accordions.length;i<n;i++) {
		accordions[i].click();
	}
}
function collapseAll() {
	accordions = document.getElementsByName('participant');
	for(var i=0, n=accordions.length;i<n;i++) {
		accordions[i].click();
	}
}

function handleAudioError(e) {
	OAF = $('[name="OAF"]')
	start = '<div class="alert alert-warning" role="alert"><p align="center"><b>'
	end = '</b></p></div>'
	switch (e.target.error.code) {
		case e.target.error.MEDIA_ERR_ABORTED:
			OAF.html(start+'One or more Audio files failed to load. The audio playback was aborted.'+end);
			break;
		case e.target.error.MEDIA_ERR_NETWORK:
			OAF.html(start+'One or more Audio files failed to load. A network error caused the audio download to fail.'+end);
			break;
		case e.target.error.MEDIA_ERR_DECODE:
			OAF.html(start+'One or more Audio files failed to load. The audio playback was aborted due to corruption in the file'+end);
			break;
		case e.target.error.MEDIA_ERR_SRC_NOT_SUPPORTED:
			OAF.html('<form action="/login" method="POST">'+start+'One or more Audio files failed to load. Please <a href="#" onclick="this.parentNode.parentNode.parentNode.parentNode.submit()">Log in to Alveo</a> again in order to access the audio files.'+end+'</form>');
			break;
		default:
			OAF.html(start+'One or more Audio files failed to load.'+end);
		break;
	}
}

