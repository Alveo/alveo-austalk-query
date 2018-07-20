%rebase("base-page")
<div align="center">
	<h4>Welcome to the Alveo Query Engine</h4>
	
	<h5>Here you can explore a large set of Australian linguistic data
		with over 800 Speakers and thousands of items to choose from.</h5>
	<p>Start by using our easy to use search page to find all the
		Speakers relevant to your study. Then search for your desired words
		and sentences and easily export this data to the Alveo website</p>
	%if name:
		<a role="button" class="btn btn-light my-3 px-4 py-2" href="/start?corpus=austalk"><h5>Click here to Start</h5></a>
		%if role.lower()=='admin':
			<br><br><br>
			<a role="button" class="btn btn-light my-2 px-4 py-2" href="/download/logs.csv"><h5>Download Latest Logs</h5></a>
		%end
	%else:
		<form action="/login" method="POST">
			<p>
				Please Log In with Alveo by clicking the button below. Read about or
				sign up at the <a href="https://app.alveo.edu.au/" target="_blank">Alveo website</a>.
			</p>
			<button type="submit" value="Log in" class="btn btn-light my-3 px-4 py-2"><h5>Login With Alveo</h5></button>

		</form>
	%end
</div>