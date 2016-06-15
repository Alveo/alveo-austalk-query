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
