<!DOCTYPE html>
<html>
<head>
	<title>Search Results</title>
	<link rel="stylesheet" type="text/css" href="/styles/style.css">
</head>

<body>

<form method="POST" action="/export">
 <input value="Export to Alveo" type="submit">
</form>

<p>Total matches: {{resultsCount}}</p>

%for i in range(0, len(partList)):
<p>Participant: <a href="{{partList[i]}}">{{partList[i]}}</a></p>
{{!resultsList[i]}}
%end

</body>

</html>