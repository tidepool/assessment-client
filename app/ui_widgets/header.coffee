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
      "click #ActionShowLogin": "_clickedLogIn"
      "click #ActionLogOut": "_clickedLogOut"
      "click #ActionShowProfile": "_clickedProfile"

    initialize: ->
      throw new Error('Need options.app') unless @options.app
      console.log "#{_me}.initialize()"
      @_usingNav = true # default
#      @options.app.on 'session:login_success', @render, @
#      @options.app.on 'session:logout_success', @render, @
      @listenTo @options.app, 'session:login_success', @render
      @listenTo @options.app, 'session:logout_success', @render
      @tmpl = Handlebars.compile tmpl

    render: ->
      console.log "#{_me}.render()"
      loggedIn = @options.app.session.loggedIn()
      isRegisteredUser = true
      if @options.app.session.user?
        imageUrl = @options.app.session.user.get('image')
        if @options.app.session.user.get('guest') is true
          userName = 'Guest'
          isRegisteredUser = false
        else
          userName = @options.app.session.user.get('email')
          if userName is undefined || userName is ""
            userName = @options.app.session.user.get('name')
      else
        userName = "Guest"
      @$el.html @tmpl
        userName: userName
        loggedIn: loggedIn
        showNav: @_usingNav
        showUser: true
        imageUrl: imageUrl
        isRegisteredUser: isRegisteredUser
      @

    hideNav: ->
      @_usingNav = false
      @
    showNav: ->
      @_usingNav = true
      @
    _clickedLogIn: ->
      @options.app.trigger 'session:showLogin'
    _clickedLogOut: ->
      @options.app.trigger 'session:logOut'
    _clickedProfile: (e) ->
      @options.app.trigger 'session:showProfile'
  
  HeaderView

