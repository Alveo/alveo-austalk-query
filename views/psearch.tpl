%rebase("base-page")

<div class="progress mb-0 border bg-light" style="height: 20px;">
  <div class="progress-bar bg-warning" role="progressbar" style="width: 0%;" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100">Start by Searching for Speakers</div>
</div>

<nav aria-label="breadcrumb mb-4 mt-0">
  <ol class="breadcrumb bg-light">
    <li class="breadcrumb-item active" aria-current="page">Search Speakers</li>
  </ol>
</nav>

<!-- 
<p>Here you can search for your desired speakers. Click on each of the headings to expand all the available criteria.</p>
<p>When you are done click submit and you'll be provided with a list of speakers fulfilling your search criteria.</p>
 -->
 
<form action="/presults" method="POST">

	<div class="d-flex flex-row-reverse">
		<button type="submit"class="btn btn-light py-2 px-4 m-3">Search</button>
		<a role="button" href="/psearch" class="btn btn-light py-2 px-4 m-3 mr-auto">Clear Search</a>
	</div>
	
	<div class="accordion" id="accordion" >
		<div class="card">
			<div class="card-header" data-toggle="collapse" data-parent="#accordion" href="#gspeaker">
				<div class="d-flex align-items-center">
					<h5 class="mb-0">Speaker Details</h5>
					<i name="accordion-arrow" class="fas fa-angle-down ml-auto"></i>
				</div>
			</div>
			<div id="gspeaker" class="panel-collapse collapse">
				<div class="card-body">
					<div class="row mb-3">
						<div class="col-lg-3 col-md-6 col-xs-12">
							<label for="id"><b>Speaker Id:</b></label>
						</div>
						<div class="col-lg-4 col-md-6 col-xs-12">
							<div class="form-group">
								<input type="text" class="form-control" name="id" id="id" placeholder="1_114">
							</div>
						</div>
						<div class="col-lg-5 col-md-12 col-xs-12">
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
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="gender"><b>Gender:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<div class="btn-group btn-group-toggle btn-group btn-group-toggle-toggle" data-toggle="buttons" id="gender" name="gender">
										<label class="btn btn-light active">
											<input type="radio" value = "" id="gender" name="gender" autocomplete="off" checked>Either
										</label>
										<label class="btn btn-light">
											<input type="radio" value = "male" id="gender" name="gender" autocomplete="off">Male
										</label>
										<label class="btn btn-light">
											<input type="radio" value = "female" id="gender" name="gender" autocomplete="off">Female
										</label>
									</div>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>Search by the gender of the speakers.</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="age"><b>Age:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<input type="text" class="form-control" name="age" id="age" placeholder="-25">
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>Search by Age or a Range of Ages
								<i class="far fa-question-circle" data-toggle="tooltip" data-html="true" 
								title="<p>Enter a single number to search for a specific age. Enter two numbers separated by a hyphen 
								(e.g, '18-50') to search for a range of ages.Enter a negative number (e.g, '-50') to search for people 
								at or under a specific age.Enter a number followed by a + (e.g, '50+') to search for people at or over 
								a specific age.</p>"></i>
								</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="city"><b>Recording Site:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select class="form-control" name="institution" id="institution">
									    <option value = "">Any</option>
										% for inst in results['inst']:
											<option value="{{inst}}">{{inst}}</option>
										% end
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>Search by the Site the Speakers were recorded at.</p>
							</div>
						</div>
					
				</div>
			</div>
		</div>
		<div class="card">
			<div class="card-header" data-toggle="collapse" data-parent="#accordion" href="#glocation">
				<div class="d-flex align-items-center">
					<h5 class="mb-0">Birth Location and Details</h5>
					<i name="accordion-arrow" class="fas fa-angle-down ml-auto"></i>
				</div>
			</div>
			<div id="glocation" class="panel-collapse collapse">
				<div class="card-body">
					
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="pob_town"><b>Birth Town:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<input type="text" class="form-control" name="pob_town" id="pob_town" placeholder="Sydney">
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>Search by the birth town or city. It currently doesn't support multiple towns.</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="pob_state"><b>Birth State:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select multiple size=4 class="form-control" name="pob_state" id="pob_state">
										<option value = "">Any</option>
										<option value = "NSW">NSW</option>
										<option value = "VIC">VIC</option>
										<option value = "QLD">QLD</option>
										<option value = "WA">WA</option>
										<option value = "SA">SA</option>
										<option value = "NT">NT</option>
										<option value = "TAS">TAS</option>
										<option value = "ACT">ACT</option>
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>Here you can select the Australian State or Territory the speakers were born in.
								<i class="far fa-question-circle" data-toggle="tooltip" data-html="true" 
								title="<p>You are able to select multiple options by holding down the Ctrl button (Command button on Mac) 
								and selecting the options you wish. You can also Select a range of options by holding down SHIFT.</p>"></i>
								</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="pob_country"><b>Birth Country:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select multiple size=4 class="form-control" name="pob_country" id="pob_country">
										<option value = "">Any</option>
										%for country in results['pob_country']:
											<option value="{{country}}">{{country}}</option>
										%end
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>You're able to select the country the speakers were born in.
								<i class="far fa-question-circle" data-toggle="tooltip" data-html="true" 
								title="<p>You are able to select multiple options by holding down the Ctrl button (Command button on Mac) 
								and selecting the options you wish. You can also Select a range of options by holding down SHIFT.</p>"></i>
								</p>
							</div>
						</div>
					
				</div>
			</div>
		</div>
		<div class="card">
			<div class="card-header" data-toggle="collapse" data-parent="#accordion" href="#ghistory">
				<div class="d-flex align-items-center">
					<h5 class="mb-0">Residential History</h5>
					<i name="accordion-arrow" class="fas fa-angle-down ml-auto"></i>
				</div>
			</div>
			<div id="ghistory" class="panel-collapse collapse">
				<div class="card-body">
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="town"><b>Town:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select multiple size=4 class="form-control" name="hist_town" id="hist_town">
										<option value = "">Any</option>
										%for country in results['town_hist']:
											<option value="{{country}}">{{country}}</option>
										%end
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>Search by the town of which the speaker has once lived in.
								<i class="far fa-question-circle" data-toggle="tooltip" data-html="true" 
								title="<p>You are able to select multiple options by holding down the Ctrl button (Command button on Mac) 
								and selecting the options you wish. You can also Select a range of options by holding down SHIFT.</p>"></i>
								</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="state"><b>State:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select multiple size=4 class="form-control" name="hist_state" id="hist_state">
										<option value = "">Any</option>
										%for country in results['state_hist']:
											<option value="{{country}}">{{country}}</option>
										%end
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>Here you can select the State or Territory the speakers have lived in. International states are available in this search.
								<i class="far fa-question-circle" data-toggle="tooltip" data-html="true" 
								title="<p>You are able to select multiple options by holding down the Ctrl button (Command button on Mac) 
								and selecting the options you wish. You can also Select a range of options by holding down SHIFT.</p>"></i>
								</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="country"><b>Country:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select multiple size=4 class="form-control" name="hist_country" id="hist_country">
										<option value = "">Any</option>
										%for country in results['country_hist']:
											<option value="{{country}}">{{country}}</option>
										%end
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>Select the country the speakers have lived in.
								<i class="far fa-question-circle" data-toggle="tooltip" data-html="true" 
								title="<p>You are able to select multiple options by holding down the Ctrl button (Command button on Mac) 
								and selecting the options you wish. You can also Select a range of options by holding down SHIFT.</p>"></i>
								</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="hist_age"><b>Age From:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<input type="text" class="form-control" name="age_from" id="age_from" placeholder="5+">
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>Specify what age the speakers were when they moved to the provided historical address.
								<i class="far fa-question-circle" data-toggle="tooltip" data-html="true" 
								title="<p>Enter a single number to search for a specific age. Enter two numbers separated by a hyphen 
								(e.g, '18-50') to search for a range of ages.Enter a negative number (e.g, '-50') to search for people 
								at or under a specific age.Enter a number followed by a + (e.g, '50+') to search for people at or over 
								a specific age.</p>"></i>
								</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="hist_length"><b>Age To:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<input type="text" class="form-control" name="age_to" id="age_to" placeholder="-25">
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>Specify what age the speakers were when they moved out of the provided historical address. If you set this field to be the same value as the age field when using a specific age and leaving Age From empty, you can find their latest address.
								<i class="far fa-question-circle" data-toggle="tooltip" data-html="true" 
								title="<p>Enter a single number to search for a specific age. Enter two numbers separated by a hyphen 
								(e.g, '18-50') to search for a range of ages.Enter a negative number (e.g, '-50') to search for people 
								at or under a specific age.Enter a number followed by a + (e.g, '50+') to search for people at or over 
								a specific age.</p>"></i>
								</p>
							</div>
						</div>
					
				</div>
			</div>
		</div>
		<div class="card">
			<div class="card-header" data-toggle="collapse" data-parent="#accordion" href="#geduprof">
				<div class="d-flex align-items-center">
					<h5 class="mb-0">Education and Professional Status</h5>
					<i name="accordion-arrow" class="fas fa-angle-down ml-auto"></i>
				</div>
			</div>
			<div id="geduprof" class="panel-collapse collapse">
				<div class="card-body">
					
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="profcat"><b>Professional Category:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select class="form-control" name="professional_category" id="professional_category">
								  		<option value="">Any</option>
								  		%for prof in results['professional_category']:
								  			%#This is due to a weird api error when searching for these values
								  			%if prof!="clerical and service" and prof!="intermediate clerical and service":
								  				<option value="{{prof}}">{{prof}}</option>
								  			%end
								  		%end
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>Select your desired Professional Category or if it's not relevant then keep it on Any. Note that 'None' is different to 'Unemployed' as None refers to the lack of this entry in the metadata.</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="highqual"><b>Highest Qualification:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select class="form-control" name="education_level" id="education_level">
										<option value="">Any</option>
										%for qual in results['education_level']:
											<option value="{{qual}}">{{qual}}</option>
										%end
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>You can select the desired level of qualification of the speakers. It is currently not supported if you wish to select speakers with 'at least' some level of qualification.</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="ses"><b>Socio-economic Status:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select class="form-control" name="ses" id="ses">
										<option value="">Any</option>
										<option value="professional">Professional</option>
										<option value="Non professional">Non-professional</option>
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>Only about half of the speakers have data for this field. If a choice is specified, speakers with unknown socio-economic status will be omitted from results.</p>
							</div>
						</div>
					
				</div>
			</div>
		</div>
		<div class="card">
			<div class="card-header" data-toggle="collapse" data-parent="#accordion" href="#glanguages">
				<div class="d-flex align-items-center">
					<h5 class="mb-0">Language and Culture</h5>
					<i name="accordion-arrow" class="fas fa-angle-down ml-auto"></i>
				</div>
			</div>
			<div id="glanguages" class="panel-collapse collapse">
				<div class="card-body">
					
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="first_language"><b>First Language:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select type="text" class="form-control" name="first_language" id="first_language">
										<option value = "">Any</option>
										% for i in range(0, len(results['first_language_int'])):
											<option value="{{results['first_language_int'][i]}}">{{results['first_language'][i]}}</option>
										% end
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>Select the first language of the speaker.</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="other_languages"><b>Other Languages:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<input type="text" class="form-control" name="other_languages" id="other_languages" placeholder="German">
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>Search by other languages spoken by the speaker. This field was a general text field and so using regular expressions 
								is supported.
								<i class="far fa-question-circle" data-toggle="tooltip" data-html="true" 
								title="<p>You can search for individual speakers by entering their speaker id's. You can also use 
								SPARQL's regular expression syntax. Some examples, '.' is a wildcard character, '*' matches 0-many 
								of the previous expression. Partial searches can also work using '^' and/or '$' at the beginning and the 
								end respectively. Searches are not case-sensitive. More information on it's special usage is below.</p>"></i>
								</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="cultural_heritage"><b>Cultural Heritage:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select class="form-control" name="cultural_heritage" id="cultural_heritage">
										<option value = "">Any</option>
										%for place in results['cultural_heritage']:
											<option value="{{place}}">{{place}}</option>
										% end
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>You can select the desired cultural heritage of the speakers. Keep in mind that there is a lot of overlap with the provided heritages. At the moment only selecting one is supported. </p>
							</div>
						</div>
					
				</div>
			</div>
		</div>
		<div class="card">
			<div class="card-header" data-toggle="collapse" data-parent="#accordion" href="#gdpi">
				<div class="d-flex align-items-center">
					<h5 class="mb-0">Detailed Speaker Information </h5>
					<i name="accordion-arrow" class="fas fa-angle-down ml-auto"></i>
				</div>
			</div>
			<div id="gdpi" class="panel-collapse collapse">
				<div class="card-body">
					
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="is_student"><b>Is Student:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
									<div class="btn-group btn-group-toggle" data-toggle="buttons" id="gender" name="gender">
										<label class="btn btn-light active">
											<input type="radio" id="is_student" name="is_student" value = "" autocomplete="off" checked>Either
										</label>
										<label class="btn btn-light">
											<input type="radio" id="is_student" name="is_student" value = "true" autocomplete="off">Yes
										</label>
										<label class="btn btn-light">
											<input type="radio" id="is_student" name="is_student" value = "false" autocomplete="off">No
										</label>
									</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p></p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="is_smoker"><b>Is Smoker:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
									<div class="btn-group btn-group-toggle" data-toggle="buttons" id="gender" name="gender">
										<label class="btn btn-light active">
											<input type="radio" id="is_smoker" name="is_smoker" value = "" autocomplete="off" checked>Either
										</label>
										<label class="btn btn-light">
											<input type="radio" id="is_smoker" name="is_smoker" value = "true" autocomplete="off">Yes
										</label>
										<label class="btn btn-light">
											<input type="radio" id="is_smoker" name="is_smoker" value = "false" autocomplete="off">No
										</label>
									</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p></p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="has_speech_problems"><b>Has Speech Problems:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
									<div class="btn-group btn-group-toggle" data-toggle="buttons" id="gender" name="gender">
										<label class="btn btn-light active">
											<input type="radio" id="has_speech_problems" name="has_speech_problems" value = "" autocomplete="off" checked>Either
										</label>
										<label class="btn btn-light">
											<input type="radio" id="has_speech_problems" name="has_speech_problems" value = "true" autocomplete="off">Yes
										</label>
										<label class="btn btn-light">
											<input type="radio" id="has_speech_problems" name="has_speech_problems" value = "false" autocomplete="off">No
										</label>
									</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p></p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="has_hearing_problems"><b>Has Hearing Problems:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
									<div class="btn-group btn-group-toggle" data-toggle="buttons" id="gender" name="gender">
										<label class="btn btn-light active">
											<input type="radio" id="has_hearing_problems" name="has_hearing_problems" value = "" autocomplete="off" checked>Either
										</label>
										<label class="btn btn-light">
											<input type="radio" id="has_hearing_problems" name="has_hearing_problems" value = "true" autocomplete="off">Yes
										</label>
										<label class="btn btn-light">
											<input type="radio" id="has_hearing_problems" name="has_hearing_problems" value = "false" autocomplete="off">No
										</label>
									</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p></p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="has_reading_problems"><b>Has Reading Problems:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
									<div class="btn-group btn-group-toggle" data-toggle="buttons" id="gender" name="gender">
										<label class="btn btn-light active">
											<input type="radio" id="has_reading_problems" name="has_reading_problems" value = "" autocomplete="off" checked>Either
										</label>
										<label class="btn btn-light">
											<input type="radio" id="has_reading_problems" name="has_reading_problems" value = "true" autocomplete="off">Yes
										</label>
										<label class="btn btn-light">
											<input type="radio" id="has_reading_problems" name="has_reading_problems" value = "false" autocomplete="off">No
										</label>
									</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p></p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="has_vocal_training"><b>Has Vocal Training:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
									<div class="btn-group btn-group-toggle" data-toggle="buttons" id="gender" name="gender">
										<label class="btn btn-light active">
											<input type="radio" id="has_vocal_training" name="has_vocal_training" value = "" autocomplete="off" checked>Either
										</label>
										<label class="btn btn-light">
											<input type="radio" id="has_vocal_training" name="has_vocal_training" value = "true" autocomplete="off">Yes
										</label>
										<label class="btn btn-light">
											<input type="radio" id="has_vocal_training" name="has_vocal_training" value = "false" autocomplete="off">No
										</label>
									</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p></p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="has_dentures"><b>Has Dentures:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
									<div class="btn-group btn-group-toggle" data-toggle="buttons" id="gender" name="gender">
										<label class="btn btn-light active">
											<input type="radio" id="has_dentures" name="has_dentures" value = "" autocomplete="off" checked>Either
										</label>
										<label class="btn btn-light">
											<input type="radio" id="has_dentures" name="has_dentures" value = "true" autocomplete="off">Yes
										</label>
										<label class="btn btn-light">
											<input type="radio" id="has_dentures" name="has_dentures" value = "false" autocomplete="off">No
										</label>
									</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p></p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="has_health_problems"><b>Has Health Problems:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
									<div class="btn-group btn-group-toggle" data-toggle="buttons" id="gender" name="gender">
										<label class="btn btn-light active">
											<input type="radio" id="has_health_problems" name="has_health_problems" value = "" autocomplete="off" checked>Either
										</label>
										<label class="btn btn-light">
											<input type="radio" id="has_health_problems" name="has_health_problems" value = "true" autocomplete="off">Yes
										</label>
										<label class="btn btn-light">
											<input type="radio" id="has_health_problems" name="has_health_problems" value = "false" autocomplete="off">No
										</label>
									</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p></p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="is_left_handed"><b>Is Left Handed:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
									<div class="btn-group btn-group-toggle" data-toggle="buttons" id="gender" name="gender">
										<label class="btn btn-light active">
											<input type="radio" id="is_left_handed" name="is_left_handed" value = "" autocomplete="off" checked>Either
										</label>
										<label class="btn btn-light">
											<input type="radio" id="is_left_handed" name="is_left_handed" value = "true" autocomplete="off">Yes
										</label>
										<label class="btn btn-light">
											<input type="radio" id="is_left_handed" name="is_left_handed" value = "false" autocomplete="off">No
										</label>
									</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p></p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="has_piercings"><b>Has Piercings:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
									<div class="btn-group btn-group-toggle" data-toggle="buttons" id="gender" name="gender">
										<label class="btn btn-light active">
											<input type="radio" id="has_piercings" name="has_piercings" value = "" autocomplete="off" checked>Either
										</label>
										<label class="btn btn-light">
											<input type="radio" id="has_piercings" name="has_piercings" value = "true" autocomplete="off">Yes
										</label>
										<label class="btn btn-light">
											<input type="radio" id="has_piercings" name="has_piercings" value = "false" autocomplete="off">No
										</label>
									</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>A quick analysis of the data shows that there are only 38 results, 24 have nose piercings, only 4 have lip piecings, 4 eyebrows, 4 None and 4 other.</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="hobbies_details"><b>Hobbies:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<input type="text" class="form-control" name="hobbies_details" id="hobbies_details" placeholder="Photography">
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>This filter supports Regular Expressions. 
								<i class="far fa-question-circle" data-toggle="tooltip" data-html="true" 
								title="<p>You can search for individual speakers by entering their speaker id's. You can also use 
								SPARQL's regular expression syntax. Some examples, '.' is a wildcard character, '*' matches 0-many 
								of the previous expression. Partial searches can also work using '^' and/or '$' at the beginning and the 
								end respectively. Searches are not case-sensitive. More information on it's special usage is below.</p>"></i>
								</p>
							</div>
						</div>
					
				</div>
			</div>
		</div>
		<div class="card">
			<div class="card-header" data-toggle="collapse" data-parent="#accordion" href="#gmother">
				<div class="d-flex align-items-center">
					<h5 class="mb-0">Mothers Details </h5>
					<i name="accordion-arrow" class="fas fa-angle-down ml-auto"></i>
				</div>
			</div>
			<div id="gmother" class="panel-collapse collapse">
				<div class="card-body">
					
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="mother_cultural_heritage"><b>Cultural Heritage:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select class="form-control" name="mother_cultural_heritage" id="mother_cultural_heritage">
										<option value = "">Any</option>
										%for place in results['mother_cultural_heritage']:
											<option value="{{place}}">{{place}}</option>
										% end
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>You can select the desired cultural heritage of the speakers mother. Keep in mind that there is a lot of overlap with the provided heritages. At the moment only selecting one is supported. </p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="mother_first_language"><b>First Language:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select type="text" class="form-control" name="mother_first_language" id="mother_first_language">
										<option value = "">Any</option>
										%for i in range(0, len(results['mother_first_language_int'])):
											<option value="{{results['mother_first_language_int'][i]}}">{{results['mother_first_language'][i]}}</option>
										% end
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>Select the first language of the speakers mother.</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="mother_professional_category"><b>Professional Category:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select class="form-control" name="mother_professional_category" id="mother_professional_category">
								  		<option value="">Any</option>
								  		%for prof in results['mother_professional_category']:
								  			%#This is due to a weird api error when searching for these values
								  			%if prof!="clerical and service" and prof!="intermediate clerical and service":
								  				<option value="{{prof}}">{{prof}}</option>
								  			%end
								  		%end
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>Select your desired Professional Category or if it's not relevant then keep it on Any. Note that 'None' is different to 'Unemployed' as None refers to the lack of this entry in the metadata.</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="mother_education_level"><b>Highest Qualification:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select class="form-control" name="mother_education_level" id="mother_education_level">
										<option value="">Any</option>
										%for qual in results['mother_education_level']:
											<option value="{{qual}}">{{qual}}</option>
										%end
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>You can select the desired level of qualification of the speakers mother. It is currently not supported if you wish to select speakers with 'at least' some level of qualification.</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="mother_pob_town"><b>Birth Town:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<input type="text" class="form-control" name="mother_pob_town" id="mother_pob_town" placeholder="Sydney">
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>Search by the birth town or city. It currently doesn't support multiple towns.</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="mother_pob_state"><b>Birth State:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select multiple size=4 class="form-control" name="mother_pob_state" id="mother_pob_state">
										<option value = "">Any</option>
										<option value = "NSW">NSW</option>
										<option value = "VIC">VIC</option>
										<option value = "QLD">QLD</option>
										<option value = "WA">WA</option>
										<option value = "SA">SA</option>
										<option value = "NT">NT</option>
										<option value = "TAS">TAS</option>
										<option value = "ACT">ACT</option>
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>Here you can select the Australian State or Territory the speakers mother was born in.
								<i class="far fa-question-circle" data-toggle="tooltip" data-html="true" 
								title="<p>You are able to select multiple options by holding down the Ctrl button (Command button on Mac) 
								and selecting the options you wish. You can also Select a range of options by holding down SHIFT.</p>"></i>
								</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="mother_pob_country"><b>Birth Country:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select multiple size=4 class="form-control" name="mother_pob_country" id="mother_pob_country">
										<option value = "">Any</option>
										%for country in results['mother_pob_country']:
											<option value="{{country}}">{{country}}</option>
										%end
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>You're able to select the country the speakers mother was born in.
								<i class="far fa-question-circle" data-toggle="tooltip" data-html="true" 
								title="<p>You are able to select multiple options by holding down the Ctrl button (Command button on Mac) 
								and selecting the options you wish. You can also Select a range of options by holding down SHIFT.</p>"></i>
								</p>
							</div>
						</div>
					
				</div>
			</div>
		</div>
		<div class="card">
			<div class="card-header" data-toggle="collapse" data-parent="#accordion" href="#gfather">
				<div class="d-flex align-items-center">
					<h5 class="mb-0">Fathers Details </h5>
					<i name="accordion-arrow" class="fas fa-angle-down ml-auto"></i>
				</div>
			</div>
			<div id="gfather" class="panel-collapse collapse">
				<div class="card-body">
					
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="father_cultural_heritage"><b>Cultural Heritage:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select class="form-control" name="father_cultural_heritage" id="father_cultural_heritage">
										<option value = "">Any</option>
										%for place in results['father_cultural_heritage']:
											<option value="{{place}}">{{place}}</option>
										% end
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>You can select the desired cultural heritage of the speakers father. Keep in mind that there is a lot of overlap with the provided heritages. At the moment only selecting one is supported. </p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="father_first_language"><b>First Language:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select type="text" class="form-control" name="father_first_language" id="father_first_language">
										<option value = "">Any</option>
										% for i in range(0, len(results['father_first_language_int'])):
											<option value="{{results['father_first_language_int'][i]}}">{{results['father_first_language'][i]}}</option>
										% end
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>Select the first language of the speakers father.</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="father_professional_category"><b>Professional Category:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select class="form-control" name="father_professional_category" id="father_professional_category">
								  		<option value="">Any</option>
								  		%for prof in results['father_professional_category']:
								  			%#This is due to a weird api error when searching for these values
								  			%if prof!="clerical and service" and prof!="intermediate clerical and service":
								  				<option value="{{prof}}">{{prof}}</option>
								  			%end
								  		%end
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>Select your desired Professional Category or if it's not relevant then keep it on Any. Note that 'None' is different to 'Unemployed' as None refers to the lack of this entry in the metadata.</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="father_education_level"><b>Highest Qualification:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select class="form-control" name="father_education_level" id="father_education_level">
										<option value="">Any</option>
										%for qual in results['father_education_level']:
											<option value="{{qual}}">{{qual}}</option>
										%end
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>You can select the desired level of qualification of the speakers father. It is currently not supported if you wish to select speakers with 'at least' some level of qualification.</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="father_pob_town"><b>Birth Town:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<input type="text" class="form-control" name="father_pob_town" id="father_pob_town" placeholder="Sydney">
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>Search by the birth town or city. It currently doesn't support multiple towns.</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="father_pob_state"><b>Birth State:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select multiple size=4 class="form-control" name="father_pob_state" id="father_pob_state">
										<option value = "">Any</option>
										<option value = "NSW">NSW</option>
										<option value = "VIC">VIC</option>
										<option value = "QLD">QLD</option>
										<option value = "WA">WA</option>
										<option value = "SA">SA</option>
										<option value = "NT">NT</option>
										<option value = "TAS">TAS</option>
										<option value = "ACT">ACT</option>
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>Here you can select the Australian State or Territory the speakers father was born in.
								<i class="far fa-question-circle" data-toggle="tooltip" data-html="true" 
								title="<p>You are able to select multiple options by holding down the Ctrl button (Command button on Mac) 
								and selecting the options you wish. You can also Select a range of options by holding down SHIFT.</p>"></i>
								</p>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-lg-3 col-md-6 col-xs-12">
								<label for="father_pob_country"><b>Birth Country:</b></label>
							</div>
							<div class="col-lg-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select multiple size=4 class="form-control" name="father_pob_country" id="father_pob_country">
										<option value = "">Any</option>
										%for country in results['father_pob_country']:
											<option value="{{country}}">{{country}}</option>
										%end
									</select>
								</div>
							</div>
							<div class="col-lg-5 col-md-12 col-xs-12">
								<p>You're able to select the country the speakers father was born in.
								<i class="far fa-question-circle" data-toggle="tooltip" data-html="true" 
								title="<p>You are able to select multiple options by holding down the Ctrl button (Command button on Mac) 
								and selecting the options you wish. You can also Select a range of options by holding down SHIFT.</p>"></i>
								</p>
							</div>
						</div>
					
				</div>
			</div>
		</div>
	</div> 
	
	<div class="d-flex flex-row-reverse">
		<button type="submit"class="btn btn-light py-2 px-4 m-3">Search</button>
		<a role="button" href="/psearch" class="btn btn-light py-2 px-4 m-3 mr-auto">Clear Search</a>
	</div>
