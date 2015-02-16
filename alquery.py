'''
@author: Dylan Wheeler
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
        
        session = bottle.request.environ.get('beaker.session') #@UndefinedVariable
        
        searchResults = self.client.sparql_query(collection, query)
   
        head = searchResults['head']['vars']     
                
        rlist = []
        
        for column in head:
            for result in searchResults['results']['bindings']:
                rlist.append(result[column]['value'])
                
        if len(rlist) == 0:
            session['lastresults'] = []
            session['resultscount'] = 0
            session.save()
            return "No search results."
  
        html = "<table><tr>"
        html = html + "<th>Selected</th>"
        
        for i in head:       
            html = html + "<th>%s</th>" % (i)
        
        x = len(rlist)/len(head)
        mlist = []
        
        for i in range(0, x):
            mlist.append(rlist[i])
            
        session['lastresults'] = mlist
        session['resultscount'] = x
        session.save()
        
        for i in range(0, x):
            html = html + "</tr><tr>"
            html = html + """<td><input type="checkbox" name="selected" value="%s">""" % (rlist[i])       
                 
            for j in range(0, len(head)):               
                if re.match("""http:|https:""", rlist[i + x*j]) != None:
                    html = html + """<td><a href="%s">%s</a></td>""" % (rlist[i + x*j], rlist[i + x*j])
                else:         
                    html = html + "<td>%s</td>" % (rlist[i + x*j])
            
        html = html + "</tr></table>"
         
        return html
    
    
    
    def results_list(self, collection, query):
        """
        @summary: Queries the Alveo database and returns the results as a list ordered according to the SELECT statement.
        
        @type collection: String
        @param collection: The collection to be searched.            
        @type query: String
        @param query: The SPARQL query to be used.
        @returns: A list of all results.
        """
        
        searchResults = self.client.sparql_query(collection, query)      
        
        head = searchResults['head']['vars']     
                
        rlist = []
        
        for column in head:
            for result in searchResults['results']['bindings']:
                rlist.append(result[column]['value'])
        
        return rlist