define [
  'jquery'
  'Backbone'
  'Handlebars'
  "text!./header.hbs"
],
(
  $
  Backbone
  Handlebars
  tmpl
) ->

  _me = 'ui_widgets/header'

  HeaderView = Backbone.View.extend
    tagName: 'header'
    events:
      "click #ShowModalLogin": "clickedLogIn"
      "click #logout": "clickedLogOut"
      "click #ShowModalProfile": "clickedProfile"

    initialize: (options) ->
      throw new Error('arguments[0].session and .app are required') unless options.session && options.app
      @_usingNav = true # default
      @session = options.session
      @app = options.app
      @app.on 'session:login_success', @render, @
      @app.on 'session:logout_success', @render, @
      @tmpl = Handlebars.compile(tmpl)

    render: ->
      @app.cfg.debug && console.log "#{_me}.render()"
      loggedIn = @session.loggedIn()
      isRegisteredUser = true
      if @session.user?
        if @session.user.get('guest') is true
          userName = 'Guest'
          isRegisteredUser = false
        else
          userName = @session.user.get('email')
          if userName is undefined || userName is ""
            userName = @session.user.get('name')
      else
        userName = "Guest"
      @$el.html @tmpl
        userName: userName
        loggedIn: loggedIn
        showNav: @_usingNav
        isRegisteredUser: isRegisteredUser
      @

    hideNav: ->
      @_usingNav = false
      @
    showNav: ->
      @_usingNav = true
      @
    clickedLogIn: ->
      @app.trigger 'modal:login'
    clickedLogOut: ->
      @app.trigger 'session:logOut'
    clickedProfile: (e) ->
      @app.trigger 'modal:profile'
  
  HeaderView