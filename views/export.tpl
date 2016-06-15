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
	<label for="listname"><b>Item List Name: </b></label><input class="form-control"  type="text" name="listname" placeholder="My new List">
  </td>
  <td>
   <br><button type="submit" class="btn btn-default" style="float:right;" name="submit" value="search">Export to New List</button>
  </td>
 </tr>
</table>
</form>
<form method="POST" action="/export">
<br>
<table>
 <tr>
  <td>
	<label for="listname"><b>Existing Item Lists: </b></label><select class="form-control" name="listname">
	% for list in itemLists['own']:
	% name = list['name']
		<option value="{{name}}">{{name}}</option>
	% end
  </td>
  <td>
   <br><button type="submit" class="btn btn-default" style="float:right;" name="submit" value="search">Add to Existing List</button>
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
