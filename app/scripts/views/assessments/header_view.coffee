define [
  'jquery',
  'Backbone',
  'Handlebars',
  'user/login_dialog',
  'user/profile_dialog',
  'routers/main_router',
  "text!./header_view.hbs",
  'bootstrap',
  'controllers/session_controller'], ($, Backbone, Handlebars, LoginDialog, ProfileDialog, MainRouter, tempfile) ->
  HeaderView = Backbone.View.extend
    events:
      "click #login": "login",
      "click #logout": "logout"
      "click #profile": "showProfile"

    initialize: (options) ->
      @session = options.session
      @user = @session.user
      @listenTo(@session, 'session:login_success', @loggedIn)
      @listenTo(@session, 'session:logout_success', @loggedOut)

    render: ->
      loggedIn = @session.loggedIn()
      template = Handlebars.compile(tempfile)
      if @user?
        if @user.get('guest') is true
          userName = 'Guest'
        else
          userName = @user.get('email')
          if userName is undefined || userName is ""
            userName = @user.get('name')
      else
        userName = "Logging In..."

      $(@el).html(template({ userName: userName, loggedIn: loggedIn } ))
      this

    loggedIn: ->
      @user = @session.user
      @render()

    loggedOut: ->
      @user = null
      @render()

    login: (e) ->
      e.preventDefault()
      loginDialog = new LoginDialog({session: @session})
      $('#content').html(loginDialog.render().el)

    logout: (e) ->
      e.preventDefault()
      @session.logout()

    showProfile: (e) ->
      e.preventDefault()
      profileDialog = new ProfileDialog({session: @user})
      $('#content').html(profileDialog.render().el)
  
  HeaderView