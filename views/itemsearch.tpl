<!DOCTYPE html>
<html>
<head>
	% include('bshead.tpl')
	
	<script>
		$(document).ready(function(){
			$('[name="componentName"]').click(function(){
				if($('[name=componentName]').val()!=""){
					$.ajax({url: "/itemsearch/sentences?sentence="+$('[name=componentName]').val(), async: true, success: function(result){
						$('[name="prompt"]').html(result);
					}});
					$('[name="prompt"]').html('<option value="">Loading Results...</option>\n');
				}
			});
		});
	</script>
</head>

<body>

<div class="navi">
	% include('nav.tpl', apiKey=apiKey, title="ISearch",loggedin=True)
</div>

<div class="content">
	%if len(message)>0:
		<div class="alert alert-warning" role="alert">
			<p><b>{{message}}</b></p>
		</div>
	%end

<form action="/itemresults" method="POST" style="width:98%;margin:auto;">
	<br><p style="font: 15px arial, sans-serif;">Here you can search for your desired participants. Click on each of the headings to expand all the available criteria.<br>When you are done click submit and you'll be provided with a list of participants fulfilling your criteria.</p>
	<button type="submit" style="float:right;" class="btn btn-default">Submit</button><br><br>
	<div class="panel-group" id="accordion" >
		<div class="panel panel-default">
			<div class="panel-heading" data-toggle="collapse" data-parent="#accordion" href="#gitem">
				<h4 class="panel-title">Search by Prompt</h4>
			</div>
			<div id="gitem" class="panel-collapse collapse in">
				<div class="panel-body">
					<table>
						<tr>
							<td class="left">
								<label for="prompt"><b>Prompt:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="prompt" id="prompt" placeholder="animal">
								</div>
							</td>
							<td class="right">
								<p>You can search for individual words by entering them in this search box. You can also use SPARQL's regular expression syntax. Some examples, '.' is a wildcard character, '*' matches 0-many of the previous expression. Partial searches can also work using "^" and/or "$" at the beginning and the end respectively. Searches are not case-sensitive. More information is below.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="anno"><b>Annotated Items Only:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<div class="btn-group" data-toggle="buttons" id="anno" name="anno">
										<label class="btn btn-custom">
											<input type="radio" value = "required" id="anno" name="anno" autocomplete="off">True
										</label>
										<label class="btn btn-custom active">
											<input type="radio" value = "" id="anno" name="anno" autocomplete="off" checked>False
										</label>
									</div>
								</div>
							</td>
							<td class="right">
								<p>Select true to show only items with annotations</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="wlist"><b>Word List:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select class="form-control" name="wlist">
										<option value="">None</option>
										<option value="hvdwords">hVd Words</option>
										<option value="hvdmono">hVd Monophthongs</option>
										<option value="hvddip">hVd Diphthongs</option>
									</select>
								</div>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		<div class="panel panel-default">
			<div class="panel-heading" data-toggle="collapse" data-parent="#accordion" href="#gcomp">
				<h4 class="panel-title">Search by Component</h4>
			</div>
			<div id="gcomp" class="panel-collapse collapse">
				<div class="panel-body">
					<table>
						<tr>
							<td class="left">
								<label for="componentName"><b>Component:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select class="form-control" name="componentName">
										<option value="">Any</option>
										<option value="calibration">calibration</option>
										<option value="digits">digits</option>
										<option value="sentences">sentences</option>
										<option value="sentences-e">sentences-e</option>
										<option value="story">story</option>
										<option value="words-1">words-1</option>
										<option value="words-1-2">words-1-2</option>
										<option value="words-2">words-2</option>
										<option value="words-2-2">words-2-2</option>
										<option value="words-3">words-3</option>
										<option value="words-3-2">words-3-2</option>
										<option value="yes-no-closing">yes-no-closing</option>
										<option value="yes-no-opening-1">yes-no-opening-1</option>
										<option value="yes-no-opening-2">yes-no-opening-2</option>
										<option value="yes-no-opening-3">yes-no-opening-3</option>
									</select>
								</div>
							</td>
							<td class="right">
								<p>Here you can select a component to search by or you can select the component which contains your desired sentence, then select the sentence from below.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="comptype"><b>Component Type:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select class="form-control" name="comptype">
										<option value="">Any</option>
										<option value="sentences">Sentences</option>
										<option value="yes-no">Yes-No</option>
										<option value="words">Words</option>
										<option value="digits">Digits</option>
										<option value="interview">Interview</option>
										<option value="maptask">Maptask</option>
										<option value="calibration">Calibration</option>
										<option value="story">Story</option>
										<option value="conversation">Conversation</option>
									</select>
								</div>
							</td>
							<td class="right">
								<p>Here you can easily select groups of components that work well together</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="prototype"><b>Prototype:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="prototype" id="prototype" placeholder="16_5">
								</div>
							</td>
							<td class="right">
								<p>Here you can specify any specific sentence by it's prototype code. It is the last 2 segments of the items id.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="prompt"><b>Sentences:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select class="form-control" name="prompt">
										<option value="">Any</option>
									</select>
								</div>
							</td>
							<td class="right">
								<p>Select the individual prompts you wish to use.</p>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div> 
	<button type="submit" style="float:right;" class="btn btn-default">Submit</button>
</form>


<h2>Notes:</h2>

<p>Any fields left blank will not be used to filter results.</p>

<table>
	<tr>
	 <td><b>Prompt/Component:</b></td>
	 <td>Example usage:<ul><li>Entering "hid" (without quotes) will return the prompts "hid" and "hide"</li>
						   <li>Entering "hid" (with quotes) will return ONLY the prompt "hid"</li>
						   <li>Entering "hid, hod" (without quotes) will return the prompts hode, hod, hid, hide, whod</li></ul>
		<p>You can also use SPARQL's regular expression syntax ('.' is a wildcard character, '*' matches 0-many of the previous expression, etc.). Searches are not case-sensitive.</p></td>
	</tr>
	<tr>
	<td><b>Component/Component Type:</b></td>
	<td>Using the Component field you can search for a specific component if desired (i.e, "yes-no-opening-2".<br>
	The Component Type drop-down menu will select by a broader category of components (all "yes-no" type components.</td>
	</tr>
</div>
	% include('bsfoot.tpl')
</body>

</html>
