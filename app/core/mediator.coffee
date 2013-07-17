
define [
  'underscore'
  'backbone'
  'composite_views/perch'
  'forms/user/login'
  'forms/user/profile'
  'preferences/personalization'
  'connections/index'
],
(
  _
  Backbone
  perch
  UserLogin
  UserProfile
  PersonalizationView
  ConnectionsView
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
      @listenTo @options.app, 'action:showPersonalizations', @_showPersonalizations
      @listenTo @options.app, 'action:showConnections', @_showConnections


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
        content: new UserLogin
          model: @options.app.user
          app: @options.app
          register: true

    _showProfile: ->
      perch.show
        title: 'Profile'
        btn1Text: null
        content: new UserProfile
          model: @options.app.user

    _showPersonalizations: ->
      perch.show
        title: '<i class="icon-cog"></i> Your Preferences'
        className: 'brandHappy'
        btn1Text: null
        huge: true
        content: new PersonalizationView( app: @options.app )

    _showConnections: ->
      perch.show
        title: 'Connections'
        btn1Text: 'Ok'
        content: new ConnectionsView( app: @options.app )

    # ------------------------------------------------ Action command handlers
    _actionLogOut: ->
      @options.app.analytics.track 'session', 'Pressed Log Out'
      @options.app.router.navigate 'home', trigger:true
      @options.app.session.logOut()


  Me


