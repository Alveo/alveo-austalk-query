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
<form method="POST" action="/export">
 <input value="Export to Alveo" type="submit">
</form>

<p>Total matches: {{resultsCount}}</p>

%for i in range(0, len(partList)):
<p>Participant: <a href="{{partList[i]}}">{{partList[i]}}</a></p>
{{!resultsList[i]}}
%end
</div>
</body>

</html>