<!DOCTYPE html>
<html>
<head>
	<title>Alveo Query Engine</title>
	<link rel="stylesheet" type="text/css" href="/styles/style.css">
</head>

<body>

<div class="navi">
	% include('nav.tpl', apiKey=apiKey, title="Log In")
</div>

<div class="content">
<p>Please enter your Alveo API key. This can be found on the <a href="https://app.alveo.edu.au/" target="_blank">Alveo website</a>
in the top right corner menu. Copy and paste the key here:<form action="/login" method="POST">
<input type="text" name="apikey"><input value="Log in" type="submit"></form></p>

<p>Your API key will be saved for this session only.</p>
</div>

</body>

</html>