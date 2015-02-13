'''
@author: Dylan Wheeler
'''

import bottle
from beaker.middleware import SessionMiddleware
import alquery
import qbuilder
import pyalveo

BASE_URL = 'https://app.alveo.edu.au/'
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
        PREFIX iso: <http://purl.org/iso25964/skos-thes#>"""
        
session_opts = {
    'session.cookie_expires': True
}

app = SessionMiddleware(bottle.app(), session_opts)
        
@bottle.route('/styles/<filename>')
def serve_style(filename):
    return bottle.static_file(filename, root='./views/styles')

@bottle.get('/itemsearch')
@bottle.get('/itemresults')
@bottle.get('/presults')
@bottle.get('/export')
def redirect_home():
    bottle.redirect('/')
    
@bottle.route('/')
def search():
    
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

    return bottle.template('psearch', cities=cities, herit=herit, highQual=highQual, profCat=profCat, fLangDisp=fLangDisp, fLangInt=fLangInt, bCountries=bCountries, message=message,
                           apiKey=apiKey)
    
@bottle.post('/presults')
def results():
    
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    try:
        apiKey = session['apikey']
        client = pyalveo.Client(apiKey, BASE_URL)
        quer = alquery.AlQuery(client)
    except KeyError:
        bottle.redirect('/login')
        
    query = PREFIXES+ """
    
    SELECT ?participant ?gender (str(?a) as ?age) ?city ?bcountry"""
    
    #Building up the "Select" clause of the query from formdata for columns we only want to include if there's formdata.
    query = query + qbuilder.select_list(['olangs', 'bstate', 'btown', 'ses', 'heritage',
                                         'profcat', 'highqual'])
           
    query = query + """
    WHERE {
        ?participant a foaf:Person .
        ?participant austalk:recording_site ?site .
        ?site austalk:city ?city .
        ?participant foaf:age ?a .
        ?participant foaf:gender ?gender .
        ?participant austalk:first_language ?flang .
        ?participant austalk:pob_country ?bcountry .   
    """
    #Building up the "Where" clause of the query from formdata for columns we only want to include if there's formdata.
    if bottle.request.forms.get('ses'):
        query = query + """?participant austalk:ses ?ses ."""
    if bottle.request.forms.get('olangs'):
        query = query + """?participant austalk:other_languages ?olangs ."""
    if bottle.request.forms.get('bstate'):
        query = query + """?participant austalk:pob_state ?bstate ."""
    if bottle.request.forms.get('btown'):
        query = query + """?participant austalk:pob_town ?btown ."""
    if bottle.request.forms.get('heritage'):
        query = query + """?participant austalk:cultural_heritage ?heritage ."""
    if bottle.request.forms.get('profcat'):
        query = query + """?participant austalk:professional_category ?profcat ."""
    if bottle.request.forms.get('highqual'):
        query = query + """?participant austalk:education_level ?highqual ."""
          
    #Building filters.       
    query = query + qbuilder.simple_filter_list(['city', 'gender', 'heritage', 'ses', 'highqual',
                                             'profcat', 'bcountry', 'bstate', 'btown'])
    query = query + qbuilder.to_str_filter('flang')
    query = query + qbuilder.num_range_filter('a')
    query = query + qbuilder.regex_filter('olangs')
                         
    query = query + "} ORDER BY ?participant"

    resultsTable = quer.html_table("austalk", query)
    session['partlist'] = session['lastresults']
    
    return bottle.template('presults', resultsTable=resultsTable, resultCount=session['resultscount'], apiKey=apiKey)

@bottle.post('/itemresults')
def item_results():
    
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
     
    partList = session['partlist']
    resultsList = []
    itemList = []
    resultsCount = 0
    
    query = query + qbuilder.regex_filter('prompt')
    query = query + qbuilder.regex_filter('compname')
    
    query = query + "}"
    
    for part in partList:
        resultsList.append(quer.html_table("austalk", query % (part)))
        resultsCount = resultsCount + session['resultscount']
        itemList = itemList + session['lastresults']
    
    session['itemlist'] = itemList
    session.save()
    return bottle.template('itemresults', partList=partList, resultsList=resultsList, resultsCount=resultsCount, apiKey=apiKey)

@bottle.post('/itemsearch')
def item_search():
    
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    try:
        apiKey = session['apikey']
    except KeyError:
        bottle.redirect('/login')
        
    return bottle.template('itemsearch', apiKey=apiKey)

@bottle.post('/export')
def export():
    
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    if session['apikey'] == None:
        bottle.redirect('/login')
        
    apiKey = session['apikey']
    client = pyalveo.Client(apiKey, BASE_URL)
    
    itemList = pyalveo.ItemGroup(session['itemlist'], client)
    
    if bottle.request.forms.get('listname') != None:
        listName = bottle.request.forms.get('listname')
        itemList.add_to_item_list_by_name(listName)
        session['message'] = "List exported to Alveo."
        session.save()
        bottle.redirect('/')
    else:     
        return bottle.template('export', apiKey=apiKey)
    
@bottle.get('/login')
def login():
    return bottle.template('login', apiKey='')

@bottle.post('/login')
def logged_in():  
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable   
    session['apikey'] = bottle.request.forms.get('apikey')
    session['message'] = "Login successful."
    session.save()
    bottle.redirect('/')

if __name__ == '__main__':
    bottle.run(app=app, host='localhost', port=8080, debug=True)


