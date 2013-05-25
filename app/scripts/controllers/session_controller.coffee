define [
  'jquery'
  'underscore'
  'backbone'
  'Handlebars'
],
(
  $
  _
  Backbone
  Handlebars
) ->

  _me = 'controllers/session_controller'
  _authUrlSuffix = '/oauth/authorize'
  _msgLoginSuccess = "Logged in successfully."
  _msgLoginError = 'Unable to log in.'
  _msgUserInfoSuccess = "Got user info successfully."
  _msgUserInfoError = 'Unable to get user info.'


  # ----------------------------------------------- Constructor
  SessionController = (appCoreInstance) ->
    @app = appCoreInstance
    @user = @app.user
    @_authUrl = "#{@app.cfg.apiServer}#{_authUrlSuffix}"
    @accessToken = localStorage['access_token']
    $.ajaxSetup
      type: 'POST',
      timeout: 5000
      headers:
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
        'Accept': 'application/json'
      dataType: 'json'
      beforeSend: (jqXHR, options) =>
        if @_hasCurrentToken()
          tokenHeader = "Bearer #{@accessToken}"
          jqXHR.setRequestHeader('Authorization', tokenHeader)

    @_fetchAuthedUser() # Attempt to get the current user by default.
    @ # Constructors return `this`


  # ----------------------------------------------- Prototype
  SessionController.prototype =

    signIn: (email, password) ->
      deferred = $.Deferred()
      if @isValid({email: email, password: password}) or (email is 'guest') or (email is 'current')
        console.log "#{_me}.signIn() isValid"
        if @_hasCurrentToken()
          @_fetchAuthedUser()
          .done ->
            deferred.resolve _msgUserInfoSuccess
          .fail ->
            deferred.reject _msgUserInfoError
        else
          $.ajax
            url: @_authUrl
            type: 'POST'
            data:
              grant_type: "password"
              response_type: "password"
              email: email
              password: password
              client_id: @app.cfg.appId
              client_secret: @app.cfg.appSecret
          .done(@_ajaxAuthSuccess.bind @)
          .fail(@_ajaxAuthFail.bind @)
      else
        deferred.reject(@validationError.message)
      deferred.promise()

    register: (email, password, passwordConfirm) ->
      deferred = $.Deferred()
      if not @isValid({email: email, password: password, passwordConfirm: passwordConfirm})
        deferred.reject(@validationError.message)
      else
        user = new User({email: email, password: password, passwordConfirm: passwordConfirm})
        user.save()
        .done (data, textStatus, jqXHR) =>
          console.log "#{_me}.register().done()"
          @signIn(email, password)
          .done =>
            console.log "#{_me}.register().done().signIn().done()"
            deferred.resolve _msgLoginSuccess
          .fail =>
            console.log "#{_me}.register().done().signIn().fail()"
            deferred.reject _msgLoginError
        .fail (jqXHR, textStatus, errorThrown) ->
          console.log "#{_me}.register().fail()"
          deferred.reject(jqXHR.response)
      deferred.promise()

    # TODO: move property validation into the user model
    isValid: (attrs) ->
      @validationError = @validate(attrs)
      if @validationError?
        return false
      else
        return true

    validate: (attrs) ->
      # From http://stackoverflow.com/a/46181/11236
      #emailRegex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/

      # type=email handles client side validation for now
