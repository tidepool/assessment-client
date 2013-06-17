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


  # ----------------------------------------------- Constructor
  SessionController = (options) ->
    @options = options
    @user = @options.app.user
    @cfg = @options.app.cfg
    _.bindAll @, 'onUserSync'
    @user.on 'sync', @onUserSync
    @_authUrl = "#{@cfg.apiServer}#{_authUrlSuffix}"
    $.ajaxSetup
      type: 'POST',
      timeout: 5000
      headers:
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
        'Accept': 'application/json'
      dataType: 'json'
      beforeSend: (jqXHR, options) =>
        if @user.hasCurrentToken()
          tokenHeader = "Bearer #{@user.get('accessToken')}"
          jqXHR.setRequestHeader('Authorization', tokenHeader)
    @user.fetch() if @user.hasCurrentToken()
    @ # Constructors return `this`


  # ----------------------------------------------- Prototype
  SessionController.prototype =
    signIn: ->
      deferred = $.Deferred()
      if @user.hasCurrentToken() and not @user.isGuest()
        @user.fetch()
        .done (data, textStatus, jqXHR) =>
          deferred.resolve("Success")
        .fail (jqXHR, textStatus, errorThrown) =>
          deferred.reject(textStatus)
      else
        $.ajax
          url: @_authUrl
          type: 'POST'
          data:
            grant_type: "password"
            response_type: "password"
            email: @user.get 'email'
            password: @user.get 'password'
            client_id: @cfg.appId
            client_secret: @cfg.appSecret
        .done (data, textStatus, jqXHR) =>
          console.log
            token: data.access_token
          @_persistLocally data
          @user.reset().fetch()
          .done (data, textStatus, jqXHR) =>
            @options.app.analytics.track 'session', 'Successful Sign In'
            deferred.resolve("Success")
          .fail (jqXHR, textStatus, errorThrown) =>
            @options.app.analytics.track 'session', 'Failed Sign In'
            deferred.reject(textStatus)
        .fail (jqXHR, textStatus, errorThrown) =>
          #console.log "#{_me}.signIn().ajax().fail()"
          @user.trigger 'error', @user, jqXHR
          deferred.reject(textStatus)
      deferred.promise()

    register: ->
      deferred = $.Deferred()
      @user.save()
      .done (data, textStatus, jqXHR) =>
        #console.log "#{_me}.user.save().done()"
        @signIn()
        .done =>
          @options.app.analytics.track 'session', 'Successful Registration'
          deferred.resolve("Success")
        .fail =>
          @options.app.analytics.track 'session', 'Failed Registration'
          deferred.reject("Fail")
      deferred.promise()


    # ---------------------------------------------- Callbacks
    onUserSync: (model) ->
      readableUserId = if model.isGuest() then model.attributes.id else model.attributes.email
      @options.app.analytics.setUserIdentity readableUserId

    # _ajaxAuthSuccess: (data) ->
    #   #@cfg.debug && console.log "#{_me}._ajaxAuthSuccess()"
    #   @user.set 'accessToken', data.access_token
    #   @_persistLocally data
    #   @_fetchAuthedUser()


    # ---------------------------------------------- Private Login Helpers
    # _fetchAuthedUser: ->
    #   return unless @user.hasCurrentToken()
    #   @user.fetch
        # data:
        #   guestId = @user.get('id') if @user.isGuest()


    # ---------------------------------------------- Private Utility Methods
    _clearOutLocalStorage: ->
      delete localStorage['access_token']
      delete localStorage['expires_in']
      delete localStorage['token_received']
      delete localStorage['refresh_token']
      delete localStorage['guest']

    # authorizeThrough: facebook, twitter or fitbit
    _buildExternalServiceUrl: (authorizeThrough) ->
      redirectUri = encodeURIComponent "#{window.location.protocol}//#{window.location.host}/redirect.html"
      authorize_param = "provider=#{authorizeThrough}&"
      if @user.get('guest')
        # If the current logged-in user is guest, we need to pass this for potential mutation to new user
        guest_param = "guest_id=#{@user.get('id')}&"
      else
        guest_param = ""
      url = "#{@_authUrl}?#{authorize_param}#{guest_param}client_id=#{@cfg.appId}&redirect_uri=#{redirectUri}&response_type=token"
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
    logInAsGuest: ->
      # @user.set( email: 'guest' )
      deferred = $.Deferred()
      @user.set( guest: true )
      @register()
      .done ->
        deferred.resolve("Success")
      .fail ->
        deferred.reject("Fail")
      deferred.promise()

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
      @user.reset()

    # Called as a global object by the opened window
    externalAuthServiceCallback: (hash, location) ->
      params = @_parseHash hash
      #console.log("Redirected with token #{params['access_token']}, hash #{hash}")
      if params['access_token']
        @logOut()
        @_persistLocally params
        @user.reset() # Reset to defaults. Defaults includes getting the token out of local storage, so this does a fetch with a user with an id `-` and an accessToken
        @user.fetch()
      else
        console.log 'Odd Error, no token received but redirected'
      @options.app.analytics.track 'session', 'Successful External Auth Login'





  SessionController
