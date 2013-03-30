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

    render: ->
      loggedIn = @model.loggedIn()
      template = Handlebars.compile(tempfile)
      $(@el).html(template({ userName: @model.get('userName'), loggedIn: loggedIn } ))
      this

    login: ->
      event.preventDefault()
      @trigger('login')

    logout: ->
      event.preventDefault()
  
  HeaderView