<!DOCTYPE html>
<html>
<head>
	<title>Alveo Query Engine</title>
	<link rel="stylesheet" type="text/css" href="/styles/style.css">
</head>



<body>

<div class="navi">
	% include('nav.tpl', apiKey=apiKey, title="Search Participants")
</div>

<div class="message">
	<p style="margin-left:15px;"><b>{{message}}</b></p>
</div>

<div class="content">
<p>First, search by participants. You can then filter the items relating to these participants.</p>

<div class="search_form">
<form action="/presults" method="POST">
	<table>
	 <tr>
	  <td>
		Gender: <select name="gender">
			<option value = "">Any</option>
			<option value = "male">Male</option>
			<option value = "female">Female</option>
		</select>
	  </td>
	  <td>		
		Age: <input type="text" name="a">
	  </td>
	  <td>
		Test Location: <select name="city" >
		    <option value = "">Any</option>
			% for city in cities:
			<option value="{{city}}">{{city}}</option>
			% end
		</select>
	  </td>
	 </tr>
	 <tr>
	  <td>
		Birth Country: <select name="bcountry">
			<option value = "">Any</option>
			%for country in bCountries:
			<option value="{{country}}">{{country}}</option>
			%end
	  </td>
	  <td>
		Birth State: <input type="text" name="bstate">
	  </td>
	  <td>
		Birth Town <input type="text" name="btown">
	  </td>
	 </tr>
	 <tr>
	  <td>
		First Language: <select name="flang">
			<option value = "">Any</option>
			% for i in range(0, len(fLangInt)):
			<option value="{{fLangInt[i]}}">{{fLangDisp[i]}}</option>
			% end
	  </td>
	  <td>
	  Other Languages: <input type="text" name="olangs">
	 </tr>
	 <tr>
	  <td>
	  	Professional Category: <select name="profcat">
	  		<option value="">Any</option>
	  		%for prof in profCat:
	  		<option value="{{prof}}">{{prof}}</option>
	  		%end  
	  </td>
	  <td>
		Highest Qualification: <select name="highqual">
			<option value="">Any</option>
			%for qual in highQual:
			<option value="{{qual}}">{{qual}}</option>
			%end
		</select>
	  </td>
	  <td>
		Socio-economic Status: <select name="ses">
			<option value="">Any</option>
			<option value="professional">Professional</option>
			<option value="Non professional">Non-professional</option>
			</select>
	  </td>
	 </tr>
	 <tr>
	  <td>
		Cultural Heritage: <select name="heritage">
				<option value = "">Any</option>
				%for place in herit:
				<option value="{{place}}">{{place}}</option>
				% end
			</select>
	  </td>
	  <td>
		Speaker Id: <input type="text" name="participant">
	  </td>
	 </tr>	 
	 <tr>
	  <td>
    <input value="Search" type="submit">
	  </td>
	 </tr>
	</table>
</form>
</div>

<h2>Notes:</h2>

<p>Any fields left blank will not be used to filter results.</p>

<table>
	<tr>
	 <td><b>Age:</b></td>
	 <td>Enter a single number to search for a specific age. Enter two numbers separated by a hyphen (e.g, "18-50") to search for a range of ages. Enter a negative number (e.g, "-50") to search
	 for people at or under a specific age.<br>
	 Enter a number followed by a + (e.g, "50+") to search for people at or over a specific age.</td>
	</tr>
	<tr>
	 <td><b>Other Languages:</b></td>
	 <td>Example usage:<ul><li>Entering "Japanese" (without quotes) will return all participants whose other languages include Japanese.</li>
						   <li>Entering "Japanese" (with quotes) will return participants whose ONLY other language is Japanese.</li>
						   <li>Entering "Japanese, Hindi" (without quotes) will return participants whose other languages include Japanese or Hindi or both.</li></ul>
		 <p>You can also use SPARQL's regular expression syntax. Some examples, '.' is a wildcard character, '*' matches 0-many of the previous expression. Partial searches can also work using "^" and "$", for example "^Eng" will result in all languages starting in "Eng" and "man$" will result in all languages ending in "man". Searches are not case-sensitive.</p></td>
	</tr>
	<tr>
	  <td><b>Participants:</b></td>
	  <td>You can search for individual speakers by entering their speaker id's. Similar to Other languages, you can search for multiple participants by separating them with a "," and partial searches also work. Note that it may be necessary to end an id with "$" as searching for participant "1_114" with return both "1_114" and "1_1141".</td>
	</tr>					   
	<tr>
	 <td><b>Professional Category:</b></td>
	 <td>Searching for "clerical and service" or "intermediate clerical and service" will cause a server error. All other values work. No idea why this is happening, fixing it is on the to do list.</td>
	</tr>
	<tr>
	 <td><b>Socio-economic Status:</b></td>
	 <td>Only about half of the participants have data for this field. If a choice is specified, participants with unknown socio-economic status will be omitted from results.</td>
	</tr>
	<tr>
	 <td><b>First Language:</b></td>
	 <td>Not displayed in results, but does search correctly.</td>
	</tr>
	<tr>
	  <td><b>Test Location:</b></td>
	  <td>The location of where the speaker was tested, not their home town.</td>
	</tr>
</table>
	 
</div>
	 
</body>

</html>