define [
  'jquery',
  'Backbone',
  '../../models/user',
  "hbs!./login_dialog"], ($, Backbone, User, template) ->
  LoginDialog = Backbone.View.extend  
    initialize: (options) ->
      window.OAuthRedirect = @onRedirect
      @eventDispatcher = options.eventDispatcher
      @nextRoute = options.nextRoute
      @session = @model

    render: ->
      $(@el).html(template({authUrl: @session.authUrl}))
      this

    display: ->
      $("#logindialog").html(@render().el)

    close: ->
      $("#logindialog").html("")

    parseHash: (hash) ->
      params = {}
      queryString = hash.substring(1)
      regex = /([^&=]+)=([^&]*)/g
      while (m = regex.exec(queryString)) 
        params[decodeURIComponent(m[1])] = decodeURIComponent(m[2])
      params

    onRedirect: (hash) =>
      params = @parseHash(hash)

      if params['access_token']
        @session.accessToken = params['access_token']
        localStorage['access_token'] = @session.access_token
        @finishLogin()
      else
        @onError(params)

    onError:(params) =>
      alert("Error!")

    finishLogin: =>
      user = new User()
      user.fetch
        success: (model, response, options) =>
          @session.user = model
          Backbone.history.navigate(@nextRoute, true)
        error: (model, xhr, options) =>
          alert("Error!")

  LoginDialog