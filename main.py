'''
@author: Dylan Wheeler

@summary: The Alveo query engine is designed to provide a more useful way of searching the Alveo database. Currently only supports the Austalk collection.
This file contains all the routing and much of the logic for the application. Run this to start the application. Listens on localhost:8080.
'''

import bottle
from beaker.middleware import SessionMiddleware
import alquery
import qbuilder
import pyalveo
import re

BASE_URL = 'https://app.alveo.edu.au/' #Normal Server
#BASE_URL = 'https://alveo-staging1.intersect.org.au/' #Staging Server
PREFIXES = """
        PREFIX dc:<http://purl.org/dc/terms/>
        PREFIX austalk:<http://ns.austalk.edu.au/>
        PREFIX olac:<http://www.language-archives.org/OLAC/1.1/>
        PREFIX ausnc:<http://ns.ausnc.org.au/schemas/ausnc_md_model/>
        PREFIX foaf:<http://xmlns.com/foaf/0.1/>
        PREFIX dbpedia:<http://dbpedia.org/ontology/>
        PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
        PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#>
        PREFIX geo:<http://www.w3.org/2003/01/geo/wgs84_pos#>
        PREFIX iso639schema:<http://downlode.org/rdf/iso-639/schema#>
        PREFIX austalkid:<http://id.austalk.edu.au/>
        PREFIX iso639:<http://downlode.org/rdf/iso-639/languages#> 
        PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
        PREFIX is: <http://purl.org/ontology/is/core#>
        PREFIX iso: <http://purl.org/iso25964/skos-thes#>
        PREFIX dada: <http://purl.org/dada/schema/0.2#>"""
        
session_opts = {
    'session.cookie_expires': False
}

app = SessionMiddleware(bottle.app(), session_opts)
        
@bottle.route('/styles/<filename>')
def serve_style(filename):
    '''Loads static files from views/styles. Store all .css files there.'''
    return bottle.static_file(filename, root='./views/styles')

def redirect_home():
    '''Redirects requests back to the homepage.'''
    bottle.redirect('/')
    
@bottle.route('/')
def search():
    '''The home page and participant search page. Drop-down lists are populated from the SPARQL database and the template returned.
    Displays the contents of session['message'] if one is set.'''
    
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
        
    try:
        apiKey = session['apikey']
        client = pyalveo.Client(apiKey, BASE_URL)
        quer = alquery.AlQuery(client)
    except KeyError:
        bottle.redirect('/login')
        
    try:
        message = session['message']
        session['message'] = ""
        session.save()
    except KeyError:
        session['message'] = ""
        message = session['message']
    
    cities = quer.results_list("austalk", PREFIXES+
    """    
        SELECT distinct ?val 
        where {
          ?part a foaf:Person .
          ?part austalk:recording_site ?site .
          ?site austalk:city ?val .}""")
    herit = quer.results_list("austalk", PREFIXES+
    """    
        SELECT distinct ?val 
        where {
          ?part a foaf:Person .
          ?part austalk:cultural_heritage ?val .}""")
    highQual = quer.results_list("austalk", PREFIXES+
    """    
        SELECT distinct ?val 
        where {
          ?part a foaf:Person .
          ?part austalk:education_level ?val .}""")
    profCat = quer.results_list("austalk", PREFIXES+
    """
        SELECT distinct ?val 
        where {
          ?part a foaf:Person .
          ?part austalk:professional_category ?val . } """)
    fLangDisp = quer.results_list("austalk", PREFIXES+
    """                            
        SELECT distinct ?flang
        WHERE {{
            ?part a foaf:Person .
            ?part austalk:first_language ?x .
            ?x iso639schema:name ?flang .
        } 
        UNION {
            ?part austalk:first_language ?flang .
            MINUS{
                ?flang iso639schema:name ?y}}}
        ORDER BY ?part""")
    fLangInt = quer.results_list("austalk", PREFIXES+
    """                            
        SELECT distinct ?val
        WHERE {
            ?part a foaf:Person .
            ?part austalk:first_language ?val .}
        ORDER BY ?part""")
    bCountries = quer.results_list("austalk", PREFIXES+
        """
        SELECT distinct ?val 
        where {
          ?part a foaf:Person .
          ?part austalk:pob_country ?val .}""")
    print message
    return bottle.template('psearch', cities=cities, herit=herit, highQual=highQual, profCat=profCat, fLangDisp=fLangDisp, fLangInt=fLangInt, bCountries=bCountries, message=message,
                           apiKey=apiKey)
    
