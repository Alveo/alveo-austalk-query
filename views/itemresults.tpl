%rebase("base-page")
%import pycountry
<div name="OAF"></div>

<div class="progress mb-0 border bg-light" style="height: 20px;">
  <div class="progress-bar bg-warning" role="progressbar" style="width: 60%;" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100">Now Further Narrow your Selection</div>
</div>

<nav aria-label="breadcrumb mb-4 mt-0">
  <ol class="breadcrumb bg-light">
    <li class="breadcrumb-item"><a href="/psearch">Search Speakers</a></li>
    <li class="breadcrumb-item"><a href="/presults">Select Speakers</a></li>
    <li class="breadcrumb-item"><a href="/itemsearch">Search Items</a></li>
    <li class="breadcrumb-item active" aria-current="page">Select Items</li>
  </ol>
</nav>

<h4>Found {{resultsCount}} Items</h4>
<p>You can now browse all the items found by your search. Click on
	the Speakers to expand a list of all their recordings.</p>

<a role="button" class="btn btn-light my-2" href="/download/items.csv"><i class="fas fa-file-download"></i> Download item metadata as CSV</a>
<a role="button" class="btn btn-light my-2" href="/download/itemswithpartdata.csv"><i class="fas fa-file-download"></i> Download item metadata as CSV with speaker data</a>

<form action="/handleitems" method="POST">
	<div class="d-flex flex-row my-2">
		<button type="button" class="btn btn-light p-2 mx-2" onClick="selectAll()">Select All</button>
		<button type="button" class="btn btn-light p-2 mx-2 mr-auto" onClick="selectNone()">Select None</button>
		%if undo:
		<button type="submit" class="btn btn-light p-2 mx-2" name="submit" value="undo">Undo</button>
		%end
		<button type="submit" class="btn btn-light p-2 mx-2" name="submit" value="remove">Remove Selected</button>
		<button type="submit" class="btn btn-light p-2 mx-2" name="submit" value="export">Export Selected</button>
	</div>
	
	<div class="row">
		<div id="speakerList" class="col-lg-5 col-md-6 mb-4">
			% for speaker in partList:
				% itemCount = len(speaker['item_results'])
				<div class="card mb-2" id="s-{{speaker['id'].split('/')[-1]}}">
					<div class="card-header p-2">
						<div class="d-flex flex-row align-items-center">
							<h5 class="m-1">{{speaker['id'].split('/')[-1]}}</h5>
							<button type="button" {{'disabled' if itemCount==0 else ''}} class="btn btn-secondary px-2 py-1 my-0 px-4 ml-auto" onClick="viewSpeaker('{{speaker['id'].split('/')[-1]}}')">View &nbsp; <i class="fas fa-caret-right"></i></button>
						</div>
						
					</div>
					<div class="card-body py-1">
						<div class="row">
							<div class="col-sm-5">
								<b>Gender:</b>
							</div>
							<div class="col-sm-7">
								{{speaker['gender']}}
							</div>
						</div>
						<div class="row">
							<div class="col-sm-5">
								<b>Age:</b>
							</div>
							<div class="col-sm-7">
								{{speaker['age']}}
							</div>
						</div>
						<div class="row">
							<div class="col-sm-5">
								<b>First Language:</b>
							</div>
							<div class="col-sm-7">
								{{speaker['first_language']}}
							</div>
						</div>
						<div class="row">
							<div class="col-sm-5">
								<b>Institution:</b>
							</div>
							<div class="col-sm-7">
								{{speaker['institution']}}
							</div>
						</div>
						<div class="row">
							<div class="col-sm-5">
								<b>Birth City:</b>
							</div>
							<div class="col-sm-7">
								{{speaker['pob_town']}}
							</div>
						</div>
						<div class="row">
							<div class="col-sm-5">
								<b>Birth Country:</b>
							</div>
							<div class="col-sm-7">
							%try:
							{{pycountry.countries.get(alpha_2=speaker['pob_country']).name}}
							%except KeyError:
							{{speaker['pob_country']}}
							%end
							</div>
						</div>
						<div class="row">
							<div class="col-sm-5">
								<b>No. Results:</b>
							</div>
							<div class="col-sm-7">
								<b>{{itemCount}}</b>
							</div>
						</div>
						%for item in speaker['item_results']:
							<input name="selected" class="hideme" type="checkbox" id="{{item['item'].split('/')[-1]}}" value="{{item['item']}}" />
						%end
					</div>
				</div>
			%end
		</div>
		<div id="itemList" class="col-lg-7 col-md-6 mb-4">
			
		</div>
	</div>

	<div class=accordion" id="accordion">

		% for row in partList:

		<div id="{{row['id'].split('/')[-1]}}" class="panel-collapse collapse">
			% if len(row['item_results'])==0:
			<p>
				<b>No search results.</b>
			</p>
			% else: 
			% for item in row['item_results']:
			<div class="rTable" style="width: 97.5%; float: right;">
				<div class="rTableBody">
					
					<label
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
		<button type="button" class="btn btn-light p-2 mx-2 mr-auto" onClick="selectNone()">Select None</button>
		%if undo:
		<button type="submit" class="btn btn-light p-2 mx-2" name="submit" value="undo">Undo</button>
		%end
		<button type="submit" class="btn btn-light p-2 mx-2" name="submit" value="remove">Remove Selected</button>
		<button type="submit" class="btn btn-light p-2 mx-2" name="submit" value="export">Export Selected</button>
	</div>

