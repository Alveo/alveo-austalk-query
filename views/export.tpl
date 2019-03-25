%rebase("base-page")

<div class="progress mb-0 border bg-light" style="height: 20px;">
  <div class="progress-bar bg-warning" role="progressbar" style="width: 80%;" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100">Finally export your data as an Alveo Item List.</div>
</div>

<nav aria-label="breadcrumb mb-4 mt-0">
  <ol class="breadcrumb bg-light">
    <li class="breadcrumb-item"><a href="/psearch">Search Speakers</a></li>
    <li class="breadcrumb-item"><a href="/presults">Select Speakers</a></li>
    <li class="breadcrumb-item"><a href="/itemsearch">Search Items</a></li>
    <li class="breadcrumb-item"><a href="/itemresults">Select Items</a></li>
    <li class="breadcrumb-item active" aria-current="page">Export Selection</li>
  </ol>
</nav>

<h5>Selected {{itemCount}} Items</h5>
<p>To export to a New List, enter the new list name in the box and click 'Export to New List'. Or choose an existing Item List and click 'Add to Existing List'</p>
<p>When the export is complete, you'll be provided with a link to access the data so you can download it for analysis or export it to another system and analyse it.</p>
<p>"Export to New List" Will add to an existing item list if one with the same name already exists.</p>

<div class="row mb-3">
	<div class="col-md-6 col-sm-12 mb-3 search_form">
		<form method="POST" action="/export">
			<div class="card">
				<div class="card-header">
					<label for="listname"><b>Item List Name</b></label>
				</div>
				<div class="card-body">
					<div class="row">
						<div class="col-lg-6 col-md-12 mb-3">
							<input
							class="form-control" type="text" name="listname"
							placeholder="My new List">
						</div>
						<div class="col-lg-6 col-md-12 mb-3">
							<button type="submit" class="btn btn-light btn-block" name="submit" value="search">Export to New List</button>
						</div>
					</div>
				</div>
			</div>
			
		</form>
	</div>
	<div class="col-md-6 col-sm-12 mb-3 search_form">
		<form method="POST" action="/export">
			<div class="card">
				<div class="card-header">
					<label for="listname"><b>Existing Item Lists</b></label>
				</div>
				<div class="card-body">
					<div class="row">
						<div class="col-lg-6 col-md-12 mb-3">
							<select class="form-control" name="listname">
								% for list in itemLists['own']: 
									%lname = list.get('name','List Name Not Valid!')
									<option value="{{lname}}">{{lname}}</option> 
								% end 
							</select>
						</div>
						<div class="col-lg-6 col-md-12 mb-3">
							<button type="submit" class="btn btn-light btn-block" name="submit" value="search">Add to Existing List</button>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
</div>
	
<!-- Displaying this link may confuse people and they'll click it without exporting, keeping it here just incase for now -->
<!-- 
<a role="button" class="btn btn-light" href="https://app.alveo.edu.au/item_lists" target="_blank">Click here to go to the Alveo Website</a> 
 -->
<script type="text/javascript">
	$(document).ready(function() {
		$('.progress .progress-bar').css("width",function() {
			return $(this).attr("aria-valuenow")+"%";
		});
	});
</script>