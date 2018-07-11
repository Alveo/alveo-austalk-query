%rebase("base-page")
<div align="center">
	<h3>Welcome to the Alveo Query Engine</h3>
	
	<h4>Here you can explore a large set of Australian linguistic data
		with over 800 Speakers and thousands of items to choose from.</h4>
	<p>Start by using our easy to use search page to find all the
		Speakers relevant to your study. Then search for your desired words
		and sentences and easily export this data to the Alveo website</p>
	%if name:
		<a type="button" class="btn btn-default" href="/start?corpus=austalk"><h5>&nbsp;&nbsp;Click
				here to Start&nbsp;&nbsp;</h5></a>
		%if role.lower()=='admin':
			<br><br><br>
			<a type="button" class="btn btn-default" href="/download/logs.csv"><h5>&nbsp;&nbsp;Download 
			Latest Logs&nbsp;&nbsp;</h5></a>
		%end
	%else:
		<form action="/login" method="POST">
			<p>
				Please Log In with Alveo by clicking the button below. Read about or
				sign up at the <a href="https://app.alveo.edu.au/" target="_blank">Alveo
					website</a>.
			</p>
			<div class="input-group" style="width: 25%;">
				<span class="input-group-btn">
					<button type="submit" value="Log in" class="btn btn-default">Login
						With Alveo</button>
				</span>
			</div>
		</form>
	%end
</div>