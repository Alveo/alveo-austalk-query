'''
Created on 1 Jul 2016

@author: Michael
'''
import unittest
import qbuilder

class Test(unittest.TestCase):

    def test_SimpleFilter(self):
        testType = 'gender'
        testVal = 'male'
        want = 'FILTER regex(?gender, "^male$", "i")\n'
        self.assertTrue(qbuilder.simple_filter(testType, custom=testVal)==want)
        
        #ends in male, ie: doesn't begin with male
        want = 'FILTER regex(?gender, "male$", "i")\n'
        self.assertTrue(qbuilder.simple_filter(testType,beginWith=False, custom=testVal)==want)
        
        #begins with make, ie: doesn't end with male
        want = 'FILTER regex(?gender, "^male", "i")\n'
        self.assertTrue(qbuilder.simple_filter(testType,endWith=False, custom=testVal)==want)
        
        #anywhere in text, ie doesn't begin with or end with male
        want = 'FILTER regex(?gender, "male", "i")\n'
        self.assertTrue(qbuilder.simple_filter(testType,endWith=False,beginWith=False, custom=testVal)==want)
    
    def test_BooleanFilter(self):
        testType = 'is_student'
        testVal = 'true'
        want = 'FILTER(?is_student="true"^^xsd:boolean)\n'
        self.assertTrue(qbuilder.boolean_filter(testType, custom=testVal)==want)
    
    def test_ToStrFilter(self):
        testType = 'first_language'
        testVal = 'English'
        want = 'FILTER regex(str(?first_language), "^English$", "i")\n'
        self.assertTrue(qbuilder.to_str_filter(testType, custom=testVal)==want)
        
        #able to insert something before the given value
        want = 'FILTER regex(str(?first_language), "^addhereEnglish$", "i")\n'
        self.assertTrue(qbuilder.to_str_filter(testType,prepend='addhere', custom=testVal)==want)
    
    def test_SimpleFilterList(self):
        testType = ['gender','city','pob_state']
        testVal = ['male','Sydney','NSW']
        want = '''FILTER regex(?gender, "^male$", "i")\nFILTER regex(?city, "^Sydney$", "i")\nFILTER regex(?pob_state, "^NSW$", "i")\n'''
        
        self.assertTrue(qbuilder.simple_filter_list(testType, custom=testVal)==want)
    
    def test_NumRangeFilter(self):
        testType = 'age'
        testVal = '20'
        want = '''FILTER (?age = xsd:integer(20))\n'''
        self.assertTrue(qbuilder.num_range_filter(testType, custom=testVal)==want)
        
        testVal = '-20'
        want = '''FILTER (?age <= xsd:integer(20))\n'''
        self.assertTrue(qbuilder.num_range_filter(testType, custom=testVal)==want)
        
        testVal = '20+'
        want = '''FILTER (?age >= xsd:integer(20))\n'''
        self.assertTrue(qbuilder.num_range_filter(testType, custom=testVal)==want)
    
    def test_RegexFilter(self):
        testType = 'id'
        testVal = '1_114'
        want = '''FILTER regex(?id, "1_114", "i")\n'''
        self.assertTrue(qbuilder.regex_filter(testType, custom=testVal)==want)
        
        #test to string
        testVal = '1_114'
        want = '''FILTER regex(str(?id), "1_114", "i")\n'''
        self.assertTrue(qbuilder.regex_filter(testType,toString=True, custom=testVal)==want)
        
        #test prepend
        testVal = '1_114'
        want = '''FILTER regex(?id, "addhere1_114", "i")\n'''
        self.assertTrue(qbuilder.regex_filter(testType,prepend='addhere', custom=testVal)==want)
        
        #test prepend and tostring
        testVal = '1_114'
        want = '''FILTER regex(str(?id), "addhere1_114", "i")\n'''
        self.assertTrue(qbuilder.regex_filter(testType,toString=True,prepend='addhere', custom=testVal)==want)
        
if __name__ == "__main__":
    #import sys;sys.argv = ['', 'Test.testName']
    unittest.main()