
define [
  'underscore'
  'backbone'
  'composite_views/perch'
  'scripts/views/user/login_dialog'
  'scripts/views/user/profile_dialog'
],
(
  _
  Backbone
  perch
  LoginDialog
  ProfileDialog
) ->

  _me = 'core/mediator'

  Me = Backbone.View.extend
    initialize: ->
      throw new Error('Need options.app') unless @options.app?
      perch.options.app = @options.app
      @_mediate()
    _mediate: ->
      @listenTo @options.app, 'session:showLogin', @_showLogin
      @listenTo @options.app, 'session:showRegister', @_showRegister
      @listenTo @options.app, 'session:showProfile', @_showProfile
      @listenTo @options.app, 'session:logOut', @_actionLogOut


    # ------------------------------------------------ Display command handlers
    _showLogin: ->
      loginDialog = new LoginDialog
        model: @options.app.user
        app: @options.app

    _showRegister: ->
      loginDialog = new LoginDialog
        model: @options.app.user
        app: @options.app
        register: true

    _showProfile: ->
      profileDialog = new ProfileDialog
        model: @options.app.user


    # ------------------------------------------------ Action command handlers
    _actionLogOut: ->
      @options.app.analytics.track 'session', 'Pressed Log Out'
      @options.app.session.logOut()


  Me


