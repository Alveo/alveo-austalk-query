'''
@author: Dylan Wheeler

@summary: Interfaces with pyalveo, performs SPARQL queries, and returns the results in different formats.
'''

import bottle
import re

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

class AlQuery(object):
    """Interfaces with pyalveo, performs SPARQL Queries, and returns the results in a variety of formats."""
    
    def __init__(self, client):
        """
        @type client: :class:Client
        @param client: pyalveo client object used to authorise searches.
        """
               
        self.client = client

    def html_table(self, collection, query):
        """
        @summary: Queries the Alveo database and returns the results as an HTML table.
        
        @type collection: String
        @param collection: The collection to be searched.              
        @type query: String
        @param query: The SPARQL query to be used.
        @rtype: List
        @returns: A list with three elements: The HTML, a list of results for the first selected field, the number of search results, 
        """

        results = self.results_dict_list(collection, query)
        if isinstance(results, str):
            return results
            
        html = "<table><tr>"
        html = html + "<th>Selected</th>"
        isItem = False
        for i in results[0].items():       
            #get the keys from this dict list from the first element. 
            html = html + "<th>%s</th>" % (i[0])
            if i[0]=='item':
                isItem = True
        
        for row in results:
            html = html + "</tr><tr>"
            html = html + """<td><input type="checkbox" name="selected" value="%s">""" % ((row['item']) if isItem else (row['participant'])  )     
                 
            for item in row.items():               
                if re.match("""http:|https:""", item[1]) != None:
                    html = html + """<td><a href="%s">%s</a></td>""" % (item[1], item[1])
                else:         
                    html = html + "<td>%s</td>" % (item[1])
            
        html = html + "</tr></table>"
         
        return html
    
    def simple_values_search(self,collection,relations,sortAlphabetically=False,isItem=False):
        '''
        @summery: Used to provide a list of all the available distinct values for each relation in the list.
        
        @param quer: An instance of the AlQuery class
        @type quer: AlQuery
        @param collection: The collection to be searched.              
        @type query: String
        @param relations: A list of all relations to be searched
        @type relations: List
        @param sortAlphabetically: Will return the values in alphabetical order for all relations
        @type sortAlphabetically: Boolean
        @return: A dict with a key for each item in relations and the value being a list of all distinct values for that relation.
        @rtype: Dict
        '''
        results = {}
        for item in relations:
            q = PREFIXES+"""    
                                SELECT distinct ?val 
                                where {
                                  ?part a %s .
                                  ?part austalk:%s ?val .}""" % ("foaf:Person" if not isItem else "ausnc:AusNCObject",item)
            if sortAlphabetically:
                q += '''order by asc(ucase(str(?val)))'''
            results[item] = self.results_list(collection,q)
    
        return results
    
    def results_dict_list(self, collection, query):
        """
        @summary: Queries the Alveo database and returns the results as a list of dictionaries.
        
        @type collection: String
        @param collection: The collection to be searched.            
        @type query: String
        @param query: The SPARQL query to be used.
        @returns: A list of all results.
        """
        session = bottle.request.environ.get('beaker.session') #@UndefinedVariable
        
        searchResults = self.client.sparql_query(collection, query)
   
        head = searchResults['head']['vars']     
        rlist = []
        
        for column in head:
            for result in searchResults['results']['bindings']:
                try:
                    rlist.append(result[column]['value'])
                except KeyError:
                    rlist.append(u'')
                
        if len(rlist) == 0:
            session['lastresults'] = []
            session['resultscount'] = 0
            session.save()
            return []
        
        x = int(len(rlist)/len(head))
        
        results = []
        for i in range(x):
            item = {}
            for col in range(i,len(rlist),x):
                item[head[col/x]] = rlist[col]
            results.append(item)
            
        session['lastresults'] = results
        session['resultscount'] = x
        session.save()
        
        return results
    
    def results_list(self, collection, query):
        """
        @summary: Queries the Alveo database and returns the results as a list ordered according to the SELECT statement.
        
        @type collection: String
        @param collection: The collection to be searched.            
        @type query: String
        @param query: The SPARQL query to be used.
        @returns: A list of all results.
        """
        session = bottle.request.environ.get('beaker.session') #@UndefinedVariable
        searchResults = self.client.sparql_query(collection, query)      
        
        head = searchResults['head']['vars']     
        rlist = []
        session['lastresults'] = []
        
        for column in head:
            for result in searchResults['results']['bindings']:
                rlist.append(result[column]['value'])
        
        if len(rlist) == 0:
            session['lastresults'] = []
            session['resultscount'] = 0
            session.save()
            return []
        
        session['resultscount'] = len(rlist)/len(head)
        session['lastresults'] = rlist
        session.save()
        return rlist