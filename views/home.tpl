<!DOCTYPE html>
<html>
<head>
	% include('bshead.tpl')
</head>

<body>

<div class="navi">
	% include('nav.tpl', apiKey=apiKey, title="Log In")
</div>

<div class="content">
	%if len(message)>0:
	<div class="alert alert-warning" role="alert">
		<p align="center"><b>{{message}}</b></p>
	</div>
	%end
<div align="center">
<h3>Welcome to the Alveo Query Engine</h3>

<h4>Here you can explore a large set of Australian linguistic data with over 800 participants and thousands of items to choose from.</h4>
<p>Start by using our easy to use search page to find all the participants relevant to your study. Then search for your desired words and sentences and easily export this data to the Alveo website</p>
%if apiKey!='Not logged in':
<a type="button" class="btn btn-default" href="/psearch"><h5>&nbsp;&nbsp;Click here to Start&nbsp;&nbsp;</h5></a>
%else:
<form action="/login" method="POST">
<p>Please enter your Alveo API key. This can be found on the <a href="https://app.alveo.edu.au/" target="_blank">Alveo website</a>
in the top right corner menu. Copy and paste the key here: </p>
<div class="input-group" style="width:25%;">
<input class="form-control" align="center" type="text" name="apikey">
<span class="input-group-btn">
	<button type="submit" value="Log in" class="btn btn-default">Submit</button>
</span>
</div>
</form>
%end

</div>
</div>


	% include('bsfoot.tpl')
</body>

</html>