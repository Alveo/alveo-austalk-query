%rebase("base-page")
<br>
<h4>Found {{resultCount}} Speakers.</h4>

<p>Click on the speakers you wish to select, then click "Search Items From Selected Speakers". 
If you wish to select all speakers minus a few, select the speakers you wish to remove, then click 
"Remove Selected Speakers". When you have your desired list, click "Select All Speakers" and then 
"Search Items from Selected Speakers"</p>

<a type="button" class="btn btn-default" href="/download/speakers.csv">Download all Speaker metadata as CSV</a>
<form action="/handleparts" method="POST" class="form-inline" role="form"><br>
	<div class="form-group" style="float:left;">
		<button type="button" class="btn btn-default" onClick="selectAll()"  >Select All Speakers</button>
		<button type="button" class="btn btn-default" onClick="selectNone()" >Select None</button>
	</div>
	<div class="form-group" style="float: right;">
		%if undo:
		<button type="submit" class="btn btn-default" name="submit"
			value="undo">Undo</button>
		%end
		<button type="submit" class="btn btn-default" name="submit"
			value="remove">Remove Selected Speakers</button>
		<button type="submit" class="btn btn-default" name="submit"
			value="search">Search Items From Selected Speakers</button>
	</div>


	<table class="table table-bordered table-hover">
		<thead>
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
	
	<div class="form-group" style="float: right;">
		%if undo:
		<button type="submit" class="btn btn-default" name="submit"
			value="undo">Undo</button>
		%end
		<button type="submit" class="btn btn-default" name="submit"
			value="remove">Remove Selected Speakers</button>
		<button type="submit" class="btn btn-default" name="submit"
			value="search">Search Items From Selected Speakers</button>
	</div>


</form>
<script type="text/javascript">

	$('#resultsTable').on('click', '.clickable-row', function(event) {
		var item = $("#" + $(this).attr('id').substring(4));
		console.log(item);
		if ($(this).hasClass("active")) {
			$(this).removeClass('active');
			item.prop('checked', false);
		} else {
			$(this).addClass('active');
			item.prop('checked', true);
		}
	});

	function selectAll() {
		$("[name='clickable']").prop("checked", true);
		$(".clickable-row").addClass("active");
	}
	function selectNone() {
		$("[name='clickable']").prop("checked", false);
		$(".clickable-row").removeClass("active");
	}
</script>