
define [
  'underscore'
  'backbone'
  'scripts/views/user/login_dialog'
  'scripts/views/user/profile_dialog'
],
(
  _
  Backbone
  LoginDialog
  ProfileDialog
) ->

  _me = 'core/mediator'

  Me = Backbone.View.extend
    initialize: ->
      throw new Error('Need options.app') unless @options.app?
      @_mediate()
    _mediate: ->
      @listenTo @options.app, 'session:showLogin', @_showLogin
      @listenTo @options.app, 'session:showProfile', @_showProfile
      @listenTo @options.app, 'session:logOut', @_actionLogOut


    # ------------------------------------------------ Display command handlers
    _showLogin: ->
      loginDialog = new LoginDialog
        model: @options.app.user
        app: @options.app

    _showProfile: ->
      profileDialog = new ProfileDialog
        model: @options.app.user


    # ------------------------------------------------ Action command handlers
    _actionLogOut: ->
      console.log "#{_me}._actionLogOut()"
      @options.app.session.logOut()


  Me


