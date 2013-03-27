define [
  'jquery',
  'Backbone',
  "hbs!./header_view"], ($, Backbone, template) ->
  HeaderView = Backbone.View.extend
    events:
      "click #login": "login",
      "click #logout": "logout"

    initialize: (options) ->
      @eventDispatcher = options.eventDispatcher

    render: ->
      loggedIn = @model.loggedIn()
      $(@el).html(template({ userName: @model.get('userName'), loggedIn: loggedIn } ))
      this

    login: ->
      @eventDispatcher.trigger("loginDialogStart")
      event.preventDefault()

    logout: ->
      @eventDispatcher.trigger("logoutRequest")
      event.preventDefault()
  HeaderView