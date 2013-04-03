define [
  'jquery',
  'Backbone',
  'Handlebars',
  "text!./login_dialog.hbs"], ($, Backbone, Handlebars, tempfile) ->
  LoginDialog = Backbone.View.extend  
    initialize: (options) ->
      @silentLogin = options.silentLogin
      @nextRoute = options.nextRoute
      @session = @model

    render: ->
      template = Handlebars.compile(tempfile)
      if @silentLogin?
        className = "loginView silent"
      else
        className = "loginView"

      $(@el).html(template({authUrl: @session.authUrl, className: className}))
      this

    close: ->
      # $("#logindialog").html("")


  LoginDialog