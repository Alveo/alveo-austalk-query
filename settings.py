'''
Created on 28 Nov 2016

@author: Michael
'''

import socket
url = "http://%s" % socket.gethostbyname(socket.gethostname())
port = "8000"
redirect_url = url+":"+port+"/oauth/callback"

#Real Server
#BASE_URL = 'https://app.alveo.edu.au/' #Normal Server

#Staging Server
#BASE_URL = 'https://staging.alveo.edu.au/'
#client_id = "a55ad0231142d3e5ca75e897a03e95277fb6479e200a473a02c85fb7e7cb6656"
#client_secret = "d77d12411d7e18dee5f28172795391969eb727a407b0552561236e29217b9ab6"

#Karls HTTP test server
BASE_URL = 'http://10.46.35.189:3000'
client_id = "55cfb1b4ccc620f97363378e5cdd41a1f9afcd3941b0565492a54fd17d488030"
client_secret = "22b3e429cc18367644f17cc655d0ee3d03bdee9a772086a660e8c47d156a87d1"
