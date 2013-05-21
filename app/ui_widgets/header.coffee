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

    initialize: () ->
      throw new Error('Need options.app and options.session') unless @options.app? and @options.session?
      @_usingNav = true # default
      @options.app.on 'session:login_success', @render, @
      @options.app.on 'session:logout_success', @render, @
      @tmpl = Handlebars.compile(tmpl)

    render: ->
      @options.app.cfg.debug && console.log "#{_me}.render()"
      loggedIn = @options.session.loggedIn()
      isRegisteredUser = true
      if @options.session.user?
        imageUrl = @options.session.user.get('image')
        if @options.session.user.get('guest') is true
          userName = 'Guest'
          isRegisteredUser = false
        else
          userName = @options.session.user.get('email')
          if userName is undefined || userName is ""
            userName = @options.session.user.get('name')
      else
        userName = "Guest"
      @$el.html @tmpl
        userName: userName
        loggedIn: loggedIn
        showNav: @_usingNav
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