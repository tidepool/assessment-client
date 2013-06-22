
define [
  'underscore'
  'backbone'
  'composite_views/perch'
  'forms/user/login'
  'forms/user/profile'
],
(
  _
  Backbone
  perch
  UserLogin
  UserProfile
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
      perch.show
        btn1Text: null
        supressTracking: true
        content: new UserLogin
          model: @options.app.user
          app: @options.app

    _showRegister: ->
      perch.show
        btn1Text: null
        supressTracking: true
        register: true
        content: new UserLogin
          model: @options.app.user
          app: @options.app

    _showProfile: ->
      perch.show
        title: 'Profile'
        btn1Text: null
        content: new UserProfile
          model: @options.app.user


    # ------------------------------------------------ Action command handlers
    _actionLogOut: ->
      @options.app.analytics.track 'session', 'Pressed Log Out'
      @options.app.session.logOut()


  Me


