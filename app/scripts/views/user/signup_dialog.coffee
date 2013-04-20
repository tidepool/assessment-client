define [
  'jquery',
  'underscore',
  'Backbone',
  'Handlebars',
  'models/user',
  "text!./signup_dialog.hbs",
  'controllers/session_controller'], ($, _, Backbone, Handlebars, User, tempfile) ->
  SignupDialog = Backbone.View.extend  
    events:
      "submit #signupForm": "signup"

    initialize: (options) ->
      @session = options.session

    render: ->
      template = Handlebars.compile(tempfile)
      $(@el).html(template())
      this

    signup: (e) ->
      e.preventDefault()
      email = $("#email").val()
      password = $("#password").val()
      passwordConfirm = $("#password_confirm").val()

      @session.signup(email, password, passwordConfirm)
      .done (message) =>
        $(".alert-success").css('visibility', 'visible')
        $("form #message").html(message)       
      .fail (message) ->
        $(".alert-error").css('visibility', 'visible')
        $("form #message").html(message)

  SignupDialog