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
<p>First, search by participants. You can then filter the items relating to these participants.</p>

<div class="search_form">
<form action="/presults" method="POST">
	<table>
	 <tr>
	 <td>
		Speaker Id: <input type="text" name="participant">
	  </td>
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
	 </tr>
	 <tr>
	 <td>
		Test Location: <select name="city" >
		    <option value = "">Any</option>
			% for city in cities:
			<option value="{{city}}">{{city}}</option>
			% end
		</select>
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
		Birth Country: <br> <select name="bcountry" multiple size=4>
			<option value = "">Any</option>
			%for country in bCountries:
			<option value="{{country}}">{{country}}</option>
			%end
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
	 <td><p>You can also use SPARQL's regular expression syntax. Some examples, '.' is a wildcard character, '*' matches 0-many of the previous expression. Partial searches can also work using "^" and "$", for example "^Eng" will result in all languages starting in "Eng" and "man$" will result in all languages ending in "man". Searches are not case-sensitive. Look below for more information.</p></td>
	</tr>
	<tr>
	  <td><b>Participants:</b></td>
	  <td>You can search for individual speakers by entering their speaker id's. Similar to Other languages, you can search for multiple participants by separating them with a "," and partial searches also work. More information on it's special usage is below.</td>
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

<h3>Partial Searches and searching multiple cases</h4>

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

</div>
	% include('bsfoot.tpl')
</body>

</html>
