define [
  'underscore'
  'backbone'
  'models/assessment'
],
(
  _
  Backbone
  Assessment
) ->

  _me = 'entities/user'

  User = Backbone.Model.extend

    # ----------------------------------------------------------- Backbone Methods
    urlRoot: "#{window.apiServerUrl}/api/v1/users"

    defaults: ->
      return {
        id: '-' # Convention to refer to the current user
        accessToken: localStorage['access_token']
      }

    initialize:  ->
      #@on 'all', (e) -> console.log "#{_me} event: #{e}"
      @on 'change:name', @_calculateNickname
      @on 'change:email', @_calculateNickname
      @on 'change:guest', @_calculateNickname
      @on 'error', @_onModelError
      @on 'change', (model, val) -> console.log model.attributes


    #http://backbonejs.org/#Model-validate
    validate: (attrs, options) ->
      return null if attrs.guest is true
      return 'The email address cannot be blank.' unless attrs.email 
      # Let's use default browser email validation for now
      #emailRegex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/ # From http://stackoverflow.com/a/46181/11236
      #return 'That doesn\'t look like a valid email address.' unless emailRegex.test attrs.email

      if options.validateProfile
        return 'The name must be filled in.' unless attrs.name
      else
        return 'The password cannot be blank.' unless attrs.password
        return 'The password should be 8 or more characters.' unless attrs.password.length >= 8

      # Register mode
      if attrs.loginType == 'register'
        return 'The confirm password field cannot be blank' unless attrs.passwordConfirm
        return 'The passwords should match' unless attrs.password is attrs.passwordConfirm
      return null # no validation errors


    # ----------------------------------------------------------- Private Helper Methods
    # If a nickname isn't specified, use the name or email field
    _calculateNickname: ->
      #console.log "#{_me}._calculateNickname()"
      nick = @get('name') || @get('email') if not @isGuest()
      @set
        nickname: nick,
        {silent: true}

    _clearOutLocalStorage: ->
      delete localStorage['access_token']
      delete localStorage['expires_in']
      delete localStorage['token_received']
      delete localStorage['refresh_token']
      delete localStorage['guest']


    # ----------------------------------------------------------- Callbacks
    _onModelError: (model, xhr, options) ->
      console.log "#{_me}._onModelError() xhr.statusText: #{xhr.statusText}"
      # Flush the local cache whenever we get a login exception from the server
      # TODO: replace with a more specific listener when the server throws 403s
      if xhr.status is 0
        @session?.logOut()


    # ----------------------------------------------------------- URL related Methods
    parseHash: (hash) ->
      params = {}
      queryString = hash.substring(1)
      regex = /([^&=]+)=([^&]*)/g
      while (m = regex.exec(queryString)) 
        params[decodeURIComponent(m[1])] = decodeURIComponent(m[2])
      params

    addAuthentication: (provider, popupWindowSize) ->
      left = window.screenLeft + 50 
      top = window.screenTop + 50
      width = popupWindowSize.width
      height = popupWindowSize.height
      window.addAuthRedirect = _.bind(@onAddAuthRedirect, @)
      window.open(@setupAddAuthUrl(provider), "Login", "width=#{width}, height=#{height}, left=#{left}, top=#{top}, menubar=no")

    setupAddAuthUrl: (provider) ->
      authUrl = "#{window.apiServerUrl}/auth/additional"
      redirectUri = "#{window.location.protocol}//#{window.location.host}/additional_redirect.html#"
      redirectUri = encodeURIComponent(redirectUri)
      provider_param = "provider=#{provider}&"
      "#{authUrl}?redirect_uri=#{redirectUri}&user_id=#{@get('id')}&provider=#{provider}"   

    onAddAuthRedirect: (hash, location) ->
      # http://assessments-front.dev/additional_redirect.html#user_id=113&provider=twitter 
      console.log("onAddAuthRedirect called with #{location} and hash #{hash}")
      params = @parseHash(hash)
      console.log("params are: #{params['user_id']} and #{params['provider']}")
      @trigger('user:authentication_added', params['provider'])


    # ----------------------------------------------------------- Public API
    isNew: -> ! @get('accessToken')

    createAssessment: (gameId)->
      curGame = new Assessment()
      if @isLoggedIn()
        curGame.create(gameId)
      else
        @session.logInAsGuest()
        .done =>
          curGame.create(gameId)
        .fail =>
          @trigger 'error:createAssessment'
          console.log "#{_me}.createAssessment.fail()"
      curGame

    isGuest: -> !! @get('guest')

    hasCurrentToken: ->
      curToken = false
      if @get('accessToken')?.length
        currentTime = new Date().getTime()
        expires_in = parseInt(localStorage['expires_in'])
        token_received = parseInt(localStorage['token_received'])
        if expires_in? and token_received? and currentTime < token_received + expires_in
          curToken = true
      #console.log "#{_me}.hasCurrentToken(): #{curToken}"
      curToken
    isLoggedIn: -> @hasCurrentToken()

    # Set the client version of the model back to as if it were new
    reset: -> @clear().set @defaults()

  User
