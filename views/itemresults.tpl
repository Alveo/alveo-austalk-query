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
<form method="GET" action="/export">
 <input value="Export to Alveo" type="submit">
</form>

<p>Selected items: {{resultsCount}}</p>

<form action="/removeitems" method="POST">
	<input value="Remove Selected Items" type="submit">


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
</div>

</div>
</div>


% for row in partList:
<div class="rTable">
<div class="rTableBody">
            <div class="rTableRow" data-toggle="collapse" data-parent="#accordion" href="#{{row['participant'].split('/')[-1]}}">
              <div class="rTableCellLeft"><b>{{row['participant'].split('/')[-1]}}</b></div>
			  <div class="rTableCell">{{row['gender']}}</div>
			  <div class="rTableCell">{{row['age']}}</div>
			  <div class="rTableCell">{{row['city']}}</div>
			  <div class="rTableCell">{{row['btown']}}</div>
			  <div class="rTableCellRight">{{row['bcountry']}}</div>
            </div>

  </div>
</div>


     <div id="{{row['participant'].split('/')[-1]}}" class="panel-collapse collapse">
		% if isinstance(row['item_results'],str):
		<p><b>{{row['item_results']}}</b></p>
		% else:
		% for item in row['item_results']:
       <div class="rTable" style="width:97.5%;float:right;">
       <div class="rTableBody">

                   <div class="rTableRow">
                     <div class="rTableCellLeft" style="width:6%;"><input name="selected" type="checkbox" value="{{item['item']}}" /></div>
                     <div class="rTableCell" style="width:17%;"><b>{{item['item'].split('/')[-1]}}</b></div>
                     <div class="rTableCell" style="width:17%;">{{item['compname']}}</div>
                     <div class="rTableCellRight" style="width:60%;">{{item['prompt']}}</div>
                   </div>
         </div>
       </div>
       % end
       % end
       <p style="padding-left:50em; margin-top: 0em; margin-bottom: 0em;">&nbsp;</p>
     </div>
% end

</div>




<!--
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
		</div>
	  </div>
	</div>
	
	% for row in partList:
	<div class="rTable">
	  <div class="rTableBody">	

			<div class="rTableRow" data-toggle="collapse" data-parent="#accordion" href="#{{row['participant'].split('/')[-1]}}">
				<div class="rTableCellLeft"><b>{{row['participant'].split('/')[-1]}}</b></div>
				<div class="rTableCell">{{row['gender']}}</div>
				<div class="rTableCell">{{row['age']}}</div>
				<div class="rTableCell">{{row['city']}}</div>
				<div class="rTableCell">{{row['btown']}}</div>
				<div class="rTableCellRight">{{row['bcountry']}}</div>
			</div>
			
		</div>
    </div>
    <div id="#{{row['participant'].split('/')[-1]}}" class="panel-collapse collapse in">
          <div class="rTable" style="width:97.5%;float:right;">
            <div class="rTableBody">
               <div class="rTableRow">
                 <div class="rTableCellLeft"><b>item_1</b></div>
                 <div class="rTableCell">Some text</div>
                 <div class="rTableCell">some text</div>
                <div class="rTableCellRight">15</div>
              </div>
               
            </div>
          </div>
              
      <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
    </div>
    %end
    
  </div>
 --> 
</form>
</div>
	% include('bsfoot.tpl')	 
</body>
</html>
