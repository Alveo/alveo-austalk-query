Alveo Austalk Query
===================

This project provides a web application that is a front end to the Alveo API
to provide an enhanced search service for data in the Austalk corpus.

The application is written using the Bottle framework and is basically an
interface for construction of SPARQL queries over the demographic data
stored in the Alveo system.

Deployment
----------

Currently deployed on http://austalk-query.apps.stevecassidy.net/ using dokku.
Summary instructions for deployment are:

   git remote add dokku dokku@apps.stevecassidy.net:austalk-query
   git push dokku master
