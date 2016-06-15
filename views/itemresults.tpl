<!DOCTYPE html>
<html>
<head>
	% include('bshead.tpl')	
</head>

<body>


<div class="navi">
	% include('nav.tpl', apiKey=apiKey, title="IResults",loggedin=True)
</div>


<div class="content">
	%if len(message)>0:
		<div class="alert alert-warning" role="alert">
			<p><b>{{message}}</b></p>
		</div>
	%end
	
<h4>Number of Items found: {{resultsCount}}</h4>
<p>You can now browse all the items found by your search. Click on the participants to expand a list of all their recordings.</p>
<form action="/removeitems" method="POST">

	<div class="form-group" style="float:left;">
		<button type="button" class="btn btn-default" onClick="selectAll()"  >Select All</button>
		<button type="button" class="btn btn-default" onClick="selectNone()" >Select None</button>
		<button type="button" class="btn btn-default" onClick="toggleExpand()" >Toggle Collapse</button>
	</div>
	<div class="form-group" style="float:right;">
		%if undo:
		<button type="submit" class="btn btn-default" name="submit" value="undo">Undo</button>
		%end
		<button type="submit" class="btn btn-default" name="submit" value="remove">Remove Selected</button>
		<form method="GET" action="/export">
		<button type="submit" class="btn btn-default" name="submit" value="search">Export Selected</button>
		</form>
	</div>

<div class="panel-group" id="accordion">

<div class="rTable">
<div class="rTableBody">

<div class="rTableRow">
  <div class="rTableHead">Participant</div>
  <div class="rTableHead">Gender</div>
  <div class="rTableHead">Age</div>
  <div class="rTableHead">Recorded In</div>
  <div class="rTableHead">Birth City</div>
  <div class="rTableHead">Birth Country</div>
  <div class="rTableHead">No. Results</div>
</div>

</div>
</div>


% for row in partList:
<div class="rTable">
<div class="rTableBody">
            <div name="participant" class="rTableRow" data-toggle="collapse" data-parent="#accordion" href="#{{row['id'].split('/')[-1]}}">
              <div class="rTableCellLeft"><b>{{row['id'].split('/')[-1]}}</b></div>
			  <div class="rTableCell">{{row['gender']}}</div>
			  <div class="rTableCell">{{row['age']}}</div>
			  <div class="rTableCell">{{row['city']}}</div>
			  <div class="rTableCell">{{row['pob_town']}}</div>
			  <div class="rTableCell">{{row['pob_country']}}</div>
			  <div class="rTableCellRight">{{len(row['item_results'])}}</div>
            </div>

  </div>
</div>


     <div id="{{row['id'].split('/')[-1]}}" class="panel-collapse collapse">
		% if len(row['item_results'])==0:
		<p><b>No search results.</b></p>
		% else:
		% for item in row['item_results']:
       <div class="rTable" style="width:97.5%;float:right;">
       <div class="rTableBody">
				   <input name="selected" class="hideme" type="checkbox" id="{{item['item']}}" value="{{item['item']}}" />
                   <label class="rTableRow" for="{{item['item']}}">
                     <div class="rTableCellLeft" style="width:15%;"><b>{{item['item'].split('/')[-1]}}</b></div>
                     <div class="rTableCell" style="width:15%;">{{item['compname']}}</div>
                     <div class="rTableCellRight" style="width:70%;">{{item['prompt']}}</div>
                   </label>
         </div>
       </div>
       % end
       % end
       <p style="padding-left:50em; margin-top: 0em; margin-bottom: 0em;">&nbsp;</p>
     </div>
% end

</div>


</form>
</div>
	% include('bsfoot.tpl')	 
</body>
</html>
