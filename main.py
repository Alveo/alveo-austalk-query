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
import sys,os
import traceback
from bottle import redirect
import pyalveo
from settings import *
import csv,json
from io import BytesIO

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

@bottle.route('/')
def home():
    '''An introductory home page to welcome the user and brief them on the process'''
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    if not 'logged_in' in session:
        session['logged_in'] = False
        session.save()

    try:
        message = session['message']
        session['message'] = ""
        session.save()
    except KeyError:
        session['message'] = ""
        message = session['message']
        session.save()

    return bottle.template('home', results=results, message=message, logged_in=session['logged_in'])

@bottle.route('/psearch')
def search():
    '''The home page and participant search page. Drop-down lists are populated from the SPARQL database and the template returned.
    Displays the contents of session['message'] if one is set.'''
    

    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    if not 'logged_in' in session:
        session['logged_in'] = False
        session['message'] = "You must log in to view this page!"
        session.save()
        bottle.redirect('/')
        
    quer = alquery.AlQuery(session['client'])

    try:
        message = session['message']
        session['message'] = ""
        session.save()
    except KeyError:
        session['message'] = ""
        message = session['message']
        session.save()

    #try getting cached results
    try:
        results = session['psearch_cache']
    except KeyError:
        #No results in cache, collect results
        simple_relations = ['cultural_heritage','education_level','professional_category',
                         'pob_country','mother_pob_country','mother_professional_category',
                         'mother_education_level','mother_cultural_heritage','father_pob_country',
                         'father_professional_category','father_education_level','father_cultural_heritage']

        results = quer.simple_values_search('austalk',simple_relations,sortAlphabetically=True)

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
        
        results['country_hist'] = quer.results_list("austalk", PREFIXES+
        """
            SELECT distinct ?country
            WHERE {
                ?part rdf:type foaf:Person .
                ?part austalk:residential_history ?rh .
                ?rh austalk:country ?country . 
            } ORDER BY ?country""")
        
        results['town_hist'] = quer.results_list("austalk", PREFIXES+
        """
            SELECT distinct ?town
            WHERE {
                ?part rdf:type foaf:Person .
                ?part austalk:residential_history ?rh .
                ?rh austalk:town ?town . 
            } ORDER BY ?town""")
        
        results['state_hist'] = quer.results_list("austalk", PREFIXES+
        """
            SELECT distinct ?state
            WHERE {
                ?part rdf:type foaf:Person .
                ?part austalk:residential_history ?rh .
                ?rh austalk:state ?state . 
            } ORDER BY ?state""")

        #cache the results
        session['psearch_cache'] = results

    return bottle.template('psearch', results=results, message=message, logged_in=session['logged_in'])

@bottle.post('/presults')
def results():
    '''Perfoms a search of participants and display the results as a table. Saves the results in the session so they can be retrieved later'''

    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    if not 'logged_in' in session:
        session['logged_in'] = False
        session['message'] = "You must log in to view this page!"
        session.save()
        bottle.redirect('/')

    quer = alquery.AlQuery(session['client'])

    try:
        message = session['message']
        session['message'] = ""
        session.save()
    except KeyError:
        session['message'] = ""
        message = session['message']
        session.save()

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
        OPTIONAL { ?id austalk:first_language ?fl . }
        OPTIONAL { ?fl iso639schema:name ?first_language . }
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
            qfilter = qfilter + qbuilder.regex_filter('id',toString=True,prepend="http://id.austalk.edu.au/participant/")
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
    
    resultsList = quer.results_dict_list("austalk", query)
    session['partfilters'] = qfilter #so we can use the filters later again
    session['partlist'] = resultsList
    session['partcount'] = session['resultscount']
    session.save()

    undoExists = 'backupPartList' in session.itervalues()

    return bottle.template('presults', resultsList=resultsList, resultCount=session['partcount'],
                           message=message,undo=undoExists, logged_in=session['logged_in'])

