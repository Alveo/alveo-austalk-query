<!DOCTYPE html>
<html>
<head>
	% include('bshead.tpl')
</head>

<body>

<div class="navi">
	% include('nav.tpl', logged_in=logged_in, title="Log In",)
</div>

<div class="content">
	%if len(message)>0:
	<div class="alert alert-warning" role="alert">
		<p align="center"><b>{{message}}</b></p>
	</div>
	%end
	
<p>Please Log in with Alveo by clicking the button below. Read about or sign up at the <a href="https://app.alveo.edu.au/" target="_blank">Alveo website</a>.</p>

<div align="center">
<form action="/login" method="POST">
<input value="Log in with Alveo" type="submit">
</form>
</div>

</div>


	% include('bsfoot.tpl')
</body>

</html>
