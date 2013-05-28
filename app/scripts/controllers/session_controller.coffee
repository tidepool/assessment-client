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
    throw new Error('Need .user and .cfg to construct') unless options.user and options.cfg
    @user = options.user
    @cfg = options.cfg
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
    @_fetchAuthedUser()
    @ # Constructors return `this`


  # ----------------------------------------------- Prototype
  SessionController.prototype =
    signIn: ->
      console.log "#{_me}.signIn()"
      if @user.hasCurrentToken()
        @_fetchAuthedUser()
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
        .done( @_ajaxAuthSuccess.bind(@) )
        .fail (jqXHR, textStatus, errorThrown) =>
          console.log "#{_me}.signIn().ajax().fail()"
          @user.trigger 'error', @user, jqXHR

    register: ->
      @user.save()
      .done (data, textStatus, jqXHR) =>
        console.log "#{_me}.user.save().done()"
        @signIn()


    # ---------------------------------------------- Depreciated Methods
    # TODO: Have other modules get user info from the user model instead.
    getUserInfo: -> throw new Error ('Get user information from models/user or app.user instead')


    # ---------------------------------------------- Callbacks
    _ajaxAuthSuccess: (data) ->
      @cfg.debug && console.log "#{_me}.signIn().done()"
      @user.set 'accessToken', data.access_token
      @_persistLocally data
      @_fetchAuthedUser()


    # ---------------------------------------------- Private Login Helpers
    _fetchAuthedUser: ->
      return unless @user.hasCurrentToken()
      @user.id = 'finish_login'
      @user.fetch
        data:
          guestId = @user.get('id') if @user.isGuest()


    # ---------------------------------------------- Private Utility Methods
    _clearOutLocalStorage: ->
      delete localStorage['access_token']
      delete localStorage['expires_in']
      delete localStorage['token_received']
      delete localStorage['refresh_token']

    # authorizeThrough: facebook, twitter or fitbit
    _buildExternalServiceUrl: (authorizeThrough) ->
      redirectUri = encodeURIComponent "#{window.location.protocol}//#{window.location.host}/redirect.html"
      authorize_param = "authorize_through=#{authorizeThrough}&"
      url = "#{@_authUrl}?#{authorize_param}client_id=#{@cfg.appId}&redirect_uri=#{redirectUri}&response_type=token"
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

    # Called as a global object by the opened window
    externalAuthServiceCallback: (hash, location) ->
      console.log "#{_me}.externalAuthServiceCallback()"
      params = @_parseHash hash
      console.log("Redirected with token #{params['access_token']}, hash #{hash}")
      if params['access_token']
        @user.set 'accessToken', params['access_token']
        @_persistLocally params
        @_fetchAuthedUser()
      else
        console.log 'Odd Error, no token received but redirected'





  SessionController
