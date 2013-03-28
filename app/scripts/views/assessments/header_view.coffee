define [
  'jquery',
  'Backbone',
  'Handlebars',
  '../views/assessments/login_dialog',
  "text!./header_view.hbs"], ($, Backbone, Handlebars, LoginDialog, tempfile) ->
  HeaderView = Backbone.View.extend
    events:
      "click #login": "login",
      "click #logout": "logout"

    initialize: (options) ->
      @eventDispatcher = options.eventDispatcher

    render: ->
      loggedIn = @model.loggedIn()
      template = Handlebars.compile(tempfile)
      $(@el).html(template({ userName: @model.get('userName'), loggedIn: loggedIn } ))
      this

    login: ->
      event.preventDefault()
      loginDialog = new LoginDialog({model: @model, nextRoute: "", eventDispatcher: @eventDispatcher})    
      loginDialog.display()

    logout: ->
      @eventDispatcher.trigger("logoutRequest")
      event.preventDefault()
  HeaderView