#      if attrs.email? and not emailRegex.test(attrs.email)
#        return {
#          message: "Invalid email format."
#        }
      if attrs.password? and (attrs.password.length < 8) 
        return {
          message: "Password should be greater than 8 characters."
        }
      if attrs.passwordConfirm? and attrs.password isnt attrs.passwordConfirm
        return {
          message: "Passwords do not match."
        }
      return null


    # ---------------------------------------------- Depreciated Methods
    # TODO: Have other modules get user info from the user model instead.
    getUserInfo: ->
      deferred = $.Deferred()
      @user.id = '-'
      @user.fetch()
      .done (data, textStatus, jqXHR) =>
        deferred.resolve(jqXHR.response)
      .fail (jqXHR, textStatus, errorThrown) ->
        deferred.reject(textStatus)
      deferred.promise()


    # ---------------------------------------------- Callbacks
    _ajaxAuthSuccess: (data) ->
      @app.cfg.debug && console.log "#{_me}.signIn().done()"
      @accessToken = data.access_token
      @_persistLocally data
      @app.trigger('session:auth_success')
      @_fetchAuthedUser()
        .done  ->
          @app.cfg.debug && console.log "#{_me}._ajaxAuthSuccess._fetchAuthedUser().done()"
          #deferred.resolve _msgUserInfoSuccess
        .fail  ->
          @app.cfg.debug && console.log "#{_me}._ajaxAuthSuccess._fetchAuthedUser().fail()"
          #deferred.reject _msgUserInfoError

    _ajaxAuthFail: (jqXHR, textStatus, errorThrown) ->
      @app.cfg.debug && console.log "#{_me}._ajaxAuthFail()"
      @app.trigger('session:auth_fail')
      #deferred.reject(textStatus)


    # ---------------------------------------------- Private Login Helpers
    _hasCurrentToken: ->
      if @accessToken?.length #and @accessToken isnt "" and @accessToken isnt "undefined"
        currentTime = new Date().getTime()
        expires_in = parseInt(localStorage['expires_in'])
        token_received = parseInt(localStorage['token_received'])
        if expires_in? and token_received? and currentTime < token_received + expires_in
          curToken = true
      curToken

    _fetchAuthedUser: ->
      return unless @_hasCurrentToken()
      deferred = $.Deferred()
      @user.id = 'finish_login'
      @user.fetch
        data:
          guestId = @user.get('id') if @user.isGuest()
      .done (data, textStatus, jqXHR) ->
        deferred.resolve(jqXHR.response)
      .fail (jqXHR, textStatus, errorThrown) =>
        console.log("Error creating user #{textStatus}")
        @app.trigger('session:login_fail')
        deferred.reject(textStatus)
      deferred.promise()


    # ---------------------------------------------- Private Utility Methods
    _clearOutLocalStorage: ->
      delete localStorage['access_token']
      delete localStorage['expires_in']
      delete localStorage['token_received']
      delete localStorage['refresh_token']
      @accessToken = null

    # authorizeThrough: facebook, twitter or fitbit
    _buildExternalServiceUrl: (authorizeThrough) ->
      redirectUri = encodeURIComponent "#{window.location.protocol}//#{window.location.host}/redirect.html"
      authorize_param = "authorize_through=#{authorizeThrough}&"
      url = "#{@_authUrl}?#{authorize_param}client_id=#{@app.cfg.appId}&redirect_uri=#{redirectUri}&response_type=token"
      url

    _parseHash: (hash) ->
      params = {}
      queryString = hash.substring(1)
      regex = /([^&=]+)=([^&]*)/g
      while (m = regex.exec(queryString))
        params[decodeURIComponent(m[1])] = decodeURIComponent(m[2])
      params

    _persistLocally: (data) ->
      localStorage['access_token'] = data['access_token']
      localStorage['expires_in'] = data['expires_in'] * 1000 # Store in ms
      localStorage['token_received'] = new Date().getTime()
      localStorage['refresh_token'] = data['refresh_token']


    # ------------------------------------------------ Public API
    logInAsGuest: -> @signIn('guest', '')

    loginUsingOauth: (provider, popupWindowSize) ->
      # Inspired by: https://github.com/ptnplanet/backbone-oauth
      # Popup a Window to let the providers (Facebook, Twitter...) show their login UI
      left = window.screenLeft + 50
      top = window.screenTop + 50
      width = popupWindowSize.width
      height = popupWindowSize.height
      window.OAuthRedirect = _.bind(@externalAuthServiceCallback, @)
      window.open(@_buildExternalServiceUrl(provider), "Login", "width=#{width}, height=#{height}, left=#{left}, top=#{top}, menubar=no")

    logOut: ->
      @_clearOutLocalStorage()
      @user.clear()
      @app.trigger('session:logout_success')

    # Called as a global object by the opened window
    externalAuthServiceCallback: (hash, location) ->
      console.log "#{_me}.externalAuthServiceCallback()"
      params = @_parseHash hash
      console.log("Redirected with token #{params['access_token']}, hash #{hash}")
      if params['access_token']
        @accessToken = params['access_token']
        @_persistLocally params
        @_fetchAuthedUser()
      else
        console.log 'Odd Error, no token received but redirected'
        @app.trigger 'session:login_fail'




  SessionController
