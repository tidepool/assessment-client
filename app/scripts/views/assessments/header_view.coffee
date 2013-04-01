define [
  'jquery',
  'Backbone',
  'Handlebars',
  'assessments/login_dialog',
  'routers/main_router',
  "text!./header_view.hbs"], ($, Backbone, Handlebars, LoginDialog, MainRouter, tempfile) ->
  HeaderView = Backbone.View.extend
    events:
      "click #login": "login",
      "click #logout": "logout"

    initialize: (options) ->
      @user = @model.user
      @listenTo(@model, 'session:logged_in', @loggedIn)

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

    login: ->
      event.preventDefault()
      @trigger('login')

    logout: ->
      event.preventDefault()
  
  HeaderView