'''
Created on 28 Nov 2016

@author: Michael
'''

import os
redirect_url = os.environ.get('REDIRECT_URL',None)
BASE_URL = os.environ.get('APP_URL','https://app.alveo.edu.au')
client_id = os.environ.get('CLIENT_ID',None)
client_secret = os.environ.get('CLIENT_SECRET',None)
log_file = os.environ.get('LOG_FILE','storage/log.csv')
try:
    max_log_size = int(os.environ.get('MAX_LOG_SIZE',5*1024*1024))
except ValueError:
    #Incase environment variable isn't a valid integer
    #Default 5Mb
    max_log_size = 5*1024*1024
