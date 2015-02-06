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
 <tr>
  <td>
   <p><b>WARNING: Selecting all items for many participants can take a very long time.</b></p>
   <p>Up to 1 minute for 50 participants, up to 15 minutes for 800 participants.</p>
</table>

<p>Total matches: {{resultCount}}</p>

{{!resultsTable}}

</body>

</html>