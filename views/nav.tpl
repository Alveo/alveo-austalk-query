%setdefault('name',None)
<nav class="navbar navbar-default">
	<div class="container">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="/">Alveo Query Engine</a>
		</div>
		<div class="navbar-collapse collapse">
			<ul class="nav navbar-nav">
			{{!'<li class="active"><a href="/psearch">Search Speakers</a></li>' if title=='PSearch' else '<li><a href="/psearch">Search Participants</a></li>'}}
			{{!'<li class="active"><a href="/presults">Speaker List</a></li>' if title=='PResults' else '<li><a href="/presults">Participant List</a></li>'}}
			{{!'<li class="active"><a href="/itemsearch">Search Items</a></li>' if title=='ISearch' else '<li><a href="/itemsearch">Search Items</a></li>'}}
			{{!'<li class="active"><a href="/itemresults">Item List</a></li>' if title=='IResults' else '<li><a href="/itemresults">Item List</a></li>' }}
			{{!'<li class="active"><a href="/export">Export</a></li>' if title=='Export' else '<li><a href="/export">Export</a></li>'}}
			{{!'<li><a href="/logout">Log out</a></li>' if name else '<li><a href="/">Log in</a></li>'}}
			<li><a>{{name if name else 'Not Logged In'}}</a></li>
			</ul>
		</div>
	</div>
</nav>
