
define [
  'underscore'
  'Backbone'
  'user/login_dialog'
  'user/profile_dialog'
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
      console.log "#{_me}._showLogin()"
      @loginDialog = new LoginDialog
        app: @options.app
        session: @options.app.session
      @loginDialog.show()

    _showProfile: ->
      console.log "#{_me}._showProfile()"
      @profileDialog = new ProfileDialog
        user: @options.app.session.user
      @profileDialog.show()


    # ------------------------------------------------ Action command handlers
    _actionLogOut: ->
      console.log "#{_me}._actionLogOut()"
      @options.app.session.logout()




  Me


