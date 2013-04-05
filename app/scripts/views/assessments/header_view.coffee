define [
  'jquery',
  'Backbone',
  'Handlebars',
  'assessments/login_dialog',
  'routers/main_router',
  "text!./header_view.hbs",
  "bootstrap"], ($, Backbone, Handlebars, LoginDialog, MainRouter, tempfile) ->
  HeaderView = Backbone.View.extend
    events:
      "click #login": "login",
      "click #logout": "logout"

    initialize: (options) ->
      @user = @model.user
      @listenTo(@model, 'session:logged_in', @loggedIn)
      @listenTo(@model, 'session:logged_out', @loggedOut)

    render: ->
      loggedIn = @model.loggedIn()
      template = Handlebars.compile(tempfile)
      if @user?
        if @user.get('guest') is true
          userName = 'Guest'
        else
          userName = @user.get('email')
      else
        userName = "Logging In..."

      $(@el).html(template({ userName: userName, loggedIn: loggedIn } ))
      this

    loggedIn: ->
      @user = @model.user
      @render()

    loggedOut: ->
      @user = null
      @render()

    login: ->
      event.preventDefault()
      @trigger('header_view:login')

    logout: ->
      event.preventDefault()
      @trigger('header_view:logout')
  
  HeaderView