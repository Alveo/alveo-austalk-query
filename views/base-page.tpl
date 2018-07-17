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
	<link href="/media/favicon.ico" rel="shortcut icon" type="image/vnd.microsoft.icon" />
	<title>Alveo Query Engine</title>
		
	<!-- Bootstrap core CSS -->
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.2/css/bootstrap.min.css" integrity="sha384-Smlep5jCw/wG7hdkwQ/Z5nLIefveQRIY9nfy6xoR1uRYBtpZgI6339F5dgvm/e9B" crossorigin="anonymous">
	
	<!-- Font Awesome -->
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.1.0/css/all.css" integrity="sha384-lKuwvrZot6UHsBSfcMvOkWwlCMgc0TaWr+30HWe3a4ltaBwTZhyTEggF5tJv8tbt" crossorigin="anonymous">

	<!-- Our Styles -->
	<link rel="stylesheet" type="text/css" href="/styles/style.css">
	
	<!-- JS Files -->
	<script src="https://code.jquery.com/jquery-3.3.1.min.js" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.2/js/bootstrap.min.js" integrity="sha384-o+RDsa0aLu++PJvFqy8fFScvbHFLtbvScb8AjopnFD+iEQ7wo/CG0xlczd+2O/em" crossorigin="anonymous"></script>
	<script src="js/alveo.js" language="Javascript" type="text/javascript" ></script>
</head>
<body>
	<nav class="navbar navbar-dark navbar-expand-lg navi">
	
		<a class="navbar-brand" href="/">
			<img src="media/alveo-logo.png" width="30" height="30" class="d-inline-block align-top" alt="">
			Alveo Query Engine
		</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse"
			data-target="#navbarSupportedContent"
			aria-controls="navbarSupportedContent" aria-expanded="false"
			aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>
		
		<div class="collapse navbar-collapse" id="navbarSupportedContent">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item {{!'active' if page=='PSearch' else ''}}">
					<a class="nav-link" href="/psearch"><i class="fas fa-search"></i> Speakers</a>
				</li>
				<li class="nav-item {{!'active' if page=='PResults' else ''}}">
					<a class="nav-link" href="/presults"><i class="fas fa-list"></i> Speaker List</a>
				</li>
				<li class="nav-item {{!'active' if page=='ISearch' else ''}}">
					<a class="nav-link" href="/itemsearch"><i class="fas fa-search"></i> Items</a>
				</li>
				<li class="nav-item {{!'active' if page=='IResults' else ''}}">
					<a class="nav-link" href="/itemresults"><i class="fas fa-list"></i> Item List</a>
				</li>
				<li class="nav-item {{!'active' if page=='Export' else ''}}">
					<a class="nav-link" href="/export"><i class="fas fa-file-export"></i> Export</a>
				</li>
			</ul>
			<ul class="navbar-nav mr-0">
				%if name:
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				        	<i class="fa fa-user" aria-hidden="true"></i> {{name}} <span class="caret"></span>
				        </a>
						<ul class="dropdown-menu" aria-labelledby="navbarDropdown">
				        	<li><a class="dropdown-item" href="{{BASE_URL+'/item_lists'}}" target="_blank"><i class="fas fa-list" aria-hidden="true"></i> Your Lists</a></li>
				        	<li><a class="dropdown-item" href="/logout"><i class="fas fa-sign-out-alt" aria-hidden="true"></i> Log out</a></li>
				        </ul>
					</li>
				%else:
					<li><a class="nav-link" href="/login">Log in</a></li>
				%end
			</ul>
		</div>
	</nav>

	<div class="container">
		<div class="content mt-4">
			%if len(message)>0:
				<div class="alert alert-warning alert-dismissible fade show" role="alert">
					<button type="button" class="close" data-dismiss="alert" aria-label="Close">
				    	<span aria-hidden="true">&times;</span>
				  	</button>
				    <p class="mb-0" align="center"><b>{{!message}}</b></p>
				</div>
			%end
			
		   	{{!base}}
	   	</div>
	</div>
	
	<div class="container">
	    <footer>
	    	<br><br>
	        <h5 class="text-muted" style="text-align: center;">
	        	<img src="/media/alveo-logo-sm.png" />
	        	Alveo: Above and Beyond Speech, Language and Music, A Virtual Lab for Human Communication Science
	        </h5>
	    </footer>
	</div>
	
</body>

</html>