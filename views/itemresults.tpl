%rebase("base-page")
<div name="OAF"></div>

<div class="progress mb-0 border bg-light" style="height: 20px;">
  <div class="progress-bar bg-warning" role="progressbar" style="width: 80%;" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100">Now Further Narrow your Selection</div>
</div>

<nav aria-label="breadcrumb mb-4 mt-0">
  <ol class="breadcrumb bg-light">
    <li class="breadcrumb-item"><a href="/psearch">Search Speakers</a></li>
    <li class="breadcrumb-item"><a href="/presults">Select Speakers</a></li>
    <li class="breadcrumb-item"><a href="/itemsearch">Search Items</a></li>
    <li class="breadcrumb-item active" aria-current="page">Select Items</li>
  </ol>
</nav>

<h4>Number of Items found: {{resultsCount}}</h4>
<p>You can now browse all the items found by your search. Click on
	the Speakers to expand a list of all their recordings.</p>

<a role="button" class="btn btn-light my-2" href="/download/items.csv"><i class="fas fa-file-download"></i> Download item metadata as CSV</a>
<a role="button" class="btn btn-light my-2" href="/download/itemswithpartdata.csv"><i class="fas fa-file-download"></i> Download item metadata as CSV with speaker data</a>

<form action="/handleitems" method="POST">
	<div class="d-flex flex-row my-2">
		<button type="button" class="btn btn-light p-2 mx-2" onClick="selectAll()">Select All</button>
		<button type="button" class="btn btn-light p-2 mx-2" onClick="selectNone()">Select None</button>
		<button type="button" class="btn btn-light p-2 mx-2 mr-auto" onClick="toggleExpand()">Toggle Collapse</button>
		%if undo:
		<button type="submit" class="btn btn-light p-2 mx-2" name="submit" value="undo">Undo</button>
		%end
		<button type="submit" class="btn btn-light p-2 mx-2" name="submit" value="remove">Remove Selected</button>
		<button type="submit" class="btn btn-light p-2 mx-2" name="submit" value="export">Export Selected</button>
	</div>

	<div class=accordion" id="accordion">

		<div class="rTable">
			<div class="rTableBody">

				<div class="rTableRow">
					<div class="rTableHead" style="width: 12%;">Speaker</div>
					<div class="rTableHead" style="width: 12%;">Gender</div>
					<div class="rTableHead" style="width: 12%;">Age</div>
					<div class="rTableHead">First Language</div>
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
				<div name="speaker" class="rTableRow" data-toggle="collapse"
					data-parent="#accordion" href="#{{row['id'].split('/')[-1]}}">
					<div class="rTableCellLeft" style="width: 12%;">
						<b>{{row['id'].split('/')[-1]}}</b>
					</div>
					<div class="rTableCell" style="width: 12%;">{{row['gender']}}</div>
					<div class="rTableCell" style="width: 12%;">{{row['age']}}</div>
					<div class="rTableCell">{{row['first_language']}}</div>
					<div class="rTableCell">{{row['institution']}}</div>
					<div class="rTableCell">{{row['pob_town']}}</div>
					<div class="rTableCell">{{row['pob_country']}}</div>
					<div class="rTableCellRight">{{len(row['item_results'])}}</div>
				</div>

			</div>
		</div>


		<div id="{{row['id'].split('/')[-1]}}" class="panel-collapse collapse">
			% if len(row['item_results'])==0:
			<p>
				<b>No search results.</b>
			</p>
			% else: 
			% for item in row['item_results']:
			<div class="rTable" style="width: 97.5%; float: right;">
				<div class="rTableBody">
					<input name="selected" class="hideme" type="checkbox"
						id="{{item['item']}}" value="{{item['item']}}" /> <label
						class="rTableRow" for="{{item['item']}}">
						<div class="rTableCellLeft" style="width: 10%;">
							<b>{{item['item'].split('/')[-1]}}</b>
						</div>
						<div class="rTableCell" style="width: 10%;">{{item['componentName']}}</div>
						<div class="rTableCellRight" style="width: 80%;">{{item['prompt']}}</div>
					</label>
				</div>
			</div>
			% end 
			% end
			<p style="padding-left: 50em; margin-top: 0em; margin-bottom: 0em;">&nbsp;</p>
		</div>
		% end

	</div>

	<div class="d-flex flex-row my-2">
		<button type="button" class="btn btn-light p-2 mx-2" onClick="selectAll()">Select All</button>
		<button type="button" class="btn btn-light p-2 mx-2" onClick="selectNone()">Select None</button>
		<button type="button" class="btn btn-light p-2 mx-2 mr-auto" onClick="toggleExpand()">Toggle Collapse</button>
		%if undo:
		<button type="submit" class="btn btn-light p-2 mx-2" name="submit" value="undo">Undo</button>
		%end
		<button type="submit" class="btn btn-light p-2 mx-2" name="submit" value="remove">Remove Selected</button>
		<button type="submit" class="btn btn-light p-2 mx-2" name="submit" value="export">Export Selected</button>
	</div>

</form>

