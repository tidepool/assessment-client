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
      "click #login": "login",
      "click #logout": "logout"
      "click #profile": "showProfile"

    initialize: (options) ->
      throw new Error('arguments[0].session is required') unless options.session
      @_usingNav = true # default
      @session = options.session
      @listenTo(@session, 'session:login_success', @render)
      @listenTo(@session, 'session:logout_success', @render)
      @tmpl = Handlebars.compile(tmpl)

    render: () ->
      console.log "#{_me}.render()"
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