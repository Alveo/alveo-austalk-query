%rebase("base-page")
<h4>Number of Selected Items: {{itemCount}}</h4>
<p>To export to a New List, enter the new list name in the box and click 'Export to New List'. Or choose an existing Item List and click 'Add to Existing List'</p>
<table>
	<tr>
		<td>
			<div class="search_form">
				<form method="POST" action="/export">
					<table>
						<tr>
							<td><label for="listname"><b>Item List Name: </b></label><input
								class="form-control" type="text" name="listname"
								placeholder="My new List"></td>
							<td><br>
								<button type="submit" class="btn btn-default"
									style="float: right;" name="submit" value="search">Export
									to New List</button></td>
						</tr>
					</table>
				</form>
			</div>
		</td>
		<td>
			<div class="search_form">
				<form method="POST" action="/export">
					<table>
						<tr>
							<td><label for="listname"><b>Existing Item
										Lists: </b></label><select class="form-control" name="listname">
									% for list in itemLists['own']: 
									% name = list['name']
									<option value="{{name}}">{{name}}</option> 
									% end 
									</td>
							<td><br>
								<button type="submit" class="btn btn-default"
									style="float: right;" name="submit" value="search">Add
									to Existing List</button></td>
						</tr>
					</table>
				</form>
			</div>
		</td>
	</tr>
</table>
<br>
<a type="button" class="btn btn-default"
	href="https://app.alveo.edu.au/item_lists" target="_blank">Click
	here to go to the Alveo Website</a>
<h2>Notes:</h2>

<p>"Export to New List" Will add to an existing item list if one
	with the same name already exists.</p>
