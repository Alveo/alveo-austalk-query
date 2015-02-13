<!DOCTYPE html>
<html>
<head>
	<title>Search Results</title>
	<link rel="stylesheet" type="text/css" href="/styles/style.css">
</head>

<body>

<div class="navi">
	% include('nav.tpl', apiKey=apiKey, title="Search Results")
</div>

<div class="content">
<p>You can now search for items related to the selected participants, or select all items for this list of
participants.</p>
<p><b>Selecting items for large numbers of participants can take a long time (up to 15 minutes if selecting for
all participants). Please be patient.</b></p>
<table>
 <tr>
  <td>
	<form action="/itemresults" method="POST">
		<input value="Get All Items" type="submit">
	</form>
  </td>
  <td>
	<form action="/itemsearch" method="POST">
		<input value="Search Items" type="submit">
	</form>
  </td>
 </tr>
</table>

<p>Total matches: {{resultCount}}</p>

{{!resultsTable}}

</div>
</body>

</html>