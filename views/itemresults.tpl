<!DOCTYPE html>
<html>
<head>
	<title>Item List</title>
	<link rel="stylesheet" type="text/css" href="/styles/style.css">
</head>

<body>

<div class="navi">
	% include('nav.tpl', apiKey=apiKey, title="Search Results")
</div>

<div class="content">
<form method="GET" action="/export">
 <input value="Export to Alveo" type="submit">
</form>

<p>Selected items: {{resultsCount}}</p>

<form action="/removeitems" method="POST">
	<input value="Remove Selected Items" type="submit">
%for i in range(0, len(partList)):
<p>Participant: <a href="{{partList[i]}}">{{partList[i]}}</a></p>
{{!resultsList[i]}}
%end
</form>
</div>
</body>

</html>