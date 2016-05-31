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
<p>You can now search for items related to the selected participants, or select all items for this list of
participants.</p>
<p><b>Selecting items for large numbers of participants can take a long time (up to 15 minutes if selecting for
all participants). Please be patient.</b></p>
<table>
 <tr>
  <td>
	<form action="/itemresults" method="POST">
		<input value="Get All Items" type="submit">
	</form>
  </td>
  <td>
	<form action="/itemsearch" method="POST">
		<input value="Search Items" type="submit">
	</form>
  </td>
 </tr>
</table>

<p>Selected participants: {{resultCount}}</p>

<form action="/removeparts" method="POST">
	<input value="Remove Selected Participants" type="submit">

	<div class="rTable">
	
		<div class="rTableBody">
		
			<div class="rTableRow">
				<div class="rTableHead">Participant</div>
				<div class="rTableHead">Gender</div>
				<div class="rTableHead">Age</div>
				<div class="rTableHead">Recorded In</div>
				<div class="rTableHead">Birth City</div>
				<div class="rTableHead">Birth Country</div>
			</div>
		
			% for row in resultsList:
			<input name="selected" class="hideme" type="checkbox" id="{{row['participant']}}" value="{{row['participant']}}" />
				<label class="rTableRow" for="{{row['participant']}}">
					<div class="rTableCellLeft"><b>{{row['participant'].split('/')[-1]}}</b></div>
					<div class="rTableCell">{{row['gender']}}</div>
					<div class="rTableCell">{{row['age']}}</div>
					<div class="rTableCell">{{row['city']}}</div>
					<div class="rTableCell">{{row['btown']}}</div>
					<div class="rTableCellRight">{{row['bcountry']}}</div>
				</label>
			% end
		</div>
	</div>
</form>

</div>
	% include('bsfoot.tpl')
</body>

</html>