</form>
<script type="text/javascript">
	
	var speakerItems = {};
	%for speaker in partList:
		speakerItems["{{speaker['id'].split('/')[-1]}}"] = [];
		%for item in speaker['item_results']:
			speakerItems["{{speaker['id'].split('/')[-1]}}"].push({
													"componentName":"{{item['componentName']}}",
													"item":"{{item['item']}}",
													"itemEnd":"{{item['item'].split("/")[-1]}}",
													"prompt":"{{item['prompt']}}",
													"media":"{{item['media']}}",
													});
		%end
	%end
	
	function viewSpeaker(id){
		var items = speakerItems[id];
		$("#itemList").empty();
		var card = "";
		var item;
		var checked;
		var checkedText="";
		for(i=0;i<items.length;i++){
			item = items[i];
			checked = $("#"+item["itemEnd"]).prop("checked");
			checkedText="";
			if(checked){
				checkedText="bg-secondary";
			}
			card = `<div class="card mb-2 itemCard" name="`+item["itemEnd"]+`"><div class="card-header p-1 `+checkedText+`"><div class="d-flex flex-row align-items-center">
			<h6 class="m-0">`+item["itemEnd"]+`</h6><h6 class="m-0 ml-auto">`+item["componentName"]+`</h6></div></div><div class="card-body py-1">
			<p class="mb-0">`+item["prompt"]+`</p></div></div>`;
			
			$("#itemList").append(card);
		}
	}
		
	$('#itemList').on('click','.card',function(event) {
		var checkbox = $("#"+$(this).attr('name'));
		var bg = $(this).find(".card-header");
		if (bg.hasClass("bg-secondary")) {
			bg.removeClass('bg-secondary');
			checkbox.prop('checked', false);
		} else {
			bg.addClass('bg-secondary');
			checkbox.prop('checked', true);
		}
	});
	
	function selectAll() {
		$("[name='selected']").prop("checked", true);
		$(".itemCard .card-header").addClass("bg-secondary");
	}
	function selectNone() {
		$("[name='selected']").prop("checked", false);
		$(".itemCard .card-header").removeClass("bg-secondary");
	}
	
	$(document).ready(function() {
		$('.progress .progress-bar').css("width",function() {
			return $(this).attr("aria-valuenow")+"%";
		});
		viewSpeaker($("#speakerList :first-child").prop("id").substr(2));
	});
</script>