@bottle.post('/presults')
def results():
    '''Perfoms a search of participants and display the results as a table. Saves the results in the session so they can be retrieved later'''
    
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    try:
        apiKey = session['apikey']
        client = pyalveo.Client(apiKey, BASE_URL)
        quer = alquery.AlQuery(client)
    except KeyError:
        bottle.redirect('/login')
        
    query = PREFIXES+ """
    
    SELECT ?participant ?gender (str(?a) as ?age) ?city ?bcountry ?btown"""
    
    #Building up the "Select" clause of the query from formdata for columns we only want to include if there's formdata.
    query = query + qbuilder.select_list(['olangs', 'bstate', 'ses', 'heritage',
                                         'profcat', 'highqual','speakerid'])
           
    query = query + """
    WHERE {
        ?participant a foaf:Person .
        ?participant austalk:recording_site ?site .
        ?site austalk:city ?city .
        ?participant foaf:age ?a .
        ?participant foaf:gender ?gender .
        ?participant austalk:first_language ?flang .
        ?participant austalk:pob_country ?bcountry .   
        ?participant austalk:pob_town ?btown .
    """
    #Building up the "Where" clause of the query from formdata for columns we only want to include if there's formdata.
    if bottle.request.forms.get('ses'):
        query = query + """?participant austalk:ses ?ses ."""
    if bottle.request.forms.get('olangs'):
        query = query + """?participant austalk:other_languages ?olangs ."""
    if bottle.request.forms.get('bstate'):
        query = query + """?participant austalk:pob_state ?bstate ."""
    if bottle.request.forms.get('heritage'):
        query = query + """?participant austalk:cultural_heritage ?heritage ."""
    if bottle.request.forms.get('profcat'):
        query = query + """?participant austalk:professional_category ?profcat ."""
    if bottle.request.forms.get('highqual'):
        query = query + """?participant austalk:education_level ?highqual ."""
        
          
    #Building filters.       
    query = query + qbuilder.simple_filter_list(['city', 'gender', 'heritage', 'ses', 'highqual',
                                             'profcat', 'bstate', 'btown'])
    query = query + qbuilder.to_str_filter('flang')
    query = query + qbuilder.num_range_filter('a')
    query = query + qbuilder.regex_filter('olangs')
    #since birth country is a multipple select, it can be gotten as a list. We can now put it together so it's as
    #if it's a normal user entered list of items.
    customStr = "".join('''"%s",''' % s for s in bottle.request.forms.getall('bcountry'))[0:-1]
    
    query = query + qbuilder.regex_filter('bcountry',custom=customStr)
    query = query + qbuilder.regex_filter('participant',toString=True,prepend="http://id.austalk.edu.au/participant/")
                         
    query = query + "} ORDER BY ?participant"
    
    resultsList = quer.results_dict_list("austalk", query)
    
    session['partlist'] = resultsList
    session['partcount'] = session['resultscount']
    session.save()
    
    return bottle.template('presults', resultsList=resultsList, resultCount=session['partcount'], apiKey=apiKey)

@bottle.get('/presults')
def part_list():
    '''Displays the results of the last participant search, or redirects home if no such search has been performed yet.'''
    
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    try:
        apiKey = session['apikey']
    except KeyError:
        bottle.redirect('/login')
        
    try:
        resultsList = session['partlist']
    except KeyError:
        session['message'] = "Perform a participant search first."
        session.save()
        redirect_home()
        
    return bottle.template('presults', resultsList=resultsList, resultCount=session['partcount'], apiKey=apiKey)

@bottle.post('/removeparts')
def remove_parts():
    '''Removes selected participants from the list of participants and saves the edited list back into the session.'''
    
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    partList = session['partlist']
    
    selectedParts = bottle.request.forms.getall('selected')
    
    newPartList = [p for p in partList if p['participant'] not in selectedParts]
    
    session['partcount'] = session['partcount'] - len(selectedParts)
    session['partlist'] = newPartList
    session.save()
             
    bottle.redirect('/presults')
    

