define [
  'underscore'
  'backbone'
],
(
  _
  Backbone
) ->

  _me = 'models/user'

  User = Backbone.Model.extend

    # ----------------------------------------------------------- Backbone Methods
    urlRoot: ->
      "#{window.apiServerUrl}/api/v1/users"

    defaults: ->
      return {
        accessToken: localStorage['access_token']
      }

    initialize:  ->
      #@on 'all', (e) -> console.log "#{_me} event: #{e}"
      @on 'change:name', @_calculateNickname
      @on 'change:email', @_calculateNickname
      @on 'error', @_onModelError

    #http://backbonejs.org/#Model-validate
    validate: (attrs, options) ->
      console.log "#{_me}.validate()"
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
      if @isNew()
        return 'The confirm password field cannot be blank' unless attrs.passwordConfirm
        return 'The passwords should match' unless attrs.password is attrs.passwordConfirm
      return null # no validation errors


    # ----------------------------------------------------------- Helper Methods
    # If a nickname isn't specified, use the name or email field
    _calculateNickname: ->
      console.log "#{_me}._calculateNickname()"
      nick = @get('name') || @get('email')
      @set
        nickname: nick,
        {silent: true}


    # ----------------------------------------------------------- Callbacks
    _onModelError: (model, xhr, options) ->
      console.log "#{_me}._onModelError()"


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
    isNew: -> @get('loginType') == 'register'
    isGuest: -> !! @get('guest')
    hasCurrentToken: ->
      if @get('accessToken')?.length #and @accessToken isnt "" and @accessToken isnt "undefined"
        currentTime = new Date().getTime()
        expires_in = parseInt(localStorage['expires_in'])
        token_received = parseInt(localStorage['token_received'])
        if expires_in? and token_received? and currentTime < token_received + expires_in
          curToken = true
      curToken


  User
