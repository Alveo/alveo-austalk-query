<!DOCTYPE html>
<html>
<head>
	% include('bshead.tpl')
</head>

<body>

<div class="navi">
	% include('nav.tpl', logged_in=logged_in, title="Log In")
</div>

<div class="content">
	%if len(message)>0:
	<div class="alert alert-warning" role="alert">
		<p align="center"><b>{{!message}}</b></p>
	</div>
	%end
<div align="center">
<h3>Welcome to the Alveo Query Engine</h3>

<h4>Here you can explore a large set of Australian linguistic data with over 800 participants and thousands of items to choose from.</h4>
<p>Start by using our easy to use search page to find all the participants relevant to your study. Then search for your desired words and sentences and easily export this data to the Alveo website</p>
%if logged_in:
<a type="button" class="btn btn-default" href="/start?corpus=austalk"><h5>&nbsp;&nbsp;Click here to Start&nbsp;&nbsp;</h5></a>
%else:
<form action="/login" method="POST">
<p>Please Log In with Alveo by clicking the button below. Read about or sign up at the <a href="https://app.alveo.edu.au/" target="_blank">Alveo website</a>.</p>
<div class="input-group" style="width:25%;">
<span class="input-group-btn">
	<button type="submit" value="Log in" class="btn btn-default">Login With Alveo</button>
</span>
</div>
</form>
%end


</div>
</div>


	% include('bsfoot.tpl')
</body>

</html>