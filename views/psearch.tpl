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
								<div class="form-group">
									<label for="participant">Speaker Id:</label>
									<input type="text" class="form-control" name="participant" id="participant" placeholder="1_114">
								</div>
							</td>
							<td class="right">
								<p>You can search for individual speakers by entering their speaker id's. You can also use SPARQL's regular expression syntax. Some examples, '.' is a wildcard character, '*' matches 0-many of the previous expression. Partial searches can also work using "^" and/or "$" at the beginning and the end respectively. Searches are not case-sensitive. More information on it's special usage is below.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<div class="form-group">
									<label for="gender">Gender:</label>
									<select class="form-control" id="gender" name="gender">
										<option value = "">Any</option>
										<option value = "male">Male</option>
										<option value = "female">Female</option>
									</select>
								</div>
							</td>
							<td class="right">
								<p>You can search by the gender of the participants.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<div class="form-group">
									<label for="a">Age:</label>
									<input type="text" class="form-control" name="a" id="a" placeholder="-25">
								</div>
							</td>
							<td class="right">
								<p>Enter a single number to search for a specific age. Enter two numbers separated by a hyphen (e.g, "18-50") to search for a range of ages.<br>Enter a negative number (e.g, "-50") to search for people at or under a specific age.<br>Enter a number followed by a + (e.g, "50+") to search for people at or over a specific age.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<div class="form-group">
									<label for="city">Test Location:</label>
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
								<div class="form-group">
									<label for="btown">Birth Town:</label>
									<input type="text" class="form-control" name="btown" id="btown" placeholder="Sydney">
								</div>
							</td>
							<td class="right">
								<p>You can search by the town of which the participant was born in. It currently doesn't support multiple towns.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<div class="form-group">
									<label for="bstate">Birth State:</label>
									<input type="text" class="form-control" name="bstate" id="bstate" placeholder="NSW">
								</div>
							</td>
							<td class="right">
								<p>Here you can select the State or Territory the participants were born in. You must enter the abbreviated names of the states such as "VIC" or "WA". This works for international states however very few are given and may not represent an accurate abbreviation for that state.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<div class="form-group">
									<label for="bcountry">Birth Country:</label>
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
								<div class="form-group">
									<label for="profcat">Professional Category:</label>
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
								<div class="form-group">
									<label for="highqual">Highest Qualification:</label>
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
								<div class="form-group">
									<label for="ses">Socio-economic Status:</label>
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
								<div class="form-group">
									<label for="flang">First Language:</label>
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
								<div class="form-group">
									<label for="olangs">Other Languages:</label>
									<input type="text" class="form-control" name="olangs" id="olangs" placeholder="German">
								</div>
							</td>
							<td class="right">
								<p>You can also use SPARQL's regular expression syntax. Some examples, '.' is a wildcard character, '*' matches 0-many of the previous expression. Partial searches can also work using "^" and/or "$" at the beginning and the end respectively. For example "^Eng" will result in all languages starting in "Eng" and "man$" will result in all languages ending in "man". Searches are not case-sensitive. More information on it's special usage is below.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<div class="form-group">
									<label for="city">Cultural Heritage:</label>
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
								<label for="is_student">Is Student:</label>
									<select class="form-control" id="is_student" name="is_student">
										<option value = "">Any</option>
										<option value = "true">True</option>
										<option value = "false">False</option>
									</select>
							</td>
							<td class="right">
								<p>Is student</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="is_smoker">Is Smoker:</label>
									<select class="form-control" id="is_smoker" name="is_smoker">
										<option value = "">Any</option>
										<option value = "true">True</option>
										<option value = "false">False</option>
									</select>
							</td>
							<td class="right">
								<p>Is smoker</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="has_speech_problems">Has Speech Problems:</label>
									<select class="form-control" id="has_speech_problems" name="has_speech_problems">
										<option value = "">Any</option>
										<option value = "true">True</option>
										<option value = "false">False</option>
									</select>
							</td>
							<td class="right">
								<p>Has speech problems</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="has_hearing_problems">Has Hearing Problems:</label>
									<select class="form-control" id="has_hearing_problems" name="has_hearing_problems">
										<option value = "">Any</option>
										<option value = "true">True</option>
										<option value = "false">False</option>
									</select>
							</td>
							<td class="right">
								<p>Has hearing problems</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="has_reading_problems">Has Reading Problems:</label>
									<select class="form-control" id="has_reading_problems" name="has_reading_problems">
										<option value = "">Any</option>
										<option value = "true">True</option>
										<option value = "false">False</option>
									</select>
							</td>
							<td class="right">
								<p>Has reading problems</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="has_vocal_training">Has Vocal Training:</label>
									<select class="form-control" id="has_vocal_training" name="has_vocal_training">
										<option value = "">Any</option>
										<option value = "true">True</option>
										<option value = "false">False</option>
									</select>
							</td>
							<td class="right">
								<p>Has vocal training</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="has_dentures">Has Dentures:</label>
									<select class="form-control" id="has_dentures" name="has_dentures">
										<option value = "">Any</option>
										<option value = "true">True</option>
										<option value = "false">False</option>
									</select>
							</td>
							<td class="right">
								<p>Has Dentures</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="has_health_problems">Has Health Problems:</label>
									<select class="form-control" id="has_health_problems" name="has_health_problems">
										<option value = "">Any</option>
										<option value = "true">True</option>
										<option value = "false">False</option>
									</select>
							</td>
							<td class="right">
								<p>Had health problems on the day</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="is_left_handed">Is Left Handed:</label>
									<select class="form-control" id="is_left_handed" name="is_left_handed">
										<option value = "">Any</option>
										<option value = "true">True</option>
										<option value = "false">False</option>
									</select>
							</td>
							<td class="right">
								<p>Left handed</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<label for="has_piercings">Has Piercings:</label>
									<select class="form-control" id="has_piercings" name="has_piercings">
										<option value = "">Any</option>
										<option value = "true">True</option>
										<option value = "false">False</option>
									</select>
							</td>
							<td class="right">
								<p>Looking at the available data there are only 38 results, 24 have nose piercings, only 4 have lip piecings, 4 eyebrows, 4 None and 4 other.</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<div class="form-group">
									<label for="hobbies">Hobbies:</label>
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
								<div class="form-group">
									<label for="city">Cultural Heritage:</label>
									<select class="form-control" name="heritage" id="heritage">
										<option value = "">Any</option>
										%for place in results['herit']:
											<option value="{{place}}">{{place}}</option>
										% end
									</select>
								</div>
							</td>
							<td class="right">
								<p>Cultural Heritage TODO</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<div class="form-group">
									<label for="profcat">Professional Category:</label>
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
								<p>Professional catagory TODO</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<div class="form-group">
									<label for="mother_flang">First Language:</label>
									<select type="text" class="form-control" name="mother_flang" id="mother_flang">
										<option value = "">Any</option>
										%for i in range(0,46):
										%	print "Count:%d \t Disp: %s \t\tInt: %s" % (i,results['mother_fLangDisp'][i],results['mother_fLangInt'][i])
										%end
										%for i in range(46,len(results['mother_fLangInt'])):
										%	print "Extra Int: %s" % results['mother_fLangInt'][i]
										%end
										%for i in range(46,len(results['mother_fLangDisp'])):
										%	print "Extra Disp: %s" % results['mother_fLangDisp'][i]
										%end
										%for i in range(0, len(results['mother_fLangInt'])):
										%#for i in range(0, 1): #because of some bug, see logbook 07/06/2016
											<option value="{{results['mother_fLangInt'][i]}}">{{results['mother_fLangDisp'][i]}}</option>
										% end
									</select>
								</div>
							</td>
							<td class="right">
								<p>First language</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<div class="form-group">
									<label for="highqual">Highest Qualification:</label>
									<select class="form-control" name="highqual" id="highqual">
										<option value="">Any</option>
										%for qual in results['highQual']:
											<option value="{{qual}}">{{qual}}</option>
										%end
									</select>
								</div>
							</td>
							<td class="right">
								<p>Education Level TODO</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<div class="form-group">
									<label for="btown">Birth Town:</label>
									<input type="text" class="form-control" name="btown" id="btown" placeholder="Sydney">
								</div>
							</td>
							</td>
							<td class="right">
								<p>Town of birth TODO</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<div class="form-group">
									<label for="bstate">Birth State:</label>
									<input type="text" class="form-control" name="bstate" id="bstate" placeholder="NSW">
								</div>
							</td>
							<td class="right">
								<p>State of Birth TODO</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<div class="form-group">
									<label for="bcountry">Birth Country:</label>
									<select multiple size=4 class="form-control" name="bcountry" id="bcountry">
										<option value = "">Any</option>
										%for country in results['bCountries']:
											<option value="{{country}}">{{country}}</option>
										%end
									</select>
								</div>
							</td>
							<td class="right">
								<p>Country of Birth TODO</p>
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
								<div class="form-group">
									<label for="city">Cultural Heritage:</label>
									<select class="form-control" name="heritage" id="heritage">
										<option value = "">Any</option>
										%for place in results['herit']:
											<option value="{{place}}">{{place}}</option>
										% end
									</select>
								</div>
							</td>
							<td class="right">
								<p>Cultural Heritage TODO</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<div class="form-group">
									<label for="profcat">Professional Category:</label>
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
								<p>Professional catagory TODO</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<div class="form-group">
									<label for="father_flang">First Language:</label>
									<select type="text" class="form-control" name="father_flang" id="father_flang">
										<option value = "">Any</option>
										%# for i in range(0, len(results['father_fLangInt'])):
										% for i in range(0, 1): #because of some bug, see logbook 07/06/2016
											<option value="{{results['father_fLangInt'][i]}}">{{results['father_fLangDisp'][i]}}</option>
										% end
									</select>
								</div>
							</td>
							<td class="right">
								<p>First language TODO</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<div class="form-group">
									<label for="highqual">Highest Qualification:</label>
									<select class="form-control" name="highqual" id="highqual">
										<option value="">Any</option>
										%for qual in results['highQual']:
											<option value="{{qual}}">{{qual}}</option>
										%end
									</select>
								</div>
							</td>
							<td class="right">
								<p>Education Level TODO</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<div class="form-group">
									<label for="btown">Birth Town:</label>
									<input type="text" class="form-control" name="btown" id="btown" placeholder="Sydney">
								</div>
							</td>
							<td class="right">
								<p>Town of birth TODO</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<div class="form-group">
									<label for="bstate">Birth State:</label>
									<input type="text" class="form-control" name="bstate" id="bstate" placeholder="NSW">
								</div>
							</td>
							<td class="right">
								<p>State of Birth TODO</p>
							</td>
						</tr>
						<tr>
							<td class="left">
								<div class="form-group">
									<label for="bcountry">Birth Country:</label>
									<select multiple size=4 class="form-control" name="bcountry" id="bcountry">
										<option value = "">Any</option>
										%for country in results['bCountries']:
											<option value="{{country}}">{{country}}</option>
										%end
									</select>
								</div>
							</td>
							<td class="right">
								<p>Country of Birth TODO</p>
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
