'''
Created on Jan 24, 2015

@author: Dylan Wheeler
'''

import re

class AlQuery(object):
    """Interfaces with pyalveo, performs SPARQL Queries, and returns the results in a variety of formats."""
    
    def __init__(self, client):
        """
        :type client: :class:Client
        :param client: pyalveo client object used to authorise searches.
        """
        
        self.client = client
        
        

    def htmlTable(self, collection, query):
        """
        Queries the Alveo database and returns the results as an HTML table.
        
        :type collection: String
        :param collection: The collection to be searched.              
        :type query: String
        :param query: The SPARQL query to be used.
        :rtype: List
        :returns: A list with two elements. Element 0 is the HTML, Element 1 is the number of search results.
        """
        
        searchResults = self.client.sparql_query(collection, query)

        itemI = searchResults.iteritems()
        
        head = re.findall(r"(?<=')(?!,)(?!:).*?(?=')", str(itemI.next()))
        head.pop(0)
        head.pop(0)
        bindings = re.findall(r"""(?<=')(?!,)(?!:)(?!}).*?(?=')|(?<=")(?!,)(?!:)(?!}).*?(?=")""", str(itemI.next()))
        
        rlist = []
        
        if len(bindings) >= 4:
            for i in range(0, len(head)):
                for j in range(0, len(bindings)):            
                    if bindings[j-4] == head[i]:
                        rlist.append(bindings[j])
        else:
            return ["No search results.", 0]
           
        html = "<table><tr>"
        
        for i in head:
            html = html + "<th>%s</th>" % (i)
        
        x = len(rlist)/len(head)
        for i in range(0, x):
            html = html + "</tr><tr>"
            
            for j in range(0, len(head)):
                if re.match("""http:""", rlist[i + x*j]) != None:
                    html = html + """<td><a href="%s">%s</a></td>""" % (rlist[i + x*j], rlist[i + x*j])
                else:         
                    html = html + "<td>%s</td>" % (rlist[i + x*j])
            
        html = html + "</tr></table>"
         
        return [html, x]
    
    
    
    def qList(self, collection, query):
        """
        Queries the Alveo database and returns the results as a list order according to the SELECT statement.
        
        :type collection: String
        :param collection: The collection to be searched.            
        :type query: String
        :param query: The SPARQL query to be used.
        """
        
        searchResults = self.client.sparql_query(collection, query)      
        
        itemI = searchResults.iteritems()
        
        head = re.findall(r"(?<=')(?!,)(?!:).*?(?=')", str(itemI.next()))
        head.pop(0)
        head.pop(0)
        bindings = re.findall(r"""(?<=')(?!,)(?!:)(?!}).*?(?=')|(?<=")(?!,)(?!:)(?!}).*?(?=")""", str(itemI.next()))
        
        rlist = []
        
        if len(bindings) >= 4:
            for i in range(0, len(head)):
                for j in range(0, len(bindings)):            
                    if bindings[j-4] == head[i]:
                        rlist.append(bindings[j])
        else:
            return []
        
        return rlist