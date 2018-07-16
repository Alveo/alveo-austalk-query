%rebase("base-page")
<br>
<h4>Found {{resultCount}} Speakers.</h4>

<p>Click on the speakers you wish to select, then click "Search Items From Selected Speakers". 
If you wish to select all speakers minus a few, select the speakers you wish to remove, then click 
"Remove Selected Speakers". When you have your desired list, click "Select All Speakers" and then 
"Search Items from Selected Speakers"</p>

<a role="button" class="btn btn-light my-2" href="/download/speakers.csv"><i class="fas fa-file-download"></i> Download all Speaker metadata as CSV</a>
<form action="/handleparts" method="POST" role="form">
	<div class="d-flex flex-row my-2">
		<button type="button" class="btn btn-light p-2 mx-2" onClick="selectAll()"  >Select All Speakers</button>
		<button type="button" class="btn btn-light p-2 mx-2 mr-auto" onClick="selectNone()" >Select None</button>
		%if undo:
		<button type="submit" class="btn btn-light p-2 mx-2" name="submit" value="undo">Undo</button>
		%end
		<button type="submit" class="btn btn-light p-2 mx-2" name="submit" value="remove">Remove Selected Speakers</button>
		<button type="submit" class="btn btn-light p-2 mx-2" name="submit" value="search">Search Items From Selected Speakers</button>
	</div>

	<table class="table table-bordered table-hover table-responsive-md">
		<thead class="thead-light">
			<tr>
				<th>Speaker</th>
				<th>Gender</th>
				<th>Age</th>
				<th>First Language</th>
				<th>Recording Site</th>
				<th>Birth City</th>
				<th>Birth Country</th>
			</tr>
		</thead>
		<tbody id="resultsTable">
			% for row in resultsList:
			%id = row['id'].split('/')[-1]
			<input name="clickable"  class="hideme" type="checkbox" id="{{id}}" value="{{row['id']}}" />
			<tr class="clickable-row" id="row-{{id}}">
				<td><b>{{id}}</b></td>
				<td>{{row['gender']}}</td>
				<td>{{row['age']}}</td>
				<td>{{row['first_language']}}</td>
				<td>{{row['institution']}}</td>
				<td>{{row['pob_town']}}</td>
				<td>{{row['pob_country']}}</td>
			</tr>
			% end
		</tbody>
	</table>
	
	<div class="d-flex flex-row my-2">
		<button type="button" class="btn btn-light p-2 mx-2" onClick="selectAll()"  >Select All Speakers</button>
		<button type="button" class="btn btn-light p-2 mx-2 mr-auto" onClick="selectNone()" >Select None</button>
		%if undo:
		<button type="submit" class="btn btn-light p-2 mx-2" name="submit" value="undo">Undo</button>
		%end
		<button type="submit" class="btn btn-light p-2 mx-2" name="submit" value="remove">Remove Selected Speakers</button>
		<button type="submit" class="btn btn-light p-2 mx-2" name="submit" value="search">Search Items From Selected Speakers</button>
	</div>


</form>
<script type="text/javascript">

	$('#resultsTable').on('click', '.clickable-row', function(event) {
		var item = $("#" + $(this).attr('id').substring(4));
		if ($(this).hasClass("table-secondary")) {
			$(this).removeClass('table-secondary');
			item.prop('checked', false);
		} else {
			$(this).addClass('table-secondary');
			item.prop('checked', true);
		}
	});

	function selectAll() {
		$("[name='clickable']").prop("checked", true);
		$(".clickable-row").addClass("table-secondary");
	}
	function selectNone() {
		$("[name='clickable']").prop("checked", false);
		$(".clickable-row").removeClass("table-secondary");
	}
</script>