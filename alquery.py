'''
@author: Dylan Wheeler

@summary: Interfaces with pyalveo, performs SPARQL queries, and returns the results in different formats.
'''

import bottle
import re

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
        
        x = len(rlist)/len(head)
        
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