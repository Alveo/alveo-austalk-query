<!DOCTYPE html>
<html>
<head>
	% include('bshead.tpl')
	
</head>



<body>

<div class="navi">
	% include('nav.tpl', title="PSearch")

</div>




<div class="content">
	%if len(message)>0:
	<div class="alert alert-warning" role="alert">
		<p align="center"><b>{{!message}}</b></p>
	</div>
	%end


<form action="/presults" method="POST" style="width:98%;margin:auto;">
	<br><p style="font: 15px arial, sans-serif;">Here you can search for your desired participants. Click on each of the headings to expand all the available criteria.<br>When you are done click submit and you'll be provided with a list of participants fulfilling your criteria.</p>
	<button type="submit" style="float:right;" class="btn btn-default">Submit</button><br><br>
	<div class="panel-group" id="accordion" >
		<div class="panel panel-default">
			<div class="panel-heading" data-toggle="collapse" data-parent="#accordion" href="#gparticipant">
				<h4 class="panel-title">Participant Details</h4>
			</div>
			<div id="gparticipant" class="panel-collapse collapse in">
				<div class="panel-body">
					<table>
						<tr>
							<td class="left">
								<label for="id"><b>Participant Id:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="id" id="id" placeholder="1_114">
								</div>
							</td>
							<td class="right">
								<p>You can search for individual speakers by entering their participant id's. You can also use SPARQL's regular expression syntax. Some examples, '.' is a wildcard character, '*' matches 0-many of the previous expression. Partial searches can also work using "^" and/or "$" at the beginning and the end respectively. Searches are not case-sensitive. More information on it's special usage is below.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="gender"><b>Gender:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<div class="btn-group" data-toggle="buttons" id="gender" name="gender">
										<label class="btn btn-custom active">
											<input type="radio" value = "" id="gender" name="gender" autocomplete="off" checked>Any
										</label>
										<label class="btn btn-custom">
											<input type="radio" value = "male" id="gender" name="gender" autocomplete="off">Male
										</label>
										<label class="btn btn-custom">
											<input type="radio" value = "female" id="gender" name="gender" autocomplete="off">Female
										</label>
									</div>
								</div>
							</td>
							<td class="right">
								<p>You can search by the gender of the participants.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="age"><b>Age:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="age" id="age" placeholder="-25">
								</div>
							</td>
							<td class="right">
								<p>Enter a single number to search for a specific age. Enter two numbers separated by a hyphen (e.g, "18-50") to search for a range of ages.<br>Enter a negative number (e.g, "-50") to search for people at or under a specific age.<br>Enter a number followed by a + (e.g, "50+") to search for people at or over a specific age.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="city"><b>Test Location:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select class="form-control" name="city" id="city">
									    <option value = "">Any</option>
										% for city in results['city']:
											<option value="{{city}}">{{city}}</option>
										% end
									</select>
								</div>
							</td>
							<td class="right">
								<p>This is the location where the participant was tested and is a good way to select a group of participants known to you.</p>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		<div class="panel panel-default">
			<div class="panel-heading" data-toggle="collapse" data-parent="#accordion" href="#glocation">
				<h4 class="panel-title">Birth Location and Details</h4>
			</div>
			<div id="glocation" class="panel-collapse collapse">
				<div class="panel-body">
					<table>
						<tr>
							<td class="left">
								<label for="pob_town"><b>Birth Town:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="pob_town" id="pob_town" placeholder="Sydney">
								</div>
							</td>
							<td class="right">
								<p>You can search by the town of which the participant was born in. It currently doesn't support multiple towns.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="pob_state"><b>Birth State:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="pob_state" id="pob_state" placeholder="NSW">
								</div>
							</td>
							<td class="right">
								<p>Here you can select the State or Territory the participants were born in. You must enter the abbreviated names of the states such as "VIC" or "WA". This works for international states however very few are given and may not represent an accurate abbreviation for that state.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="pob_country"><b>Birth Country:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select multiple size=4 class="form-control" name="pob_country" id="pob_country">
										<option value = "">Any</option>
										%for country in results['pob_country']:
											<option value="{{country}}">{{country}}</option>
										%end
									</select>
								</div>
							</td>
							<td class="right">
								<p>You're able to select the country the participants was born in. You are able to select multiple countries by holding down the Ctrl button (Command button on Mac) and selecting the countries you wish. You can also Select a range of countries by holding down SHIFT. Please note that if you wish for everyone born in Australia, you'll need to select both "AU" and "Australia" due to inconsistencies in the data.</p>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		<div class="panel panel-default">
			<div class="panel-heading" data-toggle="collapse" data-parent="#accordion" href="#ghistory">
				<h4 class="panel-title">Residential History</h4>
			</div>
			<div id="ghistory" class="panel-collapse collapse">
				<div class="panel-body">
					<table border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="left">
								<label for="town"><b>Town:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select multiple size=4 class="form-control" name="hist_town" id="hist_town">
										<option value = "">Any</option>
										%for country in results['town_hist']:
											<option value="{{country}}">{{country}}</option>
										%end
									</select>
								</div>
							</td>
							<td class="right">
								<p>You can search by the town of which the participant have lived in.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="state"><b>State:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select multiple size=4 class="form-control" name="hist_state" id="hist_state">
										<option value = "">Any</option>
										%for country in results['state_hist']:
											<option value="{{country}}">{{country}}</option>
										%end
									</select>
								</div>
							</td>
							<td class="right">
								<p>Here you can select the State or Territory the participants have lived in. You must enter the abbreviated names of the states such as "VIC" or "WA". This works for international states however very few are given and may not represent an accurate abbreviation for that state.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="country"><b>Country:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select multiple size=4 class="form-control" name="hist_country" id="hist_country">
										<option value = "">Any</option>
										%for country in results['country_hist']:
											<option value="{{country}}">{{country}}</option>
										%end
									</select>
								</div>
							</td>
							<td class="right">
								<p>You're able to select the country the participants have lived in. You are able to select multiple countries by holding down the Ctrl button (Command button on Mac) and selecting the countries you wish. You can also Select a range of countries by holding down SHIFT. Please note that if you wish for everyone born in Australia, you'll need to select both "AU" and "Australia" due to inconsistencies in the data.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="hist_age"><b>Age From:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="age_from" id="age_from" placeholder="5+">
								</div>
							</td>
							<td class="right">
								<p>Here you can specify what age the participants were when they moved to the provided historical address. Enter a single number to search for a specific age. Enter two numbers separated by a hyphen (e.g, "18-50") to search for a range of ages.<br>Enter a negative number (e.g, "-50") to search for people at or under a specific age.<br>Enter a number followed by a + (e.g, "50+") to search for people at or over a specific age.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="hist_length"><b>Age To:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="age_to" id="age_to" placeholder="-25">
								</div>
							</td>
							<td class="right">
								<p>Here you can specify what age the participants were when they moved out of the provided historical address. The same format can be used as the 'Age From' Field.<br>If you set this field to be the same value as the age field when using a specific age and leaving Age From empty, you can find their latest address.</p>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		<div class="panel panel-default">
			<div class="panel-heading" data-toggle="collapse" data-parent="#accordion" href="#geduprof">
				<h4 class="panel-title">Education and Professional Status</h4>
			</div>
			<div id="geduprof" class="panel-collapse collapse">
				<div class="panel-body">
					<table>
						<tr>
							<td class="left">
								<label for="profcat"><b>Professional Category:</b></label>
							</td>
							<td class="mid">
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
							</td>
							<td class="right">
								<p>Select your desired Professional Category or if it's not relevant then keep it on Any.<br> Note that 'None' is different to 'Unemployed' as None refers to the lack of this entry in the metadata.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="highqual"><b>Highest Qualification:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select class="form-control" name="education_level" id="education_level">
										<option value="">Any</option>
										%for qual in results['education_level']:
											<option value="{{qual}}">{{qual}}</option>
										%end
									</select>
								</div>
							</td>
							<td class="right">
								<p>You can select the desired level of qualification of the participants. It is currently not supported if you wish to select participants with 'at least' some level of qualification.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="ses"><b>Socio-economic Status:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select class="form-control" name="ses" id="ses">
										<option value="">Any</option>
										<option value="professional">Professional</option>
										<option value="Non professional">Non-professional</option>
									</select>
								</div>
							</td>
							<td class="right">
								<p>Only about half of the participants have data for this field. If a choice is specified, participants with unknown socio-economic status will be omitted from results.</p>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		<div class="panel panel-default">
			<div class="panel-heading" data-toggle="collapse" data-parent="#accordion" href="#glanguages">
				<h4 class="panel-title">Language and Culture</h4>
			</div>
			<div id="glanguages" class="panel-collapse collapse">
				<div class="panel-body">
					<table>
						<tr>
							<td class="left">
								<label for="first_language"><b>First Language:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select type="text" class="form-control" name="first_language" id="first_language">
										<option value = "">Any</option>
										% for i in range(0, len(results['first_language_int'])):
											<option value="{{results['first_language_int'][i]}}">{{results['first_language'][i]}}</option>
										% end
									</select>
								</div>
							</td>
							<td class="right">
								<p>Here you can select the desired first language of the participants.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="other_languages"><b>Other Languages:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="other_languages" id="other_languages" placeholder="German">
								</div>
							</td>
							<td class="right">
								<p>You can also use SPARQL's regular expression syntax. Some examples, '.' is a wildcard character, '*' matches 0-many of the previous expression. Partial searches can also work using "^" and/or "$" at the beginning and the end respectively. For example "^Eng" will result in all languages starting in "Eng" and "man$" will result in all languages ending in "man". Searches are not case-sensitive. More information on it's special usage is below.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="cultural_heritage"><b>Cultural Heritage:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select class="form-control" name="cultural_heritage" id="cultural_heritage">
										<option value = "">Any</option>
										%for place in results['cultural_heritage']:
											<option value="{{place}}">{{place}}</option>
										% end
									</select>
								</div>
							</td>
							<td class="right">
								<p>You can select the desired cultural heritage of the participants. Keep in mind that there is a lot of overlap with the provided heritages. At the moment only selecting one is supported. </p>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		<div class="panel panel-default">
			<div class="panel-heading" data-toggle="collapse" data-parent="#accordion" href="#gdpi">
				<h4 class="panel-title">Detailed Participant Information</h4>
			</div>
			<div id="gdpi" class="panel-collapse collapse">
				<div class="panel-body">
					<table>
						<tr>
							<td class="left">
								<label for="is_student"><b>Is Student:</b></label>
							</td>
							<td class="mid">
									<div class="btn-group" data-toggle="buttons" id="gender" name="gender">
										<label class="btn btn-custom active">
											<input type="radio" id="is_student" name="is_student" value = "" autocomplete="off" checked>Any
										</label>
										<label class="btn btn-custom">
											<input type="radio" id="is_student" name="is_student" value = "true" autocomplete="off">True
										</label>
										<label class="btn btn-custom">
											<input type="radio" id="is_student" name="is_student" value = "false" autocomplete="off">False
										</label>
									</div>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="is_smoker"><b>Is Smoker:</b></label>
							</td>
							<td class="mid">
									<div class="btn-group" data-toggle="buttons" id="gender" name="gender">
										<label class="btn btn-custom active">
											<input type="radio" id="is_smoker" name="is_smoker" value = "" autocomplete="off" checked>Any
										</label>
										<label class="btn btn-custom">
											<input type="radio" id="is_smoker" name="is_smoker" value = "true" autocomplete="off">True
										</label>
										<label class="btn btn-custom">
											<input type="radio" id="is_smoker" name="is_smoker" value = "false" autocomplete="off">False
										</label>
									</div>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="has_speech_problems"><b>Has Speech Problems:</b></label>
							</td>
							<td class="mid">
									<div class="btn-group" data-toggle="buttons" id="gender" name="gender">
										<label class="btn btn-custom active">
											<input type="radio" id="has_speech_problems" name="has_speech_problems" value = "" autocomplete="off" checked>Any
										</label>
										<label class="btn btn-custom">
											<input type="radio" id="has_speech_problems" name="has_speech_problems" value = "true" autocomplete="off">True
										</label>
										<label class="btn btn-custom">
											<input type="radio" id="has_speech_problems" name="has_speech_problems" value = "false" autocomplete="off">False
										</label>
									</div>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="has_hearing_problems"><b>Has Hearing Problems:</b></label>
							</td>
							<td class="mid">
									<div class="btn-group" data-toggle="buttons" id="gender" name="gender">
										<label class="btn btn-custom active">
											<input type="radio" id="has_hearing_problems" name="has_hearing_problems" value = "" autocomplete="off" checked>Any
										</label>
										<label class="btn btn-custom">
											<input type="radio" id="has_hearing_problems" name="has_hearing_problems" value = "true" autocomplete="off">True
										</label>
										<label class="btn btn-custom">
											<input type="radio" id="has_hearing_problems" name="has_hearing_problems" value = "false" autocomplete="off">False
										</label>
									</div>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="has_reading_problems"><b>Has Reading Problems:</b></label>
							</td>
							<td class="mid">
									<div class="btn-group" data-toggle="buttons" id="gender" name="gender">
										<label class="btn btn-custom active">
											<input type="radio" id="has_reading_problems" name="has_reading_problems" value = "" autocomplete="off" checked>Any
										</label>
										<label class="btn btn-custom">
											<input type="radio" id="has_reading_problems" name="has_reading_problems" value = "true" autocomplete="off">True
										</label>
										<label class="btn btn-custom">
											<input type="radio" id="has_reading_problems" name="has_reading_problems" value = "false" autocomplete="off">False
										</label>
									</div>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="has_vocal_training"><b>Has Vocal Training:</b></label>
							</td>
							<td class="mid">
									<div class="btn-group" data-toggle="buttons" id="gender" name="gender">
										<label class="btn btn-custom active">
											<input type="radio" id="has_vocal_training" name="has_vocal_training" value = "" autocomplete="off" checked>Any
										</label>
										<label class="btn btn-custom">
											<input type="radio" id="has_vocal_training" name="has_vocal_training" value = "true" autocomplete="off">True
										</label>
										<label class="btn btn-custom">
											<input type="radio" id="has_vocal_training" name="has_vocal_training" value = "false" autocomplete="off">False
										</label>
									</div>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="has_dentures"><b>Has Dentures:</b></label>
							</td>
							<td class="mid">
									<div class="btn-group" data-toggle="buttons" id="gender" name="gender">
										<label class="btn btn-custom active">
											<input type="radio" id="has_dentures" name="has_dentures" value = "" autocomplete="off" checked>Any
										</label>
										<label class="btn btn-custom">
											<input type="radio" id="has_dentures" name="has_dentures" value = "true" autocomplete="off">True
										</label>
										<label class="btn btn-custom">
											<input type="radio" id="has_dentures" name="has_dentures" value = "false" autocomplete="off">False
										</label>
									</div>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="has_health_problems"><b>Has Health Problems:</b></label>
							</td>
							<td class="mid">
									<div class="btn-group" data-toggle="buttons" id="gender" name="gender">
										<label class="btn btn-custom active">
											<input type="radio" id="has_health_problems" name="has_health_problems" value = "" autocomplete="off" checked>Any
										</label>
										<label class="btn btn-custom">
											<input type="radio" id="has_health_problems" name="has_health_problems" value = "true" autocomplete="off">True
										</label>
										<label class="btn btn-custom">
											<input type="radio" id="has_health_problems" name="has_health_problems" value = "false" autocomplete="off">False
										</label>
									</div>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="is_left_handed"><b>Is Left Handed:</b></label>
							</td>
							<td class="mid">
									<div class="btn-group" data-toggle="buttons" id="gender" name="gender">
										<label class="btn btn-custom active">
											<input type="radio" id="is_left_handed" name="is_left_handed" value = "" autocomplete="off" checked>Any
										</label>
										<label class="btn btn-custom">
											<input type="radio" id="is_left_handed" name="is_left_handed" value = "true" autocomplete="off">True
										</label>
										<label class="btn btn-custom">
											<input type="radio" id="is_left_handed" name="is_left_handed" value = "false" autocomplete="off">False
										</label>
									</div>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="has_piercings"><b>Has Piercings:</b></label>
							</td>
							<td class="mid">
									<div class="btn-group" data-toggle="buttons" id="gender" name="gender">
										<label class="btn btn-custom active">
											<input type="radio" id="has_piercings" name="has_piercings" value = "" autocomplete="off" checked>Any
										</label>
										<label class="btn btn-custom">
											<input type="radio" id="has_piercings" name="has_piercings" value = "true" autocomplete="off">True
										</label>
										<label class="btn btn-custom">
											<input type="radio" id="has_piercings" name="has_piercings" value = "false" autocomplete="off">False
										</label>
									</div>
							</td>
							<td class="right">
								<p>Looking at the available data there are only 38 results, 24 have nose piercings, only 4 have lip piecings, 4 eyebrows, 4 None and 4 other.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="hobbies_details"><b>Hobbies:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="hobbies_details" id="hobbies_details" placeholder="Photography">
								</div>
							</td>
							<td class="right">
								<p>You can also use SPARQL's regular expression syntax. Some examples, '.' is a wildcard character, '*' matches 0-many of the previous expression. Partial searches can also work using "^" and/or "$" at the beginning and the end respectively. For example "^S" will result in all hobbies starting in "S" and "ing$" will result in all hobbies ending in "ing", Another example: "^S...ing$" will result in both Surfing and Singing. Searches are not case-sensitive. More information on it's special usage is below.</p>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		<div class="panel panel-default">
			<div class="panel-heading" data-toggle="collapse" data-parent="#accordion" href="#gmother">
				<h4 class="panel-title">Mothers Details</h4>
			</div>
			<div id="gmother" class="panel-collapse collapse">
				<div class="panel-body">
					<table>
						<tr>
							<td class="left">
								<label for="mother_cultural_heritage"><b>Cultural Heritage:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select class="form-control" name="mother_cultural_heritage" id="mother_cultural_heritage">
										<option value = "">Any</option>
										%for place in results['mother_cultural_heritage']:
											<option value="{{place}}">{{place}}</option>
										% end
									</select>
								</div>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="mother_professional_category"><b>Professional Category:</b></label>
							</td>
							<td class="mid">
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
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="mother_first_language"><b>First Language:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select type="text" class="form-control" name="mother_first_language" id="mother_first_language">
										<option value = "">Any</option>
										%for i in range(0, len(results['mother_first_language_int'])):
											<option value="{{results['mother_first_language_int'][i]}}">{{results['mother_first_language'][i]}}</option>
										% end
									</select>
								</div>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="mother_education_level"><b>Highest Qualification:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select class="form-control" name="mother_education_level" id="mother_education_level">
										<option value="">Any</option>
										%for qual in results['mother_education_level']:
											<option value="{{qual}}">{{qual}}</option>
										%end
									</select>
								</div>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="mother_pob_town"><b>Birth Town:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="mother_pob_town" id="mother_pob_town" placeholder="Sydney">
								</div>
							</td>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="mother_pob_state"><b>Birth State:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="mother_pob_state" id="mother_pob_state" placeholder="NSW">
								</div>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="mother_pob_country"><b>Birth Country:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select multiple size=4 class="form-control" name="mother_pob_country" id="mother_pob_country">
										<option value = "">Any</option>
										%for country in results['mother_pob_country']:
											<option value="{{country}}">{{country}}</option>
										%end
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
			<div class="panel-heading" data-toggle="collapse" data-parent="#accordion" href="#gfather">
				<h4 class="panel-title">Fathers Details</h4>
			</div>
			<div id="gfather" class="panel-collapse collapse">
				<div class="panel-body">
					<table>
						<tr>
							<td class="left">
								<label for="father_cultural_heritage"><b>Cultural Heritage:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select class="form-control" name="father_cultural_heritage" id="father_cultural_heritage">
										<option value = "">Any</option>
										%for place in results['father_cultural_heritage']:
											<option value="{{place}}">{{place}}</option>
										% end
									</select>
								</div>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="father_professional_category"><b>Professional Category:</b></label>
							</td>
							<td class="mid">
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
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="father_first_language"><b>First Language:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select type="text" class="form-control" name="father_first_language" id="father_first_language">
										<option value = "">Any</option>
										% for i in range(0, len(results['father_first_language_int'])):
											<option value="{{results['father_first_language_int'][i]}}">{{results['father_first_language'][i]}}</option>
										% end
									</select>
								</div>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="father_education_level"><b>Highest Qualification:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select class="form-control" name="father_education_level" id="father_education_level">
										<option value="">Any</option>
										%for qual in results['father_education_level']:
											<option value="{{qual}}">{{qual}}</option>
										%end
									</select>
								</div>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="father_pob_town"><b>Birth Town:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="father_pob_town" id="father_pob_town" placeholder="Sydney">
								</div>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="father_pob_state"><b>Birth State:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="father_pob_state" id="father_pob_state" placeholder="NSW">
								</div>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="father_pob_country"><b>Birth Country:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select multiple size=4 class="form-control" name="father_pob_country" id="father_pob_country">
										<option value = "">Any</option>
										%for country in results['father_pob_country']:
											<option value="{{country}}">{{country}}</option>
										%end
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
	</div> 
	<button type="submit" style="float:right;" class="btn btn-default">Submit</button>
