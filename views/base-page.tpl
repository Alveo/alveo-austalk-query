%setdefault('page','home')
%setdefault('message','')
%setdefault('name',None)
%try:
	%from settings import BASE_URL
%except:
	%BASE_URL = ''
%end
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="description" content="Explore a large set of Australian linguistic data with over 800 speakers and thousands of items.">
	<meta name="author" content="The Alveo Project">
	<link href="https://app.alveo.edu.au/favicon.ico" rel="shortcut icon" type="image/vnd.microsoft.icon" />
	<title>Alveo Query Engine</title>
	<!-- Bootstrap core CSS -->
	<link href="/styles/bootstrap.min.css" rel="stylesheet">
	<!-- Bootstrap theme -->
	<link href="/styles/bootstrap-theme.min.css" rel="stylesheet">
	<!-- Font Awesome -->
	<link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" integrity="sha384-wvfXpqpZZVQGK6TAh5PVlGOfQNHSoD2xbE+QkPxCAFlNEevoEH3Sl0sibVcOQVnN" crossorigin="anonymous">
	<!-- Our Styles -->
	<link rel="stylesheet" type="text/css" href="/styles/style.css">
	<!-- Our Scripts -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
	<script>window.jQuery || document.write('<script src="js/jquery.min.js"><\/script>')</script>
	<script src="js/alveo.js" language="Javascript" type="text/javascript" ></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
</head>
<body>
	<div class="navi">
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
					<div class="navbar-left">
						<ul class="nav navbar-nav">
							<li {{!'class="active"' if page=='PSearch' else ''}}><a href="/psearch">Search Speakers</a></li>
							<li {{!'class="active"' if page=='PResults' else ''}}><a href="/presults">Speaker List</a></li>
							<li {{!'class="active"' if page=='ISearch' else ''}}><a href="/itemsearch">Search Items</a></li>
							<li {{!'class="active"' if page=='IResults' else ''}}><a href="/itemresults">Item List</a></li>
							<li {{!'class="active"' if page=='Export' else ''}}><a href="/export">Export</a></li>
						</ul>
					</div>
					<div class="navbar-right">
						<ul class="nav navbar-nav">
							%if name:
								<li class="nav-item dropdown">
									<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
							        	<i class="fa fa-user" aria-hidden="true"></i> {{name}} <span class="caret"></span>
							        </a>
									<ul class="dropdown-menu" aria-labelledby="navbarDropdown">
							        	<li><a class="dropdown-item" href="{{BASE_URL+'/item_lists'}}" target="_blank"><i class="fa fa-list" aria-hidden="true"></i> Your Lists</a></li>
							        	<li><a class="dropdown-item" href="/logout"><i class="fa fa-sign-out" aria-hidden="true"></i> Log out</a></li>
							        </ul>
								</li>
							%else:
								<li><a href="/login">Log in</a></li>
							%end
						</ul>
					</div>
				</div>
			</div>
		</nav>
	</div>

	<div class="container">
		<div class="content">
			%if len(message)>0:
				<div class="alert alert-warning alert-dismissible" role="alert">
					<button type="button" class="close" data-dismiss="alert" aria-label="Close">
				    	<span aria-hidden="true">&times;</span>
				  	</button>
				    <p align="center"><b>{{!message}}</b></p>
				</div>
			%end
			
		   	{{!base}}
	   	</div>
	</div>
	
	<div class="container">
	    <footer>
	    	<br><br>
	        <h4 style="color:#656565;text-align: center;">
	        	<img src="http://alveo.edu.au/wp-content/themes/hcsvlab/img/hcsvlab.png" />
	        	Alveo: Above and Beyond Speech, Language and Music, A Virtual Lab for Human Communication Science
	        </h4>
	    </footer>
	</div>
</body>

</html>