<!DOCTYPE html>
<html>
<head>
	<title>Export to Alveo</title>
	<link rel="stylesheet" type="text/css" href="/styles/style.css">
</head>

<body>

<div class="navi">
	% include('nav.tpl', apiKey=apiKey, title="Export to Alveo")
</div>

<div class="content">
<form method="POST" action="/export">
<table>
 <tr>
  <td>
	Item List Name: <input type="text" name="listname">
  </td>
  <td>
   <input value="Export" type="submit">
  </td>
 </tr>
</table>
</form>
</div>
</body>

</html>