define [
  'underscore'
  'classes/model'
  'entities/my/games'
],
(
  _
  Model
  Game
) ->

  _me = 'entities/user'

  User = Model.extend

    # ----------------------------------------------------------- Backbone Methods
    urlRoot: "#{window.apiServerUrl}/api/v1/users"

    defaults: ->
      return {
        id: '-' # Convention to refer to the current user
        accessToken: sessionStorage['access_token']
      }

    initialize: ->
#      @on 'all', (e, model) -> console.log "#{_me} event: #{e}"
#      @on 'change', (model, val) -> console.log model.attributes
      @on 'change:name', @_calculateNickname
      @on 'change:email', @_calculateNickname
      @on 'change:guest', @_calculateNickname
      @on 'change:age', @_calculateDOB
      @on 'change:date_of_birth', @_calculateAge
      @on 'error', @_onModelError
      @on 'invalid', @_onModelInvalid

    validate: (attrs, options) ->
      return null if attrs.guest is true # skip validation

      if options.login or options.register
        return 'The email address cannot be blank.' unless attrs.email
        return 'The password cannot be blank.' unless attrs.password
        return 'The password should be 8 or more characters.' unless attrs.password.length >= 8
      if options.register
        return 'The confirm password field cannot be blank' unless attrs.passwordConfirm
        return 'The passwords should match' unless attrs.password is attrs.passwordConfirm
      if options.profile
#        return 'The name must be filled in.' unless attrs.name
        return 'The email address cannot be blank.' unless attrs.email

      return null # no validation errors


    # ----------------------------------------------------------- Private Helper Methods
    # If a nickname isn't specified, use the name or email field
    _calculateNickname: ->
      #console.log "#{_me}._calculateNickname()"
      nick = @get('name') || @get('email') if not @isGuest()
      @set
        nickname: nick,
        {silent: true}

    _calculateDOB: (model, val) ->
      @set is_dob_by_age: true
      fuzzyDOB = (new Date()).getFullYear() - val
      @set date_of_birth: "#{fuzzyDOB}-01-01"
#      console.log fuzzyDOB:fuzzyDOB
#      console.log thus:@toJSON()

    _calculateAge: (model, val) ->
      year = val.split('-')[0]
      unless year? and year.length is 4
        console.error "Can't find the year in DOB: #{val}"
      age = (new Date()).getFullYear() - year
#      console.log
#        val:val
#        year:year
#        age:age
      @set age:age

    _nuke: ->
      delete sessionStorage['access_token']
      delete sessionStorage['expires_in']
      delete sessionStorage['token_received']
      delete sessionStorage['refresh_token']
      delete sessionStorage['guest']
      @

    _tokenGutCheck: ->
      10 < @get('accessToken')?.length < 9999


    # ----------------------------------------------------------- Callbacks
    _onModelError: (model, xhr, options) ->
      console.error xhr.responseJSON?.status?.message
      console.log model:model , xhr: xhr
      # Flush the local cache whenever we get a login exception from the server
      if xhr.status is 401
        @session?.logOut()

    _onModelInvalid: (model, error) ->
      console.log "#{_me}._onModelInvalid(): #{error}"


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
      # additional_redirect.html#user_id=113&provider=twitter
      console.log("onAddAuthRedirect called with #{location} and hash #{hash}")
      params = @parseHash(hash)
      console.log("params are: #{params['user_id']} and #{params['provider']}")
      @trigger('user:authentication_added', params['provider'])


    # ----------------------------------------------------------- Public API
    isNew: -> ! @get('accessToken')

    createGame: (gameDefId) ->
      curGame = new Game()
      if @isLoggedIn()
        curGame.create(gameDefId)
      else
        @session.logInAsGuest()
        .done =>
          curGame.create(gameDefId)
        .fail =>
          @trigger 'error:createGame'
          console.log "#{_me}.createGame.fail()"
      curGame

    isGuest: -> !! @get('guest')

    hasCurrentToken: ->
      curToken = false
      if @_tokenGutCheck()
        currentTime = new Date().getTime()
        expires_in = parseInt(sessionStorage['expires_in'])
        token_received = parseInt(sessionStorage['token_received'])
        if expires_in? and token_received? and currentTime < token_received + expires_in # Token is valid if not expired
          curToken = true
        else if not expires_in # Token is valid if no expiration date was set
          curToken = true
        else
          @_nuke()
      curToken

    isLoggedIn: -> @hasCurrentToken()

    # Set the client version of the model back to as if it were new
    # If the optional token is passed in, reset the user to that
    reset: (token) ->
      @session.nuke().persistToken token if token?
      @clear().set @defaults()
      @




  User
