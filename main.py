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
import re,time

BASE_URL = 'https://app.alveo.edu.au/' #Normal Server
#BASE_URL = 'https://alveo-staging1.intersect.org.au/' #Staging Server

#used to inform the user when they're not logged in.
USER_MESSAGE = ""
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
    return bottle.static_file(filename, root='./styles')

@bottle.route('/js/<filename>')
def send_static(filename):
    '''Loads static files from views/js. Store all .js files there.'''
    return bottle.static_file(filename, root='./js/')

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
        global USER_MESSAGE
        USER_MESSAGE = "You must log in to view this page!"
        bottle.redirect('/login')
        
    try:
        message = session['message']
        session['message'] = ""
        session.save()
    except KeyError:
        session['message'] = ""
        message = session['message']
    
    
    #try getting cached results
    try:
        results = session['psearch_cache']
    except KeyError:
        #No results in cache, collect results
        simple_relations = ['cultural_heritage','education_level','professional_category',
                         'pob_country','mother_pob_country','mother_professional_category',
                         'mother_education_level','mother_cultural_heritage','father_pob_country',
                         'father_professional_category','father_education_level','father_cultural_heritage']
    
        results = qbuilder.simple_values_search(quer,'austalk',simple_relations,sortAlphabetically=True)
    
        results['city'] = quer.results_list("austalk", PREFIXES+
        """    
            SELECT distinct ?val 
            where {
              ?part a foaf:Person .
              ?part austalk:recording_site ?site .
              ?site austalk:city ?val .}
              order by asc(ucase(str(?val)))""")
    
        results['first_language'] = quer.results_list("austalk", PREFIXES+
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
    
        results['first_language_int'] = quer.results_list("austalk", PREFIXES+
        """                            
            SELECT distinct ?val
            WHERE {
                ?part a foaf:Person .
                ?part austalk:first_language ?val .}
            ORDER BY ?part""")
    
        results['mother_first_language'] = quer.results_list("austalk", PREFIXES+
        """                            
            SELECT distinct ?flang
            WHERE {{
                ?part a foaf:Person .
                ?part austalk:mother_first_language ?x .
                ?x iso639schema:name ?flang .
            } 
            UNION {
                ?part austalk:mother_first_language ?flang .
                MINUS{
                    ?flang iso639schema:name ?y}}}
            ORDER BY ?part""")
    
        results['mother_first_language_int'] = quer.results_list("austalk", PREFIXES+
        """                            
            SELECT distinct ?val
            WHERE {
                ?part a foaf:Person .
                ?part austalk:mother_first_language ?val .}
            ORDER BY ?part""")
    
        results['father_first_language'] = quer.results_list("austalk", PREFIXES+
        """                            
            SELECT distinct ?flang
            WHERE {{
                ?part a foaf:Person .
                ?part austalk:father_first_language ?x .
                ?x iso639schema:name ?flang .
            } 
            UNION {
                ?part austalk:father_first_language ?flang .
                MINUS{
                    ?flang iso639schema:name ?y}}}
            ORDER BY ?part""")
    
        results['father_first_language_int'] = quer.results_list("austalk", PREFIXES+
        """                            
            SELECT distinct ?val
            WHERE {
                ?part a foaf:Person .
                ?part austalk:father_first_language ?val .}
            ORDER BY ?part""")
        
        #cache the results
        session['psearch_cache'] = results
        
    return bottle.template('psearch', results=results, message=message,
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
        global USER_MESSAGE
        USER_MESSAGE = "You must log in to view this page!"
        bottle.redirect('/login')
        
    try:
        message = session['message']
        session['message'] = ""
        session.save()
    except KeyError:
        session['message'] = ""
        message = session['message']
        
    query = PREFIXES+ """
    
    SELECT ?id ?gender ?age ?city ?pob_country ?pob_town"""
          
    query = query + """
    WHERE {
        ?id a foaf:Person .
        ?id austalk:recording_site ?recording_site .
        ?recording_site austalk:city ?city .
        ?id foaf:age ?age .
        ?id foaf:gender ?gender .
        ?id austalk:first_language ?first_language .
        ?id austalk:pob_country ?pob_country .   
        ?id austalk:pob_town ?pob_town .
    """
    #special args is anything all the form arguments that need something more than a simple filter.
    filterTable = {
                   'simple':['gender','city','pob_state','cultural_heritage','ses','professional_category',
                             'education_level','mother_cultural_heritage','father_cultural_heritage','pob_town',
                             'mother_professional_category','father_professional_category','mother_education_level',
                             'father_education_level','mother_pob_state','mother_pob_town','father_pob_state',
                             'father_pob_town'],
                   'regex':['id','other_languages','hobbies_details'],
                   'boolean':['has_vocal_training','is_smoker','has_speech_problems','has_piercings','has_health_problems',
                             'has_hearing_problems','has_dentures','is_student','is_left_handed','has_reading_problems',],
                   'multiselect':['pob_country','father_pob_country','mother_pob_country'],
                   'to_str':['first_language','mother_first_language','father_first_language'],
                   'num_range':['age'],
                   'original_where':['id','city','age','gender','first_language','pob_country','pob_town']
                }
    
    searchArgs = [arg for arg in bottle.request.forms.allitems() if len(arg[1])>0]
    
    #build up the where clause
    for item in searchArgs:
        #to avoid having two lines of the same thing rfom multiselect and the predefined elements.
        if item[0] in filterTable['multiselect'] or item[0] in filterTable['original_where']:
            if query.find(item[0])==-1:
                query = query + """?id austalk:%s ?%s .\n""" % (item[0],item[0])
        else:
            query = query + """?id austalk:%s ?%s .\n""" % (item[0],item[0])
    
    #now build the filters
    regexList = [arg for arg in searchArgs if arg[0] in filterTable['regex']]
    for item in regexList:
        if item[0]=='id':
            query = query + qbuilder.regex_filter('id',toString=True,prepend="http://id.austalk.edu.au/participant/")
        else:
            query = query + qbuilder.regex_filter(item[0])
    
    
    multiselectList = [arg for arg in searchArgs if arg[0] in filterTable['multiselect']]
    for item in multiselectList:
        #since birth country is a multipple select, it can be gotten as a list. We can now put it together so it's as
        #if it's a normal user entered list of items.
        customStr = "".join('''"%s",''' % s for s in bottle.request.forms.getall(item[0]))[0:-1]
        
        query = query + qbuilder.regex_filter(item[0],custom=customStr)
        
    numRangeList = [arg for arg in searchArgs if arg[0] in filterTable['num_range']]
    for item in numRangeList:
        query = query + qbuilder.num_range_filter(item[0])
    
    toStrList = [arg for arg in searchArgs if arg[0] in filterTable['to_str']]
    for item in toStrList:
        query = query + qbuilder.to_str_filter(item[0])
    
    booleanList = [arg for arg in searchArgs if arg[0] in filterTable['boolean']]
    for item in booleanList:
        query = query + qbuilder.boolean_filter(item[0])
    
    simpleList = [arg for arg in searchArgs if arg[0] in filterTable['simple']]
    for item in simpleList:
        query = query + qbuilder.simple_filter(item[0])
                    
    query = query + "} \nORDER BY ?id"
    print query
    resultsList = quer.results_dict_list("austalk", query)
    
    session['partlist'] = resultsList
    session['partcount'] = session['resultscount']
    session.save()
    
    undoExists = 'backupPartList' in session.itervalues()
    
    return bottle.template('presults', resultsList=resultsList, resultCount=session['partcount'],message=message,undo=undoExists, apiKey=apiKey)

@bottle.get('/presults')
def part_list():
    '''Displays the results of the last participant search, or redirects home if no such search has been performed yet.'''
    
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    try:
        apiKey = session['apikey']
    except KeyError:
        global USER_MESSAGE
        USER_MESSAGE = "You must log in to view this page!"
        bottle.redirect('/login')
        
    try:
        resultsList = session['partlist']
        #incase the list was created but for some reason the user removes all elements or searches nothing.
        if len(resultsList)==0:
            raise KeyError
    except KeyError:
        session['message'] = "Perform a participant search first."
        session.save()
        redirect_home()
        
    try:
        message = session['message']
        session['message'] = ""
        session.save()
    except KeyError:
        session['message'] = ""
        message = session['message']
    
    undoExists = 'backupPartList' in session and len(session['backupPartList'])>0
        
    return bottle.template('presults', resultsList=resultsList, resultCount=session['partcount'],message=message,undo=undoExists, apiKey=apiKey)

@bottle.post('/handleparts')
def handle_parts():
    '''Removes selected participants or remove all non-selected and continue to search items or get all items.'''
    
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    try:
        apiKey = session['apikey']
    except KeyError:
        global USER_MESSAGE
        USER_MESSAGE = "You must log in to view this page!"
        bottle.redirect('/login')
    
    partList = session['partlist']
    selectedParts = bottle.request.forms.getall('selected')
    
    function = bottle.request.forms.get('submit')
    
    if function=='remove':
        newPartList = [p for p in partList if p['id'] not in selectedParts]
        session['backupPartList'] = [p for p in partList if p['id'] in selectedParts]
        session['partcount'] = session['partcount'] - len(selectedParts)
        session['partlist'] = newPartList
        if len(selectedParts)>1:
            session['message'] = 'Removed %d items.' % len(selectedParts)
        elif len(selectedParts==1):
            session['message'] = 'Removed one item.' 
        session.save()
    elif function=='getall':
        #goto /itemresults with selected items
        #removed this option as it crashes to go directly to item results without a search
        newPartList = [p for p in partList if p['id'] in selectedParts]
    
        session['partcount'] = len(selectedParts)
        session['partlist'] = newPartList
        session.save()
    
        bottle.redirect('/itemresults')
        
    elif function=='search':
        #goto /itemsearch with selected items
        newPartList = [p for p in partList if p['id'] in selectedParts]
    
        session['partcount'] = len(selectedParts)
        session['partlist'] = newPartList
        session.save()
    
        bottle.redirect('/itemsearch')
    elif function=='undo':
        #undo most recent remove if there was one.
        try:
            partList.extend(session['backupPartList'])
            session['partcount'] += len(session['backupPartList'])
            session['backupPartList']=[]
            session.save()
            session['message'] = 'Reversed last remove.'
        except KeyError:
            #was nothing to undo
            session['message'] = 'Nothing to Undo.'
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
        global USER_MESSAGE
        USER_MESSAGE = "You must log in to view this page!"
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
        row['item_results'] = quer.results_dict_list("austalk", query % (row['id']))
        resultsCount = resultsCount + session['resultscount']
    
    session['itemcount'] = resultsCount
    session.save()
    
    return bottle.template('itemresults', partList=partList, resultsCount=resultsCount, apiKey=apiKey)

@bottle.get('/itemresults')
def item_list():
    '''Like part_list but for items. Note that it is functionally different, so these two functions can't currently be rolled together.'''
    
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    try:
        apiKey = session['apikey']
    except KeyError:
        global USER_MESSAGE
        USER_MESSAGE = "You must log in to view this page!"
        bottle.redirect('/login')
        
    try:
        partList = session['partlist']
    except KeyError:
        session['message'] = "Perform an item search first."
        session.save()
        redirect_home()
        
    return bottle.template('itemresults', partList=partList, resultsCount=session['itemcount'], apiKey=apiKey)

@bottle.post('/removeitems')
def remove_items():
    '''Like remove_parts but for items. Again, not functionally identical.'''
    
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    try:
        apiKey = session['apikey']
    except KeyError:
        global USER_MESSAGE
        USER_MESSAGE = "You must log in to view this page!"
        bottle.redirect('/login')
    
    partList = session['partlist']
    
    selectedItems = bottle.request.forms.getall('selected')
    for p in partList:
        newItemList = [item for item in p['item_results'] if item['item'] not in selectedItems]
        p['item_results'] = newItemList
    
    session['itemcount'] = session['itemcount'] - len(selectedItems)
    session['partlist'] = partList
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
        global USER_MESSAGE
        USER_MESSAGE = "You must log in to view this page!"
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
        global USER_MESSAGE
        USER_MESSAGE = "You must log in to view this page!"
        bottle.redirect('/login')
    
    
    #create a single item list so it can be passed to pyalveo
    iList = []
    
    try:
        for part in session['partlist']:
            [iList.append(item['item']) for item in part['item_results']]
        
        itemList = pyalveo.ItemGroup(iList, client)
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
    global USER_MESSAGE
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    try:
        apiKey = session['apikey']
    except KeyError:
        apiKey = 'Not logged in.'
    
    msg = USER_MESSAGE
    USER_MESSAGE = ""
        
    return bottle.template('login', message=msg, apiKey=apiKey)

@bottle.get('/logout')
def logout():
    '''Logout and redirect to login page
    '''
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    session.delete()
    USER_MESSAGE = "You have successfully logged out!"
    bottle.redirect('/login')

@bottle.get('/about')
def about():
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    try:
        apiKey = session['apikey']
    except KeyError:
        apiKey = 'Not logged in.'
    
    return bottle.template('about', apiKey=apiKey)

@bottle.get('/help')
def help():
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    try:
        apiKey = session['apikey']
    except KeyError:
        apiKey = 'Not logged in.'
        
    return bottle.template('help', apiKey=apiKey)

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
    #bottle.run(app=app, host='localhost', port=8080, debug=True)
    bottle.run(app=app, host='10.126.102.130', port=8080, debug=True)
    


