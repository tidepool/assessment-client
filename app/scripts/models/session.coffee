define [
  'jquery',
  'underscore',
  'Backbone',
  'models/user'], ($, _, Backbone, User) ->
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
    login: (guestOk) ->
      # check if already logged-in
      if @loggedIn()
        @finishLogin()
      else 
        @authUrl = @setupAuthUrl(window.apiServerUrl, guestOk)
        window.OAuthRedirect = _.bind(@onRedirect, @)

        # Check for renewal
        renewal = false

        if guestOk? || renewal?
          # We would like login to happen silently
          @trigger('session:show_dialog', {hidden:true})
        else
          # Show the dialog to get user permissions
          @trigger('session:show_dialog', {hidden:false})

    logout: ->
      localStorage['access_token'] = ""

    loggedIn: ->
      if @accessToken? and @accessToken isnt "" and @accessToken isnt "undefined"
        currentTime = new Date().getTime()
        expires_in = localStorage['expires_in']
        token_received = localStorage['token_received']
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
      console.log("redirected to here")
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
      user = new User()
      user.fetch
        success: (model, response, options) =>
          @user = model
          @trigger('session:logged_in')
        error: (model, xhr, options) =>
          alert("Error!")

    setupAuthUrl: (authServer, guestOk) ->
      authUrl = "#{authServer}/oauth/authorize" 
      redirectUri = "#{window.location.protocol}//#{window.location.host}/redirect.html"
      redirectUri = encodeURIComponent(redirectUri)
      if guestOk
        guestParam = "guest=true&"
      else
        guestParam = ""
      "#{authUrl}?#{guestParam}client_id=#{@appId}&redirect_uri=#{redirectUri}&response_type=token"   

  Session
