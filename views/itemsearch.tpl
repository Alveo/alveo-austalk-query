<!DOCTYPE html>
<html>
<head>
	<title>Search by Item</title>
	<link rel="stylesheet" type="text/css" href="/styles/style.css">
</head>

<body>

<div class="navi">
	% include('nav.tpl', apiKey=apiKey, title="Search Items")
</div>

<div class="content">
<div class="search_form">
<form action="/itemresults" method="POST">
<table>
 <tr>
  <td>
	Prompt: <input type="text" name="prompt">
  </td>
  <td>
	Component Type: <input type="text" name="compname">
 </tr>
 <tr>
  <td>
	<input value="Search" type="submit">
  </td>
 </tr>
</table>
</form>
</div>
<h2>Notes:</h2>

<p>Any fields left blank will not be used to filter results.</p>

<table>
	<tr>
	 <td><b>Prompt:</b></td>
	 <td>Example usage:<ul><li>Entering "hid" (without quotes) will return the prompts "hid" and "hide"</li>
						   <li>Entering "hid" (with quotes) will return ONLY the prompt "hid"</li>
						   <li>Entering "hid, hod" (without quotes) will return the prompts hode, hod, hid, hide, whod</li></ul></td>
	</tr>	
</div>
</body>

</html>