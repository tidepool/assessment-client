define [
  'jquery',
  'underscore',
  'Backbone',
  'Handlebars',
  'models/user'], ($, _, Backbone, Handlebars, User) ->
  Session = Backbone.Model.extend
    # Inspired by: https://github.com/ptnplanet/backbone-oauth

    initialize: (appId) ->
      @appId = appId
      @accessToken = localStorage['access_token']
      $.ajaxSetup
        type: 'POST',
        headers:  
          'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') 
          'Accept': 'application/json'
        dataType: 'json'
        beforeSend: (jqXHR, options) =>
          if @loggedIn()
            tokenHeader = "Bearer #{@accessToken}"
            jqXHR.setRequestHeader('Authorization', tokenHeader)

    # If already logged in as a user, then create session for it.
    # If not logged in 
    login: (forceNoGuest) ->
      # check if already logged-in
      if @loggedIn()
        @finishLogin()
      else 
        @authUrl = @setupAuthUrl(window.apiServerUrl, forceNoGuest)
        window.OAuthRedirect = _.bind(@onRedirect, @)
        whereAmI = location.pathname
        if whereAmI[0] is '/'
          whereAmI = whereAmI.substr(1)

        window.currentLocation = whereAmI

        # Check for renewal
        # renewal = false
        # TODO: Figure out the case where I am logged in 
        # token expired, and I don't want to log in as guest silently.
        if forceNoGuest?
          # Show the dialog to get user permissions
          @trigger('session:show_dialog', {hidden:false})
        else          
          # We would like login to happen silently
          @trigger('session:show_dialog', {hidden:true})

    logout: (forceRemoteSession) ->
      deferred = $.Deferred()
      localStorage['access_token'] = ""
      localStorage['expires_in'] = ""
      localStorage['token_received'] = ""
      localStorage['refresh_token'] = ""
      @accessToken = ""
      # TODO: Below is a fairly hacky way of clearing out session cookies coming
      # from the api-server origin. 
      if forceRemoteSession is true 
        window.logoutRedirect = (hash) =>
          console.log("loggedOut")
          $('#logoutView').html("")
          @user = null
          @trigger('session:logged_out')
          deferred.resolve("Logged out")
        redirectUri = "#{window.location.protocol}//#{window.location.host}/logout_redirect.html"
        redirectUri = encodeURIComponent(redirectUri)
        url = "#{window.apiServerUrl}/logout?logout_callback=#{redirectUri}"
        tempString = "<iframe id='logoutIframe' src='#{url}' style='visibility:hidden;width:1px;height:1px;top:0px;left:0px;' />"
        # template = Handlebars.compile(tempString)
        # out = template({url: url})
        $('#logoutView').html(tempString)
      else
        @user = null
        deferred.resolve("Immediate resolve")
      
      deferred.promise()

    loggedIn: ->
      if @accessToken? and @accessToken isnt "" and @accessToken isnt "undefined"
        currentTime = new Date().getTime()
        expires_in = parseInt(localStorage['expires_in'])
        token_received = parseInt(localStorage['token_received'])
        if expires_in? and token_received? and currentTime < token_received + expires_in
          # still not expired
          true
        else
          false
      else
        false

    parseHash: (hash) ->
      params = {}
      queryString = hash.substring(1)
      regex = /([^&=]+)=([^&]*)/g
      while (m = regex.exec(queryString)) 
        params[decodeURIComponent(m[1])] = decodeURIComponent(m[2])
      params

    onRedirect: (hash) ->
      params = @parseHash(hash)
      console.log("Redirected with params #{hash}")
      if params['access_token']
        @accessToken = params['access_token']
        localStorage['access_token'] = @accessToken
        localStorage['expires_in'] = params['expires_in'] * 1000 # Store in ms
        localStorage['token_received'] = new Date().getTime()
        localStorage['refresh_token'] = params['refresh_token']
        @finishLogin()
      else
        @onError(params)

    onError:(params) ->
      alert("Error!")

    finishLogin: ->
      @user = new User()
      @user.fetch()
      .done (data, textStatus, jqXHR) =>
        localStorage['guest'] = @user.get('guest')
        @trigger('session:logged_in')
      .fail (jqXHR, textStatus, errorThrown) ->
        console.log("Error creating user #{textStatus}")

    setupAuthUrl: (authServer, forceNoGuest) ->
      authUrl = "#{authServer}/oauth/authorize" 
      redirectUri = "#{window.location.protocol}//#{window.location.host}/redirect.html"
      redirectUri = encodeURIComponent(redirectUri)
      if forceNoGuest
        guestParam = "force_no_guest=true&"
      else
        guestParam = ""
      "#{authUrl}?#{guestParam}client_id=#{@appId}&redirect_uri=#{redirectUri}&response_type=token"   


  Session
