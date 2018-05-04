"""
    A server to run the application locally for development
"""
import sys, socket
from cherrypy import wsgiserver
from cherrypy.wsgiserver.ssl_pyopenssl import pyOpenSSLAdapter
from OpenSSL import SSL

import bottle
from main import app
port = None
from settings import *


# By default, the server will allow negotiations with extremely old protocols
# that are susceptible to attacks, so we only allow TLSv1.2
class SecuredSSLServer(pyOpenSSLAdapter):
    def get_context(self):
        c = super(SecuredSSLServer, self).get_context()
        c.set_options(SSL.OP_NO_SSLv2)
        c.set_options(SSL.OP_NO_SSLv3)
        c.set_options(SSL.OP_NO_TLSv1)
        c.set_options(SSL.OP_NO_TLSv1_1)
        return c

# Create our own sub-class of Bottle's ServerAdapter
# so that we can specify SSL. Using just server='cherrypy'
# uses the default cherrypy server, which doesn't use SSL
class SSLCherryPyServer(bottle.ServerAdapter):
    def run(self, handler):
        server = wsgiserver.CherryPyWSGIServer((self.host, self.port), handler)
        server.ssl_adapter = SecuredSSLServer('keys/cacert.pem', 'keys/privkey.pem')
        try:
            server.start()
        finally:
            server.stop()

if __name__ == '__main__':
    '''Runs the app. Listens on localhost:8080.'''
    try:
        ip = socket.gethostbyname(socket.gethostname())
    except:
        ip = ''
    if len(sys.argv)>1:
        if len(sys.argv)>2 and sys.argv[2]=='--no-ssl':
            if not port:
                    port = 80
            bottle.run(app=app, host=sys.argv[1], port=port, debug=True)
        else:
            if sys.argv[1]=='--no-ssl':
                if not port:
                    port = 80
                bottle.run(app=app, host=ip, port=port, debug=True)
            else:
                if not port:
                    port = 443
                bottle.run(app=app, host=sys.argv[1], port=port, debug=True,server=SSLCherryPyServer)
    else:
        if not port:
            port = 443
        bottle.run(app=app, host=ip, port=port, debug=True,server=SSLCherryPyServer)
