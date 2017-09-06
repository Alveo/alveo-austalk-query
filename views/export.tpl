<!DOCTYPE html>
<html>
<head>
	% include('bshead.tpl')
</head>

<body>

<div class="navi">
	% include('nav.tpl', title="Export")
</div>

<div class="content">

%if len(message)>0:
	<div class="alert alert-warning" role="alert">
		<p align="center"><b>{{!message}}</b></p>
	</div>
%end

<h4>Number of Selected Items: {{itemCount}}</h4>
<p>Select an item list to add your selected items too or export to a new list </p>
<table>
<tr>
<td>
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
</div>
</td>
<td>
<div class="search_form">
<form method="POST" action="/export">
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
</td>
</tr>
</table>
<br>
<a type="button" class="btn btn-default" href="https://app.alveo.edu.au/item_lists" target="_blank">Click here to go to the Alveo Website</a>
<h2>Notes:</h2>

<p>"Export to New List" Will add to an existing item list if one with the same name already exists.</p>

</div>
	% include('bsfoot.tpl')
</body>

</html>
