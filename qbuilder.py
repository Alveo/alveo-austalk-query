'''
@author: Dylan Wheeler

@summary: Contains functions related to building SPARQL queries.
'''

from bottle import request
import re

def simple_filter(fName,endWith=True,beginWith=True,custom=None):
    '''
    @summary: Used to add a simple filter to a SPARQL query.
    
    @param fName: The name of the field being filtered. Make sure that this matches the name of the input in the HTML form.
    @type fName: String
    @param endWith: True to ensure the value ends with the given input
    @type endWith: Boolean
    @param beginWith: True to ensure the value begins with the given input
    @type beginWith: Boolean
    @param custom: If the input needs to be manually formatted rather than being pulled directly from the form
    @type String
    @return: A FILTER line to be added to a SPARQL query.
    @rtype: String
    '''
    if custom:
        val = custom
    else:
        val = request.forms.get(fName)
    if val:
        return """FILTER regex(?%s, "%s%s%s", "i")\n""" % (fName,'^' if beginWith else '',val,'$' if endWith else '')
    else:
        return ''     
    
def boolean_filter(fName,custom=None):  
    '''
    @summary: Used to add a simple boolean filter to a SPARQL query.
    
    @param fName: The name of the field being filtered. Make sure that this matches the name of the input in the HTML form.
    @type fName: String
    @param custom: If the input needs to be manually formatted rather than being pulled directly from the form
    @type String
    @return: A FILTER line to be added to a SPARQL query.
    @rtype: String
    '''
    if custom:
        val = custom
    else:
        val = request.forms.get(fName)
    if val:
        return """FILTER(?%s="%s"^^xsd:boolean)\n""" % (fName, val)
    else:
        return ''     
    
def to_str_filter(fName,prepend="",custom=None):
    '''
    @summary: Used to add a simple filter to a SPARQL query where the field needs to be converted to a string from another data type (such as a URI)
    
    @param fName: The name of the field being filtered. Make sure that this matches the name of the input in the HTML form.
    @type fName: String
    @param prepend: Adds a string at the beginning of the query, use if the user input values is not the entire value that needs to be specified in SPARQL.
                    Eg: User selects ?participant with a [0-9]_[0-9]^3 string rather than the entire url. 
                    Necessary if the searched element can be a subset of another element. Ie: when you search for "1_114" yet "1_1441" also exists.
    @type String
    @param custom: If the input needs to be manually formatted rather than being pulled directly from the form
    @type String
    @return: A FILTER line to be added to a SPARQL query.
    @rtype: String
    '''
    if custom:
        val = custom
    else:
        val = request.forms.get(fName)
    if val:
        return """FILTER regex(str(?%s), "^%s%s$", "i")\n""" % (fName, prepend,val)
    else:
        return ''
    
def simple_filter_list(fList,custom=None):
    '''
    @summary: Used to add many simple filters to a SPARQL query.
    
    @param fList: A list of fields to be filtered. Make sure that they match the names of the inputs in the HTML form.
    @type fList: List
    @param custom: If the input needs to be manually formatted rather than being pulled directly from the form, must be the same length as given list
    @type String
    @return: Some FILTER lines to be added to a SPARQL query.
    @rtype: String
    '''
    
    filters = ''
    
    for i in range(len(fList)):
        filters = filters + simple_filter(fList[i],custom=custom[i])
    
    return filters

def num_range_filter(fName,custom=None):
    '''
    @summary: Used to add a filter that can search a range of numbers to a SPARQL query.
    
    @param fName: The name of the field being filtered. Make sure that this matches the name of the input in the HTML form.
    @type fName: String
    @param custom: If the input needs to be manually formatted rather than being pulled directly from the form
    @type String
    @return: A FILTER line to be added to a SPARQL query.
    @rtype: String
    '''
    if custom:
        val = custom
    else:
        val = request.forms.get(fName)
    if val:    
        try:  
            val = val.rstrip("-")
            if re.match("-", val):
                val = val.strip("-")
                return """FILTER (?%s <= xsd:integer(%s))\n""" % (fName, int(val))
            if re.match(".+\+", val):
                val = val.strip("+")
                return """FILTER (?%s >= xsd:integer(%s))\n""" % (fName, int(val))
            if re.match(".*-.*", val):
                vals = re.split("-", val, maxsplit=1)
                if vals[0] > vals[1]:
                    vals.reverse()
                return """FILTER (xsd:integer(%s) <= ?%s && ?%s <= xsd:integer(%s))\n""" % (int(vals[0]), fName, fName, int(vals[1]))
            else:        
                return """FILTER (?%s = xsd:integer(%s))\n""" % (fName, int(val))
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
     
    if custom:
        val = custom
    else:
        val = request.forms.get(fName)
            
    if val:
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
                return """FILTER regex(str(?%s), "%s", "i")\n""" % (fName, vals)
            return """FILTER regex(?%s, "%s", "i")\n""" % (fName, vals)
        #if it's no list then we check for quotes
        elif re.match("""\".*\"""", val):
            val = prepend+val.strip("\"")
            if toString:
                return """FILTER regex(str(?%s), "^%s$", "i")\n""" % (fName, val) 
            return """FILTER regex(?%s, "^%s$", "i")\n""" % (fName, val)      
        else:
            if toString:    
                return """FILTER regex(str(?%s), "%s", "i")\n""" % (fName, prepend+val)
            return """FILTER regex(?%s, "%s", "i")\n""" % (fName, prepend+val)
    else:
        return ''
    
def select_list(sList,custom=False):
    '''
    @summary: Used to add a list of items to a SPARQL query SELECT line when we only want to select these items if they have form data.
    
    @param: sList: A list of fields to select. Make sure they match the names of the input fields in the HTML form.
    @type: sList: List
    @param ignoreRequest: If the input needs not be pulled directly from the form
    @type Boolean
    @return: A string to be added to SELECT clause.
    @rtype: String
    '''
    
    selects = ''   
    for item in sList:
        if custom or request.forms.get(item):
            selects = selects + """ ?%s """ % (item)
    return selects   
    