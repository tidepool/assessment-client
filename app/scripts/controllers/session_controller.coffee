define [
  'jquery'
  'underscore'
  'Backbone'
  'Handlebars'
  'models/user'
],
(
  $
  _
  Backbone
  Handlebars
  User
) ->

  _me = 'controllers/session_controller'
  _authUrlSuffix = '/oauth/authorize'

  SessionController = ->
    initialize: (appCoreInstance) ->
      @app = appCoreInstance
      @_apiServer = @app.cfg.apiServer
      @_authUrl = "#{@_apiServer}#{_authUrlSuffix}"
      @appId = @app.cfg.appId
      @appSecret = @app.cfg.appSecret
      @accessToken = localStorage['access_token']
      @transferOwnerFlag = false
      $.ajaxSetup
        type: 'POST',
        timeout: 5000
        headers:  
          'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') 
          'Accept': 'application/json'
        dataType: 'json'
        beforeSend: (jqXHR, options) =>
          if @loggedIn()
            tokenHeader = "Bearer #{@accessToken}"
            jqXHR.setRequestHeader('Authorization', tokenHeader)

    loginAsGuest: ->
      @login('guest', '')

    loginAsCurrent: ->
      @login('current', '')

    login: (email, password) ->
      deferred = $.Deferred()
      if @isValid({email: email, password: password}) or (email is 'guest') or (email is 'current')
        console.log "#{_me}.login() isValid"
        if @loggedIn()
          @finishLogin()
          .done =>
            deferred.resolve("Success")
          .fail =>
            deferred.reject("Cannot get user info")
        else
          $.ajax
            url: @_authUrl
            type: 'POST'
            data:
              grant_type: "password"
              response_type: "password"
              email: email
              password: password
              client_id: @appId
              client_secret: @appSecret
          .done (data, textStatus, jqXHR) =>
            console.log "Successful Login"
            @accessToken = data['access_token']
            @persistLocally data
            @finishLogin()
            .done  =>
              deferred.resolve "Success"
            .fail  =>
              deferred.reject "Cannot get user info"
          .fail (jqXHR, textStatus, errorThrown) =>
            console.log "Unsuccesful Login"
            deferred.reject(textStatus)
      else
        console.log "#{_me}.login() !isValid"
        deferred.reject(@validationError.message)

      deferred.promise()

    signup: (email, password, passwordConfirm) ->
      deferred = $.Deferred()

      if not @isValid({email: email, password: password, passwordConfirm: passwordConfirm})
        deferred.reject(@validationError.message)
      else
        user = new User({email: email, password: password, passwordConfirm: passwordConfirm})
        user.save()
        .done (data, textStatus, jqXHR) =>
          console.log("User successfully created.")
          @login(email, password)
          .done =>
            console.log("User logged in")
            deferred.resolve("User logged in")
          .fail =>
            console.log("User could not log in")
            deferred.reject("User could not log in")
        .fail (jqXHR, textStatus, errorThrown) =>
          console.log("User can not be created.")
          deferred.reject(jqXHR.response)

      deferred.promise()

    isValid: (attrs) ->
      @validationError = @validate(attrs)
      if @validationError?
        return false
      else
        return true

    validate: (attrs) ->
      # From http://stackoverflow.com/a/46181/11236
      emailRegex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/

      if attrs.email? and not emailRegex.test(attrs.email)
        return {
          message: "Invalid email format."
        }
      if attrs.password? and (attrs.password.length < 8) 
        return {
          message: "Password should be greater than 8 characters."
        }
      if attrs.passwordConfirm? and attrs.password isnt attrs.passwordConfirm
        return {
          message: "Passwords do not match."
        }

      return null

    persistLocally: (data) ->
      localStorage['access_token'] = data['access_token']
      localStorage['expires_in'] = data['expires_in'] * 1000 # Store in ms
      localStorage['token_received'] = new Date().getTime()
      localStorage['refresh_token'] = data['refresh_token']

    logout: ->
      @clearOutLocalStorage()
      @app.trigger('session:logout_success')

    clearOutLocalStorage: ->
      delete localStorage['access_token']
      delete localStorage['expires_in']
      delete localStorage['token_received']
      delete localStorage['refresh_token'] 
      @accessToken = null
     
    loggedIn: ->
      if @accessToken? and @accessToken isnt "" and @accessToken isnt "undefined"
        currentTime = new Date().getTime()
        expires_in = parseInt(localStorage['expires_in'])
        token_received = parseInt(localStorage['token_received'])
        if expires_in? and token_received? and currentTime < token_received + expires_in
          # still not expired
          return true
        else
          return false
      else
        return false

    loginUsingOauth: (provider, popupWindowSize) ->
      # Inspired by: https://github.com/ptnplanet/backbone-oauth
      # Popup a Window to let the providers (Facebook, Twitter...) show their login UI
      left = window.screenLeft + 50 
      top = window.screenTop + 50
      width = popupWindowSize.width
      height = popupWindowSize.height
      window.OAuthRedirect = _.bind(@onRedirect, @)
      window.open(@setupAuthUrl(provider), "Login", "width=#{width}, height=#{height}, left=#{left}, top=#{top}, menubar=no")

    # authorizeThrough: facebook, twitter or fitbit
    setupAuthUrl: (authorizeThrough) ->
      redirectUri = encodeURIComponent "#{window.location.protocol}//#{window.location.host}/redirect.html"
      authorize_param = "authorize_through=#{authorizeThrough}&"
      url = "#{@_authUrl}?#{authorize_param}client_id=#{@appId}&redirect_uri=#{redirectUri}&response_type=token"
      console.log url
      url

    parseHash: (hash) ->
      params = {}
      queryString = hash.substring(1)
      regex = /([^&=]+)=([^&]*)/g
      while (m = regex.exec(queryString)) 
        params[decodeURIComponent(m[1])] = decodeURIComponent(m[2])
      params

    # Called as a global object by the opened window
    onRedirect: (hash, location) ->
      params = @parseHash(hash)
      console.log("Redirected with params #{params['access_token']}, hash #{hash}")
      if params['access_token']
        @accessToken = params['access_token']
        @persistLocally(params)
        @finishLogin()
      else
        console.log("Odd Error, no token received but redirected")
        @app.trigger('session:login_fail')

    finishLogin: ->
      deferred = $.Deferred()
      params = {}
      if @user? and @user.isGuest
        guestId = @user.get('id')
        params = { guestId: guestId }

      @user = new User({id: 'finish_login'})
      @user.fetch
        data: params
      .done (data, textStatus, jqXHR) =>
        @app.trigger('session:login_success')
        deferred.resolve(jqXHR.response)
      .fail (jqXHR, textStatus, errorThrown) =>
        console.log("Error creating user #{textStatus}")
        @app.trigger('session:login_fail')
        deferred.reject(textStatus)
      deferred.promise()

    getUserInfo: ->
      deferred = $.Deferred()
      if @user?
        deferred.resolve("Already have user info")
      else
        @user = new User({id: '-'})
        @user.fetch()
        .done (data, textStatus, jqXHR) =>
          # localStorage['guest'] = @user.get('guest')
          deferred.resolve(jqXHR.response)
        .fail (jqXHR, textStatus, errorThrown) ->
          console.log("Error creating user #{textStatus}")
          deferred.reject(textStatus)
      deferred.promise()

  SessionController
