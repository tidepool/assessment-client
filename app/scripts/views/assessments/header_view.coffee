define [
  'jquery',
  'Backbone',
  'Handlebars',
  'routers/main_router',
  "text!./header_view.hbs",
  'bootstrap',
  'controllers/session_controller'], ($, Backbone, Handlebars, MainRouter, tempfile) ->
  HeaderView = Backbone.View.extend
    events:
      "click #login": "login",
      "click #logout": "logout"
      "click #profile": "showProfile"

    initialize: (options) ->
      @session = options.session
      
      @listenTo(@session, 'session:login_success', @loggedIn)
      @listenTo(@session, 'session:logout_success', @loggedOut)

    render: ->
      loggedIn = @session.loggedIn()
      template = Handlebars.compile(tempfile)

      @user = @session.user
      isRegisteredUser = true
      if @user?
        if @user.get('guest') is true
          userName = 'Guest'
          isRegisteredUser = false
        else
          userName = @user.get('email')
          if userName is undefined || userName is ""
            userName = @user.get('name')
      else
        userName = ""

      $(@el).html(template({ userName: userName, loggedIn: loggedIn, isRegisteredUser: isRegisteredUser } ))
      this

    loggedIn: ->
      @render()

    loggedOut: ->
      @render()

    login: (e) ->
      e.preventDefault()
      @trigger('command:login')

    logout: (e) ->
      e.preventDefault()
      @trigger('command:logout')
      @session.logout()

    showProfile: (e) ->
      e.preventDefault()
      @trigger('command:profile')
  
  HeaderView