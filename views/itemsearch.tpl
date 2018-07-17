%rebase("base-page")

<div class="progress mb-4" style="height: 20px;">
  <div class="progress-bar bg-warning" role="progressbar" style="width: 60%;" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100">Now you can Search for Items, Prompts or Components</div>
</div>

<p>Here you can search for any relevant items. Click on each of the headings to expand all the available criteria.</p>
<p>When you are done click submit and you'll be provided with a list of speakers fulfilling your search criteria.</p>

<form action="/itemresults" method="POST">
	
	<div class="d-flex flex-row-reverse">
		<button type="submit"class="btn btn-light py-2 px-4 m-3">Submit</button>
	</div>

	<div class="accordion" id="accordion" >
		<div class="card">
			<div class="card-header" data-toggle="collapse" data-parent="#accordion" href="#gcomp">
				<h5 class="mb-0">Search by Component</h5>
			</div>
			<div id="gcomp" class="panel-collapse collapse">
				<div class="card-body">
						<div class="row mb-3">
							<div class="col-lg-2 col-md-6 col-xs-12">
								<label for="comptype"><b>Component Type:</b></label>
							</div>
							<div class="col-lg-3 col-md-6 col-xs-12">
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
							</div>
							<div class="col-lg-7 col-md-12 col-xs-12">
								<p>Here you can easily select groups of components that work well together</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-2 col-md-6 col-xs-12">
								<label for="componentName"><b>Component Number:</b></label>
							</div>
							<div class="col-lg-3 col-md-6 col-xs-12">
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
							</div>
							<div class="col-lg-7 col-md-12 col-xs-12">
								<p>Here you can select a component to search by or you can select the component which contains your desired item, then select the item from below.</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-2 col-md-6 col-xs-12">
								<label for="prototype"><b>Prototype:</b></label>
							</div>
							<div class="col-lg-3 col-md-6 col-xs-12">
								<div class="form-group">
									<input type="text" class="form-control" name="prototype" id="prototype" placeholder="16_5">
								</div>
							</div>
							<div class="col-lg-7 col-md-12 col-xs-12">
								<p>Here you can specify any specific item by it's prototype code. It is the last 2 segments of the items id.</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-2 col-md-6 col-xs-12">
								<label for="fullprompt"><b>Prompt within Component:</b></label>
							</div>
							<div class="col-lg-3 col-md-6 col-xs-12">
								<div class="form-group">
									<select class="form-control" name="fullprompt">
										<option value="">Any</option>
									</select>
								</div>
							</div>
							<div class="col-lg-7 col-md-12 col-xs-12">
								<p>Select the individual prompts within a component selected above you wish to use.
								<i class="far fa-question-circle" data-toggle="tooltip" data-html="true" 
								title="<p>You must first select a component number before selecting a prompt.</p>"></i>
								</p>
							</div>
						</div>
					
				</div>
			</div>
		</div>
		<div class="card">
			<div class="card-header" data-toggle="collapse" data-parent="#accordion" href="#gitem">
				<h5 class="mb-0">Search by Prompt</h5>
			</div>
			<div id="gitem" class="panel-collapse collapse in">
				<div class="card-body">
					
						<div class="row mb-3">
							<div class="col-lg-2 col-md-6 col-xs-12">
								<label for="prompt"><b>Prompt:</b></label>
							</div>
							<div class="col-lg-3 col-md-6 col-xs-12">
								<div class="form-group">
									<input type="text" class="form-control" name="prompt" id="prompt" placeholder="animal">
								</div>
							</div>
							<div class="col-lg-7 col-md-12 col-xs-12">
								<p>This filter supports Regular Expressions. 
								<i class="far fa-question-circle" data-toggle="tooltip" data-html="true" 
								title="<p>You can search for individual speakers by entering their speaker id's. You can also use 
								SPARQL's regular expression syntax. Some examples, '.' is a wildcard character, '*' matches 0-many 
								of the previous expression. Partial searches can also work using '^' and/or '$' at the beginning and the 
								end respectively. Searches are not case-sensitive. More information on it's special usage is below.</p>"></i>
								</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-2 col-md-6 col-xs-12">
								<label for="anno"><b>Annotated Items Only:</b></label>
							</div>
							<div class="col-lg-3 col-md-6 col-xs-12">
								<div class="form-group">
									<div class="btn-group btn-group-toggle" data-toggle="buttons" id="anno" name="anno">
										<label class="btn btn-light active">
											<input type="radio" value = "" id="anno" name="anno" autocomplete="off" checked>Either
										</label>
										<label class="btn btn-light">
											<input type="radio" value = "required" id="anno" name="anno" autocomplete="off">Yes
										</label>
										<label class="btn btn-light">
											<input type="radio" value = "" id="anno" name="anno" autocomplete="off">No
										</label>
									</div>
								</div>
							</div>
							<div class="col-lg-7 col-md-12 col-xs-12">
								<p>Select Yes to show only items with annotations</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-2 col-md-6 col-xs-12">
								<label for="wlist"><b>Predefined Word List:</b></label>
							</div>
							<div class="col-lg-3 col-md-6 col-xs-12">
								<div class="form-group">
									<select class="form-control" name="wlist">
										<option value="">None</option>
										<option value="hvdwords">hVd Words</option>
										<option value="hvdmono">hVd Monophthongs</option>
										<option value="hvddip">hVd Diphthongs</option>
									</select>
								</div>
							</div>
							<div class="col-lg-7 col-md-12 col-xs-12">
								<p>You can choose one of the pre-defined Word Lists, where all the items match a specific pattern. <br>
								<a href="https://austalk.edu.au/sites/default/files/IS11-AusTalk.pdf" target="_blank">Click here for more information.</a></div>
								</p>
							</div>
						</div>
					
				</div>
			</div>
		</div>
	</div> 
	
	<div class="d-flex flex-row-reverse">
		<button type="submit"class="btn btn-light py-2 px-4 m-3">Submit</button>
	</div>
