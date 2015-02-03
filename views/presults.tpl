<!DOCTYPE html>
<html>
<head>
	<title>Search Results</title>
	<link rel="stylesheet" type="text/css" href="/styles/style.css">
</head>

<body>

<h1>Search Results</h1>

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

</body>

</html>