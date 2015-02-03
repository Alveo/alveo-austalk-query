'''
@author: Dylan Wheeler
'''

import bottle
from beaker.middleware import SessionMiddleware
import alquery
import qbuilder
import pyalveo

API_KEY = 'Ms8qzfWCDSNJUwdAkezq'
BASE_URL = 'https://app.alveo.edu.au/'
USER_CLIENT = pyalveo.Client(API_KEY, BASE_URL)
QUERY = alquery.AlQuery(USER_CLIENT)
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
def serveStyle(filename):
    return bottle.static_file(filename, root='./views/styles')

@bottle.get('/itemsearch')
@bottle.get('/itemresults')
@bottle.get('/presults')
def redirect_home():
    bottle.redirect('/')
    
@bottle.route('/')
def search():
    
    cities = QUERY.qList("austalk", PREFIXES+
    """    
        SELECT distinct ?val 
        where {
          ?part a foaf:Person .
          ?part austalk:recording_site ?site .
          ?site austalk:city ?val .}""")
    herit = QUERY.qList("austalk", PREFIXES+
    """    
        SELECT distinct ?val 
        where {
          ?part a foaf:Person .
          ?part austalk:cultural_heritage ?val .}""")
    highQual = QUERY.qList("austalk", PREFIXES+
    """    
        SELECT distinct ?val 
        where {
          ?part a foaf:Person .
          ?part austalk:education_level ?val .}""")
    profCat = QUERY.qList("austalk", PREFIXES+
    """
        SELECT distinct ?val 
        where {
          ?part a foaf:Person .
          ?part austalk:professional_category ?val . } """)
    fLangDisp = QUERY.qList("austalk", PREFIXES+
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
    fLangInt = QUERY.qList("austalk", PREFIXES+
    """                            
        SELECT distinct ?val
        WHERE {
            ?part a foaf:Person .
            ?part austalk:first_language ?val .}
        ORDER BY ?part""")
    bCountries = QUERY.qList("austalk", PREFIXES+
        """
        SELECT distinct ?val 
        where {
          ?part a foaf:Person .
          ?part austalk:pob_country ?val .}""")

    return bottle.template('psearch', cities=cities, herit=herit, highQual=highQual, profCat=profCat, fLangDisp=fLangDisp, fLangInt=fLangInt, bCountries=bCountries)
    
@bottle.route('/test')
def test():
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
    session['test'] = session.get('test',0) + 1
    session.save()
    return 'Test counter: %d' % session['test']

@bottle.post('/presults')
def results():
    
    session = bottle.request.environ.get('beaker.session')  #@UndefinedVariable
        
    query = PREFIXES+ """
    
    SELECT ?participant ?gender (str(?a) as ?age) ?city ?bcountry ?heritage ?highqual ?profcat"""
    
    #Building up the "Select" clause of the query from formdata for columns we only want to include if there's formdata.
    query = query + qbuilder.selectList(['ses', 'olangs', 'bstate', 'btown'])
           
    query = query + """
    WHERE {
        ?participant a foaf:Person .
        ?participant austalk:cultural_heritage ?heritage .
        ?participant austalk:education_level ?highqual .
        ?participant austalk:recording_site ?site .
        ?site austalk:city ?city .
        ?participant foaf:age ?a .
        ?participant foaf:gender ?gender .
        ?participant austalk:professional_category ?profcat .
        ?participant austalk:first_language ?flang .
        ?participant austalk:pob_country ?bcountry .   
    """
    #Building up the "Where" clause of the query from formdata for columns we only want to include if there's formdata.
    if bottle.request.forms.get('ses') != "":
        query = query + """?participant austalk:ses ?ses ."""
    if bottle.request.forms.get('olangs') != "":
        query = query + """?participant austalk:other_languages ?olangs ."""
    if bottle.request.forms.get('bstate') != "":
        query = query + """?participant austalk:pob_state ?bstate ."""
    if bottle.request.forms.get('btown') != "":
        query = query + """?participant austalk:pob_town ?btown ."""
          
    #Building filters.    
    query = query + qbuilder.simpleFilterList(['city', 'gender', 'heritage', 'ses', 'highqual',
                                               'profcat', 'bcountry', 'bstate', 'btown'])
    query = query + qbuilder.toStrFilter('flang')
    query = query + qbuilder.numRangeFilter('age')
    query = query + qbuilder.textRangeFilter('olangs')
                         
    query = query + "} ORDER BY ?participant"
    print query
    
    resultsTable = QUERY.htmlTable("austalk", query)
    
    return bottle.template('presults', resultsTable=resultsTable, resultCount=session['resultscount'])

@bottle.post('/itemresults')
def item_results():
    return bottle.template('itemresults')

@bottle.post('/itemsearch')
def item_search():
    return bottle.template('itemsearch')

if __name__ == '__main__':
    bottle.run(app=app, host='localhost', port=8080, debug=True)


