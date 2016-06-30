<!DOCTYPE html>
<html>
<head>
	% include('bshead.tpl')
</head>

<body>

<div class="navi">
	% include('nav.tpl', apiKey=apiKey, title="PResults",loggedin=True)
</div>

<div class="content">
	%if len(message)>0:
		<div class="alert alert-warning" role="alert">
			<p><b>{{message}}</b></p>
		</div>
	%end
<h4>Number of Participants Found: {{resultCount}}</h4>
<p>You can now search for items related to the selected participants, or select all items for this list of
participants.</p>
<p><b>Selecting items for large numbers of participants can take a long time (up to 15 minutes if selecting for
all participants). Please be patient.</b></p>
<a type="button" class="btn btn-default" href="/download/participants.csv">Download all metadata as CSV</a>
<form action="/handleparts" method="POST" class="form-inline" role="form"><br>
	<div class="form-group" style="float:left;">
		<button type="button" class="btn btn-default" onClick="selectAll()"  >Select All</button>
		<button type="button" class="btn btn-default" onClick="selectNone()" >Select None</button>
	</div>
	<div class="form-group" style="float:right;">
		%if undo:
		<button type="submit" class="btn btn-default" name="submit" value="undo">Undo</button>
		%end
		<button type="submit" class="btn btn-default" name="submit" value="remove">Remove Selected</button>
		<button type="submit" class="btn btn-default" name="submit" value="search">Search Items From Selected</button>
	</div>
	
	<div class="rTable">
	
		<div class="rTableBody">
		
			<div class="rTableRow">
				<div class="rTableHead">Participant</div>
				<div class="rTableHead">Gender</div>
				<div class="rTableHead">Age</div>
				<div class="rTableHead">First Language</div>
				<div class="rTableHead">Recorded In</div>
				<div class="rTableHead">Birth City</div>
				<div class="rTableHead">Birth Country</div>
			</div>
		
			% for row in resultsList:
			<input name="selected" class="hideme" type="checkbox" id="{{row['id']}}" value="{{row['id']}}" />
				<label class="rTableRow" for="{{row['id']}}">
					<div class="rTableCellLeft"><b>{{row['id'].split('/')[-1]}}</b></div>
					<div class="rTableCell">{{row['gender']}}</div>
					<div class="rTableCell">{{row['age']}}</div>
					<div class="rTableCell">{{row['first_language']}}</div>
					<div class="rTableCell">{{row['city']}}</div>
					<div class="rTableCell">{{row['pob_town']}}</div>
					<div class="rTableCellRight">{{row['pob_country']}}</div>
				</label>
			% end
		</div>
	</div>
	
</form>

</div>
	% include('bsfoot.tpl')
</body>

</html>