@bottle.post('/itemresults')
def item_results():
    '''Like results(), but for items not participants. Functionally similar.'''
    
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    try:
        apiKey = session['apikey']
        client = pyalveo.Client(apiKey, BASE_URL)
        quer = alquery.AlQuery(client)
    except KeyError:
        bottle.redirect('/login')
    
    query = PREFIXES + """   
    SELECT distinct ?item ?prompt ?compname
    WHERE {
      ?item a ausnc:AusNCObject .
      ?item olac:speaker <%s> .
      ?item austalk:prompt ?prompt .
      ?item austalk:componentName ?compname .
     """
     
    if bottle.request.forms.get('anno') == "required":
        query = query + """?ann dada:annotates ?item ."""
     
    partList = session['partlist']
    resultsList = []
    itemList = []
    resultsCount = 0
    
    query = query + qbuilder.regex_filter('prompt')
    query = query + qbuilder.regex_filter('compname')
    
    if bottle.request.forms.get('comptype') != "":
        query=query+"""FILTER regex(?compname, "%s", "i")""" % (bottle.request.forms.get('comptype'))
    
    if bottle.request.forms.get('wlist')=='hvdwords':
        query=query+"""FILTER regex(?prompt, "^head$|^had$|^hud$|^hard$|^heared$|^heed$|^hid$|^herd$|^howd$|^hoyd$|^haired$|^hood$|^hod$", "i")"""
    
    if bottle.request.forms.get('wlist')=='hvdmono':
        query=query+"""FILTER regex(?prompt, "^head$|^had$|^hud$|^heed$|^hid$|^herd$|^hood$|^hod$", "i")"""
    
    if bottle.request.forms.get('wlist')=='hvddip':
        query=query+"""FILTER regex(?prompt, "^hard$|^heared$|^herd$|^howd$|^hoyd$|^haired$", "i")"""
    
    query = query + "}"
    
    for row in partList:
        row['item_results'] = quer.results_dict_list("austalk", query % (row['participant']))
        resultsCount = resultsCount + session['resultscount']
        itemList = itemList + session['lastresults']
    
    session['itemlist'] = itemList
    session['itemcount'] = resultsCount
    session['itemhtml'] = resultsList
    session.save()
    
    return bottle.template('itemresults', partList=partList, resultsList=resultsList, resultsCount=resultsCount, apiKey=apiKey)

@bottle.get('/itemresults')
def item_list():
    '''Like part_list but for items. Note that it is functionally different, so these two functions can't currently be rolled together.'''
    
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    try:
        apiKey = session['apikey']
    except KeyError:
        bottle.redirect('/login')
        
    try:
        resultsTable = session['itemhtml']
    except KeyError:
        session['message'] = "Perform an item search first."
        session.save()
        redirect_home()
        
    return bottle.template('itemresults', partList=session['partlist'],  resultsList=resultsTable, resultsCount=session['itemcount'], apiKey=apiKey)

@bottle.post('/removeitems')
def remove_items():
    '''Like remove_parts but for items. Again, not functionally identical.'''
    
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    resultsTable = session['itemhtml']
    itemList = session['itemlist']
    
    selectedItems = bottle.request.forms.getall('selected')
    
    for item in selectedItems:
        itemList.remove(item)
        for i in range(0, len(resultsTable)):
            print item
            print resultsTable[i]
            if re.search("""<tr><td><input type="checkbox" name="selected" value="%s">.*?</tr>""" % (item), resultsTable[i]):
                result = resultsTable.pop(i)
                result = re.sub("""<tr><td><input type="checkbox" name="selected" value="%s">.*?</tr>""" % (item), '', result)
                resultsTable.insert(i, result)

    
    session['itemcount'] = session['itemcount'] - len(selectedItems)
    session['itemhtml'] = resultsTable
    session['itemlist'] = itemList
    session.save()
             
    bottle.redirect('/itemresults')


@bottle.route('/itemsearch')
@bottle.post('/itemsearch')
def item_search():
    '''Displays the page for searching items, unless there's not yet a group of participants selected to search for.'''
    
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    try:
        apiKey = session['apikey']
    except KeyError:
        bottle.redirect('/login')
        
    try:
        partList = session['partlist'] #@UnusedVariable
    except KeyError:
        session['message'] = "Select some participants first."
        session.save()
        redirect_home()
        
    return bottle.template('itemsearch', apiKey=apiKey)
    
@bottle.get('/export')
@bottle.post('/export')
def export():
    '''Exports a selected set of items to Alveo if method is POST. If method is GET, displays a simple form to allow said exporting
    unless no items have yet been selected to export. Redirects home after the export is completed'''
    
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    try:
        apiKey = session['apikey']
        client = pyalveo.Client(apiKey, BASE_URL)
    except KeyError:
        bottle.redirect('/login')
        
    try:
        itemList = pyalveo.ItemGroup(session['itemlist'], client)
    except KeyError:
        session['message'] = "Select some items first."
        session.save()
        bottle.redirect('/')
    
    if bottle.request.forms.get('listname') != None:
        listName = bottle.request.forms.get('listname')
        itemList.add_to_item_list_by_name(listName)
        session['message'] = "List exported to Alveo."
        session.save()
        bottle.redirect('/')
    else:
        itemLists = client.get_item_lists()     
        return bottle.template('export', apiKey=apiKey, itemLists=itemLists)
    
@bottle.get('/login')
def login():
    '''Login page.'''
    
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    try:
        apiKey = session['apikey']
    except KeyError:
        apiKey = 'Not logged in.'
    
    return bottle.template('login', apiKey=apiKey)

@bottle.post('/login')
def logged_in():  
    '''Logs the user in with their API key.'''
    
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable   
    session['apikey'] = bottle.request.forms.get('apikey')
    session['message'] = "Login successful."
    session.save()
    bottle.redirect('/')

if __name__ == '__main__':
    '''Runs the app. Listens on localhost:8080.'''
    bottle.run(app=app, host='localhost', port=8080, debug=True)


