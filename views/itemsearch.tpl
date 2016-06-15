<!DOCTYPE html>
<html>
<head>
	% include('bshead.tpl')
</head>

<body>

<div class="navi">
	% include('nav.tpl', apiKey=apiKey, title="ISearch",loggedin=True)
</div>

<div class="content">
<div class="search_form">
<form action="/itemresults" method="POST">
<table>
 <tr>
  <td>
	Prompt: <input type="text" name="prompt">
  </td>
  <td>
	Component: <input type="text" name="compname">
  </td>
  <td>
   <input type="checkbox" name="anno" value="required"> Show annotated items only
  </td>
 </tr>
 <tr>
  <td>
	Word List: <select name="wlist">
		<option value="">None</option>
		<option value="hvdwords">hVd Words</option>
		<option value="hvdmono">hVd Monophthongs</option>
		<option value="hvddip">hVd Diphthongs</option>
	</select>
  </td>
  <td>
	Component Type: <select name="comptype">
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
