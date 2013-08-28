assessment-client
=================

Pre-requisites:
---------------
* Install apple's xcode command line tools

        https://developer.apple.com/downloads/

* Install homebrew

        ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

* Install node.js
  
        brew install node

* Add NPM packages to PATH. Add the following two lines to your `~/.profile` or `~/.zshrc` file

        # Add globally installed Node Packages to the PATH variable
        export PATH=/usr/local/share/npm/bin:$PATH

* Install Compass for front end precompilation

        gem install compass

* Install Yeoman (http://yeoman.io/)

        npm install -g yo grunt-cli bower

* Install jqueryui-amd (https://github.com/jrburke/jqueryui-amd)

        npm install -g jqueryui-amd


Installation:
-------------

* Install the dev dependencies and client-side javascript dependencies:

        npm install && bower install

* .env file in your client project needs to contain:
        
        DEV_APISERVER=
        DEV_APPSECRET=
        DEV_APPID=
        PROD_APISERVER=
        PROD_APPSECRET=
        PROD_APPID=

    To get the DEV_* versions of those values, go to the OAuthProvider project (api-server). The contents of the .client_env file will provide the necessary environment variables for connecting to the api-server. Copy those in your .env file in the client project. If not you may need to run rake:db_seed to let it generate those values on your dev machine. 

    To get the PROD_* versions, contact your deployment person in TidePool. The PROD_* versions are used for generating (grunt dist) the production deployment files. Generally this should be only happening on the Teamcity deployment server.   

* Setting up POW (http://pow.cx/): (We are just using POW as a proxy/DNS server, it is not a web server.)

        echo 7000 > ~/.pow/assessments-front

Now ready to run the front-end:

        grunt server
        
Deployment
----------
https://github.com/tidepool/assessment-client/wiki/Thar-Build
