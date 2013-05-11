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

* Go to the OAuthProvider project (api-server)

  Copy the app_secrets_dev.js file and paste it into app/scripts folder

* Setting up POW (http://pow.cx/): (We are just using POW as a proxy/DNS server, it is not a web server.)

        echo 7000 > ~/.pow/assessments-front

Now ready to run the front-end:

        grunt server
