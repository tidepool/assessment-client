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
  _authRedirectSuffix = '/auth/client_redirect'


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
          deferred.resolve("Success", data)
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
#          console.log token: data.access_token
          @_persistLocally data
          @user.reset().fetch()
          .done (data, textStatus, jqXHR) =>
            @options.app.analytics.track 'session', 'Successful Sign In'
            deferred.resolve("Success", data)
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
        .done (status, resp) =>
          if resp.data.guest
            @options.app.analytics.track 'session', 'Successful Guest Registration'
          else
            @options.app.analytics.trackKeyMetric 'session', "Successful User Registration"
          deferred.resolve("Success")
        .fail =>
          @options.app.analytics.track 'session', 'Failed Registration'
          deferred.reject("Fail")
      deferred.promise()


    # ---------------------------------------------- Callbacks
    onUserSync: (model) ->
#      console.log "#{_me}.onUserSync()"
      #readableUserId = if model.isGuest() then model.attributes.id else model.attributes.email
      #@options.app.analytics.setUserIdentity readableUserId

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

    # authorizeThrough: facebook, twitter or fitbit
    _buildOauthUrl: (provider) ->
      # If the current logged-in user is guest, we need to pass this for potential mutation to new user
      data =
        redirect_uri: @cfg.apiServer + _authRedirectSuffix
        client_uri: 'http://assessments-front.dev/#logInUsingToken/' #encodeURIComponent "#{window.location.protocol}//#{window.location.host}/redirect.html"
        provider: provider
        client_id: @cfg.appId
        response_type: 'token'
      data.guest_id = @user.get('id') if @user.get('guest')
      console.log oauthUrlData: data
      url = "#{@_authUrl}?#{$.param data}"

#    _parseHash: (hash) ->
#      params = {}
#      queryString = hash.substring(1)
#      regex = /([^&=]+)=([^&]*)/g
#      while (m = regex.exec(queryString))
#        params[decodeURIComponent(m[1])] = decodeURIComponent(m[2])
#      params

    _persistLocally: (data) ->
      sessionStorage['access_token'] = data['access_token']
      sessionStorage['expires_in'] = if data['expires_in']? then data['expires_in'] * 1000 else null # Store in ms
      sessionStorage['token_received'] = new Date().getTime()
      sessionStorage['refresh_token'] = if data['refresh_token']? then data['refresh_token'] else null
      @


    # ------------------------------------------------ Public API
    logInAsGuest: ->
      deferred = $.Deferred()
      @user.set( guest: true )
      @register()
      .done ->
        deferred.resolve("Success")
      .fail ->
        deferred.reject("Fail")
      deferred.promise()

    oauth: (provider) ->
#      window.OAuthRedirect = _.bind(@externalAuthServiceCallback, @)
      console.log url:@_buildOauthUrl provider
      window.location.href = @_buildOauthUrl provider

    nuke: ->
      delete sessionStorage['access_token']
      delete sessionStorage['expires_in']
      delete sessionStorage['token_received']
      delete sessionStorage['refresh_token']
      delete sessionStorage['guest']
      @

    logOut: ->
      @nuke()
      @user.reset()
      @

    persistToken: (token) ->
      @_persistLocally access_token:token
      @

    # Called as a global object by the opened window
#    externalAuthServiceCallback: (hash, location) ->
#      params = @_parseHash hash
#      #console.log("Redirected with token #{params['access_token']}, hash #{hash}")
#      if params['access_token']
#        @logOut()
#        @_persistLocally params
#        @user.reset() # Reset to defaults. Defaults includes getting the token out of local storage, so this does a fetch with a user with an id `-` and an accessToken
#        @user.fetch()
#      else
#        console.log 'Odd Error, no token received but redirected'
#      @options.app.analytics.track 'session', 'Successful External Auth Login'


  SessionController





  