</form>

<br><br>

<h5>Supported Regular Expressions</h5>

<p>Sometimes it's useful or just convenient to search for some particular cases. In some of the search fields you can search for everything that starts with, ends with, contains, strictly a single case or even a list of specifc cases you want.
Below explains the different ways you can utilize this along with examples.</p>
<p>Currently only "Speaker Id" and "Other languages" support this. Age is a special case which is explained above.</p>
<p>Note: &lt;search&gt; is used below to show what you'll have entered in related to the expression being described. None of the expressions use a '&lt;' or '&gt;'.</p>

	<div class="row mb-3 bg-light">
		<div class="col-lg-2 col-md-12 border"><b>Expression</b></div>
		<div class="col-lg-5 col-md-6 col-sm-12 border"><b>Usage</b></div>
		<div class="col-lg-5 col-md-6 col-sm-12 border"><b>Example</b></div>
	</div>
	<div class="row mb-3 bg-light">
		<div class="col-lg-2 col-md-12 border">&lt;search&gt;</div>
		<div class="col-lg-5 col-md-6 col-sm-12 border">This is the case when you have nothing around your input, it will return anything that contains &lt;search&gt;.</div>
		<div class="col-lg-5 col-md-6 col-sm-12 border">If you search "1_114" without quotes, it will return "1_114" and "1_1141"</div>
	</div>
	<div class="row mb-3 bg-light">
		<div class="col-lg-2 col-md-12 border">"&lt;search&gt;"</div>
		<div class="col-lg-5 col-md-6 col-sm-12 border">In this case only exactly what you've typed will be searched for.</div>
		<div class="col-lg-5 col-md-6 col-sm-12 border">If you search "1_114" with quotes, it will return "1_114" only</div>
	</div>
	<div class="row mb-3 bg-light">
		<div class="col-lg-2 col-md-12 border">&lt;search1&gt;, "&lt;search2&gt;", &lt;search3&gt;</div>
		<div class="col-lg-5 col-md-6 col-sm-12 border">In this case not only case you select multiple options delimited by a comma, but you can also mix the above cases.</div>
		<div class="col-lg-5 col-md-6 col-sm-12 border">If you search 1_114,"1_475" it will return "1_114", "1_1141" and "1_475"</div>
	</div>
	<div class="row mb-3 bg-light">
		<div class="col-lg-2 col-md-12 border">$&lt;search&gt;</div>
		<div class="col-lg-5 col-md-6 col-sm-12 border">In this case you are searching for anything that starts with what your input.</div>
		<div class="col-lg-5 col-md-6 col-sm-12 border">If you search "$Eng" without quotes in other languages, it will return "English"</div>
	</div>
	<div class="row mb-3 bg-light">
		<div class="col-lg-2 col-md-12 border">&lt;search&gt;^</div>
		<div class="col-lg-5 col-md-6 col-sm-12 border">This case is similar to the one above however it's an 'ends with' case.</div>
		<div class="col-lg-5 col-md-6 col-sm-12 border">If you search "man^" without quotes in other languages, it will return "German"</div>
	</div>
	<div class="row mb-3 bg-light">
		<div class="col-lg-2 col-md-12 border">.</div>
		<div class="col-lg-5 col-md-6 col-sm-12 border">The full stop character is a wildcard character. Which means any single letter or number can replace it</div>
		<div class="col-lg-5 col-md-6 col-sm-12 border">If you search for "...l..." without quotes in other languages, it will look for anything that is 7 letters long, with the letter 'l' in the middle.</div>
	</div>
	<div class="row mb-3 bg-light">
		<div class="col-lg-2 col-md-12 border">*</div>
		<div class="col-lg-5 col-md-6 col-sm-12 border">The star character matches 0-many of the previous expression. It will primarily be useful for placing it after a full stop.</div>
		<div class="col-lg-5 col-md-6 col-sm-12 border">If you search for ".*ap.*" without quotes in other languages, it will look for anything that somewhere in the word has "ap"</div>
	</div>

<br><br><br>
<script type="text/javascript">
	$(function () {
		  $('[data-toggle="tooltip"]').tooltip();
	});
	
	$('.card').on('click', '.card-header', function(event) {
		var arrow = $(this).find('[name="accordion-arrow"]')
		if (arrow.hasClass("fa-angle-down")){
			arrow.removeClass("fa-angle-down");
			arrow.addClass("fa-angle-up");
		} else {
			arrow.removeClass("fa-angle-up");
			arrow.addClass("fa-angle-down");
		}
	});
	
	$(document).ready(function() {
		$('.progress .progress-bar').css("width",function() {
			return $(this).attr("aria-valuenow") + "%";
		});
	});
</script>