@bottle.get('/presults')
def part_list():
    '''Displays the results of the last participant search, or redirects home if no such search has been performed yet.'''

    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    if not 'logged_in' in session:
        session['logged_in'] = False
        session['message'] = "You must log in to view this page!"
        session.save()
        bottle.redirect('/')

    try:
        resultsList = session['partlist']
        #incase the list was created but for some reason the user removes all elements or searches nothing.
        if len(resultsList)==0:
            raise KeyError
    except KeyError:
        session['message'] = "Perform a participant search first."
        session.save()
        bottle.redirect('/psearch')

    try:
        message = session['message']
        session['message'] = ""
        session.save()
    except KeyError:
        session['message'] = ""
        message = session['message']
        session.save()

    undoExists = 'backupPartList' in session
    if undoExists:
        undoExists = len(session['backupPartList'])>0
    return bottle.template('presults', resultsList=resultsList, resultCount=session['partcount'],
                           message=message,undo=undoExists, logged_in=session['logged_in'])

@bottle.get('/download/participants.csv')
def download_participants_csv():
    '''Returns a csv file download of the participants and all their meta data.'''

    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    if not 'logged_in' in session:
        session['logged_in'] = False
        session['message'] = "You must log in to view this page!"
        session.save()
        bottle.redirect('/')

    quer = alquery.AlQuery(session['client'])

    try:
        resultsList = session['partlist']
        #incase the list was created but for some reason the user removes all elements or searches nothing.
        if len(resultsList)==0:
            raise KeyError
    except KeyError:
        session['message'] = "Perform a participant search first."
        session.save()
        bottle.redirect('/psearch')

    query = qbuilder.get_everything_from_participants(filters=session['partfilters'])

    resultsList = quer.results_dict_list("austalk", query)
    
    #modify the output so it is more human readable
    for row in resultsList:
        row['id'] = row['id'].split('/')[-1]

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

    if not 'logged_in' in session:
        session['logged_in'] = False
        session['message'] = "You must log in to view this page!"
        session.save()
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
        #if nothing selected, tell them to select something first
        if len(selectedParts)==0:
            session['message'] = 'Please select some participants before continuing'
            bottle.redirect('/presults')
        #goto /itemsearch with selected items
        newPartList = [p for p in partList if p['id'] in selectedParts]

        session['partcount'] = len(selectedParts)
        session['partlist'] = newPartList
        session.save()

        bottle.redirect('/itemsearch')
    elif function=='undo':
        #undo most recent remove if there was one.
        try:
            if len(session['backupPartList'])==0:
                raise KeyError
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

    if not 'logged_in' in session:
        session['logged_in'] = False
        session['message'] = "You must log in to view this page!"
        session.save()
        bottle.redirect('/')
        
    quer = alquery.AlQuery(session['client'])

    query = PREFIXES + """
    SELECT distinct ?item ?prompt ?componentName ?media
    WHERE {
      ?item a ausnc:AusNCObject .
      ?item olac:speaker <%s> .
      ?item austalk:prompt ?prompt .
      ?item austalk:prototype ?prototype .
      ?item austalk:componentName ?componentName .
      ?item ausnc:document ?media .
      ?media austalk:version 1 .
      ?media austalk:channel "ch6-speaker16"
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
    query = query + qbuilder.to_str_filter('prototype',prepend="http://id.austalk.edu.au/protocol/item/")

    if bottle.request.forms.get('comptype') != "":
        query=query+"""FILTER regex(?componentName, "%s", "i")""" % (bottle.request.forms.get('comptype'))

    if bottle.request.forms.get('wlist')=='hvdwords':
        query=query+"""FILTER regex(?prompt, "^head$|^had$|^hud$|^hard$|^heared$|^heed$|^hid$|^herd$|^howd$|^hoyd$|^haired$|^hood$|^hod|^whod$", "i")"""

    if bottle.request.forms.get('wlist')=='hvdmono':
        query=query+"""FILTER regex(?prompt, "^head$|^had$|^hud$|^heed$|^hid$|^herd$|^hood$|^hod|^whod$", "i")"""

    if bottle.request.forms.get('wlist')=='hvddip':
        query=query+"""FILTER regex(?prompt, "^hard$|^heared$|^herd$|^howd$|^hoyd$|^haired$", "i")"""

    query = query + "}"

    for row in partList:
        row['item_results'] = quer.results_dict_list("austalk", query % (row['id']))
        resultsCount = resultsCount + session['resultscount']

    session['itemcount'] = resultsCount
    session.save()

    try:
        message = session['message']
        session['message'] = ""
        session.save()
    except KeyError:
        session['message'] = ""
        message = session['message']
        session.save()

    undoExists = 'backupItemList' in session and len(session['backupPartList'])>0

    return bottle.template('itemresults', partList=partList, resultsCount=resultsCount, 
                           message=message,undo=undoExists, logged_in=session['logged_in'])

@bottle.get('/itemresults')
def item_list():
    '''Like part_list but for items. Note that it is functionally different, so these two functions can't currently be rolled together.'''

    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    if not 'logged_in' in session:
        session['logged_in'] = False
        session['message'] = "You must log in to view this page!"
        session.save()
        bottle.redirect('/')

    try:
        partList = session['partlist']
        test = session['partlist'][0]['item_results']#should have something here
    except KeyError:
        session['message'] = "Perform an item search first."
        session.save()
        bottle.redirect('/itemsearch')

    try:
        message = session['message']
        session['message'] = ""
        session.save()
    except KeyError:
        session['message'] = ""
        message = session['message']
        session.save()

    undoExists = 'backupItemList' in session
    if undoExists:
        undoExists = len(session['backupItemList'])>0
    return bottle.template('itemresults', partList=partList, resultsCount=session['itemcount'],
                           message=message,undo=undoExists, logged_in=session['logged_in'])


@bottle.get('/download/items.csv')
@bottle.get('/download/itemswithpartdata.csv')
def download_items_csv():
    '''Returns a csv file download of the participants and all their meta data.'''

    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    if not 'logged_in' in session:
        session['logged_in'] = False
        session['message'] = "You must log in to view this page!"
        session.save()
        bottle.redirect('/')
    
    quer = alquery.AlQuery(session['client'])

    try:
        #incase the list was created but for some reason the user removes all elements or searches nothing.
        if session['itemcount']==0:
            raise KeyError
    except KeyError:
        session['message'] = "Perform an item search first."
        session.save()
        bottle.redirect('/itemsearch')

    resultsList = []
    if str(bottle.request.path).split('/')[-1]=='itemswithpartdata.csv':
        #add more participant meta data
        for part in session['partlist']:
            for x in part['item_results']:
                #now get all participant info
                query = qbuilder.get_everything_from_participants(id=part['id'])
                new = x.copy()
                results = quer.results_dict_list("austalk", query)
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

    if not 'logged_in' in session:
        session['logged_in'] = False
        session['message'] = "You must log in to view this page!"
        session.save()
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
        session.save()
    elif function=='undo':
        #undo most recent remove if there was one.
        try:
            #loop participants and extend each of their item lists
            if len(session['backupItemList'])==0:
                raise KeyError
            for p in partList:
                p['item_results'].extend(session['backupItemList'][p['id']])

            session['itemcount'] += session['backupItemList']['count']
            session['backupItemList']={}
            session.save()
            session['message'] = 'Reversed last remove.'
        except KeyError:
            #was nothing to undo
            session['message'] = 'Nothing to Undo.'
    elif function=='export':
        #remove all that isn't selected.
        for p in partList:
            newItemList = [item for item in p['item_results'] if item['item'] in selectedItems]
            p['item_results'] = newItemList

        bottle.redirect('/export')
    bottle.redirect('/itemresults')


@bottle.route('/itemsearch')
@bottle.post('/itemsearch')
def item_search():
    '''Displays the page for searching items, unless there's not yet a group of participants selected to search for.'''

    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    if not 'logged_in' in session:
        session['logged_in'] = False
        session['message'] = "You must log in to view this page!"
        session.save()
        bottle.redirect('/')
        

    try:
        partList = session['partlist'] #@UnusedVariable
    except KeyError:
        session['message'] = "Select some participants first."
        session.save()
        bottle.redirect('/psearch')

    try:
        message = session['message']
        session['message'] = ""
        session.save()
    except KeyError:
        session['message'] = ""
        message = session['message']
        session.save()

    return bottle.template('itemsearch',results=results, message=message, logged_in=session['logged_in'])


@bottle.get('/itemsearch/sentences')
def getSentences():

    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    if not 'logged_in' in session:
        session['logged_in'] = False
        return "<option value="">You must login to view results!</option>"
        session.save()
    
    quer = alquery.AlQuery(session['client'])

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
    results = quer.results_dict_list("austalk", query)
    return '<option value="">Any</option>\n'+''.join('<option value="%s">%s</option>\n' % (s['prompt'],s['prompt']) for s in results)

@bottle.get('/export')
@bottle.post('/export')
def export():
    '''Exports a selected set of items to Alveo if method is POST. If method is GET, displays a simple form to allow said exporting
    unless no items have yet been selected to export. Redirects home after the export is completed'''

    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    if not 'logged_in' in session:
        session['logged_in'] = False
        session['message'] = "You must log in to view this page!"
        session.save()
        bottle.redirect('/')

    try:
        message = session['message']
        session['message'] = ""
        session.save()
    except KeyError:
        session['message'] = ""
        message = session['message']
        session.save()

    #create a single item list so it can be passed to pyalveo
    iList = [] #iList, the expensive and non-functional but good looking version of list
    listUrl=''
    try:
        for part in session['partlist']:
            [iList.append(item['item']) for item in part['item_results']]

        itemList = pyalveo.ItemGroup(iList, client)
        
    except KeyError:
        session['message'] = "Select some items first."
        session.save()
        bottle.redirect('/itemresults')

    if bottle.request.forms.get('listname') != None:
        #This is when the user sends a post
        listName = bottle.request.forms.get('listname')
        res = itemList.add_to_item_list_by_name(listName)
        
        listUrl = pyalveo.Client.get_item_list_by_name(client,listName).list_url
        message = "List exported to Alveo. Next step is to <a href="+listUrl+">click here</a> to go directly to your list."
        session.save()

    itemLists = client.get_item_lists()
    return bottle.template('export', logged_in=session['logged_in'], itemLists=itemLists,
                           listUrl=listUrl,message=message,itemCount=session['itemcount'])


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
        bottle.redirect('/')
        session['logged_in'] = False
        session['message'] = "You must log in properly!"
        session.save()
        
    if session['client'].oauth.on_callback(bottle.request.url):
        res = session['client'].oauth.get_user_data()
        session['logged_in'] = "%s %s" % (res['first_name'],res['last_name'])
        session['message'] = "Successfully Logged In!"
        session.save()
        
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
    session.save()
    bottle.response.status = 303
    bottle.response.set_header('location','/')
    return 'this is meant to redirect'

    
@bottle.error(500)
def error500(error):
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    session['message'] = "Sorry, something went wrong! Error: 500 Internal Server Error"
    session.save()
    bottle.response.status = 303
    bottle.response.set_header('location','/')
    return 'this is meant to redirect'

@bottle.get('/login')
def login():
    '''Login page.'''
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    if not 'logged_in' in session:
        session['logged_in'] = False
        session.save()
    
    try:
        message = session['message']
        session['message'] = ""
        session.save()
    except KeyError:
        session['message'] = ""
        message = session['message']
        session.save()

    return bottle.template('login', message=message, logged_in=session['logged_in'])

@bottle.get('/logout')
def logout():
    '''Logout and redirect to login page
    '''
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    try:
        session['client'].oauth.revoke_access()
    except KeyError:
        pass
    session.delete()
    session['message'] = "You have successfully logged out!"
    session['logged_in'] = False
    session.save()
    bottle.redirect('/')

@bottle.get('/about')
def about():
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    
    if not 'logged_in' in session:
        session['logged_in'] = False
        session.save()

    return bottle.template('about', logged_in=session['logged_in'])

@bottle.get('/help')
def help():
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    if not 'logged_in' in session:
        session['logged_in'] = False
        session.save()

    return bottle.template('help', logged_in=session['logged_in'])

@bottle.post('/login')
def logging_in():
    '''Logs the user in with their API key.'''
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable

    client = pyalveo.Client(api_url=BASE_URL,client_id=client_id,client_secret=client_secret,
                            redirect_url=redirect_url,verifySSL=False)
    url = client.oauth.get_authorisation_url()
    session['client'] = client
    session.save()
    bottle.redirect(url)

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
    #bottle.run(app=app, host='localhost', port=8080, debug=True)
    import sys
    if len(sys.argv)>1:
        if len(sys.argv)>2 and sys.argv[2]=='--no-ssl':
            redirect_url = "http://"+sys.argv[1]+":8000/oauth/callback"
            bottle.run(app=app, host=sys.argv[1], port=8000, debug=True)
        else:
            redirect_url = "https://"+sys.argv[1]+":8000/oauth/callback"
            bottle.run(app=app, host=sys.argv[1], port=8000, debug=True,server=SSLCherryPyServer)
    else:
        bottle.run(app=app, host='localhost', port=8080, debug=True,server=SSLCherryPyServer)
