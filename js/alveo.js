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