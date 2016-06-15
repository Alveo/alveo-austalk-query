<!DOCTYPE html>
<html>
<head>
	% include('bshead.tpl')
</head>

<body>

<div class="navi">
	% include('nav.tpl', apiKey=apiKey, title="Export",loggedin=True)
</div>

<div class="content">
<div class="search_form">
<form method="POST" action="/export">
<table>
 <tr>
  <td>
	Item List Name: <input type="text" name="listname">
  </td>
  <td>
   <input value="Export to New List" type="submit">
  </td>
 </tr>
</table>
</form>
<form method="POST" action="/export">
<br>
<table>
 <tr>
  <td>
	Existing Item Lists: <select name="listname">
	% for list in itemLists['own']:
	% name = list['name']
	<option value="{{name}}">{{name}}</option>
	% end
  </td>
  <td>
   <input value="Add to Existing List" type="submit">
  </td>
 </tr>
</table>
</form>
</div>

<h2>Notes:</h2>

<p>"Export to New List" Will add to an existing item list if one with the same name already exists.</p>

</div>
	% include('bsfoot.tpl')
</body>

</html>
