Alveo Austalk Query
===================

This project provides a web application that is a front end to the Alveo API
to provide an enhanced search service for data in the Austalk corpus.

The application is written using the Bottle framework and is basically an
interface for construction of SPARQL queries over the demographic data
stored in the Alveo system.

Deployment
----------

Currently deployed on https://austalk-query.apps.alveo.edu.au using dokku.
Summary instructions for deployment are:

- git remote add dokku dokku@austalk-query.apps.alveo.edu.au:austalk-query
- git push dokku master

Note: Your key may need to be added to the dokku server before you're able to deploy.

Config
------

Austalk Query relies on four environment variables as configuration. These are:

- APP_URL : The url to the primary Alveo app, eg: https://app.alveo.edu.au/
- REDIRECT_URL : The URL required by OAuth2.0 to redirect back to the app, eg: https://austalk-query.apps.alveo.edu.au
- CLIENT_ID : Austalk Query's unique client id for OAuth2.0
- CLIENT_SECRET : Austalk Query's unique secret key for OAuth2.0