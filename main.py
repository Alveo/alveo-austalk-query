'''
@author: Dylan Wheeler, Michael Bauer

@summary: The Alveo query engine is designed to provide a more useful way of searching the Alveo database. Currently only supports the Austalk collection.
This file contains all the routing and much of the logic for the application. Run this to start the application. Listens on localhost:8080.
'''

import bottle
from beaker.middleware import SessionMiddleware
from cherrypy import wsgiserver
from cherrypy.wsgiserver.ssl_pyopenssl import pyOpenSSLAdapter
from OpenSSL import SSL
import alquery
import qbuilder
import socket
import sys
import traceback
import pyalveo
from datetime import datetime
import csv,json
from io import BytesIO
from settings import *

client = None

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
    'session.cookie_expires': False,
    'session.auto': True,
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

@bottle.route('/')
def home():
    '''An introductory home page to welcome the user and brief them on the process'''
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    return bottle.template('home',
                           message=session.pop('message',''), 
                           role=session.get('role',''),
                           name=session.get('name',None))

@bottle.get('/start')
def start():
    '''Allows the user to select which '''
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    session['corpus'] = bottle.request.query.get('corpus','austalk')
    

    return bottle.redirect('/psearch')

@bottle.route('/psearch')
def search():
    '''The home page and participant search page. Drop-down lists are populated from the SPARQL database and the template returned.
    Displays the contents of session['message'] if one is set.'''
    
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    client = session.get('client',None)
    if client is None:
        session['message'] = "You must log in to view this page!"
        bottle.redirect('/')
        
    quer = alquery.AlQuery(client)

    #try getting cached results
    try:
        results = session['psearch_cache']
    except KeyError:
        #No results in cache, collect results
        simple_relations = ['cultural_heritage','education_level','professional_category',
                         'pob_country','mother_pob_country','mother_professional_category',
                         'mother_education_level','mother_cultural_heritage','father_pob_country',
                         'father_professional_category','father_education_level','father_cultural_heritage']

        results = quer.simple_values_search(session.get('corpus','austalk'),simple_relations,sortAlphabetically=True)

        results['city'] = quer.results_list(session.get('corpus','austalk'), PREFIXES+
        """
            SELECT distinct ?val
            where {
              ?part a foaf:Person .
              ?part austalk:recording_site ?site .
              ?site austalk:city ?val .}
              order by asc(ucase(str(?val)))""")

        results['first_language'] = quer.results_list(session.get('corpus','austalk'), PREFIXES+
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

        results['first_language_int'] = quer.results_list(session.get('corpus','austalk'), PREFIXES+
        """
            SELECT distinct ?val
            WHERE {
                ?part a foaf:Person .
                ?part austalk:first_language ?val .}
            ORDER BY ?part""")

        results['mother_first_language'] = quer.results_list(session.get('corpus','austalk'), PREFIXES+
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

        results['mother_first_language_int'] = quer.results_list(session.get('corpus','austalk'), PREFIXES+
        """
            SELECT distinct ?val
            WHERE {
                ?part a foaf:Person .
                ?part austalk:mother_first_language ?val .}
            ORDER BY ?part""")

        results['father_first_language'] = quer.results_list(session.get('corpus','austalk'), PREFIXES+
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

        results['father_first_language_int'] = quer.results_list(session.get('corpus','austalk'), PREFIXES+
        """
            SELECT distinct ?val
            WHERE {
                ?part a foaf:Person .
                ?part austalk:father_first_language ?val .}
            ORDER BY ?part""")
        
        results['country_hist'] = quer.results_list(session.get('corpus','austalk'), PREFIXES+
        """
            SELECT distinct ?country
            WHERE {
                ?part rdf:type foaf:Person .
                ?part austalk:residential_history ?rh .
                ?rh austalk:country ?country . 
            } ORDER BY ?country""")
        
        results['town_hist'] = quer.results_list(session.get('corpus','austalk'), PREFIXES+
        """
            SELECT distinct ?town
            WHERE {
                ?part rdf:type foaf:Person .
                ?part austalk:residential_history ?rh .
                ?rh austalk:town ?town . 
            } ORDER BY ?town""")
        
        results['state_hist'] = quer.results_list(session.get('corpus','austalk'), PREFIXES+
        """
            SELECT distinct ?state
            WHERE {
                ?part rdf:type foaf:Person .
                ?part austalk:residential_history ?rh .
                ?rh austalk:state ?state . 
            } ORDER BY ?state""")

        #cache the results
        session['psearch_cache'] = results

    return bottle.template('psearch', 
                           results=results, 
                           message=session.pop('message',''), 
                           name=session.get('name',None))

@bottle.post('/presults')
def results():
    '''Perfoms a search of participants and display the results as a table. Saves the results in the session so they can be retrieved later'''

    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    client = session.get('client',None)
    if client is None:
        session['message'] = "You must log in to view this page!"
        bottle.redirect('/')

    quer = alquery.AlQuery(client)

    query = PREFIXES+ """

    SELECT distinct ?id ?gender ?age ?city ?first_language ?pob_country ?pob_town"""

    query = query + """
    WHERE {
        ?id a foaf:Person .
        ?id austalk:recording_site ?recording_site .
        ?recording_site austalk:city ?city .
        ?id foaf:age ?age .
        ?id foaf:gender ?gender .
        OPTIONAL { ?id austalk:residential_history ?rh . 
        OPTIONAL { ?rh austalk:country ?hist_country . }
        OPTIONAL { ?rh austalk:state ?hist_state . }
        OPTIONAL { ?rh austalk:town ?hist_town . }
        OPTIONAL { ?rh austalk:age_from ?age_from . }
        OPTIONAL { ?rh austalk:age_to ?age_to . } }
        OPTIONAL { ?id austalk:first_language ?fl . 
                   ?fl iso639schema:name ?first_language . }
        OPTIONAL { ?id austalk:pob_country ?pob_country . }
        OPTIONAL { ?id austalk:pob_town ?pob_town . }
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
                   'multiselect':['pob_country','father_pob_country','mother_pob_country','hist_town','hist_state','hist_country'],
                   'to_str':['first_language','mother_first_language','father_first_language'],
                   'num_range':['age','age_from','age_to'],
                   'original_where':['id','city','age','gender','first_language','pob_country','pob_town','age_from','age_to',
                                     'hist_town','hist_state','hist_country']
                }

    searchArgs = [arg for arg in bottle.request.forms.allitems() if len(arg[1])>0]
    qfilter=""
    #build up the where clause
    for item in searchArgs:
        #to avoid having two lines of the same thing rfom multiselect and the predefined elements.
        if item[0] in filterTable['multiselect'] or item[0] in filterTable['original_where']:
            if query.find(item[0])==-1:
                qfilter = qfilter + """?id austalk:%s ?%s .\n""" % (item[0],item[0])
        else:
            qfilter = qfilter + """?id austalk:%s ?%s .\n""" % (item[0],item[0])

    #now build the filters
    regexList = [arg for arg in searchArgs if arg[0] in filterTable['regex']]
    for item in regexList:
        if item[0]=='id':
            qfilter = qfilter + qbuilder.regex_filter('id',toString=True,prepend="https://app.alveo.edu.au/speakers/%s/"%session.get('corpus','austalk'))
        else:
            qfilter = qfilter + qbuilder.regex_filter(item[0])

    #we want only unique listings in the multiselect list
    unique = []
    multiselectList = [arg for arg in searchArgs if arg[0] in filterTable['multiselect']]
    for item in multiselectList:
        if item[0] not in unique:
            unique.append(item[0])
            #since birth country is a multipple select, it can be gotten as a list. We can now put it together so it's as
            #if it's a normal user entered list of items.
            customStr = "".join('''"%s",''' % s for s in bottle.request.forms.getall(item[0]))[0:-1]
    
            qfilter = qfilter + qbuilder.regex_filter(item[0],custom=customStr)

    numRangeList = [arg for arg in searchArgs if arg[0] in filterTable['num_range']]
    for item in numRangeList:
        qfilter = qfilter + qbuilder.num_range_filter(item[0])

    toStrList = [arg for arg in searchArgs if arg[0] in filterTable['to_str']]
    for item in toStrList:
        qfilter = qfilter + qbuilder.to_str_filter(item[0])

    booleanList = [arg for arg in searchArgs if arg[0] in filterTable['boolean']]
    for item in booleanList:
        qfilter = qfilter + qbuilder.boolean_filter(item[0])

    simpleList = [arg for arg in searchArgs if arg[0] in filterTable['simple']]
    for item in simpleList:
        qfilter = qfilter + qbuilder.simple_filter(item[0])

    query = query + qfilter + "} \nORDER BY ?id"
    
    resultsList = quer.results_dict_list(session.get('corpus','austalk'), query)
    session['partfilters'] = qfilter #so we can use the filters later again
    session['partlist'] = resultsList
    session['partcount'] = session['resultscount']
    session['searchedcount'] = session['resultscount']
    

    undoExists = 'backupPartList' in session.itervalues()

    return bottle.template('presults', 
                           resultsList=resultsList, 
                           resultCount=session['partcount'],
                           message=session.pop('message',''),
                           undo=undoExists, 
                           name=session.get('name',None))

@bottle.get('/presults')
def part_list():
    '''Displays the results of the last participant search, or redirects home if no such search has been performed yet.'''

    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    client = session.get('client',None)
    if client is None:
        session['message'] = "You must log in to view this page!"
        bottle.redirect('/')

    try:
        resultsList = session['partlist']
        #incase the list was created but for some reason the user removes all elements or searches nothing.
        if len(resultsList)==0:
            raise KeyError
    except KeyError:
        session['message'] = "Perform a participant search first."
        
        bottle.redirect('/psearch')

    undoExists = 'backupPartList' in session
    if undoExists:
        undoExists = len(session['backupPartList'])>0
    return bottle.template('presults', 
                           resultsList=resultsList, 
                           resultCount=session['partcount'],
                           message=session.pop('message',''),
                           undo=undoExists, 
                           name=session.get('name',None))

@bottle.get('/download/participants.csv')
def download_participants_csv():
    '''Returns a csv file download of the participants and all their meta data.'''

    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    client = session.get('client',None)
    if client is None:
        session['message'] = "You must log in to view this page!"
        bottle.redirect('/')

    quer = alquery.AlQuery(client)

    try:
        resultsList = session['partlist']
        #incase the list was created but for some reason the user removes all elements or searches nothing.
        if len(resultsList)==0:
            raise KeyError
    except KeyError:
        session['message'] = "Perform a participant search first."
        
        bottle.redirect('/psearch')

    query = qbuilder.get_everything_from_participants(filters=session['partfilters'])

    resultsList = quer.results_dict_list(session.get('corpus','austalk'), query)
    
    #modify the output so it is more human readable
    for row in resultsList:
        row['id'] = row['id'].split('/')[-1]
        #We need to encode to ascii otherwise dictwriter will cry
        for key in row:
            key = key.encode('ascii','backslashreplace')
            row[key] = row[key].encode('ascii','backslashreplace')

    #make response header so that file will be downloaded.
    bottle.response.headers["Content-Disposition"] = "attachment; filename=participants.csv"
    bottle.response.headers["Content-type"] = "text/csv"

    csvfile = BytesIO()
    dict_writer = csv.DictWriter(csvfile,resultsList[0].keys())
    dict_writer.writeheader()
    dict_writer.writerows(resultsList)

    csvfile.seek(0)
    return csvfile.read()

@bottle.post('/handleparts')
def handle_parts():
    '''Removes selected participants or remove all non-selected and continue to search items or get all items.'''

    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    client = session.get('client',None)
    if client is None:
        session['message'] = "You must log in to view this page!"
        bottle.redirect('/')

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
        elif len(selectedParts)==1:
            session['message'] = 'Removed one item.'
        
    elif function=='getall':
        #goto /itemresults with selected items
        #removed this option as it crashes to go directly to item results without a search
        newPartList = [p for p in partList if p['id'] in selectedParts]

        session['partcount'] = len(selectedParts)
        session['partlist'] = newPartList
        

        bottle.redirect('/itemresults')

    elif function=='search':
        #if nothing selected, tell them to select something first
        if len(selectedParts)==0:
            session['message'] = 'Please select some participants before continuing'
            bottle.redirect('/presults')
        #goto /itemsearch with selected items
        newPartList = [p for p in partList if p['id'] in selectedParts]

        session['partcount'] = len(selectedParts)
        session['partlist'] = newPartList
        

        bottle.redirect('/itemsearch')
    elif function=='undo':
        #undo most recent remove if there was one.
        try:
            if len(session['backupPartList'])==0:
                raise KeyError
            partList.extend(session['backupPartList'])
            session['partcount'] += len(session['backupPartList'])
            session['backupPartList']=[]
            
            session['message'] = 'Reversed last remove.'
        except KeyError:
            #was nothing to undo
            session['message'] = 'Nothing to Undo.'
    bottle.redirect('/presults')

@bottle.post('/itemresults')
def item_results():
    '''Like results(), but for items not participants. Functionally similar.'''

    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    client = session.get('client',None)
    if client is None:
        session['message'] = "You must log in to view this page!"
        bottle.redirect('/')
        
    quer = alquery.AlQuery(client)

    query = PREFIXES + """
    SELECT distinct ?id ?item ?prompt ?componentName ?media
    WHERE {
      ?item a ausnc:AusNCObject .
      ?item olac:speaker ?id .
      ?item austalk:prototype ?prototype .
      ?prototype austalk:prompt ?prompt .
      ?item austalk:componentName ?componentName .
      ?item ausnc:document ?media .
      ?media austalk:version 1 .
      ?media austalk:channel "ch6-speaker16" .
      ?id a foaf:Person .
      ?id austalk:recording_site ?recording_site .
      ?recording_site austalk:city ?city .
      ?id foaf:age ?age .
      ?id foaf:gender ?gender .
     """

    if bottle.request.forms.get('anno') == "required":
        query = query + """?ann dada:annotates ?item ."""

    partList = session['partlist']
    resultsCount = 0

    #if there is a complete sentance (prompt) selected from the dropdown, use that and not the 'prompt' regex.
    if bottle.request.forms.get('fullprompt'):
        query = query + qbuilder.regex_filter('prompt',custom='^'+bottle.request.forms.get('fullprompt')+'$')
    else:
        query = query + qbuilder.regex_filter('prompt')
    query = query + qbuilder.simple_filter('componentName')
    query = query + qbuilder.to_str_filter('prototype',prepend="https://app.alveo.edu.au/protocol/item/")

    if bottle.request.forms.get('comptype') != "":
        query=query+"""FILTER regex(?componentName, "%s", "i")""" % (bottle.request.forms.get('comptype'))

    hVdWords = {
        'monopthongs': ['head', 'had', 'hud', 'heed', 'hid', 'hood', 'hod', 'whod', 'herd', 'haired', 'hard', 'horde'],
        'dipthongs': ['howd', 'hoyd', 'hide', 'hode', 'hade', 'heared']
        }

    if bottle.request.forms.get('wlist')=='hvdwords':
        query=query+'FILTER regex(?prompt, "^%s$", "i")' % "$|^".join(hVdWords['monopthongs'] + hVdWords['dipthongs'])

    if bottle.request.forms.get('wlist')=='hvdmono':
        query=query+'FILTER regex(?prompt, "^%s$", "i")' % "$|^".join(hVdWords['monopthongs'])

    if bottle.request.forms.get('wlist')=='hvddip':
        query=query+'FILTER regex(?prompt, "^%s$", "i")' % "$|^".join(hVdWords['dipthongs'])
    
    #This partcount greater than 65 isn't arbitrary,
    #The amount of or's in the filter to select 70 or more 
    #speakers results in a HTTP 414
    #Basically the url is too long for the server to handle
    #ie: the query is too long.
    #This 65 should be a decent compromise between keeping
    #a short and potentially more efficient search query
    #and over querying for what the user wants.
    #When querying for more than 65 participant we will
    #search using the search filters, any further modifications
    #to the participant list after are ignored and items from
    #those who are unselected will also be returned.
    #later on those extra results will be dumped.
    if session['partcount']>65 or session['partcount']==session['searchedcount']:
        query = query + "\n"+session.get('partfilters','')+"\n}"
    else:
        query = query + "\nFILTER ("
        for p in partList:
            query = query + 'str(?id) = "%s" || ' % p['id']
        
        query = query[:-3] + ')\n}'
    
    results = quer.results_dict_list(session.get('corpus','austalk'), query)
    
    resultsCount = 0
    
    #Converting participant list into a dict so it's O(1) to add an item to this participant
    #Without this, worst case complexity will be O(num_parts*num_items)
    partDict = {}
    for part in partList:
        partDict[part['id']] = part
        partDict[part['id']]['item_results'] = []
    
    for row in results:
        try:
            partDict[row['id']]['item_results'].append(row)
            resultsCount = resultsCount + 1
        except KeyError:
            #Incase we get a result from a participant we haven't selected
            #This will only happen if the participant filters are applied 
            #instead of selecting each of the participants.
            pass
        
    partList = partDict.values()
    
    session['itemcount'] = resultsCount
    

    undoExists = 'backupItemList' in session and len(session['backupPartList'])>0

    return bottle.template('itemresults', 
                           partList=partList, 
                           resultsCount=resultsCount, 
                           message=session.pop('message',''),
                           undo=undoExists, 
                           name=session.get('name',None))

@bottle.get('/itemresults')
def item_list():
    '''Like part_list but for items. Note that it is functionally different, so these two functions can't currently be rolled together.'''

    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    client = session.get('client',None)
    if client is None:
        session['message'] = "You must log in to view this page!"
        bottle.redirect('/')

    try:
        partList = session['partlist']
        test = session['partlist'][0]['item_results']#should have something here
    except KeyError:
        session['message'] = "Perform an item search first."
        
        bottle.redirect('/itemsearch')

    undoExists = 'backupItemList' in session
    if undoExists:
        undoExists = len(session['backupItemList'])>0
    return bottle.template('itemresults', 
                           partList=partList, 
                           resultsCount=session['itemcount'],
                           message=session.pop('message',''),
                           undo=undoExists, 
                           name=session.get('name',None))


@bottle.get('/download/items.csv')
@bottle.get('/download/itemswithpartdata.csv')
def download_items_csv():
    '''Returns a csv file download of the participants and all their meta data.'''

    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    client = session.get('client',None)
    if client is None:
        session['message'] = "You must log in to view this page!"
        bottle.redirect('/')
    
    quer = alquery.AlQuery(client)

    try:
        #incase the list was created but for some reason the user removes all elements or searches nothing.
        if session['itemcount']==0:
            raise KeyError
    except KeyError:
        session['message'] = "Perform an item search first."
        
        bottle.redirect('/itemsearch')

    resultsList = []
    if str(bottle.request.path).split('/')[-1]=='itemswithpartdata.csv':
        #add more participant meta data
        for part in session['partlist']:
            for x in part['item_results']:
                #now get all participant info
                query = qbuilder.get_everything_from_participants(id=part['id'])
                new = x.copy()
                results = quer.results_dict_list(session.get('corpus','austalk'), query)
                new.update(results[0])
                resultsList.append(new)
    else:
        #add only participant id
        for part in session['partlist']:
            for x in part['item_results']:
                new = x.copy()
                new['participant'] = part['id']
                resultsList.append(new)
    
    #modify the output so it is more human readable
    for row in resultsList:
        row['participant'] = row['id'].split('/')[-1]
        row.pop('id',None)
        row['media'] = row['media'].split('/')[-1]
        row['item'] = row['item'].split('/')[-1]
    
    #make response header so that file will be downloaded.
    bottle.response.headers["Content-Disposition"] = "attachment; filename=items.csv"
    bottle.response.headers["Content-type"] = "text/csv"

    csvfile = BytesIO()
    dict_writer = csv.DictWriter(csvfile,resultsList[0].keys())
    dict_writer.writeheader()
    dict_writer.writerows(resultsList)

    csvfile.seek(0)
    return csvfile.read()

@bottle.post('/handleitems')
def handle_items():
    '''Like handle_parts but for items. Not functionally identical.'''

    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    client = session.get('client',None)
    if client is None:
        session['message'] = "You must log in to view this page!"
        bottle.redirect('/')

    partList = session['partlist']

    selectedItems = bottle.request.forms.getall('selected')

    function = bottle.request.forms.get('submit')

    if function=='remove':
        if len(selectedItems)==0:
            session['message'] = 'Select something to remove'
        #setup the undo portion which is the opposite list of above
        #I'm making this a dict as I'll need to remember which participant the items
        #belong to as well. Also it means I can easily store the count with it.
        session['backupItemList'] = {}
        #get new item list for each participant
        for p in partList:
            newItemList = []
            removeItemList = []
            for item in p['item_results']:
                if item['item'] not in selectedItems:
                    newItemList.append(item)
                else:
                    removeItemList.append(item)
            session['backupItemList'][p['id']] = removeItemList
            p['item_results'] = newItemList

        session['backupItemList']['count'] = len(selectedItems)
        session['itemcount'] = session['itemcount'] - len(selectedItems)
        session['partlist'] = partList
        if len(selectedItems)>1:
            session['message'] = 'Removed %d items.' % len(selectedItems)
        elif len(selectedItems)==1:
            session['message'] = 'Removed one item.'
        
    elif function=='undo':
        #undo most recent remove if there was one.
        #loop participants and extend each of their item lists
        backupItemList = session.get('backupItemList',[])
        if len(backupItemList)>0:
            for p in partList:
                p['item_results'].extend(backupItemList[p['id']])

            session['itemcount'] += backupItemList['count']
            session['backupItemList']={}
            
            session['message'] = 'Reversed last remove.'
        else:
            session['message'] = 'Nothing to Undo.'
    elif function=='export':
        if selectedItems and len(selectedItems)>0:
            #remove all that isn't selected.
            for p in partList:
                itemResults = p.get('item_results',[])
                newItemList = [item for item in itemResults if item['item'] in selectedItems]
                p['item_results'] = newItemList
            session['itemcount'] = len(selectedItems)
            bottle.redirect('/export')
        session['message'] = 'Please Select some items first'
        bottle.redirect('/itemresults')
    bottle.redirect('/itemresults')


@bottle.route('/itemsearch')
@bottle.post('/itemsearch')
def item_search():
    '''Displays the page for searching items, unless there's not yet a group of participants selected to search for.'''

    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    client = session.get('client',None)
    if client is None:
        session['message'] = "You must log in to view this page!"
        bottle.redirect('/')
        

    try:
        partList = session['partlist'] #@UnusedVariable
    except KeyError:
        session['message'] = "Select some participants first."
        
        bottle.redirect('/psearch')

    return bottle.template('itemsearch',
                           message=session.pop('message',''), 
                           name=session.get('name',None))


@bottle.get('/itemsearch/sentences')
def getSentences():

    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    client = session.get('client',None)
    if client is None:
        return "<option value="">You must login to view results!</option>"
        
    
    quer = alquery.AlQuery(client)

    try:
        selectedComp = bottle.request.query['sentence']
    except KeyError:
        return ""

    if len(selectedComp)==0:
        return ""

    query = PREFIXES+'''
    SELECT ?prompt WHERE {
        ?component a austalk:Component .
        ?component austalk:shortname "%s" .
        ?item dc:isPartOf ?component .
        ?item austalk:prompt ?prompt .
    }
    ''' % selectedComp
    results = quer.results_dict_list(session.get('corpus','austalk'), query)
    return '<option value="">Any</option>\n'+''.join('<option value="%s">%s</option>\n' % (s['prompt'],s['prompt']) for s in results)

@bottle.get('/export')
@bottle.post('/export')
def export():
    '''
    If POST: Exports a selected set of items to Alveo. Redirects home after the export is completed.
    If GET : Displays a simple form to allow said exporting unless no items have yet been selected to export.
    '''

    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    client = session.get('client',None)
    if client is None:
        session['message'] = "You must log in to view this page!"
        bottle.redirect('/')

    #create a single item list so it can be passed to pyalveo
    iList = [] #iList, the expensive and non-functional but good looking version of list
    listUrl=''
    try:
        for part in session['partlist']:
            for item in part['item_results']:
                # TODO: fix item url since it is wrong in the triple store right now
                itemurl = item['item'].replace('http://id.austalk.edu.au/item/', 'https://app.alveo.edu.au/catalog/%s/'%session.get('corpus','austalk'))
                iList.append(itemurl)
        
        if len(iList)==0:
            session['message'] = "Select some items first."
            bottle.redirect('/itemresults')
        
        itemList = pyalveo.ItemGroup(iList, client)
    except KeyError:
        session['message'] = "Select some items first."
        bottle.redirect('/itemresults')

    if bottle.request.forms.get('listname') != None:
        #This is when the user sends a post
        listName = bottle.request.forms.get('listname')
        res = itemList.add_to_item_list_by_name(listName)

        try:
            listUrl = pyalveo.Client.get_item_list_by_name(client,listName).list_url
            message = 'List exported to Alveo. Next step is to <a href='+listUrl+' target="_blank">click here</a> to go directly to your list.'
        except:
            message = "List exported to Alveo. Next step is to click on your name in the top right and click on 'Your Lists'."
        
        create_log('ListExport',{'listName':listName})
        session['message'] = message
        
        bottle.redirect('/')

    itemLists = client.get_item_lists()
    return bottle.template('export', 
                           name=session.get('name',None), 
                           itemLists=itemLists,
                           listUrl=listUrl,
                           message=session.pop('message',''),
                           itemCount=session['itemcount'])


@bottle.get('/download/logs.csv')
def download_logs():
    '''Returns a csv file download of the Apps Logs.'''

    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    if session.get('role','').lower()=='admin':
        #make response header so that file will be downloaded.
        bottle.response.headers["Content-Disposition"] = "attachment; filename=items.csv"
        bottle.response.headers["Content-type"] = "text/csv"
    
        return bottle.static_file(log_file, root='./',download=True)
    
    session['message'] = "You don't have permission to access this file."
    bottle.redirect('/')

@bottle.get('/oauth/user_data')
def oauth_user_data():
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    if 'client' in session:
        if session['client'].oauth!=None:
            return session['client'].oauth.get_user_data()
    return {}

@bottle.get('/oauth/callback')
def oauth_callback():
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    if not 'client' in session:
        session['message'] = 'You must log in via <a href="/">this link</a>'
        bottle.redirect('/')
        
    if session['client'].oauth.on_callback(bottle.request.url):
        res = session['client'].oauth.get_user_data()
        session['email'] = res.get('email','None')
        session['role'] = res.get('role','None')
        session['login_time'] = datetime.now()
        session['name'] = "%s %s" % (res.get('first_name',''), res.get('last_name',''))
        session['message'] = "Successfully Logged In!"
        create_log('UserLogin',{'method':'oauth2'})
        
        
    #Lets check to see if item results already exist in the session
    #If so then redirect to item results page
    try:
        partList = session['partlist']
        test = session['partlist'][0]['item_results']
        bottle.redirect('/itemresults')
    except KeyError:
        pass
    
    bottle.redirect('/')
    
@bottle.get('/oauth/validate')
def oauth_validate():
    ''' Validates access token and returns a json response '''
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    res = {'valid':'false'}
    if 'client' in session:
        if session['client'].oauth!=None:
            if session['client'].oauth.validate():
                res = {'valid':'true'}
    return json.dumps(res)

@bottle.get('/oauth/refresh')
def oauth_refresh():
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    return json.dumps({'success':'false','error':'not implemented'})
    #Maybe implement later or else delete. Not so important anymore
    try:
        session['client'].oauth.refresh_token()
    except KeyError:
        return json.dumps({'success':'false',
                           'error':'You must first log in before refreshing the token',
                           'error_info':traceback.format_exc()})
    except:
        return json.dumps({'success':'false',
                           'error':'Unknown Error',
                           'error_info':traceback.format_exc()})
    return json.dumps({'success':'true'})

@bottle.error(404)
def error404(error):
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    session['message'] = "Sorry, the page you're looking for doesn't exist."
    
    create_log('Error404',{'route':bottle.request.url})
    
    bottle.response.status = 303
    bottle.response.set_header('location','/')
    
    return 'this is meant to redirect'

    
@bottle.error(500)
def error500(error):
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    session['message'] = "Sorry, something went wrong! Error: 500 Internal Server Error"
    
    try:
        if error.exception.http_status_code=='403':
            session['message'] = '''You are not authorized to access this resource. 
                    Please accept the <a href="https://app.alveo.edu.au/account/licence_agreements">%s User Agreement</a>''' % session.get('corpus','austalk')
    except:
        pass
    
    create_log('Error500',{'route':bottle.request.url,
                           'session_dump':dict(session),
                           'last_traceback':error.traceback})
    
    bottle.response.status = 303
    bottle.response.set_header('location','/')
    return 'this is meant to redirect'

@bottle.get('/logout')
def logout():
    '''Logout and redirect to login page
    '''
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    try:
        session['client'].oauth.revoke_access()
    except KeyError:
        pass
    create_log('UserLogout')
    session.delete()
    session['message'] = "You have successfully logged out!"
    
    bottle.redirect('/')

@bottle.get('/about')
def about():
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    return bottle.template('about', 
                           message=session.pop('message',''),
                           name=session.get('name',None))

@bottle.get('/help')
def help():
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    return bottle.template('help', 
                           message=session.pop('message',''),
                           name=session.get('name',None))

@bottle.get('/apikeylogin')
@bottle.post('/apikeylogin')
def apikey_login():
    '''Logs the user in with their API key.'''
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    
    apiKey = bottle.request.query.get('apikey', None)
    if apiKey:
        client = pyalveo.Client(api_url=BASE_URL,api_key=apiKey,verifySSL=False)
        res = client.oauth.get_user_data()
        session['client'] = client
        session['email'] = res.get('email','None')
        session['role'] = res.get('role','None')
        session['login_time'] = datetime.now()
        session['name'] = "%s %s" % (res.get('first_name',''), res.get('last_name',''))
        session['message'] = "Successfully Logged In!"
        create_log('UserLogin',{'method':'apiKey'})
    bottle.redirect('/')

@bottle.get('/login')
@bottle.post('/login')
def logging_in():
    '''Logs the user in with their API key.'''
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    try:
        oauth_dict = {
                      'client_id':client_id,
                      'client_secret':client_secret,
                      'redirect_url':redirect_url
                      }
    except:
        session['message'] = "No client id set. Please ensure the settings are correctly setup."
        bottle.redirect('/')
    client = pyalveo.Client(api_url=BASE_URL,oauth=oauth_dict,verifySSL=False)
    url = client.oauth.get_authorisation_url()
    session['client'] = client
    session['corpus'] = bottle.request.query.get('corpus','austalk')
    
    bottle.redirect(url)

def create_log(event,data={}):
    '''
        @param event: A short string categorising the event that occurred. 
                    Eg: Error500, UserLogin
        @type event: str
        @param data: A Dict with relevant data to the event in a Key-Value Format. 
                    Contains data such as recent search parameters.
        @type data: dict
        @return: True if writing log was successful, false otherwise.
        @rtype: boolean
    '''
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    ip = bottle.request.environ.get('HTTP_X_FORWARDED_FOR') #@UndefinedVariable
    if ip==None:
        ip = bottle.request.environ.get('REMOTE_ADDR') #@UndefinedVariable
        
    login_time = session.get('login_time',None)
    session_time = "0:00:00"
    if login_time:
        session_time = str(datetime.now()-login_time).split('.')[0]
    
    fields_ordered_list = ['Event','User','Email','IP Address','Session Time','Event Time','Data']
    
    fields = {'Event':event,
              'User':session.get('name','None'),
              'Email':session.get('email','None'),
              'IP Address':ip,
              'Session Time':session_time,
              'Event Time':datetime.now().strftime('%d-%m-%Y %H:%M:%S'),
              'Data':str(data)
              }
    
    #Print to console log data as dict with headers as keys and row as values.
    print(str(fields))
    
    #Open Log file and init if not exists or empty
    with open(log_file, 'a+') as f:
        size = os.path.getsize(log_file)
        writer = csv.DictWriter(f,fieldnames=fields_ordered_list)
        if size == 0:
            writer.writeheader()
        writer.writerow(fields)
        
    #If file is greater than max_log_size (in bytes) then rename it. Next log will create a new one
    if size > max_log_size:
        date = datetime.today().strftime('%d-%m-%Y-%H-%M')
        new = log_file[:-4]+'-backup-'+date+log_file[-4:]
        os.rename(log_file,new)

# By default, the server will allow negotiations with extremely old protocols
# that are susceptible to attacks, so we only allow TLSv1.2
class SecuredSSLServer(pyOpenSSLAdapter):
    def get_context(self):
        c = super(SecuredSSLServer, self).get_context()
        c.set_options(SSL.OP_NO_SSLv2)
        c.set_options(SSL.OP_NO_SSLv3)
        c.set_options(SSL.OP_NO_TLSv1)
        c.set_options(SSL.OP_NO_TLSv1_1)
        return c

# Create our own sub-class of Bottle's ServerAdapter
# so that we can specify SSL. Using just server='cherrypy'
# uses the default cherrypy server, which doesn't use SSL
class SSLCherryPyServer(bottle.ServerAdapter):
    def run(self, handler):
        server = wsgiserver.CherryPyWSGIServer((self.host, self.port), handler)
        server.ssl_adapter = SecuredSSLServer('keys/cacert.pem', 'keys/privkey.pem')
        try:
            server.start()
        finally:
            server.stop()

if __name__ == '__main__':
    '''Runs the app. Listens on localhost:8080.'''
    try:
        ip = socket.gethostbyname(socket.gethostname())
    except:
        ip = ''
    if len(sys.argv)>1:
        if len(sys.argv)>2 and sys.argv[2]=='--no-ssl':
            bottle.run(app=app, host=sys.argv[1], port=port, debug=True)
        else:
            if sys.argv[1]=='--no-ssl':
                bottle.run(app=app, host=ip, port=port, debug=True)
            else:
                bottle.run(app=app, host=sys.argv[1], port=port, debug=True,server=SSLCherryPyServer)
    else:
        bottle.run(app=app, host=ip, port=port, debug=True,server=SSLCherryPyServer)
