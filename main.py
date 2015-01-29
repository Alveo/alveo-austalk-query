'''
@author: Dylan Wheeler
'''

from bottle import route, post, run, request, redirect, template, static_file
import alquery
import pyalveo
import re

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

@route('/styles/<filename>')
def serveStyle(filename):
    return static_file(filename, root='./views/styles')

@route('/results')
def redirect_home():
    redirect('/')
    
@route('/')
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
        ORDER BY ?part
    """)
    fLangInt = QUERY.qList("austalk", PREFIXES+
    """                            
        SELECT distinct ?val
        WHERE {
            ?part a foaf:Person .
            ?part austalk:first_language ?val .}
        ORDER BY ?part
    """)
    print fLangDisp
    print fLangInt
    return template('search', cities=cities, herit=herit, highQual=highQual, profCat=profCat, fLangDisp=fLangDisp, fLangInt=fLangInt)
    
@route('/test')
def test():
    query = PREFIXES+ """     
        SELECT distinct ?val 
        where {
          ?part a foaf:Person .
          ?part austalk:recording_site ?site .
          ?site austalk:city ?val .}    
    """
    
    
    searchResults = USER_CLIENT.sparql_query('austalk', query)  
    return searchResults

@post('/results')
def results():
        
    query = PREFIXES+ """
    
    SELECT ?participant ?gender (str(?a) as ?age) ?city ?heritage ?highqual ?profcat"""
    
    #Building up the "Select" clause of the query from formdata for columns we only want to include if there's formdata.
    if request.forms.get('ses') != "":
        query = query + """ ?ses """
        
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
    """
    #Building up the "Where" clause of the query from formdata for columns we only want to include if there's formdata.
    if request.forms.get('ses') != "":
        query = query + """?participant austalk:ses ?ses ."""
          
    #Building filters.
    if request.forms.get('city') != '':
        city = request.forms.get('city')
        query = query + """FILTER regex(?city, "^%s$", "i")""" % (city)
        
    if request.forms.get('gender') != '':
        gender = request.forms.get('gender')
        query = query + """FILTER regex(?gender, "^%s$", "i")""" % (gender)
    
    try:
        if request.forms.get('age') != '':
            age = request.forms.get('age')       
            if re.match(".*-.*", age):
                ages = re.split("-", age, maxsplit=1)
                query = query + """FILTER (xsd:integer(%s) <= ?a && ?a <= xsd:integer(%s))""" % (int(ages[0]), int(ages[1]))
            else:        
                query = query + """FILTER (?a = xsd:integer(%s))""" % (int(age))
    except(ValueError):
        query = query
        
    if request.forms.get('heritage') != '':
        heritage = request.forms.get('heritage')
        query = query + """FILTER regex(?heritage, "^%s$", "i")""" % (heritage)
        
    if request.forms.get('ses') != "":
        ses = request.forms.get('ses')
        query = query + """FILTER regex(?ses, "^%s$", "i")""" % (ses)
        
    if request.forms.get('highqual') !="":
        highQual = request.forms.get('highqual')
        query = query + """FILTER regex(?highqual, "^%s$", "i")""" % (highQual)
        
    if request.forms.get('profcat') != "":
        profCat = request.forms.get('profcat')
        query = query + """FILTER regex(?profcat, "^%s$", "i")""" % (profCat)
        
    if request.forms.get('flang') != "":
        fLang = request.forms.get('flang')
        print fLang
        query = query + """FILTER regex(str(?flang), "^%s$", "i")""" % (fLang)
        print query
        
           
    query = query + "} ORDER BY ?participant"

    resultsTable = QUERY.htmlTable("austalk", query)
       
    return template('results', resultsTable=resultsTable[0], resultCount=resultsTable[1])

run(host='localhost', port=8080, debug=True)