</form>

<h2>Notes:</h2>

<p>Any fields left blank will not be used to filter results.</p>


<h3>Partial Searches and searching multiple cases</h3>

<p>Sometimes it's useful or just convenient to search for some particular cases. In some of the search fields you can search for everything that starts with, ends with, contains, strictly a single case or even a list of specifc cases you want.
Below explains the different ways you can utilize this along with examples.</p>
<p>Currently only "Speaker Id" and "Other languages" support this. Age is a special case which is explained above.</p>
<p>Note: &lt;search&gt; is used below to show what you'll have entered in related to the expression being described. None of the expressions use a '&lt;' or '&gt;'.</p>
<table>
	<tr>
		<td><b>Expression</b></td>
		<td><b>Usage</b></td>
		<td><b>Example</b></td>
	</tr>
	<tr>
		<td>&lt;search&gt;</td>
		<td>This is the case when you have nothing around your input, it will return anything that contains &lt;search&gt;.</td>
		<td>If you search "1_114" without quotes, it will return "1_114" and "1_1141"</td>
	</tr>
	<tr>
		<td>"&lt;search&gt;"</td>
		<td>In this case only exactly what you've typed will be searched for.</td>
		<td>If you search "1_114" with quotes, it will return "1_114" only</td>
	</tr>
	<tr>
		<td>&lt;search1&gt;, "&lt;search2&gt;", &lt;search3&gt;</td>
		<td>In this case not only case you select multiple options delimited by a comma, but you can also mix the above cases.</td>
		<td>If you search 1_114,"1_475" it will return "1_114", "1_1141" and "1_475"</td>
	</tr>
	<tr>
		<td>$&lt;search&gt;</td>
		<td>In this case you are searching for anything that starts with what your input.</td>
		<td>If you search "$Eng" without quotes in other languages, it will return "English"</td>
	</tr>
	<tr>
		<td>&lt;search&gt;^</td>
		<td>This case is similar to the one above however it's an 'ends with' case.</td>
		<td>If you search "man^" without quotes in other languages, it will return "German"</td>
	</tr>
	<tr>
		<td>.</td>
		<td>The full stop character is a wildcard character. Which means any single letter or number can replace it</td>
		<td>If you search for "...l..." without quotes in other languages, it will look for anything that is 7 letters long, with the letter 'l' in the middle.</td>
	</tr>
	<tr>
		<td>*</td>
		<td>The star character matches 0-many of the previous expression. It will primarily be useful for placing it after a full stop.</td>
		<td>If you search for ".*ap.*" without quotes in other languages, it will look for anything that somewhere in the word has "ap"</td>
	</tr>
</table>
<br><br><br>
</div>
	% include('bsfoot.tpl')
</body>

</html>
