define [
  'jquery',
  'underscore',
  'Backbone',
  'Handlebars',
  'models/user'], ($, _, Backbone, Handlebars, User) ->
  SessionController = ->
    initialize: (options) ->
      _.extend(@, Backbone.Events)
      @apiServer = options["apiServer"]
      @appId = options["appId"] 
      @appSecret = options["appSecret"]
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

    loginAsGuest: ->
      @login('guest', '')

    login: (email, password) ->
      deferred = $.Deferred()
      
      if @isValid({email: email, password: password}) or email is 'guest'
        if @loggedIn()
          @finishLogin()
          .done =>
            deferred.resolve("Success")
          .fail =>
            deferred.reject("Cannot get user info")
        else
          authUrl = "#{@apiServer}/oauth/authorize" 
          $.ajax
            url: authUrl
            type: 'POST'
            data:
              grant_type: "password"
              response_type: "password"
              email: email
              password: password
              client_id: @appId
              client_secret: @appSecret
          .done (data, textStatus, jqXHR) =>
            console.log("Successful Login")
            @accessToken = data['access_token']
            @persistLocally(data)
            @finishLogin()
            .done  =>
              deferred.resolve("Success")
            .fail  =>
              deferred.reject("Cannot get user info")
          .fail (jqXHR, textStatus, errorThrown) =>
            console.log("Unsuccesful Login")
            deferred.reject(textStatus)
      else
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

    logout: (forceRemoteSession) ->
      delete localStorage['access_token']
      delete localStorage['expires_in']
      delete localStorage['token_received']
      delete localStorage['refresh_token']
      @accessToken = null
      @user = null
      @assessment = null
      @result = null
      @trigger('session:logout_success')

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

    loginUsingOauth: (provider, popupWindowSize) ->
      # Inspired by: https://github.com/ptnplanet/backbone-oauth
      # Popup a Window to let the providers (Facebook, Twitter...) show their login UI

      left = window.screenLeft + 50 
      top = window.screenTop + 50
      width = popupWindowSize.width
      height = popupWindowSize.height
      window.OAuthRedirect = _.bind(@onRedirect, @)
      window.open(@setupAuthUrl(provider), "Login", "width=#{width}, height=#{height}, left=#{left}, top=#{top}, menubar=no")

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
        @persistLocally(params)
        @finishLogin()
      else
        console.log("Odd Error, no token received but redirected")
        @trigger('session:login_fail')

    finishLogin: ->
      deferred = $.Deferred()
      if @user?
        deferred.resolve("Already logged in")
      else
        @user = new User({id: '-'})
        @user.fetch()
        .done (data, textStatus, jqXHR) =>
          localStorage['guest'] = @user.get('guest')
          @trigger('session:login_success')
          deferred.resolve(jqXHR.response)
        .fail (jqXHR, textStatus, errorThrown) ->
          console.log("Error creating user #{textStatus}")
          deferred.reject(textStatus)
          @trigger('session:login_fail')

      deferred.promise()

    setupAuthUrl: (authorize_through) ->
      authUrl = "#{@apiServer}/oauth/authorize" 
      redirectUri = "#{window.location.protocol}//#{window.location.host}/redirect.html"
      redirectUri = encodeURIComponent(redirectUri)
      authorize_param = "authorize_through=#{authorize_through}&"
      "#{authUrl}?#{authorize_param}client_id=#{@appId}&redirect_uri=#{redirectUri}&response_type=token"   

  SessionController