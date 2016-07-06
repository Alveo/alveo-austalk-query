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
			OAF.html(start+'You aborted the video playback.'+end);
			break;
		case e.target.error.MEDIA_ERR_NETWORK:
			OAF.html(start+'A network error caused the audio download to fail.'+end);
			break;
		case e.target.error.MEDIA_ERR_DECODE:
			OAF.html(start+'The audio playback was aborted due to corruption in the file'+end);
			break;
		case e.target.error.MEDIA_ERR_SRC_NOT_SUPPORTED:
			OAF.html(start+'Please <a href="https://app.alveo.edu.au/" target="_blank">login to Alveo</a> then refreash this page to play the audio file.'+end);
			break;
		default:
			OAF.html(start+'An Error has occured, cannot play audio files.'+end);
		break;
	}
}

