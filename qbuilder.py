'''
@author: Dylan Wheeler
'''

from bottle import request
import re

def simpleFilter(fName):
    '''
    @summary: Used to add a simple filter to a SPARQL query.
    
    @param fName: The name of the field being filtered. Make sure that this matches the name of the input in the HTML form.
    @type fName: String
    @return: A FILTER line to be added to a SPARQL query.
    @rtype: String
    '''
    
    if request.forms.get(fName) != '':
        val = request.forms.get(fName)
        return """FILTER regex(?%s, "^%s$", "i")""" % (fName, val)
    else:
        return ''
    
def toStrFilter(fName):
    '''
    @summary: Used to add a simple filter to a SPARQL query where the field needs to be converted to a string from another data type (such as a URI)
    
    @param fName: The name of the field being filtered. Make sure that this matches the name of the input in the HTML form.
    @type fName: String
    @return: A FILTER line to be added to a SPARQL query.
    @rtype: String
    '''
    
    if request.forms.get(fName) != '':
        val = request.forms.get(fName)
        return """FILTER regex(str(?%s), "^%s$", "i")""" % (fName, val)
    else:
        return ''
    
def simpleFilterList(fList):
    '''
    @summary: Used to add many simple filters to a SPARQL query.
    
    @param fList: A list of fields to be filtered. Make sure that they match the names of the inputs in the HTML form.
    @type fList: List
    @return: Some FILTER lines to be added to a SPARQL query.
    @rtype: String
    '''
    
    filters = ''
    
    for field in fList:
        filters = filters + simpleFilter(field)
    
    return filters

def numRangeFilter(fName):
    '''
    @summary: Used to add a filter that can search a range of numbers to a SPARQL query.
    
    @param fName: The name of the field being filtered. Make sure that this matches the name of the input in the HTML form.
    @type fName: String
    @return: A FILTER line to be added to a SPARQL query.
    @rtype: String
    '''
    
    if request.forms.get(fName) != '':    
        try:
            val = request.forms.get(fName)       
            if re.match(".*-.*", val):
                vals = re.split("-", val, maxsplit=1)
                return """FILTER (xsd:integer(%s) <= ?a && ?a <= xsd:integer(%s))""" % (int(vals[0]), int(vals[1]))
            else:        
                return """FILTER (?a = xsd:integer(%s))""" % (int(val))
        except(ValueError):
            return ''
    else:
        return ''
    
def textRangeFilter(fName):
    '''
    @summary: Used to add a filter that can search one or more text entries separated by commas to a SPARQL query.
    
    @param fName: The name of the field being filtered. Make sure that this matches the name of the input in the HTML form.
    @type fName: String
    @return: A FILTER line to be added to a SPARQL query.
    @rtype: String
    '''     
    if request.forms.get(fName) != "":
        val = request.forms.get(fName)
        
        if re.match("""\".*\"""", val):
            val = val.strip("\"")
            return """FILTER regex(?%s, "^%s$", "i")""" % (fName, val)           
        elif re.match(".*,.*", val):
            vals = ""
            tvals = re.split(",", val)
            for x in tvals:
                x = x.strip()
                vals = vals + str(x) +"|"
            vals = vals.rstrip("|")
            return """FILTER regex(?%s, "%s", "i")""" % (fName, vals)
        else:    
            return """FILTER regex(?%s, "%s", "i")""" % (fName, val)
    else:
        return ''
    
def selectList(sList):
    '''
    @summary: Used to add a list of items to a SPARQL query SELECT line when we only want to select these items if they have form data.
    
    @param: sList: A list of fields to select. Make sure they match the names of the input fields in the HTML form.
    @type: sList: List
    @return: A string to be added to SELECT clause.
    @rtype: String
    '''
    
    selects = ''   
    for item in sList:
        if request.forms.get(item) != "":
            selects = selects + """ ?%s """ % (item)
    return selects   
    