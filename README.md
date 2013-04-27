assessment-client
=================

Pre-requisites:
---------------

* Install node.js
  
        brew install node

* Install Yeoman (http://yeoman.io/)

        npm install -g yo grunt-cli bower 

* Install jqueryui-amd (https://github.com/jrburke/jqueryui-amd)

        npm install -g jqueryui-amd    


Installation:
-------------

* Install the dev dependencies and client-side javascript dependencies:

        npm install && bower install

* Run the jquery-amd code from the root of your client folder to create an amd wrapper for the jqueryui components

        jqueryui-amd app/components/jquery-ui

* Go to the OAuthProvider project (api-server)

  Copy the app_secrets_dev.js file and paste it into app/scripts folder

* Setting up POW (http://pow.cx/): (We are just using POW as a proxy/DNS server, it is not a web server.)

        echo 7000 > ~/.pow/assessments-front

Now ready to run the front-end:

        grunt server