</form>

<br><br>

<h5>Notes:</h5>

<div class="row mb-3">
	<div class="col-md-3 col-sm-12"><b>Prompt/Component:</b></div>
	<div class="col-md-9 col-sm-12">Example usage:<ul><li>Entering "hid" (without quotes) will return the prompts "hid" and "hide"</li>
					   <li>Entering "hid" (with quotes) will return ONLY the prompt "hid"</li>
					   <li>Entering "hid, hod" (without quotes) will return the prompts hode, hod, hid, hide, whod</li></ul>
	<p>You can also use SPARQL's regular expression syntax ('.' is a wildcard character, '*' matches 0-many of the previous expression, etc.). Searches are not case-sensitive.</p></div>
</div>
<div class="row mb-3">
	<div class="col-md-3 col-sm-12"><b>Predefined Word Lists:</b></div>
	<div class="col-md-9 col-sm-12">You can choose one of the pre-defined Word Lists, where all the items match a specific pattern (see Burnham et al. (2011) "Building an Audio-Visual Corpus of Australian English: Large Corpus Collection with an Economical Portable and Replicable Black Box". Interspeech 2011.<br>
		<a href="https://austalk.edu.au/sites/default/files/IS11-AusTalk.pdf" target="_blank">Click here for more information.</a></div>
</div>
<div class="row mb-3">
	<div class="col-md-3 col-sm-12"><b>Component/Component Type:</b></div>
	<div class="col-md-9 col-sm-12">Using the Component field you can search for a specific component if desired (i.e, "yes-no-opening-2").<br>
	The Component Type drop-down menu will select by a broader category of components (all "yes-no" type components).</div>
</div>
<script type="text/javascript">
$(function () {
	  $('[data-toggle="tooltip"]').tooltip();
});
</script>
