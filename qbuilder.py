'''
@author: Dylan Wheeler

@summary: Contains functions related to building SPARQL queries.
'''

from bottle import request
import re
from main import PREFIXES

def simple_values_search(quer,collection,relations,sortAlphabetically=False):
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
                              ?part a foaf:Person .
                              ?site austalk:%s ?val .}""" % item
        if sortAlphabetically:
            q += '''order by asc(ucase(str(?val)))'''
        
        results[item] = quer.results_list(collection,q)
    
    return results
    

def simple_filter(fName):
    '''
    @summary: Used to add a simple filter to a SPARQL query.
    
    @param fName: The name of the field being filtered. Make sure that this matches the name of the input in the HTML form.
    @type fName: String
    @return: A FILTER line to be added to a SPARQL query.
    @rtype: String
    '''

    if request.forms.get(fName):
        val = request.forms.get(fName)
        return """FILTER regex(?%s, "^%s$", "i")""" % (fName, val)
    else:
        return ''       
    
def to_str_filter(fName):
    '''
    @summary: Used to add a simple filter to a SPARQL query where the field needs to be converted to a string from another data type (such as a URI)
    
    @param fName: The name of the field being filtered. Make sure that this matches the name of the input in the HTML form.
    @type fName: String
    @return: A FILTER line to be added to a SPARQL query.
    @rtype: String
    '''
    
    if request.forms.get(fName):
        val = request.forms.get(fName)
        return """FILTER regex(str(?%s), "^%s$", "i")""" % (fName, val)
    else:
        return ''
    
def simple_filter_list(fList):
    '''
    @summary: Used to add many simple filters to a SPARQL query.
    
    @param fList: A list of fields to be filtered. Make sure that they match the names of the inputs in the HTML form.
    @type fList: List
    @return: Some FILTER lines to be added to a SPARQL query.
    @rtype: String
    '''
    
    filters = ''
    
    for field in fList:
        filters = filters + simple_filter(field)
    
    return filters

def num_range_filter(fName):
    '''
    @summary: Used to add a filter that can search a range of numbers to a SPARQL query.
    
    @param fName: The name of the field being filtered. Make sure that this matches the name of the input in the HTML form.
    @type fName: String
    @return: A FILTER line to be added to a SPARQL query.
    @rtype: String
    '''
    
    if request.forms.get(fName):    
        try:
            val = request.forms.get(fName)    
            val = val.rstrip("-")
            if re.match("-", val):
                val = val.strip("-")
                return """FILTER (?%s <= xsd:integer(%s))""" % (fName, int(val))
            if re.match(".+\+", val):
                val = val.strip("+")
                return """FILTER (?%s >= xsd:integer(%s))""" % (fName, int(val))
            if re.match(".*-.*", val):
                vals = re.split("-", val, maxsplit=1)
                if vals[0] > vals[1]:
                    vals.reverse()
                return """FILTER (xsd:integer(%s) <= ?%s && ?%s <= xsd:integer(%s))""" % (int(vals[0]), fName, fName, int(vals[1]))
            else:        
                return """FILTER (?%s = xsd:integer(%s))""" % (fName, int(val))
        except(ValueError):
            return ''
    else:
        return ''
    
def regex_filter(fName,toString=False,prepend="",custom=None):
    '''
    @summary: Used to add a filter that can search one or more text entries separated by commas to a SPARQL query.
    
    @param fName: The name of the field being filtered. Make sure that this matches the name of the input in the HTML form.
    @type fName: String
    @param toString: If fName needs to be converted to a string in the query
    @type Boolean
    @param prepend: Adds a string at the beginning of the query, use if the user input values is not the entire value that needs to be specified in SPARQL.
                    Eg: User selects ?participant with a [0-9]_[0-9]^3 string rather than the entire url. 
                    Necessary if the searched element can be a subset of another element. Ie: when you search for "1_114" yet "1_1441" also exists.
    @type String
    @param custom: If the input needs to be manually formatted rather than being pulled directly from the form
    @type String
    @return: A FILTER line to be added to a SPARQL query.
    @rtype: String
    '''     
    if request.forms.get(fName):
        if custom:
            val = custom
        else:
            val = request.forms.get(fName)
             
        #check first to see if it's a list of some sort
        if re.match(".*,.*", val):
            vals = ""
            tvals = re.split(",", val)
            for x in tvals:
                #maybe this element of the list has quotes
                if re.match("""\".*\"""", x):
                    x = "^"+prepend+x.strip()[1:-1]+"$"
                    vals = vals + str(x) +"|"
                else:
                    x = prepend+x.strip()
                    vals = vals + str(x) +"|"
            vals = vals.rstrip("|")
            if toString:
                return """FILTER regex(str(?%s), "%s", "i")""" % (fName, vals)
            return """FILTER regex(?%s, "%s", "i")""" % (fName, vals)
        #if it's no list then we check for quotes
        elif re.match("""\".*\"""", val):
            val = prepend+val.strip("\"")
            if toString:
                return """FILTER regex(str(?%s), "^%s$", "i")""" % (fName, val) 
            return """FILTER regex(?%s, "^%s$", "i")""" % (fName, val)      
        else:
            if toString:    
                return """FILTER regex(str(?%s), "%s", "i")""" % (fName, prepend+val)
            return """FILTER regex(?%s, "%s", "i")""" % (fName, prepend+val)
    else:
        return ''
    
def select_list(sList):
    '''
    @summary: Used to add a list of items to a SPARQL query SELECT line when we only want to select these items if they have form data.
    
    @param: sList: A list of fields to select. Make sure they match the names of the input fields in the HTML form.
    @type: sList: List
    @return: A string to be added to SELECT clause.
    @rtype: String
    '''
    
    selects = ''   
    for item in sList:
        if request.forms.get(item):
            selects = selects + """ ?%s """ % (item)
    return selects   
    