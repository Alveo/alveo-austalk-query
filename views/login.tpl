<!DOCTYPE html>
<html>
<head>
	% include('bshead.tpl')
</head>

<body>

<div class="navi">
	% include('nav.tpl', apiKey=apiKey, title="Log In",loggedin=False)
</div>

<div class="content">
	%if len(message)>0:
	<div class="alert alert-warning" role="alert">
		<p align="center"><b>{{message}}</b></p>
	</div>
	%end
	
<p>Please enter your Alveo API key. This can be found on the <a href="https://app.alveo.edu.au/" target="_blank">Alveo website</a>
in the top right corner menu. Copy and paste the key here: </p>

<div align="center">
<form action="/login" method="POST">
<input class="form-control" align="center" style="width:20%;" type="text" name="apikey"><input value="Log in" type="submit">
</form>
</div>

<p>Your API key will be saved for this session only.</p>
</div>


	% include('bsfoot.tpl')
</body>

</html>
