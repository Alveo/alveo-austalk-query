<!DOCTYPE html>
<html>
<head>
	% include('bshead.tpl')
</head>



<body>

<div class="navi">
	% include('nav.tpl', apiKey=apiKey, title="PSearch",loggedin=True)

</div>




<div class="content">
	%if len(message)>0:
	<div class="alert alert-warning" role="alert">
		<p><b>{{message}}</b></p>
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
								<label for="participant"><b>Participant Id:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="participant" id="participant" placeholder="1_114">
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
								<label for="a"><b>Age:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="a" id="a" placeholder="-25">
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
										% for city in results['cities']:
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
				<h4 class="panel-title">Birth and Residential Details</h4>
			</div>
			<div id="glocation" class="panel-collapse collapse">
				<div class="panel-body">
					<table>
						<tr>
							<td class="left">
								<label for="btown"><b>Birth Town:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="btown" id="btown" placeholder="Sydney">
								</div>
							</td>
							<td class="right">
								<p>You can search by the town of which the participant was born in. It currently doesn't support multiple towns.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="bstate"><b>Birth State:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="bstate" id="bstate" placeholder="NSW">
								</div>
							</td>
							<td class="right">
								<p>Here you can select the State or Territory the participants were born in. You must enter the abbreviated names of the states such as "VIC" or "WA". This works for international states however very few are given and may not represent an accurate abbreviation for that state.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="bcountry"><b>Birth Country:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select multiple size=4 class="form-control" name="bcountry" id="bcountry">
										<option value = "">Any</option>
										%for country in results['bCountries']:
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
									<select class="form-control" name="profcat" id="profcat">
								  		<option value="">Any</option>
								  		%for prof in results['profCat']:
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
									<select class="form-control" name="highqual" id="highqual">
										<option value="">Any</option>
										%for qual in results['highQual']:
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
								<label for="flang"><b>First Language:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select type="text" class="form-control" name="flang" id="flang">
										<option value = "">Any</option>
										% for i in range(0, len(results['fLangInt'])):
											<option value="{{results['fLangInt'][i]}}">{{results['fLangDisp'][i]}}</option>
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
								<label for="olangs"><b>Other Languages:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="olangs" id="olangs" placeholder="German">
								</div>
							</td>
							<td class="right">
								<p>You can also use SPARQL's regular expression syntax. Some examples, '.' is a wildcard character, '*' matches 0-many of the previous expression. Partial searches can also work using "^" and/or "$" at the beginning and the end respectively. For example "^Eng" will result in all languages starting in "Eng" and "man$" will result in all languages ending in "man". Searches are not case-sensitive. More information on it's special usage is below.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="heritage"><b>Cultural Heritage:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select class="form-control" name="heritage" id="heritage">
										<option value = "">Any</option>
										%for place in results['herit']:
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
								<label for="hobbies"><b>Hobbies:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="hobbies" id="hobbies" placeholder="Photography">
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
								<label for="mother_heritage"><b>Cultural Heritage:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select class="form-control" name="mother_heritage" id="mother_heritage">
										<option value = "">Any</option>
										%for place in results['mother_herit']:
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
								<label for="mother_profcat"><b>Professional Category:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select class="form-control" name="mother_profcat" id="mother_profcat">
								  		<option value="">Any</option>
								  		%for prof in results['mother_profCat']:
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
								<label for="mother_flang"><b>First Language:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select type="text" class="form-control" name="mother_flang" id="mother_flang">
										<option value = "">Any</option>
										%for i in range(0, len(results['mother_fLangInt'])):
											<option value="{{results['mother_fLangInt'][i]}}">{{results['mother_fLangDisp'][i]}}</option>
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
								<label for="mother_highqual"><b>Highest Qualification:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select class="form-control" name="mother_highqual" id="mother_highqual">
										<option value="">Any</option>
										%for qual in results['mother_highQual']:
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
								<label for="mother_btown"><b>Birth Town:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="mother_btown" id="mother_btown" placeholder="Sydney">
								</div>
							</td>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="mother_bstate"><b>Birth State:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="mother_bstate" id="mother_bstate" placeholder="NSW">
								</div>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="mother_bcountry"><b>Birth Country:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select multiple size=4 class="form-control" name="mother_bcountry" id="mother_bcountry">
										<option value = "">Any</option>
										%for country in results['mother_bCountries']:
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
								<label for="father_heritage"><b>Cultural Heritage:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select class="form-control" name="father_heritage" id="father_heritage">
										<option value = "">Any</option>
										%for place in results['father_herit']:
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
								<label for="father_profcat"><b>Professional Category:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select class="form-control" name="father_profcat" id="father_profcat">
								  		<option value="">Any</option>
								  		%for prof in results['father_profCat']:
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
								<label for="father_flang"><b>First Language:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select type="text" class="form-control" name="father_flang" id="father_flang">
										<option value = "">Any</option>
										% for i in range(0, len(results['father_fLangInt'])):
											<option value="{{results['father_fLangInt'][i]}}">{{results['father_fLangDisp'][i]}}</option>
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
								<label for="father_highqual"><b>Highest Qualification:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select class="form-control" name="father_highqual" id="father_highqual">
										<option value="">Any</option>
										%for qual in results['father_highQual']:
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
								<label for="father_btown"><b>Birth Town:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="father_btown" id="father_btown" placeholder="Sydney">
								</div>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="father_bstate"><b>Birth State:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<input type="text" class="form-control" name="father_bstate" id="father_bstate" placeholder="NSW">
								</div>
							</td>
							<td class="right">
								<p></p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="father_bcountry"><b>Birth Country:</b></label>
							</td>
							<td class="mid">
								<div class="form-group">
									<select multiple size=4 class="form-control" name="father_bcountry" id="father_bcountry">
										<option value = "">Any</option>
										%for country in results['father_bCountries']:
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
